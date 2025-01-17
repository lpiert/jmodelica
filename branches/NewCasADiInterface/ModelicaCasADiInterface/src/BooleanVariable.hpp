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

#ifndef _MODELICACASADI_BOOLEAN_VAR
#define _MODELICACASADI_BOOLEAN_VAR

#include "symbolic/casadi.hpp"
#include "types/VariableType.hpp"
#include "Variable.hpp"
#include "Ref.hpp"

namespace ModelicaCasADi
{
class BooleanVariable : public Variable {
    public:
        /**
         * Create a Boolean variable. Boolean variables may not have
         * continuous variability. 
         * @param A symbolic MX
         * @param A Causality enum
         * @param A Variability enum
         * @param A VariableType, default is a reference to NULL. 
         */
        BooleanVariable(CasADi::MX var, Causality causality, 
                     Variability variability,
                      Ref<VariableType> declaredType = Ref<VariableType>());
        /** @return The Boolean Type enum */
        const Type getType() const;

        MODELICACASADI_SHAREDNODE_CHILD_PUBLIC_DEFS
};
inline const Variable::Type BooleanVariable::getType() const { return Variable::BOOLEAN; }
}; // End namespace
#endif
