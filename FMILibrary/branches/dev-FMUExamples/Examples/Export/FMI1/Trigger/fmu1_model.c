/*
Copyright (C) 2012 Modelon AB

This program is free software: you can redistribute it and/or modify
it under the terms of the BSD style license.


This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
FMILIB_License.txt file for more details.

You should have received a copy of the FMILIB_License.txt file
along with this program. If not, contact Modelon AB <http://www.modelon.com>.
*/

#include <stdio.h>
#include <string.h>

/*Include model specific definition e.g. number of states and values references, as well as all generic FMI function and type declarations -> fmu1_model.h*/
#include "Trigger_fmu1_model_defines.h"

/* Model calculation functions */
/*Set all default values for the model here. This needs to be separate from the initialization routine, as it might be overwritten altered by the master*/
static int set_default_values(component_ptr_t comp){
		
	/*Set values according to values from xml*/
	comp->integers	[VAR_I_integer_cnt]		= 1;
	comp->integers	[VAR_I_integer_stop]	= 10;
	comp->reals		[VAR_R_time_increment]	= 0.1;
	
	/*Settings for state event trigger*/
	comp->reals		[VAR_R_state_init]		= 2.0;
	comp->reals		[VAR_R_state_derivative]= -3.0;
				
	return 0;
}

/*Initial settings,values that are calculated and eventually the first time event are to be set here.*/
static int calc_initialize(component_ptr_t comp)
{
	comp->states[VAR_R_state]			= comp->reals[VAR_R_state_init];
	comp->states_der[VAR_R_state]		= comp->reals[VAR_R_state_derivative];
	
	/*Set first event*/
	comp->eventInfo.upcomingTimeEvent	= fmiTrue;
	comp->eventInfo.nextEventTime       = comp->reals[VAR_R_time_increment];

	if(comp->loggingOn) {
		comp->functions.logger(comp, comp->instanceName, fmiOK, "INFO", "###### Initializing component ######");
		comp->functions.logger(comp, comp->instanceName, fmiOK, "INFO", "Init #i%d#=%i", VAR_I_integer_cnt, comp->integers	[VAR_I_integer_cnt]);
		comp->functions.logger(comp, comp->instanceName, fmiOK, "INFO", "Init #i%d#=%i", VAR_I_integer_stop, comp->integers	[VAR_I_integer_stop]);
		comp->functions.logger(comp, comp->instanceName, fmiOK, "INFO", "Init #r%d#=%g", VAR_R_time_increment,comp->reals	[VAR_R_time_increment]);
		comp->functions.logger(comp, comp->instanceName, fmiOK, "INFO", "Init #r%d#=%g", VAR_R_state_init, comp->reals		[VAR_R_state_init]);
		comp->functions.logger(comp, comp->instanceName, fmiOK, "INFO", "Init #r%d#=%g", VAR_R_state_derivative, comp->reals[VAR_R_state_derivative]);
	}

	return 0;
}

/*Calculation of state derivatives*/
static int calc_get_derivatives(component_ptr_t comp)
{
	/*Set state derivative*/
	comp->states_der[VAR_R_state] = comp->reals[VAR_R_state_derivative];

	return 0;
}

/*Calculation of event indicators to verify if state event has happened*/
static int calc_get_event_indicators(component_ptr_t comp)
{	
	/*Indicator for state event*/
	fmiReal event_tol = 1e-16;
	comp->event_indicators[EVENT_state_zero]		= comp->states[VAR_R_state] + (comp->states[VAR_R_state] >= 0 ? event_tol : -event_tol);
	return 0;
}

