/* --------------------------------------------------------------------------
CppAD: C++ Algorithmic Differentiation: Copyright (C) 2003-07 Bradley M. Bell

CppAD is distributed under multiple licenses. This distribution is under
the terms of the 
                    Common Public License Version 1.0.

A copy of this license is included in the COPYING file of this distribution.
Please visit http://www.coin-or.org/CppAD/ for information on other licenses.
-------------------------------------------------------------------------- */

/*
// Old GetStarted example now used just for validation testing
*/
// BEGIN PROGRAM

// directory where cppad/cppad.hpp is stored must be searched by compiler
# include <cppad/cppad.hpp>

bool Poly(void)
{	bool ok = true;

	// make CppAD routines visible without CppAD:: infront of names
	using namespace CppAD;

	// degree of the polynomial that we will differentiate
	size_t deg = 4;

	// vector that will hold polynomial coefficients for p(z)
	CPPAD_TEST_VECTOR< AD<double> > A(deg + 1);  // AD<double> elements
	CPPAD_TEST_VECTOR<double>       a(deg + 1);  //    double  elements

	// set the polynomial coefficients
	A[0] = 1.;
	size_t k;
	for(k = 1; k <= deg; k++)
		A[k] = a[k] = 1.;

	// independent variables
	CPPAD_TEST_VECTOR< AD<double> > Z(1); // one independent variable
	Z[0]     = 3.;                        // value of independent variable
	Independent(Z);                       // declare independent variable

	// dependent variables 
	CPPAD_TEST_VECTOR< AD<double> > P(1); // one dependent variable
	P[0]     = Poly(0, A, Z[0]);    // value of polynomial at Z[0]

	// define f : Z -> P as a function mapping independent to dependent 
	ADFun<double> f(Z, P);          // ADFun corresponding to polynomial

	// compute derivative of polynomial
	CPPAD_TEST_VECTOR<double> z(1);  // vector length f.Domain()
	CPPAD_TEST_VECTOR<double> J(1);  // vector length f.Range * f.Domain()
	z[0] = 3.;                 // point at which to compute derivative
	J    = f.Jacobian(z);      // value of derivative

	// compare with derivative as computed by Poly
	ok  &= (Poly(1, a, z[0]) == J[0]);

	return ok;
}

// END PROGRAM
