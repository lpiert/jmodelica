#!/usr/bin/env python 
# -*- coding: utf-8 -*-
"""Implements single and multiple shooting.

"""

import ctypes
import math
import os
import sys

import nose
import numpy as N
import scipy as S
import matplotlib

try:
    from openopt import NLP
except ImportError:
    print "Could not load SUNDIALS."

import pylab as p
import nose

import jmodelica.jmi as pyjmi
from jmodelica.jmi import c_jmi_real_t
from jmodelica.tests import get_example_path
from jmodelica.tests import load_example_standard_model
from jmodelica.simulation.sundials import SundialsOdeSimulator


class ShootingException(Exception):
    """ A shooting exception. """
    pass


def _shoot(model, start_time, end_time, sensi=True, time_step=0.2):
    """Performs a single 'shot' (simulation) from start_time to end_time.
    
    Model parameters/states etc. must be set BEFORE calling this method.
    
    The function returns a tuple consisting of:
        1. The cost gradient with respect to initial states and
           input U.
        2. The final ($t_{tp_0}=1$) simulation states.
        3. A dictionary holding the indices for the gradient.
        4. The corresponding sensitivity matrix (if sensi is not False)
    
    if sensi is set to False no sensitivity analysis will be done and the 
    
    Parameters:
    model      -- the model which is to be used in the shot (simulation).
    start_time -- the time when simulation should start.
    end_time   -- the time when the simulation should finish.
    
    Keyword parameters:
    sensi     -- True/False, if sensivity is to be conducted. (default=True)
    time_step -- the time_step to be taken within the integration code.
                 (default=0.2)
        
    Notes:
     * Assumes cost function is only dependent on state X and control signal U.
    
    """
    simulator = SundialsOdeSimulator(model, start_time=start_time,
        final_time=end_time, sensitivity_analysis=sensi, time_step=time_step,
        return_last=True)
    simulator.run()
    T, last_y = simulator.get_solution()
    sens = simulator.get_sensitivities()
    params = simulator.get_sensitivity_indices()
    
    model.set_x_p(last_y, 0)
    model.set_dx_p(model.dx, 0)
    model.set_u_p(model.u, 0)
    
    if sensi:
        sens_rows = range(params.xinit_start, params.xinit_end) + \
                    range(params.u_start, params.u_end)
        sens_mini = sens[sens_rows]
        gradparams = {
            'xinit_start': 0,
            'xinit_end': params.xinit_end - params.xinit_start,
            'u_start': params.xinit_end - params.xinit_start,
            'u_end': params.xinit_end - params.xinit_start + params.u_end - \
                     params.u_start,
        }
    
        cost_jac_x = model.opt_eval_jac_J(pyjmi.JMI_DER_X_P).flatten()
        cost_jac_u = model.opt_eval_jac_J(pyjmi.JMI_DER_U_P).flatten()
        cost_jac = N.concatenate ( [cost_jac_x, cost_jac_u] )
        
        # See my master thesis report for the specifics of these calculations
        # Both lines below have been verified to work correctly
        costgradient_x = N.dot(sens[params.xinit_start:params.xinit_end, :],
                               cost_jac_x).flatten()
        costgradient_u = N.dot(sens[params.u_start:params.u_end, :],
                               cost_jac_x).flatten() + cost_jac_u
        
        # The full cost gradient w.r.t. the states and the input
        costgradient = N.concatenate( [costgradient_x, costgradient_u] )
    else:
        costgradient = None
        gradparams = None
        sens_mini = None
    
    # TODO: Create a return type instead of returning tuples
    return costgradient, last_y, gradparams, sens_mini