/*Calculations for handling an event, e.g. reinitialization of states*/
static int calc_event_update(component_ptr_t comp)
{	
	fmiReal eventt_tol = 1e-16;

	/*Reset Sate to initial value.*/
	if (comp->states[VAR_R_state] < 0) {
		comp->states[VAR_R_state] =  comp->reals[VAR_R_state_init];
		if(comp->loggingOn) {
			comp->functions.logger(comp, comp->instanceName, fmiOK, "INFO", "Reset #r%d#=%g at %f", VAR_R_state, comp->states[VAR_R_state], comp->fmitime);
		}
		comp->eventInfo.iterationConverged			= fmiTrue;
		comp->eventInfo.stateValueReferencesChanged = fmiFalse;
		comp->eventInfo.stateValuesChanged			= fmiTrue;
	}
	
	if(comp->eventInfo.nextEventTime <= comp->fmitime) {

		comp->eventInfo.iterationConverged			= fmiTrue;
		comp->eventInfo.stateValueReferencesChanged = fmiFalse;
		comp->eventInfo.stateValuesChanged			= fmiFalse;

		comp->integers[VAR_I_integer_cnt] += 1;
    
		if (comp->integers	[VAR_I_integer_cnt] == comp->integers[VAR_I_integer_stop]){ 
			comp->eventInfo.terminateSimulation	= fmiTrue;
			}
		else {
			comp->eventInfo.upcomingTimeEvent	= fmiTrue;
			comp->eventInfo.nextEventTime       = comp->eventInfo.nextEventTime + comp->reals[VAR_R_time_increment];
			if(comp->loggingOn) {
				comp->functions.logger(comp, comp->instanceName, fmiOK, "INFO", "Setting TimeEvent at %f to %f", comp->fmitime,comp->eventInfo.nextEventTime);
			}
		}
	}
	
	return 0;
}


/* FMI 1.0 Common Functions */
const char* fmi_get_version()
{
	return FMI_VERSION;
}

/*Pass on logger switch*/
fmiStatus fmi_set_debug_logging(fmiComponent c, fmiBoolean loggingOn)
{
	component_ptr_t comp = (fmiComponent)c;
	if (comp == NULL) {
		return fmiFatal;
	} else {
		comp->loggingOn = loggingOn;
		return fmiOK;
	}
}

/*Read current real values*/
fmiStatus fmi_get_real(fmiComponent c, const fmiValueReference vr[], size_t nvr, fmiReal value[])
{
	component_ptr_t comp = (fmiComponent)c;
	if (comp == NULL) {
		return fmiFatal;
	} else {
		size_t k;
		for (k = 0; k < nvr; k++) {
			fmiValueReference cvr = vr[k];
			if (cvr < N_STATES) {
				value[k] = comp->states[cvr];
			} 
			else {
				value[k] = comp->reals[cvr];
			}	
		}
		return fmiOK;
	}
}

/*Read current integer values*/
fmiStatus fmi_get_integer(fmiComponent c, const fmiValueReference vr[], size_t nvr, fmiInteger value[])
{
	component_ptr_t comp = (fmiComponent)c;
	if (comp == NULL) {
		return fmiFatal;
	} else {
		size_t k;
		for (k = 0; k < nvr; k++) {
			value[k] = comp->integers[vr[k]];
		}
		return fmiOK;
	}
}

/*Read current boolean values*/
fmiStatus fmi_get_boolean(fmiComponent c, const fmiValueReference vr[], size_t nvr, fmiBoolean value[])
{
	component_ptr_t comp = (fmiComponent)c;
	if (comp == NULL) {
		return fmiFatal;
	} else {
		size_t k;
		for (k = 0; k < nvr; k++) {
			value[k] = comp->booleans[vr[k]];
		}
		return fmiOK;
	}
}

/*Read current string values*/
fmiStatus fmi_get_string(fmiComponent c, const fmiValueReference vr[], size_t nvr, fmiString  value[])
{
	component_ptr_t comp = (fmiComponent)c;
	if (comp == NULL) {
		return fmiFatal;
	} else {
		size_t k;
		for (k = 0; k < nvr; k++) {
			value[k] = comp->strings[vr[k]];
		}
		return fmiOK;
	}
}

