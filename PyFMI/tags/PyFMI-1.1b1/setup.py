#!/usr/bin/env python 
# -*- coding: utf-8 -*-

# Copyright (C) 2011 Modelon AB
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

#from distutils.core import setup, Extension
from distutils.ccompiler import new_compiler
from distutils.core import setup

import distutils
import os as O
import shutil
import numpy as N
from numpy.distutils.misc_util import Configuration
#from numpy.distutils.core import setup
from numpy.distutils.command.build_clib import build_clib
import sys

try:
    from Cython.Distutils import build_ext
    from Cython.Build import cythonize
except ImportError:
    raise Exception("Please upgrade to a newer Cython version, >= 0.15.")

NAME = "PyFMI"
AUTHOR = "Modelon AB"
AUTHOR_EMAIL = ""
VERSION = "1.1b1"
LICENSE = "GPL"
URL = "http://www.jmodelica.org"
DOWNLOAD_URL = "http://pypi.python.org/pypi/PyFMI"
DESCRIPTION = "A package for working with dynamic models compliant with the Functional Mock-Up Interface standard."
PLATFORMS = ["Linux", "Windows", "MacOS X"]
CLASSIFIERS = [ 'Programming Language :: Python',
                'Operating System :: MacOS :: MacOS X',
                'Operating System :: Microsoft :: Windows',
                'Operating System :: Unix']

LONG_DESCRIPTION = """
PyFMI is a package for loading and interacting with Functional Mock-Up 
Units (FMUs), which are compiled dynamic models compliant with the 
Functional Mock-Up Interface (FMI), see 
http://www.functional-mockup-interface.org/ for more information. PyFMI
is based on FMI Library, see http://www.jmodelica.org/FMILibrary .

FMI is a standard that enables tool independent exchange of dynamic 
models on binary format. Several industrial simulation platforms 
supports export of FMUs, including, Dymola, JModelica.org, OpenModelica 
and SimulationX, see http://www.functional-mockup-interface.org/tools 
for a complete list. PyFMI offers a Python interface for interacting 
with FMUs and enables for example loading of FMU models, setting of 
model parameters and evaluation of model equations.

PyFMI is available as a stand-alone package or as part of the 
JModelica.org distribution. Using PyFMI together with the Python 
simulation package `Assimulo <http://pypi.python.org/pypi/Assimulo>`_ adds industrial grade simulation 
capabilities of FMUs to Python.

For a forum discussing usage and development of PyFMI, see http://www.jmodelica.org/forum.

Requirements:
-------------
- `FMI Library <http://www.jmodelica.org/FMILibrary>`_
- `Numpy <http://pypi.python.org/pypi/numpy>`_
- `Scipy <http://pypi.python.org/pypi/scipy>`_
- `lxml <http://pypi.python.org/pypi/lxml>`_
- `Assimulo <http://pypi.python.org/pypi/Assimulo>`_

Optional
---------
- `wxPython <http://pypi.python.org/pypi/wxPython>`_ For the Plot GUI.
- `matplotlib <http://pypi.python.org/pypi/matplotlib>`_ For the Plot GUI.
"""

copy_args=sys.argv[1:]

incdirs = ""
libdirs = ""
static = False
debug_flag = True
fmilib_shared = ""

static_link_gcc = ["-static-libgcc"]

####NECESSECARY FOR THE DEPRECATED FMI LOGGER
#Load the helper function
if sys.platform == 'win32':
    suffix = '.dll'
elif sys.platform == 'darwin':
    suffix = '.dylib'
else:
    suffix = '.so'

path_log_src = "src"+O.path.sep+"pyfmi"+O.path.sep+"util" + O.path.sep + "FMILogger.c"
path_log_dest = "src"+O.path.sep+"pyfmi"+O.path.sep+"util" + O.path.sep + "FMILogger" + suffix

O.system("gcc -fPIC "+path_log_src+" -shared -o "+path_log_dest)
########


