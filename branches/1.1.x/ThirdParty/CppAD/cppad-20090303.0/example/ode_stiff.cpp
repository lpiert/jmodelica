/* --------------------------------------------------------------------------
CppAD: C++ Algorithmic Differentiation: Copyright (C) 2003-07 Bradley M. Bell

CppAD is distributed under multiple licenses. This distribution is under
the terms of the 
                    Common Public License Version 1.0.

A copy of this license is included in the COPYING file of this distribution.
Please visit http://www.coin-or.org/CppAD/ for information on other licenses.
-------------------------------------------------------------------------- */

/*
$begin OdeStiff.cpp$$
$spell
	Rosen
$$

$section A Stiff Ode: Example and Test$$

$index stiff, ode$$
$index ode, stiff$$
$index example, stiff ode$$
$index test, stiff ode$$

Define 
$latex x : \R \rightarrow \R^2$$ by
$latex \[
\begin{array}{rcl}
	x_0 (0)        & = & 1 \\
	x_1 (0)        & = & 0 \\
	x_0^\prime (t) & = & - a_0 x_0 (t) \\
	x_1^\prime (t) & = & + a_0 x_0 (t) - a_1 x_1 (t)
\end{array}
\] $$ 
If $latex a_0 \gg a_1 > 0$$, this is a stiff Ode and 
the analytic solution is
$latex \[
\begin{array}{rcl}
x_0 (t)    & = & \exp( - a_0 t ) \\
x_1 (t)    & = & a_0 [ \exp( - a_1 t ) - \exp( - a_0 t ) ] / ( a_0 - a_1 ) 
\end{array}
\] $$
The example tests Rosen34 using the relations above:

$code
$verbatim%example/ode_stiff.cpp%0%// BEGIN PROGRAM%// END PROGRAM%1%$$
$$

$end
*/
// BEGIN PROGRAM

# include <cppad/cppad.hpp> 

// To print the comparision, change the 0 to 1 on the next line.
# define CppADOdeStiffPrint 0

namespace {
	// --------------------------------------------------------------
	class Fun {
	private:
		CPPAD_TEST_VECTOR<double> a;
	public:
		// constructor
		Fun(const CPPAD_TEST_VECTOR<double>& a_) : a(a_)
		{ }
		// compute f(t, x) 
		void Ode(
			const double                    &t, 
			const CPPAD_TEST_VECTOR<double> &x, 
			CPPAD_TEST_VECTOR<double>       &f)
		{	f[0]  = - a[0] * x[0];
			f[1]  = + a[0] * x[0] - a[1] * x[1]; 
		}
		// compute partial of f(t, x) w.r.t. t 
		void Ode_ind(
			const double                    &t, 
			const CPPAD_TEST_VECTOR<double> &x, 
			CPPAD_TEST_VECTOR<double>       &f_t)
		{	f_t[0] = 0.;
			f_t[1] = 0.;
		}
		// compute partial of f(t, x) w.r.t. x 
		void Ode_dep(
			const double                    &t, 
			const CPPAD_TEST_VECTOR<double> &x, 
			CPPAD_TEST_VECTOR<double>       &f_x)
		{	f_x[0] = -a[0];  
			f_x[1] = 0.;
			f_x[2] = +a[0];
			f_x[3] = -a[1];
		}
	};
	// --------------------------------------------------------------
	class RungeMethod {
	private:
		Fun F;
	public:
		// constructor
		RungeMethod(const CPPAD_TEST_VECTOR<double> &a_) : F(a_)
		{ }
		void step(
			double                     ta , 
			double                     tb , 
			CPPAD_TEST_VECTOR<double> &xa ,
			CPPAD_TEST_VECTOR<double> &xb ,
			CPPAD_TEST_VECTOR<double> &eb )
		{	xb = CppAD::Runge45(F, 1, ta, tb, xa, eb);
		}
		size_t order(void)
		{	return 5; }
	};
	class RosenMethod {
	private:
		Fun F;
	public:
		// constructor
		RosenMethod(const CPPAD_TEST_VECTOR<double> &a_) : F(a_)
		{ }
		void step(
			double                     ta , 
			double                     tb , 
			CPPAD_TEST_VECTOR<double> &xa ,
			CPPAD_TEST_VECTOR<double> &xb ,
			CPPAD_TEST_VECTOR<double> &eb )
		{	xb = CppAD::Rosen34(F, 1, ta, tb, xa, eb);
		}
		size_t order(void)
		{	return 4; }
	};
}

bool OdeStiff(void)
{	bool ok = true;     // initial return value

	CPPAD_TEST_VECTOR<double> a(2);
	a[0] = 1e3;
	a[1] = 1.;
	RosenMethod rosen(a);
	RungeMethod runge(a);
	Fun          gear(a);

	CPPAD_TEST_VECTOR<double> xi(2);
	xi[0] = 1.;
	xi[1] = 0.;

	CPPAD_TEST_VECTOR<double> eabs(2);
	eabs[0] = 1e-6;
	eabs[1] = 1e-6;

	CPPAD_TEST_VECTOR<double> ef(2);
	CPPAD_TEST_VECTOR<double> xf(2);
	CPPAD_TEST_VECTOR<double> maxabs(2);
	size_t                nstep;

	size_t k;
	for(k = 0; k < 3; k++)
	{	
		size_t M    = 5;
		double ti   = 0.;
		double tf   = 1.;
		double smin = 1e-7;
		double sini = 1e-7;
		double smax = 1.;
		double scur = .5;
		double erel = 0.;

		const char *method;
		if( k == 0 )
		{	method = "Rosen34";
			xf = CppAD::OdeErrControl(rosen, ti, tf, 
			xi, smin, smax, scur, eabs, erel, ef, maxabs, nstep);
		}
		else if( k == 1 )
		{	method = "Runge45";
			xf = CppAD::OdeErrControl(runge, ti, tf, 
			xi, smin, smax, scur, eabs, erel, ef, maxabs, nstep);
		}
		else if( k == 2 )
		{	method = "Gear5";
			xf = CppAD::OdeGearControl(gear, M, ti, tf,
			xi, smin, smax, sini, eabs, erel, ef, maxabs, nstep);
		}
		double x0 = exp(-a[0]*tf);
		ok &= CppAD::NearEqual(x0, xf[0], 0., eabs[0]);
		ok &= CppAD::NearEqual(0., ef[0], 0., eabs[0]);

		double x1 = a[0] * 
			(exp(-a[1]*tf) - exp(-a[0]*tf))/(a[0] - a[1]);
		ok &= CppAD::NearEqual(x1, xf[1], 0., eabs[1]);
		ok &= CppAD::NearEqual(0., ef[1], 0., eabs[0]);
# if CppADOdeStiffPrint
		std::cout << "method     = " << method << std::endl;
		std::cout << "nstep      = " << nstep  << std::endl;
		std::cout << "x0         = " << x0 << std::endl;
		std::cout << "xf[0]      = " << xf[0] << std::endl;
		std::cout << "x0 - xf[0] = " << x0 - xf[0] << std::endl;
		std::cout << "ef[0]      = " << ef[0] << std::endl;
		std::cout << "x1         = " << x1 << std::endl;
		std::cout << "xf[1]      = " << xf[1] << std::endl;
		std::cout << "x1 - xf[1] = " << x1 - xf[1] << std::endl;
		std::cout << "ef[1]      = " << ef[1] << std::endl;
# endif
	}

	return ok;
}

// END PROGRAM