/*Write current real values*/
fmiStatus fmi_set_real(fmiComponent c, const fmiValueReference vr[], size_t nvr, const fmiReal value[])
{
	component_ptr_t comp = (fmiComponent)c;
	if (comp == NULL) {
		return fmiFatal;
	} else {
		size_t k;
		for (k = 0; k < nvr; k++) {
			fmiValueReference cvr = vr[k];
			if (cvr < N_STATES) {
				comp->states[cvr] = value[k]; 
			} 
			else {
				comp->reals[cvr] = value[k]; 
			}			
		}
		return fmiOK;
	}
}

/*Write current integer values*/
fmiStatus fmi_set_integer(fmiComponent c, const fmiValueReference vr[], size_t nvr, const fmiInteger value[])
{
	component_ptr_t comp = (fmiComponent)c;
	if (comp == NULL) {
		return fmiFatal;
	} else {
		size_t k;
		for (k = 0; k < nvr; k++) {
			comp->integers[vr[k]] = value[k]; 
		}
		return fmiOK;
	}
}

/*Write current boolean values*/
fmiStatus fmi_set_boolean(fmiComponent c, const fmiValueReference vr[], size_t nvr, const fmiBoolean value[])
{
	component_ptr_t comp = (fmiComponent)c;
	if (comp == NULL) {
		return fmiFatal;
	} else {
		size_t k;
		for (k = 0; k < nvr; k++) {
			comp->booleans[vr[k]] = value[k]; 
		}
		return fmiOK;
	}
}

/*Write current string values*/
fmiStatus fmi_set_string(fmiComponent c, const fmiValueReference vr[], size_t nvr, const fmiString  value[])
{
	component_ptr_t comp = (fmiComponent)c;
	if (comp == NULL) {
		return fmiFatal;
	} else {
		size_t k;
		for (k = 0; k < nvr; k++) {			
			size_t len;
			fmiString s_dist;
			fmiString s_src = value[k];

			len = strlen((char*)s_src) + 1;
			s_dist = comp->functions.allocateMemory(len, sizeof(char));
			if (s_dist == NULL) {
				return fmiFatal;
			}			
			strcpy((char*)s_dist, (char*)s_src);
			if(comp->strings[vr[k]]) {
				comp->functions.freeMemory((void*)comp->strings[vr[k]]);
			}
			comp->strings[vr[k]] = s_dist;
		}

		/******* Logger test *******/
		if(comp->loggingOn == fmiTrue) {
			for (k = 0; k < nvr; k++) {
				fmiValueReference cvr = vr[k];
				if (cvr == VAR_S_LOGGER_TEST) {
					comp->functions.logger(comp, comp->instanceName, fmiFatal, "INFO", "%s",value[k]);
				}
			}
		}
		/******* End of logger test *******/
		return fmiOK;
	}
}

/* FMI 1.0 ME Functions */
const char* fmi_get_model_types_platform()
{
	return FMI_PLATFORM_TYPE;
}


