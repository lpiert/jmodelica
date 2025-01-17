/* --------------------------------------------------------------------------
CppAD: C++ Algorithmic Differentiation: Copyright (C) 2003-07 Bradley M. Bell

CppAD is distributed under multiple licenses. This distribution is under
the terms of the 
                    Common Public License Version 1.0.

A copy of this license is included in the COPYING file of this distribution.
Please visit http://www.coin-or.org/CppAD/ for information on other licenses.
-------------------------------------------------------------------------- */

/*
$begin reverse_two.cpp$$
$spell
	Cpp
$$

$section Second Order Reverse ModeExample and Test$$

$index reverse, second order$$
$index example, second order reverse$$
$index test, second order reverse$$

$code
$verbatim%example/reverse_two.cpp%0%// BEGIN PROGRAM%// END PROGRAM%1%$$
$$

$end
*/
// BEGIN PROGRAM
# include <cppad/cppad.hpp>
namespace { // ----------------------------------------------------------
// define the template function reverse_two_cases<Vector> in empty namespace
template <typename Vector> 
bool reverse_two_cases(void)
{	bool ok = true;
	using CppAD::AD;
	using CppAD::NearEqual;

	// domain space vector
	size_t n = 2;
	CPPAD_TEST_VECTOR< AD<double> > X(n);
	X[0] = 0.; 
	X[1] = 1.;

	// declare independent variables and start recording
	CppAD::Independent(X);

	// range space vector
	size_t m = 1;
	CPPAD_TEST_VECTOR< AD<double> > Y(m);
	Y[0] = X[0] * X[0] * X[1];

	// create f : X -> Y and stop recording
	CppAD::ADFun<double> f(X, Y);

	// use zero order forward mode to evaluate y at x = (3, 4)
	// use the template parameter Vector for the vector type
	Vector x(n), y(m);
	x[0]  = 3.;
	x[1]  = 4.;
	y     = f.Forward(0, x);
	ok    &= NearEqual(y[0] , x[0]*x[0]*x[1], 1e-10, 1e-10);

	// use first order forward mode in x[0] direction
	// (all second order partials below involve x[0])
	Vector dx(n), dy(m);
	dx[0] = 1.;
	dx[1] = 1.;
	dy    = f.Forward(1, dx);
	double check = 2.*x[0]*x[1]*dx[0] + x[0]*x[0]*dx[1];
	ok   &= NearEqual(dy[0], check, 1e-10, 1e-10);

	// use second order reverse mode to evalaute second partials of y[0]
	// with respect to (x[0], x[0]) and with respect to (x[0], x[1])
	Vector w(m), dw( n * 2 );
	w[0]  = 1.;
	dw    = f.Reverse(2, w);

	// check derivative of f
	ok   &= NearEqual(dw[0*2+0] , 2.*x[0]*x[1], 1e-10, 1e-10);
	ok   &= NearEqual(dw[1*2+0] ,    x[0]*x[0], 1e-10, 1e-10);

	// check derivative of f^{(1)} (x) * dx
	check = 2.*x[1]*dx[1] + 2.*x[0]*dx[1];
	ok   &= NearEqual(dw[0*2+1] , check, 1e-10, 1e-10); 
	check = 2.*x[0]*dx[1];
	ok   &= NearEqual(dw[1*2+1] , check, 1e-10, 1e-10); 

	return ok;
}
} // End empty namespace 
# include <vector>
# include <valarray>
bool reverse_two(void)
{	bool ok = true;
	ok &= reverse_two_cases< CppAD::vector  <double> >();
	ok &= reverse_two_cases< std::vector    <double> >();
	ok &= reverse_two_cases< std::valarray  <double> >();
	return ok;
}
// END PROGRAM
