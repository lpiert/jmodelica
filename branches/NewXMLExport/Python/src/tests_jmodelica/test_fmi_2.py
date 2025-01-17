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

"""
Module containing the tests for the FMI interface.
"""

import nose
import os
import numpy as N
import sys as S

from tests_jmodelica import testattr, get_files_path
from pymodelica.compiler import compile_fmu
from pyfmi.fmi import FMUModel, FMUException, FMUModelME1, FMUModelCS1, load_fmu, FMUModelCS2, FMUModelME2, PyEventInfo
import pyfmi.fmi_algorithm_drivers as ad
from pyfmi.common.core import get_platform_dir
from pyjmi.log import parse_jmi_log, gather_solves
from pyfmi.common.io import ResultHandler

path_to_fmus = os.path.join(get_files_path(), 'FMUs')
path_to_fmus_me1 = os.path.join(path_to_fmus,"ME1.0")
path_to_fmus_cs1 = os.path.join(path_to_fmus,"CS1.0")
path_to_mofiles = os.path.join(get_files_path(), 'Modelica')

path_to_fmus_me2 = os.path.join(path_to_fmus,"ME2.0")
path_to_fmus_cs2 = os.path.join(path_to_fmus,"CS2.0")
ME2 = 'bouncingBall2_me.fmu'
CS2 = 'bouncingBall2_cs.fmu'
ME1 = 'bouncingBall.fmu'
CS1 = 'bouncingBall.fmu'
CoupledME2 = 'Modelica_Mechanics_Rotational_Examples_CoupledClutches_ME2.fmu'
CoupledCS2 = 'Modelica_Mechanics_Rotational_Examples_CoupledClutches_CS2.fmu'
Robot = 'Modelica_Mechanics_MultiBody_Examples_Systems_RobotR3_fullRobot_ME2.fmu'


