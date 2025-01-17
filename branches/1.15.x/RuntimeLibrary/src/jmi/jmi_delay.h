 /*
    Copyright (C) 2014 Modelon AB

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

/** \file jmi_delay.h
    \brief Interface to simulation of delay blocks.

    Delay blocks are kept in the `jmi_t` struct and are indexed from 0 to `n_delays - 1`.
    Each delay block represents a use of the `delay` operator with fixed or variable time delay.
    The functions below that take an index operate on a single delay block,
    those that don't operate on all delay blocks at once.
    Most functions need the current time value, which they take implicitly from the `jmi_t` struct.
    
    The total number of delay blocks `n_delays` is specified in the call to `jmi_init`,
    which allocates space for the blocks and calls `jmi_delay_new` on them.
    Correspondingly, `jmi_delete` deallocates the blocks with the aid of `jmi_delay_delete`.

    Before using a delay block in simulation, it must be initialized with `jmi_delay_init`.
    This will specify the properties of the delay block and provide an initial value for it's output,
    to be used until the elapsed simulation time exceeds the delay time.

    Delay blocks are evaluated using the `jmi_delay_evaluate`, which uses the current time and input
    value in cases when the delay time is small. `jmi_delay_evaluate` will step over events stored
    in the delay buffer if `jmi->atEvent` is true, and not otherwise.

    Delay blocks need to be fed with new samples of their input value regularly to save in the delay buffer.
    This is done with `jmi_delay_record_sample`, which should be called
      * after each completed integrator step (call `jmi_delay_set_event_mode` with `in_event` set to false first) and
      * after each completed event iteration (call `jmi_delay_set_event_mode` with `in_event` set to true first)
    The event mode set with `jmi_delay_set_event_mode` controls whether an event is considered to have occured
    just before the recorded sample. Time should increase from one sample to the next, except for recorded events,
    where the time should be the same as for the previous sample.
    
    Depending on their type, delay blocks can generate
      * no events (`no_event` set to true),
      * time events (`fixed` set to true), or
      * state events (`fixed` set to false)
    The caller must initialize the flags correctly when calling `jmi_delay_init`,
    and make sure to query event indicators precisely for the delay blocks with `fixed` and `noevent` set to false.
    Delay blocks that cause events will not be able to cross events in the delay history unless the events that
    they request are triggered.

    Time events are queried collectively for all delay blocks that cause time events using `jmi_delay_next_time_event`.

    Delay blocks with state events have two event indicators (forward and backward), both with a >= 0 relation,
    queried with `jmi_delay_first_event_indicator` and `jmi_delay_second_event_indicator`.
 */

#ifndef _JMI_DELAY_H
#define _JMI_DELAY_H

#include "jmi_types.h"

/** \brief Initial value for state event switches */
#define JMI_DELAY_INITIAL_EVENT_SW  1.0
/** \brief Initial value for state event residuals */
#define JMI_DELAY_INITIAL_EVENT_RES 1.0

/** \brief Allocate buffers for the delay block with the given index. Do this before `jmi_delay_init`. */
int jmi_delay_new(jmi_t *jmi, int index);
/** \brief Free the memory for the buffers of the delay block with the given index. It may then be reallocated with `jmi_delay_new`. */
int jmi_delay_delete(jmi_t *jmi, int index);

/** \brief Initialize the delay block with given index and provide a first data point. The time variable in the jmi struct should already be initialized. */
int jmi_delay_init(jmi_t *jmi, int index, jmi_boolean fixed, jmi_boolean no_event, jmi_real_t max_delay, jmi_real_t y0);

/** \brief Evaluate the output of the delay block with given index, current input value, and delay time */
jmi_real_t jmi_delay_evaluate(jmi_t *jmi, int index, jmi_real_t y_in, jmi_real_t delay_time);

/** \brief Record a sample for the delay with given index. Call at each completed integrator step. Time is taken from the `jmi` struct. */
int jmi_delay_record_sample(jmi_t *jmi, int index, jmi_real_t y_in);

/** \brief Call with `event_mode` set to true before recording samples that follow an event, then with `event_mode` set to false before recording regular samples */
int jmi_delay_set_event_mode(jmi_t *jmi, jmi_boolean in_event);

/** \brief Return the next time event caused by any delay block, or JMI_INF if there is no next time event */
jmi_real_t jmi_delay_next_time_event(jmi_t *jmi);

/** \brief Return the first (of two) event indicators >= 0 for a variable delay block in *event_indicator. Return -1 on failure, 0 otherwise. */
int jmi_delay_first_event_indicator(jmi_t *jmi, int index, jmi_real_t delay_time, jmi_real_t *event_indicator);
/** \brief Return the second (of two) event indicators >= 0 for a variable delay block in *event_indicator. Return -1 on failure, 0 otherwise. */
int jmi_delay_second_event_indicator(jmi_t *jmi, int index, jmi_real_t delay_time, jmi_real_t *event_indicator);


#endif 
