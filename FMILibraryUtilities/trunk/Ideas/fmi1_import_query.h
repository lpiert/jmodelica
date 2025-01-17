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
#ifndef FMI1_IMPORT_QUERY_H
#define FMI1_IMPORT_QUERY_H

#include <jm_vector.h>
#include <jm_stack.h>
#include <FMI1/fmi1_import_variable.h>
#ifdef __cplusplus
extern "C" {
#endif

/* Query below has the following syntax:
  query =   elementary_query
                  | '(' query ')'
                  | query 'or' query
                  | query 'and' query
                  | 'not' query
  elementary_query =  "name" '=' <string>
                    | "quantity" '=' <string>
                    | "basetype" '=' (real| integer | enumeration |boolean |string)
                    | "type" '=' <string>
                    | "unit" '=' <string>
                    | "displayUnit" '=' <string>
                    | "fixed" '=' ("true"|"false")
                    | "hasStart" '='  ("true"|"false")
                    | "isAlias"
                    | "alias" '=' ['-']<variable name> (negative value for negated-aliases)

Example: "name='a.*' & fixed=false"
*/

#define FMI1_IMPORT_Q_ELEMENTARY(HANDLE) \
    HANDLE(name) \
    HANDLE(unit) \

/*
    HANDLE(type) \
    HANDLE(fixed) \
    HANDLE(hasstart) \
    HANDLE(isalias) 
    HANDLE(alias)
    HANDLE(basetype) \
    HANDLE(displayunit) \
*/

typedef enum fmi1_import_elementary_enu_t {
#define FMI1_IMPORT_Q_ELEMENTARY_PREFIX(elem) fmi1_import_q_elmentary_enu_##elem,
    FMI1_IMPORT_Q_ELEMENTARY(FMI1_IMPORT_Q_ELEMENTARY_PREFIX)
    fmi1_import_elementary_enu_num
} fmi1_import_elementary_enu_t;

typedef struct fmi1_import_q_context_t fmi1_import_q_context_t;
typedef struct fmi1_import_q_terminal_t fmi1_import_q_terminal_t;

typedef int (*fmi1_import_q_scan_elementary_ft)(fmi1_import_q_context_t*, fmi1_import_q_terminal_t* term);

#define FMI1_IMPORT_Q_ELEMENTARY_DECLARE_SCAN(name) int fmi1_import_q_scan_elementary_##name(fmi1_import_q_context_t*, fmi1_import_q_terminal_t* term);
FMI1_IMPORT_Q_ELEMENTARY(FMI1_IMPORT_Q_ELEMENTARY_DECLARE_SCAN)


typedef int (*fmi1_import_q_eval_elementary_ft)(fmi1_import_variable_t* var, fmi1_import_q_terminal_t* term);

#define FMI1_IMPORT_Q_ELEMENTARY_DECLARE_EVAL(name) int fmi1_import_q_eval_elementary_##name(fmi1_import_variable_t* var, fmi1_import_q_terminal_t* term);
FMI1_IMPORT_Q_ELEMENTARY(FMI1_IMPORT_Q_ELEMENTARY_DECLARE_EVAL)

typedef enum fmi1_import_q_term_enu_t {
	fmi1_import_q_term_enu_elementary,
	fmi1_import_q_term_enu_LP,
	fmi1_import_q_term_enu_RP,
	fmi1_import_q_term_enu_OR,
	fmi1_import_q_term_enu_AND,
	fmi1_import_q_term_enu_NOT,
	fmi1_import_q_term_enu_END,
	fmi1_import_q_term_enu_TRUE,
	fmi1_import_q_term_enu_FALSE
} fmi1_import_q_terminal_enu_t;


struct fmi1_import_q_terminal_t {
	fmi1_import_q_terminal_enu_t kind;

	fmi1_import_elementary_enu_t specific;

	int param_i;
	double param_d;
	void* param_p;
	char* param_str;

};

jm_vector_declare_template(fmi1_import_q_terminal_t)

typedef jm_vector(fmi1_import_q_terminal_t) fmi1_import_q_term_vt;

typedef struct fmi1_import_q_expression_t fmi1_import_q_expression_t;

struct fmi1_import_q_expression_t {
    jm_vector(jm_voidp) expression;

    jm_vector(jm_voidp) stack;

    fmi1_import_q_terminal_t termFalse, termTrue;
    fmi1_import_q_term_vt terms;
	jm_vector(char) strbuf;
};

struct fmi1_import_q_context_t {
    jm_vector(jm_name_ID_map_t) elementary_map;

	jm_string query;

	size_t qlen;
	int curCh;

	jm_vector(char) buf;

	fmi1_import_q_expression_t expr;
};

void fmi1_import_q_init_context(fmi1_import_q_context_t*, jm_callbacks* cb);
void fmi1_import_q_free_context_data(fmi1_import_q_context_t*);
int fmi1_import_q_filter_variable(fmi1_import_variable_t* var, fmi1_import_q_expression_t* );
int fmi1_import_q_parse_query(fmi1_import_q_context_t* context, jm_string query);

#ifdef __cplusplus
}
#endif
#endif /* FMI1_IMPORT_QUERY_H */