def single_shooting(model, initial_u=0.4, plot=True):
    """Run single shooting of model model with a constant u.
    
    The function returns the optimal u.
    
    Notes:
     * Currently written specifically for VDP.
     * Currently only supports one input/control signal.
    
    Parameters:
    model -- the model which is to be simulated. Only models with one control
             signal is supported.
             
    Keyword parameters:
    initial_u -- the initial input U_0 used to initialize the optimization
                 with.
    
    """
    assert len(model.u) == 1, "More than one control signal is " \
                                         "not supported as of today."
    
    start_time = model.opt_interval_get_start_time()
    end_time = model.opt_interval_get_final_time()
    
    u = model.u
    u0 = N.array([initial_u])
    print "Initial u:", u
    
    gradient = None
    gradient_u = None
    
    def f(cur_u):
        """The cost evaluation function."""
        model.reset()
        u[:] = cur_u
        print "u is", u
        big_gradient, last_y, gradparams, sens = _shoot(model, start_time, end_time)
        
        model.set_x_p(last_y, 0)
        model.set_dx_p(model.dx, 0)
        model.set_u_p(model.u, 0)
        cost = model.opt_eval_J()
        
        gradient_u = cur_u.copy()
        gradient = big_gradient[gradparams['u_start']:gradparams['u_end']]
        
        print "Cost:", cost
        print "Grad:", gradient
        return cost
    
    def df(cur_u):
        """The gradient of the cost function.
        
        NOT USED right now.
        """
        model.reset()
        u[:] = cur_u
        print "u is", u
        big_gradient, last_y, gradparams, sens = _shoot(model, start_time, end_time)
        
        model.set_x_p(last_y, 0)
        model.set_dx_p(model.dx, 0)
        model.set_u_p(model.u, 0)
        cost = model.opt_eval_J()
        
        gradient_u = cur_u.copy()
        gradient = big_gradient[gradparams['u_start']:gradparams['u_end']]
        
        print "Cost:", cost
        print "Grad:", gradient
        return gradient
    
    p = NLP(f, u0, maxIter = 1e3, maxFunEvals = 1e2)
    p.df = df
    if plot:
        p.plot = 1
    else:
        p.plot = 0
    p.iprint = 1
    
    u_opt = p.solve('scipy_slsqp')
    return u_opt


def _eval_initial_ys(model, grid, time_step=0.2):
    """Generate a feasible initial guesstimate of the initial states for each
       segment in a grid.
       
    This is done by doing a simulation from start to end and extracting the
    states at the time points between the segments specified in the grid.
    
    Parameters:
    model -- the model which is to be simulated.
    grid  -- the segment grid list. Each element in grid corresponds to a
             segment and contains a tupleconsisting of start and end time of
             that segment.
    
    Keyword parameters:
    time_step -- the time step size used in the integration.
    
    """
    # TODO: Move this to MultipleShooter
    from scipy import interpolate
    _check_grid_consistency(grid)
    
    simulator = SundialsOdeSimulator(model, time_step=time_step)
    simulator.run()
    T, ys = simulator.get_solution()
    T = N.array(T)
    
    tck = interpolate.interp1d(T, ys, axis=0)
    initials = map(lambda interval: tck(interval[0]).flatten(), grid)
    initials = N.array(initials).flatten()
    return initials
    

def _check_normgrid_consistency(normgrid):
    """Check normalized grid input parameter for errors.
    
    Raises ShootingException on error.
    
    By normalized it means the times are from 0 to 1.
    """
    # TODO: Move this to MultipleShooter
    if math.fabs(normgrid[0][0]) > 0.001:
        raise ShootingException("Warning: The start time of the first segment "
                                "should usually coinside with the model start "
                                "time.")
    if math.fabs(normgrid[-1][1]-1) > 0.001:
        raise ShootingException("Warning: The end time of the last segment "
                                "should usually coinside with the model end "
                                "time.")
    _check_grid_consistency(normgrid)


def _check_grid_consistency(grid):
    # TODO: Move this to MultipleShooter
    """Check grid input parameter for errors.
    
    Raises ShootingException on error.
    """
    if not len(grid) >= 1:
        raise ShootingException('You need to specify at least one segment.')
    def check_inequality(a, b):
        if a >= b:
            raise ShootingException('One grid segment is incorrectly '
                                    'formatted.')
    map(check_inequality, *zip(*grid))


