/*
    Copyright (C) 2016 Modelon AB

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License version 3 as published
    by the Free Software Foundation, or optionally, under the terms of the
    Common Public License version 1.0 as published by IBM.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License, or the Common Public License, for more details.

    You should have received copies of the GNU General Public License
    and the Common Public License along with this program.  If not,
    see <http://www.gnu.org/licenses/> or
    <http://www.ibm.com/developerworks/library/os-cpl.html/> respectively.
*/

#include "jmi.h"
#include "jmi_math.h"


/* Helper function for logging warnings from the "_equation"- and "_function"-functions below */
void static jmi_log_func_or_eq(jmi_t *jmi, const char cathegory_name[], const char func_name[], const char msg[], const char val[]) {
    if (func_name != NULL) {
        char buf[64];
        sprintf(buf, "%s%s", cathegory_name, "InFunc");
        jmi_log_node(jmi->log, logWarning, buf, "<func: %s, exp: %s, val:%s>", func_name, msg, val);
    } else {
        jmi_log_node(jmi->log, logWarning, cathegory_name, "<exp:%s, val: %s>", msg, val);
    }
}

int jmi_check_nan(jmi_t *jmi, jmi_real_t* val, size_t n_val, jmi_int_t* index_of_nan) {
    size_t i = 0;
    for (i = 0; i < n_val; i++) {
        if ( val[i] - val[i] != 0) {
            *index_of_nan = i;
            return JMI_ERROR;
        }
    }
    return JMI_OK;
}

void jmi_inf_log(jmi_t *jmi, const char func_name[], const char msg[], jmi_real_t res, jmi_real_t x) {
    if (((res - res) != 0)) {
        if (jmi == NULL) jmi = jmi_get_current();
        
        if (res > 0) {
            /* res is +inf */
            char val[64];
            sprintf(val, "%.14E", x);
            jmi_log_func_or_eq(jmi, "RangeError", func_name, msg, val);
        } else if (res < 0){
            /* res is -inf */
            char val[64];
            sprintf(val, "%.14E", x);
            jmi_log_func_or_eq(jmi, "RangeError", func_name, msg, val);
        }
    }
}

/*Some of these functions return types are a temporary remnant of CppAD*/
jmi_real_t static jmi_divide(jmi_t *jmi, const char func_name[], jmi_real_t num, jmi_real_t den, const char msg[]) {
    if (den == 0) {
        char val[64];
        sprintf(val, "%.14E, %.14E", num, den);
        
        if (jmi == NULL) jmi = jmi_get_current();
        jmi_log_func_or_eq(jmi, "DivideByZero", func_name, msg, val);
    }
    
    return num/den;
}

jmi_real_t jmi_divide_function(const char func_name[], jmi_real_t num, jmi_real_t den, const char msg[]) {
    return jmi_divide(NULL, func_name, num, den, msg);
}

jmi_real_t jmi_divide_equation(jmi_t *jmi, jmi_real_t num, jmi_real_t den, const char msg[]) {
    return jmi_divide(jmi, NULL, num, den, msg);
}

jmi_real_t static jmi_atan2(jmi_t *jmi, const char func_name[], jmi_real_t x, jmi_real_t y, const char msg[]) {
    jmi_real_t to_return = atan2(x, y);
    if (x == 0 && y == 0) {
        char val[64];
        sprintf(val, "%.14E, %.14E", x, y);
        
        if (jmi == NULL) jmi = jmi_get_current();
        jmi_log_func_or_eq(jmi, "IllegalAtan2Input", func_name, msg, val);
    }
    
    return to_return;
}

jmi_real_t jmi_atan2_function(const char func_name[], jmi_real_t x, jmi_real_t y, const char msg[]) {
    return jmi_atan2(NULL, func_name, x, y, msg);
}

jmi_real_t jmi_atan2_equation(jmi_t *jmi, jmi_real_t x, jmi_real_t y, const char msg[]) {
    return jmi_atan2(jmi, NULL, x, y, msg);
}