class Test_FMUModelCS2:
    """
    This class tests pyfmi.fmi.FMUModelCS2
    """

    @testattr(windows = True)
    def test_init(self):
        """
        Test the method __init__ in FMUModelCS2
        """
        self._bounce=load_fmu(CS2, path_to_fmus_cs2, False)

        assert self._bounce.get_identifier() == 'BouncingBall2'
        nose.tools.assert_raises(FMUException, FMUModelCS2, fmu=ME2, path=path_to_fmus_me2)
        nose.tools.assert_raises(FMUException, FMUModelCS2, fmu=CS1, path=path_to_fmus_cs1)
        nose.tools.assert_raises(FMUException, FMUModelCS2, fmu=ME1, path=path_to_fmus_me1)

    @testattr(windows = True)
    def test_dealloc(self):
        """
        Test the method __dealloc__ in FMUModelCS2
        """
        pass

    @testattr(windows = True)
    def test_instantiate_slave(self):
        """
        Test the method instantiate_slave in FMUModelCS2
        """
        self._bounce=load_fmu(CS2, path_to_fmus_cs2, False)
        self._bounce.initialize()

        self._bounce.reset_slave() #Test multiple instantiation
        for i in range(0,10):
            name_of_slave = 'slave' + str(i)
            self._bounce.instantiate_slave(name = name_of_slave)

    @testattr(windows = True)
    def test_initialize(self):
        """
        Test the method initialize in FMUModelCS2
        """
        self._bounce=load_fmu(CS2, path_to_fmus_cs2, False)
        self._coupledCS2 = load_fmu(CoupledCS2, path_to_fmus_cs2, False)

        for i in range(10):
            self._bounce.initialize(relTol = 10**-i)  #Initialize multiple times with different relTol
            self._bounce.reset_slave()
        self._bounce.initialize()    #Initialize with default options
        self._bounce.reset_slave()

        self._bounce.initialize(tStart = 4.5)
        nose.tools.assert_almost_equal(self._bounce.time, 4.5)
        self._bounce.reset_slave()

        #Try to simulate past the defined stop
        self._coupledCS2.initialize(tStop=1.0 , StopTimeDefined = True)
        step_size=0.1
        total_time=0
        for i in range(10):
            self._coupledCS2.do_step(total_time, step_size)
            total_time += step_size
        status=self._coupledCS2.do_step(total_time, step_size)
        assert status != 0
        self._coupledCS2.reset_slave()

        #Try to initialize twice when not supported
        self._coupledCS2.initialize()
        nose.tools.assert_raises(FMUException, self._coupledCS2.initialize)

    @testattr(windows = True)
    def test_reset_slave(self):
        """
        Test the method reset_slave in FMUModelCS2
        """
        self._bounce=load_fmu(CS2, path_to_fmus_cs2, False)
        self._bounce.initialize()
        self._coupledCS2 = load_fmu(CoupledCS2, path_to_fmus_cs2, False)
        self._coupledCS2.initialize()

        self._bounce.reset_slave()
        self._bounce.initialize()
        self._coupledCS2.reset_slave()
        self._coupledCS2.initialize()


    @testattr(windows = True)
    def test_the_time(self):
        """
        Test the time in FMUModelCS2
        """
        self._bounce=load_fmu(CS2, path_to_fmus_cs2, False)
        self._bounce.initialize()

        assert self._bounce._get_time() == 0.0
        assert self._bounce.time == 0.0
        self._bounce._set_time(4.5)
        assert self._bounce._get_time() == 4.5
        self._bounce.time = 3
        assert self._bounce.time == 3.0

        self._bounce.reset_slave()
        self._bounce.initialize(tStart=2.5, tStop=3.0)
        assert self._bounce.time == 2.5

    @testattr(windows = True)
    def test_do_step(self):
        """
        Test the method do_step in FMUModelCS2
        """
        self._bounce=load_fmu(CS2, path_to_fmus_cs2, False)
        self._bounce.initialize()
        self._coupledCS2 = load_fmu(CoupledCS2, path_to_fmus_cs2, False)
        self._coupledCS2.initialize()

        new_step_size = 1e-1
        for i in range(1,30):
            current_time = self._bounce.time
            status = self._bounce.do_step(current_time, new_step_size, True)
            assert status == 0
            nose.tools.assert_almost_equal(self._bounce.time , current_time + new_step_size)


        for i in range(10):
            current_time = self._coupledCS2.time
            status = self._coupledCS2.do_step(current_time, new_step_size, True)
            assert status == 0
            nose.tools.assert_almost_equal(self._coupledCS2.time , current_time + new_step_size)
            self.test_get_status()

    @testattr(windows = True)
    def test_cancel_step(self):
        """
        Test the method cancel_step in FMUModelCS2
        """
        pass


    @testattr(windows = True)
    def test_set_input_derivatives(self):
        """
        Test the method set_input_derivatives in FMUModelCS2
        """

        #Do the setUp
        self._coupledCS2 = load_fmu(CoupledCS2, path_to_fmus_cs2, False)

        nose.tools.assert_raises(FMUException, self._coupledCS2.set_input_derivatives, 'J1.phi', 1.0, 0) #this is nou an input-variable
        nose.tools.assert_raises(FMUException, self._coupledCS2.set_input_derivatives, 'J1.phi', 1.0, 1)
        nose.tools.assert_raises(FMUException, self._coupledCS2.set_input_derivatives, 578, 1.0, 1)

    @testattr(windows = True)
    def test_get_output_derivatives(self):
        """
        Test the method get_output_derivatives in FMUModelCS2
        """
        self._coupledCS2 = load_fmu(CoupledCS2, path_to_fmus_cs2, False)
        self._coupledCS2.initialize()

        self._coupledCS2.do_step(0.0, 0.02)
        nose.tools.assert_raises(FMUException, self._coupledCS2.get_output_derivatives, 'J1.phi', 1)
        nose.tools.assert_raises(FMUException, self._coupledCS2.get_output_derivatives, 'J1.phi', -1)
        nose.tools.assert_raises(FMUException, self._coupledCS2.get_output_derivatives, 578, 0)

    @testattr(windows = True)
    def test_get_status(self):
        """
        Test the methods get status in FMUModelCS2
        """
        pass

    @testattr(windows = True)
    def test_simulate(self):
        """
        Test the main features of the method simulate() in FMUmodelCS2
        """
        #Set up for simulation
        self._bounce=load_fmu(CS2, path_to_fmus_cs2, False)
        self._coupledCS2 = load_fmu(CoupledCS2, path_to_fmus_cs2, False)

        #Try simulate the bouncing ball
        res=self._bounce.simulate()
        sim_time = res['time']
        nose.tools.assert_almost_equal(sim_time[0], 0.0)
        nose.tools.assert_almost_equal(sim_time[-1], 1.0)
        self._bounce.reset_slave()

        for i in range(5):
            res=self._bounce.simulate(start_time=0.1, final_time=1.0, options={'ncp':500})
            sim_time = res['time']
            nose.tools.assert_almost_equal(sim_time[0], 0.1)
            nose.tools.assert_almost_equal(sim_time[-1],1.0)
            assert sim_time.all() >= sim_time[0] - 1e-4   #Check that the time is increasing
            assert sim_time.all() <= sim_time[-1] + 1e+4  #Give it some marginal
            height = res['HIGHT']
            assert height.all() >= -1e-4 #The height of the ball should be non-negative
            nose.tools.assert_almost_equal(res.final('HIGHT'), 0.63489609999, 4)
            if i>0: #check that the results stays the same
                diff = height_old - height
                nose.tools.assert_almost_equal(diff[-1],0.0)
            height_old = height
            self._bounce.reset_slave()

        #Try to simulate the coupled-clutches
        res_coupled=self._coupledCS2.simulate()
        sim_time_coupled = res_coupled['time']
        nose.tools.assert_almost_equal(sim_time_coupled[0], 0.0)
        nose.tools.assert_almost_equal(sim_time_coupled[-1], 1.0)
        self._coupledCS2.reset_slave()


        for i in range(10):
            self._coupledCS2 = load_fmu(CoupledCS2, path_to_fmus_cs2, False)
            res_coupled = self._coupledCS2.simulate(start_time=0.0, final_time=2.0)
            sim_time_coupled = res_coupled['time']
            nose.tools.assert_almost_equal(sim_time_coupled[0], 0.0)
            nose.tools.assert_almost_equal(sim_time_coupled[-1],2.0)
            assert sim_time_coupled.all() >= sim_time_coupled[0] - 1e-4   #Check that the time is increasing
            assert sim_time_coupled.all() <= sim_time_coupled[-1] + 1e+4  #Give it some marginal

            #val_J1 = res_coupled['J1.w']
            #val_J2 = res_coupled['J2.w']
            #val_J3 = res_coupled['J3.w']
            #val_J4 = res_coupled['J4.w']

            val=[res_coupled.final('J1.w'), res_coupled.final('J2.w'), res_coupled.final('J3.w'), res_coupled.final('J4.w')]
            if i>0: #check that the results stays the same
                for j in range(len(val)):
                    nose.tools.assert_almost_equal(val[j], val_old[j])
            val_old = val
            self._coupledCS2.reset_slave()

        #Compare to something we know is correct
        cs1_model = load_fmu('Modelica_Mechanics_Rotational_Examples_CoupledClutches_CS.fmu',path_to_fmus_cs1, False)
        res1 = cs1_model.simulate(final_time=10, options={'result_file_name':'result1'})
        self._coupledCS2 = load_fmu(CoupledCS2, path_to_fmus_cs2, False)
        res2 = self._coupledCS2.simulate(final_time=10, options={'result_file_name':'result2'})
        diff1 = res1.final("J1.w") - res2.final("J1.w")
        diff2 = res1.final("J2.w") - res2.final("J2.w")
        diff3 = res1.final("J3.w") - res2.final("J3.w")
        diff4 = res1.final("J4.w") - res2.final("J4.w")
        nose.tools.assert_almost_equal(abs(diff1), 0.000, 1)
        nose.tools.assert_almost_equal(abs(diff2), 0.000, 1)
        nose.tools.assert_almost_equal(abs(diff3), 0.000, 1)
        nose.tools.assert_almost_equal(abs(diff4), 0.000, 1)

    @testattr(windows = True)
    def test_simulate_options(self):
        """
        Test the method simultaion_options in FMUModelCS2
        """
        #Do the setUp
        self._coupledCS2 = load_fmu(CoupledCS2, path_to_fmus_cs2, False)

        #Test the result file
        res=self._coupledCS2.simulate()
        assert res.result_file == 'Modelica_Mechanics_Rotational_Examples_CoupledClutches_result.txt'
        assert os.path.exists(res.result_file)

        self._coupledCS2.reset_slave()
        opts = {'result_file_name':'Modelica_Mechanics_Rotational_Examples_CoupledClutches_result_test.txt'}
        res=self._coupledCS2.simulate(options=opts)
        assert res.result_file == 'Modelica_Mechanics_Rotational_Examples_CoupledClutches_result_test.txt'
        assert os.path.exists(res.result_file)

        #Test the option in the simulate method
        self._coupledCS2.reset_slave()
        opts={}
        opts['ncp'] = 250
        opts['initialize'] = False
        self._coupledCS2.initialize()
        res=self._coupledCS2.simulate(options=opts)
        assert len(res['time']) == 251



