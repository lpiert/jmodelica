
"""
Module for writing optimization and simulation results to file.
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


import numpy as N
import array
import scipy.io

from operator import itemgetter

import jmodelica.jmi
from jmodelica import xmlparser

def export_result_dymola(model, data, file_name='', format='txt'):
    """
    Export an optimization or simulation result to file in Dymolas
    result file format. The parameter values are read from the z
    vector of the model object and the time series are read from
    the data argument.

    Parameters::
    
        model --
            A Model object.
        data --
            A two dimensional array of variable trajectory data. The
            first column represents the time vector. The following
            colums contain, in order, the derivatives, the states,
            the inputs and the algebraic variables. The ordering is
            according to increasing value references.
        file_name --
            If no file name is given, the name of the model (as defined
            by JMIModel.get_name()) concatenated with the string
            '_result' is used. A file suffix equal to the format
            argument is then appended to the file name.
            Default: Empty string.
        format --
            A text string equal either to 'txt' for textual format or
            'mat' for binary Matlab format.
            Default: txt

    Limitations::
    
        Currently only textual format is supported.

    """

    if (format=='txt'):

        if file_name=='':
            file_name=model.get_name() + '_result.txt'

        # Open file
        f = open(file_name,'w')

        # Write header
        f.write('#1\n')
        f.write('char Aclass(3,11)\n')
        f.write('Atrajectory\n')
        f.write('1.1\n')
        f.write('\n')
        
        #xmlfile = model.get_name()+'.xml'
        #md = xmlparser.ModelDescription(xmlfile)
        md = model._get_XMLDoc()
        
        # sort in value reference order (must match order in data)
        names = sorted(md.get_variable_names(), key=itemgetter(0))
        aliases = sorted(md.get_variable_aliases(), key=itemgetter(0))
        descriptions = sorted(md.get_variable_descriptions(), key=itemgetter(0))
        variabilities = sorted(md.get_variable_variabilities(), key=itemgetter(0))
        
        num_vars = len(names)
        
        # Find the maximum name and description length
        max_name_length = len('Time')
        max_desc_length = len('Time in [s]')
        
        for i in range(len(names)):
            name = names[i][1]
            desc = descriptions[i][1]
            
            if (len(name)>max_name_length):
                max_name_length = len(name)
                
            if (len(desc)>max_desc_length):
                max_desc_length = len(desc)

        f.write('char name(%d,%d)\n' % (num_vars + 1, max_name_length))
        f.write('time\n')
    
        # write names
        for name in names:
            f.write(name[1] +'\n')

        f.write('\n')

        f.write('char description(%d,%d)\n' % (num_vars + 1, max_desc_length))
        f.write('Time in [s]\n')

        # write descriptions
        for desc in descriptions:
            f.write(desc[1]+'\n')
            
        f.write('\n')

        # Write data meta information
        offs = model.get_offsets()
        n_parameters = offs[12] # offs[12] = offs_dx
        f.write('int dataInfo(%d,%d)\n' % (num_vars + 1, 4))
        f.write('0 1 0 -1 # time\n')

        cnt_1 = 1
        cnt_2 = 1
        
        for i, name in enumerate(names):
            (ref, type) = jmodelica.jmi._translate_value_ref(name[0])
            
            if int(ref) < n_parameters: # Put parameters in data set
                if aliases[i][1] == 0: # no alias
                    cnt_1 = cnt_1 + 1
                    f.write('1 %d 0 -1 # ' % cnt_1 + name[1]+'\n')
                elif aliases[i][1] == 1: # alias
                    f.write('1 %d 0 -1 # ' % cnt_1 + name[1]+'\n')
                else: # negated alias
                    f.write('1 -%d 0 -1 # ' % cnt_1 + name[1] +'\n')
                
                
            else:
                if aliases[i][1] == 0: # noalias
                    cnt_2 = cnt_2 + 1   
                    f.write('2 %d 0 -1 # ' % cnt_2 + name[1] +'\n')
                elif aliases[i][1] == 1: # alias
                    f.write('2 %d 0 -1 # ' % cnt_2 + name[1] +'\n')
                else: #neg alias
                    f.write('2 -%d 0 -1 # ' % cnt_2 + name[1] +'\n')
            
                
        f.write('\n')

        sc = model.jmimodel.get_variable_scaling_factors()
        z = model.get_z()

        scaling_method = model.get_scaling_method()

        # Write data
        # Write data set 1
        f.write('float data_1(%d,%d)\n' % (2, n_parameters + 1))
        f.write("%12.12f" % data[0,0])
        str_text = ''
        for ref in range(n_parameters):
            if scaling_method & jmodelica.jmi.JMI_SCALING_VARIABLES > 0:
                str_text += " %12.12f" % (z[ref]*sc[ref])
            else:
                str_text += " %12.12f" % (z[ref])
                
        f.write(str_text)
        f.write('\n')
        f.write("%12.12f" % data[-1,0])
        f.write(str_text)

        f.write('\n\n')

        # Write data set 2
        n_vars = len(data[0,:])
        n_points = len(data[:,0])
        f.write('float data_2(%d,%d)\n' % (n_points, n_vars))
        for i in range(n_points):
            str = ''
            for ref in range(n_vars):
                if ref==0: # Don't scale time
                    str = str + (" %12.12f" % data[i,ref])
                else:
                    if scaling_method & jmodelica.jmi.JMI_SCALING_VARIABLES > 0:
                        str = str + (" %12.12f" % (data[i,ref]*sc[ref-1+n_parameters]))
                    else:
                        str = str + (" %12.12f" % data[i,ref])
            f.write(str+'\n')

        f.write('\n')

        f.close()

    else:
        raise Error('Export on binary Dymola result files not yet supported.')

class Trajectory:
    """
    Class for storing a time series.
    """
    
    def __init__(self,t,x):
        """
        Constructor for the Trajectory class.

        Parameters::
        
            t --
                Abscissa of the trajectory.
            x --
                The ordinate of the trajectory.

        """
        self.t = t
        self.x = x

class ResultDymolaTextual:
    """ Class representing a simulation or optimization result loaded from a
    Dymola binary file.
    """

    def __init__(self,fname):
        """
        Load a result file written on Dymola textual format.

        Parameters::
        
            fname --
                Name of file.
        """
        fid = open(fname,'r')
        
        result  = [];
     
        # Read Aclass section
        l = fid.readline()
        tmp = l.partition('(')
        while tmp[0]!='char Aclass':
            l = fid.readline()
            tmp = l. partition('(')
        nLines = tmp[2].partition(',')
        nLines = int(nLines[0])
        Aclass = []
        for i in range(0,nLines):
            Aclass.append(fid.readline().strip())
        self.Aclass = Aclass

        # Read name section
        l = fid.readline()
        tmp = l.partition('(')
        while tmp[0]!='char name':
            l = fid.readline()
            tmp = l. partition('(')
        nLines = tmp[2].partition(',')
        nLines = int(nLines[0])
        name = []
        for i in range(0,nLines):
            name.append(fid.readline().strip().replace(" ",""))
        self.name = name
     
        # Read description section   
        l = fid.readline()
        tmp = l.partition('(')
        while tmp[0]!='char description':
            l = fid.readline()
            tmp = l. partition('(')
        nLines = tmp[2].partition(',')
        nLines = int(nLines[0])
        description = []
        for i in range(0,nLines):
            description.append(fid.readline().strip())
        self.description = description

        # Read dataInfo section
        l = fid.readline()
        tmp = l.partition('(')
        while tmp[0]!='int dataInfo':
            l = fid.readline()
            tmp = l. partition('(')
        nLines = tmp[2].partition(',')
        nCols = nLines[2].partition(')')
        nLines = int(nLines[0])
        nCols = int(nCols[0])
        dataInfo = []
        for i in range(0,nLines):
            info = fid.readline().split()
            dataInfo.append(map(int,info[0:nCols]))
        self.dataInfo = N.array(dataInfo)

        # Find out how many data matrices there are
        nData = 0
        for i in range(0,nLines):
            if dataInfo[i][0] > nData:
                nData = dataInfo[i][0]
                
        self.data = []
        for i in range(0,nData): 
            l = fid.readline()
            tmp = l.partition(' ')
            while tmp[0]!='float' and tmp[0]!='double':
                l = fid.readline()
                tmp = l. partition(' ')
            tmp = tmp[2].partition('(')
            nLines = tmp[2].partition(',')
            nCols = nLines[2].partition(')')
            nLines = int(nLines[0])
            nCols = int(nCols[0])
            data = []
            for i in range(0,nLines):
                info = []
                while len(info) < nCols:
                    l = fid.readline()
                    info.extend(l.split())
                data.append(map(float,info[0:nCols]))
                del(info)
            self.data.append(N.array(data))

    def get_variable_index(self,name): 
        """
        Retrieve the index in the name vector of a given variable.
        
        Parameters::
        
            name --
                Name of variable.
        
        Returns::
        
            In integer index.
        """
        try:
            return self.name.index(name)
        except ValueError, ex:
            raise VariableNotFoundError("Cannot find variable " +
                                        name + " in data file.")
            
    def get_variable_data(self,name):
        """
        Retrieve the data sequence for a variable with a given name.
        
        Parameters::
        
            name --
                Name of the variable.

        Returns::
        
            A Trajectory object containing the time vector and the data 
            vector of the variable.
        """
        varInd  = self.get_variable_index(name)
        dataInd = self.dataInfo[varInd][1]
        factor = 1
        if dataInd<0:
            factor = -1
            dataInd = -dataInd -1
        else:
            dataInd = dataInd - 1
        dataMat = self.dataInfo[varInd][0]-1
        # Take into account that the 'Time' variable has data matrix index 0,
        # which means that it is
        if dataMat<0:
            dataMat = 0
        return Trajectory(self.data[dataMat][:,0],factor*self.data[dataMat][:,dataInd])
        
        
class ResultDymolaBinary:
    """ Class representing a simulation or optimization result loaded 
        from a Dymola binary file.
    """

    def __init__(self,fname):
        """
        Load a result file written on Dymola binary format.

        Parameters::
        
            fname --
                Name of file.
        """
        self.raw = scipy.io.loadmat(fname,chars_as_strings=False)
        name = self.raw['name']
        self.name = [array.array('u',name[:,i].tolist()).tounicode().rstrip().replace(" ","") for i in range(0,name[0,:].size)]
        description = self.raw['description']
        self.description = [array.array('u',description[:,i].tolist()).tounicode().rstrip() for i in range(0,description[0,:].size)]
        
    def get_variable_index(self,name): 
        """
        Retrieve the index in the name vector of a given variable.
        
        Parameters::
        
            name --
                Name of variable.

        Returns::
        
            In integer index.
        """
        try:
            return self.name.index(name)
        except ValueError, ex:
            raise VariableNotFoundError("Cannot find variable " +
                                        name + " in data file.")
       
    def get_variable_data(self,name):
        """
        Retrieve the data sequence for a variable with a given name.
        
        Parameters::
        
            name --
                Name of the variable.

        Returns::
        
            A Trajectory object containing the time vector and the data vector
            of the variable.
        """
        varInd  = self.get_variable_index(name)
        dataInd = self.raw['dataInfo'][1][varInd]
        dataMat = self.raw['dataInfo'][0][varInd]
        factor = 1
        if dataInd<0:
            factor = -1
            dataInd = -dataInd -1
        else:
            dataInd = dataInd - 1
        
        # Take into account that the 'Time' variable has data matrix index 0
            
        if dataMat<1:
            dataMat = 1
        return Trajectory(self.raw['data_%d'%dataMat][0,:],factor*self.raw['data_%d'%dataMat][dataInd,:])

class ResultWriter():
    """ Base class for writing results to file. """
    
    def write_header():
        """ The header is intended to be used for writing general information
        about the model. This is intended to be called once.
        """
        pass
        
    def write_point():
        """ This method does the writing of the actual result. """
        pass
        
    def write_finalize():
        """ The finalize method can be used to for instance close the 
        file.
        """
        pass
        
class ResultWriterDymola(ResultWriter):
    """ Export an optimization or simulation result to file in Dymola's
    result file format.
    """
    def __init__(self, model, format='txt'):
        """
        Export an optimization or simulation result to file in Dymolas
        result file format.

        Parameters::
        
            model --
                A FMIModel object.
            format --
                A text string equal either to 'txt' for textual format or
                'mat' for binary Matlab format.
                Default: txt

        Limitations::
        
            Currently only textual format is supported.
        """
        self.model = model
        
        if format!='txt':
            raise JIOError('The format is currently not supported.')
        
        #Internal values
        self._file_open = False
        self._npoints = 0
        
    
    def write_header(self, file_name=''):
        """
        Opens the file and writes the header. This includes the 
        information about the variables and a table determining the link 
        between variables and data.
        
        Parameters::
        
            file_name --
                If no file name is given, the name of the model (as 
                defined by FMIModel.get_name()) concatenated with the 
                string '_result' is used. A file suffix equal to the 
                format argument is then appended to the file name.
                Default: Empty string.
        """
        if file_name=='':
            file_name=self.model.get_name() + '_result.txt'

        # Open file
        f = open(file_name,'w')
        self._file_open = True
        
        # Write header
        f.write('#1\n')
        f.write('char Aclass(3,11)\n')
        f.write('Atrajectory\n')
        f.write('1.1\n')
        f.write('\n')
        
        # all lists that we need for later
        vrefs_alias = []
        vrefs_noalias = []
        vrefs = []
        names_alias = []
        names_noalias = []
        names = []
        aliases_alias = []
        aliases = []
        descriptions_alias = []
        descriptions = []
        variabilities_alias = []
        variabilities_noalias = []
        variabilities = []
        types_alias = []
        types_noalias = []
        types = []
        
        for var in self.model._md.get_model_variables():
            ftype = var.get_fundamental_type()
            if not isinstance(ftype,xmlparser.String) and \
                not isinstance(ftype,xmlparser.Enumeration):
                    if var.get_alias() == xmlparser.NO_ALIAS:
                        vrefs_noalias.append(var.get_value_reference())
                        names_noalias.append(var.get_name())
                        aliases.append(var.get_alias())
                        descriptions.append(var.get_description())
                        variabilities_noalias.append(var.get_variability())
                        types_noalias.append(xmlparser._translate_fundamental_type(ftype))
                    else:
                        vrefs_alias.append(var.get_value_reference())
                        names_alias.append(var.get_name())
                        aliases_alias.append(var.get_alias())
                        descriptions_alias.append(var.get_description())
                        variabilities_alias.append(var.get_variability())
                        types_alias.append(xmlparser._translate_fundamental_type(ftype))
                        
        # need to save these no alias lists for later
        vrefs = vrefs_noalias[:]
        names = names_noalias[:]
        types = types_noalias[:]
        variabilities = variabilities_noalias[:]
        
        # merge lists
        vrefs.extend(vrefs_alias)
        names.extend(names_alias)
        aliases.extend(aliases_alias)
        descriptions.extend(descriptions_alias)
        variabilities.extend(variabilities_alias)
        types.extend(types_alias)
        
        # zip to list of tuples and sort - non alias variables are now
        # guaranteed to be first in list
        names_noalias = sorted(zip(tuple(vrefs_noalias),tuple(names_noalias)), key=itemgetter(0))
        variabilities_noalias = sorted(zip(tuple(vrefs_noalias),tuple(variabilities_noalias)), key=itemgetter(0))
        names = sorted(zip(tuple(vrefs),tuple(names)), key=itemgetter(0))
        aliases = sorted(zip(tuple(vrefs),tuple(aliases)), key=itemgetter(0))
        descriptions = sorted(zip(tuple(vrefs),tuple(descriptions)), key=itemgetter(0))
        variabilities = sorted(zip(tuple(vrefs),tuple(variabilities)), key=itemgetter(0))
        types = sorted(zip(tuple(vrefs),tuple(types)), key=itemgetter(0))
        
        num_vars = len(names)

        # Find the maximum name and description length
        max_name_length = len('Time')
        max_desc_length = len('Time in [s]')
        
        for i in range(len(names)):
            name = names[i][1]
            desc = descriptions[i][1]
            
            if (len(name)>max_name_length):
                max_name_length = len(name)
                
            if (len(desc)>max_desc_length):
                max_desc_length = len(desc)

        f.write('char name(%d,%d)\n' % (num_vars+1, max_name_length))
        f.write('time\n')

        for name in names:
            f.write(name[1] +'\n')

        f.write('\n')

        # Write descriptions       
        f.write('char description(%d,%d)\n' % (num_vars + 1, max_desc_length))
        f.write('Time in [s]\n')

        # Loop over all variables, not only those with a description
        for desc in descriptions:
            f.write(desc[1] +'\n')
                
        f.write('\n')

        # Write data meta information
        
        f.write('int dataInfo(%d,%d)\n' % (num_vars + 1, 4))
        f.write('0 1 0 -1 # time\n')
        
        list_of_continuous_states = N.append(self.model._save_cont_valueref[0],self.model._save_cont_valueref[1])
        list_of_continuous_states = N.append(list_of_continuous_states, self.model._save_cont_valueref[2]).tolist()
        list_of_continuous_states = dict(zip(list_of_continuous_states,xrange(len(list_of_continuous_states))))
        valueref_of_continuous_states = []
        
        cnt_1 = 1
        cnt_2 = 1
        n_parameters = 0
        for i, name in enumerate(names):
            if variabilities[i][1] == xmlparser.PARAMETER or \
                variabilities[i][1] == xmlparser.CONSTANT:
                if aliases[i][1] == 0: # no alias
                    cnt_1 += 1
                    n_parameters += 1
                    f.write('1 %d 0 -1 # ' % cnt_1 + name[1]+'\n')
                elif aliases[i][1] == 1: # alias
                    f.write('1 %d 0 -1 # ' % cnt_1 + name[1]+'\n')
                else: # negated alias
                    f.write('1 -%d 0 -1 # ' % cnt_1 + name[1] +'\n')
            else:
                if aliases[i][1] == 0: # noalias
                    valueref_of_continuous_states.append(list_of_continuous_states[name[0]])
                    cnt_2 += 1   
                    f.write('2 %d 0 -1 # ' % cnt_2 + name[1] +'\n')
                elif aliases[i][1] == 1: # alias
                    f.write('2 %d 0 -1 # ' % cnt_2 + name[1] +'\n')
                else: #neg alias
                    f.write('2 -%d 0 -1 # ' % cnt_2 + name[1] +'\n')
        f.write('\n')

        # Write data
        # Write data set 1
        f.write('float data_1(%d,%d)\n' % (2, n_parameters + 1))
        f.write("%12.12f" % self.model.time)
        str_text = ''
        
        # write constants and parameters
        for i, name in enumerate(names_noalias):
            if variabilities_noalias[i][1] == xmlparser.CONSTANT or \
                variabilities_noalias[i][1] == xmlparser.PARAMETER:
                    if types_noalias[i] == xmlparser.REAL:
                        str_text = str_text + (" %12.12f" % (self.model.get_real([name[0]])))
                    elif types_noalias[i] == xmlparser.INTEGER:
                        str_text = str_text + (" %12.12f" % (self.model.get_integer([name[0]])))
                    elif types_noalias[i] == xmlparser.BOOLEAN:
                        str_text = str_text + (" %12.12f" % (float(self.model.get_boolean([name[0]])[0])))
                        
                    
        f.write(str_text)
        f.write('\n')
        self._point_last_t = f.tell()
        f.write("%s" % ' '*28)
        f.write(str_text)

        f.write('\n\n')
        
        self._nvariables = len(valueref_of_continuous_states)+1
        
        
        f.write('float data_2(')
        self._point_npoints = f.tell()
        f.write(' '*(14+4+14))
        f.write('\n')
        
        #f.write('%s,%d)\n' % (' '*14, self._nvariables))
        
        self._file = f
        self._data_order = valueref_of_continuous_states
        
    def write_point(self, data=None):
        """ Writes the current status of the model to file. If the header
        has not been written previously it is written now. If data is 
        specified it is written instead of the current status.
        
        Parameters::
            
                data --
                    A one dimensional array of variable trajectory data.
                    data should consist of information about the status
                    in the order specified by FMIModel.save_time_point()
                    Default: None
        """
        f = self._file
        data_order = self._data_order

        #If data is none, store the current point from the model
        if data==None:
            #Retrieves the time-point
            [r,i,b] = self.model.save_time_point()
            data = N.append(N.append(N.append(self.model.time,r),i),b)

        #Write the point
        str_text = (" %12.12f" % data[0])
        for j in xrange(self._nvariables-1):
            str_text = str_text + (" %12.12f" % (data[1+data_order[j]]))
        f.write(str_text+'\n')
        
        #Update number of points
        self._npoints+=1

    def write_finalize(self):
        """ Finalize the writing by filling in the blanks in the created 
        file. The blanks consists of the number of points and the final 
        time (in data set 1). Also closes the file.
        """
        #If open, finalize and close
        if self._file_open:
            
            f = self._file
            
            f.seek(self._point_last_t)
            
            f.write('%12.12f'%self.model.time)
            
            f.seek(self._point_npoints)
            f.write('%d,%d)' % (self._npoints, self._nvariables))
            #f.write('%d'%self._npoints)
            f.seek(-1,2)
            #Close the file
            f.write('\n')
            f.close()
            self._file_open = False
    
    
class JIOError(Exception):
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
         
        Overrides the general-purpose special method such that a string 
        representation of an instance of this class will be the error 
        message.
        """
        return self.message


class VariableNotFoundError(JIOError):
    """ Exception that is thrown when a variable is not found in a
    data file.
    """
    pass