# Fix path sep
for x in sys.argv[1:]:
    if not x.find('--prefix'):
        copy_args[copy_args.index(x)] = x.replace('/',O.sep)
    if not x.find('--fmil-home'):
        incdirs = O.path.join(x[12:],'include')
        libdirs = O.path.join(x[12:],'lib')
        copy_args.remove(x)
    if not x.find('--static'):
        static = x[9:]
        if x[9:].upper() == "TRUE":
            static = True
        else:
            static = False
        copy_args.remove(x)

#Check to see if FMILIB_SHARED exists and if so copy it
files = O.listdir(O.path.join(libdirs))
for file in files:
    if "fmilib_shared" in file and not file.endswith("a"):
        shutil.copy2(O.path.join(libdirs,file),O.path.join(".","src","pyfmi"))
        fmilib_shared = O.path.join(".","src","pyfmi",file)
        break
else:
    raise Exception("Could not find FMILibrary at: %s"%libdirs)

def check_extensions():
    ext_list = []
    """
    delgenC = O.path.join("src","pyfmi","fmi.c")
    if O.path.exists(delgenC):
        try:
            O.remove(delgenC)
        except:
            pass
    """
    if static:
        extra_link_flags = static_link_gcc
    else:
        extra_link_flags = [""]

    #COMMON PYX
    """
    ext_list = cythonize(["src"+O.path.sep+"common"+O.path.sep+"core.pyx"], 
                    include_path=[".","src","src"+O.sep+"common"],
                    include_dirs=[N.get_include()],pyrex_gdb=debug)
    
    ext_list[-1].include_dirs = [N.get_include(), "src","src"+O.sep+"common", incdirs]
        
    if debug:
        ext_list[-1].extra_compile_args = ["-g", "-fno-strict-aliasing", "-ggdb"]
        ext_list[-1].extra_link_args = extra_link_flags
    else:
        ext_list[-1].extra_compile_args = ["-O2", "-fno-strict-aliasing"]
        ext_list[-1].extra_link_args = extra_link_flags
    """
    
    #FMI PYX
    ext_list += cythonize(["src"+O.path.sep+"pyfmi"+O.path.sep+"fmi.pyx"], 
                    include_path=[".","src","src"+O.sep+"pyfmi"],
                    include_dirs=[N.get_include()],pyrex_gdb=debug_flag)

    ext_list[-1].include_dirs = [N.get_include(), "src","src"+O.sep+"pyfmi", incdirs]
    ext_list[-1].library_dirs = [libdirs]
    ext_list[-1].language = "c"
    ext_list[-1].libraries = ["fmilib_shared"]
    
    if "win" in sys.platform:
        pass
    elif "darwin" in sys.platform:
        ext_list[-1].runtime_library_dirs = [",@loader_path/"]
    else:
        ext_list[-1].runtime_library_dirs = [",'$ORIGIN'"]
    
    if debug_flag:
        ext_list[-1].extra_compile_args = ["-g", "-fno-strict-aliasing", "-ggdb"]
        ext_list[-1].extra_link_args = extra_link_flags
    else:
        ext_list[-1].extra_compile_args = ["-O2", "-fno-strict-aliasing"]
        ext_list[-1].extra_link_args = extra_link_flags

    return ext_list

ext_list = check_extensions()

setup(name=NAME,
      version=VERSION,
      license=LICENSE,
      description=DESCRIPTION,
      long_description=LONG_DESCRIPTION,
      author=AUTHOR,
      author_email=AUTHOR_EMAIL,
      url=URL,
      download_url=DOWNLOAD_URL,
      platforms=PLATFORMS,
      classifiers=CLASSIFIERS,
      ext_modules = ext_list,
      package_dir = {'pyfmi':'src'+O.path.sep+'pyfmi','pyfmi.common':'src'+O.path.sep+'common'},
      packages=['pyfmi','pyfmi.simulation','pyfmi.examples','pyfmi.common','pyfmi.common.plotting'],
      package_data = {'pyfmi':['examples'+O.path.sep+'files'+O.path.sep+'FMUs'+O.path.sep+'*','util'+O.path.sep+'*','*fmilib_shared*']},
      script_args=copy_args
      )


#Dont forget to delete fmilib_shared
if O.path.exists(fmilib_shared):
    O.remove(fmilib_shared)
