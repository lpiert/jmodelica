# ifndef CPPAD_DECLARE_AD_INCLUDED
# define CPPAD_DECLARE_AD_INCLUDED

/* --------------------------------------------------------------------------
CppAD: C++ Algorithmic Differentiation: Copyright (C) 2003-08 Bradley M. Bell

CppAD is distributed under multiple licenses. This distribution is under
the terms of the 
                    Common Public License Version 1.0.

A copy of this license is included in the COPYING file of this distribution.
Please visit http://www.coin-or.org/CppAD/ for information on other licenses.
-------------------------------------------------------------------------- */

namespace CppAD {
	// classes
	template <class Base> class AD;
	template <class Base> class ADFun;
	template <class Base> class ADTape;
	template <class Base> class VecAD;
	template <class Base> class recorder;
	template <class Base> class player;
	template <class Base> class VecAD_reference;
	template <class Base> class ADDiscrete;

	// functions with one VecAD<Base> argument
	template <class Base> bool Parameter         (const VecAD<Base> &u);
	template <class Base> bool Variable          (const VecAD<Base> &u);
	
	// functions with one AD<Base> argument
	template <class Base> int  Integer           (const AD<Base> &u);
	template <class Base> bool Parameter         (const AD<Base> &u);
	template <class Base> bool Variable          (const AD<Base> &u);
	template <class Base> bool IdenticalZero     (const AD<Base> &u);
	template <class Base> bool IdenticalOne      (const AD<Base> &u);
	template <class Base> bool IdenticalPar      (const AD<Base> &u);
	template <class Base> bool LessThanZero      (const AD<Base> &u);
	template <class Base> bool LessThanOrZero    (const AD<Base> &u);
	template <class Base> bool GreaterThanZero   (const AD<Base> &u);
	template <class Base> bool GreaterThanOrZero (const AD<Base> &u);
	template <class Base> AD<Base> Var2Par       (const AD<Base> &u);
	template <class Base> AD<Base> abs           (const AD<Base> &u);
	template <class Base> AD<Base> acos          (const AD<Base> &u);
	template <class Base> AD<Base> asin          (const AD<Base> &u);
	template <class Base> AD<Base> atan          (const AD<Base> &u);
	template <class Base> AD<Base> cos           (const AD<Base> &u);
	template <class Base> AD<Base> cosh          (const AD<Base> &u);
	template <class Base> AD<Base> exp           (const AD<Base> &u);
	template <class Base> AD<Base> log           (const AD<Base> &u);
	template <class Base> AD<Base> log10         (const AD<Base> &u);
	template <class Base> AD<Base> sin           (const AD<Base> &u);
	template <class Base> AD<Base> sinh          (const AD<Base> &u);
	template <class Base> AD<Base> sqrt          (const AD<Base> &u);
	template <class Base> AD<Base> tan           (const AD<Base> &u);

	// arithematic operators
	template <class Base> AD<Base> operator + (
		const AD<Base> &left, const AD<Base> &right);
	template <class Base> AD<Base> operator - (
		const AD<Base> &left, const AD<Base> &right);
	template <class Base> AD<Base> operator * (
		const AD<Base> &left, const AD<Base> &right);
	template <class Base> AD<Base> operator / (
		const AD<Base> &left, const AD<Base> &right);

	// comparison operators
	template <class Base> bool operator < (
		const AD<Base> &left, const AD<Base> &right);
	template <class Base> bool operator <= (
		const AD<Base> &left, const AD<Base> &right);
	template <class Base> bool operator > (
		const AD<Base> &left, const AD<Base> &right);
	template <class Base> bool operator >= (
		const AD<Base> &left, const AD<Base> &right);
	template <class Base> bool operator == (
		const AD<Base> &left, const AD<Base> &right);
	template <class Base> bool operator != (
		const AD<Base> &left, const AD<Base> &right);

	// pow
	template <class Base> AD<Base> pow (
		const AD<Base> &x, const AD<Base> &y);

	// NearEqual
	template <class Base> bool NearEqual(
	const AD<Base> &x, const AD<Base> &y, const Base &r, const Base &a);

	template <class Base> bool NearEqual(
	const Base &x, const AD<Base> &y, const Base &r, const Base &a);

	template <class Base> bool NearEqual(
	const AD<Base> &x, const Base &y, const Base &r, const Base &a);
	
	// CondExpOp
	template <class Base> AD<Base> CondExpOp (
		enum CompareOp         cop ,
		const AD<Base>       &left , 
		const AD<Base>      &right , 
		const AD<Base>   &trueCase , 
		const AD<Base>  &falseCase 
	);
	
	// IdenticalEqualPar
	template <class Base> 
	bool IdenticalEqualPar (const AD<Base> &u, const AD<Base> &v);
	
	// EqualOpSeq
	template <class Base> 
	bool EqualOpSeq (const AD<Base> &u, const AD<Base> &v);
	
	// PrintFor
	template <class Base>
	void PrintFor(const char *text, const AD<Base> &x);

	// Value
	template <class Base> Base Value(const AD<Base> &x);

	// Pow function
	template <class Base> AD<Base> pow
		(const AD<Base> &x, const AD<Base> &y);

	// output operator
	template <class Base> std::ostream&
	operator << (std::ostream &os, const AD<Base> &x);
	template <class Base> std::ostream&
	operator << (std::ostream &os, const VecAD_reference<Base> &e);
	template <class Base> std::ostream&
	operator << (std::ostream &os, const VecAD<Base> &vec);
}

# endif
