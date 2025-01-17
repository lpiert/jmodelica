/* --------------------------------------------------------------------------
CppAD: C++ Algorithmic Differentiation: Copyright (C) 2003-06 Bradley M. Bell

CppAD is distributed under multiple licenses. This distribution is under
the terms of the 
                    Common Public License Version 1.0.

A copy of this license is included in the COPYING file of this distribution.
Please visit http://www.coin-or.org/CppAD/ for information on other licenses.
-------------------------------------------------------------------------- */

/*
$begin NumericType.cpp$$

$section The NumericType: Example and Test$$
$index NumericType, example$$
$index example, NumericType$$
$index test, NumericType$$

$code
$verbatim%example/numeric_type.cpp%0%// BEGIN PROGRAM%// END PROGRAM%1%$$
$$

$end
*/
// BEGIN PROGRAM

# include <cppad/cppad.hpp>

namespace { // Empty namespace

	// -------------------------------------------------------------------
	class MyType {
	private:
		double d;
	public:
		// constructor from void 
		MyType(void) : d(0.)
		{ }
		// constructor from an int 
		MyType(int d_) : d(d_)
		{ }
		// copy constructor
		MyType(const MyType &x) 
		{	d = x.d; }
		// assignment operator
		void operator = (const MyType &x)
		{	d = x.d; }
		// member function that converts to double
		double Double(void) const
		{	return d; }
		// unary plus
		MyType operator + (void) const
		{	MyType x;
			x.d =  d;
			return x; 
		}
		// unary plus
		MyType operator - (void) const
		{	MyType x;
			x.d = - d;
			return x; 
		}
		// binary addition
		MyType operator + (const MyType &x) const
		{	MyType y;
			y.d = d + x.d ;
			return y; 
		}
		// binary subtraction
		MyType operator - (const MyType &x) const
		{	MyType y;
			y.d = d - x.d ;
			return y; 
		}
		// binary multiplication
		MyType operator * (const MyType &x) const
		{	MyType y;
			y.d = d * x.d ;
			return y; 
		}
		// binary division
		MyType operator / (const MyType &x) const
		{	MyType y;
			y.d = d / x.d ;
			return y; 
		}
		// computed assignment addition
		void operator += (const MyType &x)
		{	d += x.d; }
		// computed assignment subtraction
		void operator -= (const MyType &x)
		{	d -= x.d; }
		// computed assignment multiplication
		void operator *= (const MyType &x)
		{	d *= x.d; }
		// computed assignment division
		void operator /= (const MyType &x)
		{	d /= x.d; }
	};
}
bool NumericType(void)
{	bool ok  = true;
	using CppAD::AD;
	using CppAD::CheckNumericType;

	CheckNumericType<MyType>            ();

	CheckNumericType<int>               ();
	CheckNumericType<double>            ();
	CheckNumericType< AD<double> >      ();
	CheckNumericType< AD< AD<double> > >();

	return ok;
}

// END PROGRAM