jmi_real_t static jmi_pow(jmi_t *jmi, const char func_name[], jmi_real_t x, jmi_real_t y, const char msg[]) {
    jmi_real_t to_return = pow(x, y);

	if ((to_return - to_return) != 0) {
		/* The returned value is not a number */
		if (jmi == NULL)
			jmi = jmi_get_current();

		/* Check that the inputs are in the domain of the function*/
		if (x > 0 || (x == 0 && y > 0) || (x < 0 && (int) y == y)) {
			/* Range problem, will return JMI_INF or -JMI_INF */
			char val[64];
			sprintf(val, "%.14E, %.14E", x, y);
			jmi_log_func_or_eq(jmi, "RangeError", func_name, msg, val);
		} else if (x == 0 && y < 0) {
			/* Pole error */
			char val[64];
			sprintf(val, "%.14E, %.14E", x, y);
			jmi_log_func_or_eq(jmi, "DivideByZero", func_name, msg, val);
		}
	}
    /* jmi_inf_log(jmi, func_name, msg, to_return); */
    return to_return;
}

jmi_real_t jmi_pow_function(const char func_name[], jmi_real_t x, jmi_real_t y, const char msg[]) {
    return jmi_pow(NULL, func_name, x, y, msg);
}

jmi_real_t jmi_pow_equation(jmi_t *jmi, jmi_real_t x, jmi_real_t y, const char msg[]) {
    return jmi_pow(jmi, NULL, x, y, msg);
}

jmi_real_t static jmi_pow_der(jmi_t *jmi, const char func_name[], jmi_real_t x, jmi_real_t y, jmi_real_t x_der, jmi_real_t y_der, const char msg[]) {
	jmi_real_t x_pow_y = jmi_pow(jmi, func_name, x, y, msg);
    jmi_real_t to_return;
	if (x == 0 && y_der == 0 ) {
		if (y > 1) {
			to_return = 0;
		} else if (y == 1) {
			to_return = x_der;
		} else if (y < 1) {
			char val[64];
			to_return = jmi_sign(x_der*y)*JMI_INF;
			sprintf(val, "%.14E, %.14E, %.14E, %.14E", x, y, x_der, y_der);
			jmi_log_func_or_eq(jmi, "x^y where y < 1", func_name, msg, val);
		}
	} else {
		to_return = x_pow_y * (x_der*y/x + y_der*log(jmi_abs(x)));
	}
	return to_return;
}

jmi_real_t jmi_pow_der_function(const char func_name[], jmi_real_t x, jmi_real_t y, jmi_real_t x_der, jmi_real_t y_der, const char msg[]) {
    return jmi_pow_der(NULL, func_name, x, y, x_der, y_der, msg);
}

jmi_real_t jmi_pow_der_equation(jmi_t *jmi, jmi_real_t x, jmi_real_t y, jmi_real_t x_der, jmi_real_t y_der, const char msg[]) {
    return jmi_pow_der(jmi, NULL, x, y, x_der, y_der, msg);
}

jmi_real_t static jmi_exp(jmi_t *jmi, const char func_name[], jmi_real_t x, const char msg[]) {

    jmi_real_t to_return = exp(x);
    jmi_inf_log(jmi, func_name, msg, to_return, x);
    return to_return;
}

jmi_real_t jmi_exp_function(const char func_name[], jmi_real_t x, const char msg[]) {
    return jmi_exp(NULL, func_name, x, msg);
}

jmi_real_t jmi_exp_equation(jmi_t *jmi, jmi_real_t x, const char msg[]) {
    return jmi_exp(jmi, NULL, x, msg);
}

jmi_real_t static jmi_log(jmi_t *jmi, const char func_name[], jmi_real_t x, const char msg[]) {

    jmi_real_t to_return = log(x);
    
    if ((to_return - to_return) != 0) {
        /* The returned value is not a number */
        if (jmi == NULL) jmi = jmi_get_current();
        
        if (x == 0) {
            /* Pole problem, will return -JMI_INF */
            char val[64];
            sprintf(val, "%.14E", x);
            jmi_log_func_or_eq(jmi, "LogarithmOfZero", func_name, msg, val);
        } else if (x > 0) {
            /* Range problem, will return JMI_INF */
            char val[64];
            sprintf(val, "%.14E", x);
            jmi_log_func_or_eq(jmi, "LogarithmOfInf", func_name, msg, val);
        }
    }
    return to_return;
}

jmi_real_t jmi_log_function(const char func_name[], jmi_real_t x, const char msg[]) {
    return jmi_log(NULL, func_name, x, msg);
}

jmi_real_t jmi_log_equation(jmi_t *jmi, jmi_real_t x, const char msg[]) {
    return jmi_log(jmi, NULL, x, msg);
}

