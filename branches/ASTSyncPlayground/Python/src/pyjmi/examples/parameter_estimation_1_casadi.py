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

# Import utility libraries
import os.path
from collections import OrderedDict

# Import numerical libraries
import numpy as N
import ctypes as ct
import matplotlib.pyplot as plt

# Import the JModelica.org Python packages
from pymodelica import compile_fmux, compile_fmu
from pyfmi import load_fmu
from pyjmi import CasadiModel
from pyjmi.optimization.casadi_collocation import MeasurementData

import scipy.integrate as integr

def run_demo(with_plots=True):
    """
    Demonstrate how to solve a simple parameter estimation problem.
    """
    
    # Locate model file
    curr_dir = os.path.dirname(os.path.abspath(__file__));
    model_path = curr_dir + "/files/ParameterEstimation_1.mop"
    
    # Compile the model into an FMU and FMUX
    fmu = compile_fmu("ParEst.SecondOrder", model_path)
    fmux = compile_fmux("ParEst.ParEstCasADi", model_path)
    
    # Load the model
    sim_model = load_fmu(fmu)
    opt_model = CasadiModel(fmux)
    
    # Simulate model with nominal parameters
    sim_res = sim_model.simulate(final_time=10)
        
    # Extract nominal trajectories
    t_sim = sim_res['time']
    x1_sim = sim_res['x1']
    x2_sim = sim_res['x2']

    # Get measurement data with 1 Hz and add measurement noise
    sim_model = load_fmu(fmu)
    meas_res = sim_model.simulate(final_time=10, options={'ncp': 10})
    x1_meas = meas_res['x1']
    noise = [0.01463904, 0.0139424, 0.09834249, 0.0768069, 0.01971631, 
             -0.03827911, 0.05266659, -0.02608245, 0.05270525, 0.04717024,
             0.0779514]
    t_meas = N.linspace(0, 10, 11)
    y_meas = x1_meas + noise

    if with_plots:
        # Plot simulation
        plt.close(1)
        plt.figure(1)
        plt.subplot(2, 1, 1)
        plt.plot(t_sim, x1_sim)
        plt.grid()
        plt.plot(t_meas, y_meas, 'x')
        plt.ylabel('x1')
        
        plt.subplot(2, 1, 2)
        plt.plot(t_sim, x2_sim)
        plt.grid()
        plt.ylabel('x2')
        plt.show()
    
    # Create MeasurementData object
    Q = N.array([[1.]])
    unconstrained = OrderedDict()
    unconstrained['sys.y'] = N.vstack([t_meas, y_meas])
    measurement_data = MeasurementData(Q=Q, unconstrained=unconstrained)
    
    # Set optimization options
    opts = opt_model.optimize_options()
    opts['measurement_data'] = measurement_data
    
    # Optimize
    opt_res = opt_model.optimize(options=opts)

    # Extract variable profiles
    x1_opt = opt_res['sys.x1']
    x2_opt = opt_res['sys.x2']
    w_opt = opt_res.final('sys.w')
    z_opt = opt_res.final('sys.z')
    t_opt = opt_res['time']
    
    # Assert results
    assert N.abs(opt_res.final('sys.x1') - 1.) < 1e-2
    assert N.abs(w_opt - 1.05)  < 1e-2
    assert N.abs(z_opt - 0.47)   < 1e-2
    
    # Plot optimization result
    if with_plots:
        plt.close(2)
        plt.figure(2)
        plt.subplot(2, 1, 1)
        plt.plot(t_opt, x1_opt, 'g')
        plt.plot(t_sim, x1_sim)
        plt.plot(t_meas, y_meas, 'x')
        plt.grid()
        plt.subplot(2, 1, 2)
        plt.plot(t_opt, x2_opt, 'g')
        plt.grid()
        plt.plot(t_sim, x2_sim)
        plt.show()
        
        print("** Optimal parameter values: **")
        print("w = %f" % w_opt)
        print("z = %f" % z_opt)

if __name__ == "__main__":
    run_demo()
