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

#ifndef _MODELICACASADI_VAR
#define _MODELICACASADI_VAR

#include <iostream>
#include <map>

#include "symbolic/casadi.hpp"
#include "boost/flyweight.hpp"

#include "types/VariableType.hpp"
#include "OwnedNode.hpp"
#include "Ref.hpp"
namespace ModelicaCasADi
{
class Model;

/** 
 * Abstract class for Variables, using symolic MX. A variable holds data 
 * so that it can represent a Modelica or Optimica variable. This data
 * consists of attributes and enum variables that tells the variable's
 * primitive data type and its causality and variability. 
 * 
 * A variable can also hold a VariableType that contains information about 
 * its default attributes or the attributes of its user defined type. 
 */

class Variable : public OwnedNode {
    public:
        typedef std::string AttributeKey; 
        typedef CasADi::MX AttributeValue;
    protected:
        typedef boost::flyweights::flyweight<std::string> AttributeKeyInternal;
        typedef std::map<AttributeKeyInternal,AttributeValue> attributeMap;
    public:
        enum Type {
            REAL,
            INTEGER,
            BOOLEAN,
            STRING
        };
        enum Causality {
            INPUT,
            OUTPUT,
            INTERNAL
        };
        enum Variability {
            CONSTANT,
            PARAMETER,
            DISCRETE,
            CONTINUOUS
        };
        Variable(Model *owner);
        /**
         * The Variable class should not be used, use subclasses such 
         * as RealVariable instead.
         * @param A symbolic MX.
         * @param An entry of the enum Causality
         * @param An entry of the enum Variability
         * @param A VariableType, default is a reference to NULL. 
         */
        Variable(Model *owner, CasADi::MX var, Causality causality,
                Variability variability, 
                Ref<VariableType> declaredType = Ref<VariableType>());
        
        /** @return True if this variable is an alias */
        bool isAlias() const;
        /** @return True if this variable is negated */
        bool isNegated() const;
        /** @param Bool negated . Only possible for Alias variables*/
        void setNegated(bool negated);
        /** @param Sets an alias for this variable, making this an alias variable */
        void setAlias(Ref<Variable> var);
        /** @return This variable's model variable if it is an alias, or itself otherwise */
        Ref<Variable> getModelVariable();
        // const Ref<Variable> getModelVariable() const; // will we need this one?
        
        
        /* Getters and setters for standard Modelica attributes */
        void setQuantity(std::string quantity);
        void setQuantity(CasADi::MX quantity);
        CasADi::MX* getQuantity();
        
        void setNominal(double nominal);
        void setNominal(CasADi::MX nominal);
        CasADi::MX* getNominal();
        
        void setUnit(std::string unit);
        void setUnit(CasADi::MX unit);
        CasADi::MX* getUnit();
        
        void setDisplayUnit(std::string displayUnit);
        void setDisplayUnit(CasADi::MX displayUnit);
        CasADi::MX* getDisplayUnit();
        
        void setMin(double min);
        void setMin(CasADi::MX min);
        CasADi::MX* getMin();
        
        void setMax(double max);
        void setMax(CasADi::MX max);
        CasADi::MX* getMax();
        
        void setStart(double start);
        void setStart(CasADi::MX start);
        CasADi::MX* getStart();
        
        void setFixed(bool fixed);
        void setFixed(CasADi::MX fixed);
        CasADi::MX* getFixed();
        
        
        
        /**
         * @return The string name of this Variable 
         */
        std::string getName() const;
        
        /**
         * @return A MX
         */        
        const CasADi::MX getVar() const;
        /**
         * @return An enum for the primitive data type.
         */ 
        virtual const Type getType() const;
        /**
         * @return An enum for the causality
         */
        const Causality getCausality() const;
        /**
         * @return An enum for the variability.
         */
        const Variability getVariability() const;
        /**
         * Returns the Variable's declared type. This may be one of Modelica's
         * built in types such as Real, which holds Real's default attributes, 
         * or it may be a user defined type.
         * @return A pointer to a VariableType. 
         */
        Ref<VariableType> getDeclaredType() const;
        /**
         * Sets the declared type
         * @param A pointer to a VariableType
         */
        void setDeclaredType(Ref<VariableType> declaredType);
        
        /** 
         * Looks at local attributes, then at attributes for is declared type,
         * OR at the attributes of its alias if this is an alias variable. 
         * Returns NULL if not present.
         * @param An AttributeKey
         * @return A pointer to an AttributeValue 
         */
        virtual AttributeValue* getAttribute(AttributeKey key);
        /** 
         * A check whether a certain attribute is set in this variable,
         * OR in its alias if this is an alias variable. 
         * @return A bool.  
         */
        bool hasAttributeSet(AttributeKey key) const; 
        /** 
         * Sets an attribute in the local Variable's attribute map, 
         * or it propagates the attribute to its alias if this is an
         * alias variable. 
         * @param An AttributeKey
         * @param An AttributeValue
         */
        void setAttribute(AttributeKey key, AttributeValue val);
        /** 
         * Sets an attribute in the local Variable's attribute map, 
         * or it propagates the attribute to its alias if this is an
         * alias variable. 
         * @param An AttributeKey
         * @param A double.
         */
        void setAttribute(AttributeKey key, double val);
        
        /** Allows the use of the operator << to print this class to a stream, through Printable */
        virtual void print(std::ostream& os) const;
        
        MODELICACASADI_SHAREDNODE_CHILD_PUBLIC_DEFS
    protected:
        Ref<Variable> myModelVariable; /// If this Variable is a alias, this is its corresponding model variable. 
        bool negated;
        Ref<VariableType> declaredType;
        CasADi::MX var;
        attributeMap attributes;
        AttributeValue* getAttributeForAlias(AttributeKey key);
        AttributeKey keyForAlias(AttributeKey key) const;
        void setAttributeForAlias(AttributeKey key, AttributeValue val);
        Model &myModel() { return *((Model *)owner); }
    private:
        Causality causality;
        Variability variability;
};
inline bool Variable::isAlias() const { return myModelVariable != Ref<Variable>(NULL); }
inline bool Variable::isNegated() const { return negated; }
inline void Variable::setNegated(bool negated) { 
    if (!isAlias()) {
        throw std::runtime_error("Only alias variables may be negated");
    }
    this->negated = negated; 
}
inline void Variable::setAlias(Ref<Variable> modelVariable) { this->myModelVariable = modelVariable; }
inline Ref<Variable> Variable::getModelVariable() { return isAlias() ? myModelVariable : this; }
inline std::string Variable::getName() const { return var.getName(); }
inline const Variable::Type Variable::getType() const { throw std::runtime_error("Variable does not have a type"); }
inline void Variable::setDeclaredType(Ref<VariableType> declaredType) { this->declaredType = declaredType; }
inline Ref<VariableType> Variable::getDeclaredType() const { return declaredType; }
inline const CasADi::MX Variable::getVar() const { return var; }
inline const Variable::Causality Variable::getCausality() const { return causality; }
inline const Variable::Variability Variable::getVariability() const { return variability; }
}; // End namespace
#endif
