# ifndef CPPAD_DET_BY_MINOR_INCLUDED
# define CPPAD_DET_BY_MINOR_INCLUDED

/* --------------------------------------------------------------------------
CppAD: C++ Algorithmic Differentiation: Copyright (C) 2003-07 Bradley M. Bell

CppAD is distributed under multiple licenses. This distribution is under
the terms of the 
                    Common Public License Version 1.0.

A copy of this license is included in the COPYING file of this distribution.
Please visit http://www.coin-or.org/CppAD/ for information on other licenses.
-------------------------------------------------------------------------- */
/*
$begin det_by_minor$$
$spell
	cppad
	typedef
	const
	hpp
	Det
	CppADvector
	namespace
$$

$section Determinant Using Expansion by Minors$$

$index determinant, minor expansion$$
$index minor, expansion determinant$$
$index expansion, minor determinant$$


$head Syntax$$
$syntax%# include <cppad/speed/det_by_minor.hpp>
%$$
$syntax%det_by_minor<%Scalar%> %det%(%n%)
%$$
$syntax%%d% = %det%(%a%)
%$$

$head Inclusion$$
The template class $code det_by_minor$$ is defined in the $code CppAD$$
namespace by including 
the file $code cppad/speed/det_by_minor.hpp$$
(relative to the CppAD distribution directory).
It is only intended for example and testing purposes, 
so it is not automatically included by
$cref/cppad.hpp/cppad/$$.

$head Constructor$$
The syntax
$syntax%
	det_by_minor<%Scalar%> %det%(%n%)
%$$
constructs the object $italic det$$ which can be used for 
evaluating the determinant of $italic n$$ by $italic n$$ matrices
using expansion by minors.

$head Scalar$$
The type $italic Scalar$$ must satisfy the same conditions
as in the function $cref/det_of_minor/det_of_minor/Scalar/$$.

$head n$$
The argument $italic n$$ has prototype
$syntax%
	size_t %n%
%$$

$head det$$
The syntax
$syntax%
	%d% = %det%(%a%)
%$$
returns the determinant of the matrix $italic A$$ using expansion by minors.

$subhead a$$
The argument $italic a$$ has prototype
$syntax%
	const %Vector% &%a%
%$$
It must be a $italic Vector$$ with length $latex n * n$$ and with
elements of type $italic Scalar$$.
The elements of the $latex n \times n$$ matrix $latex A$$ are defined,
for $latex i = 0 , \ldots , n-1$$ and $latex j = 0 , \ldots , n-1$$, by
$latex \[
	A_{i,j} = a[ i * m + j]
\] $$

$subhead d$$
The return value $italic d$$ has prototype
$syntax%
	%Scalar% %d%
%$$
It is equal to the determinant of $latex A$$.

$head Vector$$
If $italic y$$ is a $italic Vector$$ object, 
it must support the syntax
$syntax%
	%y%[%i%]
%$$
where $italic i$$ has type $code size_t$$ with value less than $latex n * n$$.
This must return a $italic Scalar$$ value corresponding to the $th i$$
element of the vector $italic y$$.
This is the only requirement of the type $italic Vector$$.

$children%
	speed/example/det_by_minor.cpp%
	omh/det_by_minor_hpp.omh
%$$


$head Example$$
The file
$xref/det_by_minor.cpp/$$ 
contains an example and test of $code det_by_minor.hpp$$.
It returns true if it succeeds and false otherwise.

$head Source Code$$
The file
$xref/det_by_minor.hpp/$$ 
contains the source for this template function.


$end
---------------------------------------------------------------------------
*/
// BEGIN PROGRAM
# include <cppad/cppad.hpp>
# include <cppad/speed/det_of_minor.hpp>

// BEGIN CppAD namespace
namespace CppAD {

template <class Scalar>
class det_by_minor {
private:
	size_t              m_;

	// made mutable because modified and then restored
	mutable std::vector<size_t> r_;
	mutable std::vector<size_t> c_;

	// make mutable because its value does not matter
	mutable std::vector<Scalar> a_;
public:
	det_by_minor(size_t m) : m_(m) , r_(m + 1) , c_(m + 1), a_(m * m)
	{
		size_t i;

		// values for r and c that correspond to entire matrix
		for(i = 0; i < m; i++)
		{	r_[i] = i+1;
			c_[i] = i+1;
		}
		r_[m] = 0;
		c_[m] = 0;
	}

	template <class Vector>
	inline Scalar operator()(const Vector &x) const
	{	size_t i = m_ * m_;
		while(i--)
			a_[i] = x[i];
		return det_of_minor(a_, m_, m_, r_, c_); 
	}

};

} // END CppAD namespace
// END PROGRAM
# endif