class MultipleShooter:
    """Handles Multiple Shooting model optimization."""
    
    def __init__(self, model, initial_u, normgrid=[(0, 1)], initial_y=None,
                 plot=True):
        """Constructor.
        
        Parameters:
        model     -- the model to simulate/optimize over.
        initial_u -- a list of initial inputs for each segment. If not a list,
                     it is assumed to be the same initial input for each
                     segment.
        
        Keyword parameters:
        normgrid --
            A list of 2-tuples per segment. The first element in each tuple
            being the segment start time, the second element the segment end
            time. The grid must hold normalized values.
        initial_y --
            Can be three things:
             * A list of initial states for all grids. If any of these are
               None they will be replaced by the default model state.
             * None -- using the solution from the default model state.
             * A list of initial states for each segment except the first one.
               If not a list the same initial state will be used for each
               segment.
               
        Note:
        Any states set in the model will be reset when initializing this class
        with with that model.
        """
        self.set_model(model)
        self.set_normalized_grid(normgrid)
        self.set_time_step()
        self.set_initial_u(initial_u)
        self.set_initial_y(initial_y)
        self.set_log_level(MultipleShooter.QUIET)
        
    QUIET = 0
    WHISPER = 1
    SCREAM = 2
    TINITUS = 3
    def set_log_level(self, loglevel):
        """Set the amount of verbosity when running shooting."""
        self._verbosity = loglevel
        
    def get_log_level(self):
        return self._verbosity
        
    def set_time_step(self, time_step=0.2):
        """The step length when the integrator should return."""
        self._time_step = time_step
        
    def get_time_step(self):
        return self._time_step
        
    def set_model(self, model):
        """Set the OptModel model.
        
        Note:
        Any states set in the model will be reset when initializing this class
        with with that model.
        """
        model.reset()
        self._m = model
        
    def get_model(self):
        """Get the OptModel model."""
        return self._m    
        
    def set_initial_u(self, initial_u):
        """ Set the initial U's (control signals) for each segment."""
        grid = self.get_grid()
        model = self.get_model()
        if len(initial_u) != len(grid):
            raise ShootingException('initial_u parameters must be the same '
                                    'length as grid segments.')
        self._initial_u = N.array(initial_u).reshape(
                                          (len(grid), len(model.u)))
        
        # Assume the first initial_u is a feasible one
        model.u = self._initial_u[0]
        
    def get_initial_u(self):
        """Returns the constant control/input signals, one segment per row."""
        return self._initial_u
        
    def set_initial_y(self, initial_y=None):
        """Set the initial states for the first optimization iteration.
        
        If initial_y is None a simple guessing scheme will be used based on a
        simple simulation using default initial values.
        """
        model = self.get_model()
        grid = self.get_grid()
        
        if initial_y is None:
            initial_y = _eval_initial_ys(model, grid,
                                         time_step=self.get_time_step())
        elif len(initial_y) != len(grid):
            raise ShootingException('initial_y states must be the same length '
                                    'as grid segments.')
        self._initial_y = N.array(initial_y).reshape(
                                (len(grid), len(self.get_model().x)))
        
    def get_initial_y(self):
        """Returns the initial states, one segment per row."""
        return self._initial_y[1:]
        
    def get_initial_y_grid0(self):
        """Returns the initial states for the first grid."""
        return self._initial_y[0]
        
    def set_normalized_grid(self, grid):
        """Set the grid containing normalized times (between [0, 1]).
        
        The method also checks for inconsistencies in the grid.
        
        Each element in grid corresponds to a segment and contains a tuple
        consisting of start and end time of that segment.
        """
        _check_normgrid_consistency(grid)
        
        model = self.get_model()
        
        # Denormalize times
        simulation_length = model.opt_interval_get_final_time() - model.opt_interval_get_start_time()
        def denormalize_time(start_time, end_time):
            start_time = model.opt_interval_get_start_time() + \
                         simulation_length * start_time
            end_time = model.opt_interval_get_start_time() + simulation_length * end_time
            return (start_time, end_time)
            
        self.set_grid(map(denormalize_time, *zip(*grid)))
        
    def set_grid(self, grid):
        """ Set the grid.
        
        The grid does not necessarily have to be normalized.
        
        The method also checks for inconsistencies in the grid.
        
        Each element in grid corresponds to a segment and contains a tuple
        consisting of start and end time of that segment.
        """
        _check_grid_consistency(grid)
        
        self._grid = grid
        
    def get_grid(self):
        """Returned the real grid holding the actual simulation times."""
        return self._grid
    
    def _shoot_single_segment(self, u, y0, interval, sensi=True):
        """Shoot a single segment in multiple shooting.
        
        The 'shot' is done between interval[0] and interval[1] with initial
        states y0 and constant input/control signal u.
        """
        model = self.get_model()
        
        if len(y0) != len(model.x):
            raise ShootingException('Wrong length to single segment: '
                                    '%s != %s' %
                                    (len(y0), len(model.x)))
            
        seg_start_time = interval[0]
        seg_end_time = interval[1]
        
        u = u.flatten()
        y0 = y0.flatten()
        
        model.reset()
        model.u = u
        model.x = y0
        
        seg_cost_gradient, seg_last_y, seg_gradparams, sens = \
                                         _shoot(model,
                                                seg_start_time,
                                                seg_end_time,
                                                sensi=sensi,
                                                time_step=self.get_time_step())
        
        # TODO: Create a return type instead of returning tuples
        return seg_cost_gradient, seg_last_y, seg_gradparams, sens
    
    def f(self, p):
        """Returns the evaluated cost function w.r.t. the vector 'p'.
        
        'p'is a concatenation of initial states (excluding the first segment) 
        and parameters. See _split_opt_x(...) for details.
        """
        model = self.get_model()
        grid = self.get_grid()
        ys, us = _split_opt_x(model, len(grid), p, self.get_initial_y_grid0())
        
        if self.get_log_level() >= MultipleShooter.SCREAM:
            print "p:", p
        
        costgradient, last_y, gradparams, sens = \
              self._shoot_single_segment(us[-1], ys[-1], grid[-1], sensi=False)
        
        model.set_x_p(last_y, 0)
        model.set_dx_p(model.dx, 0)
        model.set_u_p(model.u, 0)
        cost = model.opt_eval_J()
        
        if self.get_log_level() >= MultipleShooter.WHISPER:
            print "Evaluating cost:", cost
        if self.get_log_level() >= MultipleShooter.SCREAM:
            print "Evaluating cost: (u, y, grid) = ", us[-1], ys[-1], grid[-1]
        
        return cost
        
    def df(self, p):
        """Returns the evaluated gradient of the cost function w.r.t.
           the vector 'p'.
        
        'p'is a concatenation of initial states (excluding the first segment) 
        and parameters. See _split_opt_x(...) for details.
        """
        model = self.get_model()
        grid = self.get_grid()
        ys, us = _split_opt_x(model, len(grid), p, self.get_initial_y_grid0())
        costgradient, last_y, gradparams, sens = \
                           self._shoot_single_segment(us[-1], ys[-1], grid[-1])
        
        if self.get_log_level() >= MultipleShooter.WHISPER:
            print "Evaluating cost function gradient."
        
        if len(grid) == 1:
            gradient = N.array(costgradient[gradparams['u_start'] :
                                            gradparams['u_end']])
        else:
            # Comments:
            #  * The cost does not depend on the first initial states.
            #  * The cost does not depend on the first inputs/control signal
            gradient = N.array([0] * len(model.x) * (len(grid) - 2)
                                + list(costgradient[gradparams['xinit_start'] :
                                                    gradparams['xinit_end']])
                                + [0] * (len(grid) - 1) *
                                                        len(model.u)
                                + list(costgradient[gradparams['u_start'] :
                                                    gradparams['u_end']]))
        
        assert len(p) == len(gradient)
        
        if self.get_log_level() >= MultipleShooter.SCREAM:
            print gradient
        
        return gradient
        
    def h(self, p): # h(p) = 0
        """Evaluates continuity (equality) constraints.
        
        This function has visually been verified to work in the sense that
        discontinuities lead to a big magnitude of the corresponding elements
        in the system.
        """
        model = self.get_model()
        grid = self.get_grid()
        y0s, us = _split_opt_x(model, len(grid), p, self.get_initial_y_grid0())
        
        def eval_last_ys(u, y0, interval):
            grad, last_y, gradparams, sens = \
                                    self._shoot_single_segment(u, y0, interval)
            return last_y
        last_ys = N.array(map(eval_last_ys, us[:-1], y0s[:-1], grid[:-1]))
        
        if self.get_log_level() >= MultipleShooter.SCREAM:
            print "Evaluating equality contraints:", (last_ys - y0s[1:])
        
        return (last_ys - y0s[1:])
        
    def dh(self, p):
        """Evaluates the jacobian of self.h(p).
        
        This function currently assumes the multiple shooting being conducted
        cannot vary the initial states with respect to the first segment.
        """
        if self.get_log_level() >= MultipleShooter.WHISPER:
            print "Evaluating equality contraints gradient."
        
        model = self.get_model()
        grid = self.get_grid()
        y0s, us = _split_opt_x(model, len(grid), p, self.get_initial_y_grid0())
        
        def eval_last_ys(u, y0, interval):
            costgrad, last_y, gradparams, sens = \
                                    self._shoot_single_segment(u, y0, interval)
            return gradparams, sens
        mapresults = map(eval_last_ys, us[:-1], y0s[:-1], grid[:-1])
        gradparams, sens = zip(*mapresults)
        
        NP = len(p)                  # number of elements in p
        NOS = len(model.x) # Number Of States
        NOI = len(model.u) # Number Of Inputs
        NEQ = (len(grid) - 1) * NOS  # number of equality equations in h(p)
        
        r = N.zeros((NEQ, NP))
        
        for segmentindex in range(len(grid) - 1):
            # Indices
            row_start = segmentindex * NOS
            row_end = row_start + NOS
            xinitsenscols_start = (segmentindex - 1) * NOS
            xinitsenscols_end = xinitsenscols_start + NOS
            xinitcols_start = segmentindex * NOS
            xinitcols_end = xinitcols_start + NOS
            usenscols_start = (y0s.size - NOS) + NOI * segmentindex
            usenscols_end = usenscols_start + NOI
            
            # Indices from the sensivity matrix
            sensxinitindices = range(gradparams[segmentindex]['xinit_start'],
                                     gradparams[segmentindex]['xinit_end'])
            sensuindices = range(gradparams[segmentindex]['u_start'],
                                 gradparams[segmentindex]['u_end'])
            
            if segmentindex != 0:
                # The initial states of first segment is locked.
                r[row_start:row_end, xinitsenscols_start:xinitsenscols_end] = \
                                      sens[segmentindex][sensxinitindices, :].T
            r[row_start : row_end, xinitcols_start : xinitcols_end] = \
                                                 -N.eye(len(model.x))
            r[row_start : row_end, usenscols_start : usenscols_end] = \
                                          sens[segmentindex][sensuindices, :].T
        
        if self.get_log_level() >= MultipleShooter.TINITUS:
            N.set_printoptions(N.nan)
            print "dh(p):"
            print r
        
        return r
        
    def get_p0(self):
        """Returns the initial p-vector which is to optimized over.
        
        The vector is constructed based on self.get_initial_y() and
        self.get_initial_u(). See _split_opt_x(...) for details.
        """
        initial_y = self.get_initial_y()
        initial_u = self.get_initial_u()
        p0 = N.concatenate( (N.array(initial_y).flatten(),
                             N.array(initial_u).flatten()) )
        return p0
        
    def check_gradients(self):
        """Verify that gradients looks correct.
        
        This function indirectly uses the built in OpenOPT gradient
        verification feature which compares finite different quotients with the
        gives gradient evaluation function.
        """
        self.run_optimization(plot=False, _only_check_gradients=True)
        
    def run_optimization(self, plot=True, _only_check_gradients=False):
        """Start/run optimization procedure and the optimum unless.
        
        Set the keyword parameter 'plot' to False (default=True) if plotting
        should not be conducted.
        """
        grid = self.get_grid()
        model = self.get_model()
        
        # Initial try
        p0 = self.get_p0()

        # Less than (-0.5 < u < 1)
        # TODO: These are currently hard coded. They shouldn't be.
        #NLT = len(grid) * len(model.u)
        #Alt = N.zeros( (NLT, len(p0)) )
        #Alt[:, (len(grid) - 1) * len(model.x):] = -N.eye(len(grid) *
        #                                              len(model.u))
        #blt = -0.5*N.ones(NLT)

        # TODO: These are currently hard coded. They shouldn't be.
        #N_xvars = (len(grid) - 1) * len(model.x)
        #N_uvars = len(grid) * len(model.u)
        #N_vars = N_xvars + N_uvars
        #Alt = -N.eye(N_vars)
        #blt = N.zeros(N_vars)
        #blt[0:N_xvars] = -N.ones(N_xvars)*0.001
        #blt[N_xvars:] = -N.ones(N_uvars)*1;
        
        # Get OpenOPT handler
        p = NLP(self.f,
                p0,
                maxIter = 1e3,
                maxFunEvals = 1e3,
                #A=Alt, # See TODO above
                #b=blt, # See TODO above
                df=self.df,
                ftol = 1e-4,
                xtol = 1e-4,
                contol=1e-4)
        if len(grid) > 1:
            p.h  = self.h
            p.dh = self.dh
        
        if plot:
            p.plot = 1
        p.iprint = 1
        
        if _only_check_gradients:
            # Check gradients against finite difference quotients
            p.checkdf(maxViolation=0.05)
            p.checkdh()
            return None
        
        #opt = p.solve('ralg') # does not work - serious convergence issues
        opt = p.solve('scipy_slsqp')
        
        if plot:
            plot_control_solutions(model, grid, opt.xf)
        
        return opt
        

