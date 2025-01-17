/* $Id: check_simple_vector.hpp 1556 2009-10-21 14:41:47Z bradbell $ */
# ifndef CPPAD_CHECK_SIMPLE_VECTOR_INCLUDED
# define CPPAD_CHECK_SIMPLE_VECTOR_INCLUDED

/* --------------------------------------------------------------------------
CppAD: C++ Algorithmic Differentiation: Copyright (C) 2003-09 Bradley M. Bell

CppAD is distributed under multiple licenses. This distribution is under
the terms of the 
                    Common Public License Version 1.0.

A copy of this license is included in the COPYING file of this distribution.
Please visit http://www.coin-or.org/CppAD/ for information on other licenses.
-------------------------------------------------------------------------- */
/*
$begin CheckSimpleVector$$
$spell
	const
	cppad.hpp
	CppAD
$$

$section Check Simple Vector Concept$$

$index simple, vector check$$
$index vector, simple check$$
$index check, simple vector$$
$index concept, check simple vector$$

$head Syntax$$
$code # include <cppad/check_simple_vector.hpp>$$
$pre
$$
$codei%CheckSimpleVector<%Scalar%, %Vector%>()%$$
$pre
$$
$codei%CheckSimpleVector<%Scalar%, %Vector%>(%x%, %y%)%$$


$head Purpose$$
Preforms compile and run time checks that the type specified
by $icode Vector$$ satisfies all the requirements for 
a $xref/SimpleVector/$$ class with 
$xref/SimpleVector/Elements of Specified Type/elements of type/$$ 
$icode Scalar$$.
If a requirement is not satisfied,
a an error message makes it clear what condition is not satisfied.

$head x, y$$
If the arguments $icode x$$ and $icode y$$ are present,
they have prototype
$codei%
	const %Scalar%& %x%
	const %Scalar%& %y%
%$$
In addition, the check
$code%
	%x% == %x%
%$$
will return the boolean value $code true$$, and 
$code%
	%x% == %y%
%$$
will return $code false$$.

$head Restrictions$$
If the arguments $icode x$$ and $icode y$$ are not present,
the following extra assumption is made by $code CheckSimpleVector$$:
If $icode x$$ is a $icode Scalar$$ object
$codei%
	%x% = 0
	%y% = 1
%$$
assigns values to the objects $icode x$$ and $icode y$$.
In addition, 
$icode%x% == %x%$$ would return the boolean value $code true$$ and
$icode%x% == %y%$$ would return $code false$$.

$head Include$$
The file $code cppad/check_simple_vector.hpp$$ is included by $code cppad/cppad.hpp$$
but it can also be included separately with out the rest
if the CppAD include files.

$head Example$$
$children%
	example/check_simple_vector.cpp
%$$
The file $xref/CheckSimpleVector.cpp/$$
contains an example and test of this function where $icode S$$
is the same as $icode T$$.
It returns true, if it succeeds an false otherwise.
The comments in this example suggest a way to change the example
so $icode S$$ is not the same as $icode T$$.

$end
---------------------------------------------------------------------------
*/

# include <cppad/local/cppad_assert.hpp>

namespace CppAD {

# ifdef NDEBUG
	template <class Scalar, class Vector>
	inline void CheckSimpleVector(void)
	{ }
# else
	template <class S, class T>
	struct ok_if_S_same_as_T { };

	template <class T>
	struct ok_if_S_same_as_T<T,T> { typedef T ok; };

	template <class Scalar, class Vector>
	void CheckSimpleVector(const Scalar& x, const Scalar& y)
	{	// only need execute once per value Scalar, Vector pair
		static bool runOnce = false;
		if( runOnce )
			return;
		runOnce = true;

		// value_type must be type of elements of Vector
		typedef typename Vector::value_type value_type;

		// check that elements of Vector have type Scalar
		typedef typename ok_if_S_same_as_T<Scalar, value_type>::ok ok;

		// check default constructor
		Vector d;

		// size member function
		CPPAD_ASSERT_KNOWN(
			d.size() == 0,
			"default construtor result does not have size zero"
		);

		// resize to same size as other vectors in test
		d.resize(1);

		// check sizing constructor
		Vector s(1);

		// check element assignment
		s[0] = y;
		CPPAD_ASSERT_KNOWN(
			s[0] == y,
			"element assignment failed"
		);

		// check copy constructor
		s[0] = x;
		const Vector c(s);
		s[0] = y;
		CPPAD_ASSERT_KNOWN(
			c[0] == x,
			"copy constructor is shallow"
		);

		// vector assignment operator
		d[0] = x;
		s    = d;
		s[0] = y;
		CPPAD_ASSERT_KNOWN(
			d[0] == x,
			"assignment operator is shallow"
		);

		// element access, right side const
		// element assignment, left side not const
		d[0] = c[0];
		CPPAD_ASSERT_KNOWN(
			d[0] == x,
			"element assignment from const failed" 
		);
	}
	template <class Scalar, class Vector>
	void CheckSimpleVector(void)
	{	Scalar x;
		Scalar y;

		// use assignment and not constructor
		x = 0;
		y = 1;

		CheckSimpleVector<Scalar, Vector>(x, y);
	}

# endif

} // end namespace CppAD

# endif
