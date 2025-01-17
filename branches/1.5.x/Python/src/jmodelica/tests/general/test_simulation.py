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
Module for testing Simulation.
"""
import numpy as N

from jmodelica.tests.general.base_simul import *
from jmodelica.tests import testattr

class TestNominal(SimulationTest):

    @classmethod
    def setUpClass(cls):
        SimulationTest.setup_class_base(
                'NominalTest.mop', 'NominalTests.NominalTest1',
                    options={"enable_variable_scaling":True})

    @testattr(assimulo = True)
    def setUp(self):
        self.setup_base(start_time=0.0, final_time=10.0, 
            time_step = 0.1, abs_tol=1.0e-8)
        self.run()
        self.load_expected_data('NominalTests_NominalTest1_result.txt')

    @testattr(assimulo = True)
    def test_trajectories(self):
        self.assert_all_trajectories(['x', 'y', 'z', 'der(x)', 'der(y)'])

class TestFunction1(SimulationTest):

    @classmethod
    def setUpClass(cls):
        SimulationTest.setup_class_base(
            'FunctionAR.mo', 'FunctionAR.UnknownArray1')

    @testattr(assimulo = True)
    def setUp(self):
        self.setup_base(start_time=0.0, final_time=1.0, time_step = 0.002, 
            rel_tol=1.0e-2, abs_tol=1.0e-2)
        self.run()
        self.load_expected_data('UnknownArray.txt')

    @testattr(assimulo = True)
    def test_trajectories(self):
        vars = ['x[%d]' % i for i in range(1, 4)]
        self.assert_all_trajectories(vars, same_span=True)


class TestFunction2(SimulationTest):

    @classmethod
    def setUpClass(cls):
        SimulationTest.setup_class_base(
            'FunctionAR.mo', 'FunctionAR.FuncRecord1')

    @testattr(assimulo = True)
    def setUp(self):
        self.setup_base(start_time=0.0, final_time=1.0, time_step = 0.002, 
            rel_tol=1.0e-2)
        self.run()
        self.load_expected_data('FuncRecord.txt')

    @testattr(assimulo = True)
    def test_trajectories(self):
        self.assert_all_trajectories(['x', 'r.a'], same_span=True)


class TestStreams1(SimulationTest):

    @classmethod
    def setUpClass(cls):
        SimulationTest.setup_class_base(
            'StreamExample.mo', 
            'StreamExample.Examples.Systems.HeatedGas_SimpleWrap',
            options={'enable_variable_scaling':True})

    @testattr(assimulo = True)
    def setUp(self):
        self.setup_base(start_time=0.0, final_time=10, time_step = 0.1,)
        self.run()
        self.load_expected_data(
            'StreamExample_Examples_Systems_HeatedGas_SimpleWrap_result.txt')

    @testattr(assimulo = True)
    def test_trajectories(self):
        self.assert_all_trajectories(['linearResistanceWrap.port_a.m_flow',
                                      'linearResistanceWrap.linearResistance.port_a.p',
                                      'linearResistanceWrap.linearResistance.port_a.h_outflow',
                                      ], same_span=True, rel_tol=1e-2, abs_tol=1e-2)

class TestStreams2(SimulationTest):

    @classmethod
    def setUpClass(cls):
        SimulationTest.setup_class_base(
            'StreamExample.mo', 'StreamExample.Examples.Systems.HeatedGas',
            options={'enable_variable_scaling':True})

    @testattr(assimulo = True)
    def setUp(self):
        self.setup_base(start_time=0.0, final_time=10, time_step = 0.1,)
        self.run()
        self.load_expected_data(
            'StreamExample_Examples_Systems_HeatedGas_result.txt')

    @testattr(assimulo = True)
    def test_trajectories(self):
        self.assert_all_trajectories(['linearResistance.port_a.m_flow',
                                      'multiPortVolume.flowPort[1].h_outflow'
                                      ], same_span=True, rel_tol=1e-2, abs_tol=1e-2)
                                      
class TestEnumerations(SimulationTest):
    
    @classmethod
    def setUpClass(cls):
        SimulationTest.setup_class_base(
            'Enumerations.mo', 'Enumerations.Enumeration1')

    @testattr(assimulo = True)
    def setUp(self):
        self.setup_base()
        
    def check_init(self, val):
        self.model.initialize();
        assert self.model.get('x') == val

    @testattr(assimulo = True)
    def test_enumerations_1(self):
        self.check_init(7)
        
        
    @testattr(assimulo = True)
    def test_enumerations_2(self):
        self.model.set('y',2)
        self.check_init(9)

class TestHybrid1(SimulationTest):
    
    @classmethod
    def setUpClass(cls):
        SimulationTest.setup_class_base(
            'HybridTests.mo', 'HybridTests.WhenEqu2',
            options={'compliance_as_warning':True},format='fmu')

    @testattr(assimulo = True)
    def setUp(self):
        self.setup_base(start_time=0.0, final_time=4, time_step = 0.01)
        self.run()
        self.load_expected_data(
            'HybridTests_WhenEqu2_result.txt')

    @testattr(assimulo = True)
    def test_trajectories(self):
        self.assert_all_trajectories(['x','y','z','w','v'], same_span=True, rel_tol=1e-3, abs_tol=1e-3)


class TestHybrid2(SimulationTest):
    
    @classmethod
    def setUpClass(cls):
        SimulationTest.setup_class_base(
            'HybridTests.mo', 'HybridTests.WhenEqu3',
            options={'compliance_as_warning':True},format='fmu')

    @testattr(assimulo = True)
    def setUp(self):
        self.setup_base(start_time=0.0, final_time=4, time_step = 0.01)
        self.run()
        self.load_expected_data(
            'HybridTests_WhenEqu3_result.txt')

    @testattr(assimulo = True)
    def test_trajectories(self):
        self.assert_all_trajectories(['b1','x','y','z','w','v'], same_span=True, rel_tol=1e-3, abs_tol=1e-3)


class TestHybrid3(SimulationTest):
  
    @classmethod
    def setUpClass(cls):
        SimulationTest.setup_class_base(
            'HybridTests.mo', 'HybridTests.WhenEqu5',
            options={'compliance_as_warning':True},format='fmu')

    @testattr(assimulo = True)
    def setUp(self):
        self.setup_base(start_time=0.0, final_time=2, time_step = 0.01,rel_tol=1e-6, abs_tol=1e-6)
        self.run()
        self.load_expected_data(
            'HybridTests_WhenEqu5_result.txt')

    @testattr(assimulo = True)
    def test_trajectories(self):
        self.assert_all_trajectories(['x','y','z','a','h1','h2'], same_span=True, rel_tol=1e-3, abs_tol=1e-3)


class TestHybrid4(SimulationTest):
    
    @classmethod
    def setUpClass(cls):
        SimulationTest.setup_class_base(
            'HybridTests.mo', 'HybridTests.WhenEqu8',
            options={'compliance_as_warning':True},format='fmu')

    @testattr(assimulo = True)
    def setUp(self):
        self.setup_base(start_time=0.0, final_time=10, time_step = 0.01)
        self.run()
        self.load_expected_data(
            'HybridTests_WhenEqu8_result.txt')

    @testattr(assimulo = True)
    def test_trajectories(self):
        self.assert_all_trajectories(['x','y'], same_span=True, rel_tol=1e-3, abs_tol=1e-3)


class TestHybrid5(SimulationTest):
    
    @classmethod
    def setUpClass(cls):
        SimulationTest.setup_class_base(
            'HybridTests.mo', 'HybridTests.WhenEqu9',
            options={'compliance_as_warning':True},format='fmu')

    @testattr(assimulo = True)
    def setUp(self):
        self.setup_base(start_time=0.0, final_time=10, time_step = 0.01)
        self.run()
        self.load_expected_data(
            'HybridTests_WhenEqu9_result.txt')

    @testattr(assimulo = True)
    def test_trajectories(self):
        self.assert_all_trajectories(['x','u','ref','I'], same_span=True, rel_tol=1e-3, abs_tol=1e-3)

class TestHybrid6(SimulationTest):
    
    @classmethod
    def setUpClass(cls):
        SimulationTest.setup_class_base(
            'HybridTests.mo', 'HybridTests.WhenEqu10',
            options={'compliance_as_warning':True},format='fmu')

    @testattr(assimulo = True)
    def setUp(self):
        self.setup_base(start_time=0.0, final_time=10, time_step = 0.01)
        self.run()
        self.load_expected_data(
            'HybridTests_WhenEqu10_result.txt')

    @testattr(assimulo = True)
    def test_trajectories(self):
        self.assert_all_trajectories(['x','y'], same_span=True, rel_tol=1e-3, abs_tol=1e-3)

class TestHybrid7(SimulationTest):
    
    @classmethod
    def setUpClass(cls):
        SimulationTest.setup_class_base(
            'HybridTests.mo', 'HybridTests.ZeroOrderHold1',
            options={'compliance_as_warning':True},format='fmu')

    @testattr(assimulo = True)
    def setUp(self):
        self.setup_base(start_time=0.0, final_time=10, time_step = 0.01)
        self.run()
        self.load_expected_data(
            'HybridTests_ZeroOrderHold1_result.txt')

    @testattr(assimulo = True)
    def test_trajectories(self):
        self.assert_all_trajectories(['expSine.y','sampler.y'], same_span=True, rel_tol=1e-3, abs_tol=1e-3)


    




