""" Test module for testing the compiler module.
 
"""

import os, os.path
import sys

import nose
import nose.tools

from jmodelica.tests import testattr

from jmodelica.compiler import ModelicaCompiler
import jmodelica as jm


jm_home = jm.environ['JMODELICA_HOME']
path_to_examples = os.path.join('Python', 'jmodelica', 'examples')

model = os.path.join('files', 'Pendulum_pack_no_opt.mo')
fpath = os.path.join(jm_home,path_to_examples,model)
cpath = "Pendulum_pack.Pendulum"

mc = ModelicaCompiler()
ModelicaCompiler.set_log_level(ModelicaCompiler.LOG_ERROR)


@testattr(stddist = True)
def test_compile():
    """
    Test that compilation is possible with compiler 
    and that all obligatory files are created. 
    """

    # detect platform specific shared library file extension
    suffix = ''
    if sys.platform == 'win32':
        suffix = '.dll'
    elif sys.platform == 'darwin':
        suffix = '.dylib'
    else:
        suffix = '.so'
        
    assert mc.compile_model(fpath, cpath) == 0, \
           "Compiling "+cpath+" failed."
    
    fname = cpath.replace('.','_',1)
    assert os.access(fname+'_variables.xml',os.F_OK) == True, \
           fname+'_variables.xml'+" was not created."
    
    assert os.access(fname+'_values.xml', os.F_OK) == True, \
           fname+'_values.xml'+" was not created."
    
    assert os.access(fname+'.o', os.F_OK) == True, \
           fname+'.o'+" was not created."        
    
    assert os.access(fname+'.c', os.F_OK) == True, \
           fname+'.c'+" was not created."        
    
    assert os.access(fname+suffix, os.F_OK) == True, \
           fname+suffix+" was not created."        
        

@testattr(stddist = True)
def test_compile_wtarget_alg():
    """ Test that it is possible to compile (compiler.py) with target algorithms. """
    assert mc.compile_model(fpath, cpath, target='algorithms') == 0, \
           "Compiling "+cpath+" with target=algorithms failed."
    

@testattr(stddist = True)
def test_compile_wtarget_ipopt():
    """ Test that it is possible to compile (compiler.py) with target ipopt. """
    assert mc.compile_model(fpath, cpath, target='ipopt') == 0, \
           "Compiling "+cpath+" with target=ipopt failed."
    

@testattr(stddist = True)
def test_stepbystep():
    """ Test that it is possible to compile (compiler.py) step-by-step. """
    sourceroot = mc.parse_model(fpath)
    ipr = mc.instantiate_model(sourceroot, cpath)
    fclass = mc.flatten_model(fpath, cpath, ipr)
    assert mc.compile_dll(cpath.replace('.','_',1)) == 0, \
           "Compiling dll failed."
   

@testattr(stddist = True)
def test_compiler_error():
    """ Test that a CompilerError is raised if compilation errors are found in the model."""
    corruptmodel = os.path.join('files','CorruptCodeGenTests.mo')
    path = os.path.join(jm_home,path_to_examples,corruptmodel)
    cl = 'CorruptCodeGenTests.CorruptTest1'
    nose.tools.assert_raises(jm.compiler.CompilerError, mc.compile_model, path, cl)
    

@testattr(stddist = True)
def test_class_not_found_error():
    """ Test that a ModelicaClassNotFoundError is raised if model class is not found. """
    errorcl = 'NonExisting.ModelicaClass'
    nose.tools.assert_raises(jm.compiler.ModelicaClassNotFoundError, mc.compile_model, fpath, errorcl)


@testattr(stddist = True)
def test_IO_error():
    """ Test that an IOError is raised if the model file is not found. """          
    errormodel = os.path.join('files','NonExistingModel.mo')
    errorpath = os.path.join(jm_home,path_to_examples,errormodel)
    nose.tools.assert_raises(IOError, mc.compile_model, errorpath, cpath)
           

@testattr(stddist = True)
def test_setget_modelicapath():
    """ Test modelicapath setter and getter. """
    newpath = os.path.join(jm_home,'ThirdParty','MSL','Modelica')
    mc.set_modelicapath(newpath)
    nose.tools.assert_equal(mc.get_modelicapath(),newpath)
    

@testattr(stddist = True)
def test_setget_XMLVariablesTemplate():
    """ Test XML variables template setter and getter. """
    newtemplate = os.path.join(jm_home, 'CodeGenTemplates','jmi_modelica_variables_template.xml')
    mc.set_XMLVariablesTemplate(newtemplate)
    nose.tools.assert_equal(mc.get_XMLVariablesTemplate(), newtemplate)
    

@testattr(stddist = True)
def test_setget_XMLValuesTemplate():
    """ Test XML values template setter and getter. """
    newtemplate = os.path.join(jm_home, 'CodeGenTemplates','jmi_modelica_values_template.xml')
    mc.set_XMLValuesTemplate(newtemplate)
    nose.tools.assert_equal(mc.get_XMLValuesTemplate(), newtemplate)


@testattr(stddist = True)
def test_setget_cTemplate():
    """ Test c template setter and getter. """
    newtemplate = os.path.join(jm_home, 'CodeGenTemplates','jmi_modelica_template.c')
    mc.set_cTemplate(newtemplate)
    nose.tools.assert_equal(mc.get_cTemplate(), newtemplate)
   


