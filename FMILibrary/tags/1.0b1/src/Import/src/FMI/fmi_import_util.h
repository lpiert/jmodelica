/*
    Copyright (C) 2012 Modelon AB

    This program is free software: you can redistribute it and/or modify
    it under the terms of the BSD style license.

    the Free Software Foundation, version 3 of the License.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    FMILIB_License.txt file for more details.

    You should have received a copy of the FMILIB_License.txt file
    along with this program. If not, contact Modelon AB <http://www.modelon.com>.
*/

#ifndef FMI1_IMPORT_UTIL_H_
#define FMI1_IMPORT_UTIL_H_

#include <JM/jm_callbacks.h>

char* fmi_import_get_dll_path(const char* fmu_unzipped_path, const char* model_identifier, jm_callbacks* callBackFunctions);
char* fmi_import_get_model_description_path(const char* fmu_unzipped_path, jm_callbacks* callBackFunctions);

#endif /* End of header file FMI1_IMPORT_UTIL_H_ */