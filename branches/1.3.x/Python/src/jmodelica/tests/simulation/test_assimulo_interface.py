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

"""Tests for the jmodelica.simulation.assimulo module."""
import warnings
import nose
import os
import numpy as N
import jmodelica
import jmodelica.jmi as jmi
import jmodelica.fmi as fmi
from jmodelica.compiler import ModelicaCompiler
from jmodelica.compiler import OptimicaCompiler
from jmodelica.io import ResultDymolaTextual
from jmodelica.tests import testattr
from jmodelica.tests import get_files_path
from jmodelica import simulate

try:
    from jmodelica.simulation.assimulo_interface import JMIODE, JMIDAE, FMIODE, JMIModel_Exception
    from jmodelica.simulation.assimulo_interface import write_data
    from jmodelica.simulation.assimulo_interface import TrajectoryLinearInterpolation
    from assimulo.explicit_ode import CVode
except NameError, ImportError:
    warnings.warn('Could not load Assimulo module. Check jmodelica.check_packages()')


mc = ModelicaCompiler()
oc = OptimicaCompiler()
oc.set_boolean_option('state_start_values_fixed',True)
path_to_fmus = os.path.join(get_files_path(), 'FMUs')

class Test_JMI_ODE:
    """
    This class tests jmodelica.simulation.assimulo.JMIODE
    """
    
    @classmethod
    def setUpClass(cls):
        """
        Compile the test model.
        """
        fpath_ODE = os.path.join(get_files_path(), 'Modelica', 'VDP.mo')
        cpath_ODE = 'VDP_pack.VDP_Opt'
        fname_ODE = cpath_ODE.replace('.','_',1)
        
        oc.compile_model(cpath_ODE, fpath_ODE)
        
    def setUp(self):
        """Load the test model."""
        package_ODE = 'VDP_pack_VDP_Opt'

        # Load the dynamic library and XML data
        self.m_ODE = jmi.Model(package_ODE)
        
        # Creates the solvers
        self.ODE = JMIODE(self.m_ODE)
    
    @testattr(assimulo = True)
    def test_input(self):
        """
        Tests the input.
        """
        t = N.linspace(1,10.,100)
        u = (0.75)*N.ones(N.size(t,0))
        u_traj = TrajectoryLinearInterpolation(t,u.reshape(100,1))
        
        self.ODE.input = u_traj
        
        vdp_sim = CVode(self.ODE)

        vdp_sim(10,100)
    
        write_data(vdp_sim)
    
        # Load the file we just wrote to file
        res = jmodelica.io.ResultDymolaTextual('VDP_pack_VDP_Opt_result.txt')
    
        x1=res.get_variable_data('x1')
        x2=res.get_variable_data('x2')
        u =res.get_variable_data('u')
        
        assert u.x[-1] == 0.75
        nose.tools.assert_almost_equal(x1.x[-1], -0.54108518, 5)
        nose.tools.assert_almost_equal(x2.x[-1], -0.81364915, 5)

        
    
    @testattr(assimulo = True) 
    def test_init(self):
        """
        Tests jmodelica.simulation.assimulo.JMIODE.__init__
        """
        assert self.m_ODE == self.ODE._model
        
        for i in range(len(self.ODE.y0)):
            assert self.m_ODE.real_x[i] == self.ODE.y0[i]
            
        #Test for algebraic variables
        fpath_DAE = os.path.join(get_files_path(), 'Modelica', 'RLC_Circuit.mo')
        cpath_DAE = 'RLC_Circuit'
        fname_DAE = cpath_DAE.replace('.','_',1)
        mc.compile_model(cpath_DAE, fpath_DAE)
        package_DAE = 'RLC_Circuit'
        # Load the dynamic library and XML data
        m_DAE = jmi.Model(package_DAE)
        
        nose.tools.assert_raises(JMIModel_Exception, JMIODE, m_DAE)
        

        #Test for discontinious model
        fpath_DISC = os.path.join(get_files_path(), 'Modelica', 'IfExpExamples.mo')
        cpath_DISC = 'IfExpExamples.IfExpExample2'
        fname_DISC = cpath_DISC.replace('.','_',1)
        mc.compile_model(cpath_DISC, fpath_DISC)
        package_DISC = 'IfExpExamples_IfExpExample2'
        # Load the dynamic library and XML data
        m_DISC = jmi.Model(package_DISC)
        
        nose.tools.assert_raises(JMIModel_Exception, JMIODE, m_DISC)
    
    @testattr(assimulo = True) 
    def test_f(self):
        """
        Tests jmodelica.simulation.assimulo.JMIODE.f
        """
        test_x = N.array([1.,1.,1.])
        test_t = 2
        
        temp_rhs = self.ODE.f(test_t,test_x)
        
        assert temp_rhs[0] == -1.0
        assert temp_rhs[1] == 1.0
        nose.tools.assert_almost_equal(temp_rhs[2], 14.77811, 5)
    
    @testattr(assimulo = True) 
    def test_j(self):
        """
        Tests jmodelica.simulation.assimulo.JMIODE.j
        """
        test_x = N.array([1.,1.,1.])
        test_t = 2
        
        temp_j = self.ODE.j(test_t,test_x)
        print temp_j
        assert temp_j[0,0] == 0.0
        assert temp_j[0,1] == -3.0
        assert temp_j[0,2] == 0.0
        assert temp_j[1,0] == 1.0
        assert temp_j[1,1] == 0.0
        assert temp_j[1,2] == 0.0
        nose.tools.assert_almost_equal(temp_j[2,0], 14.7781122, 5)
        nose.tools.assert_almost_equal(temp_j[2,1], 14.7781122, 5)
        assert temp_j[2,2] == 0.0
    
    @testattr(assimulo = True) 
    def test_reset(self):
        """
        Tests jmodelica.simulation.assimulo.JMIODE.reset
        """
        self.ODE.t0 = 10.0
        self.ODE._model.real_x = N.array([2.,2.,2.])
        
        self.ODE.reset()
        
        assert self.ODE._model.t == 10.0
        assert self.ODE._model.real_x[0] != 2.0
        assert self.ODE._model.real_x[1] != 2.0
        assert self.ODE._model.real_x[2] != 2.0
    
    @testattr(assimulo = True) 
    def test_g(self):
        """
        Tests jmodelica.simulation.assimulo.JMIODE.g
        """
        #This is not implemented in JMIODE yet.
        pass
        
