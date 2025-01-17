/*
Copyright (C) 2013 Modelon AB

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, version 3 of the License.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#ifndef _MODELICACASADI_COMPILER_OPTIONS_WRAPPER
#define _MODELICACASADI_COMPILER_OPTIONS_WRAPPER
#include <string>
#include <iostream>

#include "SharedNode.hpp"
#include "org/jmodelica/util/OptionRegistry.h"

namespace ModelicaCasADi 
{
class CompilerOptionsWrapper: public SharedNode {
    public:
        CompilerOptionsWrapper(); 
        void setStringOption(std::string opt, std::string val);
        void setBooleanOption(std::string opt, bool val);
        void setIntegerOption(std::string opt, int val);
        void setRealOption(std::string opt, double val);
        
        void addStringOption(std::string opt, std::string val);
        void addBooleanOption(std::string opt, bool val);
        void addIntegerOption(std::string opt, int val);
        void addRealOption(std::string opt, double val);
        
        org::jmodelica::util::OptionRegistry getOptionRegistry();
        
        /** Allows the use of the operator << to print this class to a stream, through Printable */
        virtual void print(std::ostream& os) const;

        MODELICACASADI_SHAREDNODE_CHILD_PUBLIC_DEFS
    private:
        org::jmodelica::util::OptionRegistry optr;
};
inline CompilerOptionsWrapper::CompilerOptionsWrapper() : optr() {}
inline org::jmodelica::util::OptionRegistry CompilerOptionsWrapper::getOptionRegistry() { return optr; }
}; // End namespace
#endif
