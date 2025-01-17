/*
    Copyright (C) 2012 Modelon AB

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, version 3 of the License.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include <string.h>
#include <stdio.h>

#include "fmi_xml_model_description_impl.h"
#include "fmi_xml_parser.h"


#define ATTR_STR(attr) #attr
const char *fmi_xmlAttrNames[] = {
    FMI_XML_ATTRLIST(ATTR_STR)
};


#define EXPAND_ELM_NAME(elm) { #elm, fmi_xml_handle_##elm},

fmi_xml_element_handle_map_t fmi_element_handle_map[fmi_xml_elm_number] = {
    FMI_XML_ELMLIST(EXPAND_ELM_NAME)
};

void fmi_parse_free_context(fmi_xml_parser_context_t *context) {
    if(!context) return;
    if(context->modelDescription)
        fmi_xml_clear_model_description(context->modelDescription);
    if(context->parser) {
        XML_ParserFree(context->parser);
        context->parser = 0;
    }
    fmi_xml_free_parse_buffer(context);
    if(context->attrMap) {
        jm_vector_free(jm_named_ptr)(context->attrMap);
        context->attrMap = 0;
    }
    if(context->elmMap) {
        jm_vector_free(fmi_xml_element_handle_map_t)(context->elmMap);
        context->elmMap = 0;
    }
    if(context->attrBuffer) {
        jm_vector_free(jm_string)(context->attrBuffer);
        context->attrBuffer = 0;
    }
    jm_stack_free_data(fmi_xml_element_handle_ft)(& context->elmHandleStack );
    jm_vector_free_data(char)( &context->elmData );

    jm_vector_free_data(jm_voidp)(&context->directDependencyBuf);
    jm_vector_foreach(jm_string)(&context->directDependencyStringsStore, (void(*)(jm_string))context->callbacks->free);
    jm_vector_free_data(jm_string)(&context->directDependencyStringsStore);

    context->callbacks->free(context);
}

void fmi_xml_parse_error(fmi_xml_parser_context_t *context, const char* fmt, ...) {
    va_list args;
    const char * module = "XMLparser";
    va_start (args, fmt);
    fmi_xml_report_error_v(context->modelDescription, module, fmt, args);
    va_end (args);
    XML_StopParser(context->parser,0);
}

void fmi_xml_parse_warning(fmi_xml_parser_context_t *context, const char* fmt, ...) {
    va_list args;
    const char * module = "XMLparser";
    va_start (args, fmt);
    fmi_xml_report_warning_v(context->modelDescription, module, fmt, args);
    va_end (args);
}

int fmi_xml_is_attr_defined(fmi_xml_parser_context_t *context, fmi_xml_attr_enu_t attrID) {
    return ( jm_vector_get_item(jm_string)(context->attrBuffer, attrID) != 0);
}

int fmi_get_attr_str(fmi_xml_parser_context_t *context, fmi_xml_elm_enu_t elmID, fmi_xml_attr_enu_t attrID, int required,const char** valp) {

    jm_string elmName, attrName, value;

    elmName = fmi_element_handle_map[elmID].elementName;
    attrName = fmi_xmlAttrNames[attrID];
    value = jm_vector_get_item(jm_string)(context->attrBuffer, attrID);
    *valp =  value;
    jm_vector_set_item(jm_string)(context->attrBuffer, attrID, 0);
    if(!(*valp)) {
        if (required) {
            fmi_xml_parse_error(context, "Parsing XML element '%s': required attribute '%s' not found", elmName, attrName);
            return -1;
        }
        else
            return 0;
    }
    return 0;
}

int fmi_xml_set_attr_string(fmi_xml_parser_context_t *context, fmi_xml_elm_enu_t elmID, fmi_xml_attr_enu_t attrID, int required, jm_vector(char)* field) {
    int ret;
    jm_string elmName, attrName, val;
    size_t len;
    ret = fmi_get_attr_str(context, elmID, attrID,required,&val);
    if(ret) return ret;
    if((!val || !val[0]) && !required) {
        jm_vector_resize(char)(field, 1);
        jm_vector_set_item(char)(field, 0, 0);
        jm_vector_resize(char)(field, 0);
        return 0;
    }
    elmName = fmi_element_handle_map[elmID].elementName;
    attrName = fmi_xmlAttrNames[attrID];

    len = strlen(val) + 1;
    if(jm_vector_resize(char)(field, len) < len) {
        fmi_xml_parse_error(context, "XML element '%s': could not allocate memory for setting '%s'='%s'", elmName, attrName, val);
        return -1;
    }
    /* copy terminating 0 as well but set vector size to be actual string length */
    memcpy(jm_vector_get_itemp(char)(field,0), val, len);
    jm_vector_resize(char)(field, len - 1);
    return 0;
}