class Test_JMI_DAE:
    """
    This class tests jmodelica.simulation.assimulo.JMIDAE
    """
    
    @classmethod
    def setUpClass(cls):
        """
        Compile the test model.
        """
        #DAE test model
        fpath_DAE = os.path.join(get_files_path(), 'Modelica', 'Pendulum_pack_no_opt.mo')
        cpath_DAE = 'Pendulum_pack.Pendulum'
        fname_DAE = cpath_DAE.replace('.','_',1)

        mc.compile_model(cpath_DAE, fpath_DAE)
        
        fpath_DISC = os.path.join(get_files_path(), 'Modelica', 'IfExpExamples.mo')
        cpath_DISC = 'IfExpExamples.IfExpExample2'
        fname_DISC = cpath_DISC.replace('.','_',1)

        mc.compile_model(cpath_DISC, fpath_DISC)
        
    def setUp(self):
        """Load the test model."""
        package_DAE = 'Pendulum_pack_Pendulum'
        package_DISC = 'IfExpExamples_IfExpExample2'

        # Load the dynamic library and XML data
        self.m_DAE = jmi.Model(package_DAE)
        self.m_DISC = jmi.Model(package_DISC)
        
        # Creates the solvers
        self.DAE = JMIDAE(self.m_DAE)
        self.DISC = JMIDAE(self.m_DISC)
    
    @testattr(assimulo = True) 
    def test_eps(self):
        """
        Tests jmodelica.simulation.assimulo.JMIDAE.get/set_eps
        """
        nose.tools.assert_raises(JMIModel_Exception, self.DAE._set_eps, 'Test')
        nose.tools.assert_raises(JMIModel_Exception, self.DAE._set_eps, -1)
        nose.tools.assert_raises(JMIModel_Exception, self.DAE._set_eps, 1)
        nose.tools.assert_raises(JMIModel_Exception, self.DAE._set_eps, -1.0)
        
        self.DAE.eps = 1.0
        assert self.DAE.eps == 1.0
        self.DAE.eps = 10.0
        assert self.DAE.eps == 10.0
    
    @testattr(assimulo = True) 
    def test_max_eIteration(self):
        """
        Tests jmodelica.simulation.assimulo.JMIDAE.get/set_max_eIteration
        """
        nose.tools.assert_raises(JMIModel_Exception, self.DAE._set_max_eIteration, 'Test')
        nose.tools.assert_raises(JMIModel_Exception, self.DAE._set_max_eIteration, -1)
        nose.tools.assert_raises(JMIModel_Exception, self.DAE._set_max_eIteration, 1.0)
        nose.tools.assert_raises(JMIModel_Exception, self.DAE._set_max_eIteration, -1.0)
        
        self.DAE.max_eIter = 1
        assert self.DAE.max_eIter == 1
        self.DAE.max_eIter = 10
        assert self.DAE.max_eIter == 10
    
    @testattr(assimulo = True) 
    def test_check_eIter(self):
        """
        Tests jmodelica.simulation.assimulo.JMIDAE.check_eIter
        """
        self.DAE.eps = 1e-4
        
        b_mode = [1, -1, 0]
        a_mode = [-1, 1, 1]
        
        [eIter, iter] = self.DAE.check_eIter(b_mode, a_mode)
        
        assert iter == True
        assert eIter[0] == -1
        assert eIter[1] == 1
        assert eIter[2] == 1
        
        b_mode = [2, 5, 1]
        a_mode = [0, 2, 2]
        
        [eIter, iter] = self.DAE.check_eIter(b_mode, a_mode)
        
        assert iter == False
        assert eIter[0] == 0
        assert eIter[1] == 0
        assert eIter[2] == 0
    
    @testattr(assimulo = True) 
    def test_event_switch(self):
        """
        Tests jmodelica.simulation.assimulo.JMIDAE.event_switch
        """
        solver = lambda x:1
        solver.verbosity = 1
        solver.LOUD = 2
        solver.switches = [False, False, True]
        event_info = [1, 0, -1]
        
        self.DAE.event_switch(solver,event_info)
        
        assert solver.switches[0] == True
        assert solver.switches[1] == False
        assert solver.switches[2] == False
    
    @testattr(assimulo = True) 
    def test_f(self):
        """
        Tests jmodelica.simulation.assimulo.JMIDAE.f
        """
        test_x = N.array([1.,1.,1.,1.])
        test_dx = N.array([2.,2.,2.,2.])
        test_t = 2
        
        temp_f = self.DAE.f(test_t,test_x,test_dx)
        
        assert temp_f[0] == -1.0
        assert temp_f[2] == -1.0
        assert temp_f[3] == -2.0
        nose.tools.assert_almost_equal(temp_f[1], -1.158529, 5)
    
    @testattr(assimulo = True) 
    def test_g(self):
        """
        Tests jmodelica.simulation.assimulo.JMIDAE.g
        """
        temp_g = self.DISC.g(2.,[1.,2.],[2.,0],[0,0])
        
        nose.tools.assert_almost_equal(temp_g[0], -0.429203, 5)
        nose.tools.assert_almost_equal(temp_g[1], 1.141592, 5)
    
    @testattr(assimulo = True) 
    def test_g_adjust(self):
        """
        Tests jmodelica.simulation.assimulo.JMIDAE.g
        """
        self.DISC.eps = 2.0

        temp_g_adjust = self.DISC.g_adjust(2.,[1.,2.],[2.,0],[0,0])

        nose.tools.assert_almost_equal(temp_g_adjust[0], -2.429203, 5)
        nose.tools.assert_almost_equal(temp_g_adjust[1], -0.858407, 5)
        
        temp_g_adjust = self.DISC.g_adjust(2.,[1.,2.],[2.,0],[0,1])
        
        nose.tools.assert_almost_equal(temp_g_adjust[0], -2.429203, 5)
        nose.tools.assert_almost_equal(temp_g_adjust[1], 3.141592, 5)
        
    @testattr(assimulo = True) 
    def test_init(self):
        """
        Tests jmodelica.simulation.assimulo.JMIDAE.__init__
        """
        assert self.m_DAE == self.DAE._model
        assert self.DAE.max_eIter == 50
        assert self.DAE.eps == 1e-9
        assert self.DAE.jac == self.DAE.j
        
        temp_y0 = N.append(self.m_DAE.real_x.copy(), self.m_DAE.real_w.copy())
        temp_yd0 = N.append(self.m_DAE.real_dx.copy(),[0]*len(self.m_DAE.real_w))
        temp_algvar = [1.0]*len(self.m_DAE.real_x) + [0.0]*len(self.m_DAE.real_w)
        
        for i in range(len(temp_y0)):
            assert temp_y0[i] == self.DAE.y0[i]
            assert temp_yd0[i] == self.DAE.yd0[i]
            assert temp_algvar[i] == self.DAE.algvar[i]
            
        #Test discontiniuous system
        assert self.DISC._g_nbr == 2
        assert self.DISC.state_events == self.DISC.g_adjust
    
    @testattr(assimulo = True) 
    def test_reset(self):
        """
        Tests jmodelica.simulation.assimulo.JMIDAE.reset
        """   
        self.DAE.t0 = 10.0
        self.DAE._model.real_x = N.array([2.,2.,2.,2.])
        self.DAE._model.real_dx = N.array([2.,2.,2.,2.])

        self.DAE.reset()
        
        assert self.DAE._model.t == 10.0
        assert self.DAE._model.real_x[0] != 2.0
        assert self.DAE._model.real_x[1] != 2.0
        assert self.DAE._model.real_x[2] != 2.0
        assert self.DAE._model.real_dx[0] != 2.0
        assert self.DAE._model.real_dx[1] != 2.0
        assert self.DAE._model.real_dx[2] != 2.0        
       
        assert self.DAE.y0[0] == 0.1

    @testattr(assimulo = True) 
    def test_j(self):
        """
        Tests jmodelica.simulation.assimulo.JMIDAE.j
        """
        
        test_x = N.array([1.,1.,1.,1.])
        test_dx = N.array([2.,2.,2.,2.])
        test_t = 2
        
        temp_j = self.DAE.j(0.1,test_t,test_x,test_dx)
        print temp_j
        assert temp_j[0,0] == -0.1
        assert temp_j[0,1] == 1.0
        assert temp_j[1,1] == -0.1
        nose.tools.assert_almost_equal(temp_j[1,0], 0.5403023, 5)
    
    @testattr(assimulo = True) 
    def test_handle_event(self):
        """
        Tests jmodelica.simulation.assimulo.JMIDAE.handle_event
        """
        solver = lambda x:1
        solver.verbosity = 1
        solver.NORMAL = solver.LOUD = 2
        solver.t = [[1.0]]
        solver.y = [[1.,1.]]
        solver.yd = [[1.,1.]]
        solver.t_cur = N.array(1.0)
        solver.y_cur = N.array([1.,1.])
        solver.yd_cur = N.array([1.,1.])
        solver.switches = [False,True]
        self.DISC.event_switch = lambda x,y:1
        self.DISC.init_mode = lambda x:1
        self.DISC.check_eIter = lambda x,y: [True,False]
        
        self.DISC.handle_event(solver, [1,1])
        
        self.DISC.check_eIter = lambda x,y: [True,True]
        
        self.DISC.handle_event(solver, [1,1])

    @testattr(assimulo = True) 
    def test_init_mode(self):
        """
        Tests jmodelica.simulation.assimulo.init_mode
        """
        solver = lambda x:1
        solver.switches = [True, True]
        solver.make_consistency = lambda x:1
        
        self.DISC.init_mode(solver)
        
        assert self.DISC._model.sw[0] == 1
        assert self.DISC._model.sw[1] == 1
    
    @testattr(assimulo = True) 
    def test_initiate(self):
        """
        Tests jmodelica.simulation.assimulo.initiate
        """
        self.DAE.init_mode = lambda x:1
        self.DAE.initiate('Test')
        
        self.DISC.handle_event = lambda x,y:1
        solver = lambda x:1
        solver.switches = [False, False]
        
        self.DISC.initiate(solver)

        assert solver.switches[0] == True
        assert solver.switches[1] == True

