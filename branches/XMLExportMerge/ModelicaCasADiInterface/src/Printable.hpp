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

#ifndef _MODELICACASADI_PRINTABLE
#define _MODELICACASADI_PRINTABLE
#include <sstream>
#include <iostream>
#include <string>

namespace ModelicaCasADi
{
class Printable {
    public:
        virtual void print(std::ostream& os) const;
        
        friend std::ostream& operator<<(std::ostream& os, const Printable& p);
        std::string repr();
};

inline std::ostream &operator<<(std::ostream &os, const Printable &p) {
    p.print(os);
    return os;
}

inline std::string Printable::repr() {
    std::stringstream s;
    s << *this;
    return s.str();    
}

inline void Printable::print(std::ostream& os) const {
    // Test code to help debug python printing problems. Todo: remove
    os << "<This is a Printable>";
}

#ifdef SWIG
%extend Printable{
  std::string __str__()  { return $self->repr(); }
  std::string __repr__() { return $self->repr(); }
}
#endif // SWIG    

} // End namespace

#endif // _MODELICACASADI_PRINTABLE