fmiComponent fmi_instantiate_model(fmiString instanceName, fmiString GUID, fmiCallbackFunctions functions, fmiBoolean loggingOn)
{
	component_ptr_t comp;
	int k, p;

	comp = (component_ptr_t)functions.allocateMemory(1, sizeof(component_t));
	if (comp == NULL) {
		return NULL;
	} else if (strcmp(GUID, FMI_ME_GUID) != 0) {
		return NULL;
	} else {	
		sprintf(comp->instanceName, "%s", instanceName);
		sprintf(comp->GUID, "%s",GUID);
		comp->functions		= functions;
		comp->loggingOn		= loggingOn;

		comp->callEventUpdate = fmiFalse;

		/* Set default values */
		for (k = 0; k < N_STATES;			k++) comp->states[k]			= 0.0;
		for (k = 0; k < N_STATES;			k++) comp->states_prev[k]		= 0.0; /* Used in CS only */
		for (k = 0; k < N_STATES;			k++) comp->states_nom[k]		= 1.0;
		for (k = 0; k < N_STATES;			k++) comp->states_vr[k]			= k;
		for (k = 0; k < N_STATES;			k++) comp->states_der[k]		= 0.0;
		for (k = 0; k < N_EVENT_INDICATORS; k++) comp->event_indicators[k]	= 1e10;
		for (k = 0; k < N_REAL;				k++) comp->reals[k]				= 0.0;
		for (k = 0; k < N_INTEGER;			k++) comp->integers[k]			= 0;
		for (k = 0; k < N_BOOLEAN;			k++) comp->booleans[k]			= fmiFalse;
		for (k = 0; k < N_STRING;			k++) comp->strings[k]			= NULL;

		/* Used in CS only */
		for (k = 0; k < N_INPUT_REAL; k++) {
			for (p = 0; p < N_INPUT_REAL_MAX_ORDER + 1; p++) {
				comp->input_real[k][p] = 0.0;
			}
		}

		/* Used in CS only */
		for (k = 0; k < N_OUTPUT_REAL; k++) {
			for (p = 0; p < N_OUTPUT_REAL_MAX_ORDER + 1; p++) {
				comp->output_real[k][p] = MAGIC_TEST_VALUE;
			}
		}

		/*Set default inital values*/
		set_default_values(comp);

		return comp;
	}
}

void fmi_free_model_instance(fmiComponent c)
{
	component_ptr_t comp = (fmiComponent)c;
	
	if(comp->loggingOn){
		comp->functions.logger(comp, comp->instanceName, fmiOK, "INFO", "###### Freeing model instance. ######");		
	}
	comp->functions.freeMemory(c);
}

fmiStatus fmi_set_time(fmiComponent c, fmiReal fmitime)
{
	component_ptr_t comp = (fmiComponent)c;
	if (comp == NULL) {
		return fmiFatal;
	} else {
		comp->fmitime = fmitime;
		return fmiOK;
	}
}

fmiStatus fmi_set_continuous_states(fmiComponent c, const fmiReal x[], size_t nx)
{
	component_ptr_t comp = (fmiComponent)c;
	if (comp == NULL) {
		return fmiFatal;
	} else {
		size_t k;

		for (k = 0; k < nx; k++) {
			comp->states[k] = x[k];
		}
		return fmiOK;
	}
}

fmiStatus fmi_completed_integrator_step(fmiComponent c, fmiBoolean* callEventUpdate)
{
	component_ptr_t comp = (fmiComponent)c;
	if (comp == NULL) {
		return fmiFatal;
	} else {
	
		*callEventUpdate = comp->callEventUpdate;
		return fmiOK;
	}
}

fmiStatus fmi_initialize(fmiComponent c, fmiBoolean toleranceControlled, fmiReal relativeTolerance, fmiEventInfo* eventInfo)
{
	component_ptr_t comp = (fmiComponent)c;

	if (comp == NULL) {
		return fmiFatal;
	} else {
		comp->eventInfo.iterationConverged			= fmiFalse;
		comp->eventInfo.stateValueReferencesChanged = fmiFalse;
		comp->eventInfo.stateValuesChanged			= fmiFalse;
		comp->eventInfo.terminateSimulation			= fmiFalse;
		comp->eventInfo.upcomingTimeEvent			= fmiFalse;
		comp->eventInfo.nextEventTime				= -0.0;

		comp->toleranceControlled = toleranceControlled;
		comp->relativeTolerance = relativeTolerance;
		
		calc_initialize(comp);

		*eventInfo = comp->eventInfo;

		return fmiOK;
	}
}

