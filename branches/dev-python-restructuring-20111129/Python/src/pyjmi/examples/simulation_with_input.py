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

import os

import numpy as N
import pylab as p

from jmodelica.compiler import compile_jmu
from pyjmi.jmi import JMUModel

def run_demo(with_plots=True):
    """
    Demonstrates how to simulate with inputs.
    """

    curr_dir = os.path.dirname(os.path.abspath(__file__));

    model_name = 'SecondOrder'
    mofile = curr_dir+'/files/SecondOrder.mo'

    # Generate input
    t = N.linspace(0.,10.,100) 
    u = N.cos(t)
    u_traj = N.transpose(N.vstack((t,u)))
    
    # Compile the Modelica model to JMU
    jmu_name = compile_jmu(model_name,mofile)

    # Load the dynamic library and XML data
    model=JMUModel(jmu_name)

    model.set('u',u[0])
    
    res = model.simulate(final_time=30, input=('u',u_traj),
        options={'ncp':3000})
    
    x1_sim = res['x1']
    x2_sim = res['x2']
    u_sim = res['u']
    t_sim = res['time']
    
    assert N.abs(x1_sim[-1]*1.e1 - (-8.3999640)) < 1e-3, \
            "Wrong value of x1_sim function in simulation_with_input.py"

    assert N.abs(x2_sim[-1]*1.e1 - (-5.0691179)) < 1e-3, \
            "Wrong value of x2_sim function in simulation_with_input.py"  

    assert N.abs(u_sim[-1]*1.e1 - (-8.3907153)) < 1e-3, \
            "Wrong value of u_sim function in simulation_with_input.py"  



#    assert N.abs(resistor_v.x[-1] - 0.159255008028) < 1e-3, \
#           "Wrong value in simulation result in RLC.py"


    if with_plots:
        fig = p.figure()
        p.clf()
        p.subplot(2,1,1)
        p.plot(t_sim, x1_sim, t_sim, x2_sim)
        p.subplot(2,1,2)
        p.plot(t_sim, u_sim,'x-',t, u[:],'x-')

        p.show()


if __name__=="__main__":
    run_demo()