int fmi_xml_set_attr_uint(fmi_xml_parser_context_t *context, fmi_xml_elm_enu_t elmID, fmi_xml_attr_enu_t attrID, int required, unsigned int* field, unsigned int defaultVal) {
    int ret;
    jm_string elmName, attrName, strVal;    

    ret = fmi_get_attr_str(context, elmID, attrID,required,&strVal);
    if(ret) return ret;
    if(!strVal && !required) {
        *field = defaultVal;
        return 0;
    }

    elmName = fmi_element_handle_map[elmID].elementName;
    attrName = fmi_xmlAttrNames[attrID];

    if(sscanf(strVal, "%u", field) != 1) {
        fmi_xml_parse_error(context, "XML element '%s': could not parse value for attribute '%s'='%s'", elmName, attrName, strVal);
        return -1;
    }
    return 0;
}


int fmi_xml_set_attr_enum(fmi_xml_parser_context_t *context, fmi_xml_elm_enu_t elmID, fmi_xml_attr_enu_t attrID, int required, unsigned int* field, unsigned int defaultVal, jm_name_ID_map_t* nameMap) {
    int ret, i;
    jm_string elmName, attrName, strVal;

    ret = fmi_get_attr_str(context, elmID, attrID,required,&strVal);
    if(ret) return ret;
    if(!strVal && !required) {
        *field = defaultVal;
        return 0;
    }

    elmName = fmi_element_handle_map[elmID].elementName;
    attrName = fmi_xmlAttrNames[attrID];

    i = 0;
    while(nameMap[i].name && strcmp(nameMap[i].name, strVal)) i++;
    if(!nameMap[i].name) {
        fmi_xml_parse_error(context, "XML element '%s': could not parse value for attribute '%s'='%s'", elmName, attrName, strVal);
        return -1;
    }
    *field = nameMap[i].ID;
    return 0;
}

int fmi_xml_set_attr_boolean(fmi_xml_parser_context_t *context, fmi_xml_elm_enu_t elmID, fmi_xml_attr_enu_t attrID, int required, int* field, int defaultVal) {
    jm_name_ID_map_t fmi_boolean_i_dMap[] = {{"true", 1},{"false", 0}, {"1", 1},{"0", 0}, {0,0}};
    return fmi_xml_set_attr_enum(context,elmID, attrID,required, (unsigned*)field, (unsigned)defaultVal, fmi_boolean_i_dMap);
}

int fmi_xml_set_attr_int(fmi_xml_parser_context_t *context, fmi_xml_elm_enu_t elmID, fmi_xml_attr_enu_t attrID, int required, int* field, int defaultVal) {
    int ret;
    jm_string elmName, attrName, strVal;

    ret = fmi_get_attr_str(context, elmID, attrID,required,&strVal);
    if(ret) return ret;
    if(!strVal && !required) {
        *field = defaultVal;
        return 0;
    }

    elmName = fmi_element_handle_map[elmID].elementName;
    attrName = fmi_xmlAttrNames[attrID];

    if(sscanf(strVal, "%d", field) != 1) {
        fmi_xml_parse_error(context, "XML element '%s': could not parse value for attribute '%s'='%s'", elmName, attrName, strVal);
        return -1;
    }
    return 0;
}