def _split_opt_x(model, gridsize, p, prepend_initials):
    """Split a Multiple Shooting optimization array into its segmented parts.
    
    Based on the OptModel model and grid size gridsize _split_opt_x(...) takes
    an optimization vector p and returns tuple (ys, us) where ys is a matrix
    with the initial states, one segment per row. us are the control signals,
    one row per segment.
    """
    ys = N.concatenate( (prepend_initials,
                         p[0 : (gridsize - 1) * len(model.x)]) )
    ys = ys.reshape( (gridsize, len(model.x)) )
    us = p[(gridsize - 1) * len(model.x) : ]
    us = us.reshape( (gridsize, len(model.u)) )
    return ys, us
    

def _plot_control_solution(model, interval, initial_ys, us):
    """Plots a single shooting solution.
    
    Parameters:
    model      -- the model to simulate.
    interval   -- a tuple: (start_time, end_time)
    initial_ys -- the initial states at the beginning of the simulation.
    us         -- the constant control signal(s) used throughout the
                  simulation.
    """
    model.reset()
    model.x = initial_ys
    model.u = us

    p.figure(1)
    p.subplot(211)
    simulator = SundialsOdeSimulator(model, start_time=interval[0],
                                     final_time=interval[1])
    simulator.run()
    T, Y = simulator.get_solution()
    p.hold(True)
    for i in range(len(model.x)):
        p.plot(T,Y[:,i],label="State #%s" % (i + 1), linewidth=2)

    p.subplot(212)
    p.hold(True)
    for i in range(len(model.u)):
        p.plot(interval, [us[i], us[i]], label="Input #%s" % (i + 1))
    p.hold(False)

    return [T,Y,yS]
    
    
