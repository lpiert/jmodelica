#!/usr/bin/env python 
# -*- coding: utf-8 -*-

#    Copyright (C) 2011 Modelon AB
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, version 3 of the License.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

"""
Module containing the CasADi interface Python wrappers.
"""

import os.path
import numpy as N

try:
    import casadi
except:
    pass

from jmodelica.compiler import compile_fmux
from pyfmi.fmi import unzip_fmux
from pyjmi.common.core import get_temp_location
from pyjmi.common import xmlparser

def convert_casadi_der_name(name):
    n = name.split('der_')[1]
    qnames = n.split('.')
    n = ''
    for i in range(len(qnames)-1):
        n = n + qnames[i] + '.'
    return n + 'der(' + qnames[len(qnames)-1] + ')' 

class CasadiModel(object):
    def __init__(self, name, path='.', enable_scaling=False,
                 scale_equations=False):
        
        #Create temp binary
        self._fmuxnames = unzip_fmux(archive=name, path=path)
        self._tempxml = self._fmuxnames['model_desc']
        
        #Load model description
        self.xmldoc = xmlparser.ModelDescription(self._tempxml)
        
        #Load CasADi interface
        self._load_xml_to_casadi(self._tempxml, enable_scaling, scale_equations)
    
    def get_model_description(self):
        return self.xmldoc
    
    def get_name(self):
        """
        Returns the model name.
        """
        return self.xmldoc.get_model_name().replace('.','_')
    
    def _default_options(self, module, algorithm):
        """ 
        Help method. Gets the options class for the algorithm specified in 
        'algorithm'.
        """
        module = __import__(module, globals(), locals(), [algorithm], -1)
        algorithm = getattr(module, algorithm)
        
        return algorithm.get_default_options()
    
    def optimize_options(self, algorithm='LocalDAECollocationAlg'):
        """
        Returns an instance of the optimize options class containing options 
        default values. If called without argument then the options class for 
        the default optimization algorithm will be returned.
        
        Parameters::
        
            algorithm --
                The algorithm for which the options class should be returned. 
                Possible values are: 'LocalDAECollocationAlg' and
                'CasadiPseudoSpectral'
                Default: 'LocalDAECollocationAlg'
                
        Returns::
        
            Options class for the algorithm specified with default values.
        """
        return self._default_options('pyjmi.jmi_algorithm_drivers', algorithm)    
    
    def optimize(self, 
                 algorithm='LocalDAECollocationAlg', 
                 options={}):
        """
        Solve an optimization problem.
            
        Parameters::
            
            algorithm --
                The algorithm which will be used for the optimization is 
                specified by passing the algorithm class name as string or class 
                object in this argument. 'algorithm' can be any class which 
                implements the abstract class AlgorithmBase (found in 
                algorithm_drivers.py). In this way it is possible to write 
                custom algorithms and to use them with this function.

                The following algorithms are available:
                - 'LocalDAECollocationAlg'. This algorithm is based on direct
                  collocation on finite elements and the algorithm IPOPT is
                  used to obtain a numerical solution to the problem.
                - 'CasadiPseudoSpectral'
                Default: 'LocalDAECollocationAlg'
                
            options -- 
                The options that should be used in the algorithm. The options
                documentation can be retrieved from an options object:
                
                    >>> myModel = CasadiModel(...)
                    >>> opts = myModel.optimize_options(algorithm)
                    >>> opts?

                Valid values are: 
                - A dict that overrides some or all of the algorithm's default
                  values. An empty dict will thus give all options with default
                  values.
                - An Options object for the corresponding algorithm, e.g.
                  LocalDAECollocationAlgOptions for LocalDAECollocationAlg.
                Default: Empty dict
            
        Returns::
            
            A result object, subclass of algorithm_drivers.ResultBase.
        """
        return self._exec_algorithm('pyjmi.jmi_algorithm_drivers',
                                    algorithm,
                                    options)
                                    
    def _exec_algorithm(self, module, algorithm, options):
        """ 
        Helper function which performs all steps of an algorithm run which are 
        common to all initialize and optimize algortihms.
        
        Raises:: 
        
            Exception if algorithm is not a subclass of 
            jmodelica.algorithm_drivers.AlgorithmBase.
        """
        base_path = 'pyjmi.common.algorithm_drivers'
        algdrive = __import__(base_path, globals(), locals(), ['AlgorithmBase'], -1)
        AlgorithmBase = getattr(algdrive, 'AlgorithmBase')
        
        if isinstance(algorithm, basestring):
            module = __import__(module, globals(), locals(), [algorithm], -1)
            algorithm = getattr(module, algorithm)
        
        if not issubclass(algorithm, AlgorithmBase):
            raise Exception(str(algorithm)+
            " must be a subclass of jmodelica.algorithm_drivers.AlgorithmBase")

        # initialize algorithm
        alg = algorithm(self, options)
        # solve optimization problem/initialize
        alg.solve()
        # get and return result
        return alg.get_result()
    
    def get_casadi_ocp(self):
        return self.ocp
        
    def get_n_x(self):
        return self.n_x
    
    def get_n_p(self):
        return self.n_p

    def get_n_u(self):
        return self.n_u

    def get_n_w(self):
        return self.n_w
        
    def get_dx_sf(self):
        return self.dx_sf
        
    def get_dx(self):
        return self.dx
    
    def get_x(self):
        return self.x
        
    def get_u(self):
        return self.u
    
    def get_p(self):
        return self.p
    
    def get_variability(self, variablename):
        """ 
        Get variability of variable. 
            
        Parameters::
            
            variablename --
                The name of the variable.
                    
        Returns::
        
            The variability of the variable, CONTINUOUS(0), CONSTANT(1), 
            PARAMETER(2) or DISCRETE(3).

        Raises::
        
            XMLException if variable was not found.
        """
        return self.xmldoc.get_variability(variablename)

    def get_pd_val(self):
        # Get the dependent variables
        d = casadi.var(self.ocp.d_)
        
        # Substitute for the expressions
        d_exp = casadi.substitute(casadi.SXMatrix(d),casadi.SXMatrix(self.ocp.explicit_var_),casadi.SXMatrix(self.ocp.explicit_fcn_))
        
        # Evaluate the expression to get the numerical values
        pFunc = casadi.SXFunction([[]],[d_exp])
        pFunc.init()
        pFunc.evaluate()
        res = pFunc.output()
      
        pd = []
        i=0
        for p in self.ocp.d_:
            pd += [(p.getName(),p.getValueReference(),N.array([res[i]]))]
            i = i+1
        return pd
    
    def get_w(self):
        return self.w
    
    def get_t(self):
        return self.t
    
    def get_x_sf(self):
        return self.x_sf

    def get_u_sf(self):
        return self.u_sf
        
    def get_p_sf(self):
        return self.p_sf

    def get_w_sf(self):
        return self.w_sf

    def get_dx_vr_map(self):
        return self.dx_vr_map

    def get_x_vr_map(self):
        return self.x_vr_map
        
    def get_p_vr_map(self):
        return self.p_vr_map

    def get_u_vr_map(self):
        return self.u_vr_map

    def get_w_vr_map(self):
        return self.w_vr_map
        
    def get_dae_F(self):
        return self.dae_F
        
    def get_init_F0(self):
        return self.init_F0
        
    def get_opt_J(self):
        """
        Get the Mayer cost functional.
        """
        return self.opt_J
        
    def get_opt_L(self):
        """
        Get the Lagrange cost functional.
        """
        return self.opt_L
        
    def _convert_to_ode(self):

        self.ocp.sortBLT()

        self.ocp.makeExplicit()
        
        self.ocp_ode_inputs = []
        self.ocp_ode_inputs += list(self.p)
        self.ocp_ode_inputs += list(self.x)
        self.ocp_ode_inputs += list(self.u)
        self.ocp_ode_inputs += [self.t]
        
        self.ocp_ode_init_inputs = []
        self.ocp_ode_init_inputs += list(self.p)
        self.ocp_ode_init_inputs += list(self.x)
        self.ocp_ode_init_inputs += [self.t]
        
        dx = casadi.der(self.ocp.x_)
        self.F = casadi.substitute(casadi.SXMatrix(dx),casadi.SXMatrix(self.ocp.explicit_var_),casadi.SXMatrix(self.ocp.explicit_fcn_))
        
        self.ode_F = casadi.SXFunction([self.ocp_ode_inputs], [self.F])
        self.ode_F.init()
        
        # The initial equations
        self.ode_F0 = casadi.SXFunction([self.ocp_ode_init_inputs],[self.ocp.initial_eq_])
        self.ode_F0.init()
        
        # The Lagrange cost function
        if len(self.ocp.lterm)>0:
            self.opt_ode_L = casadi.SXFunction([self.ocp_ode_inputs],[[self.ocp.lterm[0]]])
            self.opt_ode_L.init()
        else:
            self.opt_ode_L = None
        
        # The Mayer cost function
        if len(self.ocp.mterm)>0:
            self.ocp_ode_mterm_inputs = []
            self.ocp_ode_mterm_inputs += list(self.p)
            self.ocp_ode_mterm_inputs += [x.atTime(self.ocp.tf,True) for x in self.ocp.x_]
            self.ocp_ode_mterm_inputs += [self.t]
            self.opt_ode_J = casadi.SXFunction([self.ocp_ode_mterm_inputs],[[self.ocp.mterm[0]]])
            self.opt_ode_J.init()
        else:
            self.opt_ode_J = None
        
        # Boundary Constraints
        self.opt_ode_Cineq = [] #Inequality
        self.opt_ode_C = [] #Equality
        # Modify equality constraints to be on type g(x)=0 (instead of g(x)=a)
        lb = N.array(self.ocp.path_min_, dtype=N.float)
        ub = N.array(self.ocp.path_max_, dtype=N.float)
        for i in range(len(ub)):
            if lb[i] == ub[i]: #The constraint is an equality
                self.opt_ode_C += [self.ocp.path_fcn_[i]-self.ocp.path_max_[i]]
                #self.ocp.cfcn_ub[i] = casadi.SX(0.0)
                #self.ocp.cfcn_lb[i] = casadi.SX(0.0)
            else: #The constraint is an inequality
                if   lb[i] == -N.inf:
                    self.opt_ode_Cineq += [(1.0)*self.ocp.path_fcn_[i]-self.ocp.path_max_[i]]
                elif ub[i] == N.inf:
                    self.opt_ode_Cineq += [(-1.0)*self.ocp.path_fcn_[i]+self.ocp.path_min_[i]]
                else:
                    self.opt_ode_Cineq += [(1.0)*self.ocp.path_fcn_[i]-self.ocp.path_max_[i]]
                    self.opt_ode_Cineq += [(-1.0)*self.ocp.path_fcn_[i]+self.ocp.path_min_[i]]
        
        self.ocp_ode_boundary_inputs = []
        self.ocp_ode_boundary_inputs += list(self.p)
        self.ocp_ode_boundary_inputs += [x.atTime(self.ocp.t0,True) for x in self.ocp.x_]
        self.ocp_ode_boundary_inputs += [self.t]
        self.ocp_ode_boundary_inputs += [x.atTime(self.ocp.tf,True) for x in self.ocp.x_]
        self.ocp_ode_boundary_inputs += [self.t]
        self.opt_ode_C     = casadi.SXFunction([self.ocp_ode_boundary_inputs],[self.opt_ode_C])
        self.opt_ode_C.init()
        self.opt_ode_Cineq = casadi.SXFunction([self.ocp_ode_boundary_inputs],[self.opt_ode_Cineq])
        self.opt_ode_Cineq.init()
        
        if self.enable_scaling:
            # Scale model
            # Get nominal values for scaling
            x_nominal = self.xmldoc.get_x_nominal(include_alias = False)
            u_nominal = self.xmldoc.get_u_nominal(include_alias = False)
            
            for vr, val in x_nominal:
                if val != None:
                    self.x_sf[self.x_vr_map[vr]] = N.abs(val)

            for vr, val in u_nominal:
                if val != None:
                    self.u_sf[self.u_vr_map[vr]] = N.abs(val)

            # Create new, scaled variables
            self.x_scaled = self.x_sf*self.x
            self.u_scaled = self.u_sf*self.u
            
            self.ocp_ode_inputs_scaled = []
            self.ocp_ode_inputs_scaled += list(self.p)
            self.ocp_ode_inputs_scaled += list(self.x_scaled)
            self.ocp_ode_inputs_scaled += list(self.u_scaled)
            self.ocp_ode_inputs_scaled += [self.t]
            
            self.ocp_ode_init_inputs_scaled = []
            self.ocp_ode_init_inputs_scaled += list(self.p)
            self.ocp_ode_init_inputs_scaled += list(self.x_scaled)
            self.ocp_ode_init_inputs_scaled += [self.t]
            
            self.ocp_ode_mterm_inputs_scaled = []
            self.ocp_ode_mterm_inputs_scaled += list(self.p)
            self.ocp_ode_mterm_inputs_scaled += [self.x_sf[ind]*x.atTime(self.ocp.tf,True) for ind,x in enumerate(self.ocp.x_)]
            self.ocp_ode_mterm_inputs_scaled += [self.t]

            # Substitute scaled variables
            self.ode_F = list(self.ode_F.eval([self.ocp_ode_inputs_scaled])[0])
            self.ode_F0 = list(self.ode_F0.eval([self.ocp_ode_init_inputs_scaled])[0])
            if self.opt_ode_J != None:
                self.opt_ode_J = list(self.opt_ode_J.eval([self.ocp_ode_mterm_inputs_scaled])[0])
            if self.opt_L!=None:
                self.opt_ode_L = list(self.opt_ode_L.eval([self.ocp_ode_inputs_scaled])[0])

            self.ode_F = casadi.SXFunction([self.ocp_ode_inputs], [self.ode_F])
            self.ode_F0 = casadi.SXFunction([self.ocp_ode_init_inputs],[self.ode_F0])
        
            if self.opt_ode_J != None:
                self.opt_ode_J = casadi.SXFunction([self.ocp_ode_mterm_inputs],[[self.opt_ode_J]])
            if self.opt_ode_J != None:
                self.opt_ode_L = casadi.SXFunction([self.ocp_ode_inputs],[[self.opt_ode_L]])
    
    def get_opt_ode_L(self):
        return self.opt_ode_L

    def get_opt_ode_J(self):
        return self.opt_ode_J    
    
    def get_ode_F(self):
        return self.ode_F
        
    def get_ode_F0(self):
        return self.ode_F0
        
    def _load_xml_to_casadi(self, xml, enable_scaling=False,
                            scale_equations=False):
        # Store scaling option
        self.enable_scaling = enable_scaling
        
        # Allocate a parser and load the xml
        self.parser = casadi.FMIParser(xml)

        # Obtain the symbolic representation of the OCP
        self.ocp = self.parser.parse()

        # Scale the variables
        if enable_scaling:
            self.ocp.scaleVariables()

        # Eliminate the dependent variables
        self.ocp.eliminateDependent()

        # Scale the equations
        if enable_scaling and scale_equations:
            self.ocp.scaleEquations()

        # Create functions the DAE right hand side
        # Joel: Use this if making collocation using MX graphs
        # self.ocp.createFunctions(True, False, True)

        # Make sure the variables appear in value reference order
        var_dict = dict((repr(v),v) for v in self.ocp.x_)
        name_dict = dict((x[0],x[1]) for x in self.xmldoc.get_x_variable_names(include_alias = False))        
        i = 0;
        
        for vr in sorted(name_dict.keys()):
            self.ocp.x_[i] = var_dict[name_dict[vr]]
            i = i + 1

        var_dict = dict((repr(v),v) for v in self.ocp.u_)            
        name_dict = dict((x[0],x[1]) for x in self.xmldoc.get_u_variable_names(include_alias = False))        
        i = 0;
        for vr in sorted(name_dict.keys()):
            self.ocp.u_[i] = var_dict[name_dict[vr]]
            i = i + 1

        var_dict = dict((repr(v),v) for v in self.ocp.z_)            
        name_dict = dict((x[0],x[1]) for x in self.xmldoc.get_w_variable_names(include_alias = False))        
        i = 0;
        for vr in sorted(name_dict.keys()):
            self.ocp.z_[i] = var_dict[name_dict[vr]]
            i = i + 1
        
        var_dict = dict((repr(v),v) for v in self.ocp.p_)            
        name_dict = dict((x[0],x[1]) for x in self.xmldoc.get_p_opt_variable_names(include_alias = False))        
        i = 0;

        for vr in sorted(name_dict.keys()):
            if name_dict[vr] == "finalTime":
                continue
            self.ocp.p_[i] = var_dict[name_dict[vr]]
            i = i + 1
        
        # Get the variables
        self.dx = casadi.der(self.ocp.x_)
        self.x = casadi.var(self.ocp.x_)
        self.u = casadi.var(self.ocp.u_)
        self.w = casadi.var(self.ocp.z_)
        self.t = self.ocp.t_
        self.p = casadi.var(self.ocp.p_)

        # Build maps mapping value references to indices in the
        # variable vectors of casadi
        self.dx_vr_map = {}
        self.x_vr_map = {}
        self.u_vr_map = {}
        self.w_vr_map = {}
        self.p_vr_map = {}

        i = 0;
        for v in self.dx:
            self.dx_vr_map[self.xmldoc.get_value_reference(convert_casadi_der_name(str(v)))] = i
            i = i + 1

        i = 0;
        for v in self.x:
            self.x_vr_map[self.xmldoc.get_value_reference(str(v))] = i
            i = i + 1

        i = 0;
        for v in self.u:
            self.u_vr_map[self.xmldoc.get_value_reference(str(v))] = i
            i = i + 1

        i = 0;
        for v in self.w:
            self.w_vr_map[self.xmldoc.get_value_reference(str(v))] = i
            i = i + 1
            
        i = 0;
        for v in self.p:
            self.p_vr_map[self.xmldoc.get_value_reference(str(v))] = i
            i = i + 1

        self.ocp_inputs = []
        self.ocp_inputs += list(self.p)
        self.ocp_inputs += list(self.dx)
        self.ocp_inputs += list(self.x)
        self.ocp_inputs += list(self.u)
        self.ocp_inputs += list(self.w)
        self.ocp_inputs += [self.t]
        
        # The DAE function
        self.dae_F = casadi.SXFunction([self.ocp_inputs],[self.ocp.implicit_fcn_])
        self.dae_F.init()
        
        # The initial equations
        self.init_F0 = casadi.SXFunction([self.ocp_inputs],[self.ocp.initial_eq_])
        self.init_F0.init()
        
        # The Mayer cost function
        if len(self.ocp.mterm)>0:

            self.ocp_mterm_inputs = []
            self.ocp_mterm_inputs += list(self.p)
            self.ocp_mterm_inputs += [x.atTime(self.ocp.tf,True) for x in self.ocp.x_]
            self.ocp_mterm_inputs += [x.atTime(self.ocp.tf,True) for x in self.ocp.u_]
            self.ocp_mterm_inputs += [x.atTime(self.ocp.tf,True) for x in self.ocp.z_]
            self.ocp_mterm_inputs += [self.t]
            self.opt_J = casadi.SXFunction([self.ocp_mterm_inputs],[[self.ocp.mterm[0]]])
            self.opt_J.init()
        else:
            self.opt_J = None

        # The Lagrange cost function
        if len(self.ocp.lterm)>0:
            self.opt_L = casadi.SXFunction([self.ocp_inputs],[self.ocp.lterm[0]])
            self.opt_L.init()
        else:
            self.opt_L = None

        self.n_x = len(self.x)
        self.n_u = len(self.u)
        self.n_w = len(self.w)
        self.n_p = len(self.p)

        self.dx_sf = N.ones(self.n_x)
        self.x_sf = N.ones(self.n_x)
        self.u_sf = N.ones(self.n_u)
        self.w_sf = N.ones(self.n_w)
        self.p_sf = N.ones(self.n_p)
        
        if enable_scaling:
            # Scale model
            # Get nominal values for scaling
            dx_nominal = self.xmldoc.get_x_nominal(include_alias = False)
            x_nominal = self.xmldoc.get_x_nominal(include_alias = False)
            u_nominal = self.xmldoc.get_u_nominal(include_alias = False)
            w_nominal = self.xmldoc.get_w_nominal(include_alias = False)
            p_nominal = self.xmldoc.get_p_opt_nominal(include_alias = False)

            for vr, val in x_nominal:
                if val != None:
                    self.dx_sf[self.x_vr_map[vr]] = N.abs(val)
                    self.x_sf[self.x_vr_map[vr]] = N.abs(val)

            for vr, val in u_nominal:
                if val != None:
                    self.u_sf[self.u_vr_map[vr]] = N.abs(val)

            for vr, val in w_nominal:
                if val != None:
                    self.w_sf[self.w_vr_map[vr]] = N.abs(val)
                    
            for vr, val in p_nominal:
                if val != None:
                    self.p_sf[self.p_vr_map[vr]] = N.abs(val)        