class Test_FMI_ODE:
    """
    This class tests jmodelica.simulation.assimulo.FMIODE and together
    with Assimulo. Requires that Assimulo is installed.
    """
    
    @classmethod
    def setUpClass(cls):
        """
        Compile the test model.
        """
        pass
        
    def setUp(self):
        """
        Load the test model.
        """
        self._bounce  = fmi.FMIModel('bouncingBall.fmu',path_to_fmus)
        self._dq = fmi.FMIModel('dq.fmu',path_to_fmus)
        self._bounce.initialize()
        self._dq.initialize()
        self._bounceSim = FMIODE(self._bounce)
        self._dqSim     = FMIODE(self._dq)
        
    @testattr(assimulo = True)
    def test_init(self):
        """
        This tests the functionality of the method init. 
        """
        assert self._bounceSim._f_nbr == 2
        assert self._bounceSim._g_nbr == 1
        assert self._bounceSim.state_events == self._bounceSim.g
        assert self._bounceSim.y0[0] == 1.0
        assert self._bounceSim.y0[1] == 0.0
        assert self._dqSim._f_nbr == 1
        assert self._dqSim._g_nbr == 0
        try:
            self._dqSim.state_events
            raise FMIException('')
        except AttributeError:
            pass
        
        #sol = self._bounceSim._sol_real
        
        #nose.tools.assert_almost_equal(sol[0][0],1.000000000)
        #nose.tools.assert_almost_equal(sol[0][1],0.000000000)
        #nose.tools.assert_almost_equal(sol[0][2],0.000000000)
        #nose.tools.assert_almost_equal(sol[0][3],-9.81000000)
        
    @testattr(assimulo = True)
    def test_f(self):
        """
        This tests the functionality of the rhs.
        """
        t = 1.0
        y = N.array([1.0,1.0])
        
        rhs = self._bounceSim.f(t,y)
        
        nose.tools.assert_almost_equal(rhs[0],1.00000000)
        nose.tools.assert_almost_equal(rhs[1],-9.8100000)

    
    @testattr(assimulo = True)
    def test_g(self):
        """
        This tests the functionality of the event indicators.
        """
        t = 1.0
        y = N.array([1.0,1.0])
        
        event = self._bounceSim.g(t,y,None)
        
        nose.tools.assert_almost_equal(event[0],1.00000000)
        
        y = N.array([0.5,1.0])
        event = self._bounceSim.g(t,y,None)
        
        nose.tools.assert_almost_equal(event[0],0.50000000)

        
    @testattr(assimulo = True)
    def test_t(self):
        """
        This tests the functionality of the time events.
        """
        t = 1.0
        y = N.array([1.0,1.0])
        
        time = self._bounceSim.t(t,y,None)
        
        assert time == None
        #Further testing of the time event function is needed.
        
    @testattr(assimulo = True)
    def test_handle_result(self):
        """
        This tests the functionality of the handle result method.
        """
        t = 1.0
        y = N.array([1.0,1.0])
        
        assert len(self._bounceSim._sol_real) == 0
        self._bounceSim.write_cont = False
        self._bounceSim.handle_result(None,t,y)
        
        assert len(self._bounceSim._sol_real) == 1
        
        
    @testattr(assimulo = True)
    def test_handle_event(self):
        """
        This tests the functionality of the method handle_event.
        """
        y = N.array([1.,1.])
        self._bounceSim._model.real_x = y
        solver = lambda x:1
        solver.rtol = 1.e-4
        solver.t_cur = 1.0
        solver.y_cur = y
        solver.y = [y]

        self._bounceSim.handle_event(solver, None)

        nose.tools.assert_almost_equal(solver.y_cur[0],1.00000000)
        nose.tools.assert_almost_equal(solver.y_cur[1],-0.70000000)
        
        #Further testing of the handle_event function is needed.
    
    @testattr(assimulo = True)
    def test_completed_step(self):
        """
        This tests the functionality of the method completed_step.
        """
        y = N.array([1.,1.])
        solver = lambda x:1
        solver.t_cur = 1.0
        solver.y_cur = y
        assert self._bounceSim.completed_step(solver) == 0
        #Further testing of the completed step function is needed.
        
    @testattr(assimulo = True)
    def test_basic_simulation(self):
        """
        This tests the basic simulation and writing.
        """
        #Writing continuous
        res_obj = simulate(os.path.join(path_to_fmus,'bouncingBall.fmu'), alg_args={'final_time':3.})
        res = res_obj.result_data
        height = res.get_variable_data('h')

        nose.tools.assert_almost_equal(height.x[0],1.000000,5)
        nose.tools.assert_almost_equal(height.x[-1],-0.9804523,5)
        nose.tools.assert_almost_equal(height.t[-1],3.000000,5)
        
        #Writing after
        res_obj = simulate(os.path.join(path_to_fmus,'bouncingBall.fmu'), alg_args={'final_time':3.}, solver_args={'write_cont':False})
        res = res_obj.result_data
        height = res.get_variable_data('h')

        nose.tools.assert_almost_equal(height.x[0],1.000000,5)
        nose.tools.assert_almost_equal(height.x[-1],-0.9804523,5)
        nose.tools.assert_almost_equal(height.t[-1],3.000000,5)
        
        #Test with predefined FMIModel
        model = fmi.FMIModel(os.path.join(path_to_fmus,'bouncingBall.fmu'))
        model.initialize()
        res_obj = simulate(model, alg_args={'final_time':3.})
        res = res_obj.result_data
        height = res.get_variable_data('h')

        nose.tools.assert_almost_equal(height.x[0],1.000000,5)
        nose.tools.assert_almost_equal(height.x[-1],-0.9804523,5)
        nose.tools.assert_almost_equal(height.t[-1],3.000000,5)


    @testattr(assimulo = True)
    def test_default_simulation(self):
        """
        This test the default values of the simulation using simulate.
        """
        #Writing continuous
        res_obj = simulate(os.path.join(path_to_fmus,'bouncingBall.fmu'), alg_args={'final_time':3.})
        res = res_obj.result_data
        height = res.get_variable_data('h')
        
        nose.tools.assert_almost_equal(res_obj.solver.rtol, 0.000100, 5)
        assert res_obj.solver.iter == 'Newton'
        
        nose.tools.assert_almost_equal(height.x[0],1.000000,5)
        nose.tools.assert_almost_equal(height.x[-1],-0.9804523,5)
        nose.tools.assert_almost_equal(height.t[-1],3.000000,5)
        
        #Writing continuous
        res_obj = simulate(os.path.join(path_to_fmus,'bouncingBall.fmu'), alg_args={'final_time':3.},
                                            solver_args={'rtol':1e-6, 'iter':'FixedPoint'})
        res = res_obj.result_data
        height = res.get_variable_data('h')
    
        nose.tools.assert_almost_equal(res_obj.solver.rtol, 0.00000100, 7)
        assert res_obj.solver.iter == 'FixedPoint'
        
        nose.tools.assert_almost_equal(height.x[0],1.000000,5)
        nose.tools.assert_almost_equal(height.x[-1],-0.98018113,5)
        nose.tools.assert_almost_equal(height.t[-1],3.000000,5)