def plot_control_solutions(model, grid, opt_p, doshow=True):
    """Plot multiple shooting solution.
    
    Parameters:
    model -- the model to be used in the simulation.
    grid  -- the grid to be used.
    p     -- the optimization vector p to be used. See _split_opt_x(...) for
             more info.
    
    Keyword parameters:
    doshow -- set to False if a plot of the solution not should be shown.
              (default=True).
    
    Note:
    The model will be reset when calling this!
    """
    model.reset()
    initial_ys, us = _split_opt_x(model, len(grid), opt_p, model.x)
    
    p.figure()
    p.hold(True)
    map(_plot_control_solution, [model] * len(grid), grid, initial_ys, us)
    p.subplot(211); p.title("Solutions (states)")
    p.subplot(212); p.title("Control/input signals")
    p.hold(False)
    if doshow:
        p.show()


def cost_graph(model):
    """Plot the cost as a function a constant u (single shooting) based on the
       model model.
    
    This function was mainly used for testing.
    
    Notes:
     * Currently written specifically for VDP.
     * Currently only supports inputs.
    """
    start_time = model.opt_interval_get_start_time()
    end_time = model.opt_interval_get_final_time()
    
    u = model.u
    print "Initial u:", u
    
    costs = []
    Us = []
    
    simulator = SundialsOdeSimulator(model, start_time=start_time,
                                     final_time=end_time)
    
    for u_elmnt in N.arange(-0.5, 1, 0.02):
        print "u is", u
        model.reset()
        u[0]=u_elmnt
        
        simulation.run()
        T, ys = simulation.get_solution()
        
        model.set_x_p(ys[-1], 0)
        model.set_dx_p(model.dx, 0)
        model.set_u_p(model.u, 0)
        
        cost = model.opt_eval_J()
        print "Cost:", cost
        
        # Saved for plotting
        costs.append(cost)
        Us.append(u_elmnt)
        
        cost_jac = model.opt_eval_jac_J(pyjmi.JMI_DER_X_P)
    
    p.subplot('121')
    p.plot(Us, costs)
    p.title("Costs as a function of different constant Us (VDP model)")
    
    from scipy import convolve
    p.subplot('122')
    dUs = Us
    dcost = convolve(costs, N.array([1, -1])/0.02)[0:-1]
    assert len(dUs) == len(dcost)
    p.plot(dUs, dcost)
    p.title('Forward derivatives')
    
    p.show()