jmi_real_t static jmi_log10(jmi_t *jmi, const char func_name[], jmi_real_t x, const char msg[]) {

    jmi_real_t to_return = log10(x);
    
    if ((to_return - to_return) != 0) {
        /* The returned value is not a number */
        if (jmi == NULL) jmi = jmi_get_current();
        
        if (x == 0) {
            /* Pole problem, will return -JMI_INF */
            char val[64];
            sprintf(val, "%.14E", x);
            jmi_log_func_or_eq(jmi, "LogarithmOfZero", func_name, msg, val);
        } else if (x > 0) {
            /* Infinity problem, will return JMI_INF */
            char val[64];
            sprintf(val, "%.14E", x);
            jmi_log_func_or_eq(jmi, "LogarithmOfInf", func_name, msg, val);
        }
    }
    return to_return;
}

jmi_real_t jmi_log10_function(const char func_name[], jmi_real_t x, const char msg[]) {
    return jmi_log10(NULL, func_name, x, msg);
}

jmi_real_t jmi_log10_equation(jmi_t *jmi, jmi_real_t x, const char msg[]) {
    return jmi_log10(jmi, NULL, x, msg);
}

jmi_real_t static jmi_sinh(jmi_t *jmi, const char func_name[], jmi_real_t x, const char msg[]) {

    jmi_real_t to_return = sinh(x);
    jmi_inf_log(jmi, func_name, msg, to_return, x);
    return to_return;
}

jmi_real_t jmi_sinh_function(const char func_name[], jmi_real_t x, const char msg[]) {
    return jmi_sinh(NULL, func_name, x, msg);
}

jmi_real_t jmi_sinh_equation(jmi_t *jmi, jmi_real_t x, const char msg[]) {
    return jmi_sinh(jmi, NULL, x, msg);
}

jmi_real_t static jmi_cosh(jmi_t *jmi, const char func_name[], jmi_real_t x, const char msg[]) {

    jmi_real_t to_return = cosh(x);
    jmi_inf_log(jmi, func_name, msg, to_return, x);
    return to_return;
}

jmi_real_t jmi_cosh_function(const char func_name[], jmi_real_t x, const char msg[]) {
    return jmi_cosh(NULL, func_name, x, msg);
}

jmi_real_t jmi_cosh_equation(jmi_t *jmi, jmi_real_t x, const char msg[]) {
    return jmi_cosh(jmi, NULL, x, msg);
}

jmi_real_t static jmi_tan(jmi_t *jmi, const char func_name[], jmi_real_t x, const char msg[]) {

    jmi_real_t to_return = tan(x);
    jmi_inf_log(jmi, func_name, msg, to_return, x);
    return to_return;
}

jmi_real_t jmi_tan_function(const char func_name[], jmi_real_t x, const char msg[]) {
    return jmi_tan(NULL, func_name, x, msg);
}

jmi_real_t jmi_tan_equation(jmi_t *jmi, jmi_real_t x, const char msg[]) {
    return jmi_tan(jmi, NULL, x, msg);
}

jmi_real_t jmi_abs(jmi_real_t v) {
    return COND_EXP_GE(v, 0.0, v, -v);
}

jmi_real_t jmi_sign(jmi_real_t v) {
    return COND_EXP_GT(v, 0.0, 1.0, COND_EXP_LT(v, 0.0, -1.0, 0.0));
}

jmi_real_t jmi_min(jmi_real_t x, jmi_real_t y) {
    return COND_EXP_LT(x, y, x ,y);
}

jmi_real_t jmi_max(jmi_real_t x, jmi_real_t y) {
    return COND_EXP_GT(x, y, x ,y);
}

jmi_real_t jmi_dround(jmi_real_t x) {
    return (x >= 0)? floor(x + 0.5) : floor(x - 0.5);
}

jmi_real_t jmi_dremainder(jmi_t* jmi, jmi_real_t x, jmi_real_t y) {
    jmi_real_t res = fmod(x,y);
    jmi_real_t scaling = jmi_max(1.0, jmi_max(x,y));
    return ((jmi_abs(res-y)/scaling)<jmi->time_events_epsilon)? (res-y)/scaling : res/scaling;
}

jmi_real_t jmi_sample(jmi_t* jmi, jmi_real_t offset, jmi_real_t h) {
    jmi_real_t t = jmi_get_t(jmi)[0];
    jmi_real_t remainder;
    if (!jmi->atEvent || SURELY_LT_ZERO(t-offset) || jmi->atInitial) {
        return JMI_FALSE;
    }
    remainder = jmi_dremainder(jmi, (t-offset),h);
    if (jmi_abs(remainder) < jmi->time_events_epsilon)
        return TRUE;
    else
        return FALSE;
}
