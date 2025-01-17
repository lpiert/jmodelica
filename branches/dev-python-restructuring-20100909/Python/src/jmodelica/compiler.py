#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Interfaces to the JModelica compilers

Module containing functions for compiling models. Options which are user 
specific can be set either before importing this module by editing the file 
options.xml or interactively. If options are not changed the default option 
settings will be used.

"""

#    Copyright (C) 2009 Modelon AB
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


import os
import sys
import platform
import subprocess
import string

import jpype

import jmodelica as jm
from jmodelica import xmlparser

#start JVM
# note that startJVM() fails after shutdownJVM(), hence, only one start
if not jpype.isJVMStarted():
    _jvm_args = string.split(jm.environ['JVM_ARGS'],' ')
    _jvm_class_path = jm.environ['MC_JAR'] + os.pathsep + jm.environ['OC_JAR']+ os.pathsep + jm.environ['UTIL_JAR'] + os.pathsep + jm.environ['GRAPHS_JAR']
    _jvm_ext_dirs = jm.environ['BEAVER_PATH']
    jpype.startJVM(jm.environ['JVM_PATH'],
                   '-Djava.class.path=%s' % _jvm_class_path,
                   '-Djava.ext.dirs=%s' % _jvm_ext_dirs,
                   *_jvm_args)
    org = jpype.JPackage('org')
    print "JVM started."

OptionRegistry = org.jmodelica.util.OptionRegistry

UnknownOptionException = jpype.JClass('org.jmodelica.util.OptionRegistry$UnknownOptionException')

class ModelicaCompiler():
    """ User class for accessing the Java ModelicaCompiler class. """
    
    ModelicaCompiler = org.jmodelica.modelica.compiler.ModelicaCompiler
    
    LOG_ERROR = ModelicaCompiler.ERROR
    LOG_WARNING = ModelicaCompiler.WARNING
    LOG_INFO = ModelicaCompiler.INFO
    
    jm_home = jm.environ['JMODELICA_HOME']
    
    fmi_tpl = os.path.join(jm_home, 'CodeGenTemplates', 'fmi_model_description.tpl') 
    fmi_ext_tpl = os.path.join(jm_home, 'CodeGenTemplates', 'fmi_extended_model_description.tpl')
    jmodelica_tpl = os.path.join(jm_home, 'CodeGenTemplates','jmodelica_model_description.tpl')
    model_values_tpl = os.path.join(jm_home, 'CodeGenTemplates', 'jmodelica_model_values.tpl')
    c_tpl_path = os.path.join(jm_home, 'CodeGenTemplates', 'jmi_modelica_template.c')    
    options_file_path = os.path.join(jm_home, 'Options','options.xml')

    def __init__(self):
        """ Create a Modelica compiler. The compiler can be used to compile 
        pure Modelica models. A compiler instance can be used multiple 
        times.
        """
        try:
            options = OptionRegistry(self.options_file_path)
        except jpype.JavaException, ex:
            self._handle_exception(ex)
            
        options.setStringOption('MODELICAPATH',jm.environ['MODELICAPATH'])
        fmi = options.getBooleanOption('generate_fmi_xml')
        equ = options.getBooleanOption('generate_xml_equations')
        if fmi and not equ:
            self._compiler = self.ModelicaCompiler(options, 
                                                   self.fmi_tpl,
                                                   self.model_values_tpl,
                                                   self.c_tpl_path)
        elif fmi and equ:
            self._compiler = self.ModelicaCompiler(options, 
                                                   self.fmi_ext_tpl,
                                                   self.model_values_tpl,
                                                   self.c_tpl_path)
        else:
            self._compiler = self.ModelicaCompiler(options, 
                                                   self.jmodelica_tpl,
                                                   self.model_values_tpl,
                                                   self.c_tpl_path)           
            
    @classmethod
    def set_log_level(self,level):
        """ Set the level of log messages. Valid options are 
        ModelicaCompiler.LOG_ERROR, ModelicaCompiler.LOG_WARNING and 
        ModelicaCompiler.LOG_INFO. They will print, errors only, both 
        errors and warnings and all log messages respectively.
        
        Parameters::
        
            level --
                Level of log messages to set. Valid options are 
                ModelicaCompiler.LOG_ERROR, ModelicaCompiler.LOG_WARNING 
                and ModelicaCompiler.LOG_INFO.
        """
        self.ModelicaCompiler.setLogLevel(self.ModelicaCompiler.log, level)

    @classmethod
    def get_log_level(self):
        """ Get the current level of log messages set. 
        
        Returns::
        
            The current level of log messages.
        """
        return self.ModelicaCompiler.getLogLevel(self.ModelicaCompiler.log)
        
    def get_modelicapath(self):
        """ Get the path to Modelica libraries set for this compiler.
        
        Returns::
        
            Path to Modelica libraries set.
        """
        return self._compiler.getModelicapath()
    
    def set_modelicapath(self, path):
        """ Set the path to Modelica libraries for this compiler instance. 
        
        Parameters::
        
            path --
                The path to Modelica libraries.
        """
        self._compiler.setModelicapath(path)

    def get_boolean_option(self, key):
        """ Get the boolean option set for the specific key. 
        
        Parameters::
        
            key --
                Get the boolean option for this key.
        """
        try:
            option = self._compiler.getBooleanOption(key)
        except jpype.JavaException, ex:
            self._handle_exception(ex)
        return bool(option)
    
    def set_boolean_option(self, key, value, description=""):
        """ Set the boolean option with key to value and an optional
        description. 
        
        If the option already exists it will be overwritten. 
        
        Parameters::
        
            key --
                Key for the boolean option.
            value --
                Boolean option.
            description --
                Description for the option.
                Default: Empty string.
        """
        try:
            self._compiler.setBooleanOption(key, value, description)
            
            if key.strip() == 'generate_fmi_xml' or key.strip() == 'generate_xml_equations':
                fmi = self.get_boolean_option('generate_fmi_xml')
                equ = self.get_boolean_option('generate_xml_equations')
                if fmi and not equ:
                    self.set_XML_tpl(self.fmi_tpl)
                elif fmi and equ:
                    self.set_XML_tpl(self.fmi_ext_tpl)
                else:
                    self.set_XML_tpl(self.jmodelica_tpl)
                    
        except jpype.JavaException, ex:
            self._handle_exception(ex)
        
    def get_integer_option(self, key):
        """ Get the integer option set for the specific key. 
        
        Parameters::
        
            key --
                Get the integer option for this key.
        """
        try:
            option = self._compiler.getIntegerOption(key)
        except jpype.JavaException, ex:
            self._handle_exception(ex)
        return option
    
    def set_integer_option(self, key, value, description=""):
        """ Set the integer option with key to value and an optional
        description. 
        
        If the option already exists it will be overwritten. 
        
        Parameters::
        
            key --
                Key for the integer option.
            value --
                Integer option.
            description --
                Description for the option.
                Default: Empty string.
        """
        try:
            self._compiler.setIntegerOption(key, value, description)
        except jpype.JavaException, ex:
            self._handle_exception(ex)
        
    def get_real_option(self, key):
        """ Get the real option set for the specific key. 
        
        Parameters::
        
            key --
                Get the real option for this key.
        """
        try:
            option = self._compiler.getRealOption(key)
        except jpype.JavaException, ex:
            self._handle_exception(ex)
        return option
    
    def set_real_option(self, key, value, description=""):
        """ Set the real option with key to value and an optional
        description. 
        
        If the option already exists it will be overwritten. 
        
        Parameters::
        
            key --
                Key for the real option.
            value --
                Real option.
            description --
                Description for the option.
                Default: Empty string.
        """
        try:
            self._compiler.setRealOption(key, value, description)
        except jpype.JavaException, ex:
            self._handle_exception(ex)
                    
    def get_string_option(self, key):
        """ Get the string option set for the specific key. 
        
        Parameters::
        
            key --
                Get the string option for this key.
        """
        try:
            option = self._compiler.getStringOption(key)
        except jpype.JavaException, ex:
            self._handle_exception(ex)
        return str(option)
        
    def set_string_option(self, key, value, description=""):
        """ Set the string option with key to value and an optional
        description. 
        
        If the option already exists it will be overwritten. 
        
        Parameters::
        
            key --
                Key for the string option.
            value --
                String option.
            description --
                Description for the option.
                Default: Empty string.
        """
        try:
            self._compiler.setStringOption(key, value, description)
        except jpype.JavaException, ex:
            self._handle_exception(ex)
        
    def get_option_description(self, key):
        """ Get the description set for a certain option. 
        
        Parameters::
        
            key --
                The key for the option.
                
        Returns::
        
            The description for the option.
        """
        try:
            desc = self._compiler.getOptionDescription(key)    
        except jpype.JavaException, ex:
            self._handle_exception(ex)
        return str(desc)
    
    def get_XML_tpl(self):
        """ Get the file path to the XML model description template.
        
        Returns::
        
            The file path for the XML model description template.
        """
        return self._compiler.getXMLTpl()

    def set_XML_tpl(self, template):
        """ Set the XML model description template to the file pointed 
        out by template.
        
        Parameters::
        
            template --
                The new XML model description template.
        
        """
        self._compiler.setXMLTpl(template)

    def get_XML_values_tpl(self):
        """ Get the file path to the XML model values template. 
        
        Returns::
        
            The file path for the XML model values template.
        """
        return self._compiler.getXMLValuesTpl()
    
    def set_XML_values_tpl(self, template):
        """ Set the XML values template to the file pointed out by 
        template.
        
        Parameters::
        
            template --
                The new XML model values template.
        
        """
        self._compiler.setXMLValuesTpl(template)
        
    def get_cTemplate(self):
        """ Get the file path to the c code template. 
        
        Returns::
        
            The file path for the c code template.
        """
        return self._compiler.getCTemplate()
    
    def set_cTemplate(self, template):
        """ Set the c code template to the file pointed out by template.
        
        Parameters::
        
            template --
                The new c code template.
        """
        self._compiler.setCTemplate(template)

    def compile_model(self,
                      model_class_name,
                      model_file_name,
                      target = "model"):
    
        """ 
        Compile a model.

        Perform all steps in the compilation of a model: parsing, 
        instantiating, flattening, code generation and dll generation. 
        Outputs are object file, c-code file, xml file and dll which are 
        all written to the folder in which the compilation is performed. 
        All files will get the default name <model_class_name>.<ext>. 
        Set target to specify the contents of the object file used to 
        build the .dll. Default is"model". Other three options are 
        "model_noad", "algorithms" and "ipopt". See makefile in install 
        folder for details.

        Parameters::
        
            model_class_name -- 
                Name of model class in the model file to compile.
            model_file_name -- 
                Path to file or list of paths to files in which the model is 
                contained.
            target -- 
                The build target. Valid options are 'model', 'model_noad', 
                'algorithms' and 'ipopt'.
                Default: model

        Returns::
        
            A jmi.Model object.

        Exceptions::
        
            CompilerError -- 
                Raised if one or more error is found during compilation.
            ModelicaClassNotFoundError -- 
                If the model class is not found.
            IOError -- 
                If the model file is not found, can not be read or any 
                other IO related error.
            Exception -- 
                If there are general errors related to the parsing of the 
                model.       
            JError -- 
                If there was a runtime exception thrown by the underlying 
                Java classes.

        """        
        if isinstance(model_file_name, str):
            model_file_name = [model_file_name]           
        try:
            self._compiler.compileModel(model_file_name,
                                        model_class_name)
            c_file = model_class_name.replace('.','_')
            
            # get external libs and include dirs from XML doc
            xml_file=c_file+'.xml'
            xmldoc = xmlparser.ModelDescription(xml_file)
            ext_libs = xmldoc.get_external_libraries()
            ext_lib_dirs = xmldoc.get_external_lib_dirs()
            ext_incl_dirs = xmldoc.get_external_incl_dirs()
            
            if len(ext_libs) > 0:
                self.compile_dll(c_file, target, ext_libs=ext_libs, ext_lib_dirs=ext_lib_dirs, ext_incl_dirs=ext_incl_dirs)
            else:
                self.compile_dll(c_file, target)

        except jpype.JavaException, ex:
            self._handle_exception(ex)

        #return jmi.JMUModel(c_file)

    def parse_model(self,model_file_name):   
        """ 
        Parse a model.

        Parse a model and return a reference to the source tree
        representation.

        Parameters::
            
            model_file_name -- 
                Path to file or list of paths to files in which the model 
                is contained.

        Return::
        
            Reference to the root of the source tree representation of the 
            parsed model.

        Exceptions::
        
            CompilerError --
                If one or more error is found during compilation.
            IOError --
                If the model file is not found, can not be read or any 
                other IO related error.
            Exception --
                If there are general errors related to the parsing of the 
                model.       
            JError -- 
                If there was a runtime exception thrown by the underlying 
                Java classes.

        """        
        if isinstance(model_file_name, str):
            model_file_name = [model_file_name]
        try:
            sr = self._compiler.parseModel(model_file_name)
            return sr        
        except jpype.JavaException, ex:
            self._handle_exception(ex)

    def instantiate_model(self, source_root, model_class_name):
        """ 
        Generate an instance tree representation for a model.

        Generate an instance tree representation for a model using the 
        source tree belonging to the model which must first be created 
        with parse_model.

        Parameters::
          
            source_root -- 
                Reference to the root of the source tree representation.
            model_class_name -- 
                Name of model class in the model file to compile.

        Returns::
        
            Reference to the instance AST node representing the model 
            instance. 

        Exceptions::
        
            CompilerError -- 
                If one or more error is found during compilation.
            ModelicaClassNotFoundError -- 
                If the model class is not found.
            JError --
                If there was a runtime exception thrown by the underlying 
                Java classes.

        """    
        try:
            ipr = self._compiler.instantiateModel(source_root, model_class_name)
            return ipr    
        except jpype.JavaException, ex:
            self._handle_exception(ex)

    def flatten_model(self, inst_class_decl):
        """ 
        Compute a flattened representation of a model. 

        Compute a flattened representation of a model using the instance 
        tree belonging to the model which must first be created with 
        instantiate_model.

        Parameters::
          
            inst_class_decl -- 
                Reference to a model instance. 

        Returns::
        
            Object (FClass) representing the flattened model. 

        Exceptions::
        
            CompilerError --
                If one or more error is found during compilation.
            ModelicaClassNotFoundError --
                If the model class is not found.
            IOError --
                If the model file is not found, can not be read or any 
                other IO related error.
            JError -- 
                If there was a runtime exception thrown by the underlying 
                Java classes.

        """
        try:
            fclass = self._compiler.flattenModel(inst_class_decl)
            return fclass    
        except jpype.JavaException, ex:
            self._handle_exception(ex)

    def generate_code(self,fclass):
    
        """ 
        Generate code for a model.

        Generate code for a model c and xml code for a model using the 
        FClass represenation created with flatten_model and template 
        files located in the JModelica installation folder. Default 
        output folder is the current folder from which this module is 
        run.

        Parameters::
        
            fclass -- 
                Reference to the flattened model object representation.  

        Exceptions::
        
            IOError -- 
                If the model file is not found, can not be read or any 
                other IO related error.
            JError --
                If there was a runtime exception thrown by the underlying 
                Java classes.

        """
        try:
            self._compiler.generateCode(fclass)
        except jpype.JavaException, ex:
            self._handle_exception(ex)

    def compile_dll(self, c_file_name, target="model", ext_libs=[], 
        ext_lib_dirs=[], ext_incl_dirs=[]):

        """ 
        Compile a c code representation of a model.

        Compile a c code representation of a model and output a .dll
        file. Default output folder is the current folder from which
        this module is run. Needs a c-file which is generated with
        generate_code.
        
        If there are external functions in the model, the libaries, 
        library directories and include directories should be passed in 
        ext_libs, ext_lib_dirs and ext_incl_dirs lists respectively.
        External functions can currently only be combined with the target 
        'model_noad'.
        
        Parameters::
        
            c_file_name --
                Name of c-file for which the .dll should be compiled without 
                file extention.
            target --
                Build target. Valid options are 'model', 'model_noad', 
                'algorithm' and 'ipopt'.
                Default: model
            ext_libs --
                List of external libraries.
                Default: Empty list.
            ext_lib_dirs --
                List of external library directories.
                Default: Empty list.
            ext_incl_dirs --
                List of external include file directories.
                Default: Empty list.

        """
        #make settings
        make_file = os.path.join(self.jm_home, 'Makefiles', 'MakeFile')
        file_name =' FILE_NAME=' + c_file_name
        jmodelica_h =' JMODELICA_HOME=' + self.jm_home
        cppad_h = ' CPPAD_HOME=' + jm.environ['CPPAD_HOME']
        ipopt_h = ' IPOPT_HOME=' + jm.environ['IPOPT_HOME']
        
        
        # external library directories
        platform_dir = _get_platform()
            
        extlibdirs = ' EXT_LIB_DIRS=\"'
        for libdir in ext_lib_dirs:
            if os.path.exists(os.path.join(libdir, platform_dir)):
                extlibdirs = extlibdirs + os.path.join(libdir, platform_dir)
            else:
                extlibdirs = extlibdirs + libdir
        extlibdirs = extlibdirs+"\""
        
        # external libraries
        extlibs = ' EXT_LIBS=\"'
        s = ' '
        libs = s.join(ext_libs)
        extlibs = extlibs+libs+"\""

        # external include directories
        extincdir = ' EXT_INC_DIRS=\"'
        s = ' '
        incdir = s.join(ext_incl_dirs)
        extincdir = extincdir+incdir+"\""

        if sys.platform == 'win32':
            make = os.path.join(jm.environ['MINGW_HOME'],'bin','mingw32-make') + ' -f '
            compiler = ' CXX=' + os.path.join(jm.environ['MINGW_HOME'],'bin','g++')
            ar = ' AR=' + os.path.join(os.environ['MINGW_HOME'],'bin','ar')

            cmd = make + \
                  make_file + \
                  compiler + \
                  ar + \
                  ' ' + \
                  target + \
                  file_name + \
                  jmodelica_h + \
                  cppad_h + \
                  ipopt_h + \
                  extlibdirs + \
                  extlibs + \
                  extincdir
        else:
            cmd = 'make -f' + \
                  make_file + \
                  ' ' + \
                  target + \
                  file_name + \
                  jmodelica_h + \
                  cppad_h + \
                  ipopt_h + \
                  extlibdirs + \
                  extlibs + \
                  extincdir

        #run make -> <model_class_name>.dll
        retcode = subprocess.call(cmd, shell=True)
        if retcode != 0:
            raise CcodeCompilationError("Retcode was: "+str(retcode))
        else:
            print >>sys.stderr, "make returned", retcode
            
    def _handle_exception(self, ex):
        """ Catch and handle all expected Java Exceptions that the 
        underlying Java classes might throw.
        
        Raise an appropriate Python error or the default JError.
        """
        if ex.javaClass() is org.jmodelica.modelica.compiler.CompilerException \
            or ex.javaClass() is org.jmodelica.optimica.compiler.CompilerException:
            arraylist = ex.__javaobject__.getProblems()
            itr = arraylist.iterator()
            
            #problems = "\n"
            #while itr.hasNext():
            #    problems = problems + str(itr.next()) + "\n"

            compliance_errors = []
            errors = []
            warnings = []
            while itr.hasNext():
                p = str(itr.next())
                if p.count('Compliance error')>0:
                    compliance_errors.append(p)
                elif p.count('Warning')>0:
                    warnings.append(p)
                else:
                    errors.append(p)
                    
            raise CompilerError(errors,compliance_errors,warnings)
        
        if ex.javaClass() is org.jmodelica.modelica.compiler.ModelicaClassNotFoundException:
            raise ModelicaClassNotFoundError(str(ex.__javaobject__.getClassName()))
        
        if ex.javaClass() is org.jmodelica.optimica.compiler.ModelicaClassNotFoundException:
            raise OptimicaClassNotFoundError(str(ex.__javaobject__.getClassName()))
        
        if ex.javaClass() is jpype.java.io.FileNotFoundException:
            raise IOError('Message: '+ex.message().encode('utf-8')+'\n Stacktrace: '+ex.stacktrace().encode('utf-8'))
        
        if ex.javaClass() is jpype.java.io.IOException:
            raise IOError('Message: '+ex.message().encode('utf-8')+'\n Stacktrace: '+ex.stacktrace().encode('utf-8'))
        
        if ex.javaClass() is jpype.javax.xml.xpath.XPathExpressionException:
            raise XPathExpressionError('Message: '+ex.message().encode('utf-8')+'\n Stacktrace: '+ex.stacktrace().encode('utf-8'))
        
        if ex.javaClass() is jpype.javax.xml.parsers.ParserConfigurationException:
            raise ParserConfigurationError('Message: '+ex.message().encode('utf-8')+'\n Stacktrace: '+ex.stacktrace().encode('utf-8'))
        
        if ex.javaClass() is org.xml.sax.SAXException or \
            ex.javaClass() is org.xml.sax.SAXNotRecognizedException or \
            ex.javaClass() is org.xml.sax.SAXNotSupportedException or \
            ex.javaClass() is org.xml.sax.SAXParseException:
            raise SAXError('Message: '+ex.message().encode('utf-8')+'\n Stacktrace: '+ex.stacktrace().encode('utf-8'))
    
        if ex.javaClass() is UnknownOptionException:
            raise UnknownOptionError(ex.message().encode('utf-8')+'\n Stacktrace: '+ex.stacktrace().encode('utf-8'))
        
        if ex.javaClass() is jpype.java.lang.Exception:
            raise Exception('Message: '+ex.message().encode('utf-8')+'\n Stacktrace: '+ex.stacktrace().encode('utf-8'))
        
        if ex.javaClass() is jpype.java.lang.NullPointerException:
            raise JError(ex.stacktrace().encode('utf-8'))
        
        raise JError(ex.stacktrace().encode('utf-8'))

class OptimicaCompiler(ModelicaCompiler):
    """ User class for accessing the Java OptimicaCompiler class. """

    OptimicaCompiler = org.jmodelica.optimica.compiler.OptimicaCompiler

    jm_home = jm.environ['JMODELICA_HOME']
    optimica_c_tpl_path = os.path.join(jm_home, 'CodeGenTemplates', 'jmi_optimica_template.c')

    def __init__(self):
        """ Create an Optimica compiler. The compiler can be used to 
        compile both Modelica and Optimica models. A compiler instance 
        can be used multiple times.
        """
        try:
            options = OptionRegistry(self.options_file_path)
        except jpype.JavaException, ex:
            self._handle_exception(ex)
            
        options.setStringOption('MODELICAPATH',jm.environ['MODELICAPATH'])
        
        fmi = options.getBooleanOption('generate_fmi_xml')
        if fmi:
            self._compiler = self.OptimicaCompiler(options, 
                                                   self.fmi_ext_tpl,
                                                   self.model_values_tpl,
                                                   self.c_tpl_path,
                                                   self.fmi_ext_tpl,
                                                   self.optimica_c_tpl_path)
        else:
            self._compiler = self.OptimicaCompiler(options, 
                                                   self.jmodelica_tpl,
                                                   self.model_values_tpl,
                                                   self.c_tpl_path,
                                                   self.jmodelica_tpl,
                                                   self.optimica_c_tpl_path)
    @classmethod
    def set_log_level(self,level):
        """ Set the level of log messages. Valid options are 
        OptimicaCompiler.LOG_ERROR, OptimicaCompiler.LOG_WARNING and 
        OptimicaCompiler.LOG_INFO. They will print, errors only, both 
        errors and warnings and all log messages respectively.
        
        Parameters::
        
            level --
                Level of log messages to set. Valid options are 
                OptimicaCompiler.LOG_ERROR, OptimicaCompiler.LOG_WARNING 
                and OptimicaCompiler.LOG_INFO.
        """
        self.OptimicaCompiler.setLogLevel(self.OptimicaCompiler.log, level)

    @classmethod
    def get_log_level(self):
        """ Get the current level of log messages set. 
        
        Returns::
        
            The current level of log messages.
        """
        return self.OptimicaCompiler.getLogLevel(self.ModelicaCompiler.log)

    def set_boolean_option(self, key, value, description=""):
        """ Set the boolean option with key to value and an optional
        description. 
        
        If the option already exists it will be overwritten. 
        
        Parameters::
        
            key --
                Key for the boolean option.
            value --
                Boolean option.
            description --
                Description for the option.
                Default: Empty string.
        """
        try:
            self._compiler.setBooleanOption(key, value, description)
            
            if key.strip() == 'generate_fmi_xml':
                fmi = self.get_boolean_option('generate_fmi_xml')
                if fmi:
                    self.set_XML_tpl(self.fmi_ext_tpl)
                else:
                    self.set_XML_tpl(self.jmodelica_tpl)            
                          
        except jpype.JavaException, ex:
            self._handle_exception(ex)
              

class JError(Exception):
    
    """ Base class for exceptions specific to this module."""
    
    def __init__(self, message):
        """ Create new error with a specific message. 
        
        Parameters::
        
            message --
                The error message.
        """
        self.message = message
        
    def __str__(self):
        """ Print error message when class instance is printed.
         
        Override the general-purpose special method such that a string 
        representation of an instance of this class will be the error 
        message.
        
        Returns::
            The error message.
        
        """
        return self.message

class ModelicaClassNotFoundError(JError):
    
    """ Class for errors raised if the Modelica model class to be 
    compiled can not be found.
    
    """
    pass

class OptimicaClassNotFoundError(JError):
    
    """ Class for a errors raised if the Optimica model class to be 
    compiled can not be found.
    
    """ 
    pass


class CompilerError(JError):
    
    """ Class representing a compiler error. Raised if there were one or more 
    errors found during compilation of the model. If there are several errors 
    in one model, they are collected and presented in one CompilerError.
    
    """

    def __init__(self, errors, compliance_errors, warnings):
        """ Create CompilerError with a list of error messages. """
        self.compliance_errors = compliance_errors
        self.warnings = warnings
        self.errors = errors
        
    def __str__(self):
        """ Print error messages.
         
        Override the general-purpose special method such that a string 
        representation of an instance of this class will a string representation
        of the error messages.
        """
    
        problems = '\n' + str(len(self.errors)) + ' error(s), ' + str(len(self.compliance_errors)) + \
                   ' compliance error(s) and ' + str(len(self.warnings)) + ' warning(s) found:\n\n' 
        for e in self.errors:
            problems = problems + e + "\n\n"
        for ec in self.compliance_errors:
            problems = problems + ec + "\n\n"
        for w in self.warnings:
            problems = problems + w + "\n\n"
        
        return problems

class CcodeCompilationError(JError):
    """ Class for errors thrown when compiling a DLL file from c code."""
    pass

class XPathExpressionError(JError):
    """ Class representing errors in XPath expressions. """
    pass

class ParserConfigurationError(JError):
    """ Class for errors thrown when configuring XML parser. """
    pass

class SAXError(JError):
    """ Class representing a SAX error. """
    pass

class UnknownOptionError(JError):
    """ Class for error thrown when trying to access unknown compiler 
    option. 
    
    """
    pass
    
def _get_platform():
    """ Helper function. Returns string describing the platform 
        on which jmodelica is run. The different possible return values 
        are::
        
            win32
            win64
            darwin32
            darwin64
            linux32
            linux64
    """
    _platform = ''
    if sys.platform == 'win32':
        # windows
        _platform = 'win'
    elif sys.platform == 'darwin':
        # mac
        _platform = 'darwin'
    else:
        # assume linux
        _platform = 'linux'
    
    (bits, linkage) =  platform.architecture()
    if bits == '32bit':
        _platform = _platform +'32'
    else:
        _platform = _platform + '64'
    
    return _platform
    
    