int fmi_xml_set_attr_double(fmi_xml_parser_context_t *context, fmi_xml_elm_enu_t elmID, fmi_xml_attr_enu_t attrID, int required, double* field, double defaultVal) {

    int ret;
    jm_string elmName, attrName, strVal;


    ret = fmi_get_attr_str(context, elmID, attrID,required,&strVal);
    if(ret) return ret;
    if(!strVal && !required) {
        *field = defaultVal;
        return 0;
    }

    elmName = fmi_element_handle_map[elmID].elementName;
    attrName = fmi_xmlAttrNames[attrID];

    if(sscanf(strVal, "%lf", field) != 1) {
        fmi_xml_parse_error(context, "XML element '%s': could not parse value for attribute '%s'='%s'", elmName, attrName, strVal);
        return -1;
    }
    return 0;
}

int fmi_xml_alloc_parse_buffer(fmi_xml_parser_context_t *context, size_t items) {

    jm_vector(jm_voidp)* parseBuffer = &context->parseBuffer;

    if(jm_vector_init(jm_voidp)(parseBuffer,items,context->callbacks) < items) {
        fmi_xml_parse_error(context, "Could not allocate buffer for parsing XML");
        return -1;
    }
    jm_vector_zero(jm_voidp)(parseBuffer);
    return 0;
}

void fmi_xml_free_parse_buffer(fmi_xml_parser_context_t *context) {
    size_t i;
    jm_vector(jm_voidp)* parseBuffer = &context->parseBuffer;

    for(i=0; i < jm_vector_get_size(jm_voidp)(parseBuffer); i++) {
        jm_vector(char) * item = jm_vector_get_item(jm_voidp)(parseBuffer,i);
        if(item) jm_vector_free(char)(item);
    }
    jm_vector_free_data(jm_voidp)(parseBuffer);
}

jm_vector(char) * fmi_xml_reserve_parse_buffer(fmi_xml_parser_context_t *context, size_t index, size_t size) {

    jm_vector(jm_voidp)* parseBuffer = &context->parseBuffer;
    jm_vector(char) * item = jm_vector_get_item(jm_voidp)(parseBuffer,index);
    if(!item) {
        item = jm_vector_alloc(char)(size,size,context->callbacks);
        jm_vector_set_item(jm_voidp)(parseBuffer,index,item);
        if(!item) {
            fmi_xml_parse_error(context, "Could not allocate a buffer for parsing XML");
            return 0;
        }
    }
    else {
        if(jm_vector_resize(char)(item, size) < size ) {
            fmi_xml_parse_error(context, "Could not allocate a buffer for parsing XML");
            return 0;
        }
    }
    return item;
}

jm_vector(char) * fmi_xml_get_parse_buffer(fmi_xml_parser_context_t *context, size_t index) {
    jm_vector(jm_voidp)* parseBuffer = &context->parseBuffer;
    return jm_vector_get_item(jm_voidp)(parseBuffer,index);
}



int fmi_create_attr_map(fmi_xml_parser_context_t* context) {
    int i;
    context->attrBuffer = jm_vector_alloc(jm_string)(fmi_xml_attr_number, fmi_xml_attr_number, context->callbacks);
    if(!context->attrBuffer) return -1;
    context->attrMap = jm_vector_alloc(jm_named_ptr)(fmi_xml_attr_number, fmi_xml_attr_number, context->callbacks);
    if(!context->attrMap) return -1;
    for(i = 0; i < fmi_xml_attr_number; i++) {
        jm_named_ptr map;
        jm_vector_set_item(jm_string)(context->attrBuffer, i, 0);
        map.name = fmi_xmlAttrNames[i];
        map.ptr = (void*)(jm_vector_get_itemp(jm_string)(context->attrBuffer, i));
        jm_vector_set_item(jm_named_ptr)(context->attrMap, i, map);
    }
    jm_vector_qsort(jm_named_ptr)(context->attrMap, jm_compare_named);
    return 0;
}

int fmi_create_elm_map(fmi_xml_parser_context_t* context) {
    size_t i;
    context->elmMap = jm_vector_alloc(fmi_xml_element_handle_map_t)(fmi_xml_elm_number, fmi_xml_elm_number, context->callbacks);
    if(!context->elmMap) return -1;
    for(i = 0; i < fmi_xml_elm_number; i++) {
        fmi_xml_element_handle_map_t item = fmi_element_handle_map[i];
        jm_vector_set_item(fmi_xml_element_handle_map_t)(context->elmMap, i, item);
    }
    jm_vector_qsort(fmi_xml_element_handle_map_t)(context->elmMap, fmi_xml_compare_elmName);
    return 0;
}

