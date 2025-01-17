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

#include <stdio.h>
#include <stdlib.h>
#include "fmi_dll_1_0_cs.h"
#include "fmi_dll_1_0_me.h"
#include "fmi_dll_common.h"
#include "jm_types.h"
#include "fmi_zip_unzip.h"
#include <fmi_xml_model_description.h>
#include "fmi_import_util.h"


#define PRINT_MY_DEBUG printf("Line: %d \t File: %s \n",__LINE__, __FILE__)

void mylogger(fmiComponent c, fmiString instanceName, fmiStatus status, fmiString category, fmiString message, ...)
{
	char msg[2024];
	va_list argp;	
	va_start(argp, message);
	vsprintf(msg, message, argp);
	if (!instanceName) instanceName = "?";
	if (!category) category = "?";
	printf("fmiStatus = %d;  %s (%s): %s\n", status, instanceName, category, msg);
}

void do_pause()
{
#ifdef _MSC_VER
	system("PAUSE");
#elif
#endif
}

int main(int argc, char *argv[])
{
	fmiCallbackFunctions callBackFunctions;
	fmi_dll_t* fmu;	
	const char* FMUPath = "C:\\P510-JModelica\\FMIToolbox\\trunk\\src\\wrapperfolder\\Furuta.fmu";
	const char* tmpPath = "C:\\Documents and Settings\\p418_baa\\Desktop\\XMLtest\\temporaryfolder";
	const char* dllPath;
	const char* modelIdentifier;
	const char* modelName;
	const char* model_description_path;
	char* instanceName;
	char*  GUID;
	fmi_dll_standard_enu_t standard = 	FMI_ME1; /* or FMI_CS1 */	



	fmiBoolean loggingOn = fmiTrue;
	fmi_xml_model_description_t* md;
	jm_status_enu_t status;

	PRINT_MY_DEBUG;

	if (jm_status_error == fmi_zip_unzip(FMUPath, tmpPath)) {
		printf("Failed to unzip the FMU file\n");
		abort();
	}

	callBackFunctions.logger = mylogger;
	callBackFunctions.allocateMemory = calloc;
	callBackFunctions.freeMemory = free;

	model_description_path = fmi_import_get_model_description_path(tmpPath, callBackFunctions);

	md = fmi_xml_allocate_model_description(0);

    if(!md) abort();

    if(fmi_xml_parse(md, model_description_path)) {
        printf("Error parsing XML file %s:%s\n", FMUPath, fmi_xml_get_last_error(md));
        fmi_xml_free_model_description(md);
        abort();
	}

	
    printf("Model name: %s\n", fmi_xml_get_model_name(md));
    printf("Model identifier: %s\n", fmi_xml_get_model_identifier(md));
    printf("Model GUID: %s\n", fmi_xml_get_GUID(md));

	modelIdentifier = fmi_xml_get_model_identifier(md);
	modelName = fmi_xml_get_model_name(md);
	GUID = fmi_xml_get_GUID(md);

	modelIdentifier = fmi_xml_get_model_identifier(md);

	

	dllPath = fmi_import_get_dll_path(tmpPath, modelIdentifier, callBackFunctions);

	fmu = fmi_dll_common_create_dllfmu(dllPath, modelIdentifier, callBackFunctions, standard);
	if (fmu == NULL) {
		printf("An error occured while fmi_dll_common_create_dllfmu was called, an error message should been printed.\n");
		do_pause();
		return 0;
	}

	status = fmi_dll_common_load_dll(fmu);
	if (status == jm_status_error) {
		printf("Error in fmi_dll_common_load_dll: %s\n", fmi_dll_common_get_last_error(fmu));
		do_pause();
		return 0;
	}

	status = fmi_dll_common_load_fcn(fmu);
	if (status == jm_status_error) {
		printf("Error in fmi_dll_common_load_fcn: %s\n", fmi_dll_common_get_last_error(fmu));
		do_pause();
		return 0;
	}

	printf("fmi_dll_1_0_me_get_version:              %s\n", fmi_dll_1_0_me_get_version(fmu));

	fmi_dll_common_free_dll(fmu);
	fmi_dll_common_destroy_dllfmu(fmu);

	fmi_xml_free_model_description(md);

	printf("Everything seems to be OK since you got this far=)!\n");

	do_pause();
}


