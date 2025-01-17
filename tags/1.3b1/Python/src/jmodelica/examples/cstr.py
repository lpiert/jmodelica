#!/usr/bin/env python 
# -*- coding: utf-8 -*-

# Copyright (C) 2010 Modelon AB
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, version 3 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

# Import library for path manipulations
import os.path
from jmodelica import initialize
from jmodelica import simulate
from jmodelica import optimize

import jmodelica.jmi as jmi
from jmodelica.compiler import OptimicaCompiler

import numpy as N
import matplotlib.pyplot as plt

def run_demo(with_plots=True):
    """This example is based on the Hicks-Ray
    Continuously Stirred Tank Reactors (CSTR) system. The system
    has two states, the concentration and the temperature. The
    control input to the system is the temperature of the cooling
    flow in the reactor jacket. The chemical reaction in the reactor
    is exothermic, and also temperature dependent; high temperature
    results in high reaction rate.
    
    The example demonstrates the following steps:
    
    1. How to solve a DAE initialization problem. The initialization
       model have equations specifying that all derivatives
       should be identically zero, which implies that a
       stationary solution is obtained. Two stationary points,
       corresponding to different inputs, are computed. We call
       the stationary points A and B respectively. point A corresponds
       to operating conditions where the reactor is cold and
       the reaction rate is low, whereas point B corresponds to
       a higher temperature where the reaction rate is high.

       For more information about the DAE initialization algorithm, see
       http://www.jmodelica.org/page/10.

    2. How to generate an initial guess for a direct collocation method
       by means of simulation. The trajectories resulting from simulation
       are used to initialize the variables in the transcribed NLP.
       
    3. An optimal control problem is solved where the objective Is to
       transfer the state of the system from stationary point A to point
       B. The challenge is to ignite the reactor while avoiding
       uncontrolled temperature increase. It is also demonstrated how to
       set parameter and variable values in a model.

       More information about the simultaneous optimization algorithm
       can be found at http://www.jmodelica.org/page/10.

    4. The optimization result is saved to file and then
       the important variables are plotted.

    5. Simulate the system with the optimal control profile. This step
       is important in order to verify that the approximation in the
       transcription step is valid.
       
"""

    curr_dir = os.path.dirname(os.path.abspath(__file__));

    # Create a Modelica compiler instance
    oc = OptimicaCompiler()
    oc.set_boolean_option("enable_variable_scaling",True)
        
    # Compile the stationary initialization model into a DLL
    init_model = oc.compile_model("CSTR.CSTR_Init", curr_dir+"/files/CSTR.mo", target='ipopt')
        
    # Set inputs for Stationary point A
    Tc_0_A = 250
    init_model.set_value('Tc',Tc_0_A)
        
    # Solve the DAE initialization system with Ipopt
    init_result = initialize(init_model)
    
    # Store stationary point A
    c_0_A = init_result.result_data.get_variable_data('c').x[0]
    T_0_A = init_result.result_data.get_variable_data('T').x[0]
    
    # Print some data for stationary point A
    print(' *** Stationary point A ***')
    print('Tc = %f' % Tc_0_A)
    print('c = %f' % c_0_A)
    print('T = %f' % T_0_A)

    # Set inputs for Stationary point B
    Tc_0_B = 280
    init_model.set_value('Tc',Tc_0_B)
        
    # Solve the DAE initialization system with Ipopt
    init_result = initialize(init_model)
    
    # Store stationary point B
    res = init_result.result_data
    c_0_B = res.get_variable_data('c').x[0]
    T_0_B = res.get_variable_data('T').x[0]

    # Print some data for stationary point B
    print(' *** Stationary point B ***')
    print('Tc = %f' % Tc_0_B)
    print('c = %f' % c_0_B)
    print('T = %f' % T_0_B)

    # Compute initial guess trajectories by means of simulation

    # Create the time vector
    t = N.linspace(1,150.,100)
    # Create the input vector from the target input value. The
    # target input value is here increased in order to get a
    # better initial guess.
    u = (Tc_0_B+35)*N.ones(N.size(t,0))
    # Create a matrix where the first column is time and the second column represents
    # the input trajectory.
    u_traj = N.transpose(N.vstack((t,u)))

    # Compile the optimization initialization model and load the DLL
    init_sim_model = oc.compile_model("CSTR.CSTR_Init_Optimization",curr_dir+"/files/CSTR.mo",target='ipopt')

    # Set model parameters
    init_sim_model.set_value('cstr.c_init',c_0_A)
    init_sim_model.set_value('cstr.T_init',T_0_A)
    init_sim_model.set_value('Tc_0',Tc_0_A)
    init_sim_model.set_value('c_ref',c_0_B)
    init_sim_model.set_value('T_ref',T_0_B)
    init_sim_model.set_value('Tc_ref',u[0])

    sim_res = simulate(init_sim_model,alg_args={'start_time':0.,'final_time':150.,
                                                'input_trajectory':u_traj})
    
    # Extract variable profiles
    res = sim_res.result_data
    c_init_sim=res.get_variable_data('cstr.c')
    T_init_sim=res.get_variable_data('cstr.T')
    Tc_init_sim=res.get_variable_data('cstr.Tc')

    # Plot the results
    if with_plots:
        plt.figure(1)
        plt.clf()
        plt.hold(True)
        plt.subplot(311)
        plt.plot(c_init_sim.t,c_init_sim.x)
        plt.grid()
        plt.ylabel('Concentration')

        plt.subplot(312)
        plt.plot(T_init_sim.t,T_init_sim.x)
        plt.grid()
        plt.ylabel('Temperature')

        plt.subplot(313)
        plt.plot(Tc_init_sim.t,Tc_init_sim.x)
        plt.grid()
        plt.ylabel('Cooling temperature')
        plt.xlabel('time')
        plt.show()


    # Solve optimal control problem    
    cstr = oc.compile_model("CSTR.CSTR_Opt", curr_dir+"/files/CSTR.mo", target='ipopt')

    cstr.set_value('Tc_ref',Tc_0_B)
    cstr.set_value('c_ref',c_0_B)
    cstr.set_value('T_ref',T_0_B)

    cstr.set_value('cstr.c_init',c_0_A)
    cstr.set_value('cstr.T_init',T_0_A)

    n_e = 100 # Number of elements 
    hs = N.ones(n_e)*1./n_e # Equidistant points
    n_cp = 3; # Number of collocation points in each element

    opt_res = optimize(cstr,alg_args={'n_e':n_e,'hs':hs,'n_cp':n_cp,'init_traj':res})

    # Extract variable profiles
    res = opt_res.result_data
    c_res=res.get_variable_data('cstr.c')
    T_res=res.get_variable_data('cstr.T')
    Tc_res=res.get_variable_data('cstr.Tc')

    c_ref=res.get_variable_data('c_ref')
    T_ref=res.get_variable_data('T_ref')
    Tc_ref=res.get_variable_data('Tc_ref')

    cost=res.get_variable_data('cost')
    
    assert N.abs(cost.x[-1]/1.e7 - 1.8585429) < 1e-3, \
            "Wrong value of cost function in cstr.py"  

    # Plot the results
    if with_plots:
        plt.figure(2)
        plt.clf()
        plt.hold(True)
        plt.subplot(311)
        plt.plot(c_res.t,c_res.x)
        plt.plot(c_ref.t,c_ref.x,'--')
        plt.grid()
        plt.ylabel('Concentration')

        plt.subplot(312)
        plt.plot(T_res.t,T_res.x)
        plt.plot(T_ref.t,T_ref.x,'--')
        plt.grid()
        plt.ylabel('Temperature')

        plt.subplot(313)
        plt.plot(Tc_res.t,Tc_res.x)
        plt.plot(Tc_ref.t,Tc_ref.x,'--')
        plt.grid()
        plt.ylabel('Cooling temperature')
        plt.xlabel('time')
        plt.show()

    # Simulate to verify the optimal solution
    # Set up input trajectory
    t = Tc_res.t 
    u = Tc_res.x
    u_traj = N.transpose(N.vstack((t,u)))
    
    # Comile the Modelica model first to C code and
    # then to a dynamic library
    sim_model = oc.compile_model("CSTR.CSTR",curr_dir+"/files/CSTR.mo",target='ipopt')

    sim_model.set_value('c_init',c_0_A)
    sim_model.set_value('T_init',T_0_A)
    sim_model.set_value('Tc',u[0])

    sim_res = simulate(sim_model,compiler='optimica',
                       alg_args={'start_time':0.,'final_time':150.,
                       'input_trajectory':u_traj})
    
    # Extract variable profiles
    res = sim_res.result_data
    c_sim=res.get_variable_data('c')
    T_sim=res.get_variable_data('T')
    Tc_sim=res.get_variable_data('Tc')

    # Plot the results
    if with_plots:
        plt.figure(3)
        plt.clf()
        plt.hold(True)
        plt.subplot(311)
        plt.plot(c_res.t,c_res.x,'--')
        plt.plot(c_sim.t,c_sim.x)
        plt.legend(('optimized','simulated'))
        plt.grid()
        plt.ylabel('Concentration')

        plt.subplot(312)
        plt.plot(T_res.t,T_res.x,'--')
        plt.plot(T_sim.t,T_sim.x)
        plt.legend(('optimized','simulated'))
        plt.grid()
        plt.ylabel('Temperature')

        plt.subplot(313)
        plt.plot(Tc_res.t,Tc_res.x,'--')
        plt.plot(Tc_sim.t,Tc_sim.x)
        plt.legend(('optimized','simulated'))
        plt.grid()
        plt.ylabel('Cooling temperature')
        plt.xlabel('time')
        plt.show()

    
if __name__ == "__main__":
    run_demo()