void XMLCALL fmi_parse_element_start(void *c, const char *elm, const char **attr) {
    jm_named_ptr key;
    fmi_xml_element_handle_map_t keyEl;
    fmi_xml_element_handle_map_t* currentElMap;
    jm_named_ptr* currentMap;
    fmi_xml_element_handle_ft currentHandle;
    int i;
    fmi_xml_parser_context_t *context = c;
    keyEl.elementName = elm;

    /* find the element handle by name */
    currentElMap = jm_vector_bsearch(fmi_xml_element_handle_map_t)(context->elmMap, &keyEl, fmi_xml_compare_elmName);
    if(!currentElMap) {
        /* not found error*/
        fmi_xml_parse_error(context, "Unknown element '%s' start in XML", elm);
        return;
    }
    currentHandle = currentElMap->elementHandle;

    /* process the attributes  */
    i = 0;
    while(attr[i]) {
        key.name = attr[i];
        /* find attribute by name  */
        currentMap = jm_vector_bsearch(jm_named_ptr)(context->attrMap, &key, jm_compare_named);
        if(!currentMap) {
            /* not found error*/
            fmi_xml_parse_error(context, "Unknown attribute '%s' in XML", attr[i]);
            return;
        }
        {
            /* save attr value (still as string) for further handling  */
            const char** mapItem = currentMap->ptr;
            *mapItem = attr[i+1];
        }
        i += 2;
    }

    /* handle the element */
    if( currentHandle(context, 0) ) {
        return;
    }
    /* check that the element handle had process all the attributes */
    for(i = 0; i < fmi_xml_attr_number; i++) {
        if(jm_vector_get_item(jm_string)(context->attrBuffer, i)) {
            if(!context->skipOneVariableFlag)
                fmi_xml_parse_warning(context, "Attribute '%s' not processed by element '%s' handle", fmi_xmlAttrNames[i], elm);
            jm_vector_set_item(jm_string)(context->attrBuffer, i,0);
        }
    }
    if(context -> currentElmHandle) { /* with nested elements: put the parent on the stack*/
        jm_stack_push(fmi_xml_element_handle_ft)(&context->elmHandleStack, context -> currentElmHandle);
    }
    context -> currentElmHandle = currentHandle;
}

void XMLCALL fmi_parse_element_end(void* c, const char *elm) {

    fmi_xml_element_handle_map_t keyEl;
    fmi_xml_element_handle_map_t* currentElMap;
    fmi_xml_element_handle_ft currentHandle;
    fmi_xml_parser_context_t *context = c;

    keyEl.elementName = elm;
    currentElMap = jm_vector_bsearch(fmi_xml_element_handle_map_t)(context->elmMap, &keyEl, fmi_xml_compare_elmName);
    if(!currentElMap) {
        /* not found error*/
        fmi_xml_parse_error(context, "Unknown element end in XML (element: %s)", elm);
        return;
    }
    currentHandle = currentElMap->elementHandle;

    if(currentHandle != context -> currentElmHandle) {
        /* missmatch error*/
        fmi_xml_parse_error(context, "Element end '%s' does not match element start in XML", elm);
        return;
    }

    jm_vector_push_back(char)(&context->elmData, 0);

    if( currentHandle(context, jm_vector_get_itemp(char)(&context->elmData, 0) )) {
        return;
    }
    jm_vector_resize(char)(&context->elmData, 0);

    /* record the last handle and pop the stack */
    context->lastElmHandle = currentHandle;

    if(jm_stack_is_empty(fmi_xml_element_handle_ft)(&context->elmHandleStack)) {
        context -> currentElmHandle = 0;
    }
    else {
        context -> currentElmHandle = jm_stack_pop(fmi_xml_element_handle_ft)(&context->elmHandleStack);
    }
}

