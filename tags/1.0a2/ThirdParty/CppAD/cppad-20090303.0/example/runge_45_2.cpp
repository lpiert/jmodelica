/* --------------------------------------------------------------------------
CppAD: C++ Algorithmic Differentiation: Copyright (C) 2003-09 Bradley M. Bell

CppAD is distributed under multiple licenses. This distribution is under
the terms of the 
                    Common Public License Version 1.0.

A copy of this license is included in the COPYING file of this distribution.
Please visit http://www.coin-or.org/CppAD/ for information on other licenses.
-------------------------------------------------------------------------- */

/*
$begin runge_45_2.cpp$$
$spell
	Runge
$$

$section Runge45: Example and Test$$

$index Runge45, example$$
$index example, Runge45$$
$index test, Runge45$$

Define 
$latex X : \R \times \R \rightarrow \R^n$$ by
$latex \[
	X_j (b, t) =  b \left( \sum_{k=0}^j t^k / k ! \right)
\] $$ 
for $latex j = 0 , \ldots , n-1$$.
It follows that
$latex \[
\begin{array}{rcl}
X_j  (b, 0)   & = & b                                                     \\
\partial_t X_j (b, t)   & = & b \left( \sum_{k=0}^{j-1} t^k / k ! \right) \\
\partial_t X_j (b, t)   & = & \left\{ \begin{array}{ll}
	0               & {\rm if} \; j = 0  \\
	X_{j-1} (b, t)  & {\rm otherwise}
\end{array} \right.
\end{array}
\] $$
For a fixed $latex t_f$$,
we can use $cref/Runge45/$$ to define 
$latex f : \R \rightarrow \R^n$$ as an approximation for
$latex f(b) = X(b, t_f )$$.
We can then compute $latex f^{(1)} (b)$$ which is an approximation for
$latex \[
	\partial_b X(b, t_f ) =  \sum_{k=0}^j t_f^k / k !
\] $$

$code
$verbatim%example/runge_45_2.cpp%0%// BEGIN PROGRAM%// END PROGRAM%1%$$
$$

$end
*/
// BEGIN PROGRAM

# include <cstddef>              // for size_t
# include <limits>               // for machine epsilon
# include <cppad/cppad.hpp>      // for all of CppAD

namespace {

	template <class Scalar>
	class Fun {
	public:
		// constructor
		Fun(void) 
		{ }

		// set return value to X'(t)
		void Ode(
			const Scalar                    &t, 
			const CPPAD_TEST_VECTOR<Scalar> &x, 
			CPPAD_TEST_VECTOR<Scalar>       &f)
		{	size_t n  = x.size();	
			f[0]      = 0.;
			for(size_t k = 1; k < n; k++)
				f[k] = x[k-1];
		}
	};
}

bool runge_45_2(void)
{	typedef CppAD::AD<double> Scalar;
	using CppAD::NearEqual;

	bool ok = true;     // initial return value
	size_t j;           // temporary indices

	size_t     n = 5;   // number components in X(t) and order of method
	size_t     M = 2;   // number of Runge45 steps in [ti, tf]
	Scalar ad_ti = 0.;  // initial time
	Scalar ad_tf = 2.;  // final time 

	// value of independent variable at which to record operations
	CPPAD_TEST_VECTOR<Scalar> ad_b(1);
	ad_b[0] = 1.;

	// declare b to be the independent variable
	Independent(ad_b);
	
	// object to evaluate ODE
	Fun<Scalar> ad_F; 

	// xi = X(0)
	CPPAD_TEST_VECTOR<Scalar> ad_xi(n); 
	for(j = 0; j < n; j++)
		ad_xi[j] = ad_b[0];

	// compute Runge45 approximation for X(tf)
	CPPAD_TEST_VECTOR<Scalar> ad_xf(n), ad_e(n); 
	ad_xf = CppAD::Runge45(ad_F, M, ad_ti, ad_tf, ad_xi, ad_e);

	// stop recording and use it to create f : b -> xf
	CppAD::ADFun<double> f(ad_b, ad_xf);

	// evaluate f(b)
	CPPAD_TEST_VECTOR<double>  b(1);
	CPPAD_TEST_VECTOR<double> xf(n);
	b[0] = 1.;
	xf   = f.Forward(0, b);

	// check that f(b) = X(b, tf)
	double tf    = Value(ad_tf);
	double term  = 1;
	double sum   = 0;
	double eps   = 10. * std::numeric_limits<double>::epsilon();
	for(j = 0; j < n; j++)
	{	sum += term;
		ok &= NearEqual(xf[j], b[0] * sum, eps, eps);
		term *= tf;
		term /= double(j+1);
	}

	// evalute f'(b)
	CPPAD_TEST_VECTOR<double> d_xf(n);
	d_xf = f.Jacobian(b);

	// check that f'(b) = partial of X(b, tf) w.r.t b
	term  = 1;
	sum   = 0;
	for(j = 0; j < n; j++)
	{	sum += term;
		ok &= NearEqual(d_xf[j], sum, eps, eps);
		term *= tf;
		term /= double(j+1);
	}
	
	return ok;
}

// END PROGRAM
