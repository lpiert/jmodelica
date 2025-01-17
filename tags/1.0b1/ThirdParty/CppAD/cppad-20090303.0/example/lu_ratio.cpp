/* --------------------------------------------------------------------------
CppAD: C++ Algorithmic Differentiation: Copyright (C) 2003-07 Bradley M. Bell

CppAD is distributed under multiple licenses. This distribution is under
the terms of the 
                    Common Public License Version 1.0.

A copy of this license is included in the COPYING file of this distribution.
Please visit http://www.coin-or.org/CppAD/ for information on other licenses.
-------------------------------------------------------------------------- */

/*
$begin LuRatio.cpp$$
$spell
	Geq
	Cpp
	Lu
$$

$section LuRatio: Example and Test$$

$index example, LuRatio$$
$index test, LuRatio$$

$code
$verbatim%example/lu_ratio.cpp%0%// BEGIN PROGRAM%// END PROGRAM%1%$$
$$

$end
*/

// BEGIN PROGRAM
# include <cstdlib>               // for rand function
# include <cassert>
# include <cppad/cppad.hpp>

namespace { // Begin empty namespace

CppAD::ADFun<double> *NewFactor(
	size_t                           n ,
	const CPPAD_TEST_VECTOR<double> &x , 
	bool                           &ok ,
	CPPAD_TEST_VECTOR<size_t>      &ip , 
	CPPAD_TEST_VECTOR<size_t>      &jp )
{	using CppAD::AD;
	using CppAD::ADFun;
	size_t i, j, k;

	// values for independent and dependent variables
	CPPAD_TEST_VECTOR< AD<double> > Y(n*n+1), X(n*n);

	// values for the LU factor
	CPPAD_TEST_VECTOR< AD<double> > LU(n*n);

	// record the LU factorization corresponding to this value of x
	AD<double> Ratio;
	for(k = 0; k < n*n; k++)
		X[k] = x[k];
	Independent(X);
	for(k = 0; k < n*n; k++)
		LU[k] = X[k];
	CppAD::LuRatio(ip, jp, LU, Ratio);
	for(k = 0; k < n*n; k++)
		Y[k] = LU[k];
	Y[n*n] = Ratio;

	// use a function pointer so can return ADFun object
	ADFun<double> *FunPtr = new ADFun<double>(X, Y);

	// check value of ratio during recording
	ok &= (Ratio == 1.);

	// check that ip and jp are permutations of the indices 0, ... , n-1
	for(i = 0; i < n; i++)
	{	ok &= (ip[i] < n);
		ok &= (jp[i] < n);
		for(j = 0; j < n; j++)
		{	if( i != j )
			{	ok &= (ip[i] != ip[j]);
				ok &= (jp[i] != jp[j]);
			}
		}
	}
	return FunPtr; 
}
bool CheckLuFactor(
	size_t                           n  ,
	const CPPAD_TEST_VECTOR<double> &x  ,
	const CPPAD_TEST_VECTOR<double> &y  ,
	const CPPAD_TEST_VECTOR<size_t> &ip ,
	const CPPAD_TEST_VECTOR<size_t> &jp )
{	bool     ok = true;	

	double  sum;                          // element of L * U
	double  pij;                          // element of permuted x
	size_t  i, j, k;                      // temporary indices

	// L and U factors
	CPPAD_TEST_VECTOR<double>  L(n*n), U(n*n);

	// Extract L from LU factorization
	for(i = 0; i < n; i++)
	{	// elements along and below the diagonal
		for(j = 0; j <= i; j++)
			L[i * n + j] = y[ ip[i] * n + jp[j] ];
		// elements above the diagonal
		for(j = i+1; j < n; j++)
			L[i * n + j] = 0.;
	}

	// Extract U from LU factorization
	for(i = 0; i < n; i++)
	{	// elements below the diagonal
		for(j = 0; j < i; j++)
			U[i * n + j] = 0.;
		// elements along the diagonal
		U[i * n + i] = 1.;
		// elements above the diagonal
		for(j = i+1; j < n; j++)
			U[i * n + j] = y[ ip[i] * n + jp[j] ];
	}

	// Compute L * U 
	for(i = 0; i < n; i++)
	{	for(j = 0; j < n; j++)
		{	// compute element (i,j) entry in L * U
			sum = 0.;
			for(k = 0; k < n; k++)
				sum += L[i * n + k] * U[k * n + j];
			// element (i,j) in permuted version of A
			pij  = x[ ip[i] * n + jp[j] ];
			// compare
			ok  &= CppAD::NearEqual(pij, sum, 1e-10, 1e-10);
		}
	}
	return ok;
}

} // end Empty namespace

bool LuRatio(void)
{	bool  ok = true;

	size_t  n = 2; // number rows in A 
	double  ratio;

	// values for independent and dependent variables
	CPPAD_TEST_VECTOR<double>  x(n*n), y(n*n+1);

	// pivot vectors
	CPPAD_TEST_VECTOR<size_t> ip(n), jp(n);

	// set x equal to the identity matrix
	x[0] = 1.; x[1] = 0;
	x[2] = 0.; x[3] = 1.;

	// create a fnction object corresponding to this value of x
	CppAD::ADFun<double> *FunPtr = NewFactor(n, x, ok, ip, jp);

	// use function object to factor matrix
	y     = FunPtr->Forward(0, x);
	ratio = y[n*n];
	ok   &= (ratio == 1.);
	ok   &= CheckLuFactor(n, x, y, ip, jp);

	// set x so that the pivot ratio will be infinite
	x[0] = 0. ; x[1] = 1.;
	x[2] = 1. ; x[3] = 0.;

	// try to use old function pointer to factor matrix
	y     = FunPtr->Forward(0, x);
	ratio = y[n*n];

	// check to see if we need to refactor matrix
	ok &= (ratio > 10.);
	if( ratio > 10. )
	{	delete FunPtr; // to avoid a memory leak	
		FunPtr = NewFactor(n, x, ok, ip, jp);
	}

	//  now we can use the function object to factor matrix
	y     = FunPtr->Forward(0, x);
	ratio = y[n*n];
	ok    &= (ratio == 1.);
	ok    &= CheckLuFactor(n, x, y, ip, jp);

	delete FunPtr;  // avoid memory leak
	return ok;
}
// END PROGRAM
