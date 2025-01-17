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

/* This header is used to generate the FMU test DLL and in the C API test that uses the DLL */
#ifndef BB_FMU1_MODEL_DEFINES_H_

#define STRINGIFY(a)			#a
#define STRINGIFY2(a)			STRINGIFY(a)
#define MODEL_IDENTIFIER_STR	STRINGIFY2(MODEL_IDENTIFIER)

#define BUFFER					1024
#define MAGIC_TEST_VALUE		13.0	/* A test value for some functions  */

/* BouncingBall model with redundant values */
/* ValueReferences for the variables and parameters in the model, separated by datatype */
/* States */
#define VAR_R_position			0
#define VAR_R_der_position		1
/* Real */
#define VAR_R_gravity			2
#define VAR_R_bounce_coeff		3

/* Event indicators */
#define EVENT_position			0

/* Event indicators */
#define VAR_S_LOGGER_TEST		0

/* Sizes */
#define N_STATES				2
#define N_EVENT_INDICATORS		1
#define N_REAL					4
#define N_INTEGER				4
#define N_BOOLEAN				4
#define N_STRING				4

#define N_INPUT_REAL			2 /* CS only */
#define N_INPUT_REAL_MAX_ORDER	2 /* CS only */
#define N_OUTPUT_REAL			2 /* CS only */
#define N_OUTPUT_REAL_MAX_ORDER	2 /* CS only */


#define FMI_VERSION			"1.0"
#if defined(FMI1_TYPES_H_)
#define FMI_PLATFORM_TYPE	fmi1_get_platform()
#elif defined(fmiModelTypesPlatform)
#define FMI_PLATFORM_TYPE	fmiModelTypesPlatform
#elif defined(fmiPlatform)
#define FMI_PLATFORM_TYPE	fmiPlatform
#else
#error "Either fmiPlatform or fmiModelTypesPlatform must be defined"
#endif

/*Unique GUIDs for ME and CS FMUs*/
#define FMI_CS_GUID			"ef7ce57c-8fb5-4556-b0c9-4bfd7f91b793"
#define FMI_ME_GUID			"b6106da2-8e21-464c-8a3f-a1723bebbd94"


#include <fmu1_model.h>

#endif /* End of header BB_FMU1_MODEL_DEFINES_H_ */