fmiStatus fmi_get_derivatives(fmiComponent c, fmiReal derivatives[] , size_t nx)
{
	component_ptr_t comp = (fmiComponent)c;
	if (comp == NULL) {
		return fmiFatal;
	} else {
		size_t k;

		calc_get_derivatives(comp);

		for (k = 0; k < nx; k++) {
			derivatives[k] = comp->states_der[k];
		}
		return fmiOK;
	}
}

fmiStatus fmi_get_event_indicators(fmiComponent c, fmiReal eventIndicators[], size_t ni)
{
	component_ptr_t comp = (fmiComponent)c;
	if (comp == NULL) {
		return fmiFatal;
	} else {
		size_t k;

		calc_get_event_indicators(comp);

		for (k = 0; k < ni; k++) {
			eventIndicators[k] = comp->event_indicators[k];
		}
		return fmiOK;
	}
}

fmiStatus fmi_event_update(fmiComponent c, fmiBoolean intermediateResults, fmiEventInfo* eventInfo)
{
	component_ptr_t comp = (fmiComponent)c;
	if (comp == NULL) {
		return fmiFatal;
	} else {
		calc_event_update(comp);

		*eventInfo = comp->eventInfo;
		return fmiOK;
	}
}

fmiStatus fmi_get_continuous_states(fmiComponent c, fmiReal states[], size_t nx)
{
	component_ptr_t comp = (fmiComponent)c;
	if (comp == NULL) {
		return fmiFatal;
	} else {
		size_t k;
		
		for (k = 0; k < nx; k++) {
			states[k] = comp->states[k];
		}
		return fmiOK;
	}
}

fmiStatus fmi_get_nominal_continuousstates(fmiComponent c, fmiReal x_nominal[], size_t nx)
{
	component_ptr_t comp = (fmiComponent)c;
	if (comp == NULL) {
		return fmiFatal;
	} else {
		size_t k;
		for (k = 0; k < nx; k++) {
			x_nominal[k] = comp->states_nom[k];
		}
		return fmiOK;
	}
}

fmiStatus fmi_get_state_value_references(fmiComponent c, fmiValueReference vrx[], size_t nx)
{
	component_ptr_t comp = (fmiComponent)c;
	if (comp == NULL) {
		return fmiFatal;
	} else {
		size_t k;
		for (k = 0; k < nx; k++) {
			vrx[k] = comp->states_vr[k];
		}
		return fmiOK;
	}
}

fmiStatus fmi_terminate(fmiComponent c)
{
	component_ptr_t comp = (fmiComponent)c;
	if (comp == NULL) {
		return fmiFatal;
	} else {
		return fmiOK;
	}
}

/* FMI 1.0 CS Functions */
const char* fmi_get_types_platform()
{
	return FMI_PLATFORM_TYPE;
}

/*instantiation of slave, uses and extends ME model definitions*/
fmiComponent fmi_instantiate_slave(fmiString instanceName, fmiString fmuGUID, fmiString fmuLocation, fmiString mimeType, fmiReal timeout, fmiBoolean visible, fmiBoolean interactive, fmiCallbackFunctions functions, fmiBoolean loggingOn)
{
	component_ptr_t comp;

	comp = fmi_instantiate_model(instanceName, FMI_ME_GUID, functions, loggingOn);
	if (comp == NULL) {
		return NULL;
	} else if (strcmp(fmuGUID, FMI_CS_GUID) != 0) {
		return NULL;
	} else {	
		sprintf(comp->fmuLocation, "%s",fmuLocation);
		sprintf(comp->mimeType, "%s",mimeType);
		comp->timeout		= timeout;
		comp->visible		= visible;
		comp->interactive	= interactive;
		return comp;
	}
}

