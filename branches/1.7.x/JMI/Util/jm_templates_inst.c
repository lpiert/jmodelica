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

#include "jm_vector.h"

#define JM_TEMPLATE_INSTANCE_TYPE char
#include "jm_vector_template.h"

#undef JM_TEMPLATE_INSTANCE_TYPE
#define JM_TEMPLATE_INSTANCE_TYPE int
#include "jm_vector_template.h"

#undef JM_TEMPLATE_INSTANCE_TYPE
#define JM_TEMPLATE_INSTANCE_TYPE double
#include "jm_vector_template.h"

#undef JM_TEMPLATE_INSTANCE_TYPE
#define JM_TEMPLATE_INSTANCE_TYPE size_t
#include "jm_vector_template.h"

#undef JM_TEMPLATE_INSTANCE_TYPE
/* #undef JM_COMPAR_OP
#define JM_COMPAR_OP(f,s) ((char*)f -(char*)s) */
#define JM_TEMPLATE_INSTANCE_TYPE jm_voidp
#include "jm_vector_template.h"

#undef JM_TEMPLATE_INSTANCE_TYPE
#undef JM_COMPAR_OP
#define JM_TEMPLATE_INSTANCE_TYPE jm_string
#define JM_COMPAR_OP(f,s) strcmp(f,s)
#include "jm_vector_template.h"
