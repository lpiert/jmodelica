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

#ifndef _MODELICACASADI_REAL_TYPE
#define _MODELICACASADI_REAL_TYPE
#include <string>
#include <map>

#include "types/PrimitiveType.hpp"
namespace ModelicaCasADi 
{
class RealType : public PrimitiveType { 
    public:
        /** A RealType has fixed default attributes */
        RealType(); 
        
        /** @return "Real" */
        const std::string getName() const;
        /** 
         * @param An AttributeKey
         * @return An AttributeValue, returns NULL if not present. 
         */
        AttributeValue* getAttribute(const AttributeKey key);
        /**
         * @param An AttributeKey
         * @return A bool
         */
        bool hasAttribute(const AttributeKey key) const;

        MODELICACASADI_SHAREDNODE_CHILD_PUBLIC_DEFS
};
inline const std::string RealType::getName() const { return "Real"; }
inline bool RealType::hasAttribute(const AttributeKey key) const { return attributes.find(AttributeKeyInternal(key))!=attributes.end(); }
}; // End namespace
#endif