def construct_grid(n):
    """Construct and return an equally spaced grid with n segments."""
    times = N.linspace(0, 1, n+1)
    return zip(times[:-1], times[1:])


def _print_openopt_result(optres):
    print "Optimal p:", optres.xf
    print "Cost(p)", optres.ff


def main(args=sys.argv):
    """The main method.
    
    Uses command line arguments to know what to do. Run
    $ python shooting.py --help
    to see what you can do.
    """
    from optparse import OptionParser
    parser = OptionParser()
    parser.add_option('-w', '--what', default='multiple', type='choice',
        metavar="METHOD", choices=['multiple', 'single', 'genplot'],
        help="What this script should do. Can be multiple, single or genplot. "
             "(default=%default)")
    parser.add_option('-m', '--model', default='VDP_pack.VDP_Opt',
        metavar="MODELNAME",
        help="The optimica model that should be loaded from within the *.mo "
             "file. (default=%default)")
    parser.add_option('-D', '--directory', default=get_example_path(),
        metavar="PATH", help="The directory from which to load the *.mo file. "
                             "(default=%default)")
    parser.add_option('-f', '--modelfile', default='VDP.mo',
        metavar="FILE", help="The *.mo file that contains the Optimica "
                             "optimzation problem description and/or model. "
                             "(default=%default)")
    parser.add_option('-d', '--dllfile', default='VDP_pack_VDP_Opt',
        metavar="FILE", help="The name of the compiled DLL file that contains "
                             "the compiled model. If this doesn't exist it "
                             "will be created from the *.mo file. "
                             "(default=%default)")
    parser.add_option('-t', '--timestep', default=0.2, type="float",
        help="The step size between each integrator return.")
    
    parser.add_option('-u', '--initial-u', dest='initialu', default=2.5,
        type='float', metavar="U", help="The initial guess of control/input "
                                        "signal u in optimization. "
                                        "(default=%default)")
    parser.add_option('-g', '--gridsize', dest='gridsize', default=10,
        type='int', metavar="N", help="The grid size to use in multiple "
                                      "shooting. (default=%default)")
    
    parser.add_option('-p', '--predefined-model', dest='predmodel',
                      default=None, type='choice', choices=['vdp', 'quadtank'],
                      help="A set of predefined example models. Using one of "
                           "these will override --modelfile, --directory, "
                           "--modelfile and --directory.")
    
    (options, args) = parser.parse_args(args=args)
    
    if options.gridsize <= 0:
        raise ShootingException('Grid size must be greater than zero.')
        
    if options.predmodel == 'vdp':
        options.dllfile = 'VDP_pack_VDP_Opt'
        options.model = 'VDP_pack.VDP_Opt'
        options.directory = get_example_path()
        options.modelfile = 'VDP.mo'
    elif options.predmodel == 'quadtank':
        options.dllfile = 'QuadTank_pack_QuadTank_Opt'
        options.model = 'QuadTank_pack.QuadTank_Opt'
        options.directory = get_example_path()
        options.modelfile = 'QuadTank.mo'
        options.timestep = 5
    
    m = pyjmi.load_model(options.dllfile, options.directory, options.modelfile,
                         options.model, 'optimica')
    
    if options.what == 'genplot':
        # Whether the cost as a function of input U should be plotted
        cost_graph(m)
    elif options.what=='single':
        optimum = single_shooting(m)
        _print_openopt_result(optimum)
        return optimum
    elif options.what == 'multiple':
        grid = construct_grid(options.gridsize)
        
        # needed to be able get a reasonable initial
        m.u = [options.initialu] * len(m.u)
        
        initial_u = [[options.initialu] * len(m.u)] * \
                                                               options.gridsize
        shooter = MultipleShooter(m, initial_u, grid)
        shooter.set_time_step(options.timestep)
        optimum = shooter.run_optimization()
        _print_openopt_result(optimum)
        return optimum
        
    return None


if __name__ == "__main__":
    # The assignment below allows iPython session to reuse the parameter opt
    opt = main(sys.argv[1:])
