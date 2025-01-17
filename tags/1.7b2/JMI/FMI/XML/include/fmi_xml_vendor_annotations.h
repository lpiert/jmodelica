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

/** \file fmi_xml_vendor_annotations.h
*  \brief Public interface to the FMI XML C-library. Handling of vendor annotations.
*/

#ifndef FMI_XML_VENDORANNOTATIONS_H_
#define FMI_XML_VENDORANNOTATIONS_H_

#include "fmi_xml_model_description.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Basic support for vendor annotations. */

fmi_xml_vendor_list_t* fmi_xml_get_vendor_list(fmi_xml_model_description_t* md);

unsigned int  fmi_xml_get_number_of_vendors(fmi_xml_vendor_list_t*);

fmi_xml_vendor_t* fmi_xml_get_vendor(fmi_xml_vendor_list_t*, unsigned int  index);

/* fmi_xml_vendor* fmiAddVendor(fmiModelDescription* md, char* name);

void* fmiRemoveVendor(fmi_xml_vendor*); */

const char* fmi_xml_get_vendor_name(fmi_xml_vendor_t*);

unsigned int  fmi_xml_get_number_of_vendor_annotations(fmi_xml_vendor_t*);

/*Note: Annotations can be used in other places but have common interface name-value */
fmi_xml_annotation_t* fmi_xml_get_vendor_annotation(fmi_xml_vendor_t*, unsigned int  index);

const char* fmi_xml_get_annotation_name(fmi_xml_annotation_t*);

const char* fmi_xml_get_annotation_value(fmi_xml_annotation_t*);

/* fmi_xml_annotation* fmi_xml_add_vendor_annotation(fmi_xml_vendor*, const char* name, const char* value);

fmi_xml_annotation* fmi_xml_remove_vendor_annotation(fmi_xml_vendor*, const char* name, const char* value);
*/

#ifdef __cplusplus
}
#endif
#endif