/*initialization of slave, uses and extends ME model definitions*/
fmiStatus fmi_initialize_slave(fmiComponent c, fmiReal tStart, fmiBoolean StopTimeDefined, fmiReal tStop)
{
	component_ptr_t comp	= (fmiComponent)c;
	fmiReal relativeTolerance;
	fmiEventInfo eventInfo;
	fmiBoolean toleranceControlled;


	comp->tStart			= tStart;
	comp->StopTimeDefined	= StopTimeDefined;
	comp->tStop				= tStop;

	toleranceControlled = fmiTrue;
	relativeTolerance = 1e-4;

	return fmi_initialize((fmiComponent)comp, toleranceControlled, relativeTolerance, &eventInfo);
}

fmiStatus fmi_terminate_slave(fmiComponent c)
{
	return fmi_terminate(c);
}

fmiStatus fmi_reset_slave(fmiComponent c)
{
	/*Set values to default again*/
	set_default_values(c);

	return fmiOK;
}

void fmi_free_slave_instance(fmiComponent c)
{
	fmi_free_model_instance(c);
}

/*get input derivatives, not used, dummy*/
fmiStatus fmi_set_real_input_derivatives(fmiComponent c, const fmiValueReference vr[], size_t nvr, const fmiInteger order[], const fmiReal value[])
{

	component_ptr_t comp	= (fmiComponent)c;
	size_t k;

	for (k = 0; k < nvr; k++) {
		comp->input_real[vr[k]][order[k]] = value[k];
		if (value[k] != MAGIC_TEST_VALUE) {/* Tests that the value is set to MAGIC_TEST_VALUE */
			return fmiFatal;
		}
	}

	return fmiOK;
}

/*get output derivatives, not used*/
fmiStatus fmi_get_real_output_derivatives(fmiComponent c, const fmiValueReference vr[], size_t nvr, const fmiInteger order[], fmiReal value[])
{
	component_ptr_t comp	= (fmiComponent)c;
	size_t k;

	for (k = 0; k < nvr; k++) {
		value[k] = comp->output_real[vr[k]][order[k]];
	}

	return fmiOK;
}

/*cancel step, not used,dummy*/
fmiStatus fmi_cancel_step(fmiComponent c)
{
	return fmiOK;
}