/*
// Called to handle element data, e.g. "xy" in <Name>xy</Name>
// Can be called many times, e.g. with "x" and then with "y" in the example above.
// Feature in expat:
// For some reason, if the element data is the empty string (Eg. <a></a>)
// instead of an empty string with len == 0 we get "\n". The workaround is
// to replace this with the empty string whenever we encounter "\n".
*/
void XMLCALL fmi_parse_element_data(void* c, const XML_Char *s, int len) {
        fmi_xml_parser_context_t *context = c;
        int i;
        jm_vector_reserve(char)(&context->elmData, len + jm_vector_get_size(char)(&context->elmData) + 1);
        for(i = 0; i< len;i++) {
            char ch = s[i];
            if(ch != '\n') {
                jm_vector_push_back(char)(&context->elmData, ch);
            }
        }
}

int fmi_xml_parse(fmi_xml_model_description_t* md, const char* filename) {
    XML_Memory_Handling_Suite memsuite;
    fmi_xml_parser_context_t* context;
    XML_Parser parser = NULL;
    FILE* file;

    context = md->callbacks->calloc(1, sizeof(fmi_xml_parser_context_t));
    if(!context) {
        md->callbacks->logger(md, 0, -1, "ERROR", "Could not allocate memory for XML parser context");
    }
    context->callbacks = md->callbacks;
    context->modelDescription = md;
    if(fmi_xml_alloc_parse_buffer(context, 16)) return -1;
    if(fmi_create_attr_map(context) || fmi_create_elm_map(context)) {
        fmi_xml_parse_error(context, "Error in parsing initialization");
        return -1;
    }
    context->lastBaseUnit = 0;
    jm_vector_init(jm_voidp)(&context->directDependencyBuf, 0, context->callbacks);
    jm_vector_init(jm_string)(&context->directDependencyStringsStore, 0, context->callbacks);
    context->skipOneVariableFlag = 0;
    jm_stack_init(fmi_xml_element_handle_ft)(&context->elmHandleStack,  context->callbacks);
    jm_vector_init(char)(&context->elmData, 0, context->callbacks);
    context->lastElmHandle = 0;
    context->currentElmHandle = 0;

    memsuite.malloc_fcn = context->callbacks->malloc;
    memsuite.realloc_fcn = context->callbacks->realloc;
    memsuite.free_fcn = context->callbacks->free;
    context -> parser = parser = XML_ParserCreate_MM(0, &memsuite, 0);

    if(! parser) {
        fmi_xml_parse_error(context, "Could not initialize XML parsing library.");
        return -1;
    }

    XML_SetUserData( parser, context);

    XML_SetElementHandler(parser, fmi_parse_element_start, fmi_parse_element_end);

    XML_SetCharacterDataHandler(parser, fmi_parse_element_data);

    file = fopen(filename, "rb");
    if (file == NULL) {
        fmi_xml_parse_error(context, "Cannot open file '%s' for parsing", filename);
        return -1;
    }

    while (!feof(file)) {
        char * text = jm_vector_get_itemp(char)(fmi_xml_reserve_parse_buffer(context,0,XML_BLOCK_SIZE),0);
        int n = fread(text, sizeof(char), XML_BLOCK_SIZE, file);
        if(ferror(file)) {
            fmi_xml_parse_error(context, "Error reading from file %s", filename);
            fclose(file);
            return -1;
        }
        if (!XML_Parse(parser, text, n, feof(file))) {
             fmi_xml_parse_error(context, "Parse error in file %s at line %d:\n%s",
                          filename,
                         (int)XML_GetCurrentLineNumber(parser),
                         XML_ErrorString(XML_GetErrorCode(parser)));
             fclose(file);
             return -1; /* failure */
        }        
    }
    fclose(file);
    /* done later XML_ParserFree(parser);*/
    if(!jm_stack_is_empty(fmi_xml_element_handle_ft)(&context->elmHandleStack)) {
        fmi_xml_parse_error(context, "Unexpected end of file (not all elements ended) when parsing %s", filename);
        return -1;
    }

    md->status = fmi_xml_model_description_enu_ok;
    context->modelDescription = 0;
    fmi_parse_free_context(context);

    return 0;
}

#define JM_TEMPLATE_INSTANCE_TYPE fmi_xml_element_handle_map_t
#include "jm_vector_template.h"

#undef JM_TEMPLATE_INSTANCE_TYPE
#define JM_TEMPLATE_INSTANCE_TYPE fmi_xml_element_handle_ft
#include "jm_vector_template.h"
