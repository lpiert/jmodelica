/* --------------------------------------------------------------------------
CppAD: C++ Algorithmic Differentiation: Copyright (C) 2003-07 Bradley M. Bell

CppAD is distributed under multiple licenses. This distribution is under
the terms of the 
                    Common Public License Version 1.0.

A copy of this license is included in the COPYING file of this distribution.
Please visit http://www.coin-or.org/CppAD/ for information on other licenses.
-------------------------------------------------------------------------- */

/*
$begin TapeIndex.cpp$$

$section Taping Array Index Operation: Example and Test$$

$index array, tape index operation$$
$index index, tape array operation$$
$index tape, array index operation$$

$code
$verbatim%example/tape_index.cpp%0%// BEGIN PROGRAM%// END PROGRAM%1%$$
$$

$end
*/
// BEGIN PROGRAM
# include <cppad/cppad.hpp>

namespace {
	double Array(const double &index)
	{	static double array[] = {
			5.,
			4.,
			3.,
			2.,
			1.
		};
		static size_t number = sizeof(array) / sizeof(array[0]);
		if( index < 0. )
			return array[0];

		size_t i = static_cast<size_t>(index);
		if( i >= number )
			return array[number-1];

		return array[i];
	}
	// in empty namespace and outside any other routine
	CPPAD_DISCRETE_FUNCTION(double, Array)
}

bool TapeIndex(void)
{	bool ok = true;
	using CppAD::AD;

	// domain space vector
	size_t n = 2;
	CPPAD_TEST_VECTOR< AD<double> > X(n);
	X[0] = 2.;   // array index value
	X[1] = 3.;   // multiplier of array index value

	// declare independent variables and start tape recording
	CppAD::Independent(X);

	// range space vector
	size_t m = 1;
	CPPAD_TEST_VECTOR< AD<double> > Y(m);
	Y[0] = X[1] * Array( X[0] );

	// create f: X -> Y and stop tape recording
	CppAD::ADFun<double> f(X, Y);

	// vectors for arguments to the function object f
	CPPAD_TEST_VECTOR<double> x(n);   // argument values
	CPPAD_TEST_VECTOR<double> y(m);   // function values 
	CPPAD_TEST_VECTOR<double> w(m);   // function weights 
	CPPAD_TEST_VECTOR<double> dw(n);  // derivative of weighted function

	// check function value
	x[0] = Value(X[0]);
	x[1] = Value(X[1]);
	y[0] = Value(Y[0]);
	ok  &= y[0] == x[1] * Array(x[0]);

	// evaluate f where x has different values
	x[0] = x[0] + 1.;  // new array index value
	x[1] = x[1] + 1.;  // new multiplier value
	y    = f.Forward(0, x);
	ok  &= y[0] == x[1] * Array(x[0]);

	// evaluate derivaitve of y[0] 
	w[0] = 1.;
	dw   = f.Reverse(1, w);
	ok   &= dw[0] == 0.;              // partial w.r.t array index
	ok   &= dw[1] == Array(x[0]);     // partial w.r.t multiplier

	return ok;
}

// END PROGRAM
