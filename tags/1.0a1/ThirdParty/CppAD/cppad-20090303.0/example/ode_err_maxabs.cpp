/* --------------------------------------------------------------------------
CppAD: C++ Algorithmic Differentiation: Copyright (C) 2003-06 Bradley M. Bell

CppAD is distributed under multiple licenses. This distribution is under
the terms of the 
                    Common Public License Version 1.0.

A copy of this license is included in the COPYING file of this distribution.
Please visit http://www.coin-or.org/CppAD/ for information on other licenses.
-------------------------------------------------------------------------- */

/*
$begin OdeErrMaxabs.cpp$$
$spell
	Runge
	Maxabs
$$

$section OdeErrControl: Example and Test Using Maxabs Argument$$

$index OdeErrControl, example$$
$index OdeErrControl, maxabs$$
$index example, OdeErrControl$$
$index test, OdeErrControl$$
$index maxabs, OdeErrControl$$

Define 
$latex X : \R \rightarrow \R^2$$ by
$latex \[
\begin{array}{rcl}
X_0 (t) & = &  - \exp ( - w_0 t )  \\
X_1 (t) & = & \frac{w_0}{w_1 - w_0} [ \exp ( - w_0 t ) - \exp( - w_1 t )]
\end{array}
\] $$
It follows that $latex X_0 (0) = 1$$, $latex X_1 (0) = 0$$ and
$latex \[
\begin{array}{rcl}
	X_0^{(1)} (t) & = & - w_0 X_0 (t)  \\
	X_1^{(1)} (t) & = & + w_0 X_0 (t) - w_1 X_1 (t) 
\end{array}
\] $$
Note that $latex X_1 (0)$$ is zero an if $latex w_0 t$$ is large,
$latex X_0 (t)$$ is near zero.
This example tests OdeErrControl using the $italic maxabs$$ argument.

$code
$verbatim%example/ode_err_maxabs.cpp%0%// BEGIN PROGRAM%// END PROGRAM%1%$$
$$

$end
*/
// BEGIN PROGRAM

# include <cstddef>              // for size_t
# include <cmath>                // for exp
# include <cppad/ode_err_control.hpp>   // CppAD::OdeErrControl
# include <cppad/near_equal.hpp>    // CppAD::NearEqual
# include <cppad/vector.hpp> // CppAD::vector
# include <cppad/runge_45.hpp>      // CppAD::Runge45

namespace {
	// --------------------------------------------------------------
	class Fun {
	private:
		 CppAD::vector<double> w;
	public:
		// constructor
		Fun(const CppAD::vector<double> &w_) : w(w_)
		{ } 

		// set f = x'(t)
		void Ode(
			const double                &t, 
			const CppAD::vector<double> &x, 
			CppAD::vector<double>       &f)
		{	f[0] = - w[0] * x[0];
			f[1] = + w[0] * x[0] - w[1] * x[1];	
		}
	};

	// --------------------------------------------------------------
	class Method {
	private:
		Fun F;
	public:
		// constructor
		Method(const CppAD::vector<double> &w_) : F(w_)
		{ }
		void step(
			double ta, 
			double tb, 
			CppAD::vector<double> &xa ,
			CppAD::vector<double> &xb ,
			CppAD::vector<double> &eb )
		{	xb = CppAD::Runge45(F, 1, ta, tb, xa, eb);
		}
		size_t order(void)
		{	return 4; }
	};
}

bool OdeErrMaxabs(void)
{	bool ok = true;     // initial return value

	CppAD::vector<double> w(2);
	w[0] = 10.;
	w[1] = 1.;
	Method method(w);

	CppAD::vector<double> xi(2);
	xi[0] = 1.;
	xi[1] = 0.;

	CppAD::vector<double> eabs(2);
	eabs[0] = 0.;
	eabs[1] = 0.;

	CppAD::vector<double> ef(2);
	CppAD::vector<double> xf(2);
	CppAD::vector<double> maxabs(2);

	double ti   = 0.;
	double tf   = 1.;
	double smin = .5;
	double smax = 1.;
	double scur = .5;
	double erel = 1e-4;
	
	bool accurate = false;
	while( ! accurate )
	{	xf = OdeErrControl(method,
			ti, tf, xi, smin, smax, scur, eabs, erel, ef, maxabs);
		accurate = true;
		size_t i;
		for(i = 0; i < 2; i++)
			accurate &= ef[i] <= erel * maxabs[i];
		if( ! accurate )
			smin = smin / 2;
	} 

	double x0 = exp(-w[0]*tf);
	ok &= CppAD::NearEqual(x0, xf[0], erel, 0.);
	ok &= CppAD::NearEqual(0., ef[0], erel, erel);

	double x1 = w[0] * (exp(-w[0]*tf) - exp(-w[1]*tf))/(w[1] - w[0]);
	ok &= CppAD::NearEqual(x1, xf[1], erel, 0.);
	ok &= CppAD::NearEqual(0., ef[1], erel, erel);

	return ok;
}

// END PROGRAM
