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

# Import numerical libraries
import numpy as N
import matplotlib.pyplot as plt

# Import the JModelica.org Python packages
from pymodelica import compile_fmu
from pyfmi import FMUModel

def run_demo(with_plots=True):
    """
    Distillation1 model
    """
    
    curr_dir = os.path.dirname(os.path.abspath(__file__));

    fmu_name1 = compile_fmu("JMExamples.Distillation.Distillation1", 
    curr_dir+"/files/JMExamples.mo")
    dist1 = FMUModel(fmu_name1)
    
    res = dist1.simulate(final_time=7200)

    # Extract variable profiles
    x16	= res['x[16]']
    x32	= res['x[32]']
    y16	= res['y[16]']
    y32	= res['y[32]']
    t	= res['time']
    
    print "t = ", repr(N.array(t))
    print "x16 = ", repr(N.array(x16))
    print "x32 = ", repr(N.array(x32))
    print "y16 = ", repr(N.array(y16))
    print "y32 = ", repr(N.array(y32))

    if with_plots:
        # Plot
        plt.figure(1)
        plt.subplot(2,1,1)
        plt.plot(t,x16,t,x32)
        plt.title('Liquid composition')
        plt.grid(True)
        plt.ylabel('x')
        plt.subplot(2,1,2)
        plt.plot(t,y16,t,y32)
        plt.title('Vapor composition')
        plt.grid(True)
        plt.ylabel('y')
        
        plt.xlabel('time')
        plt.show()

if __name__ == "__main__":
    run_demo()