class Test_FMUModelME2:
    """
    This class tests pyfmi.fmi.FMUModelME2
    """
    @testattr(windows = True)
    def test_init(self):
        """
        Test the method __init__ in FMUModelME2
        """
        bounce = load_fmu(ME2, path_to_fmus_me2, False)
        coupled = load_fmu(CoupledME2, path_to_fmus_me2)

        assert bounce.get_identifier() == 'BouncingBall2'
        nose.tools.assert_raises(FMUException, FMUModelME2, fmu=CS2, path=path_to_fmus_cs2, enable_logging=False)
        nose.tools.assert_raises(FMUException, FMUModelME2, fmu=CS1, path=path_to_fmus_cs1, enable_logging=False)
        nose.tools.assert_raises(FMUException, FMUModelME2, fmu=ME1, path=path_to_fmus_me1, enable_logging=False)

    @testattr(windows = True)
    def test_dealloc(self):
        """
        Test the method __dealloc__ in FMUModelME2
        """
        pass

    @testattr(windows = True)
    def test_instantiate_model(self):
        """
        Test the method instantiate_model in FMUModelME2
        """
        bounce = load_fmu(ME2, path_to_fmus_me2, False)
        coupled = load_fmu(CoupledME2, path_to_fmus_me2)

        for i in range(5):
            name1 = 'model1' + str(i)
            #name2 = 'model2' + str(i)
            #coupled.instantiate_model(name=name2)
            bounce.instantiate_model(name=name1)

    @testattr(windows = True)
    def test_initialize(self):
        """
        Test the method initialize in FMUModelME2
        """
        bounce = load_fmu(ME2, path_to_fmus_me2, False)
        coupled = load_fmu(CoupledME2, path_to_fmus_me2)

        coupled.initialize(tolControlled=False)
        nose.tools.assert_almost_equal(coupled.time, 0.0)
        nose.tools.assert_raises(FMUException, coupled.initialize, tolControlled=False) #Cant initialize twice in a row

        bounce.initialize()
        nose.tools.assert_almost_equal(bounce.time, 0.0)

        bounce.reset()
        bounce.initialize(relativeTolerance=1e-7)

    @testattr(windows = True)
    def test_reset(self):
        """
        Test the method reset in FMUModelME2
        """
        bounce = load_fmu(ME2, path_to_fmus_me2, False)
        coupled = load_fmu(CoupledME2, path_to_fmus_me2)

        bounce.initialize()
        coupled.initialize(tolControlled=False)

        bounce.reset()
        coupled.reset()

        assert bounce.time is None
        assert coupled.time is None

    @testattr(windows = True)
    def test_terminate(self):
        """
        Test the method terminate in FMUModelME2
        """
        coupled = load_fmu(CoupledME2, path_to_fmus_me2)
        coupled.initialize(tolControlled=False)
        coupled.terminate()

    @testattr(windows = True)
    def test_time(self):
        """
        Test the method get/set_time in FMUModelME2
        """
        bounce = load_fmu(ME2, path_to_fmus_me2, False)
        coupled = load_fmu(CoupledME2, path_to_fmus_me2)

        coupled.reset()
        assert coupled.time is None
        coupled.initialize(tolControlled=False)
        nose.tools.assert_almost_equal(coupled._get_time(), 0.0)
        coupled._set_time(2.71)
        nose.tools.assert_almost_equal(coupled.time , 2.71)
        coupled._set_time(1.00)
        nose.tools.assert_almost_equal(coupled._get_time() , 1.00)

        nose.tools.assert_raises(TypeError, coupled._set_time, '2.0')
        nose.tools.assert_raises(TypeError, coupled._set_time, N.array([1.0, 1.0]))

    @testattr(windows = True)
    def test_get_event_info(self):
        """
        Test the method get_event_info in FMUModelME2
        """
        bounce = load_fmu(ME2, path_to_fmus_me2, False)

        bounce.initialize()
        event = bounce.get_event_info()
        assert isinstance(event, PyEventInfo)

        assert event.iterationConverged          == False
        assert event.stateValueReferencesChanged == False
        assert event.stateValuesChanged          == False
        assert event.terminateSimulation         == False
        assert event.upcomingTimeEvent           == False
        assert event.nextEventTime               == 0.0

    @testattr(windows = True)
    def test_get_event_indicators(self):
        """
        Test the method get_event_indicators in FMUModelME2
        """
        bounce = load_fmu(ME2, path_to_fmus_me2, False)

        coupled = load_fmu(CoupledME2, path_to_fmus_me2)
        bounce.initialize()
        coupled.initialize(tolControlled=False)

        assert len(bounce.get_event_indicators()) == 1
        assert len(coupled.get_event_indicators()) == 54

        event_ind = bounce.get_event_indicators()
        nose.tools.assert_almost_equal(event_ind[0],1.000000)
        bounce.continuous_states = N.array([5.]*2)
        event_ind = bounce.get_event_indicators()
        nose.tools.assert_almost_equal(event_ind[0],5.000000)

    @testattr(windows = True)
    def test_event_update(self):
        """
        Test the method event_update in FMUModelME2
        """
        pass

    @testattr(windows = True)
    def test_get_tolerances(self):
        """
        Test the method get_tolerances in FMUModelME2
        """
        bounce = load_fmu(ME2, path_to_fmus_me2, False)
        coupled = load_fmu(CoupledME2, path_to_fmus_me2)
        bounce.initialize()
        coupled.initialize(tolControlled=False)

        [rtol,atol] = bounce.get_tolerances()

        assert rtol == 0.0001
        nose.tools.assert_almost_equal(atol[0],0.0000010)
        nose.tools.assert_almost_equal(atol[1],0.0000010)

        [rtol,atol] = coupled.get_tolerances()

        assert rtol == 0.0001
        nose.tools.assert_almost_equal(atol[0],0.0000010)

    @testattr(windows = True)
    def test_completed_event_iteration(self):
        """
        Test the method completed_event_iteration in FMUModelME2
        """
        pass

    @testattr(windows = True)
    def test_completed_integrator_step(self):
        """
        Test the method completed_integrator_step in FMUModelME2
        """
        pass

    @testattr(windows = True)
    def test_continuous_states(self):
        """
        Test the method get/set_continuous_states in FMUModelME2
        """
        bounce = load_fmu(ME2, path_to_fmus_me2, False)
        coupled = load_fmu(CoupledME2, path_to_fmus_me2)

        bounce.initialize()
        coupled.initialize(tolControlled=False)

        nx = bounce.get_ode_sizes()[0]
        states = bounce._get_continuous_states()
        assert nx == len(states)

        nose.tools.assert_almost_equal(states[0],1.000000)
        nose.tools.assert_almost_equal(states[1],4.000000)

        bounce.continuous_states = N.array([2.,-3.])
        states = bounce.continuous_states

        nose.tools.assert_almost_equal(states[0],2.000000)
        nose.tools.assert_almost_equal(states[1],-3.000000)

        n_states=bounce._get_nominal_continuous_states()
        assert nx == len(n_states)
        nose.tools.assert_almost_equal(n_states[0], 1.000000)
        nose.tools.assert_almost_equal(n_states[1], 1.000000)


        nx = coupled.get_ode_sizes()[0]
        states = coupled._get_continuous_states()
        assert nx == len(states)
        coupled._set_continuous_states(N.array([5.]*nx))
        states = coupled.continuous_states
        nose.tools.assert_almost_equal(states[-1], 5.000000)

        n_states=coupled._get_nominal_continuous_states()
        nose.tools.assert_almost_equal(n_states[0], 1.000000)
        n_states=coupled.nominal_continuous_states
        nose.tools.assert_almost_equal(n_states[0], 1.000000)

    @testattr(windows = True)
    def test_get_derivatives(self):
        """
        Test the method get_derivatives in FMUModelME2
        """
        bounce = load_fmu(ME2, path_to_fmus_me2, False)
        coupled = load_fmu(CoupledME2, path_to_fmus_me2)

        bounce.initialize()
        coupled.initialize(tolControlled=False)

        nx = bounce.get_ode_sizes()[0]
        der=bounce.get_derivatives()
        assert nx == len(der)

        nose.tools.assert_almost_equal(der[0], 4.000000)
        nose.tools.assert_almost_equal(der[1], -9.810000)

        bounce.set_real(1, 2.)
        bounce.set_real(2, -5.)
        der=bounce.get_derivatives()

        nose.tools.assert_almost_equal(der[0], 2.000000)
        nose.tools.assert_almost_equal(der[1], -5.000000)

        der_list = coupled.get_derivatives_list()
        der_ref  = N.array([s.value_reference for s in der_list.values()])
        der = coupled.get_derivatives()
        diff = N.sort(N.array([coupled.get_real(i) for i in der_ref]))-N.sort(der)
        nose.tools.assert_almost_equal(N.sum(diff), 0.)

    @testattr(windows = True)
    def test_get_directional_derivative(self):
        """
        Test the method get_directional_derivative in FMUModelME2
        """
        bounce = load_fmu(ME2, path_to_fmus_me2, False)

        coupled = load_fmu(CoupledME2, path_to_fmus_me2)

        bounce.initialize()
        coupled.initialize(tolControlled=False)

        nose.tools.assert_raises(FMUException, bounce.get_directional_derivative, [1], [1], [1])
        nose.tools.assert_raises(FMUException, coupled.get_directional_derivative, [1], [1], [1,2])

        states_list = coupled.get_states_list()
        der_list    = coupled.get_derivatives_list()
        states_ref  = [s.value_reference for s in states_list.values()]
        der_ref     = [s.value_reference for s in der_list.values()]

        nose.tools.assert_raises(FMUException, coupled.get_directional_derivative, [1], [der_ref[0]], [1])

        dir_der = coupled.get_directional_derivative(states_ref, der_ref, [1]*len(states_ref))
        assert len(dir_der) == len(der_list)
        nose.tools.assert_almost_equal(dir_der[1], 0)
        nose.tools.assert_almost_equal(dir_der[2], 1.000000)

        dir_der2 = coupled.get_directional_derivative(states_ref, der_ref, [2]*len(states_ref))
        assert len(dir_der) == len(der_list)
        diff = dir_der2 - 2*dir_der
        nose.tools.assert_almost_equal(sum(diff), 0)

    @testattr(windows = True)
    def test_simulate_options(self):
        """
        Test the method simulate_options in FMUModelME2
        """
        coupled = load_fmu(CoupledME2, path_to_fmus_me2)

        opts=coupled.simulate_options()
        assert opts['initialize']
        assert not opts['with_jacobian']
        assert opts['ncp'] == 0

        #Test the result file
        res=coupled.simulate()
        assert res.result_file == 'Modelica_Mechanics_Rotational_Examples_CoupledClutches_result.txt'
        assert os.path.exists(res.result_file)

        coupled.reset()
        opts = {'result_file_name':'Modelica_Mechanics_Rotational_Examples_CoupledClutches_result_test.txt'}
        res=coupled.simulate(options=opts)
        assert res.result_file == 'Modelica_Mechanics_Rotational_Examples_CoupledClutches_result_test.txt'
        assert os.path.exists(res.result_file)

        #Test the option in the simulate method
        coupled.reset()
        opts={}
        opts['ncp'] = 250
        opts['initialize'] = False
        coupled.initialize(tolControlled=False)
        res=coupled.simulate(options=opts)
        assert len(res['time']) > 250

    @testattr(windows = True)
    def test_simulate(self):
        """
        Test the method simulate in FMUModelME2
        """
        bounce = load_fmu(ME2, path_to_fmus_me2, False)
        coupled = load_fmu(CoupledME2, path_to_fmus_me2)

        #Try simulate the bouncing ball
        res=bounce.simulate()
        sim_time = res['time']
        nose.tools.assert_almost_equal(sim_time[0], 0.0)
        nose.tools.assert_almost_equal(sim_time[-1], 1.0)
        bounce.reset()

        opts = bounce.simulate_options()
        opts["CVode_options"]["rtol"] = 1e-6
        opts["CVode_options"]["atol"] = 1e-6
        opts["ncp"] = 500

        for i in range(5):
            res=bounce.simulate(start_time=0.1, final_time=1.0, options=opts)
            sim_time = res['time']
            nose.tools.assert_almost_equal(sim_time[0], 0.1)
            nose.tools.assert_almost_equal(sim_time[-1],1.0)
            assert sim_time.all() >= sim_time[0] - 1e-4   #Check that the time is increasing
            assert sim_time.all() <= sim_time[-1] + 1e+4  #Give it some marginal
            height = res['HIGHT']
            assert height.all() >= -1e-4 #The height of the ball should be non-negative
            nose.tools.assert_almost_equal(res.final('HIGHT'), 0.6269474005, 4)
            if i>0: #check that the results stays the same
                diff = height_old - height
                nose.tools.assert_almost_equal(diff[-1],0.0)
            height_old = height
            bounce.reset()

        #Try to simulate the coupled-clutches
        res_coupled=coupled.simulate()
        sim_time_coupled = res_coupled['time']
        nose.tools.assert_almost_equal(sim_time_coupled[0], 0.0)
        nose.tools.assert_almost_equal(sim_time_coupled[-1], 1.0)
        coupled.reset()


        for i in range(10):
            res_coupled = coupled.simulate(start_time=0.0, final_time=2.0)
            sim_time_coupled = res_coupled['time']
            nose.tools.assert_almost_equal(sim_time_coupled[0], 0.0)
            nose.tools.assert_almost_equal(sim_time_coupled[-1],2.0)
            assert sim_time_coupled.all() >= sim_time_coupled[0] - 1e-4   #Check that the time is increasing
            assert sim_time_coupled.all() <= sim_time_coupled[-1] + 1e+4  #Give it some marginal

            #val_J1 = res_coupled['J1.w']
            #val_J2 = res_coupled['J2.w']
            #val_J3 = res_coupled['J3.w']
            #val_J4 = res_coupled['J4.w']

            val=[res_coupled.final('J1.w'), res_coupled.final('J2.w'), res_coupled.final('J3.w'), res_coupled.final('J4.w')]
            if i>0: #check that the results stays the same
                for j in range(len(val)):
                    nose.tools.assert_almost_equal(val[j], val_old[j])
            val_old = val
            coupled.reset()

        #Compare to something we know is correct
        me1_model = load_fmu('Modelica_Mechanics_Rotational_Examples_CoupledClutches_ME.fmu',path_to_fmus_me1, False)
        res1 = me1_model.simulate(final_time=2., options={'result_file_name':'result1'})
        coupled = load_fmu(CoupledME2, path_to_fmus_me2, False)
        res2 = coupled.simulate(final_time=2., options={'result_file_name':'result2'})
        diff1 = res1.final("J1.w") - res2.final("J1.w")
        diff2 = res1.final("J2.w") - res2.final("J2.w")
        diff3 = res1.final("J3.w") - res2.final("J3.w")
        diff4 = res1.final("J4.w") - res2.final("J4.w")
        nose.tools.assert_almost_equal(abs(diff1), 0.0000, 2)
        nose.tools.assert_almost_equal(abs(diff2), 0.0000, 2)
        nose.tools.assert_almost_equal(abs(diff3), 0.0000, 2)
        nose.tools.assert_almost_equal(abs(diff4), 0.0000, 2)

        #Try simualte the robot
        robot = load_fmu(Robot, path_to_fmus_me2)
        result = robot.simulate()