/*Integration routine for CoSimulation, resembles explicit Euler with substeps*/
fmiStatus fmi_do_step(fmiComponent c, fmiReal currentCommunicationPoint, fmiReal communicationStepSize, fmiBoolean newStep)
{
	component_ptr_t comp	= (fmiComponent)c;

	if (comp == NULL) {
		return fmiFatal;
	} else {
		fmiReal tstart = currentCommunicationPoint;
		fmiReal tcur;
		fmiReal tend = currentCommunicationPoint + communicationStepSize;
		fmiReal hcur; 
		fmiReal hdef = 0.01;	/* Default time step length */
		fmiReal z_cur[N_EVENT_INDICATORS];
		fmiReal z_pre[N_EVENT_INDICATORS];
		fmiReal states[N_STATES];
		fmiReal states_der[N_STATES];
		fmiEventInfo eventInfo;
		fmiBoolean callEventUpdate;
		fmiBoolean intermediateResults = fmiFalse;
		fmiStatus fmistatus;	
		size_t k;
		size_t counter = 0;

		fmi_get_continuous_states(comp, states, N_STATES);
		fmi_get_event_indicators(comp, z_pre, N_EVENT_INDICATORS);

		tcur = tstart;
		hcur = hdef;
		callEventUpdate = fmiFalse;
		eventInfo = comp->eventInfo;

		while (tcur < tend && counter < 100 && comp->eventInfo.terminateSimulation == fmiFalse) {
			size_t k;
			int zero_crossning_event = 0;
			counter++;

			/* Updated next time step */
			if (eventInfo.upcomingTimeEvent) {
				if (tcur + hdef < eventInfo.nextEventTime) {
					hcur = hdef;
				} else {
					hcur = eventInfo.nextEventTime - tcur;
				}
			} else {
				hcur = hdef;
			}

			{ 
				double t_full = tcur + hcur;
				if(t_full > tend) {
					hcur = (tend - tcur);
					tcur = tend;				
				}
				else
					tcur = t_full;
			}

			fmi_set_time(comp, tcur);

			/* Integrate a step */
			fmistatus = fmi_get_derivatives(comp, states_der, N_STATES);
			for (k = 0; k < N_STATES; k++) {
				states[k] = states[k] + hcur*states_der[k];	
				/* if (k == 0) printf("states[%u] = %f states_der[k] = %f hcur =%f\n", k, states[k], states_der[k], hcur); */
			}

			/* Set states */
			fmistatus = fmi_set_continuous_states(comp, states, N_STATES);
			/* Step is complete */
			fmistatus = fmi_completed_integrator_step(comp, &callEventUpdate);

			fmi_get_event_indicators(comp, z_cur, N_EVENT_INDICATORS);
			/* Check if an event inidcator has triggered */
			for (k = 0; k < N_EVENT_INDICATORS; k++) {
				if (z_cur[k]*z_pre[k] < 0) {
					zero_crossning_event = 1;
					break;
				}
			}
			
			/* Handle any events */
			if (callEventUpdate || zero_crossning_event || (eventInfo.upcomingTimeEvent && tcur == eventInfo.nextEventTime)) {
				if(comp->loggingOn) {
					comp->functions.logger(comp, comp->instanceName, fmiOK, "INFO", "###### Event was triggered at %g s.######",tcur);
				}
				fmistatus = fmi_event_update(comp, intermediateResults, &eventInfo);
				fmistatus = fmi_get_continuous_states(comp, states, N_STATES);
				fmistatus = fmi_get_event_indicators(comp, z_cur, N_EVENT_INDICATORS);
			}
			fmistatus = fmi_get_event_indicators(comp, z_pre, N_EVENT_INDICATORS);
			
            if(fmistatus != fmiOK) break;
		}
		for (k = 0; k < N_STATES; k++) { /* Update states */
			comp->reals[k] = comp->states[k];
		}
		if(eventInfo.terminateSimulation) {
			if(comp->loggingOn) {
					comp->functions.logger(comp, comp->instanceName, fmiOK, "INFO", "###### Terminate Simulation was requested at %g.######",tcur);
				}
			comp->eventInfo.terminateSimulation = eventInfo.terminateSimulation;
			return fmiOK;
		}
		return fmiOK;
	}
}

fmiStatus fmi_get_status(fmiComponent c, const fmiStatusKind s, fmiStatus*  value)
{
	switch (s) {
		case fmiDoStepStatus:
			/* Return fmiPending if we are waiting. Otherwise the result from fmiDoStep */
			*value = fmiOK;
			return fmiOK;
		default: /* Not defined for status for this function */
			return fmiDiscard;
	}
}

fmiStatus fmi_get_real_status(fmiComponent c, const fmiStatusKind s, fmiReal*    value)
{
	switch (s) {
		case fmiLastSuccessfulTime:
			/* Return fmiPending if we are waiting. Otherwise return end time for last call to fmiDoStep */
			*value = 0.01;
			return fmiOK;
		default: /* Not defined for status for this function */
			return fmiDiscard;
	}
}

fmiStatus fmi_get_integer_status(fmiComponent c, const fmiStatusKind s, fmiInteger* value)
{
	switch (s) {
		default: /* Not defined for status for this function */
			return fmiDiscard;
	}
}

fmiStatus fmi_get_boolean_status(fmiComponent c, const fmiStatusKind s, fmiBoolean* value)
{
	switch (s) {
		default: /* Not defined for status for this function */
			return fmiDiscard;
	}
}

fmiStatus fmi_get_string_status(fmiComponent c, const fmiStatusKind s, fmiString*  value)
{
	switch (s) {
		case fmiPendingStatus:
			*value = "Did fmiDoStep really return with fmiPending? Then its time to implement this function";
			return fmiDiscard;
		default: /* Not defined for status for this function */
			return fmiDiscard;
	}
}
