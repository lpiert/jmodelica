/* --------------------------------------------------------------------------
CppAD: C++ Algorithmic Differentiation: Copyright (C) 2003-07 Bradley M. Bell

CppAD is distributed under multiple licenses. This distribution is under
the terms of the 
                    Common Public License Version 1.0.

A copy of this license is included in the COPYING file of this distribution.
Please visit http://www.coin-or.org/CppAD/ for information on other licenses.
-------------------------------------------------------------------------- */

/*
Comprehensive test of Trigonometric and Hyperbolic Sine and Cosine
*/

# include <cppad/cppad.hpp>
# include <cmath>

namespace { // Begin empty namespace

bool Sin(void)
{	bool ok = true;

	using CppAD::sin;
	using CppAD::cos;
	using namespace CppAD;

	// independent variable vector
	double x = .5;
	double y = .8;
	CPPAD_TEST_VECTOR< AD<double> > X(2);
	X[0]     = x;
	X[1]     = y;
	Independent(X);

	// dependent variable vector 
	CPPAD_TEST_VECTOR< AD<double> > Z(1);
	AD<double> U = X[0] * X[1];
	Z[0] = sin( U ); 

	// create f: X -> Z and vectors used for derivative calculations
	// f(x, y) = sin(x, y)
	ADFun<double> f(X, Z); 
	CPPAD_TEST_VECTOR<double> v( 2 );
	CPPAD_TEST_VECTOR<double> w( 1 );

	// check value 
	double sin_u = sin( Value(U) );
	double cos_u = cos( Value(U) );

	ok &= NearEqual(sin_u, Value(Z[0]),  1e-10 , 1e-10);

	// forward computation of partials w.r.t. u
	size_t j;
	size_t p     = 5;
	double jfac  = 1.;
	v[0]         = 1.;  // differential w.r.t. x
	v[1]         = 0;   // differential w.r.t. y
	double yj    = 1;   // y^j
	for(j = 1; j < p; j++)
	{	w      = f.Forward(j, v);	

		// compute j-th power of y
		yj *= y ;

		// compute j-th derivartive of sin function
		double sinj;
		if( j % 4 == 1 )
			sinj = cos_u;
		else if( j % 4 == 2 )
			sinj = -sin_u;
		else if( j % 4 == 3 )
			sinj = -cos_u;
		else	sinj = sin_u;

		jfac *= j;

		// check j-th derivative of z w.r.t x
		ok &= NearEqual(jfac*w[0], sinj * yj, 1e-10 , 1e-10); 

		v[0]  = 0.;
	}

	// reverse computation of partials of Taylor coefficients
	CPPAD_TEST_VECTOR<double> r( 2 * p); 
	w[0]  = 1.;
	r     = f.Reverse(p, w);
	jfac  = 1.;
	yj    = 1.;
	double sinjp = 0.;
	for(j = 0; j < p; j++)
	{
		double sinj = sinjp;

		// compute j+1 derivative of sin funciton
		if( j % 4 == 0 )
			sinjp = cos_u;
		else if( j % 4 == 1 )
			sinjp = -sin_u;
		else if( j % 4 == 2 )
			sinjp = -cos_u;
		else	sinjp = sin_u;

		// derivative w.r.t x of sin^{(j)} (x * y) * y^j
		ok &= NearEqual(jfac*r[0+j], sinjp * yj * y, 1e-10 , 1e-10);

		// derivative w.r.t y of sin^{(j)} (x * y) * y^j
		double value = sinjp * yj * x + j * sinj * yj / y;
		ok &= NearEqual(jfac*r[p+j], value , 1e-10 , 1e-10);

		jfac  *= (j + 1);
		yj    *= y;
	}

	return ok;
}

bool Cos(void)
{	bool ok = true;

	using CppAD::sin;
	using CppAD::cos;
	using namespace CppAD;

	// independent variable vector
	double x = .5;
	double y = .8;
	CPPAD_TEST_VECTOR< AD<double> > X(2);
	X[0]     = x;
	X[1]     = y;
	Independent(X);

	// dependent variable vector 
	CPPAD_TEST_VECTOR< AD<double> > Z(1);
	AD<double> U = X[0] * X[1];
	Z[0] = cos( U ); 

	// create f: X -> Z and vectors used for derivative calculations
	// f(x, y) = cos(x, y)
	ADFun<double> f(X, Z); 
	CPPAD_TEST_VECTOR<double> v( 2 );
	CPPAD_TEST_VECTOR<double> w( 1 );

	// check value 
	double sin_u = sin( Value(U) );
	double cos_u = cos( Value(U) );

	ok &= NearEqual(cos_u, Value(Z[0]),  1e-10 , 1e-10);

	// forward computation of partials w.r.t. u
	size_t j;
	size_t p     = 5;
	double jfac  = 1.;
	v[0]         = 1.;  // differential w.r.t. x
	v[1]         = 0;   // differential w.r.t. y
	double yj    = 1;   // y^j
	for(j = 1; j < p; j++)
	{	w      = f.Forward(j, v);	

		// compute j-th power of y
		yj *= y ;

		// compute j-th derivartive of cos function
		double cosj;
		if( j % 4 == 1 )
			cosj = -sin_u;
		else if( j % 4 == 2 )
			cosj = -cos_u;
		else if( j % 4 == 3 )
			cosj = sin_u;
		else	cosj = cos_u;

		jfac *= j;

		// check j-th derivative of z w.r.t x
		ok &= NearEqual(jfac*w[0], cosj * yj, 1e-10 , 1e-10); 

		v[0]  = 0.;
	}

	// reverse computation of partials of Taylor coefficients
	CPPAD_TEST_VECTOR<double> r( 2 * p); 
	w[0]  = 1.;
	r     = f.Reverse(p, w);
	jfac  = 1.;
	yj    = 1.;
	double cosjp = 0.;
	for(j = 0; j < p; j++)
	{
		double cosj = cosjp;

		// compute j+1 derivative of cos funciton
		if( j % 4 == 0 )
			cosjp = -sin_u;
		else if( j % 4 == 1 )
			cosjp = -cos_u;
		else if( j % 4 == 2 )
			cosjp = sin_u;
		else	cosjp = cos_u;

		// derivative w.r.t x of cos^{(j)} (x * y) * y^j
		ok &= NearEqual(jfac*r[0+j], cosjp * yj * y, 1e-10 , 1e-10);

		// derivative w.r.t y of cos^{(j)} (x * y) * y^j
		double value = cosjp * yj * x + j * cosj * yj / y;
		ok &= NearEqual(jfac*r[p+j], value , 1e-10 , 1e-10);

		jfac  *= (j + 1);
		yj    *= y;
	}

	return ok;
}

bool Cosh(void)
{	bool ok = true;

	using CppAD::sinh;
	using CppAD::cosh;
	using namespace CppAD;

	// independent variable vector
	double x = .5;
	double y = .8;
	CPPAD_TEST_VECTOR< AD<double> > X(2);
	X[0]     = x;
	X[1]     = y;
	Independent(X);

	// dependent variable vector 
	CPPAD_TEST_VECTOR< AD<double> > Z(1);
	AD<double> U = X[0] * X[1];
	Z[0] = cosh( U ); 

	// create f: X -> Z and vectors used for derivative calculations
	// f(x, y) = cosh(x, y)
	ADFun<double> f(X, Z); 
	CPPAD_TEST_VECTOR<double> v( 2 );
	CPPAD_TEST_VECTOR<double> w( 1 );

	// check value 
	double sinh_u = sinh( Value(U) );
	double cosh_u = cosh( Value(U) );

	ok &= NearEqual(cosh_u, Value(Z[0]),  1e-10 , 1e-10);

	// forward computation of partials w.r.t. u
	size_t j;
	size_t p     = 5;
	double jfac  = 1.;
	v[0]         = 1.;  // differential w.r.t. x
	v[1]         = 0;   // differential w.r.t. y
	double yj    = 1;   // y^j
	for(j = 1; j < p; j++)
	{	w      = f.Forward(j, v);	

		// compute j-th power of y
		yj *= y ;

		// compute j-th derivartive of cosh function
		double coshj;
		if( j % 2 == 1 )
			coshj = sinh_u;
		else	coshj = cosh_u;

		jfac *= j;

		// check j-th derivative of z w.r.t x
		ok &= NearEqual(jfac*w[0], coshj * yj, 1e-10 , 1e-10); 

		v[0]  = 0.;
	}

	// reverse computation of partials of Taylor coefficients
	CPPAD_TEST_VECTOR<double> r( 2 * p); 
	w[0]  = 1.;
	r     = f.Reverse(p, w);
	jfac  = 1.;
	yj    = 1.;
	double coshjp = 0.;
	for(j = 0; j < p; j++)
	{
		double coshj = coshjp;

		// compute j+1 derivative of cosh funciton
		if( j % 2 == 0 )
			coshjp = sinh_u;
		else	coshjp = cosh_u;

		// derivative w.r.t x of cosh^{(j)} (x * y) * y^j
		ok &= NearEqual(jfac*r[0+j], coshjp * yj * y, 1e-10 , 1e-10);

		// derivative w.r.t y of cosh^{(j)} (x * y) * y^j
		double value = coshjp * yj * x + j * coshj * yj / y;
		ok &= NearEqual(jfac*r[p+j], value , 1e-10 , 1e-10);

		jfac  *= (j + 1);
		yj    *= y;
	}

	return ok;
}

bool Sinh(void)
{	bool ok = true;

	using CppAD::sinh;
	using CppAD::cosh;
	using namespace CppAD;

	// independent variable vector
	double x = .5;
	double y = .8;
	CPPAD_TEST_VECTOR< AD<double> > X(2);
	X[0]     = x;
	X[1]     = y;
	Independent(X);

	// dependent variable vector 
	CPPAD_TEST_VECTOR< AD<double> > Z(1);
	AD<double> U = X[0] * X[1];
	Z[0] = sinh( U ); 

	// create f: X -> Z and vectors used for derivative calculations
	// f(x, y) = sinh(x, y)
	ADFun<double> f(X, Z); 
	CPPAD_TEST_VECTOR<double> v( 2 );
	CPPAD_TEST_VECTOR<double> w( 1 );

	// check value 
	double sinh_u = sinh( Value(U) );
	double cosh_u = cosh( Value(U) );

	ok &= NearEqual(sinh_u, Value(Z[0]),  1e-10 , 1e-10);

	// forward computation of partials w.r.t. u
	size_t j;
	size_t p     = 5;
	double jfac  = 1.;
	v[0]         = 1.;  // differential w.r.t. x
	v[1]         = 0;   // differential w.r.t. y
	double yj    = 1;   // y^j
	for(j = 1; j < p; j++)
	{	w      = f.Forward(j, v);	

		// compute j-th power of y
		yj *= y ;

		// compute j-th derivartive of sinh function
		double sinhj;
		if( j % 2 == 1 )
			sinhj = cosh_u;
		else	sinhj = sinh_u;

		jfac *= j;

		// check j-th derivative of z w.r.t x
		ok &= NearEqual(jfac*w[0], sinhj * yj, 1e-10 , 1e-10); 

		v[0]  = 0.;
	}

	// reverse computation of partials of Taylor coefficients
	CPPAD_TEST_VECTOR<double> r( 2 * p); 
	w[0]  = 1.;
	r     = f.Reverse(p, w);
	jfac  = 1.;
	yj    = 1.;
	double sinhjp = 0.;
	for(j = 0; j < p; j++)
	{
		double sinhj = sinhjp;

		// compute j+1 derivative of sinh funciton
		if( j % 2 == 0 )
			sinhjp = cosh_u;
		else	sinhjp = sinh_u;

		// derivative w.r.t x of sinh^{(j)} (x * y) * y^j
		ok &= NearEqual(jfac*r[0+j], sinhjp * yj * y, 1e-10 , 1e-10);

		// derivative w.r.t y of sinh^{(j)} (x * y) * y^j
		double value = sinhjp * yj * x + j * sinhj * yj / y;
		ok &= NearEqual(jfac*r[p+j], value , 1e-10 , 1e-10);

		jfac  *= (j + 1);
		yj    *= y;
	}

	return ok;
}

} // End empty namespace

bool SinCos(void)
{	bool ok = Sin() & Cos() & Cosh() & Sinh();
	return ok;
}
	
