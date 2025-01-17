/*
    Copyright (C) 2009-2013 Modelon AB

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, version 3 of the License.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/


package FunctionTests 

/* Functions used in tests. */
function TestFunction0
 output Real o1 = 0;
algorithm
 return;
end TestFunction0;

function TestFunction1
 input Real i1 = 0;
 output Real o1 = i1;
algorithm
end TestFunction1;

function TestFunction2
 input Real i1 = 0;
 input Real i2 = 0;
 output Real o1 = 0;
 output Real o2 = i2;
algorithm
 o1 := i1;
end TestFunction2;

function TestFunction3
 input Real i1;
 input Real i2;
 input Real i3 = 0;
 output Real o1 = i1 + i2 + i3;
 output Real o2 = i2 + i3;
 output Real o3 = i1 + i2;
algorithm
end TestFunction3;

function TestFunctionString
 input String i1;
 output String o1 = i1;
algorithm
end TestFunctionString;

function TestFunctionCallingFunction
 input Real i1;
 output Real o1;
algorithm
 o1 := TestFunction1(i1);
end TestFunctionCallingFunction;

function TestFunctionRecursive
 input Integer i1;
 output Integer o1;
algorithm
 if i1 < 3 then
  o1 := 1;
 else
  o1 := TestFunctionRecursive(i1 - 1) + TestFunctionRecursive(i1 - 2);
 end if;
end TestFunctionRecursive;

function TestFunctionWithConst
 input Real x = 1;
 output Real y = x + A + B + C;
protected
 constant Real A = 1;
 constant Real B = 2;
 constant Real C = 3;
algorithm
end TestFunctionWithConst;


/* Temporary functions for manual C-tests */

function Func00
algorithm
 return;
end Func00;

function Func10
 input Real i1 = 0;
algorithm
 return;
end Func10;

function Func01
 output Real o1 = 0;
algorithm
 return;
end Func01;

function Func11
 input Real i1 = 0;
 output Real o1 = i1;
algorithm
 return;
end Func11;

function Func21
 input Real i1 = 0;
 input Real i2 = 0;
 output Real o1 = i1 + i2;
algorithm
 return;
end Func21;

function Func02
 output Real o1 = 0;
 output Real o2 = 1;
algorithm
 return;
end Func02;

function Func12
 input Real i1 = 0;
 output Real o1 = i1;
 output Real o2 = 1;
algorithm
 return;
end Func12;

function Func22
 input Real i1 = 0;
 input Real i2 = 0;
 output Real o1 = i1 + i2;
 output Real o2 = 1;
algorithm
 for i in 1:3 loop
   o1 := o1 + 1;
   o2 := o2 - o1;
 end for;
 return;
end Func22;


/* ====================== Functions ====================== */

model FunctionFlatten1
 Real x;
equation
 x = TestFunction1(1);

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="FunctionFlatten1",
			description="Flattening functions: simple function call",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.FunctionFlatten1
 Real x;
equation
 x = FunctionTests.TestFunction1(1);

public
 function FunctionTests.TestFunction1
  input Real i1 := 0;
  output Real o1 := i1;
 algorithm
  return;
 end FunctionTests.TestFunction1;

end FunctionTests.FunctionFlatten1;
")})));
end FunctionFlatten1;


model FunctionFlatten2
 Real x;
 Real y = TestFunction2(2, 3);
equation
 x = TestFunction2(1);

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="FunctionFlatten2",
			description="Flattening functions: two calls to same function",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.FunctionFlatten2
 Real x;
 Real y = FunctionTests.TestFunction2(2, 3);
equation
 x = FunctionTests.TestFunction2(1, 0);

public
 function FunctionTests.TestFunction2
  input Real i1 := 0;
  input Real i2 := 0;
  output Real o1 := 0;
  output Real o2 := i2;
 algorithm
  o1 := i1;
  return;
 end FunctionTests.TestFunction2;

end FunctionTests.FunctionFlatten2;
")})));
end FunctionFlatten2;


model FunctionFlatten3
 Real x;
 Real y = TestFunction2(2, 3);
equation
 x = TestFunction1(y * 2);

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="FunctionFlatten3",
			description="Flattening functions: calls to two functions",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.FunctionFlatten3
 Real x;
 Real y = FunctionTests.TestFunction2(2, 3);
equation
 x = FunctionTests.TestFunction1(y * 2);

public
 function FunctionTests.TestFunction2
  input Real i1 := 0;
  input Real i2 := 0;
  output Real o1 := 0;
  output Real o2 := i2;
 algorithm
  o1 := i1;
  return;
 end FunctionTests.TestFunction2;

 function FunctionTests.TestFunction1
  input Real i1 := 0;
  output Real o1 := i1;
 algorithm
  return;
 end FunctionTests.TestFunction1;

end FunctionTests.FunctionFlatten3;
")})));
end FunctionFlatten3;


model FunctionFlatten4
 Real x = TestFunctionWithConst(2);

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="FunctionFlatten4",
			description="Flattening functions: function containing constants",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.FunctionFlatten4
 Real x = FunctionTests.TestFunctionWithConst(2);

public
 function FunctionTests.TestFunctionWithConst
  input Real x := 1;
  output Real y := x + 1.0 + 2.0 + 3.0;
 algorithm
  return;
 end FunctionTests.TestFunctionWithConst;

end FunctionTests.FunctionFlatten4;
")})));
end FunctionFlatten4;


model FunctionFlatten5
	model A
		Real x;
	equation
		x = TestFunction1(1);
	end A;
	
	model B
		extends A;
	end B;
	
	B y;

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="FunctionFlatten5",
			description="Flattening functions: function called in extended class",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.FunctionFlatten5
 Real y.x;
equation
 y.x = FunctionTests.TestFunction1(1);

public
 function FunctionTests.TestFunction1
  input Real i1 := 0;
  output Real o1 := i1;
 algorithm
  return;
 end FunctionTests.TestFunction1;

end FunctionTests.FunctionFlatten5;
")})));
end FunctionFlatten5;


model FunctionFlatten6
	model A
		Real x;
	end A;
	
	model B = A(x = TestFunction1(1));
	
	B y;

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="FunctionFlatten6",
			description="Flattening functions: function called in class modification",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.FunctionFlatten6
 Real y.x = FunctionTests.TestFunction1(1);

public
 function FunctionTests.TestFunction1
  input Real i1 := 0;
  output Real o1 := i1;
 algorithm
  return;
 end FunctionTests.TestFunction1;

end FunctionTests.FunctionFlatten6;
")})));
end FunctionFlatten6;


model FunctionFlatten7
	package A
		constant Real c = 1;
		function f
			output Real a = c;
		algorithm
		end f;
	end A;
	
	package B
		extends A(c = 2);
	end B;
	
	package C
		extends A(c = 3);
	end C;
	
	Real x = A.f();
	Real y = B.f();
	Real z = C.f();

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="FunctionFlatten7",
			description="Calling different inherited versions of same function",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.FunctionFlatten7
 Real x = FunctionTests.FunctionFlatten7.A.f();
 Real y = FunctionTests.FunctionFlatten7.B.f();
 Real z = FunctionTests.FunctionFlatten7.C.f();

public
 function FunctionTests.FunctionFlatten7.A.f
  output Real a := 1.0;
 algorithm
  return;
 end FunctionTests.FunctionFlatten7.A.f;

 function FunctionTests.FunctionFlatten7.B.f
  output Real a := 2.0;
 algorithm
  return;
 end FunctionTests.FunctionFlatten7.B.f;

 function FunctionTests.FunctionFlatten7.C.f
  output Real a := 3.0;
 algorithm
  return;
 end FunctionTests.FunctionFlatten7.C.f;

end FunctionTests.FunctionFlatten7;
")})));
end FunctionFlatten7;


model FunctionFlatten8
	function f
		output Real x = 1;
	algorithm
	end f;
	
	model A
		Real x;
	equation
		x = f();
	end A;
	
	A y;

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="FunctionFlatten8",
			description="Calling function from parallel class",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.FunctionFlatten8
 Real y.x;
equation
 y.x = FunctionTests.FunctionFlatten8.f();

public
 function FunctionTests.FunctionFlatten8.f
  output Real x := 1;
 algorithm
  return;
 end FunctionTests.FunctionFlatten8.f;

end FunctionTests.FunctionFlatten8;
")})));
end FunctionFlatten8;


model FunctionFlatten9
    constant Real[3] a = {1,2,3};
    
    function f
        input Real[2] x;
		input Integer i;
        output Real[2] y;
    algorithm
        y := x .+ a[i] .+ a[i+1];
    end f;
    
    Real[2] z = f({3,4}, 1);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionFlatten9",
			description="Require copying of same constant array twice",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.FunctionFlatten9
 constant Real a[1] = 1;
 constant Real a[2] = 2;
 constant Real a[3] = 3;
 Real z[1];
 Real z[2];
equation
 ({z[1],z[2]}) = FunctionTests.FunctionFlatten9.f({3, 4}, 1);

public
 function FunctionTests.FunctionFlatten9.f
  Real[3] a;
  input Real[2] x;
  input Integer i;
  output Real[2] y;
 algorithm
  a[1] := 1;
  a[2] := 2;
  a[3] := 3;
  y[1] := x[1] .+ a[i] .+ a[i + 1];
  y[2] := x[2] .+ a[i] .+ a[i + 1];
  return;
 end FunctionTests.FunctionFlatten9.f;

end FunctionTests.FunctionFlatten9;
")})));
end FunctionFlatten9;


model FunctionFlatten10
    function f1
        input Real x;
        output Real y;
    end f1;
    
    function f2
        extends f1;
    end f2;
    
    function f3
        extends f2;
    algorithm
        y := x;
    end f3;
    
    Real z = f3(1);

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="FunctionFlatten10",
			description="Multi-level extending of functions",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.FunctionFlatten10
 Real z = FunctionTests.FunctionFlatten10.f3(1);

public
 function FunctionTests.FunctionFlatten10.f3
  input Real x;
  output Real y;
 algorithm
  y := x;
  return;
 end FunctionTests.FunctionFlatten10.f3;

end FunctionTests.FunctionFlatten10;
")})));
end FunctionFlatten10;


model FunctionFlatten11
    function f0
        input Real x;
        output Real y;
    end f0;
    
    function f1
        extends f0;
    algorithm
        y := x;
    end f1;
    
    function f2
        extends f0;
    algorithm
        y := x + 1;
    end f2;
    
	model A
		replaceable function f3 = f1 constrainedby f0;
		Real x = 1;
		Real y = f3(x);
	end A;
	
	model B = A(redeclare function f3 = f2);
	
	model C
		extends A;
		redeclare function f3 = f2;
	end C;
	
	B b;
	C c;

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="FunctionFlatten11",
			description="Using redeclared function in model",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.FunctionFlatten11
 Real b.x = 1;
 Real b.y = FunctionTests.FunctionFlatten11.f2(b.x);
 Real c.x = 1;
 Real c.y = FunctionTests.FunctionFlatten11.f2(c.x);

public
 function FunctionTests.FunctionFlatten11.f2
  input Real x;
  output Real y;
 algorithm
  y := x + 1;
  return;
 end FunctionTests.FunctionFlatten11.f2;

end FunctionTests.FunctionFlatten11;
")})));
end FunctionFlatten11;


model FunctionFlatten12
	function f
		input Real[:] x;
		output Real y;
	algorithm
		y := min(size(x));
	end f;
	
	constant Real z = f({1,2,3});
	Real w = z;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionFlatten12",
			description="Size of function input with unknown size as argument to min",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.FunctionFlatten12
 constant Real z = FunctionTests.FunctionFlatten12.f({1, 2, 3});
 Real w;
equation
 w = 3.0;

public
 function FunctionTests.FunctionFlatten12.f
  input Real[:] x;
  output Real y;
 algorithm
  y := size(x, 1);
  return;
 end FunctionTests.FunctionFlatten12.f;

end FunctionTests.FunctionFlatten12;
")})));
end FunctionFlatten12;



/* ====================== Function calls ====================== */

model FunctionBinding1
 Real x = TestFunction1();

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="FunctionBinding1",
			description="Binding function arguments: 1 input, use default",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.FunctionBinding1
 Real x = FunctionTests.TestFunction1(0);

public
 function FunctionTests.TestFunction1
  input Real i1 := 0;
  output Real o1 := i1;
 algorithm
  return;
 end FunctionTests.TestFunction1;

end FunctionTests.FunctionBinding1;
")})));
end FunctionBinding1;

model FunctionBinding2
 Real x = TestFunction1(1);

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="FunctionBinding2",
			description="Binding function arguments: 1 input, 1 arg",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.FunctionBinding2
 Real x = FunctionTests.TestFunction1(1);

public
 function FunctionTests.TestFunction1
  input Real i1 := 0;
  output Real o1 := i1;
 algorithm
  return;
 end FunctionTests.TestFunction1;

end FunctionTests.FunctionBinding2;
")})));
end FunctionBinding2;

model FunctionBinding3
 Real x = TestFunction1(1, 2);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="FunctionBinding3",
			description="Function call with too many arguments",
			variability_propagation=false,
			errorMessage="
1 error(s) found:
Error: in file 'FunctionTests.mo':
Semantic error at line 1, column 1:
  Calling function TestFunction1(): too many positional arguments
")})));
end FunctionBinding3;

model FunctionBinding4
 Real x = TestFunction3();

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="FunctionBinding4",
			description="Function call with too few arguments: no arguments",
			variability_propagation=false,
			errorMessage="
2 error(s) found:
Error: in file 'FunctionTests.mo':
Semantic error at line 1, column 1:
  Calling function TestFunction3(): missing argument for required input i1
Error: in file 'FunctionTests.mo':
Semantic error at line 1, column 1:
  Calling function TestFunction3(): missing argument for required input i2
")})));
end FunctionBinding4;

model FunctionBinding5
 Real x = TestFunction3(1);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="FunctionBinding5",
			description="Function call with too few arguments: one positional argument",
			variability_propagation=false,
			errorMessage="
1 error(s) found:
Error: in file 'FunctionTests.mo':
Semantic error at line 1, column 1:
  Calling function TestFunction3(): missing argument for required input i2
")})));
end FunctionBinding5;

model FunctionBinding6
 Real x = TestFunction3(1, 2);

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="FunctionBinding6",
			description="Binding function arguments: 3 inputs, 2 args, 1 default",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.FunctionBinding6
 Real x = FunctionTests.TestFunction3(1, 2, 0);

public
 function FunctionTests.TestFunction3
  input Real i1;
  input Real i2;
  input Real i3 := 0;
  output Real o1 := i1 + i2 + i3;
  output Real o2 := i2 + i3;
  output Real o3 := i1 + i2;
 algorithm
  return;
 end FunctionTests.TestFunction3;

end FunctionTests.FunctionBinding6;
")})));
end FunctionBinding6;

model FunctionBinding7
 Real x = TestFunction0();

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="FunctionBinding7",
			description="Binding function arguments: 3 inputs, 2 args, 1 default",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.FunctionBinding7
 Real x = FunctionTests.TestFunction0();

public
 function FunctionTests.TestFunction0
  output Real o1 := 0;
 algorithm
  return;
 end FunctionTests.TestFunction0;

end FunctionTests.FunctionBinding7;
")})));
end FunctionBinding7;

model FunctionBinding8
 Real x = TestFunction1(i1=1);

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="FunctionBinding8",
			description="Binding function arguments: 1 input, 1 named arg",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.FunctionBinding8
 Real x = FunctionTests.TestFunction1(1);

public
 function FunctionTests.TestFunction1
  input Real i1 := 0;
  output Real o1 := i1;
 algorithm
  return;
 end FunctionTests.TestFunction1;

end FunctionTests.FunctionBinding8;
")})));
end FunctionBinding8;

model FunctionBinding9
 Real x = TestFunction2(i2=2, i1=1);

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="FunctionBinding9",
			description="Binding function arguments: 2 inputs, 2 named arg (inverted order)",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.FunctionBinding9
 Real x = FunctionTests.TestFunction2(1, 2);

public
 function FunctionTests.TestFunction2
  input Real i1 := 0;
  input Real i2 := 0;
  output Real o1 := 0;
  output Real o2 := i2;
 algorithm
  o1 := i1;
  return;
 end FunctionTests.TestFunction2;

end FunctionTests.FunctionBinding9;
")})));
end FunctionBinding9;

model FunctionBinding10
 Real x = TestFunction3(1, i3=2);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="FunctionBinding10",
			description="Function call with too few arguments: missing middle argument",
			variability_propagation=false,
			errorMessage="
1 error(s) found:
Error: in file 'FunctionTests.mo':
Semantic error at line 1, column 1:
  Calling function TestFunction3(): missing argument for required input i2
")})));
end FunctionBinding10;

model FunctionBinding11
 Real x = TestFunction2(i3=1);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="FunctionBinding11",
			description="Function call with named arguments: non-existing input",
			variability_propagation=false,
			errorMessage="
1 error(s) found:
Error: in file 'FunctionTests.mo':
Semantic error at line 1, column 1:
  Calling function TestFunction2(): no input matching named argument i3 found
")})));
end FunctionBinding11;

model FunctionBinding12
 Real x = TestFunction2(o1=1);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="FunctionBinding12",
			description="Function call with named arguments: using output as input",
			variability_propagation=false,
			errorMessage="
1 error(s) found:
Error: in file 'FunctionTests.mo':
Semantic error at line 1, column 1:
  Calling function TestFunction2(): no input matching named argument o1 found
")})));
end FunctionBinding12;

model FunctionBinding13
 Real x = TestFunction2(1, 2, i1=3);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="FunctionBinding13",
			description="Function call with named arguments: giving an input value twice",
			variability_propagation=false,
			errorMessage="
1 error(s) found:
Error: in file 'FunctionTests.mo':
Semantic error at line 1, column 1:
  Calling function TestFunction2(): multiple arguments matches input i1
")})));
end FunctionBinding13;

model FunctionBinding14
 Real x = TestFunction2(1, 2, i1=3, i1=3, i1=3);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="FunctionBinding14",
			description="Function call with named arguments: giving an input value four times",
			variability_propagation=false,
			errorMessage="
1 error(s) found:
Error: in file 'FunctionTests.mo':
Semantic error at line 1, column 1:
  Calling function TestFunction2(): multiple arguments matches input i1
")})));
end FunctionBinding14;

model FunctionBinding15
    package A
        constant Real a = 1;
        
        function f
            input  Real b = a;
            output Real c = b;
        algorithm
        end f;
    end A;
    
    model B
        Real c = A.f();
    end B;
    
    B d;

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="FunctionBinding15",
			description="Access to constant in default input value",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.FunctionBinding15
 Real d.c = FunctionTests.FunctionBinding15.A.f(1.0);

public
 function FunctionTests.FunctionBinding15.A.f
  input Real b := 1.0;
  output Real c := b;
 algorithm
  return;
 end FunctionTests.FunctionBinding15.A.f;

end FunctionTests.FunctionBinding15;
")})));
end FunctionBinding15;


model FunctionBinding16
    function f
        input Real a = 1;
        input Real b = a;
        output Real c = a + b;
    algorithm
    end f;
    
    Real x = f();
    Real y = f(x);
    Real z = f(x,y);
end FunctionBinding16;


model FunctionBinding17
    function f1
        output Real a1;
    algorithm
        a1 := f2;
    end f1;
    
    function f2
        output Real a2 = 1;
    algorithm
    end f2;
    
    Real x = f1();
end FunctionBinding17;


model FunctionBinding18
    function f
        output Real a = 1;
    algorithm
    end f;
   
    Real x = f;
end FunctionBinding18;


model FunctionBinding19
	function a
        input Real x; 
        output Real y;
    end a;
	
    function b
        extends a;
    end b;
	
    function c
        extends a;
        extends b;
    algorithm
        y := x;
    end c;

    Real w = c(1.0);

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="FunctionBinding19",
			description="",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.FunctionBinding19
 Real w = FunctionTests.FunctionBinding19.c(1.0);

public
 function FunctionTests.FunctionBinding19.c
  input Real x;
  output Real y;
 algorithm
  y := x;
  return;
 end FunctionTests.FunctionBinding19.c;

end FunctionTests.FunctionBinding19;
")})));
end FunctionBinding19;


model FunctionBinding20
    function f
        input Real a;
        input Real b = a + 2;
        output Real c;
    algorithm
        c := a + b;
    end f;

    model E
        Real g = f(time + 1);
    end E;

    E e;

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="FunctionBinding20",
			description="Default arguments referencing other arguments",
			flatModel="
fclass FunctionTests.FunctionBinding20
 Real e.g = FunctionTests.FunctionBinding20.f(time + 1, time + 1 + 2);

public
 function FunctionTests.FunctionBinding20.f
  input Real a;
  input Real b := a + 2;
  output Real c;
 algorithm
  c := a + b;
  return;
 end FunctionTests.FunctionBinding20.f;

end FunctionTests.FunctionBinding20;
")})));
end FunctionBinding20;


model FunctionBinding21
    function f1
        input Real a;
        input Real b;
        output Real c;
    algorithm
        c := a + b;
    end f1;


    model E
	    parameter Real d = 2;
	
	    function f2 = f1(b = d);
		
		model F
            Real h = f2(1);
		end F;
		
		F f;
    end E;

    E e;

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="FunctionBinding21",
			description="Default arguments that reference parameters",
			flatModel="
fclass FunctionTests.FunctionBinding21
 parameter Real e.d = 2 /* 2 */;
 Real e.f.h = FunctionTests.FunctionBinding21.e.f2(1, e.d);

public
 function FunctionTests.FunctionBinding21.e.f2
  input Real a;
  input Real b := e.d;
  output Real c;
 algorithm
  c := a + b;
  return;
 end FunctionTests.FunctionBinding21.e.f2;

end FunctionTests.FunctionBinding21;
")})));
end FunctionBinding21;



model BadFunctionCall1
  Real x = NonExistingFunction(1, 2);
  Real y = NonExistingFunction();

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="BadFunctionCall1",
			description="Call to non-existing function",
			variability_propagation=false,
			errorMessage="
2 error(s) found:
Error: in file 'FunctionTests.mo':
Semantic error at line 1, column 1:
  Cannot find function declaration for NonExistingFunction()
Error: in file 'FunctionTests.mo':
Semantic error at line 1, column 1:
  Cannot find function declaration for NonExistingFunction()
")})));
end BadFunctionCall1;

model BadFunctionCall2
  Real notAFunction = 0;
  Real x = notAFunction(1, 2);
  Real y = notAFunction();

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="BadFunctionCall2",
			description="Call to component as function",
			variability_propagation=false,
			errorMessage="
2 error(s) found:
Error: in file 'FunctionTests.mo':
Semantic error at line 1, column 1:
  Cannot find function declaration for notAFunction()
Error: in file 'FunctionTests.mo':
Semantic error at line 1, column 1:
  Cannot find function declaration for notAFunction()
")})));
end BadFunctionCall2;

class NotAFunctionClass
 Real x;
end NotAFunctionClass;

model BadFunctionCall3
  Real x = NotAFunctionClass(1, 2);
  Real y = NotAFunctionClass();

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="BadFunctionCall3",
			description="Call to non-function class as function",
			variability_propagation=false,
			errorMessage="
2 error(s) found:
Error: in file 'FunctionTests.mo':
Semantic error at line 1, column 1:
  The class NotAFunctionClass is not a function
Error: in file 'FunctionTests.mo':
Semantic error at line 1, column 1:
  The class NotAFunctionClass is not a function
")})));
end BadFunctionCall3;

model MultipleOutput1
  Real x;
  Real y;
equation
  (x, y) = TestFunction2(1, 2);

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="MultipleOutput1",
			description="Functions with multiple outputs: flattening of equation",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.MultipleOutput1
 Real x;
 Real y;
equation
 (x, y) = FunctionTests.TestFunction2(1, 2);

public
 function FunctionTests.TestFunction2
  input Real i1 := 0;
  input Real i2 := 0;
  output Real o1 := 0;
  output Real o2 := i2;
 algorithm
  o1 := i1;
  return;
 end FunctionTests.TestFunction2;

end FunctionTests.MultipleOutput1;
")})));
end MultipleOutput1;

model MultipleOutput2
  Real x;
  Real y;
equation
  (x, y) = TestFunction3(1, 2, 3);

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="MultipleOutput2",
			description="Functions with multiple outputs: flattening, fewer components assigned than outputs",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.MultipleOutput2
 Real x;
 Real y;
equation
 (x, y) = FunctionTests.TestFunction3(1, 2, 3);

public
 function FunctionTests.TestFunction3
  input Real i1;
  input Real i2;
  input Real i3 := 0;
  output Real o1 := i1 + i2 + i3;
  output Real o2 := i2 + i3;
  output Real o3 := i1 + i2;
 algorithm
  return;
 end FunctionTests.TestFunction3;

end FunctionTests.MultipleOutput2;
")})));
end MultipleOutput2;

model MultipleOutput3
  Real x;
  Real z;
equation
  (x, , z) = TestFunction3(1, 2, 3);

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="MultipleOutput3",
			description="Functions with multiple outputs: flattening, one output skipped",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.MultipleOutput3
 Real x;
 Real z;
equation
 (x, , z) = FunctionTests.TestFunction3(1, 2, 3);

public
 function FunctionTests.TestFunction3
  input Real i1;
  input Real i2;
  input Real i3 := 0;
  output Real o1 := i1 + i2 + i3;
  output Real o2 := i2 + i3;
  output Real o3 := i1 + i2;
 algorithm
  return;
 end FunctionTests.TestFunction3;

end FunctionTests.MultipleOutput3;
")})));
end MultipleOutput3;

model MultipleOutput4
  Real x;
  Real y;
equation
  TestFunction2(1, 2);

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="MultipleOutput4",
			description="Functions with multiple outputs: flattening, no components assigned",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.MultipleOutput4
 Real x;
 Real y;
equation
 FunctionTests.TestFunction2(1, 2);

public
 function FunctionTests.TestFunction2
  input Real i1 := 0;
  input Real i2 := 0;
  output Real o1 := 0;
  output Real o2 := i2;
 algorithm
  o1 := i1;
  return;
 end FunctionTests.TestFunction2;

end FunctionTests.MultipleOutput4;
")})));
end MultipleOutput4;

model RecursionTest1
 Real x = TestFunctionCallingFunction(1);

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="RecursionTest1",
			description="Flattening function calling other function",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.RecursionTest1
 Real x = FunctionTests.TestFunctionCallingFunction(1);

public
 function FunctionTests.TestFunctionCallingFunction
  input Real i1;
  output Real o1;
 algorithm
  o1 := FunctionTests.TestFunction1(i1);
  return;
 end FunctionTests.TestFunctionCallingFunction;

 function FunctionTests.TestFunction1
  input Real i1 := 0;
  output Real o1 := i1;
 algorithm
  return;
 end FunctionTests.TestFunction1;

end FunctionTests.RecursionTest1;
")})));
end RecursionTest1;

model RecursionTest2
 Real x = TestFunctionRecursive(5);

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="RecursionTest2",
			description="Flattening function calling other function",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.RecursionTest2
 Real x = FunctionTests.TestFunctionRecursive(5);

public
 function FunctionTests.TestFunctionRecursive
  input Integer i1;
  output Integer o1;
 algorithm
  if i1 < 3 then
   o1 := 1;
  else
   o1 := FunctionTests.TestFunctionRecursive(i1 - 1) + FunctionTests.TestFunctionRecursive(i1 - 2);
  end if;
  return;
 end FunctionTests.TestFunctionRecursive;

end FunctionTests.RecursionTest2;
")})));
end RecursionTest2;

/* ====================== Function call type checks ====================== */

model FunctionType0
 Real x = TestFunction1(1.0);

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="FunctionType0",
			description="Function type checks: Real literal arg, Real input",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.FunctionType0
 Real x = FunctionTests.TestFunction1(1.0);

public
 function FunctionTests.TestFunction1
  input Real i1 := 0;
  output Real o1 := i1;
 algorithm
  return;
 end FunctionTests.TestFunction1;

end FunctionTests.FunctionType0;
")})));
end FunctionType0;

model FunctionType1
 Real x = TestFunction1(1);

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="FunctionType1",
			description="Function type checks: Integer literal arg, Real input",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.FunctionType1
 Real x = FunctionTests.TestFunction1(1);

public
 function FunctionTests.TestFunction1
  input Real i1 := 0;
  output Real o1 := i1;
 algorithm
  return;
 end FunctionTests.TestFunction1;

end FunctionTests.FunctionType1;
")})));
end FunctionType1;

model FunctionType2
 Integer x = TestFunction1(1.0);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="FunctionType2",
			description="Function type checks: function with Real output as binding exp for Integer component",
			variability_propagation=false,
			errorMessage="
1 error(s) found:
Error: in file 'FunctionTests.mo':
Semantic error at line 1, column 1:
  The binding expression of the variable x does not match the declared type of the variable
")})));
end FunctionType2;

model FunctionType3
 parameter Real a = 1.0;
 Real x = TestFunction1(a);

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="FunctionType3",
			description="Function type checks: Real component arg, Real input",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.FunctionType3
 parameter Real a = 1.0 /* 1.0 */;
 Real x = FunctionTests.TestFunction1(a);

public
 function FunctionTests.TestFunction1
  input Real i1 := 0;
  output Real o1 := i1;
 algorithm
  return;
 end FunctionTests.TestFunction1;

end FunctionTests.FunctionType3;
")})));
end FunctionType3;

model FunctionType4
 parameter Integer a = 1;
 Real x = TestFunction1(a);

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="FunctionType4",
			description="Function type checks: Integer component arg, Real input",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.FunctionType4
 parameter Integer a = 1 /* 1 */;
 Real x = FunctionTests.TestFunction1(a);

public
 function FunctionTests.TestFunction1
  input Real i1 := 0;
  output Real o1 := i1;
 algorithm
  return;
 end FunctionTests.TestFunction1;

end FunctionTests.FunctionType4;
")})));
end FunctionType4;

model FunctionType5
 Real x = TestFunction2(1, true);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="FunctionType5",
			description="Function type checks: Boolean literal arg, Real input",
			variability_propagation=false,
			errorMessage="
1 error(s) found:
Error: in file 'FunctionTests.mo':
Semantic error at line 1, column 1:
  Calling function TestFunction2(): types of positional argument 2 and input i2 are not compatible
")})));
end FunctionType5;

model FunctionType6
 parameter Boolean a = true;
 Real x = TestFunction2(1, a);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="FunctionType6",
			description="Function type checks: Boolean component arg, Real input",
			variability_propagation=false,
			errorMessage="
1 error(s) found:
Error: in file 'FunctionTests.mo':
Semantic error at line 1, column 1:
  Calling function TestFunction2(): types of positional argument 2 and input i2 are not compatible
")})));
end FunctionType6;

model FunctionType7
 parameter Integer a = 1;
 Real x = TestFunction2(TestFunction2(), TestFunction2(1));

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="FunctionType7",
			description="Function type checks: nestled function calls",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.FunctionType7
 parameter Integer a = 1 /* 1 */;
 Real x = FunctionTests.TestFunction2(FunctionTests.TestFunction2(0, 0), FunctionTests.TestFunction2(1, 0));

public
 function FunctionTests.TestFunction2
  input Real i1 := 0;
  input Real i2 := 0;
  output Real o1 := 0;
  output Real o2 := i2;
 algorithm
  o1 := i1;
  return;
 end FunctionTests.TestFunction2;

end FunctionTests.FunctionType7;
")})));
end FunctionType7;

model FunctionType8
 parameter Integer a = 1;
 Real x = TestFunction2(TestFunction1(true), TestFunction2(1));

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="FunctionType8",
			description="Function type checks: nestled function calls, type mismatch in inner",
			variability_propagation=false,
			errorMessage="
1 error(s) found:
Error: in file 'FunctionTests.mo':
Semantic error at line 1, column 1:
  Calling function TestFunction1(): types of positional argument 1 and input i1 are not compatible
")})));
end FunctionType8;

model FunctionType9
 String x = TestFunctionString("test");

	annotation(__JModelica(UnitTesting(tests={
		ComplianceErrorTestCase(
			name="FunctionType9",
			description="Function type checks: String literal arg, String input (error for now)",
			variability_propagation=false,
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/FunctionTests.mo':
Compliance error at line 1303, column 7:
  String variables are not supported
")})));
end FunctionType9;

model FunctionType10
 parameter String a = "test";
 String x = TestFunctionString(a);

	annotation(__JModelica(UnitTesting(tests={
		ComplianceErrorTestCase(
			name="FunctionType10",
			description="Function type checks: String component arg, String input (error for now)",
			variability_propagation=false,
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/FunctionTests.mo':
Compliance error at line 1327, column 29:
  String variables are not supported
")})));
end FunctionType10;

model FunctionType11
 String x = TestFunctionString(1);

	annotation(__JModelica(UnitTesting(tests={
		ComplianceErrorTestCase(
			name="FunctionType11",
			description="Function type checks: Integer literal arg, String input",
			variability_propagation=false,
			errorMessage="
2 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/FunctionTests.mo':
Compliance error at line 1338, column 7:
  String variables are not supported
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/FunctionTests.mo':
Semantic error at line 1340, column 32:
  Calling function TestFunctionString(): types of positional argument 1 and input i1 are not compatible
")})));
end FunctionType11;

model FunctionType12
 Real x;
 Integer y;
equation
 (x, y) = TestFunction2(1, 2);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="FunctionType12",
			description="Function type checks: 2 outputs, 2nd wrong type",
			variability_propagation=false,
			errorMessage="
1 error(s) found:
Error: in file 'FunctionTests.mo':
Semantic error at line 1, column 1:
  Calling function TestFunction2(): types of component y and output o2 are not compatible
")})));
end FunctionType12;

model FunctionType13
 Integer x;
 Real y;
 Integer z;
equation
 (x, y, z) = TestFunction3(1, 2);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="FunctionType13",
			description="Function type checks: 3 outputs, 1st and 3rd wrong type",
			variability_propagation=false,
			errorMessage="
2 error(s) found:
Error: in file 'FunctionTests.mo':
Semantic error at line 1, column 1:
  Calling function TestFunction3(): types of component x and output o1 are not compatible
Error: in file 'FunctionTests.mo':
Semantic error at line 1, column 1:
  Calling function TestFunction3(): types of component z and output o3 are not compatible
")})));
end FunctionType13;

model FunctionType14
 Real x;
 Real y;
 Real z;
equation
 (x, y, z) = TestFunction2(1, 2);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="FunctionType14",
			description="Function type checks: 2 outputs, 3 components assigned",
			variability_propagation=false,
			errorMessage="
1 error(s) found:
Error: in file 'FunctionTests.mo':
Semantic error at line 1, column 1:
  Too many components assigned from function call: TestFunction2() has 2 output(s)
")})));
end FunctionType14;

model FunctionType15
 Real x;
 Integer z;
equation
 (x, , z) = TestFunction3(1, 2);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="FunctionType15",
			description="Function type checks: 3 outputs, 2nd skipped, 3rd wrong type",
			variability_propagation=false,
			errorMessage="
1 error(s) found:
Error: in file 'FunctionTests.mo':
Semantic error at line 1, column 1:
  Calling function TestFunction3(): types of component z and output o3 are not compatible
")})));
end FunctionType15;

model FunctionType16
 Real x;
 Real y;
equation
 (x, y) = sin(1);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="FunctionType16",
			description="Function type checks: assigning 2 components from sin()",
			variability_propagation=false,
			errorMessage="
1 error(s) found:
Error: in file 'FunctionTests.mo':
Semantic error at line 1, column 1:
  Too many components assigned from function call: sin() has 1 output(s)
")})));
end FunctionType16;

model FunctionType17
 function f
  input Real x[:,:];
  input Real y[2,:];
  output Real z[size(x,1),size(x,2)];
 algorithm
  z := x + y;
 end f;
  
 Real x[2,2] = f({{1,2},{3,4}}, {{5,6},{7,8}});

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="FunctionType17",
			description="Function type checks: combining known and unknown types",
			variability_propagation=false,
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/FunctionTests.mo':
Semantic error at line 1094, column 8:
  Type error in expression: x + y
")})));
end FunctionType17;


model BuiltInCallType1
  Real x = sin(true);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="BuiltInCallType1",
			description="Built-in type checks: passing Boolean literal to sin()",
			variability_propagation=false,
			errorMessage="
1 error(s) found:
Error: in file 'FunctionTests.mo':
Semantic error at line 1, column 1:
  Calling function sin(): types of positional argument 1 and input u are not compatible
")})));
end BuiltInCallType1;

model BuiltInCallType2
  Real x = sqrt("test");

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="BuiltInCallType2",
			description="Built-in type checks: passing String literal to sqrt()",
			variability_propagation=false,
			errorMessage="
1 error(s) found:
Error: in file 'FunctionTests.mo':
Semantic error at line 1, column 1:
  Calling function sqrt(): types of positional argument 1 and input x are not compatible
")})));
end BuiltInCallType2;

model BuiltInCallType3
  Real x = sqrt(1);

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="BuiltInCallType3",
			description="Built-in type checks: passing Integer literal to sqrt()",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.BuiltInCallType3
 Real x = sqrt(1);

end FunctionTests.BuiltInCallType3;
")})));
end BuiltInCallType3;

model BuiltInCallType4
  Integer x = sqrt(9.0);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="BuiltInCallType4",
			description="Built-in type checks: using return value from sqrt() as Integer",
			variability_propagation=false,
			errorMessage="
1 error(s) found:
Error: in file 'FunctionTests.mo':
Semantic error at line 1, column 1:
  The binding expression of the variable x does not match the declared type of the variable
")})));
end BuiltInCallType4;

model BuiltInCallType5
  Real x = sin();

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="BuiltInCallType5",
			description="Built-in type checks: calling sin() without arguments",
			variability_propagation=false,
			errorMessage="
1 error(s) found:
Error: in file 'FunctionTests.mo':
Semantic error at line 1, column 1:
  Calling function sin(): missing argument for required input u
")})));
end BuiltInCallType5;

model BuiltInCallType6
  Real x = atan2(9.0);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="BuiltInCallType6",
			description="Built-in type checks: calling atan2() with only one argument",
			variability_propagation=false,
			errorMessage="
1 error(s) found:
Error: in file 'FunctionTests.mo':
Semantic error at line 1, column 1:
  Calling function atan2(): missing argument for required input u2
")})));
end BuiltInCallType6;

model BuiltInCallType7
  Real x = atan2(9.0, "test");

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="BuiltInCallType7",
			description="Built-in type checks: calling atan2() with String literal as second argument",
			variability_propagation=false,
			errorMessage="
1 error(s) found:
Error: in file 'FunctionTests.mo':
Semantic error at line 1, column 1:
  Calling function atan2(): types of positional argument 2 and input u2 are not compatible
")})));
end BuiltInCallType7;

model BuiltInCallType8
  Real x[3] = zeros(3);
  Real y[3,2] = ones(3,2);

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="BuiltInCallType8",
			description="Built-in type checks: using ones and zeros",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.BuiltInCallType8
 Real x[3] = zeros(3);
 Real y[3,2] = ones(3, 2);

end FunctionTests.BuiltInCallType8;
")})));
end BuiltInCallType8;

model BuiltInCallType9
   Real x[3] = zeros(3.0);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="BuiltInCallType9",
			description="Built-in type checks: calling zeros() with Real literal as argument",
			variability_propagation=false,
			errorMessage="
1 error(s) found:
Error: in file 'FunctionTests.mo':
Semantic error at line 1, column 1:
  Argument of zeros() is not compatible with Integer: 3.0
")})));
end BuiltInCallType9;

model BuiltInCallType10
   Real x[3] = ones(3, "test");

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="BuiltInCallType10",
			description="Built-in type checks: calling ones() with String literal as second argument",
			variability_propagation=false,
			errorMessage="
2 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/FunctionTests.mo':
Semantic error at line 1234, column 9:
  Array size mismatch in declaration of x, size of declaration is [3] and size of binding expression is [3, \"test\"]
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/FunctionTests.mo':
Semantic error at line 1223, column 24:
  Argument of ones() is not compatible with Integer: \"test\"
")})));
end BuiltInCallType10;

model FunctionVariability1
    function IsXPositive
        input Real x;
        output Boolean y;
    algorithm
        if x >= 0 then
            y := true;
        else
            y := false;
        end if;
    end IsXPositive;
    Boolean x = IsXPositive(time - 0.5);

    annotation(__JModelica(UnitTesting(tests={
        FlatteningTestCase(
            name="FunctionVariability1",
            description="Function variability test",
            flatModel="
fclass FunctionTests.FunctionVariability1
 discrete Boolean x = FunctionTests.FunctionVariability1.IsXPositive(time - 0.5);

public
 function FunctionTests.FunctionVariability1.IsXPositive
  input Real x;
  output Boolean y;
 algorithm
  if x >= 0 then
   y := true;
  else
   y := false;
  end if;
  return;
 end FunctionTests.FunctionVariability1.IsXPositive;

end FunctionTests.FunctionVariability1;
")})));
end FunctionVariability1;

model FunctionVariability2
    function count
        input Real x;
        output Integer y = 0;
    algorithm
        while x > y loop
            y := y + 1;
        end while;
    end count;
    Integer x = count(time);

    annotation(__JModelica(UnitTesting(tests={
        FlatteningTestCase(
            name="FunctionVariability2",
            description="Function variability test",
            flatModel="
fclass FunctionTests.FunctionVariability2
 discrete Integer x = FunctionTests.FunctionVariability2.count(time);

public
 function FunctionTests.FunctionVariability2.count
  input Real x;
  output Integer y := 0;
 algorithm
  while x > y loop
   y := y + 1;
  end while;
  return;
 end FunctionTests.FunctionVariability2.count;

end FunctionTests.FunctionVariability2;
")})));
end FunctionVariability2;

/* ====================== Algorithm flattening ====================== */

model AlgorithmFlatten1
 Real x;
algorithm
 x := 5;
 x := x + 2;

    annotation(__JModelica(UnitTesting(tests={
        TransformCanonicalTestCase(
            name="AlgorithmFlatten1",
            description="Flattening algorithms: assign stmts",
            flatModel="
fclass FunctionTests.AlgorithmFlatten1
 Real x;
algorithm
 x := 5;
 x := x + 2;
end FunctionTests.AlgorithmFlatten1;
")})));
end AlgorithmFlatten1;


model AlgorithmFlatten2
 Real x(start = 1.0);
 Real y = x;
algorithm
 x := 5;
 x := x + 2;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="AlgorithmFlatten2",
			description="Alias elimination in algorithm",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.AlgorithmFlatten2
 Real x(start = 1.0);
algorithm
 x := 5;
 x := x + 2;
end FunctionTests.AlgorithmFlatten2;
")})));
end AlgorithmFlatten2;


model AlgorithmFlatten3
 Integer x;
 Integer y;
algorithm
 if x == 4 then
  x := 1;
  y := 2;
 elseif x == 3 then
  if y == 0 then
   y := 1;
  end if;
  x := 2;
  y := 3;
 else
  x := 3;
 end if;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="AlgorithmFlatten3",
			description="Flattening algorithms: if stmts",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.AlgorithmFlatten3
 discrete Integer x;
 discrete Integer y;
initial equation 
 pre(x) = 0;
 pre(y) = 0;
algorithm
 if x == 4 then
  x := 1;
  y := 2;
 elseif x == 3 then
  if y == 0 then
   y := 1;
  end if;
  x := 2;
  y := 3;
 else
  x := 3;
 end if;
end FunctionTests.AlgorithmFlatten3;
")})));
end AlgorithmFlatten3;


model AlgorithmFlatten4
 Integer x;
 Integer y;
algorithm
 when x == 4 then
  x := 1;
  y := 2;
 elsewhen x == 3 then
  x := 2;
  y := 3;
  if x == 2 then
   x := 3;
  end if;
 end when;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="AlgorithmFlatten4",
			description="Flattening algorithms: when stmts",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.AlgorithmFlatten4
 discrete Integer x;
 discrete Integer y;
 discrete Boolean temp_1;
 discrete Boolean temp_2;
initial equation 
 pre(x) = 0;
 pre(y) = 0;
 pre(temp_1) = false;
 pre(temp_2) = false;
algorithm
 temp_1 := x == 4;
 temp_2 := x == 3;
 if temp_1 and not pre(temp_1) then
  x := 1;
  y := 2;
 elseif temp_2 and not pre(temp_2) then
  x := 2;
  y := 3;
  if x == 2 then
   x := 3;
  end if;
 end if;
end FunctionTests.AlgorithmFlatten4;
			
")})));
end AlgorithmFlatten4;


model AlgorithmFlatten5
 Real x;
algorithm
 while noEvent(x < 1) loop
  while noEvent(x < 2) loop
   while noEvent(x < 3) loop
    x := x + 1;
   end while;
  end while;
 end while;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="AlgorithmFlatten5",
			description="Flattening algorithms: while stmts",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.AlgorithmFlatten5
 Real x;
algorithm
 while noEvent(x < 1) loop
  while noEvent(x < 2) loop
   while noEvent(x < 3) loop
    x := x + 1;
   end while;
  end while;
 end while;
end FunctionTests.AlgorithmFlatten5;
")})));
end AlgorithmFlatten5;


model AlgorithmFlatten6
 Real x;
algorithm
 for i in {1, 2, 4}, j in 1:3 loop
  x := x + i * j;
 end for;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="AlgorithmFlatten6",
			description="Flattening algorithms: for stmts",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.AlgorithmFlatten6
 Real x;
algorithm
 x := x + 1;
 x := x + 2;
 x := x + 3;
 x := x + 2;
 x := x + 2 * 2;
 x := x + 2 * 3;
 x := x + 4;
 x := x + 4 * 2;
 x := x + 4 * 3;
end FunctionTests.AlgorithmFlatten6;
")})));
end AlgorithmFlatten6;

model AlgorithmFlatten7
function f
	input Real[2] i;
	output Real[2] o;
algorithm
	o := if i * i > 1.0E-6 then i else i;
end f;

Real[2] x = f({time,time*2});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="AlgorithmFlatten7",
			description="Flattening algorithms: if expression",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.AlgorithmFlatten7
 Real x[1];
 Real x[2];
equation
 ({x[1], x[2]}) = FunctionTests.AlgorithmFlatten7.f({time, time * 2});

public
 function FunctionTests.AlgorithmFlatten7.f
  input Real[2] i;
  output Real[2] o;
algorithm
  o[1] := if i[1] * i[1] + i[2] * i[2] > 1.0E-6 then i[1] else i[1];
  o[2] := if i[1] * i[1] + i[2] * i[2] > 1.0E-6 then i[2] else i[2];
  return;
 end FunctionTests.AlgorithmFlatten7.f;
end FunctionTests.AlgorithmFlatten7;
")})));
end AlgorithmFlatten7;

model AlgorithmFlatten8
  Real[3] x;
algorithm
  for i in 1:3 loop
    x[1:i] := 1:i;
    x[{i,2}] := {i,2};
  end for;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="AlgorithmFlatten8",
			description="Flattening algorithms: for indices in left hand side of array assignments.",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.AlgorithmFlatten8
 Real x[1];
 Real x[2];
 Real x[3];
algorithm
 x[1] := 1;
 x[1] := 1;
 x[2] := 2;
 x[1] := 1;
 x[2] := 2;
 x[2] := 2;
 x[2] := 2;
 x[1] := 1;
 x[2] := 2;
 x[3] := 3;
 x[3] := 3;
 x[2] := 2;
end FunctionTests.AlgorithmFlatten8;

")})));
end AlgorithmFlatten8;

model AlgorithmFlatten9
 Real y1,y2,y3,x;
algorithm
 when x > 2 then
  y1 := sin(x);
 end when;
equation
 y2 = sin(y1);
 x = time;
algorithm
 when x > 2 then
	 y3 := 2*x + y1 + y2;
 end when;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="AlgorithmFlatten9",
			description="Flattening algorithms: when stmts",
			flatModel="
fclass FunctionTests.AlgorithmFlatten9
 discrete Real y1;
 Real y2;
 discrete Real y3;
 Real x;
 discrete Boolean temp_1;
 discrete Boolean temp_2;
initial equation 
 pre(y1) = 0.0;
 pre(y3) = 0.0;
 pre(temp_1) = false;
 pre(temp_2) = false;
equation
 y2 = sin(y1);
 x = time;
algorithm
 if temp_1 and not pre(temp_1) then
  y1 := sin(x);
 end if;
algorithm
 if temp_2 and not pre(temp_2) then
  y3 := 2 * x + y1 + y2;
 end if;
equation
 temp_1 = x > 2;
 temp_2 = x > 2;
end FunctionTests.AlgorithmFlatten9;
			
")})));
end AlgorithmFlatten9;

model AlgorithmFlatten10
 Real y1,y2;
algorithm
	when time > 1 then
		y1 := 1;
	elsewhen time > 2 then
		y2 := 2;
	end when;
	
	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="AlgorithmFlatten10",
			description="Flattening algorithms: else-when stmts",
			flatModel="
fclass FunctionTests.AlgorithmFlatten10
 discrete Real y1;
 discrete Real y2;
 discrete Boolean temp_1;
 discrete Boolean temp_2;
initial equation 
 pre(y1) = 0.0;
 pre(y2) = 0.0;
 pre(temp_1) = false;
 pre(temp_2) = false;
algorithm
 if temp_1 and not pre(temp_1) then
  y1 := 1;
 elseif temp_2 and not pre(temp_2) then
  y2 := 2;
 end if;
equation
 temp_1 = time > 1;
 temp_2 = time > 2;
end FunctionTests.AlgorithmFlatten10;
			
")})));
end AlgorithmFlatten10;


/* ====================== Algorithm type checks ====================== */

/* ----- if ----- */

model AlgorithmTypeIf1
 Real x;
algorithm
 if 1 then
  x := 1.0;
 end if;

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="AlgorithmTypeIf1",
			description="Type checks in algorithms: Integer literal as test in if",
			variability_propagation=false,
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/FunctionTests.mo':
Semantic error at line 1944, column 5:
  Type of test expression of if statement is not Boolean
")})));
end AlgorithmTypeIf1;

model AlgorithmTypeIf2
 Integer a = 1;
 Real x;
algorithm
 if a then
  x := 1.0;
 end if;

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="AlgorithmTypeIf2",
			description="Type checks in algorithms: Integer component as test in if",
			variability_propagation=false,
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/FunctionTests.mo':
Semantic error at line 1382, column 5:
  Type of test expression of if statement is not Boolean
")})));
end AlgorithmTypeIf2;

model AlgorithmTypeIf3
 Integer a = 1;
 Real x;
algorithm
 if a + x then
  x := 1.0;
 end if;

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="AlgorithmTypeIf3",
			description="Type checks in algorithms: arithmetic expression as test in if",
			variability_propagation=false,
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/FunctionTests.mo':
Semantic error at line 1403, column 5:
  Type of test expression of if statement is not Boolean
")})));
end AlgorithmTypeIf3;

model AlgorithmTypeIf4
 Real x;
algorithm
 if { true, false } then
  x := 1.0;
 end if;

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="AlgorithmTypeIf4",
			description="Type checks in algorithms: Boolean vector as test in if",
			variability_propagation=false,
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/FunctionTests.mo':
Semantic error at line 1422, column 5:
  Type of test expression of if statement is not Boolean
")})));
end AlgorithmTypeIf4;

model AlgorithmTypeIf5
 Real x;
algorithm
 if true then
  x := 1.0;
 end if;

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="AlgorithmTypeIf5",
			description="Type checks in algorithms: Boolean literal as test in if",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.AlgorithmTypeIf5
 Real x;
algorithm
 if true then
  x := 1.0;
 end if;

end FunctionTests.AlgorithmTypeIf5;
")})));
end AlgorithmTypeIf5;

/* ----- when ----- */

model AlgorithmTypeWhen1
 Real x;
algorithm
 when 1 then
  x := 1.0;
 end when;

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="AlgorithmTypeWhen1",
			description="Type checks in algorithms: Integer literal as test in when",
			variability_propagation=false,
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/FunctionTests.mo':
Semantic error at line 1469, column 7:
  Test expression of when statement isn't Boolean scalar or vector expression
")})));
end AlgorithmTypeWhen1;

model AlgorithmTypeWhen2
 Integer a = 1;
 Real x;
algorithm
 when a then
  x := 1.0;
 end when;

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="AlgorithmTypeWhen2",
			description="Type checks in algorithms: Integer component as test in when",
			variability_propagation=false,
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/FunctionTests.mo':
Semantic error at line 1489, column 7:
  Test expression of when statement isn't Boolean scalar or vector expression
")})));
end AlgorithmTypeWhen2;

model AlgorithmTypeWhen3
 Integer a = 1;
 Real x;
algorithm
 when a + x then
  x := 1.0;
 end when;

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="AlgorithmTypeWhen3",
			description="Type checks in algorithms: arithmetic expression as test in when",
			variability_propagation=false,
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/FunctionTests.mo':
Semantic error at line 1509, column 7:
  Test expression of when statement isn't Boolean scalar or vector expression
")})));
end AlgorithmTypeWhen3;

model AlgorithmTypeWhen4
 Real x;
algorithm
 when { true, false } then
  x := 1.0;
 end when;

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="AlgorithmTypeWhen4",
			description="Type checks in algorithms: Boolean vector as test in when",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.AlgorithmTypeWhen4
 discrete Real x;
algorithm
 when {true, false} then
  x := 1.0;
 end when;
end FunctionTests.AlgorithmTypeWhen4;
")})));
end AlgorithmTypeWhen4;

model AlgorithmTypeWhen5
 Real x;
algorithm
 when true then
  x := 1.0;
 end when;

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="AlgorithmTypeWhen5",
			description="Type checks in algorithms: Boolean literal as test in when",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.AlgorithmTypeWhen5
 discrete Real x;
algorithm
 when true then
  x := 1.0;
 end when;
end FunctionTests.AlgorithmTypeWhen5;
")})));
end AlgorithmTypeWhen5;

/* ----- while ----- */

model AlgorithmTypeWhile1
 Real x;
algorithm
 while 1 loop
  x := 1.0;
 end while;

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="AlgorithmTypeWhile1",
			description="Type checks in algorithms: Integer literal as test in while",
			variability_propagation=false,
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/FunctionTests.mo':
Semantic error at line 1363, column 5:
  Type of test expression of while statement is not Boolean
")})));
end AlgorithmTypeWhile1;

model AlgorithmTypeWhile2
 Integer a = 1;
 Real x;
algorithm
 while a loop
  x := 1.0;
 end while;

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="AlgorithmTypeWhile2",
			description="Type checks in algorithms: Integer component as test in while",
			variability_propagation=false,
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/FunctionTests.mo':
Semantic error at line 1382, column 5:
  Type of test expression of while statement is not Boolean
")})));
end AlgorithmTypeWhile2;

model AlgorithmTypeWhile3
 Integer a = 1;
 Real x;
algorithm
 while a + x loop
  x := 1.0;
 end while;

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="AlgorithmTypeWhile3",
			description="Type checks in algorithms: arithmetic expression as test in while",
			variability_propagation=false,
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/FunctionTests.mo':
Semantic error at line 1403, column 5:
  Type of test expression of while statement is not Boolean
")})));
end AlgorithmTypeWhile3;

model AlgorithmTypeWhile4
 Real x;
algorithm
 while { true, false } loop
  x := 1.0;
 end while;

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="AlgorithmTypeWhile4",
			description="Type checks in algorithms: Boolean vector as test in while",
			variability_propagation=false,
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/FunctionTests.mo':
Semantic error at line 1422, column 5:
  Type of test expression of while statement is not Boolean
")})));
end AlgorithmTypeWhile4;

model AlgorithmTypeWhile5
 Real x;
algorithm
 while true loop
  x := 1.0;
 end while;

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="AlgorithmTypeWhile5",
			description="Type checks in algorithms: Boolean literal as test in while",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.AlgorithmTypeWhile5
 Real x;
algorithm
 while true loop
  x := 1.0;
 end while;

end FunctionTests.AlgorithmTypeWhile5;
")})));
end AlgorithmTypeWhile5;

model AlgorithmTypeAssign1
 Integer x;
algorithm
 x := 1.0;

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="AlgorithmTypeAssign1",
			description="Type checks in algorithms: assign Real to Integer component",
			variability_propagation=false,
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/FunctionTests.mo':
Semantic error at line 1674, column 2:
  Types of right and left side of assignment are not compatible
")})));
end AlgorithmTypeAssign1;

model AlgorithmTypeAssign2
 Real x;
algorithm
 x := 1;

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="AlgorithmTypeAssign2",
			description="Type checks in algorithms: assign Integer to Real component",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.AlgorithmTypeAssign2
 Real x;
algorithm
 x := 1;

end FunctionTests.AlgorithmTypeAssign2;
")})));
end AlgorithmTypeAssign2;

model AlgorithmTypeAssign3
 Real x;
algorithm
 x := 1.0;

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="AlgorithmTypeAssign3",
			description="Type checks in algorithms: assign Real to Real component",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.AlgorithmTypeAssign3
 Real x;
algorithm
 x := 1.0;

end FunctionTests.AlgorithmTypeAssign3;
")})));
end AlgorithmTypeAssign3;

model AlgorithmTypeAssign4
 Real x;
algorithm
 x := "foo";

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="AlgorithmTypeAssign4",
			description="Type checks in algorithms: assign String to Real component",
			variability_propagation=false,
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/FunctionTests.mo':
Semantic error at line 1715, column 2:
  Types of right and left side of assignment are not compatible
")})));
end AlgorithmTypeAssign4;


model AlgorithmTypeForIndex1
 Real x;
algorithm
 for i in 1:3 loop
  i := 2;
  x := i;
 end for;

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="AlgorithmTypeForIndex1",
			description="Type checks in algorithms: assigning to for index",
			variability_propagation=false,
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/FunctionTests.mo':
Semantic error at line 1794, column 3:
  Can not assign a value to a for loop index
")})));
end AlgorithmTypeForIndex1;


model AlgorithmTypeForIndex2
 Real x;
algorithm
 for i in 1:3 loop
  (i, x) := TestFunction2(1, 2);
 end for;

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="AlgorithmTypeForIndex2",
			description="Type checks in algorithms: assigning to for index (FunctionCallStmt)",
			variability_propagation=false,
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/FunctionTests.mo':
Semantic error at line 1815, column 3:
  Can not assign a value to a for loop index
")})));
end AlgorithmTypeForIndex2;


/* ====================== Algorithm transformations ===================== */

model AlgorithmTransformation1
 Real a = 1;
 Real b = 2;
 Real x;
 Real y;
algorithm
 x := a;
 y := b;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="AlgorithmTransformation1",
			description="Generating functions from algorithms: simple algorithm",
			variability_propagation=false,
			algorithms_as_functions=true,
			inline_functions="none",
			flatModel="
fclass FunctionTests.AlgorithmTransformation1
 Real a;
 Real b;
 Real x;
 Real y;
equation
 (x, y) = FunctionTests.AlgorithmTransformation1.algorithm_1(a, b);
 a = 1;
 b = 2;

public
 function FunctionTests.AlgorithmTransformation1.algorithm_1
  output Real x;
  output Real y;
  input Real a;
  input Real b;
 algorithm
  x := a;
  y := b;
  return;
 end FunctionTests.AlgorithmTransformation1.algorithm_1;

end FunctionTests.AlgorithmTransformation1;
")})));
end AlgorithmTransformation1;


model AlgorithmTransformation2
 Real a = 1;
 Real x;
 Real y;
algorithm
 x := a;
 y := a;
 x := a;
 y := a;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="AlgorithmTransformation2",
			description="Generating functions from algorithms: vars used several times",
			variability_propagation=false,
			algorithms_as_functions=true,
			inline_functions="none",
			flatModel="
fclass FunctionTests.AlgorithmTransformation2
 Real a;
 Real x;
 Real y;
equation
 (x, y) = FunctionTests.AlgorithmTransformation2.algorithm_1(a);
 a = 1;

public
 function FunctionTests.AlgorithmTransformation2.algorithm_1
  output Real x;
  output Real y;
  input Real a;
 algorithm
  x := a;
  y := a;
  x := a;
  y := a;
  return;
 end FunctionTests.AlgorithmTransformation2.algorithm_1;

end FunctionTests.AlgorithmTransformation2;
")})));
end AlgorithmTransformation2;


model AlgorithmTransformation3
 Real a = 1;
 Real b = 2;
 Real x;
 Real y;
algorithm
 x := a + 1;
 if b > 1 then
  y := a + 2;
 end if;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="AlgorithmTransformation3",
			description="Generating functions from algorithms: complex algorithm",
			variability_propagation=false,
			algorithms_as_functions=true,
			inline_functions="none",
			flatModel="
fclass FunctionTests.AlgorithmTransformation3
 Real a;
 Real b;
 Real x;
 Real y;
equation
 (x, y) = FunctionTests.AlgorithmTransformation3.algorithm_1(a, b);
 a = 1;
 b = 2;

public
 function FunctionTests.AlgorithmTransformation3.algorithm_1
  output Real x;
  output Real y;
  input Real a;
  input Real b;
 algorithm
  x := a + 1;
  if b > 1 then
   y := a + 2;
  end if;
  return;
 end FunctionTests.AlgorithmTransformation3.algorithm_1;

end FunctionTests.AlgorithmTransformation3;
")})));
end AlgorithmTransformation3;


model AlgorithmTransformation4
 Real a = 1;
 Real b;
 Real x;
 Real y;
algorithm
 b := 2;
 while b > 1 loop
  x := a;
  if a < 2 then
   y := b;
  else
   y := a + 2;
  end if;
  b := b - 0.1;
 end while;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="AlgorithmTransformation4",
			description="Generating functions from algorithms: complex algorithm",
			variability_propagation=false,
			algorithms_as_functions=true,
			inline_functions="none",
			flatModel="
fclass FunctionTests.AlgorithmTransformation4
 Real a;
 Real b;
 Real x;
 Real y;
equation
 (b, x, y) = FunctionTests.AlgorithmTransformation4.algorithm_1(0.0, a);
 a = 1;

public
 function FunctionTests.AlgorithmTransformation4.algorithm_1
  output Real b;
  output Real x;
  output Real y;
  input Real b_0;
  input Real a;
 algorithm
  b := b_0;
  b := 2;
  while b > 1 loop
   x := a;
   if a < 2 then
    y := b;
   else
    y := a + 2;
   end if;
   b := b - 0.1;
  end while;
  return;
 end FunctionTests.AlgorithmTransformation4.algorithm_1;

end FunctionTests.AlgorithmTransformation4;
")})));
end AlgorithmTransformation4;


model AlgorithmTransformation5
 Real x;
 Real y;
algorithm
 x := 1;
 y := 2;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="AlgorithmTransformation5",
			description="Generating functions from algorithms: no used variables",
			variability_propagation=false,
			algorithms_as_functions=true,
			inline_functions="none",
			flatModel="
fclass FunctionTests.AlgorithmTransformation5
 Real x;
 Real y;
equation
 (x, y) = FunctionTests.AlgorithmTransformation5.algorithm_1();

public
 function FunctionTests.AlgorithmTransformation5.algorithm_1
  output Real x;
  output Real y;
 algorithm
  x := 1;
  y := 2;
  return;
 end FunctionTests.AlgorithmTransformation5.algorithm_1;

end FunctionTests.AlgorithmTransformation5;
")})));
end AlgorithmTransformation5;


model AlgorithmTransformation6
 Real x;
 Real y;
algorithm
 x := 1;
algorithm
 y := 2;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="AlgorithmTransformation6",
			description="Generating functions from algorithms: 2 algorithms",
			variability_propagation=false,
			algorithms_as_functions=true,
			inline_functions="none",
			flatModel="
fclass FunctionTests.AlgorithmTransformation6
 Real x;
 Real y;
equation
 (x) = FunctionTests.AlgorithmTransformation6.algorithm_1();
 (y) = FunctionTests.AlgorithmTransformation6.algorithm_2();

public
 function FunctionTests.AlgorithmTransformation6.algorithm_1
  output Real x;
 algorithm
  x := 1;
  return;
 end FunctionTests.AlgorithmTransformation6.algorithm_1;

 function FunctionTests.AlgorithmTransformation6.algorithm_2
  output Real y;
 algorithm
  y := 2;
  return;
 end FunctionTests.AlgorithmTransformation6.algorithm_2;

end FunctionTests.AlgorithmTransformation6;
")})));
end AlgorithmTransformation6;


model AlgorithmTransformation7
 function algorithm_1
  input Real i;
  output Real o = i * 2;
  algorithm
 end algorithm_1;
 
 Real x;
algorithm
 x := algorithm_1(2);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="AlgorithmTransformation7",
			description="Generating functions from algorithms: generated name exists - function",
			variability_propagation=false,
			algorithms_as_functions=true,
			inline_functions="none",
			flatModel="
fclass FunctionTests.AlgorithmTransformation7
 Real x;
equation
 (x) = FunctionTests.AlgorithmTransformation7.algorithm_2();

public
 function FunctionTests.AlgorithmTransformation7.algorithm_1
  input Real i;
  output Real o;
 algorithm
  o := i * 2;
  return;
 end FunctionTests.AlgorithmTransformation7.algorithm_1;

 function FunctionTests.AlgorithmTransformation7.algorithm_2
  output Real x;
 algorithm
  x := FunctionTests.AlgorithmTransformation7.algorithm_1(2);
  return;
 end FunctionTests.AlgorithmTransformation7.algorithm_2;

end FunctionTests.AlgorithmTransformation7;
")})));
end AlgorithmTransformation7;


model AlgorithmTransformation8
 model algorithm_1
  Real a;
  Real b;
 end algorithm_1;
 
 algorithm_1 x;
algorithm
 x.a := 2;
 x.b := 3;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="AlgorithmTransformation8",
			description="Generating functions from algorithms: generated name exists - model",
			variability_propagation=false,
			algorithms_as_functions=true,
			inline_functions="none",
			flatModel="
fclass FunctionTests.AlgorithmTransformation8
 Real x.a;
 Real x.b;
equation
 (x.a, x.b) = FunctionTests.AlgorithmTransformation8.algorithm_1();

public
 function FunctionTests.AlgorithmTransformation8.algorithm_1
  output Real x.a;
  output Real x.b;
 algorithm
  x.a := 2;
  x.b := 3;
  return;
 end FunctionTests.AlgorithmTransformation8.algorithm_1;

end FunctionTests.AlgorithmTransformation8;
")})));
end AlgorithmTransformation8;


model AlgorithmTransformation9
 Real algorithm_1;
 Real algorithm_3;
algorithm
 algorithm_1 := 1;
algorithm
 algorithm_3 := 3;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="AlgorithmTransformation9",
			description="Generating functions from algorithms: generated name exists - component",
			variability_propagation=false,
			algorithms_as_functions=true,
			inline_functions="none",
			flatModel="
fclass FunctionTests.AlgorithmTransformation9
 Real algorithm_1;
 Real algorithm_3;
equation
 (algorithm_1) = FunctionTests.AlgorithmTransformation9.algorithm_2();
 (algorithm_3) = FunctionTests.AlgorithmTransformation9.algorithm_4();

public
 function FunctionTests.AlgorithmTransformation9.algorithm_2
  output Real algorithm_1;
 algorithm
  algorithm_1 := 1;
  return;
 end FunctionTests.AlgorithmTransformation9.algorithm_2;

 function FunctionTests.AlgorithmTransformation9.algorithm_4
  output Real algorithm_3;
 algorithm
  algorithm_3 := 3;
  return;
 end FunctionTests.AlgorithmTransformation9.algorithm_4;

end FunctionTests.AlgorithmTransformation9;
")})));
end AlgorithmTransformation9;


model AlgorithmTransformation10
 Real x;
 Real x_0;
 Real x_1;
algorithm
 x := x_0;
 x_1 := x;
equation
 x_0 = 0;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="AlgorithmTransformation10",
			description="Generating functions from algorithms: generated arg name exists",
			variability_propagation=false,
			algorithms_as_functions=true,
			inline_functions="none",
			flatModel="
fclass FunctionTests.AlgorithmTransformation10
 Real x;
 Real x_0;
 Real x_1;
equation
 x_0 = 0;
 (x, x_1) = FunctionTests.AlgorithmTransformation10.algorithm_1(x_0, 0.0);

public
 function FunctionTests.AlgorithmTransformation10.algorithm_1
  output Real x;
  output Real x_1;
  input Real x_0;
  input Real x_2;
 algorithm
  x := x_2;
  x := x_0;
  x_1 := x;
  return;
 end FunctionTests.AlgorithmTransformation10.algorithm_1;

end FunctionTests.AlgorithmTransformation10;
")})));
end AlgorithmTransformation10;


model AlgorithmTransformation11
 Real x;
 Real y;
algorithm
 x := 1;
 y := x;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="AlgorithmTransformation11",
			description="Generating functions from algorithms: assigned variable used",
			variability_propagation=false,
			algorithms_as_functions=true,
			inline_functions="none",
			flatModel="
fclass FunctionTests.AlgorithmTransformation11
 Real x;
 Real y;
equation
 (x, y) = FunctionTests.AlgorithmTransformation11.algorithm_1(0.0);

public
 function FunctionTests.AlgorithmTransformation11.algorithm_1
  output Real x;
  output Real y;
  input Real x_0;
 algorithm
  x := x_0;
  x := 1;
  y := x;
  return;
 end FunctionTests.AlgorithmTransformation11.algorithm_1;

end FunctionTests.AlgorithmTransformation11;
")})));
end AlgorithmTransformation11;


model AlgorithmTransformation12
 Real x0;
 Real x1(start=1);
 Real x2(start=2);
 Real y;
algorithm
 x0 := 1;
 x1 := x0;
 x2 := x1;
 y := x2;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="AlgorithmTransformation12",
			description="Generating functions from algorithms: assigned variables used, different start values",
			variability_propagation=false,
			algorithms_as_functions=true,
			inline_functions="none",
			flatModel="
fclass FunctionTests.AlgorithmTransformation12
 Real x0;
 Real x1(start = 1);
 Real x2(start = 2);
 Real y;
equation
 (x0, x1, x2, y) = FunctionTests.AlgorithmTransformation12.algorithm_1(0.0, 1, 2);

public
 function FunctionTests.AlgorithmTransformation12.algorithm_1
  output Real x0;
  output Real x1;
  output Real x2;
  output Real y;
  input Real x0_0;
  input Real x1_0;
  input Real x2_0;
 algorithm
  x0 := x0_0;
  x1 := x1_0;
  x2 := x2_0;
  x0 := 1;
  x1 := x0;
  x2 := x1;
  y := x2;
  return;
 end FunctionTests.AlgorithmTransformation12.algorithm_1;

end FunctionTests.AlgorithmTransformation12;
")})));
end AlgorithmTransformation12;


model AlgorithmTransformation13
 Real x = 2;
algorithm
 if x < 3 then
  TestFunction1(x);
 end if;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="AlgorithmTransformation13",
			description="Generating functions from algorithms: no assignments",
			variability_propagation=false,
			algorithms_as_functions=true,
			inline_functions="none",
			flatModel="
fclass FunctionTests.AlgorithmTransformation13
 Real x;
equation
 FunctionTests.AlgorithmTransformation13.algorithm_1(x);
 x = 2;

public
 function FunctionTests.TestFunction1
  input Real i1;
  output Real o1;
 algorithm
  o1 := i1;
  return;
 end FunctionTests.TestFunction1;

 function FunctionTests.AlgorithmTransformation13.algorithm_1
  input Real x;
 algorithm
  if x < 3 then
   FunctionTests.TestFunction1(x);
  end if;
  return;
 end FunctionTests.AlgorithmTransformation13.algorithm_1;

end FunctionTests.AlgorithmTransformation13;
")})));
end AlgorithmTransformation13;


model AlgorithmTransformation14
 Real x;
algorithm
 x := 0;
 for i in 1:3 loop
  x := x + i;
 end for;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="AlgorithmTransformation14",
			description="Generating functions from algorithms: using for index",
			variability_propagation=false,
			algorithms_as_functions=true,
			inline_functions="none",
			flatModel="
fclass FunctionTests.AlgorithmTransformation14
 Real x;
equation
 (x) = FunctionTests.AlgorithmTransformation14.algorithm_1(0.0);

public
 function FunctionTests.AlgorithmTransformation14.algorithm_1
  output Real x;
  input Real x_0;
 algorithm
  x := x_0;
  x := 0;
  for i in 1:3 loop
   x := x + i;
  end for;
  return;
 end FunctionTests.AlgorithmTransformation14.algorithm_1;

end FunctionTests.AlgorithmTransformation14;
")})));
end AlgorithmTransformation14;


model AlgorithmTransformation15
	Real a_in = 1;
	Real b_in = 2;
	Real c_out;
	Real d_out;

	function f
		input Real a;
		input Real b;
		output Real c = a;
		output Real d = b;
	algorithm
	end f;

algorithm
	(c_out, d_out) := f(a_in, b_in);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="AlgorithmTransformation15",
			description="Generating functions from algorithms: function call statement",
			variability_propagation=false,
			algorithms_as_functions=true,
			inline_functions="none",
			flatModel="
fclass FunctionTests.AlgorithmTransformation15
 Real a_in;
 Real b_in;
 Real c_out;
 Real d_out;
equation
 (c_out, d_out) = FunctionTests.AlgorithmTransformation15.algorithm_1(a_in, b_in);
 a_in = 1;
 b_in = 2;

public
 function FunctionTests.AlgorithmTransformation15.f
  input Real a;
  input Real b;
  output Real c;
  output Real d;
 algorithm
  c := a;
  d := b;
  return;
 end FunctionTests.AlgorithmTransformation15.f;

 function FunctionTests.AlgorithmTransformation15.algorithm_1
  output Real c_out;
  output Real d_out;
  input Real a_in;
  input Real b_in;
 algorithm
  (c_out, d_out) := FunctionTests.AlgorithmTransformation15.f(a_in, b_in);
  return;
 end FunctionTests.AlgorithmTransformation15.algorithm_1;

end FunctionTests.AlgorithmTransformation15;
")})));
end AlgorithmTransformation15;



/* =========================== Arrays in functions =========================== */

model ArrayExpInFunc1
 function f
  output Real o = 1.0;
  protected Real x[3];
 algorithm
  x := { 1, 2, 3 };
 end f;
 
 Real x = f();

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayExpInFunc1",
			description="Scalarization of functions: assign from array",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.ArrayExpInFunc1
 Real x;
equation
 x = FunctionTests.ArrayExpInFunc1.f();

public
 function FunctionTests.ArrayExpInFunc1.f
  output Real o;
  Real[3] x;
 algorithm
  o := 1.0;
  x[1] := 1;
  x[2] := 2;
  x[3] := 3;
  return;
 end FunctionTests.ArrayExpInFunc1.f;

end FunctionTests.ArrayExpInFunc1;
")})));
end ArrayExpInFunc1;


model ArrayExpInFunc2
 function f
  output Real o = 1.0;
  protected Real x[2,2];
 algorithm
  x := {{1,2},{3,4}} * {{1,2},{3,4}};
 end f;
 
 Real x = f();

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayExpInFunc2",
			description="Scalarization of functions: assign from array exp",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.ArrayExpInFunc2
 Real x;
equation
 x = FunctionTests.ArrayExpInFunc2.f();

public
 function FunctionTests.ArrayExpInFunc2.f
  output Real o;
  Real[2, 2] x;
 algorithm
  o := 1.0;
  x[1,1] := 1 + 2 * 3;
  x[1,2] := 2 + 2 * 4;
  x[2,1] := 3 + 4 * 3;
  x[2,2] := 3 * 2 + 4 * 4;
  return;
 end FunctionTests.ArrayExpInFunc2.f;

end FunctionTests.ArrayExpInFunc2;
")})));
end ArrayExpInFunc2;


model ArrayExpInFunc3
 function f
  output Real o = 1.0;
  protected Real x[2,2];
 algorithm
  x[1,:] := {1,2};
  x[2,:] := {3,4};
 end f;
 
 Real x = f();

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayExpInFunc3",
			description="Scalarization of functions: assign to slice",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.ArrayExpInFunc3
 Real x;
equation
 x = FunctionTests.ArrayExpInFunc3.f();

public
 function FunctionTests.ArrayExpInFunc3.f
  output Real o;
  Real[2, 2] x;
 algorithm
  o := 1.0;
  x[1,1] := 1;
  x[1,2] := 2;
  x[2,1] := 3;
  x[2,2] := 4;
  return;
 end FunctionTests.ArrayExpInFunc3.f;

end FunctionTests.ArrayExpInFunc3;
")})));
end ArrayExpInFunc3;


model ArrayExpInFunc4
 function f
  output Real o = 1.0;
  protected Real x[2,2] = {{1,2},{3,4}} * {{1,2},{3,4}};
 algorithm
 end f;
 
 Real x = f();

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayExpInFunc4",
			description="Scalarization of functions: binding exp to array var",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.ArrayExpInFunc4
 Real x;
equation
 x = FunctionTests.ArrayExpInFunc4.f();

public
 function FunctionTests.ArrayExpInFunc4.f
  output Real o;
  Real[2, 2] x;
 algorithm
  o := 1.0;
  x[1,1] := 1 + 2 * 3;
  x[1,2] := 2 + 2 * 4;
  x[2,1] := 3 + 4 * 3;
  x[2,2] := 3 * 2 + 4 * 4;
  return;
 end FunctionTests.ArrayExpInFunc4.f;

end FunctionTests.ArrayExpInFunc4;
")})));
end ArrayExpInFunc4;


model ArrayExpInFunc5
 function f
  input Real a;
  output Real o;
  protected Real x;
  protected Real y;
 algorithm
  (x, y) := f2({1,2,3} * {1,2,3});
  o := a + x + y;
 end f;
 
 function f2
  input Real a;
  output Real b = a;
  output Real c = a;
 algorithm
 end f2;
 
 Real x = f({1,2,3} * {1,2,3});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayExpInFunc5",
			description="Scalarization of functions: (x, y) := f(...) syntax",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.ArrayExpInFunc5
 Real x;
equation
 x = FunctionTests.ArrayExpInFunc5.f(1 + 2 * 2 + 3 * 3);

public
 function FunctionTests.ArrayExpInFunc5.f
  input Real a;
  output Real o;
  Real x;
  Real y;
 algorithm
  (x, y) := FunctionTests.ArrayExpInFunc5.f2(1 + 2 * 2 + 3 * 3);
  o := a + x + y;
  return;
 end FunctionTests.ArrayExpInFunc5.f;

 function FunctionTests.ArrayExpInFunc5.f2
  input Real a;
  output Real b;
  output Real c;
 algorithm
  b := a;
  c := a;
  return;
 end FunctionTests.ArrayExpInFunc5.f2;

end FunctionTests.ArrayExpInFunc5;
")})));
end ArrayExpInFunc5;


model ArrayExpInFunc6
 function f
  output Real o = 1.0;
  protected Real x[3];
 algorithm
  if o < 2.0 then
   x := { 1, 2, 3 };
  elseif o < 1.5 then
   x := { 4, 5, 6 };
  else
   x := { 7, 8, 9 };
  end if;
 end f;
 
 Real x = f();

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayExpInFunc6",
			description="Scalarization of functions: if statements",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.ArrayExpInFunc6
 Real x;
equation
 x = FunctionTests.ArrayExpInFunc6.f();

public
 function FunctionTests.ArrayExpInFunc6.f
  output Real o;
  Real[3] x;
 algorithm
  o := 1.0;
  if o < 2.0 then
   x[1] := 1;
   x[2] := 2;
   x[3] := 3;
  elseif o < 1.5 then
   x[1] := 4;
   x[2] := 5;
   x[3] := 6;
  else
   x[1] := 7;
   x[2] := 8;
   x[3] := 9;
  end if;
  return;
 end FunctionTests.ArrayExpInFunc6.f;

end FunctionTests.ArrayExpInFunc6;
")})));
end ArrayExpInFunc6;


model ArrayExpInFunc8
 function f
  output Real o = 1.0;
  protected Real x[3];
  protected Real y[3];
 algorithm
  for i in 1:3 loop
   x[i] := i;
   y := {i*i for i in 1:3};
  end for;
 end f;
 
 Real x = f();

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayExpInFunc8",
			description="Scalarization of functions: for statements",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.ArrayExpInFunc8
 Real x;
equation
 x = FunctionTests.ArrayExpInFunc8.f();

public
 function FunctionTests.ArrayExpInFunc8.f
  output Real o;
  Real[3] x;
  Real[3] y;
 algorithm
  o := 1.0;
  for i in 1:3 loop
   x[i] := i;
   y[1] := 1;
   y[2] := 2 * 2;
   y[3] := 3 * 3;
  end for;
  return;
 end FunctionTests.ArrayExpInFunc8.f;

end FunctionTests.ArrayExpInFunc8;
")})));
end ArrayExpInFunc8;


model ArrayExpInFunc9
 function f
  output Real o = 1.0;
  protected Real x[3];
  protected Integer y = 3;
 algorithm
  while y > 0 loop
   x := 1:3;
   x[y] := y;
   y := y - 1;
  end while;
 end f;
 
 Real x = f();

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayExpInFunc9",
			description="Scalarization of functions: while statements",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.ArrayExpInFunc9
 Real x;
equation
 x = FunctionTests.ArrayExpInFunc9.f();

public
 function FunctionTests.ArrayExpInFunc9.f
  output Real o;
  Real[3] x;
  Integer y;
 algorithm
  o := 1.0;
  y := 3;
  while y > 0 loop
   x[1] := 1;
   x[2] := 2;
   x[3] := 3;
   x[y] := y;
   y := y - 1;
  end while;
  return;
 end FunctionTests.ArrayExpInFunc9.f;

end FunctionTests.ArrayExpInFunc9;
")})));
end ArrayExpInFunc9;

model ArrayExpInFunc10
function f
	input Real[:,2] a;
	output Real[size(a,1)] b;
algorithm
	b := a[:,2];
end f;
	Real[3,2] x = {{1,2},{3,4},{5,6}};
	Real y[3];
equation
	y = f(x);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayExpInFunc10",
			description="Scalarization of functions: unknown size slice",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.ArrayExpInFunc10
 Real x[1,1];
 Real x[1,2];
 Real x[2,1];
 Real x[2,2];
 Real x[3,1];
 Real x[3,2];
 Real y[1];
 Real y[2];
 Real y[3];
equation
 ({y[1], y[2], y[3]}) = FunctionTests.ArrayExpInFunc10.f({{x[1,1], x[1,2]}, {x[2,1], x[2,2]}, {x[3,1], x[3,2]}});
 x[1,1] = 1;
 x[1,2] = 2;
 x[2,1] = 3;
 x[2,2] = 4;
 x[3,1] = 5;
 x[3,2] = 6;

public
 function FunctionTests.ArrayExpInFunc10.f
  input Real[:, 2] a;
  output Real[size(a, 1)] b;
 algorithm
  for i1 in 1:size(a, 1) loop
   b[i1] := a[i1,2];
  end for;
  return;
 end FunctionTests.ArrayExpInFunc10.f;

end FunctionTests.ArrayExpInFunc10;

")})));
end ArrayExpInFunc10;

model ArrayExpInFunc11
	
record R
	Real x;
end R;
function f
	input Real[2,:,2] a;
	output Real[3,size(a,2)] b;
algorithm
	b[1,:] := a[2,:,1];
	b[{2,3},:] := 2*a[:,:,1];
end f;
	constant Real[3,2] c = {{1,1},{1,1},{1,1}};
	Real[2,3,2] x = {c,c};
	Real y[3,3];
equation
	y = f(x);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayExpInFunc11",
			description="Scalarization of functions: unknown size slice",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.ArrayExpInFunc11
 constant Real c[1,1] = 1;
 constant Real c[1,2] = 1;
 constant Real c[2,1] = 1;
 constant Real c[2,2] = 1;
 constant Real c[3,1] = 1;
 constant Real c[3,2] = 1;
 Real x[1,1,1];
 Real x[1,1,2];
 Real x[1,2,1];
 Real x[1,2,2];
 Real x[1,3,1];
 Real x[1,3,2];
 Real x[2,1,1];
 Real x[2,1,2];
 Real x[2,2,1];
 Real x[2,2,2];
 Real x[2,3,1];
 Real x[2,3,2];
 Real y[1,1];
 Real y[1,2];
 Real y[1,3];
 Real y[2,1];
 Real y[2,2];
 Real y[2,3];
 Real y[3,1];
 Real y[3,2];
 Real y[3,3];
equation
 ({{y[1,1], y[1,2], y[1,3]}, {y[2,1], y[2,2], y[2,3]}, {y[3,1], y[3,2], y[3,3]}}) = FunctionTests.ArrayExpInFunc11.f({{{x[1,1,1], x[1,1,2]}, {x[1,2,1], x[1,2,2]}, {x[1,3,1], x[1,3,2]}}, {{x[2,1,1], x[2,1,2]}, {x[2,2,1], x[2,2,2]}, {x[2,3,1], x[2,3,2]}}});
 x[1,1,1] = 1.0;
 x[1,1,2] = 1.0;
 x[1,2,1] = 1.0;
 x[1,2,2] = 1.0;
 x[1,3,1] = 1.0;
 x[1,3,2] = 1.0;
 x[2,1,1] = 1.0;
 x[2,1,2] = 1.0;
 x[2,2,1] = 1.0;
 x[2,2,2] = 1.0;
 x[2,3,1] = 1.0;
 x[2,3,2] = 1.0;

public
 function FunctionTests.ArrayExpInFunc11.f
  input Real[2, :, 2] a;
  output Real[3, size(a, 2)] b;
  Integer[2] temp_1;
 algorithm
  for i1 in 1:size(a, 2) loop
   b[1,i1] := a[2,i1,1];
  end for;
  temp_1[1] := 2;
  temp_1[2] := 3;
  for i1 in 1:2 loop
   for i2 in 1:size(a, 2) loop
    b[temp_1[i1],i2] := 2 * a[i1,i2,1];
   end for;
  end for;
  return;
 end FunctionTests.ArrayExpInFunc11.f;

end FunctionTests.ArrayExpInFunc11;

")})));
end ArrayExpInFunc11;

model ArrayExpInFunc12
	
record R
	Real x[2];
end R;
function f1
	output Real[2] o = {1,2};
	algorithm
end f1;
function f2
	output R b;
algorithm
	b := R(f1());
end f2;
	R r;
equation
	r = f2();

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayExpInFunc12",
			description="Scalarization of functions: temp in record constructor",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.ArrayExpInFunc12
 Real r.x[1];
 Real r.x[2];
equation
 (FunctionTests.ArrayExpInFunc12.R({r.x[1], r.x[2]})) = FunctionTests.ArrayExpInFunc12.f2();

public
 function FunctionTests.ArrayExpInFunc12.f2
  output FunctionTests.ArrayExpInFunc12.R b;
  Real[2] temp_1;
 algorithm
  (temp_1) := FunctionTests.ArrayExpInFunc12.f1();
  b.x[1] := temp_1[1];
  b.x[2] := temp_1[2];
  return;
 end FunctionTests.ArrayExpInFunc12.f2;

 function FunctionTests.ArrayExpInFunc12.f1
  output Real[2] o;
 algorithm
  o[1] := 1;
  o[2] := 2;
  return;
 end FunctionTests.ArrayExpInFunc12.f1;

 record FunctionTests.ArrayExpInFunc12.R
  Real x[2];
 end FunctionTests.ArrayExpInFunc12.R;

end FunctionTests.ArrayExpInFunc12;

")})));
end ArrayExpInFunc12;

model ArrayExpInFunc13
	
function f
	input Integer[:] i;
	input Real[:] x;
	output Real[size(i,1)] y;
algorithm
	y := x[i];
end f;

Real[3] x = f({1,2,3}, {1,2,3});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayExpInFunc13",
			description="Scalarization of functions: unknown size slice",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.ArrayExpInFunc13
 Real x[1];
 Real x[2];
 Real x[3];
equation
 ({x[1], x[2], x[3]}) = FunctionTests.ArrayExpInFunc13.f({1, 2, 3}, {1, 2, 3});

public
 function FunctionTests.ArrayExpInFunc13.f
  input Integer[:] i;
  input Real[:] x;
  output Real[size(i, 1)] y;
 algorithm
  for i1 in 1:size(i, 1) loop
   y[i1] := x[i[i1]];
  end for;
  return;
 end FunctionTests.ArrayExpInFunc13.f;

end FunctionTests.ArrayExpInFunc13;
			
")})));
end ArrayExpInFunc13;

model ArrayExpInFunc14
	
function f
	input Integer[:] is1;
	input Integer[size(is1,1)] is2;
	input Real[:,:] x;
	output Real[size(is1,1),size(is1,1)] y;
algorithm
	y := x[is1,is2];
	y := x[is2,is1] + y;
end f;

Real[2,2] x = f({1,2}, {1,2}, {{1,2},{3,4}});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayExpInFunc14",
			description="Scalarization of functions: unknown size slice",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.ArrayExpInFunc14
 Real x[1,1];
 Real x[1,2];
 Real x[2,1];
 Real x[2,2];
equation
 ({{x[1,1], x[1,2]}, {x[2,1], x[2,2]}}) = FunctionTests.ArrayExpInFunc14.f({1, 2}, {1, 2}, {{1, 2}, {3, 4}});

public
 function FunctionTests.ArrayExpInFunc14.f
  input Integer[:] is1;
  input Integer[size(is1, 1)] is2;
  input Real[:, :] x;
  output Real[size(is1, 1), size(is1, 1)] y;
 algorithm
  for i1 in 1:size(is1, 1) loop
   for i2 in 1:size(is1, 1) loop
    y[i1,i2] := x[is1[i1],is2[i2]];
   end for;
  end for;
  for i1 in 1:size(is1, 1) loop
   for i2 in 1:size(is1, 1) loop
    y[i1,i2] := x[is2[i1],is1[i2]] + y[i1,i2];
   end for;
  end for;
  return;
 end FunctionTests.ArrayExpInFunc14.f;

end FunctionTests.ArrayExpInFunc14;
			
")})));
end ArrayExpInFunc14;

model ArrayExpInFunc15
	
function f
	input Integer[:] is1;
	input Integer[:] is2;
	input Real[:,:] x;
	output Real[size(is2,1), 2] y;
algorithm
	y := x[is1[is2], {1,2}];
end f;

Real[2,2] x = f({1,2,3}, {2,3}, {{1,2,3},{4,5,6}});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayExpInFunc15",
			description="Scalarization of functions: unknown size slice",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.ArrayExpInFunc15
 Real x[1,1];
 Real x[1,2];
 Real x[2,1];
 Real x[2,2];
equation
 ({{x[1,1], x[1,2]}, {x[2,1], x[2,2]}}) = FunctionTests.ArrayExpInFunc15.f({1, 2, 3}, {2, 3}, {{1, 2, 3}, {4, 5, 6}});

public
 function FunctionTests.ArrayExpInFunc15.f
  input Integer[:] is1;
  input Integer[:] is2;
  input Real[:, :] x;
  output Real[size(is2, 1), 2] y;
  Integer[2] temp_1;
 algorithm
  temp_1[1] := 1;
  temp_1[2] := 2;
  for i1 in 1:size(is2, 1) loop
   for i2 in 1:2 loop
    y[i1,i2] := x[is1[is2[i1]],temp_1[i2]];
   end for;
  end for;
  return;
 end FunctionTests.ArrayExpInFunc15.f;

end FunctionTests.ArrayExpInFunc15;
			
")})));
end ArrayExpInFunc15;

model ArrayExpInFunc16
	
function f
	input Integer[:] is1;
	input Integer[:] is2;
	input Real[:,:] x;
	output Real[size(is2,1), 2] y;
algorithm
	y := x[is1[{1,2}],is2];
end f;

Real[2,2] x = f({1,2,3}, {2,3}, {{1,2,3},{4,5,6}});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayExpInFunc16",
			description="Scalarization of functions: unknown size slice",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.ArrayExpInFunc16
 Real x[1,1];
 Real x[1,2];
 Real x[2,1];
 Real x[2,2];
equation
 ({{x[1,1], x[1,2]}, {x[2,1], x[2,2]}}) = FunctionTests.ArrayExpInFunc16.f({1, 2, 3}, {2, 3}, {{1, 2, 3}, {4, 5, 6}});

public
 function FunctionTests.ArrayExpInFunc16.f
  input Integer[:] is1;
  input Integer[:] is2;
  input Real[:, :] x;
  output Real[size(is2, 1), 2] y;
  Integer[2] temp_1;
 algorithm
  assert(size(is2, 1) == 2, \"Mismatching sizes in FunctionTests.ArrayExpInFunc16.f\");
  temp_1[1] := 1;
  temp_1[2] := 2;
  for i1 in 1:2 loop
   for i2 in 1:size(is2, 1) loop
    y[i1,i2] := x[is1[temp_1[i1]],is2[i2]];
   end for;
  end for;
  return;
 end FunctionTests.ArrayExpInFunc16.f;

end FunctionTests.ArrayExpInFunc16;
			
")})));
end ArrayExpInFunc16;

model ArrayExpInFunc17
	
function f
	input Integer is1;
	input Integer is2;
	input Integer n;
	input Real[:,:] x;
	output Real[n, size(x,2)] y;
algorithm
	y[:] := x[is1:is2];
end f;

Real[3,3] x = f(1,3,3,{{1,2,3},{4,5,6}});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayExpInFunc17",
			description="Scalarization of functions: unknown size range exp as slice",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.ArrayExpInFunc17
 Real x[1,1];
 Real x[1,2];
 Real x[1,3];
 Real x[2,1];
 Real x[2,2];
 Real x[2,3];
 Real x[3,1];
 Real x[3,2];
 Real x[3,3];
equation
 ({{x[1,1], x[1,2], x[1,3]}, {x[2,1], x[2,2], x[2,3]}, {x[3,1], x[3,2], x[3,3]}}) = FunctionTests.ArrayExpInFunc17.f(1, 3, 3, {{1, 2, 3}, {4, 5, 6}});

public
 function FunctionTests.ArrayExpInFunc17.f
  input Integer is1;
  input Integer is2;
  input Integer n;
  input Real[:, :] x;
  output Real[n, size(x, 2)] y;
 algorithm
  for i1 in 1:max(integer(is2 - is1) + 1, 0) loop
   y[i1] := x[is1 + (i1 - 1)];
  end for;
  return;
 end FunctionTests.ArrayExpInFunc17.f;

end FunctionTests.ArrayExpInFunc17;
			
")})));
end ArrayExpInFunc17;

model ArrayExpInFunc18
	
function f
	input Real[:] i;
	output Real[size(i,1)] o;
	output Real dummy = 1;
algorithm
	o := i;
end f;

function fw
	input Integer[:] i;
	output Real[size(i,1)] o;
	output Real dummy = 1;
algorithm
	o[{1,3,5}] := {1,1,1};
	(o[i],) := f(o[i]);
end fw;

Real[3] ae;
equation
	(ae[{3,2,1}],) = fw({1,2,3});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayExpInFunc18",
			description="Scalarization of functions: unknown size slice in function call stmt",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.ArrayExpInFunc18
 Real ae[1];
 Real ae[2];
 Real ae[3];
equation
 ({ae[3], ae[2], ae[1]}, ) = FunctionTests.ArrayExpInFunc18.fw({1, 2, 3});

public
 function FunctionTests.ArrayExpInFunc18.fw
  input Integer[:] i;
  output Real[size(i, 1)] o;
  output Real dummy;
  Real[:] temp_1;
  Real[:] temp_2;
 algorithm
  size(temp_1) := {size(i, 1)};
  size(temp_2) := {size(i, 1)};
  dummy := 1;
  o[1] := 1;
  o[3] := 1;
  o[5] := 1;
  for i1 in 1:size(i, 1) loop
   temp_1[i1] := o[i[i1]];
  end for;
  (temp_2, ) := FunctionTests.ArrayExpInFunc18.f(temp_1);
  for i1 in 1:size(i, 1) loop
   o[i[i1]] := temp_2[i1];
  end for;
  return;
 end FunctionTests.ArrayExpInFunc18.fw;

 function FunctionTests.ArrayExpInFunc18.f
  input Real[:] i;
  output Real[size(i, 1)] o;
  output Real dummy;
 algorithm
  dummy := 1;
  for i1 in 1:size(i, 1) loop
   o[i1] := i[i1];
  end for;
  return;
 end FunctionTests.ArrayExpInFunc18.f;

end FunctionTests.ArrayExpInFunc18;
			
")})));
end ArrayExpInFunc18;

model ArrayExpInFunc19
	
function f
	input Real[:,:] x1;
	input Real[:,:] x2;
	output Real[2,size(x1,1),size(x1,2)] y;
algorithm
	y := {x1, x2};
end f;

Real[2,2,2] ae = f({{1,2},{3,4}},{{1,2},{3,4}});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayExpInFunc19",
			description="Scalarization of functions: unknown size array expression",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.ArrayExpInFunc19
 Real ae[1,1,1];
 Real ae[1,1,2];
 Real ae[1,2,1];
 Real ae[1,2,2];
 Real ae[2,1,1];
 Real ae[2,1,2];
 Real ae[2,2,1];
 Real ae[2,2,2];
equation
 ({{{ae[1,1,1], ae[1,1,2]}, {ae[1,2,1], ae[1,2,2]}}, {{ae[2,1,1], ae[2,1,2]}, {ae[2,2,1], ae[2,2,2]}}}) = FunctionTests.ArrayExpInFunc19.f({{1, 2}, {3, 4}}, {{1, 2}, {3, 4}});

public
 function FunctionTests.ArrayExpInFunc19.f
  input Real[:, :] x1;
  input Real[:, :] x2;
  output Real[2, size(x1, 1), size(x1, 2)] y;
  Real[:,:,:] temp_1;
 algorithm
  size(temp_1) := {2, size(x1, 1), size(x1, 2)};
  for i5 in 1:size(x1, 1) loop
   for i6 in 1:size(x1, 2) loop
    temp_1[1,i5,i6] := x1[i5,i6];
   end for;
  end for;
  for i5 in 1:size(x2, 1) loop
   for i6 in 1:size(x2, 2) loop
    temp_1[2,i5,i6] := x2[i5,i6];
   end for;
  end for;
  for i1 in 1:2 loop
   for i2 in 1:size(x1, 1) loop
    for i3 in 1:size(x1, 2) loop
     y[i1,i2,i3] := temp_1[i1,i2,i3];
    end for;
   end for;
  end for;
  return;
 end FunctionTests.ArrayExpInFunc19.f;

end FunctionTests.ArrayExpInFunc19;
			
")})));
end ArrayExpInFunc19;

model ArrayExpInFunc20
	
function f
	input Real[:] x1;
	output Real[2,size(x1,1)+2] o;
algorithm
	o := [{x1}, 1, 2; 3,{x1},4];
end f;

Real[2,4] ae = f({1,2});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayExpInFunc20",
			description="Scalarization of functions: unknown size matrix expression",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.ArrayExpInFunc20
 Real ae[1,1];
 Real ae[1,2];
 Real ae[1,3];
 Real ae[1,4];
 Real ae[2,1];
 Real ae[2,2];
 Real ae[2,3];
 Real ae[2,4];
equation
 ({{ae[1,1], ae[1,2], ae[1,3], ae[1,4]}, {ae[2,1], ae[2,2], ae[2,3], ae[2,4]}}) = FunctionTests.ArrayExpInFunc20.f({1, 2});

public
 function FunctionTests.ArrayExpInFunc20.f
  input Real[:] x1;
  output Real[2, size(x1, 1) + 2] o;
  Real[:,:] temp_1;
  Integer temp_2;
  Integer temp_3;
  Real[:,:] temp_4;
  Real[:,:] temp_5;
 algorithm
  size(temp_1) := {2, size(x1, 1) + 1 + 1};
  size(temp_4) := {1, size(x1, 1)};
  size(temp_5) := {1, size(x1, 1)};
  temp_2 := 0;
  temp_3 := 0;
  for i6 in 1:size(x1, 1) loop
   temp_4[1,i6] := x1[i6];
  end for;
  for i3 in 1:1 loop
   for i4 in 1:size(x1, 1) loop
    temp_1[temp_2 + i3,temp_3 + i4] := temp_4[i3,i4];
   end for;
  end for;
  temp_3 := temp_3 + size(x1, 1);
  temp_1[temp_2 + 1,temp_3 + 1] := 1;
  temp_3 := temp_3 + 1;
  temp_1[temp_2 + 1,temp_3 + 1] := 2;
  temp_2 := temp_2 + 1;
  temp_3 := 0;
  temp_1[temp_2 + 1,temp_3 + 1] := 3;
  temp_3 := temp_3 + 1;
  for i6 in 1:size(x1, 1) loop
   temp_5[1,i6] := x1[i6];
  end for;
  for i3 in 1:1 loop
   for i4 in 1:size(x1, 1) loop
    temp_1[temp_2 + i3,temp_3 + i4] := temp_5[i3,i4];
   end for;
  end for;
  temp_3 := temp_3 + size(x1, 1);
  temp_1[temp_2 + 1,temp_3 + 1] := 4;
  for i1 in 1:2 loop
   for i2 in 1:size(x1, 1) + 1 + 1 loop
    o[i1,i2] := temp_1[i1,i2];
   end for;
  end for;
  return;
 end FunctionTests.ArrayExpInFunc20.f;

end FunctionTests.ArrayExpInFunc20;
			
")})));
end ArrayExpInFunc20;

model ArrayExpInFunc21
	
function f
	input Real[:] x1;
	input Real[:,:] x2;
	input Real[:,:] x3;
	output Real[size(x1,1)*2+size(x3,1),size(x2,2)+1] y;
algorithm
	y := [x1, x2; x2, x1; x3];
end f;

Real[5,3] ae = f({1,2},{{3,4},{5,6}},{{10,11,12}});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayExpInFunc21",
			description="Scalarization of functions: unknown size matrix expression",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.ArrayExpInFunc21
 Real ae[1,1];
 Real ae[1,2];
 Real ae[1,3];
 Real ae[2,1];
 Real ae[2,2];
 Real ae[2,3];
 Real ae[3,1];
 Real ae[3,2];
 Real ae[3,3];
 Real ae[4,1];
 Real ae[4,2];
 Real ae[4,3];
 Real ae[5,1];
 Real ae[5,2];
 Real ae[5,3];
equation
 ({{ae[1,1], ae[1,2], ae[1,3]}, {ae[2,1], ae[2,2], ae[2,3]}, {ae[3,1], ae[3,2], ae[3,3]}, {ae[4,1], ae[4,2], ae[4,3]}, {ae[5,1], ae[5,2], ae[5,3]}}) = FunctionTests.ArrayExpInFunc21.f({1, 2}, {{3, 4}, {5, 6}}, {{10, 11, 12}});

public
 function FunctionTests.ArrayExpInFunc21.f
  input Real[:] x1;
  input Real[:, :] x2;
  input Real[:, :] x3;
  output Real[size(x1, 1) * 2 + size(x3, 1), size(x2, 2) + 1] y;
  Real[:,:] temp_1;
  Integer temp_2;
  Integer temp_3;
 algorithm
  size(temp_1) := {size(x1, 1) + size(x2, 1) + size(x3, 1), 1 + size(x2, 2)};
  temp_2 := 0;
  temp_3 := 0;
  for i3 in 1:size(x1, 1) loop
   temp_1[temp_2 + i3,temp_3 + 1] := x1[i3];
  end for;
  temp_3 := temp_3 + 1;
  for i3 in 1:size(x2, 1) loop
   for i4 in 1:size(x2, 2) loop
    temp_1[temp_2 + i3,temp_3 + i4] := x2[i3,i4];
   end for;
  end for;
  temp_2 := temp_2 + size(x2, 1);
  temp_3 := 0;
  for i3 in 1:size(x2, 1) loop
   for i4 in 1:size(x2, 2) loop
    temp_1[temp_2 + i3,temp_3 + i4] := x2[i3,i4];
   end for;
  end for;
  temp_3 := temp_3 + size(x2, 2);
  for i3 in 1:size(x1, 1) loop
   temp_1[temp_2 + i3,temp_3 + 1] := x1[i3];
  end for;
  temp_2 := temp_2 + size(x1, 1);
  temp_3 := 0;
  for i3 in 1:size(x3, 1) loop
   for i4 in 1:size(x3, 2) loop
    temp_1[temp_2 + i3,temp_3 + i4] := x3[i3,i4];
   end for;
  end for;
  for i1 in 1:size(x1, 1) + size(x2, 1) + size(x3, 1) loop
   for i2 in 1:1 + size(x2, 2) loop
    y[i1,i2] := temp_1[i1,i2];
   end for;
  end for;
  return;
 end FunctionTests.ArrayExpInFunc21.f;

end FunctionTests.ArrayExpInFunc21;
			
")})));
end ArrayExpInFunc21;

model ArrayExpInFunc22
	
function f
	input Integer[:] a;
	input Integer[size(a,1)] b;
	input Real[:,:] x;
	output Real[size(a,1),size(a,1)] y;
algorithm
	y := transpose([x[a,a]]);
	y := transpose([x[a,b]]);
end f;

Real[2,2] ae = f({1,2},{2,1},{{3,4},{5,6},{7,8}});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayExpInFunc22",
			description="Scalarization of functions: unknown size matrix expression",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.ArrayExpInFunc22
 Real ae[1,1];
 Real ae[1,2];
 Real ae[2,1];
 Real ae[2,2];
equation
 ({{ae[1,1], ae[1,2]}, {ae[2,1], ae[2,2]}}) = FunctionTests.ArrayExpInFunc22.f({1, 2}, {2, 1}, {{3, 4}, {5, 6}, {7, 8}});

public
 function FunctionTests.ArrayExpInFunc22.f
  input Integer[:] a;
  input Integer[size(a, 1)] b;
  input Real[:, :] x;
  output Real[size(a, 1), size(a, 1)] y;
  Real[:,:] temp_1;
  Integer temp_2;
  Integer temp_3;
  Real[:,:] temp_4;
  Integer temp_5;
  Integer temp_6;
 algorithm
  size(temp_1) := {size(a, 1), size(a, 1)};
  size(temp_4) := {size(a, 1), size(a, 1)};
  temp_2 := 0;
  temp_3 := 0;
  for i3 in 1:size(a, 1) loop
   for i4 in 1:size(a, 1) loop
    temp_1[temp_2 + i3,temp_3 + i4] := x[a[i3],a[i4]];
   end for;
  end for;
  for i1 in 1:size(a, 1) loop
   for i2 in 1:size(a, 1) loop
    y[i1,i2] := temp_1[i2,i1];
   end for;
  end for;
  temp_5 := 0;
  temp_6 := 0;
  for i3 in 1:size(a, 1) loop
   for i4 in 1:size(a, 1) loop
    temp_4[temp_5 + i3,temp_6 + i4] := x[a[i3],b[i4]];
   end for;
  end for;
  for i1 in 1:size(a, 1) loop
   for i2 in 1:size(a, 1) loop
    y[i1,i2] := temp_4[i2,i1];
   end for;
  end for;
  return;
 end FunctionTests.ArrayExpInFunc22.f;

end FunctionTests.ArrayExpInFunc22;
			
")})));
end ArrayExpInFunc22;

model ArrayExpInFunc23
	
function f
  input Integer[:,:] a;
  input Integer[size(a,2),:] b;
  output Real[size(a,1),size(b,2)] o;
algorithm
  o := f(a*b,a);
end f;

Real[1,1] x = f({{1}},{{1}});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayExpInFunc23",
			description="Scalarization of functions: unknown size matrix expression",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.ArrayExpInFunc23
 Real x[1,1];
equation
 ({{x[1,1]}}) = FunctionTests.ArrayExpInFunc23.f({{1}}, {{1}});

public
 function FunctionTests.ArrayExpInFunc23.f
  input Integer[:, :] a;
  input Integer[size(a, 2), :] b;
  output Real[size(a, 1), size(b, 2)] o;
  Integer[:,:] temp_1;
  Integer temp_2;
 algorithm
  size(temp_1) := {size(a, 1), size(b, 2)};
  for i1 in 1:size(a, 1) loop
   for i2 in 1:size(b, 2) loop
    temp_2 := 0;
    for i3 in 1:size(a, 2) loop
     temp_2 := temp_2 + a[i1,i3] * b[i3,i2];
    end for;
    temp_1[i1,i2] := temp_2;
   end for;
  end for;
  (o) := FunctionTests.ArrayExpInFunc23.f(temp_1, a);
  return;
 end FunctionTests.ArrayExpInFunc23.f;

end FunctionTests.ArrayExpInFunc23;
			
")})));
end ArrayExpInFunc23;

model ArrayExpInFunc24
	
function f
  input Integer[:] in1;
  input Integer[:] in2;
  input Real[:] o_in;
  output Real[size(in1,1)] o;
algorithm
  o[in1] := f(in1, in2, o_in[in2]);
end f;

Real[1] x = f({1},{1},{1});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayExpInFunc24",
			description="Scalarization of functions: unknown size matrix expression",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.ArrayExpInFunc24
 Real x[1];
equation
 ({x[1]}) = FunctionTests.ArrayExpInFunc24.f({1}, {1}, {1});

public
 function FunctionTests.ArrayExpInFunc24.f
  input Integer[:] in1;
  input Integer[:] in2;
  input Real[:] o_in;
  output Real[size(in1, 1)] o;
  Real[:] temp_1;
  Real[:] temp_2;
 algorithm
  size(temp_1) := {size(in1, 1)};
  size(temp_2) := {size(in2, 1)};
  for i1 in 1:size(in2, 1) loop
   temp_2[i1] := o_in[in2[i1]];
  end for;
  (temp_1) := FunctionTests.ArrayExpInFunc24.f(in1, in2, temp_2);
  for i1 in 1:size(in1, 1) loop
   o[in1[i1]] := temp_1[i1];
  end for;
  return;
 end FunctionTests.ArrayExpInFunc24.f;

end FunctionTests.ArrayExpInFunc24;
			
")})));
end ArrayExpInFunc24;

model ArrayExpInFunc25
	
function f
  input Integer[:,:] a;
  input Integer[size(a,2),:] b;
  input Integer[:,:] c;
  output Real[size(c,1),size(c,2)] o;
algorithm
  o := c*sum(a*b);
end f;

Real[1,1] x = f({{1}},{{1}},{{1}});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayExpInFunc25",
			description="Scalarization of functions: unknown size matrix expression",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.ArrayExpInFunc25
 Real x[1,1];
equation
 ({{x[1,1]}}) = FunctionTests.ArrayExpInFunc25.f({{1}}, {{1}}, {{1}});

public
 function FunctionTests.ArrayExpInFunc25.f
  input Integer[:, :] a;
  input Integer[size(a, 2), :] b;
  input Integer[:, :] c;
  output Real[size(c, 1), size(c, 2)] o;
  Integer temp_1;
  Integer[:,:] temp_2;
  Integer temp_3;
 algorithm
  size(temp_2) := {size(a, 1), size(b, 2)};
  for i5 in 1:size(a, 1) loop
   for i6 in 1:size(b, 2) loop
    temp_3 := 0;
    for i7 in 1:size(a, 2) loop
     temp_3 := temp_3 + a[i5,i7] * b[i7,i6];
    end for;
    temp_2[i5,i6] := temp_3;
   end for;
  end for;
  temp_1 := 0;
  for i3 in 1:size(a, 1) loop
   for i4 in 1:size(b, 2) loop
    temp_1 := temp_1 + temp_2[i3,i4];
   end for;
  end for;
  for i1 in 1:size(c, 1) loop
   for i2 in 1:size(c, 2) loop
    o[i1,i2] := c[i1,i2] * temp_1;
   end for;
  end for;
  return;
 end FunctionTests.ArrayExpInFunc25.f;

end FunctionTests.ArrayExpInFunc25;
			
")})));
end ArrayExpInFunc25;

model ArrayExpInFunc26
	
function f
	input Real[:,:] a;
	input Real[:,:] b;
	output Real[size(a,1),size(b,2)] o = transpose(a * b + a);
	algorithm
end f;
	Real[1,1] x = f({{1}},{{1}}); 
equation

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayExpInFunc26",
			description="Scalarization of functions: unknown size matrix expression",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.ArrayExpInFunc26
 Real x[1,1];
equation
 ({{x[1,1]}}) = FunctionTests.ArrayExpInFunc26.f({{1}}, {{1}});

public
 function FunctionTests.ArrayExpInFunc26.f
  input Real[:, :] a;
  input Real[:, :] b;
  output Real[size(a, 1), size(b, 2)] o;
  Real[:,:] temp_1;
  Real temp_2;
 algorithm
  size(temp_1) := {size(a, 1), size(b, 2)};
  for i3 in 1:size(a, 1) loop
   for i4 in 1:size(b, 2) loop
    temp_2 := 0.0;
    for i5 in 1:size(b, 1) loop
     temp_2 := temp_2 + a[i3,i5] * b[i5,i4];
    end for;
    temp_1[i3,i4] := temp_2;
   end for;
  end for;
  for i1 in 1:size(b, 2) loop
   for i2 in 1:size(a, 1) loop
    o[i1,i2] := temp_1[i2,i1] + a[i2,i1];
   end for;
  end for;
  return;
 end FunctionTests.ArrayExpInFunc26.f;

end FunctionTests.ArrayExpInFunc26;
			
")})));
end ArrayExpInFunc26;

model ArrayExpInFunc27
	
function f
	input Real[:,:] a;
	input Real[:,:] b;
	output Real o[size(a,1),size(b,2)] = sum(a * b * i for i in 1:size(a,1));
	algorithm
end f;
	Real x[1,1] = f({{1}},{{1}}); 
equation

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayExpInFunc27",
			description="Scalarization of functions: unknown size matrix expression",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.ArrayExpInFunc27
 Real x[1,1];
equation
 ({{x[1,1]}}) = FunctionTests.ArrayExpInFunc27.f({{1}}, {{1}});

public
 function FunctionTests.ArrayExpInFunc27.f
  input Real[:, :] a;
  input Real[:, :] b;
  output Real[size(a, 1), size(b, 2)] o;
  Real[:,:] temp_1;
  Real[:,:] temp_2;
  Real temp_3;
 algorithm
  size(temp_1) := {size(a, 1), size(b, 2)};
  size(temp_2) := {size(a, 1), size(b, 2)};
  for i3 in 1:size(a, 1) loop
   for i4 in 1:size(a, 1) loop
    temp_1[i3,i4] := 0.0;
    for i5 in 1:size(b, 2) loop
     for i6 in 1:size(a, 1) loop
      for i7 in 1:size(b, 2) loop
       temp_3 := 0.0;
       for i8 in 1:size(b, 1) loop
        temp_3 := temp_3 + a[i6,i8] * b[i8,i7];
       end for;
       temp_2[i6,i7] := temp_3;
      end for;
     end for;
     temp_1[i3,i4] := temp_1[i3,i4] + temp_2[i4,i5] * i3;
    end for;
   end for;
  end for;
  for i1 in 1:size(a, 1) loop
   for i2 in 1:size(b, 2) loop
    o[i1,i2] := temp_1[i1,i2];
   end for;
  end for;
  return;
 end FunctionTests.ArrayExpInFunc27.f;

end FunctionTests.ArrayExpInFunc27;
			
")})));
end ArrayExpInFunc27;

model ArrayExpInFunc28
	
function f
	input Real[:,:] a;
	input Real[:,:] b;
	output Real o[size(a,1),size(b,2)] = sum(transpose(a * b * i) for i in 1:size(a,1));
	algorithm
end f;
	Real x[1,1] = f({{1}},{{1}}); 
equation

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayExpInFunc28",
			description="Scalarization of functions: unknown size matrix expression",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.ArrayExpInFunc28
 Real x[1,1];
equation
 ({{x[1,1]}}) = FunctionTests.ArrayExpInFunc28.f({{1}}, {{1}});

public
 function FunctionTests.ArrayExpInFunc28.f
  input Real[:, :] a;
  input Real[:, :] b;
  output Real[size(a, 1), size(b, 2)] o;
  Real[:,:] temp_1;
  Real[:,:] temp_2;
  Real temp_3;
 algorithm
  size(temp_1) := {size(b, 2), size(a, 1)};
  size(temp_2) := {size(a, 1), size(b, 2)};
  for i3 in 1:size(a, 1) loop
   for i4 in 1:size(b, 2) loop
    temp_1[i3,i4] := 0.0;
    for i5 in 1:size(a, 1) loop
     for i6 in 1:size(a, 1) loop
      for i7 in 1:size(b, 2) loop
       temp_3 := 0.0;
       for i8 in 1:size(b, 1) loop
        temp_3 := temp_3 + a[i6,i8] * b[i8,i7];
       end for;
       temp_2[i6,i7] := temp_3;
      end for;
     end for;
     temp_1[i3,i4] := temp_1[i3,i4] + temp_2[i5,i4] * i3;
    end for;
   end for;
  end for;
  for i1 in 1:size(b, 2) loop
   for i2 in 1:size(a, 1) loop
    o[i1,i2] := temp_1[i1,i2];
   end for;
  end for;
  return;
 end FunctionTests.ArrayExpInFunc28.f;

end FunctionTests.ArrayExpInFunc28;
			
")})));
end ArrayExpInFunc28;


model ArrayOutputScalarization1
 function f
  output Real x[2] = {1,2};
  output Real y[2] = {1,2};
 algorithm
 end f;
 
 Real x[2];
 Real y[2];
equation
 (x,y) = f();

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayOutputScalarization1",
			description="Scalarization of array function outputs: function call equation",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.ArrayOutputScalarization1
 Real x[1];
 Real x[2];
 Real y[1];
 Real y[2];
equation
 ({x[1], x[2]}, {y[1], y[2]}) = FunctionTests.ArrayOutputScalarization1.f();

public
 function FunctionTests.ArrayOutputScalarization1.f
  output Real[2] x;
  output Real[2] y;
 algorithm
  x[1] := 1;
  x[2] := 2;
  y[1] := 1;
  y[2] := 2;
  return;
 end FunctionTests.ArrayOutputScalarization1.f;

end FunctionTests.ArrayOutputScalarization1;
")})));
end ArrayOutputScalarization1;


model ArrayOutputScalarization2
 function f
  output Real x[2] = {1,2};
 algorithm
 end f;
 
 Real x[2];
equation
 x = {3,4} + f();

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayOutputScalarization2",
			description="Scalarization of array function outputs: expression with func call",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.ArrayOutputScalarization2
 Real x[1];
 Real x[2];
 Real temp_1[1];
 Real temp_1[2];
equation
 ({temp_1[1],temp_1[2]}) = FunctionTests.ArrayOutputScalarization2.f();
 x[1] = 3 + temp_1[1];
 x[2] = 4 + temp_1[2];

public
 function FunctionTests.ArrayOutputScalarization2.f
  output Real[2] x;
 algorithm
  x[1] := 1;
  x[2] := 2;
  return;
 end FunctionTests.ArrayOutputScalarization2.f;

end FunctionTests.ArrayOutputScalarization2;
")})));
end ArrayOutputScalarization2;


model ArrayOutputScalarization3
 function f
  output Real x[2] = {1, 2};
 algorithm
 end f;
 
 Real x[2];
 Real temp = 1;
 Real temp_1 = 2;
 Real temp_3 = 3;
equation
 x = {1,2} + f();

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayOutputScalarization3",
			description="Scalarization of array function outputs: finding free temp name",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.ArrayOutputScalarization3
 Real x[1];
 Real x[2];
 Real temp;
 Real temp_1;
 Real temp_3;
 Real temp_2[1];
 Real temp_2[2];
equation
 ({temp_2[1],temp_2[2]}) = FunctionTests.ArrayOutputScalarization3.f();
 x[1] = 1 + temp_2[1];
 x[2] = 2 + temp_2[2];
 temp = 1;
 temp_1 = 2;
 temp_3 = 3;

public
 function FunctionTests.ArrayOutputScalarization3.f
  output Real[2] x;
 algorithm
  x[1] := 1;
  x[2] := 2;
  return;
 end FunctionTests.ArrayOutputScalarization3.f;

end FunctionTests.ArrayOutputScalarization3;
")})));
end ArrayOutputScalarization3;


model ArrayOutputScalarization4
 function f1
  output Real x[2] = {1,2};
  output Real y[2] = {1,2};
 algorithm
 end f1;
 
 function f2
  output Real x;
  protected Real y[2];
  protected Real z[2];
 algorithm
  (y,z) := f1();
  x := y[1];
 end f2;
 
 Real x = f2();

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayOutputScalarization4",
			description="Scalarization of array function outputs: function call statement",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.ArrayOutputScalarization4
 Real x;
equation
 x = FunctionTests.ArrayOutputScalarization4.f2();

public
 function FunctionTests.ArrayOutputScalarization4.f2
  output Real x;
  Real[2] y;
  Real[2] z;
 algorithm
  (y, z) := FunctionTests.ArrayOutputScalarization4.f1();
  x := y[1];
  return;
 end FunctionTests.ArrayOutputScalarization4.f2;

 function FunctionTests.ArrayOutputScalarization4.f1
  output Real[2] x;
  output Real[2] y;
 algorithm
  x[1] := 1;
  x[2] := 2;
  y[1] := 1;
  y[2] := 2;
  return;
 end FunctionTests.ArrayOutputScalarization4.f1;

end FunctionTests.ArrayOutputScalarization4;
")})));
end ArrayOutputScalarization4;


model ArrayOutputScalarization5
 function f1
  output Real x[2] = {1, 2};
 algorithm
 end f1;
 
 function f2
  output Real x;
  protected Real y[2];
 algorithm
  y := {1,2} + f1();
  x := y[1];
 end f2;
 
 Real x = f2();

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayOutputScalarization5",
			description="Scalarization of array function outputs: assign statement with expression",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.ArrayOutputScalarization5
 Real x;
equation
 x = FunctionTests.ArrayOutputScalarization5.f2();

public
 function FunctionTests.ArrayOutputScalarization5.f2
  output Real x;
  Real[2] y;
  Real[2] temp_1;
 algorithm
  (temp_1) := FunctionTests.ArrayOutputScalarization5.f1();
  y[1] := 1 + temp_1[1];
  y[2] := 2 + temp_1[2];
  x := y[1];
  return;
 end FunctionTests.ArrayOutputScalarization5.f2;

 function FunctionTests.ArrayOutputScalarization5.f1
  output Real[2] x;
 algorithm
  x[1] := 1;
  x[2] := 2;
  return;
 end FunctionTests.ArrayOutputScalarization5.f1;

end FunctionTests.ArrayOutputScalarization5;
")})));
end ArrayOutputScalarization5;


model ArrayOutputScalarization6

 function f1
  output Real x[2] = {1, 2};
 algorithm
 end f1;
 
 function f2
  output Real x;
  protected Real y[2];
  protected Real temp_1;
 algorithm
  y := f1();
  x := y[1];
 end f2;
 
 Real x = f2();

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayOutputScalarization6",
			description="Scalarization of array function outputs: finding free temp name",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.ArrayOutputScalarization6
 Real x;
equation
 x = FunctionTests.ArrayOutputScalarization6.f2();

public
 function FunctionTests.ArrayOutputScalarization6.f2
  output Real x;
  Real[2] y;
  Real temp_1;
 algorithm
  (y) := FunctionTests.ArrayOutputScalarization6.f1();
  x := y[1];
  return;
 end FunctionTests.ArrayOutputScalarization6.f2;

 function FunctionTests.ArrayOutputScalarization6.f1
  output Real[2] x;
 algorithm
  x[1] := 1;
  x[2] := 2;
  return;
 end FunctionTests.ArrayOutputScalarization6.f1;

end FunctionTests.ArrayOutputScalarization6;
")})));
end ArrayOutputScalarization6;


model ArrayOutputScalarization7
 function f1
  output Real x[2] = {1, 2};
 algorithm
 end f1;
 
 function f2
  output Real x;
  protected Real y[2];
 algorithm
  if sum(f1()) < 4 then
   x := 1;
   y := {1,2} + f1();
  elseif sum(f1()) < 5 then
   y := {3,4};
  else
   x := 1;
   y := f1();
  end if;
  x := y[1];
 end f2;
 
 Real x = f2();

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayOutputScalarization7",
			description="Scalarization of array function outputs: if statement",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.ArrayOutputScalarization7
 Real x;
equation
 x = FunctionTests.ArrayOutputScalarization7.f2();

public
 function FunctionTests.ArrayOutputScalarization7.f2
  output Real x;
  Real[2] y;
  Real[2] temp_1;
  Real[2] temp_2;
  Real[2] temp_3;
 algorithm
  (temp_1) := FunctionTests.ArrayOutputScalarization7.f1();
  (temp_2) := FunctionTests.ArrayOutputScalarization7.f1();
  if temp_1[1] + temp_1[2] < 4 then
   x := 1;
   (temp_3) := FunctionTests.ArrayOutputScalarization7.f1();
   y[1] := 1 + temp_3[1];
   y[2] := 2 + temp_3[2];
  elseif temp_2[1] + temp_2[2] < 5 then
   y[1] := 3;
   y[2] := 4;
  else
   x := 1;
   (y) := FunctionTests.ArrayOutputScalarization7.f1();
  end if;
  x := y[1];
  return;
 end FunctionTests.ArrayOutputScalarization7.f2;

 function FunctionTests.ArrayOutputScalarization7.f1
  output Real[2] x;
 algorithm
  x[1] := 1;
  x[2] := 2;
  return;
 end FunctionTests.ArrayOutputScalarization7.f1;

end FunctionTests.ArrayOutputScalarization7;
")})));
end ArrayOutputScalarization7;


model ArrayOutputScalarization8
 function f1
  output Real x[2] = {1, 2};
 algorithm
 end f1;
 
 function f2
  output Real x;
  protected Real y[2];
 algorithm
  for i in f1() loop
   y[1] := i;
   y := f1();
  end for;
  x := y[1];
 end f2;
 
 Real x = f2();

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayOutputScalarization8",
			description="Scalarization of array function outputs: for statement",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.ArrayOutputScalarization8
 Real x;
equation
 x = FunctionTests.ArrayOutputScalarization8.f2();

public
 function FunctionTests.ArrayOutputScalarization8.f2
  output Real x;
  Real[2] y;
  Real[2] temp_1;
 algorithm
  (temp_1) := FunctionTests.ArrayOutputScalarization8.f1();
  for i in {temp_1[1],temp_1[2]} loop
   y[1] := i;
   (y) := FunctionTests.ArrayOutputScalarization8.f1();
  end for;
  x := y[1];
  return;
 end FunctionTests.ArrayOutputScalarization8.f2;

 function FunctionTests.ArrayOutputScalarization8.f1
  output Real[2] x;
 algorithm
  x[1] := 1;
  x[2] := 2;
  return;
 end FunctionTests.ArrayOutputScalarization8.f1;

end FunctionTests.ArrayOutputScalarization8;
")})));
end ArrayOutputScalarization8;


model ArrayOutputScalarization9
 function f
  output Real x[2] = {1, 2};
 algorithm
 end f;
 
 Real x[2];
equation
 x = f();

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayOutputScalarization9",
			description="Scalarization of array function outputs: equation without expression",
			variability_propagation=false,
			inline_functions="none",
			eliminate_alias_variables=false,
			flatModel="
fclass FunctionTests.ArrayOutputScalarization9
 Real x[1];
 Real x[2];
 Real temp_1[1];
 Real temp_1[2];
equation
 ({temp_1[1],temp_1[2]}) = FunctionTests.ArrayOutputScalarization9.f();
 x[1] = temp_1[1];
 x[2] = temp_1[2];

public
 function FunctionTests.ArrayOutputScalarization9.f
  output Real[2] x;
 algorithm
  x[1] := 1;
  x[2] := 2;
  return;
 end FunctionTests.ArrayOutputScalarization9.f;

end FunctionTests.ArrayOutputScalarization9;
")})));
end ArrayOutputScalarization9;


model ArrayOutputScalarization10
 function f1
  output Real x[2] = {1, 2};
 algorithm
 end f1;
 
 function f2
  output Real x = 0;
 algorithm
  while x < sum(f1()) loop
   x := x + 1;
  end while;
 end f2;
 
 Real x = f2();

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayOutputScalarization10",
			description="Scalarization of array function outputs: while statement",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.ArrayOutputScalarization10
 Real x;
equation
 x = FunctionTests.ArrayOutputScalarization10.f2();

public
 function FunctionTests.ArrayOutputScalarization10.f2
  output Real x;
  Real[2] temp_1;
 algorithm
  x := 0;
  (temp_1) := FunctionTests.ArrayOutputScalarization10.f1();
  while x < temp_1[1] + temp_1[2] loop
   x := x + 1;
   (temp_1) := FunctionTests.ArrayOutputScalarization10.f1();
  end while;
  return;
 end FunctionTests.ArrayOutputScalarization10.f2;

 function FunctionTests.ArrayOutputScalarization10.f1
  output Real[2] x;
 algorithm
  x[1] := 1;
  x[2] := 2;
  return;
 end FunctionTests.ArrayOutputScalarization10.f1;

end FunctionTests.ArrayOutputScalarization10;
")})));
end ArrayOutputScalarization10;


model ArrayOutputScalarization11
 function f1
  output Real x[2] = {1, 2};
 algorithm
 end f1;
 
 function f2
  output Real x;
  protected Real y[2] = f1();
 algorithm
  x := y[1];
 end f2;
 
 Real x = f2();

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayOutputScalarization11",
			description="Scalarization of array function outputs: binding expression",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.ArrayOutputScalarization11
 Real x;
equation
 x = FunctionTests.ArrayOutputScalarization11.f2();

public
 function FunctionTests.ArrayOutputScalarization11.f1
  output Real[2] x;
 algorithm
  x[1] := 1;
  x[2] := 2;
  return;
 end FunctionTests.ArrayOutputScalarization11.f1;

 function FunctionTests.ArrayOutputScalarization11.f2
  output Real x;
  Real[2] y;
 algorithm
  (y) := FunctionTests.ArrayOutputScalarization11.f1();
  x := y[1];
  return;
 end FunctionTests.ArrayOutputScalarization11.f2;

end FunctionTests.ArrayOutputScalarization11;
")})));
end ArrayOutputScalarization11;


model ArrayOutputScalarization12
 function f1
  output Real x[2] = {1, 2};
 algorithm
 end f1;
 
 function f2
  output Real x;
  protected Real y[2] = f1() + {3, 4};
 algorithm
  x := y[1];
 end f2;
 
 Real x = f2();

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayOutputScalarization12",
			description="Scalarization of array function outputs: part of binding expression",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.ArrayOutputScalarization12
 Real x;
equation
 x = FunctionTests.ArrayOutputScalarization12.f2();

public
 function FunctionTests.ArrayOutputScalarization12.f1
  output Real[2] x;
 algorithm
  x[1] := 1;
  x[2] := 2;
  return;
 end FunctionTests.ArrayOutputScalarization12.f1;

 function FunctionTests.ArrayOutputScalarization12.f2
  output Real x;
  Real[2] y;
  Real[2] temp_1;
 algorithm
  (temp_1) := FunctionTests.ArrayOutputScalarization12.f1();
  y[1] := temp_1[1] + 3;
  y[2] := temp_1[2] + 4;
  x := y[1];
  return;
 end FunctionTests.ArrayOutputScalarization12.f2;

end FunctionTests.ArrayOutputScalarization12;
")})));
end ArrayOutputScalarization12;


model ArrayOutputScalarization13
 function f1
  output Real x[2] = {1, 2};
 algorithm
 end f1;
 
 function f2
  output Real x;
  protected Real y = sum(f1());
 algorithm
  x := y;
 end f2;
 
 Real x = f2();

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayOutputScalarization13",
			description="Scalarization of array function outputs: part of scalar binding exp",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.ArrayOutputScalarization13
 Real x;
equation
 x = FunctionTests.ArrayOutputScalarization13.f2();

public
 function FunctionTests.ArrayOutputScalarization13.f1
  output Real[2] x;
 algorithm
  x[1] := 1;
  x[2] := 2;
  return;
 end FunctionTests.ArrayOutputScalarization13.f1;

 function FunctionTests.ArrayOutputScalarization13.f2
  output Real x;
  Real y;
  Real[2] temp_1;
 algorithm
  (temp_1) := FunctionTests.ArrayOutputScalarization13.f1();
  y := temp_1[1] + temp_1[2];
  x := y;
  return;
 end FunctionTests.ArrayOutputScalarization13.f2;

end FunctionTests.ArrayOutputScalarization13;
")})));
end ArrayOutputScalarization13;


model ArrayOutputScalarization14
 function f
  output Real x[2] = {1, 2};
 algorithm
 end f;
 
 Real x = f() * {3, 4};

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayOutputScalarization14",
			description="Scalarization of array function outputs: part of scalar expression",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.ArrayOutputScalarization14
 Real x;
 Real temp_1[1];
 Real temp_1[2];
equation
 ({temp_1[1], temp_1[2]}) = FunctionTests.ArrayOutputScalarization14.f();
 x = temp_1[1] * 3 + temp_1[2] * 4;

public
 function FunctionTests.ArrayOutputScalarization14.f
  output Real[2] x;
 algorithm
  x[1] := 1;
  x[2] := 2;
  return;
 end FunctionTests.ArrayOutputScalarization14.f;

end FunctionTests.ArrayOutputScalarization14;
")})));
end ArrayOutputScalarization14;


model ArrayOutputScalarization15
 function f
  output Real x[2] = {1,2};
  output Real y = 2;
 algorithm
 end f;
 
 Real x[2];
 Real y;
equation
 (x, y) = f();

	annotation(__JModelica(UnitTesting(tests={
		GenericCodeGenTestCase(
			name="ArrayOutputScalarization15",
			description="Scalarization of array function outputs: number of equations",
			variability_propagation=false,
			template="$n_equations$",
			generatedCode="3"
 )})));
end ArrayOutputScalarization15;


model ArrayOutputScalarization16
 function f1
  output Real o = 2;
  protected Real x[2] = {1,2};
  protected Real y[2];
 algorithm
  y := f2(x);
 end f1;
 
 function f2
  input Real x[2];
  output Real y[2] = x;
 algorithm
 end f2;
 
 Real x = f1();

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayOutputScalarization16",
			description="Scalarization of array function outputs: using original arrays",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.ArrayOutputScalarization16
 Real x;
equation
 x = FunctionTests.ArrayOutputScalarization16.f1();

public
 function FunctionTests.ArrayOutputScalarization16.f1
  output Real o;
  Real[2] x;
  Real[2] y;
 algorithm
  o := 2;
  x[1] := 1;
  x[2] := 2;
  (y) := FunctionTests.ArrayOutputScalarization16.f2(x);
  return;
 end FunctionTests.ArrayOutputScalarization16.f1;

 function FunctionTests.ArrayOutputScalarization16.f2
  input Real[2] x;
  output Real[2] y;
 algorithm
  y[1] := x[1];
  y[2] := x[2];
  return;
 end FunctionTests.ArrayOutputScalarization16.f2;

end FunctionTests.ArrayOutputScalarization16;
")})));
end ArrayOutputScalarization16;


model ArrayOutputScalarization17
 function f1
  output Real o = 2;
  protected Real y[2];
 algorithm
  y := f2(f2({1,2}));
 end f1;
 
 function f2
  input Real x[2];
  output Real y[2] = x;
 algorithm
 end f2;
 
 Real x = f1();

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayOutputScalarization17",
			description="Scalarization of array function outputs: using original arrays",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.ArrayOutputScalarization17
 Real x;
equation
 x = FunctionTests.ArrayOutputScalarization17.f1();

public
 function FunctionTests.ArrayOutputScalarization17.f1
  output Real o;
  Real[2] y;
  Real[2] temp_1;
 algorithm
  o := 2;
  (temp_1) := FunctionTests.ArrayOutputScalarization17.f2({1, 2});
  (y) := FunctionTests.ArrayOutputScalarization17.f2(temp_1);
  return;
 end FunctionTests.ArrayOutputScalarization17.f1;

 function FunctionTests.ArrayOutputScalarization17.f2
  input Real[2] x;
  output Real[2] y;
 algorithm
  y[1] := x[1];
  y[2] := x[2];
  return;
 end FunctionTests.ArrayOutputScalarization17.f2;

end FunctionTests.ArrayOutputScalarization17;
			
")})));
end ArrayOutputScalarization17;


model ArrayOutputScalarization18
    function f1
        input Real[:] a1;
        output Real x1;
    protected
        Real[:] b1 = f2(a1);
    algorithm
        x1 := a1 * b1;
    end f1;
    
    function f2
        input Real[:] a2;
        output Real[size(a2, 1)] x2 = 2 * a2;
    algorithm
    end f2;
    
    Real x = f1({ 1, 2 });

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayOutputScalarization18",
			description="Scalarization of binding expression of unknown size for protected var in func",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.ArrayOutputScalarization18
 Real x;
equation
 x = FunctionTests.ArrayOutputScalarization18.f1({1, 2});

public
 function FunctionTests.ArrayOutputScalarization18.f2
  input Real[:] a2;
  output Real[size(a2, 1)] x2;
 algorithm
  for i1 in 1:size(a2, 1) loop
   x2[i1] := 2 * a2[i1];
  end for;
  return;
 end FunctionTests.ArrayOutputScalarization18.f2;

 function FunctionTests.ArrayOutputScalarization18.f1
  input Real[:] a1;
  output Real x1;
  Real[:] b1;
  Real temp_1;
  Real temp_2;
 algorithm
  size(b1) := {size(a1, 1)};
  (b1) := FunctionTests.ArrayOutputScalarization18.f2(a1);
  temp_2 := 0.0;
  for i1 in 1:size(a1, 1) loop
   temp_2 := temp_2 + a1[i1] * b1[i1];
  end for;
  temp_1 := temp_2;
  x1 := temp_1;
  return;
 end FunctionTests.ArrayOutputScalarization18.f1;

end FunctionTests.ArrayOutputScalarization18;
			
")})));
end ArrayOutputScalarization18;


model ArrayOutputScalarization19
    function f1
        input Real[:] a1;
        output Real x1;
    protected
        Real[2] b1 = f2(a1);
    algorithm
        x1 := sum(b1);
    end f1;
    
    function f2
        input Real[:] a2;
        output Real[size(a2, 1)] x2 = 2 * a2;
    algorithm
    end f2;
    
    Real x = f1({ 1, 2 });

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayOutputScalarization19",
			description="Scalarization of binding expression of unknown size for protected var in func",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.ArrayOutputScalarization19
 Real x;
equation
 x = FunctionTests.ArrayOutputScalarization19.f1({1, 2});

public
 function FunctionTests.ArrayOutputScalarization19.f2
  input Real[:] a2;
  output Real[size(a2, 1)] x2;
 algorithm
  for i1 in 1:size(a2, 1) loop
   x2[i1] := 2 * a2[i1];
  end for;
  return;
 end FunctionTests.ArrayOutputScalarization19.f2;

 function FunctionTests.ArrayOutputScalarization19.f1
  input Real[:] a1;
  output Real x1;
  Real[2] b1;
 algorithm
  assert(size(a1, 1) == 2, \"Mismatching sizes in FunctionTests.ArrayOutputScalarization19.f1\");
  (b1) := FunctionTests.ArrayOutputScalarization19.f2(a1);
  x1 := b1[1] + b1[2];
  return;
 end FunctionTests.ArrayOutputScalarization19.f1;

end FunctionTests.ArrayOutputScalarization19;
")})));
end ArrayOutputScalarization19;


model ArrayOutputScalarization20
	record R
		Real a;
		Real b[2];		
	end R;
	
    function f1
        input Real c;
        output R d;
    algorithm
        d := f2(c);
    end f1;
    
    function f2
        input Real e;
        output R f;
    algorithm
        f := R(e, {1,2});
    end f2;
    
    R x = f1(1);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayOutputScalarization20",
			description="Checks for bug in #1895",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.ArrayOutputScalarization20
 Real x.a;
 Real x.b[1];
 Real x.b[2];
equation
 (FunctionTests.ArrayOutputScalarization20.R(x.a, {x.b[1], x.b[2]})) = FunctionTests.ArrayOutputScalarization20.f1(1);

public
 function FunctionTests.ArrayOutputScalarization20.f1
  input Real c;
  output FunctionTests.ArrayOutputScalarization20.R d;
 algorithm
  (d) := FunctionTests.ArrayOutputScalarization20.f2(c);
  return;
 end FunctionTests.ArrayOutputScalarization20.f1;

 function FunctionTests.ArrayOutputScalarization20.f2
  input Real e;
  output FunctionTests.ArrayOutputScalarization20.R f;
 algorithm
  f.a := e;
  f.b[1] := 1;
  f.b[2] := 2;
  return;
 end FunctionTests.ArrayOutputScalarization20.f2;

 record FunctionTests.ArrayOutputScalarization20.R
  Real a;
  Real b[2];
 end FunctionTests.ArrayOutputScalarization20.R;

end FunctionTests.ArrayOutputScalarization20;
")})));
end ArrayOutputScalarization20;


model ArrayOutputScalarization21
	record R
		Real x[2,2];
	end R;
	
	function f
		input Real x;
		output R y;
	algorithm
		y := R({{x, 2* x},{3 * x, 4 * x}});
	end f;
	
	R z = f(time);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayOutputScalarization21",
			description="Scalarization of matrix in record as output of function",
			inline_functions="none",
			flatModel="
fclass FunctionTests.ArrayOutputScalarization21
 Real z.x[1,1];
 Real z.x[1,2];
 Real z.x[2,1];
 Real z.x[2,2];
equation
 (FunctionTests.ArrayOutputScalarization21.R({{z.x[1,1], z.x[1,2]}, {z.x[2,1], z.x[2,2]}})) = FunctionTests.ArrayOutputScalarization21.f(time);

public
 function FunctionTests.ArrayOutputScalarization21.f
  input Real x;
  output FunctionTests.ArrayOutputScalarization21.R y;
 algorithm
  y.x[1,1] := x;
  y.x[1,2] := 2 * x;
  y.x[2,1] := 3 * x;
  y.x[2,2] := 4 * x;
  return;
 end FunctionTests.ArrayOutputScalarization21.f;

 record FunctionTests.ArrayOutputScalarization21.R
  Real x[2,2];
 end FunctionTests.ArrayOutputScalarization21.R;

end FunctionTests.ArrayOutputScalarization21;
")})));
end ArrayOutputScalarization21;


model ArrayOutputScalarization22
    function f
        input Real a;
        output Real[2] b;
    algorithm
        b := { a, a*a };
    end f;
    
    parameter Integer n = 3;
    Real[n,2] c = { f(i) for i in 1:n };

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayOutputScalarization22",
			description="Iteration expression with function call",
			inline_functions="none",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.ArrayOutputScalarization22
 parameter Integer n = 3 /* 3 */;
 Real c[1,1];
 Real c[1,2];
 Real c[2,1];
 Real c[2,2];
 Real c[3,1];
 Real c[3,2];
equation
 ({c[1,1], c[1,2]}) = FunctionTests.ArrayOutputScalarization22.f(1);
 ({c[2,1], c[2,2]}) = FunctionTests.ArrayOutputScalarization22.f(2);
 ({c[3,1], c[3,2]}) = FunctionTests.ArrayOutputScalarization22.f(3);

public
 function FunctionTests.ArrayOutputScalarization22.f
  input Real a;
  output Real[2] b;
 algorithm
  b[1] := a;
  b[2] := a * a;
  return;
 end FunctionTests.ArrayOutputScalarization22.f;

end FunctionTests.ArrayOutputScalarization22;
")})));
end ArrayOutputScalarization22;


model ArrayOutputScalarization23
    function f
        input Real a;
        output Real[2] b;
    algorithm
        b := { a, a*a };
    end f;
    
    parameter Integer n = 3;
    Real[n,2] c;
equation
	for i in 1:n loop
		c[i,:] = f(i);
	end for;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayOutputScalarization23",
			description="Function returning array in for loop",
			inline_functions="none",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.ArrayOutputScalarization23
 parameter Integer n = 3 /* 3 */;
 Real c[1,1];
 Real c[1,2];
 Real c[2,1];
 Real c[2,2];
 Real c[3,1];
 Real c[3,2];
equation
 ({c[1,1], c[1,2]}) = FunctionTests.ArrayOutputScalarization23.f(1);
 ({c[2,1], c[2,2]}) = FunctionTests.ArrayOutputScalarization23.f(2);
 ({c[3,1], c[3,2]}) = FunctionTests.ArrayOutputScalarization23.f(3);

public
 function FunctionTests.ArrayOutputScalarization23.f
  input Real a;
  output Real[2] b;
 algorithm
  b[1] := a;
  b[2] := a * a;
  return;
 end FunctionTests.ArrayOutputScalarization23.f;

end FunctionTests.ArrayOutputScalarization23;
")})));
end ArrayOutputScalarization23;


model ArrayOutputScalarization24
    function f
        input Real a;
        output Real[2] b;
    algorithm
        b := { a, a*a };
    end f;
        
    Real x(start = 1);
    Real y;
    Real z[2];
initial equation
    y = x / 2;
    z = x .+ f(y);
equation
    der(x) = z[1];
    der(y) = z[2];
    der(z) = { -x, -y };

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayOutputScalarization24",
			description="Scalarize use of function returning array in initial equations",
			flatModel="
fclass FunctionTests.ArrayOutputScalarization24
 Real x(start = 1);
 Real y;
 Real z[1];
 Real z[2];
 parameter Real temp_1[1](fixed = false);
 parameter Real temp_1[2](fixed = false);
initial equation 
 y = x / 2;
 ({temp_1[1], temp_1[2]}) = FunctionTests.ArrayOutputScalarization24.f(y);
 z[1] = x .+ temp_1[1];
 z[2] = x .+ temp_1[2];
 x = 1;
equation
 der(x) = z[1];
 der(y) = z[2];
 der(z[1]) = - x;
 der(z[2]) = - y;

public
 function FunctionTests.ArrayOutputScalarization24.f
  input Real a;
  output Real[2] b;
 algorithm
  b[1] := a;
  b[2] := a * a;
  return;
 end FunctionTests.ArrayOutputScalarization24.f;

end FunctionTests.ArrayOutputScalarization24;
")})));
end ArrayOutputScalarization24;

model ArrayOutputScalarization25
	record R
		Real[2] x;
		Real[2] y;
	end R;

function f
	input R[2] i;
	output R[2] o;
algorithm
	o := i;
end f;

function fwrap
	input R[2] i;
	output R[2] o;
	output Real dummy;
algorithm
	o := f(i);
	dummy := 1;
end fwrap;

	R[2] a;
algorithm
	a := fwrap({R({1,1},{1,1}),R({1,1},{1,1})});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayOutputScalarization25",
			description="Scalarize function call statements.",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.ArrayOutputScalarization25
 Real a[1].x[1];
 Real a[1].x[2];
 Real a[1].y[1];
 Real a[1].y[2];
 Real a[2].x[1];
 Real a[2].x[2];
 Real a[2].y[1];
 Real a[2].y[2];
 Real temp_1[1].x[1];
 Real temp_1[1].x[2];
 Real temp_1[1].y[1];
 Real temp_1[1].y[2];
 Real temp_1[2].x[1];
 Real temp_1[2].x[2];
 Real temp_1[2].y[1];
 Real temp_1[2].y[2];
algorithm
 ({FunctionTests.ArrayOutputScalarization25.R({temp_1[1].x[1], temp_1[1].x[2]}, {temp_1[1].y[1], temp_1[1].y[2]}), FunctionTests.ArrayOutputScalarization25.R({temp_1[2].x[1], temp_1[2].x[2]}, {temp_1[2].y[1], temp_1[2].y[2]})}) := FunctionTests.ArrayOutputScalarization25.fwrap({FunctionTests.ArrayOutputScalarization25.R({1, 1}, {1, 1}), FunctionTests.ArrayOutputScalarization25.R({1, 1}, {1, 1})});
 a[1].x[1] := temp_1[1].x[1];
 a[1].x[2] := temp_1[1].x[2];
 a[1].y[1] := temp_1[1].y[1];
 a[1].y[2] := temp_1[1].y[2];
 a[2].x[1] := temp_1[2].x[1];
 a[2].x[2] := temp_1[2].x[2];
 a[2].y[1] := temp_1[2].y[1];
 a[2].y[2] := temp_1[2].y[2];

public
 function FunctionTests.ArrayOutputScalarization25.fwrap
  input FunctionTests.ArrayOutputScalarization25.R[2] i;
  output FunctionTests.ArrayOutputScalarization25.R[2] o;
  output Real dummy;
 algorithm
  (o) := FunctionTests.ArrayOutputScalarization25.f(i);
  dummy := 1;
  return;
 end FunctionTests.ArrayOutputScalarization25.fwrap;

 function FunctionTests.ArrayOutputScalarization25.f
  input FunctionTests.ArrayOutputScalarization25.R[2] i;
  output FunctionTests.ArrayOutputScalarization25.R[2] o;
 algorithm
  o[1].x[1] := i[1].x[1];
  o[1].x[2] := i[1].x[2];
  o[1].y[1] := i[1].y[1];
  o[1].y[2] := i[1].y[2];
  o[2].x[1] := i[2].x[1];
  o[2].x[2] := i[2].x[2];
  o[2].y[1] := i[2].y[1];
  o[2].y[2] := i[2].y[2];
  return;
 end FunctionTests.ArrayOutputScalarization25.f;

 record FunctionTests.ArrayOutputScalarization25.R
  Real x[2];
  Real y[2];
 end FunctionTests.ArrayOutputScalarization25.R;

end FunctionTests.ArrayOutputScalarization25;

")})));
end ArrayOutputScalarization25;

model ArrayOutputScalarization26
record R
	Real x;
end R;

function f
	input Real[2] i;
	output R[2] o;
	output Real d = 1;
algorithm
	o := {R(i[1]),R(i[2])};
end f;

R[4] x;
Real[4] y = {1,2,3,4};
algorithm
	(x[{4,2}],) := f(y[{4,2}]);
	(x[{1,3}],) := f(y[{1,3}]);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayOutputScalarization26",
			description="Slices of records in function call statements.",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.ArrayOutputScalarization26
 Real x[1].x;
 Real x[2].x;
 Real x[3].x;
 Real x[4].x;
 Real y[1];
 Real y[2];
 Real y[3];
 Real y[4];
algorithm
 ({FunctionTests.ArrayOutputScalarization26.R(x[4].x), FunctionTests.ArrayOutputScalarization26.R(x[2].x)}, ) := FunctionTests.ArrayOutputScalarization26.f({y[4], y[2]});
 ({FunctionTests.ArrayOutputScalarization26.R(x[1].x), FunctionTests.ArrayOutputScalarization26.R(x[3].x)}, ) := FunctionTests.ArrayOutputScalarization26.f({y[1], y[3]});
equation
 y[1] = 1;
 y[2] = 2;
 y[3] = 3;
 y[4] = 4;

public
 function FunctionTests.ArrayOutputScalarization26.f
  input Real[2] i;
  output FunctionTests.ArrayOutputScalarization26.R[2] o;
  output Real d;
algorithm
  d := 1;
  o[1].x := i[1];
  o[2].x := i[2];
  return;
 end FunctionTests.ArrayOutputScalarization26.f;

 record FunctionTests.ArrayOutputScalarization26.R
  Real x;
 end FunctionTests.ArrayOutputScalarization26.R;

end FunctionTests.ArrayOutputScalarization26;

")})));
end ArrayOutputScalarization26;


model ArrayOutputScalarization27
    function f1
        input Real c;
        output Real d[2];
    algorithm
        d := {1,2} * c;
        d[1] := d[1] + 0.1;
    end f1;
        
    function f2
        input Real c;
        output Real d[2];
    algorithm
        d := {2,3} * c;
        d[1] := d[1] + 0.1;
    end f2;
        
    parameter Boolean a = false annotation(Evaluate=true);
    Real b[2] = if a then f1(time) else f2(time);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayOutputScalarization27",
			description="Function with array output in if exp",
			flatModel="
fclass FunctionTests.ArrayOutputScalarization27
 parameter Boolean a = false /* false */;
 Real b[1];
 Real b[2];
equation
 ({b[1], b[2]}) = FunctionTests.ArrayOutputScalarization27.f2(time);

public
 function FunctionTests.ArrayOutputScalarization27.f2
  input Real c;
  output Real[2] d;
 algorithm
  d[1] := 2 * c;
  d[2] := 3 * c;
  d[1] := d[1] + 0.1;
  return;
 end FunctionTests.ArrayOutputScalarization27.f2;

end FunctionTests.ArrayOutputScalarization27;
")})));
end ArrayOutputScalarization27;


/* ======================= Unknown array sizes ======================*/

model UnknownArray1
 function f
  input Real a[:];
  output Real b[size(a,1)];
 algorithm
  b := a;
 end f;
 
 Real x[3] = f({1,2,3});
 Real y[2] = f({4,5});

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="UnknownArray1",
			description="Using functions with unknown array sizes: basic type test",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.UnknownArray1
 Real x[3] = FunctionTests.UnknownArray1.f({1,2,3});
 Real y[2] = FunctionTests.UnknownArray1.f({4,5});

public
 function FunctionTests.UnknownArray1.f
  input Real[:] a;
  output Real[size(a, 1)] b;
 algorithm
  b := a;
  return;
 end FunctionTests.UnknownArray1.f;

end FunctionTests.UnknownArray1;
")})));
end UnknownArray1;


model UnknownArray2
 function f
  input Real a[:];
  output Real b[:] = a;
 algorithm
 end f;
 
 Real x[3] = f({1,2,3});
 Real y[2] = f({4,5});

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="UnknownArray2",
			description="Using functions with unknown array sizes: size from binding exp",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.UnknownArray2
 Real x[3] = FunctionTests.UnknownArray2.f({1,2,3});
 Real y[2] = FunctionTests.UnknownArray2.f({4,5});

public
 function FunctionTests.UnknownArray2.f
  input Real[:] a;
  output Real[size(a, 1)] b := a;
 algorithm
  return;
 end FunctionTests.UnknownArray2.f;

end FunctionTests.UnknownArray2;
")})));
end UnknownArray2;


model UnknownArray3
 function f
  input Real a[:];
  output Real b[size(c,1)];
  protected Real c[size(a,1)];
 algorithm
  b := a;
 end f;
 
 Real x[3] = f({1,2,3});
 Real y[2] = f({4,5});

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="UnknownArray3",
			description="Using functions with unknown array sizes: indirect dependency",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.UnknownArray3
 Real x[3] = FunctionTests.UnknownArray3.f({1,2,3});
 Real y[2] = FunctionTests.UnknownArray3.f({4,5});

public
 function FunctionTests.UnknownArray3.f
  input Real[:] a;
  output Real[size(c, 1)] b;
  Real[size(a, 1)] c;
 algorithm
  b := a;
  return;
 end FunctionTests.UnknownArray3.f;

end FunctionTests.UnknownArray3;
")})));
end UnknownArray3;


model UnknownArray4
 function f
  input Real a[:];
  output Real b[:] = c;
  protected Real c[:] = a;
 algorithm
 end f;
 
 Real x[3] = f({1,2,3});
 Real y[2] = f({4,5});

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="UnknownArray4",
			description="Using functions with unknown array sizes: indirect dependency from binding exp",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.UnknownArray4
 Real x[3] = FunctionTests.UnknownArray4.f({1,2,3});
 Real y[2] = FunctionTests.UnknownArray4.f({4,5});

public
 function FunctionTests.UnknownArray4.f
  input Real[:] a;
  output Real[size(a, 1)] b := c;
  Real[size(a, 1)] c := a;
 algorithm
  return;
 end FunctionTests.UnknownArray4.f;

end FunctionTests.UnknownArray4;
")})));
end UnknownArray4;


model UnknownArray5
 function f
  input Real a[:];
  output Real b[:] = c;
  output Real c[:] = a;
 algorithm
 end f;
 
 Real x[3];
 Real y[3];
equation
 (x, y) = f({1,2,3});

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="UnknownArray5",
			description="Using functions with unknown array sizes: multiple outputs",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.UnknownArray5
 Real x[3];
 Real y[3];
equation
 (x[1:3], y[1:3]) = FunctionTests.UnknownArray5.f({1,2,3});

public
 function FunctionTests.UnknownArray5.f
  input Real[:] a;
  output Real[size(a, 1)] b := c;
  output Real[size(a, 1)] c := a;
 algorithm
  return;
 end FunctionTests.UnknownArray5.f;

end FunctionTests.UnknownArray5;
")})));
end UnknownArray5;


model UnknownArray6
 function f
  input Real a[:];
  output Real b[:] = c;
  output Real c[:] = a;
 algorithm
 end f;
 
 Real x[2] = f({1,2,3});

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="UnknownArray6",
			description="Using functions with unknown array sizes: wrong size",
			variability_propagation=false,
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/FunctionTests.mo':
Semantic error at line 3747, column 7:
  Array size mismatch in declaration of x, size of declaration is [2] and size of binding expression is [3]
")})));
end UnknownArray6;


model UnknownArray7
 function f
  input Real a[:];
  output Real b[:] = c;
  output Real c[:] = a;
 algorithm
 end f;
 
 Real x[3];
 Real y[2];
equation
 (x, y) = f({1,2,3});

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="UnknownArray7",
			description="Using functions with unknown array sizes: wrong size",
			variability_propagation=false,
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/FunctionTests.mo':
Semantic error at line 3773, column 2:
  Calling function f(): array sizes of component y and output c are not compatible
")})));
end UnknownArray7;


model UnknownArray8
 function f
  input Real a[:];
  output Real b[size(b,1)];
 algorithm
  b := {1,2};
 end f;
 
 Real x[2] = f({1,2,3});

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="UnknownArray8",
			description="Using functions with unknown array sizes: circular size",
			variability_propagation=false,
			errorMessage="
2 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/FunctionTests.mo':
Semantic error at line 3796, column 7:
  Array size mismatch in declaration of x, size of declaration is [2] and size of binding expression is [size(b, 1)]
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/FunctionTests.mo':
Semantic error at line 3796, column 14:
  Could not evaluate array size of output b
")})));
end UnknownArray8;


model UnknownArray9
 function f
  input Real a[:,:];
  input Real b[:,size(a,2)];
  output Real c[size(d,1), size(d,2)];
 protected Real d[:,:] = cat(1, a, b);
 protected Real e[:,:] = [a; b];
 algorithm
  c := d;
 end f;
 
 Real x[5,2] = f({{1,2},{3,4}}, {{5,6},{7,8},{9,0}});

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="UnknownArray9",
			description="Unknown size calculated by adding sizes",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.UnknownArray9
 Real x[5,2] = FunctionTests.UnknownArray9.f({{1, 2}, {3, 4}}, {{5, 6}, {7, 8}, {9, 0}});

public
 function FunctionTests.UnknownArray9.f
  input Real[:, :] a;
  input Real[:, size(a, 2)] b;
  output Real[size(d, 1), size(d, 2)] c;
  Real[size(a, 1) + size(b, 1), size(a, 2)] d := cat(1, a, b);
  Real[size(a, 1) + size(b, 1), size(a, 2)] e := [a; b];
 algorithm
  c := d;
  return;
 end FunctionTests.UnknownArray9.f;

end FunctionTests.UnknownArray9;
")})));
end UnknownArray9;


model UnknownArray10
 function f
  input Real a[:];
  output Real b[size(a,1)];
 algorithm
  b := a;
 end f;
 
 Real x[2] = f({1,2});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="UnknownArray10",
			description="Scalarization of operations on arrays of unknown size: assignment",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.UnknownArray10
 Real x[1];
 Real x[2];
equation
 ({x[1], x[2]}) = FunctionTests.UnknownArray10.f({1,2});

public
 function FunctionTests.UnknownArray10.f
  input Real[:] a;
  output Real[size(a, 1)] b;
 algorithm
  for i1 in 1:size(a, 1) loop
   b[i1] := a[i1];
  end for;
  return;
 end FunctionTests.UnknownArray10.f;

end FunctionTests.UnknownArray10;
")})));
end UnknownArray10;


model UnknownArray11
 function f
  input Real a[:];
  output Real b[size(a,1)] = a;
 algorithm
 end f;
 
 Real x[2] = f({1,2});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="UnknownArray11",
			description="Scalarization of operations on arrays of unknown size: binding expression",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.UnknownArray11
 Real x[1];
 Real x[2];
equation
 ({x[1], x[2]}) = FunctionTests.UnknownArray11.f({1,2});

public
 function FunctionTests.UnknownArray11.f
  input Real[:] a;
  output Real[size(a, 1)] b;
 algorithm
  for i1 in 1:size(a, 1) loop
   b[i1] := a[i1];
  end for;
  return;
 end FunctionTests.UnknownArray11.f;

end FunctionTests.UnknownArray11;
")})));
end UnknownArray11;


model UnknownArray12
 function f
  input Real a[:];
  input Real b[:];
  input Real c;
  output Real o[size(a,1)];
 algorithm
  o := c * a + 2 * b;
 end f;
 
 Real x[2] = f({1,2}, {3,4}, 5);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="UnknownArray12",
			description="Scalarization of operations on arrays of unknown size: element-wise expression",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.UnknownArray12
 Real x[1];
 Real x[2];
equation
 ({x[1], x[2]}) = FunctionTests.UnknownArray12.f({1, 2}, {3, 4}, 5);

public
 function FunctionTests.UnknownArray12.f
  input Real[:] a;
  input Real[:] b;
  input Real c;
  output Real[size(a, 1)] o;
 algorithm
  for i1 in 1:size(a, 1) loop
   o[i1] := c * a[i1] + 2 * b[i1];
  end for;
  return;
 end FunctionTests.UnknownArray12.f;

end FunctionTests.UnknownArray12;
")})));
end UnknownArray12;


model UnknownArray13
 function f
  input Real a[:];
  input Real b[:];
  input Real c;
  output Real o[size(a,1)] = c * a + 2 * b;
 algorithm
 end f;
 
 Real x[2] = f({1,2}, {3,4}, 5);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="UnknownArray13",
			description="Scalarization of operations on arrays of unknown size: element-wise binding expression",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.UnknownArray13
 Real x[1];
 Real x[2];
equation
 ({x[1], x[2]}) = FunctionTests.UnknownArray13.f({1, 2}, {3, 4}, 5);

public
 function FunctionTests.UnknownArray13.f
  input Real[:] a;
  input Real[:] b;
  input Real c;
  output Real[size(a, 1)] o;
 algorithm
  for i1 in 1:size(a, 1) loop
   o[i1] := c * a[i1] + 2 * b[i1];
  end for;
  return;
 end FunctionTests.UnknownArray13.f;

end FunctionTests.UnknownArray13;
")})));
end UnknownArray13;


model UnknownArray14
 function f
  input Real a[:,:];
  input Real b[size(a,2),:];
  output Real o[size(a,1),size(b,2)] = a * b;
 algorithm
 end f;
 
 Real x[2,2] = f({{1,2},{3,4}}, {{5,6},{7,8}});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="UnknownArray14",
			description="Scalarization of operations on arrays of unknown size: matrix multiplication",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.UnknownArray14
 Real x[1,1];
 Real x[1,2];
 Real x[2,1];
 Real x[2,2];
equation
 ({{x[1,1], x[1,2]}, {x[2,1], x[2,2]}}) = FunctionTests.UnknownArray14.f({{1, 2}, {3, 4}}, {{5, 6}, {7, 8}});

public
 function FunctionTests.UnknownArray14.f
  input Real[:, :] a;
  input Real[size(a, 2), :] b;
  output Real[size(a, 1), size(b, 2)] o;
  Real[:,:] temp_1;
  Real temp_2;
 algorithm
  size(temp_1) := {size(a, 1), size(b, 2)};
  for i3 in 1:size(a, 1) loop
   for i4 in 1:size(b, 2) loop
    temp_2 := 0.0;
    for i5 in 1:size(a, 2) loop
     temp_2 := temp_2 + a[i3,i5] * b[i5,i4];
    end for;
    temp_1[i3,i4] := temp_2;
   end for;
  end for;
  for i1 in 1:size(a, 1) loop
   for i2 in 1:size(b, 2) loop
    o[i1,i2] := temp_1[i1,i2];
   end for;
  end for;
  return;
 end FunctionTests.UnknownArray14.f;

end FunctionTests.UnknownArray14;
			
")})));
end UnknownArray14;


model UnknownArray15
 function f
  input Real a[:];
  input Real b[size(a,1)];
  output Real o = a * b;
 algorithm
 end f;
 
 Real x = f({1,2}, {3,4});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="UnknownArray15",
			description="Scalarization of operations on arrays of unknown size: vector multiplication",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.UnknownArray15
 Real x;
equation
 x = FunctionTests.UnknownArray15.f({1, 2}, {3, 4});

public
 function FunctionTests.UnknownArray15.f
  input Real[:] a;
  input Real[size(a, 1)] b;
  output Real o;
  Real temp_1;
  Real temp_2;
 algorithm
  temp_2 := 0.0;
  for i1 in 1:size(a, 1) loop
   temp_2 := temp_2 + a[i1] * b[i1];
  end for;
  temp_1 := temp_2;
  o := temp_1;
  return;
 end FunctionTests.UnknownArray15.f;

end FunctionTests.UnknownArray15;
			
")})));
end UnknownArray15;


model UnknownArray16
 function f
  input Real a[:];
  input Real b[size(a,1)];
  output Real o = 1;
 algorithm
  if a * b < 4 then
   o := 2;
  end if;
 end f;
 
 Real x = f({1,2}, {3,4});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="UnknownArray16",
			description="Scalarization of operations on arrays of unknown size: outside assignment",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.UnknownArray16
 Real x;
equation
 x = FunctionTests.UnknownArray16.f({1, 2}, {3, 4});

public
 function FunctionTests.UnknownArray16.f
  input Real[:] a;
  input Real[size(a, 1)] b;
  output Real o;
  Real temp_1;
  Real temp_2;
 algorithm
  o := 1;
  temp_2 := 0.0;
  for i1 in 1:size(a, 1) loop
   temp_2 := temp_2 + a[i1] * b[i1];
  end for;
  temp_1 := temp_2;
  if temp_1 < 4 then
   o := 2;
  end if;
  return;
 end FunctionTests.UnknownArray16.f;

end FunctionTests.UnknownArray16;
			
")})));
end UnknownArray16;


model UnknownArray17
 function f
  input Real a[:,:];
  input Real b[size(a,2),:];
  input Real c[size(b,2),:];
  output Real[size(a, 1), size(c, 2)] o = a * b * c;
 algorithm
 end f;
 
 Real y[2,2] = {{1,2}, {3,4}};
 Real x[2,2] = f(y, y, y);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="UnknownArray17",
			description="Scalarization of operations on arrays of unknown size: nestled multiplications",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.UnknownArray17
 Real y[1,1];
 Real y[1,2];
 Real y[2,1];
 Real y[2,2];
 Real x[1,1];
 Real x[1,2];
 Real x[2,1];
 Real x[2,2];
equation
 y[1,1] = 1;
 y[1,2] = 2;
 y[2,1] = 3;
 y[2,2] = 4;
 ({{x[1,1], x[1,2]}, {x[2,1], x[2,2]}}) = FunctionTests.UnknownArray17.f({{y[1,1], y[1,2]}, {y[2,1], y[2,2]}}, {{y[1,1], y[1,2]}, {y[2,1], y[2,2]}}, {{y[1,1], y[1,2]}, {y[2,1], y[2,2]}});

public
 function FunctionTests.UnknownArray17.f
  input Real[:, :] a;
  input Real[size(a, 2), :] b;
  input Real[size(b, 2), :] c;
  output Real[size(a, 1), size(c, 2)] o;
  Real[:,:] temp_1;
  Real temp_2;
  Real[:,:] temp_3;
  Real temp_4;
 algorithm
  size(temp_1) := {size(a, 1), size(c, 2)};
  size(temp_3) := {size(a, 1), size(b, 2)};
  for i6 in 1:size(a, 1) loop
   for i7 in 1:size(b, 2) loop
    temp_4 := 0.0;
    for i8 in 1:size(a, 2) loop
     temp_4 := temp_4 + a[i6,i8] * b[i8,i7];
    end for;
    temp_3[i6,i7] := temp_4;
   end for;
  end for;
  for i3 in 1:size(a, 1) loop
   for i4 in 1:size(c, 2) loop
    temp_2 := 0.0;
    for i5 in 1:size(b, 2) loop
     temp_2 := temp_2 + temp_3[i3,i5] * c[i5,i4];
    end for;
    temp_1[i3,i4] := temp_2;
   end for;
  end for;
  for i1 in 1:size(a, 1) loop
   for i2 in 1:size(c, 2) loop
    o[i1,i2] := temp_1[i1,i2];
   end for;
  end for;
  return;
 end FunctionTests.UnknownArray17.f;

end FunctionTests.UnknownArray17;
			
")})));
end UnknownArray17;


model UnknownArray18
 function f
  input Real a[:];
  output Real o[size(a,1)];
 algorithm
  for i in 1:size(a,1) loop
   o[i] := a[i] + i;
  end for;
 end f;
 
  Real x[2] = f({1,2});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="UnknownArray18",
			description="Scalarization of operations on arrays of unknown size: already expressed as loop",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.UnknownArray18
 Real x[1];
 Real x[2];
equation
 ({x[1], x[2]}) = FunctionTests.UnknownArray18.f({1, 2});

public
 function FunctionTests.UnknownArray18.f
  input Real[:] a;
  output Real[size(a, 1)] o;
 algorithm
  for i in 1:size(a, 1) loop
   o[i] := a[i] + i;
  end for;
  return;
 end FunctionTests.UnknownArray18.f;

end FunctionTests.UnknownArray18;
")})));
end UnknownArray18;


model UnknownArray19
 function f
  input Real a[:,:];
  output Real[size(a, 1), size(b, 2)] c = a;
 algorithm
 end f;
 
 Real x[2,2] = f({{1,2}, {3,4}});

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="UnknownArray19",
			description="Function inputs of unknown size: using size() of non-existent component",
			variability_propagation=false,
			errorMessage="
3 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/FunctionTests.mo':
Semantic error at line 4429, column 32:
  Cannot find class or component declaration for b
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/FunctionTests.mo':
Semantic error at line 4433, column 7:
  Array size mismatch in declaration of x, size of declaration is [2, 2] and size of binding expression is [2, size(zeros(), 2)]
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/FunctionTests.mo':
Semantic error at line 4433, column 16:
  Could not evaluate array size of output c
")})));
end UnknownArray19;


model UnknownArray20
 function f
  input Real a[:,:];
  output Real[2] c;
 algorithm
  c[1] := a[1,1];
  c[end] := a[end,end];
 end f;
 
 Real x[2] = f({{1,2}, {3,4}});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="UnknownArray20",
			description="Function inputs of unknown size: scalarizing end",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.UnknownArray20
 Real x[1];
 Real x[2];
equation
 ({x[1],x[2]}) = FunctionTests.UnknownArray20.f({{1,2},{3,4}});

public
 function FunctionTests.UnknownArray20.f
  input Real[:, :] a;
  output Real[2] c;
 algorithm
  c[1] := a[1,1];
  c[2] := a[size(a, 1),size(a, 2)];
  return;
 end FunctionTests.UnknownArray20.f;

end FunctionTests.UnknownArray20;
")})));
end UnknownArray20;


model UnknownArray21
	function f
		input Real a[:];
		input Real b[:];
		output Real c = a * b;
	algorithm
	end f;
	
	Real x = f({1,2}, {3,4});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="UnknownArray21",
			description="Scalarizing multiplication between two inputs of unknown size",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.UnknownArray21
 Real x;
equation
 x = FunctionTests.UnknownArray21.f({1, 2}, {3, 4});

public
 function FunctionTests.UnknownArray21.f
  input Real[:] a;
  input Real[:] b;
  output Real c;
  Real temp_1;
  Real temp_2;
 algorithm
  temp_2 := 0.0;
  for i1 in 1:size(b, 1) loop
   temp_2 := temp_2 + a[i1] * b[i1];
  end for;
  temp_1 := temp_2;
  c := temp_1;
  return;
 end FunctionTests.UnknownArray21.f;

end FunctionTests.UnknownArray21;
			
")})));
end UnknownArray21;


model UnknownArray22
	function f
		input Real a[:] = {1, 2, 3};
		input Real b[:] = {4, 5, 6};
		output Real c = a * b;
	algorithm
	end f;
	
	Real x = f({1,2}, {3,4});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="UnknownArray22",
			description="Scalarizing multiplication between two inputs of unknown size, with defaults",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.UnknownArray22
 Real x;
equation
 x = FunctionTests.UnknownArray22.f({1, 2}, {3, 4});

public
 function FunctionTests.UnknownArray22.f
  input Real[:] a;
  input Real[:] b;
  output Real c;
  Real temp_1;
  Real temp_2;
 algorithm
  temp_2 := 0.0;
  for i1 in 1:size(b, 1) loop
   temp_2 := temp_2 + a[i1] * b[i1];
  end for;
  temp_1 := temp_2;
  c := temp_1;
  return;
 end FunctionTests.UnknownArray22.f;

end FunctionTests.UnknownArray22;
			
")})));
end UnknownArray22;


model UnknownArray23
	function f
		input Real a[:];
		output Real c = a * {1, 2, 3};
	algorithm
	end f;

	Real x = f({1,2,3});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="UnknownArray23",
			description="Using array constructors with inputs of unknown size",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.UnknownArray23
 Real x;
equation
 x = FunctionTests.UnknownArray23.f({1, 2, 3});

public
 function FunctionTests.UnknownArray23.f
  input Real[:] a;
  output Real c;
  Real temp_1;
  Real temp_2;
  Integer[3] temp_3;
 algorithm
  temp_3[1] := 1;
  temp_3[2] := 2;
  temp_3[3] := 3;
  temp_2 := 0.0;
  for i1 in 1:3 loop
   temp_2 := temp_2 + a[i1] * temp_3[i1];
  end for;
  temp_1 := temp_2;
  c := temp_1;
  return;
 end FunctionTests.UnknownArray23.f;

end FunctionTests.UnknownArray23;
			
")})));
end UnknownArray23;


model UnknownArray24
	function f
		input Real x[:,2];
		output Real y[size(x, 1), 2];
	algorithm
		y := x * {{1, 2}, {3, 4}};
	end f;

	Real x[3,2] = f({{5,6},{7,8},{9,0}});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="UnknownArray24",
			description="Using array constructors with inputs of unknown size",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.UnknownArray24
 Real x[1,1];
 Real x[1,2];
 Real x[2,1];
 Real x[2,2];
 Real x[3,1];
 Real x[3,2];
equation
 ({{x[1,1], x[1,2]}, {x[2,1], x[2,2]}, {x[3,1], x[3,2]}}) = FunctionTests.UnknownArray24.f({{5, 6}, {7, 8}, {9, 0}});

public
 function FunctionTests.UnknownArray24.f
  input Real[:, 2] x;
  output Real[size(x, 1), 2] y;
  Real[:,:] temp_1;
  Real temp_2;
  Integer[2, 2] temp_3;
 algorithm
  size(temp_1) := {size(x, 1), 2};
  temp_3[1,1] := 1;
  temp_3[1,2] := 2;
  temp_3[2,1] := 3;
  temp_3[2,2] := 4;
  for i3 in 1:size(x, 1) loop
   for i4 in 1:2 loop
    temp_2 := 0.0;
    for i5 in 1:2 loop
     temp_2 := temp_2 + x[i3,i5] * temp_3[i5,i4];
    end for;
    temp_1[i3,i4] := temp_2;
   end for;
  end for;
  for i1 in 1:size(x, 1) loop
   for i2 in 1:2 loop
    y[i1,i2] := temp_1[i1,i2];
   end for;
  end for;
  return;
 end FunctionTests.UnknownArray24.f;

end FunctionTests.UnknownArray24;
			
")})));
end UnknownArray24;


model UnknownArray25
    function f
        input Real[:] y;
        output Real x;
    algorithm
        x := sum(y);
    end f;
    
    Real x = f({1,2});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="UnknownArray25",
			description="Taking sum of array of unknown size",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.UnknownArray25
 Real x;
equation
 x = FunctionTests.UnknownArray25.f({1,2});

public
 function FunctionTests.UnknownArray25.f
  input Real[:] y;
  output Real x;
  Real temp_1;
 algorithm
  temp_1 := 0.0;
  for i1 in 1:size(y, 1) loop
   temp_1 := temp_1 + y[i1];
  end for;
  x := temp_1;
  return;
 end FunctionTests.UnknownArray25.f;

end FunctionTests.UnknownArray25;
")})));
end UnknownArray25;


model UnknownArray26
    function f
        input Real[:] y;
        output Real x;
    algorithm
        x := sum(y[i]*y[i] for i in 1:size(y,1));
    end f;
    
    Real x = f({1,2});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="UnknownArray26",
			description="Taking sum of iterator expression over array of unknown size",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.UnknownArray26
 Real x;
equation
 x = FunctionTests.UnknownArray26.f({1, 2});

public
 function FunctionTests.UnknownArray26.f
  input Real[:] y;
  output Real x;
  Real temp_1;
 algorithm
  temp_1 := 0.0;
  for i1 in 1:size(y, 1) loop
   temp_1 := temp_1 + y[i1] * y[i1];
  end for;
  x := temp_1;
  return;
 end FunctionTests.UnknownArray26.f;

end FunctionTests.UnknownArray26;
")})));
end UnknownArray26;


model UnknownArray27
    function f
        input Real[:] y;
        input Real[size(y,1), size(y,1)] z;
        output Real x;
    algorithm
        x := sum(y[i]*y[i]/(sum(y[j]*z[i,j] for j in 1:size(y,1))) for i in 1:size(y,1));
    end f;
    
    Real x = f({1,2}, {{1,2},{3,4}});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="UnknownArray27",
			description="Nestled sums over iterator expressions over arrays of unknown size",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.UnknownArray27
 Real x;
equation
 x = FunctionTests.UnknownArray27.f({1, 2}, {{1, 2}, {3, 4}});

public
 function FunctionTests.UnknownArray27.f
  input Real[:] y;
  input Real[size(y, 1), size(y, 1)] z;
  output Real x;
  Real temp_1;
  Real temp_2;
 algorithm
  temp_1 := 0.0;
  for i1 in 1:size(y, 1) loop
   temp_2 := 0.0;
   for i2 in 1:size(y, 1) loop
    temp_2 := temp_2 + y[i2] * z[i1,i2];
   end for;
   temp_1 := temp_1 + y[i1] * y[i1] / temp_2;
  end for;
  x := temp_1;
  return;
 end FunctionTests.UnknownArray27.f;

end FunctionTests.UnknownArray27;
")})));
end UnknownArray27;


// TODO: this gives wrong result
model UnknownArray28
    function f
        input Real[:] y;
        output Real x;
    algorithm
        x := sum(sum(j for j in 1:size({k for k in 1:i},1)) for i in 1:size(y,1));
    end f;
    
    Real x = f({1,2});
end UnknownArray28;


model UnknownArray29
    final constant Real a[:] = {1, 2, 3};
    
    function f1
		input Integer i;
        output Real y1;
    algorithm
      y1 := f2({a[i], a[i+1]});
    end f1;
    
    function f2
        input Real x2[:];
        output Real y2 = sum(x2);
    algorithm
    end f2;
    
    Real x = f1(1);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="UnknownArray29",
			description="Calling function from function with slice argument",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.UnknownArray29
 constant Real a[1] = 1;
 constant Real a[2] = 2;
 constant Real a[3] = 3;
 Real x;
equation
 x = FunctionTests.UnknownArray29.f1(1);

public
 function FunctionTests.UnknownArray29.f1
  Real[3] a;
  input Integer i;
  output Real y1;
 algorithm
  a[1] := 1;
  a[2] := 2;
  a[3] := 3;
  y1 := FunctionTests.UnknownArray29.f2({a[i], a[i + 1]});
  return;
 end FunctionTests.UnknownArray29.f1;

 function FunctionTests.UnknownArray29.f2
  input Real[:] x2;
  output Real y2;
  Real temp_1;
 algorithm
  temp_1 := 0.0;
  for i1 in 1:size(x2, 1) loop
   temp_1 := temp_1 + x2[i1];
  end for;
  y2 := temp_1;
  return;
 end FunctionTests.UnknownArray29.f2;

end FunctionTests.UnknownArray29;
")})));
end UnknownArray29;


model UnknownArray30
	function f
		input Real[:] a;
		output Real b;
	algorithm
		b := a * ones(size(a, 1)) + zeros(size(a, 1)) * fill(a[1], size(a, 1));
	end f;
	
	Real x = f({1,2,3});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="UnknownArray30",
			description="Fill type operators with unknown arguments in functions",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.UnknownArray30
 Real x;
equation
 x = FunctionTests.UnknownArray30.f({1, 2, 3});

public
 function FunctionTests.UnknownArray30.f
  input Real[:] a;
  output Real b;
  Real temp_1;
  Real temp_2;
  Real temp_3;
  Real temp_4;
 algorithm
  temp_2 := 0.0;
  for i1 in 1:size(a, 1) loop
   temp_2 := temp_2 + a[i1];
  end for;
  temp_1 := temp_2;
  temp_4 := 0.0;
  for i2 in 1:size(a, 1) loop
   temp_4 := temp_4;
  end for;
  temp_3 := temp_4;
  b := temp_1 + temp_3;
  return;
 end FunctionTests.UnknownArray30.f;

end FunctionTests.UnknownArray30;
			
")})));
end UnknownArray30;

model UnknownArray31
	function f1
		input Real[:] a;
		output Real[size(a,1)] b;
	algorithm
		b := 2 * a;
	end f1;
	
	function f2
		input Real[:] c;
		output Real[size(c,1)] d;
	algorithm
		d := f1(c);
	end f2;
	
	Real[2] x = f2({1,2});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="UnknownArray31",
			description="Assignstatement with right hand side function call.",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.UnknownArray31
 Real x[1];
 Real x[2];
equation
 ({x[1], x[2]}) = FunctionTests.UnknownArray31.f2({1, 2});

public
 function FunctionTests.UnknownArray31.f2
  input Real[:] c;
  output Real[size(c, 1)] d;
 algorithm
  (d) := FunctionTests.UnknownArray31.f1(c);
  return;
 end FunctionTests.UnknownArray31.f2;

 function FunctionTests.UnknownArray31.f1
  input Real[:] a;
  output Real[size(a, 1)] b;
 algorithm
  for i1 in 1:size(a, 1) loop
   b[i1] := 2 * a[i1];
  end for;
  return;
 end FunctionTests.UnknownArray31.f1;

end FunctionTests.UnknownArray31;
")})));
end UnknownArray31;

model UnknownArray32
    function f
        input Real[:] a;
        output Real b;
	protected
        Real[1,size(a,1)] c;
    algorithm
        c[1,:] := 2 * a;
		b := sum(c);
    end f;
    
    Real x = f({1,2});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="UnknownArray32",
			description="Check that size assignment for protected array with some dimensions known works",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.UnknownArray32
 Real x;
equation
 x = FunctionTests.UnknownArray32.f({1, 2});

public
 function FunctionTests.UnknownArray32.f
  input Real[:] a;
  output Real b;
  Real[:,:] c;
  Real temp_1;
 algorithm
  size(c) := {1, size(a, 1)};
  for i1 in 1:size(a, 1) loop
   c[1,i1] := 2 * a[i1];
  end for;
  temp_1 := 0.0;
  for i1 in 1:1 loop
   for i2 in 1:size(a, 1) loop
    temp_1 := temp_1 + c[i1,i2];
   end for;
  end for;
  b := temp_1;
  return;
 end FunctionTests.UnknownArray32.f;

end FunctionTests.UnknownArray32;
")})));
end UnknownArray32;

model UnknownArray33
	
  record R
    Real[2] x;
  end R;
	
    function f
        input Real[2] a;
        output Real b;
        output R c;
    algorithm
        b := a[1];
		c := R(f2(f2(a)));
    end f;
	
	function f2
		input Real[:] a;
		output Real[size(a,1)] b = a;
		algorithm
	end f2;
    
    Real x;
	R y;
equation
	(x,y) = f(f2(f2({time,time*2})));

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="UnknownArray33",
			description="Check extraction of function calls in function call equations",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.UnknownArray33
 Real x;
 Real y.x[1];
 Real y.x[2];
 Real temp_1[1];
 Real temp_1[2];
 Real temp_2[1];
 Real temp_2[2];
equation
 ({temp_1[1], temp_1[2]}) = FunctionTests.UnknownArray33.f2({time, time * 2});
 ({temp_2[1], temp_2[2]}) = FunctionTests.UnknownArray33.f2({temp_1[1], temp_1[2]});
 (x, FunctionTests.UnknownArray33.R({y.x[1], y.x[2]})) = FunctionTests.UnknownArray33.f({temp_2[1], temp_2[2]});

public
 function FunctionTests.UnknownArray33.f
  input Real[2] a;
  output Real b;
  output FunctionTests.UnknownArray33.R c;
  Real[2] temp_1;
  Real[2] temp_2;
 algorithm
  b := a[1];
  (temp_1) := FunctionTests.UnknownArray33.f2(a);
  (temp_2) := FunctionTests.UnknownArray33.f2(temp_1);
  c.x[1] := temp_2[1];
  c.x[2] := temp_2[2];
  return;
 end FunctionTests.UnknownArray33.f;

 function FunctionTests.UnknownArray33.f2
  input Real[:] a;
  output Real[size(a, 1)] b;
 algorithm
  for i1 in 1:size(a, 1) loop
   b[i1] := a[i1];
  end for;
  return;
 end FunctionTests.UnknownArray33.f2;

 record FunctionTests.UnknownArray33.R
  Real x[2];
 end FunctionTests.UnknownArray33.R;

end FunctionTests.UnknownArray33;
			
")})));
end UnknownArray33;

model UnknownArray34
    function f
		input Integer n;
        output Real b;
    protected
        Real[3] c;
        Real[n] d;
    algorithm
        d := {1,2,3};
        c := d;
        b := 1;
    end f;

    Real x = f(3);
	
	annotation(__JModelica(UnitTesting(tests={
				TransformCanonicalTestCase(
			name="UnknownArray34",
			description="Known to unknown size assignment",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.UnknownArray34
 Real x;
equation
 x = FunctionTests.UnknownArray34.f(3);

public
 function FunctionTests.UnknownArray34.f
  input Integer n;
  output Real b;
  Real[3] c;
  Real[:] d;
  Integer[3] temp_1;
 algorithm
  size(d) := {n};
  assert(n == 3, \"Mismatching sizes in FunctionTests.UnknownArray34.f\");
  temp_1[1] := 1;
  temp_1[2] := 2;
  temp_1[3] := 3;
  for i1 in 1:3 loop
   d[i1] := temp_1[i1];
  end for;
  assert(n == 3, \"Mismatching sizes in FunctionTests.UnknownArray34.f\");
  for i1 in 1:n loop
   c[i1] := d[i1];
  end for;
  b := 1;
  return;
 end FunctionTests.UnknownArray34.f;

end FunctionTests.UnknownArray34;
			
")})));
end UnknownArray34;

model UnknownArray35
    function f
		input Integer n;
		input Real[:] d;
        output Real b;
    protected
		Real[n,3] e;
    algorithm
		e := {d,d,d};
        b := 1;
    end f;

    Real x = f(3, {1,2,3});
	
	annotation(__JModelica(UnitTesting(tests={
				TransformCanonicalTestCase(
			name="UnknownArray35",
			description="Known to unknown size assignment",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.UnknownArray35
 Real x;
equation
 x = FunctionTests.UnknownArray35.f(3, {1, 2, 3});

public
 function FunctionTests.UnknownArray35.f
  input Integer n;
  input Real[:] d;
  output Real b;
  Real[:,:] e;
  Real[:,:] temp_1;
 algorithm
  size(e) := {n, 3};
  size(temp_1) := {3, size(d, 1)};
  assert(size(d, 1) == 3, \"Mismatching sizes in FunctionTests.UnknownArray35.f\");
  assert(n == 3, \"Mismatching sizes in FunctionTests.UnknownArray35.f\");
  for i4 in 1:size(d, 1) loop
   temp_1[1,i4] := d[i4];
  end for;
  for i4 in 1:size(d, 1) loop
   temp_1[2,i4] := d[i4];
  end for;
  for i4 in 1:size(d, 1) loop
   temp_1[3,i4] := d[i4];
  end for;
  for i1 in 1:3 loop
   for i2 in 1:size(d, 1) loop
    e[i1,i2] := temp_1[i1,i2];
   end for;
  end for;
  b := 1;
  return;
 end FunctionTests.UnknownArray35.f;

end FunctionTests.UnknownArray35;
			
")})));
end UnknownArray35;

model UnknownArray36
    function f2
		input Real[:] xin;
		input Real[2] yin;
		output Real[size(xin,1)] xout = yin;
		output Real[2] yout = xin;
		algorithm
	end f2;
	
    function f1
		input Integer n;
        output Real b;
    protected
        Real[2] c;
        Real[n] d;
    algorithm
        d[1:2] := {1,2};
        c := d;
		(c,d) := f2(c,d);
        b := 1;
    end f1;

    Real x = f1(2);
	
	annotation(__JModelica(UnitTesting(tests={
				TransformCanonicalTestCase(
			name="UnknownArray36",
			description="Known to unknown size assignment",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.UnknownArray36
 Real x;
equation
 x = FunctionTests.UnknownArray36.f1(2);

public
 function FunctionTests.UnknownArray36.f1
  input Integer n;
  output Real b;
  Real[2] c;
  Real[:] d;
 algorithm
  size(d) := {n};
  d[1] := 1;
  d[2] := 2;
  assert(n == 2, \"Mismatching sizes in FunctionTests.UnknownArray36.f1\");
  for i1 in 1:n loop
   c[i1] := d[i1];
  end for;
  assert(n == 2, \"Mismatching sizes in FunctionTests.UnknownArray36.f1\");
  (c, d) := FunctionTests.UnknownArray36.f2(c, d);
  b := 1;
  return;
 end FunctionTests.UnknownArray36.f1;

 function FunctionTests.UnknownArray36.f2
  input Real[:] xin;
  input Real[2] yin;
  output Real[size(xin, 1)] xout;
  output Real[2] yout;
 algorithm
  assert(size(xin, 1) == 2, \"Mismatching sizes in FunctionTests.UnknownArray36.f2\");
  for i1 in 1:2 loop
   xout[i1] := yin[i1];
  end for;
  assert(size(xin, 1) == 2, \"Mismatching sizes in FunctionTests.UnknownArray36.f2\");
  for i1 in 1:size(xin, 1) loop
   yout[i1] := xin[i1];
  end for;
  return;
 end FunctionTests.UnknownArray36.f2;

end FunctionTests.UnknownArray36;
			
")})));
end UnknownArray36;

model UnknownArray37
    function f2
		input Real[:,:] xin;
		input Real[2,:] yin;
		output Real[size(xin,1),size(xin,2)] xout = yin;
		output Real[2,2] yout = xin;
		algorithm
	end f2;
	
    function f1
		input Integer n;
		input Real[:,:] d;
        output Real b;
    protected
        Real[2,n] c;
    algorithm
        c := d;
		(c,d) := f2(c,d);
        b := 1;
    end f1;

    Real x = f1(2, {{1,2},{3,4}});
	
	annotation(__JModelica(UnitTesting(tests={
				TransformCanonicalTestCase(
			name="UnknownArray37",
			description="Known to unknown size assignment",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.UnknownArray37
 Real x;
equation
 x = FunctionTests.UnknownArray37.f1(2, {{1, 2}, {3, 4}});

public
 function FunctionTests.UnknownArray37.f1
  input Integer n;
  input Real[:, :] d;
  output Real b;
  Real[:,:] c;
 algorithm
  size(c) := {2, n};
  assert(size(d, 1) == 2, \"Mismatching sizes in FunctionTests.UnknownArray37.f1\");
  for i1 in 1:size(d, 1) loop
   for i2 in 1:size(d, 2) loop
    c[i1,i2] := d[i1,i2];
   end for;
  end for;
  assert(size(d, 1) == 2, \"Mismatching sizes in FunctionTests.UnknownArray37.f1\");
  assert(size(d, 2) == 2, \"Mismatching sizes in FunctionTests.UnknownArray37.f1\");
  (c, d) := FunctionTests.UnknownArray37.f2(c, d);
  b := 1;
  return;
 end FunctionTests.UnknownArray37.f1;

 function FunctionTests.UnknownArray37.f2
  input Real[:, :] xin;
  input Real[2, :] yin;
  output Real[size(xin, 1), size(xin, 2)] xout;
  output Real[2, 2] yout;
 algorithm
  assert(size(xin, 1) == 2, \"Mismatching sizes in FunctionTests.UnknownArray37.f2\");
  for i1 in 1:2 loop
   for i2 in 1:size(yin, 2) loop
    xout[i1,i2] := yin[i1,i2];
   end for;
  end for;
  assert(size(xin, 1) == 2, \"Mismatching sizes in FunctionTests.UnknownArray37.f2\");
  assert(size(xin, 2) == 2, \"Mismatching sizes in FunctionTests.UnknownArray37.f2\");
  for i1 in 1:size(xin, 1) loop
   for i2 in 1:size(xin, 2) loop
    yout[i1,i2] := xin[i1,i2];
   end for;
  end for;
  return;
 end FunctionTests.UnknownArray37.f2;

end FunctionTests.UnknownArray37;
			
")})));
end UnknownArray37;

model UnknownArray38
    function f
		input Integer n;
		input Real[:] d;
        output Real b;
    protected
		Real[n,3] e;
		Real[1,1] c;
    algorithm
		e := {d,d,d};
		c := [f(n,3 * e * 3 * {{1,2},{3,4},{5,6}})];
        b := 1;
    end f;

    Real x = f(3, {1,2,3});
	
	annotation(__JModelica(UnitTesting(tests={
				TransformCanonicalTestCase(
			name="UnknownArray38",
			description="Checks a more complex combination of known/unknown sizes",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.UnknownArray38
 Real x;
equation
 x = FunctionTests.UnknownArray38.f(3, {1, 2, 3});

public
 function FunctionTests.UnknownArray38.f
  input Integer n;
  input Real[:] d;
  output Real b;
  Real[:,:] e;
  Real[1, 1] c;
  Real[:,:] temp_1;
  Real[:,:] temp_2;
  Integer temp_3;
  Integer temp_4;
  Real[:] temp_5;
  Real[:,:] temp_6;
  Real temp_7;
  Integer[3, 2] temp_8;
 algorithm
  size(e) := {n, 3};
  size(temp_1) := {3, size(d, 1)};
  size(temp_2) := {n, 1};
  size(temp_5) := {n};
  size(temp_6) := {n, 2};
  assert(size(d, 1) == 3, \"Mismatching sizes in FunctionTests.UnknownArray38.f\");
  assert(n == 3, \"Mismatching sizes in FunctionTests.UnknownArray38.f\");
  for i4 in 1:size(d, 1) loop
   temp_1[1,i4] := d[i4];
  end for;
  for i4 in 1:size(d, 1) loop
   temp_1[2,i4] := d[i4];
  end for;
  for i4 in 1:size(d, 1) loop
   temp_1[3,i4] := d[i4];
  end for;
  for i1 in 1:3 loop
   for i2 in 1:size(d, 1) loop
    e[i1,i2] := temp_1[i1,i2];
   end for;
  end for;
  assert(n == 1, \"Mismatching sizes in FunctionTests.UnknownArray38.f\");
  temp_3 := 0;
  temp_4 := 0;
  temp_8[1,1] := 1;
  temp_8[1,2] := 2;
  temp_8[2,1] := 3;
  temp_8[2,2] := 4;
  temp_8[3,1] := 5;
  temp_8[3,2] := 6;
  for i1 in 1:n loop
   for i2 in 1:2 loop
    temp_7 := 0.0;
    for i3 in 1:3 loop
     temp_7 := temp_7 + 3 * e[i1,i3] * 3 * temp_8[i3,i2];
    end for;
    temp_6[i1,i2] := temp_7;
   end for;
  end for;
  (temp_5) := FunctionTests.UnknownArray38.f(n, temp_6);
  for i3 in 1:n loop
   temp_2[temp_3 + i3,temp_4 + 1] := temp_5[i3];
  end for;
  for i1 in 1:n loop
   for i2 in 1:1 loop
    c[i1,i2] := temp_2[i1,i2];
   end for;
  end for;
  b := 1;
  return;
 end FunctionTests.UnknownArray38.f;

end FunctionTests.UnknownArray38;
			
")})));
end UnknownArray38;

// TODO: need more complex cases
model IncompleteFunc1
 function f
  input Real x;
  output Real y = x;
 end f;
 
 Real x = f(2);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="IncompleteFunc1",
			description="Wrong contents of called function: neither algorithm nor external",
			variability_propagation=false,
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/FunctionTests.mo':
Semantic error at line 4251, column 11:
  Calling function f(): can only call functions that have one algorithm section or external function specification
")})));
end IncompleteFunc1;


model IncompleteFunc2
 function f
  input Real x;
  output Real y = x;
 algorithm
  y := y + 1;
 algorithm
  y := y + 1;
 end f;
 
 Real x = f(2);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="IncompleteFunc2",
			description="Wrong contents of called function: 2 algorithm",
			variability_propagation=false,
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/FunctionTests.mo':
Semantic error at line 4276, column 11:
  Calling function f(): can only call functions that have one algorithm section or external function specification
")})));
end IncompleteFunc2;


model IncompleteFunc3
 function f
  input Real x;
  output Real y = x;
 algorithm
  y := y + 1;
 external;
 end f;
 
 Real x = f(2);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="IncompleteFunc3",
			description="Wrong contents of called function: both algorithm and external",
			variability_propagation=false,
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/FunctionTests.mo':
Semantic error at line 4300, column 11:
  Calling function f(): can only call functions that have one algorithm section or external function specification
")})));
end IncompleteFunc3;



model ExternalFunc1
 function f
  input Real x;
  output Real y;
 external;
 end f;
 
 Real x = f(2);

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="ExternalFunc1",
			description="External functions: simple func, all default",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.ExternalFunc1
 Real x = FunctionTests.ExternalFunc1.f(2);

public
 function FunctionTests.ExternalFunc1.f
  input Real x;
  output Real y;
 algorithm
  external \"C\" y = f(x);
  return;
 end FunctionTests.ExternalFunc1.f;

end FunctionTests.ExternalFunc1;
")})));
end ExternalFunc1;


model ExternalFunc2
 function f
  input Real x[:,2];
  input Real y;
  output Real z;
  output Real q;
  protected Real a = y + 2;
 external;
 end f;
 
 Real x = f({{1,2},{3,4}}, 5);

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="ExternalFunc2",
			description="External functions: complex func, all default",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.ExternalFunc2
 Real x = FunctionTests.ExternalFunc2.f({{1,2},{3,4}}, 5);

public
 function FunctionTests.ExternalFunc2.f
  input Real[:, 2] x;
  input Real y;
  output Real z;
  output Real q;
  Real a := y + 2;
 algorithm
  external \"C\" f(x, size(x, 1), size(x, 2), y, z, q, a);
  return;
 end FunctionTests.ExternalFunc2.f;

end FunctionTests.ExternalFunc2;
")})));
end ExternalFunc2;


model ExternalFunc3
 function f
  input Real x[:,2];
  input Real y;
  output Real z;
  output Real q;
 external foo(size(x,1), 2, x, z, y, q);
 end f;
 
 Real x = f({{1,2},{3,4}}, 5);

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="ExternalFunc3",
			description="External functions: complex func, call set",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.ExternalFunc3
 Real x = FunctionTests.ExternalFunc3.f({{1,2},{3,4}}, 5);

public
 function FunctionTests.ExternalFunc3.f
  input Real[:, 2] x;
  input Real y;
  output Real z;
  output Real q;
 algorithm
  external \"C\" foo(size(x, 1), 2, x, z, y, q);
  return;
 end FunctionTests.ExternalFunc3.f;

end FunctionTests.ExternalFunc3;
")})));
end ExternalFunc3;


model ExternalFunc4
 function f
  input Real x[:,2];
  input Real y;
  output Real z;
  output Real q;
 external q = foo(size(x,1), 2, x, z, y);
 end f;
 
 Real x = f({{1,2},{3,4}}, 5);

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="ExternalFunc4",
			description="External functions: complex func, call and return set",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.ExternalFunc4
 Real x = FunctionTests.ExternalFunc4.f({{1,2},{3,4}}, 5);

public
 function FunctionTests.ExternalFunc4.f
  input Real[:, 2] x;
  input Real y;
  output Real z;
  output Real q;
 algorithm
  external \"C\" q = foo(size(x, 1), 2, x, z, y);
  return;
 end FunctionTests.ExternalFunc4.f;

end FunctionTests.ExternalFunc4;
")})));
end ExternalFunc4;


model ExternalFunc5
 function f
  input Real x;
  output Real y;
 external "C";
 end f;
 
 Real x = f(2);

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="ExternalFunc5",
			description="External functions: simple func, language \"C\"",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.ExternalFunc5
 Real x = FunctionTests.ExternalFunc5.f(2);

public
 function FunctionTests.ExternalFunc5.f
  input Real x;
  output Real y;
 algorithm
  external \"C\" y = f(x);
  return;
 end FunctionTests.ExternalFunc5.f;

end FunctionTests.ExternalFunc5;
")})));
end ExternalFunc5;


model ExternalFunc6
 function f
  input Real x;
  output Real y;
 external "FORTRAN 77";
 end f;
 
 Real x = f(2);

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="ExternalFunc6",
			description="External functions: simple func, language \"FORTRAN 77\"",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.ExternalFunc6
 Real x = FunctionTests.ExternalFunc6.f(2);

public
 function FunctionTests.ExternalFunc6.f
  input Real x;
  output Real y;
 algorithm
  external \"FORTRAN 77\" y = f(x);
  return;
 end FunctionTests.ExternalFunc6.f;

end FunctionTests.ExternalFunc6;
")})));
end ExternalFunc6;


model ExternalFunc7
 function f
  input Real x;
  output Real y;
 external "C++";
 end f;
 
 Real x = f(2);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="ExternalFunc7",
			description="External functions: simple func, language \"C++\"",
			variability_propagation=false,
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/FunctionTests.mo':
Semantic error at line 4508, column 2:
  The external language specification \"C++\" is not supported
")})));
end ExternalFunc7;



model ExternalFuncLibs1
 function f1
  input Real x;
  output Real y;
 external annotation(Library="foo");
 end f1;
 
 function f2
  input Real x;
  output Real y;
 external annotation(Library="bar");
 end f2;
 
 function f3
  input Real x;
  output Real y;
 external annotation(Library={"bar", "m"});
 end f3;
 
 function f4
  input Real x;
  output Real y;
 external;
 end f4;
 
 Real x1 = f1(1);
 Real x2 = f2(2);
 Real x3 = f3(3);
 Real x4 = f4(4);

	annotation(__JModelica(UnitTesting(tests={
		FClassMethodTestCase(
			name="ExternalFuncLibs1",
			description="External function annotations, Library",
			variability_propagation=false,
			methodName="externalLibraries",
			methodResult="[foo, m, bar]"
 )})));
end ExternalFuncLibs1;


model ExternalFuncLibs2
 function f1
  input Real x;
  output Real y;
 external annotation(Include="#include \"foo.h\"");
 end f1;
 
 function f2
  input Real x;
  output Real y;
 external annotation(Include="#include \"foo.h\"");
 end f2;
 
 function f3
  input Real x;
  output Real y;
 external annotation(Include="#include \"bar.h\"");
 end f3;
 
 function f4
  input Real x;
  output Real y;
 external;
 end f4;
 
 Real x1 = f1(1);
 Real x2 = f2(2);
 Real x3 = f3(3);
 Real x4 = f4(4);

	annotation(__JModelica(UnitTesting(tests={
		FClassMethodTestCase(
			name="ExternalFuncLibs2",
			description="External function annotations, Include",
			variability_propagation=false,
			methodName="externalIncludes",
			methodResult="[#include \"bar.h\", #include \"foo.h\"]"
 )})));
end ExternalFuncLibs2;


model ExternalFuncLibs3
 function f1
  input Real x;
  output Real y;
 external annotation(LibraryDirectory="file:///c:/foo/lib");
 end f1;
 
 function f2
  input Real x;
  output Real y;
 external;
 end f2;
 
 function f3
  input Real x;
  output Real y;
 external annotation(Library="bar", 
                     LibraryDirectory="file:///c:/bar/lib");
 end f3;
 
 Real x1 = f1(1);
 Real x2 = f2(2);
 Real x3 = f3(3);

	annotation(__JModelica(UnitTesting(tests={
		FClassMethodTestCase(
			name="ExternalFuncLibs3",
			description="External function annotations, LibraryDirectory",
			variability_propagation=false,
			methodName="externalLibraryDirectories",
			methodResult="[/c:/bar/lib, /c:/foo/lib]"
 )})));
end ExternalFuncLibs3;


model ExternalFuncLibs4
 function f1
  input Real x;
  output Real y;
 external annotation(Library="foo");
 end f1;
 
 function f2
  input Real x;
  output Real y;
 external annotation(Library="bar");
 end f2;
 
 function f3
  input Real x;
  output Real y;
 external;
 end f3;
 
 Real x1 = f1(1);
 Real x2 = f2(2);
 Real x3 = f3(3);

	annotation(__JModelica(UnitTesting(tests={
		FClassMethodTestCase(
			name="ExternalFuncLibs4",
			description="External function annotations, LibraryDirectory",
			variability_propagation=false,
			methodName="externalLibraryDirectories",
			filter=true,
			methodResult="
[%dir%/Resources/Library]"
 )})));
end ExternalFuncLibs4;


model ExternalFuncLibs5
 function f1
  input Real x;
  output Real y;
 external annotation(IncludeDirectory="file:///c:/foo/inc");
 end f1;
 
 function f2
  input Real x;
  output Real y;
 external annotation(Include="#include \"bar.h\"", 
                     IncludeDirectory="file:///c:/bar/inc");
 end f2;
 
 function f3
  input Real x;
  output Real y;
 external;
 end f3;
 
 Real x1 = f1(1);
 Real x2 = f2(2);
 Real x3 = f3(3);

	annotation(__JModelica(UnitTesting(tests={
		FClassMethodTestCase(
			name="ExternalFuncLibs5",
			description="External function annotations, IncludeDirectory",
			variability_propagation=false,
			methodName="externalIncludeDirectories",
			filter=true,
			methodResult="[/c:/foo/inc, /c:/bar/inc]"
 )})));
end ExternalFuncLibs5;


model ExternalFuncLibs6
 function f1
  input Real x;
  output Real y;
 external annotation(Include="#include \"foo.h\"");
 end f1;
 
 function f2
  input Real x;
  output Real y;
 external annotation(Include="#include \"bar.h\"");
 end f2;
 
 function f3
  input Real x;
  output Real y;
 external;
 end f3;
 
 Real x1 = f1(1);
 Real x2 = f2(2);
 Real x3 = f3(3);

	annotation(__JModelica(UnitTesting(tests={
		FClassMethodTestCase(
			name="ExternalFuncLibs6",
			description="External function annotations, IncludeDirectory",
			variability_propagation=false,
			methodName="externalIncludeDirectories",
			filter=true,
			methodResult="
[%dir%/Resources/Include]"
 )})));
end ExternalFuncLibs6;


model ExternalFuncLibs7
 function f1
  input Real x;
  output Real y;
 external annotation(LibraryDirectory="file:///c:/std/lib", 
                     IncludeDirectory="file:///c:/std/inc");
 end f1;
 
 function f2
  input Real x;
  output Real y;
 external annotation(Library="foo",
                     LibraryDirectory="file:///c:/foo/lib",  
                     Include="#include \"foo.h\"", 
                     IncludeDirectory="file:///c:/foo/inc");
 end f2;
 
 function f3
  input Real x;
  output Real y;
 external annotation(Include="#include \"bar.h\"", 
                     IncludeDirectory="file:///c:/bar/inc", 
                     Library="bar", 
                     LibraryDirectory="file:///c:/bar/lib");
 end f3;
 
 function f4
  input Real x;
  output Real y;
 external;
 end f4;
 
 Real x1 = f1(1);
 Real x2 = f2(2);
 Real x3 = f3(3);
 Real x4 = f4(4);

	annotation(__JModelica(UnitTesting(tests={
		FClassMethodTestCase(
			name="ExternalFuncLibs7",
			description="External function annotations, compiler args",
			variability_propagation=false,
			methodName="externalCompilerArgs",
			methodResult=" -lfoo -lbar -L/c:/bar/lib -L/c:/std/lib -L/c:/foo/lib -I/c:/foo/inc -I/c:/std/inc -I/c:/bar/inc"
 )})));
end ExternalFuncLibs7;


model ExternalFuncLibs8
 function f
  input Real x;
  output Real y;
 external annotation(Library="foo", 
                     Include="#include \"foo.h\"");
 end f;
 
 Real x = f(1);

	annotation(__JModelica(UnitTesting(tests={
		FClassMethodTestCase(
			name="ExternalFuncLibs8",
			description="External function annotations, compiler args",
			variability_propagation=false,
			methodName="externalCompilerArgs",
			filter=true,
			methodResult=" -lfoo -L%dir%/Resources/Library -I%dir%/Resources/Include"
 )})));
end ExternalFuncLibs8;

model ExternalFuncError1
	function f
		input Real x;
		output Real y;
		external;
	end f;
	Real x;
equation
	x = f(x);
	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="ExternalFuncError1",
			description="",
			variability_propagation=false,
			generate_block_jacobian=true,
			errorMessage="
1 errors found:

Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/FunctionTests.mo':
Semantic error at line 0, column 0:
  Unable to determine derivative function for function 'FunctionTests.ExternalFuncError1.f'
")})));
end ExternalFuncError1;



model ExtendFunc1
    function f1
        input Real a;
        output Real b;
    end f1;
    
    function f2
        extends f1;
    algorithm
        b := a;
    end f2;
    
    Real x = f2(1.0);

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="ExtendFunc1",
			description="Flattening of function extending other function",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.ExtendFunc1
 Real x = FunctionTests.ExtendFunc1.f2(1.0);

public
 function FunctionTests.ExtendFunc1.f2
  input Real a;
  output Real b;
 algorithm
  b := a;
  return;
 end FunctionTests.ExtendFunc1.f2;

end FunctionTests.ExtendFunc1;
")})));
end ExtendFunc1;



model ExtendFunc2
	constant Real[2] d = { 1, 2 };
	
    function f1
        input Real a;
        output Real b;
    end f1;
    
    function f2
        extends f1;
		input Integer c = 2;
	protected
		Real f = a + d[c];
    algorithm
        b := f;
    end f2;

    Real x = f2(1);

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="ExtendFunc2",
			description="Order of variables in functions when inheriting and adding constants",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.ExtendFunc2
 constant Real d[2] = {1,2};
 Real x = FunctionTests.ExtendFunc2.f2(1, 2);

public
 function FunctionTests.ExtendFunc2.f2
  Real[2] d := {1,2};
  input Real a;
  output Real b;
  input Integer c := 2;
  Real f := a + d[c];
 algorithm
  b := f;
  return;
 end FunctionTests.ExtendFunc2.f2;

end FunctionTests.ExtendFunc2;
")})));
end ExtendFunc2;



model AttributeTemp1
	function f
		output Real o[2] = {1, 2};
	algorithm
	end f;
	
	Real x[2](start = f()) = {3, 4};

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="AttributeTemp1",
			description="Temporary variable for attribute",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.AttributeTemp1
 Real x[1](start = temp_1[1]);
 Real x[2](start = temp_1[2]);
 parameter Real temp_1[1];
 parameter Real temp_1[2];
parameter equation
 ({temp_1[1],temp_1[2]}) = FunctionTests.AttributeTemp1.f();
equation
 x[1] = 3;
 x[2] = 4;

public
 function FunctionTests.AttributeTemp1.f
  output Real[2] o;
 algorithm
  o[1] := 1;
  o[2] := 2;
  return;
 end FunctionTests.AttributeTemp1.f;

end FunctionTests.AttributeTemp1;
")})));
end AttributeTemp1;



model InputAsArraySize1
	function f
		input Integer n;
		output Real x[n];
	algorithm
		x := 1:size(x,1);
	end f;
	
	Real x[3] = f(3);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="InputAsArraySize1",
			description="Input as array size of output in function: basic test",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.InputAsArraySize1
 Real x[1];
 Real x[2];
 Real x[3];
equation
 ({x[1],x[2],x[3]}) = FunctionTests.InputAsArraySize1.f(3);

public
 function FunctionTests.InputAsArraySize1.f
  input Integer n;
  output Real[n] x;
 algorithm
  for i1 in 1:size(x, 1) loop
   x[i1] := i1;
  end for;
  return;
 end FunctionTests.InputAsArraySize1.f;

end FunctionTests.InputAsArraySize1;
")})));
end InputAsArraySize1;


model InputAsArraySize2
	function f
		input Integer n;
		output Real x[n];
	algorithm
		x := 1:size(x,1);
	end f;
	
	parameter Integer n = 3;
	Real x[3] = f(n);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="InputAsArraySize2",
			description="Input as array size of output in function: basic test",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.InputAsArraySize2
 parameter Integer n = 3 /* 3 */;
 Real x[1];
 Real x[2];
 Real x[3];
equation
 ({x[1],x[2],x[3]}) = FunctionTests.InputAsArraySize2.f(n);

public
 function FunctionTests.InputAsArraySize2.f
  input Integer n;
  output Real[n] x;
 algorithm
  for i1 in 1:size(x, 1) loop
   x[i1] := i1;
  end for;
  return;
 end FunctionTests.InputAsArraySize2.f;

end FunctionTests.InputAsArraySize2;
")})));
end InputAsArraySize2;


model InputAsArraySize3
	function f
		input Integer n;
		output Real x[n];
	algorithm
		x := 1:size(x,1);
	end f;
	
	parameter Integer n = 3;
	Real x[n] = f(n);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="InputAsArraySize3",
			description="Input as array size of output in function: basic test",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.InputAsArraySize3
 parameter Integer n = 3 /* 3 */;
 Real x[1];
 Real x[2];
 Real x[3];
equation
 ({x[1],x[2],x[3]}) = FunctionTests.InputAsArraySize3.f(3);

public
 function FunctionTests.InputAsArraySize3.f
  input Integer n;
  output Real[n] x;
 algorithm
  for i1 in 1:size(x, 1) loop
   x[i1] := i1;
  end for;
  return;
 end FunctionTests.InputAsArraySize3.f;

end FunctionTests.InputAsArraySize3;
")})));
end InputAsArraySize3;


model InputAsArraySize4
	function f
		input Integer n;
		output Real x[n];
	algorithm
		x := 1:size(x,1);
	end f;
	
	Real x[3] = f(size(x,1));

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="InputAsArraySize4",
			description="Input as array size of output in function: test using size()",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.InputAsArraySize4
 Real x[1];
 Real x[2];
 Real x[3];
equation
 ({x[1],x[2],x[3]}) = FunctionTests.InputAsArraySize4.f(3);

public
 function FunctionTests.InputAsArraySize4.f
  input Integer n;
  output Real[n] x;
 algorithm
  for i1 in 1:size(x, 1) loop
   x[i1] := i1;
  end for;
  return;
 end FunctionTests.InputAsArraySize4.f;

end FunctionTests.InputAsArraySize4;
")})));
end InputAsArraySize4;


model InputAsArraySize5
	function f
		input Integer n;
		output Real x[n];
	algorithm
		x := 1:size(x,1);
	end f;
	
	Integer n = 3;
	Real x[3] = f(n);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="InputAsArraySize5",
			description="Input as array size of output in function: variable passed",
			variability_propagation=false,
			errorMessage="
2 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/FunctionTests.mo':
Semantic error at line 5605, column 7:
  Array size mismatch in declaration of x, size of declaration is [3] and size of binding expression is [n]
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/FunctionTests.mo':
Semantic error at line 5605, column 14:
  Could not evaluate array size of output x
")})));
end InputAsArraySize5;


model InputAsArraySize6
	function f
		input Integer n;
		output Real x[n];
	algorithm
		x := 1:size(x,1);
	end f;
	
	Real x[3] = f(4);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="InputAsArraySize6",
			description="Input as array size of output in function: wrong value passed",
			variability_propagation=false,
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/FunctionTests.mo':
Semantic error at line 5631, column 7:
  Array size mismatch in declaration of x, size of declaration is [3] and size of binding expression is [4]
")})));
end InputAsArraySize6;


model InputAsArraySize7
	function f
		input Integer n;
		input Real y[n];
		output Real x;
	algorithm
		x := sum(y[1:n]);
	end f;
	
	Real x = f(3, {1, 2, 3});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="InputAsArraySize7",
			description="Input as array size of other input in function: basic test",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.InputAsArraySize7
 Real x;
equation
 x = FunctionTests.InputAsArraySize7.f(3, {1,2,3});

public
 function FunctionTests.InputAsArraySize7.f
  input Integer n;
  input Real[n] y;
  output Real x;
  Real temp_1;
 algorithm
  temp_1 := 0.0;
  for i1 in 1:n loop
   temp_1 := temp_1 + y[i1];
  end for;
  x := temp_1;
  return;
 end FunctionTests.InputAsArraySize7.f;

end FunctionTests.InputAsArraySize7;
")})));
end InputAsArraySize7;


model InputAsArraySize8
	function f
		input Integer n;
		input Real y[n];
		output Real x;
	algorithm
		x := sum(y[1:n]);
	end f;
	
	Real x = f(4, {1, 2, 3});
end InputAsArraySize8;


model InputAsArraySize9
	function f
		input Integer n;
		input Real y[n];
		output Real x;
	algorithm
		x := sum(y);
	end f;
	
	Real x = f(3, {1, 2, 3});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="InputAsArraySize9",
			description="Input as array size of other input in function: basic test",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.InputAsArraySize9
 Real x;
equation
 x = FunctionTests.InputAsArraySize9.f(3, {1,2,3});

public
 function FunctionTests.InputAsArraySize9.f
  input Integer n;
  input Real[n] y;
  output Real x;
  Real temp_1;
 algorithm
  temp_1 := 0.0;
  for i1 in 1:n loop
   temp_1 := temp_1 + y[i1];
  end for;
  x := temp_1;
  return;
 end FunctionTests.InputAsArraySize9.f;

end FunctionTests.InputAsArraySize9;
")})));
end InputAsArraySize9;


model InputAsArraySize10
	function f
		input Integer n;
		input Real y[n];
		output Real x;
	algorithm
		x := sum(y);
	end f;
	
	Real x = f(4, {1, 2, 3});
end InputAsArraySize10;
// TODO: Fler som ovan



model VectorizedCall1
    function f
        input Real x;
        output Real y;
    algorithm
        y := 2 * x;
    end f;
    
    Real z[2] = f({1,2});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="VectorizedCall1",
			description="Vectorization: basic test",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.VectorizedCall1
 Real z[1];
 Real z[2];
equation
 z[1] = FunctionTests.VectorizedCall1.f(1);
 z[2] = FunctionTests.VectorizedCall1.f(2);

public
 function FunctionTests.VectorizedCall1.f
  input Real x;
  output Real y;
 algorithm
  y := 2 * x;
  return;
 end FunctionTests.VectorizedCall1.f;

end FunctionTests.VectorizedCall1;
")})));
end VectorizedCall1;


model VectorizedCall2
    function f
        input Real x1;
		input Real x2;
		input Real x3 = 2;
        output Real y;
    algorithm
        y := 2 * x1 + x2 + x3;
    end f;
    
    Real z[2,2] = f({{1,2},{3,4}}, 5);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="VectorizedCall2",
			description="Vectorization: one of two args vectorized",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.VectorizedCall2
 Real z[1,1];
 Real z[1,2];
 Real z[2,1];
 Real z[2,2];
equation
 z[1,1] = FunctionTests.VectorizedCall2.f(1, 5, 2);
 z[1,2] = FunctionTests.VectorizedCall2.f(2, 5, 2);
 z[2,1] = FunctionTests.VectorizedCall2.f(3, 5, 2);
 z[2,2] = FunctionTests.VectorizedCall2.f(4, 5, 2);

public
 function FunctionTests.VectorizedCall2.f
  input Real x1;
  input Real x2;
  input Real x3;
  output Real y;
 algorithm
  y := 2 * x1 + x2 + x3;
  return;
 end FunctionTests.VectorizedCall2.f;

end FunctionTests.VectorizedCall2;
")})));
end VectorizedCall2;


model VectorizedCall3
    function f
        input Real[:,:] x1;
        input Real[:,:] x2;
        output Real y;
    algorithm
        y := sum(x1 * x2);
    end f;
    
    constant Real v[3,3] = -1 * [1,2,3;4,5,6;7,8,9];
    constant Real w[3,3] = [1,2,3;4,5,6;7,8,9];
    Real z[2,2] = f({{w, 2*w},{3*w, 4*w}}, {{v, 2*v},{3*v, 4*v}});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="VectorizedCall3",
			description="Vectorization: vectorised array arg, constant",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.VectorizedCall3
 constant Real v[1,1] = - 1;
 constant Real v[1,2] = (- 1) * 2;
 constant Real v[1,3] = (- 1) * 3;
 constant Real v[2,1] = (- 1) * 4;
 constant Real v[2,2] = (- 1) * 5;
 constant Real v[2,3] = (- 1) * 6;
 constant Real v[3,1] = (- 1) * 7;
 constant Real v[3,2] = (- 1) * 8;
 constant Real v[3,3] = (- 1) * 9;
 constant Real w[1,1] = 1;
 constant Real w[1,2] = 2;
 constant Real w[1,3] = 3;
 constant Real w[2,1] = 4;
 constant Real w[2,2] = 5;
 constant Real w[2,3] = 6;
 constant Real w[3,1] = 7;
 constant Real w[3,2] = 8;
 constant Real w[3,3] = 9;
 Real z[1,1];
 Real z[1,2];
 Real z[2,1];
 Real z[2,2];
equation
 z[1,1] = FunctionTests.VectorizedCall3.f({{1.0, 2.0, 3.0}, {4.0, 5.0, 6.0}, {7.0, 8.0, 9.0}}, {{-1.0, -2.0, -3.0}, {-4.0, -5.0, -6.0}, {-7.0, -8.0, -9.0}});
 z[1,2] = FunctionTests.VectorizedCall3.f({{2, 2 * 2.0, 2 * 3.0}, {2 * 4.0, 2 * 5.0, 2 * 6.0}, {2 * 7.0, 2 * 8.0, 2 * 9.0}}, {{2 * -1.0, 2 * -2.0, 2 * -3.0}, {2 * -4.0, 2 * -5.0, 2 * -6.0}, {2 * -7.0, 2 * -8.0, 2 * -9.0}});
 z[2,1] = FunctionTests.VectorizedCall3.f({{3, 3 * 2.0, 3 * 3.0}, {3 * 4.0, 3 * 5.0, 3 * 6.0}, {3 * 7.0, 3 * 8.0, 3 * 9.0}}, {{3 * -1.0, 3 * -2.0, 3 * -3.0}, {3 * -4.0, 3 * -5.0, 3 * -6.0}, {3 * -7.0, 3 * -8.0, 3 * -9.0}});
 z[2,2] = FunctionTests.VectorizedCall3.f({{4, 4 * 2.0, 4 * 3.0}, {4 * 4.0, 4 * 5.0, 4 * 6.0}, {4 * 7.0, 4 * 8.0, 4 * 9.0}}, {{4 * -1.0, 4 * -2.0, 4 * -3.0}, {4 * -4.0, 4 * -5.0, 4 * -6.0}, {4 * -7.0, 4 * -8.0, 4 * -9.0}});

public
 function FunctionTests.VectorizedCall3.f
  input Real[:, :] x1;
  input Real[:, :] x2;
  output Real y;
  Real temp_1;
  Real[:,:] temp_2;
  Real temp_3;
 algorithm
  size(temp_2) := {size(x1, 1), size(x2, 2)};
  for i3 in 1:size(x1, 1) loop
   for i4 in 1:size(x2, 2) loop
    temp_3 := 0.0;
    for i5 in 1:size(x2, 1) loop
     temp_3 := temp_3 + x1[i3,i5] * x2[i5,i4];
    end for;
    temp_2[i3,i4] := temp_3;
   end for;
  end for;
  temp_1 := 0.0;
  for i1 in 1:size(x1, 1) loop
   for i2 in 1:size(x2, 2) loop
    temp_1 := temp_1 + temp_2[i1,i2];
   end for;
  end for;
  y := temp_1;
  return;
 end FunctionTests.VectorizedCall3.f;

end FunctionTests.VectorizedCall3;
			
")})));
end VectorizedCall3;


model VectorizedCall4
    function f
        input Real[:,:] x1;
        input Real[:,:] x2;
        output Real y;
    algorithm
        y := sum(x1 * x2);
    end f;
    
    Real v[3,3] = -1 * [1,2,3;4,5,6;7,8,9];
    Real w[3,3] = [1,2,3;4,5,6;7,8,9];
    Real v2[2,2,3,3] = {{v, 2*v},{3*v, 4*v}};
    Real w2[2,2,3,3] = {{w, 2*w},{3*w, 4*w}};
    Real z[2,2] = f(w2, v2);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="VectorizedCall4",
			description="Vectorization: vectorised array arg, continous",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.VectorizedCall4
 Real v2[1,1,1,1];
 Real v2[1,1,1,2];
 Real v2[1,1,1,3];
 Real v2[1,1,2,1];
 Real v2[1,1,2,2];
 Real v2[1,1,2,3];
 Real v2[1,1,3,1];
 Real v2[1,1,3,2];
 Real v2[1,1,3,3];
 Real v2[1,2,1,1];
 Real v2[1,2,1,2];
 Real v2[1,2,1,3];
 Real v2[1,2,2,1];
 Real v2[1,2,2,2];
 Real v2[1,2,2,3];
 Real v2[1,2,3,1];
 Real v2[1,2,3,2];
 Real v2[1,2,3,3];
 Real v2[2,1,1,1];
 Real v2[2,1,1,2];
 Real v2[2,1,1,3];
 Real v2[2,1,2,1];
 Real v2[2,1,2,2];
 Real v2[2,1,2,3];
 Real v2[2,1,3,1];
 Real v2[2,1,3,2];
 Real v2[2,1,3,3];
 Real v2[2,2,1,1];
 Real v2[2,2,1,2];
 Real v2[2,2,1,3];
 Real v2[2,2,2,1];
 Real v2[2,2,2,2];
 Real v2[2,2,2,3];
 Real v2[2,2,3,1];
 Real v2[2,2,3,2];
 Real v2[2,2,3,3];
 Real w2[1,1,1,1];
 Real w2[1,1,1,2];
 Real w2[1,1,1,3];
 Real w2[1,1,2,1];
 Real w2[1,1,2,2];
 Real w2[1,1,2,3];
 Real w2[1,1,3,1];
 Real w2[1,1,3,2];
 Real w2[1,1,3,3];
 Real w2[1,2,1,1];
 Real w2[1,2,1,2];
 Real w2[1,2,1,3];
 Real w2[1,2,2,1];
 Real w2[1,2,2,2];
 Real w2[1,2,2,3];
 Real w2[1,2,3,1];
 Real w2[1,2,3,2];
 Real w2[1,2,3,3];
 Real w2[2,1,1,1];
 Real w2[2,1,1,2];
 Real w2[2,1,1,3];
 Real w2[2,1,2,1];
 Real w2[2,1,2,2];
 Real w2[2,1,2,3];
 Real w2[2,1,3,1];
 Real w2[2,1,3,2];
 Real w2[2,1,3,3];
 Real w2[2,2,1,1];
 Real w2[2,2,1,2];
 Real w2[2,2,1,3];
 Real w2[2,2,2,1];
 Real w2[2,2,2,2];
 Real w2[2,2,2,3];
 Real w2[2,2,3,1];
 Real w2[2,2,3,2];
 Real w2[2,2,3,3];
 Real z[1,1];
 Real z[1,2];
 Real z[2,1];
 Real z[2,2];
equation
 v2[1,1,1,1] = - 1;
 v2[1,1,1,2] = (- 1) * 2;
 v2[1,1,1,3] = (- 1) * 3;
 v2[1,1,2,1] = (- 1) * 4;
 v2[1,1,2,2] = (- 1) * 5;
 v2[1,1,2,3] = (- 1) * 6;
 v2[1,1,3,1] = (- 1) * 7;
 v2[1,1,3,2] = (- 1) * 8;
 v2[1,1,3,3] = (- 1) * 9;
 w2[1,1,1,1] = 1;
 w2[1,1,1,2] = 2;
 w2[1,1,1,3] = 3;
 w2[1,1,2,1] = 4;
 w2[1,1,2,2] = 5;
 w2[1,1,2,3] = 6;
 w2[1,1,3,1] = 7;
 w2[1,1,3,2] = 8;
 w2[1,1,3,3] = 9;
 v2[1,2,1,1] = 2 * v2[1,1,1,1];
 v2[1,2,1,2] = 2 * v2[1,1,1,2];
 v2[1,2,1,3] = 2 * v2[1,1,1,3];
 v2[1,2,2,1] = 2 * v2[1,1,2,1];
 v2[1,2,2,2] = 2 * v2[1,1,2,2];
 v2[1,2,2,3] = 2 * v2[1,1,2,3];
 v2[1,2,3,1] = 2 * v2[1,1,3,1];
 v2[1,2,3,2] = 2 * v2[1,1,3,2];
 v2[1,2,3,3] = 2 * v2[1,1,3,3];
 v2[2,1,1,1] = 3 * v2[1,1,1,1];
 v2[2,1,1,2] = 3 * v2[1,1,1,2];
 v2[2,1,1,3] = 3 * v2[1,1,1,3];
 v2[2,1,2,1] = 3 * v2[1,1,2,1];
 v2[2,1,2,2] = 3 * v2[1,1,2,2];
 v2[2,1,2,3] = 3 * v2[1,1,2,3];
 v2[2,1,3,1] = 3 * v2[1,1,3,1];
 v2[2,1,3,2] = 3 * v2[1,1,3,2];
 v2[2,1,3,3] = 3 * v2[1,1,3,3];
 v2[2,2,1,1] = 4 * v2[1,1,1,1];
 v2[2,2,1,2] = 4 * v2[1,1,1,2];
 v2[2,2,1,3] = 4 * v2[1,1,1,3];
 v2[2,2,2,1] = 4 * v2[1,1,2,1];
 v2[2,2,2,2] = 4 * v2[1,1,2,2];
 v2[2,2,2,3] = 4 * v2[1,1,2,3];
 v2[2,2,3,1] = 4 * v2[1,1,3,1];
 v2[2,2,3,2] = 4 * v2[1,1,3,2];
 v2[2,2,3,3] = 4 * v2[1,1,3,3];
 w2[1,2,1,1] = 2 * w2[1,1,1,1];
 w2[1,2,1,2] = 2 * w2[1,1,1,2];
 w2[1,2,1,3] = 2 * w2[1,1,1,3];
 w2[1,2,2,1] = 2 * w2[1,1,2,1];
 w2[1,2,2,2] = 2 * w2[1,1,2,2];
 w2[1,2,2,3] = 2 * w2[1,1,2,3];
 w2[1,2,3,1] = 2 * w2[1,1,3,1];
 w2[1,2,3,2] = 2 * w2[1,1,3,2];
 w2[1,2,3,3] = 2 * w2[1,1,3,3];
 w2[2,1,1,1] = 3 * w2[1,1,1,1];
 w2[2,1,1,2] = 3 * w2[1,1,1,2];
 w2[2,1,1,3] = 3 * w2[1,1,1,3];
 w2[2,1,2,1] = 3 * w2[1,1,2,1];
 w2[2,1,2,2] = 3 * w2[1,1,2,2];
 w2[2,1,2,3] = 3 * w2[1,1,2,3];
 w2[2,1,3,1] = 3 * w2[1,1,3,1];
 w2[2,1,3,2] = 3 * w2[1,1,3,2];
 w2[2,1,3,3] = 3 * w2[1,1,3,3];
 w2[2,2,1,1] = 4 * w2[1,1,1,1];
 w2[2,2,1,2] = 4 * w2[1,1,1,2];
 w2[2,2,1,3] = 4 * w2[1,1,1,3];
 w2[2,2,2,1] = 4 * w2[1,1,2,1];
 w2[2,2,2,2] = 4 * w2[1,1,2,2];
 w2[2,2,2,3] = 4 * w2[1,1,2,3];
 w2[2,2,3,1] = 4 * w2[1,1,3,1];
 w2[2,2,3,2] = 4 * w2[1,1,3,2];
 w2[2,2,3,3] = 4 * w2[1,1,3,3];
 z[1,1] = FunctionTests.VectorizedCall4.f({{w2[1,1,1,1], w2[1,1,1,2], w2[1,1,1,3]}, {w2[1,1,2,1], w2[1,1,2,2], w2[1,1,2,3]}, {w2[1,1,3,1], w2[1,1,3,2], w2[1,1,3,3]}}, {{v2[1,1,1,1], v2[1,1,1,2], v2[1,1,1,3]}, {v2[1,1,2,1], v2[1,1,2,2], v2[1,1,2,3]}, {v2[1,1,3,1], v2[1,1,3,2], v2[1,1,3,3]}});
 z[1,2] = FunctionTests.VectorizedCall4.f({{w2[1,2,1,1], w2[1,2,1,2], w2[1,2,1,3]}, {w2[1,2,2,1], w2[1,2,2,2], w2[1,2,2,3]}, {w2[1,2,3,1], w2[1,2,3,2], w2[1,2,3,3]}}, {{v2[1,2,1,1], v2[1,2,1,2], v2[1,2,1,3]}, {v2[1,2,2,1], v2[1,2,2,2], v2[1,2,2,3]}, {v2[1,2,3,1], v2[1,2,3,2], v2[1,2,3,3]}});
 z[2,1] = FunctionTests.VectorizedCall4.f({{w2[2,1,1,1], w2[2,1,1,2], w2[2,1,1,3]}, {w2[2,1,2,1], w2[2,1,2,2], w2[2,1,2,3]}, {w2[2,1,3,1], w2[2,1,3,2], w2[2,1,3,3]}}, {{v2[2,1,1,1], v2[2,1,1,2], v2[2,1,1,3]}, {v2[2,1,2,1], v2[2,1,2,2], v2[2,1,2,3]}, {v2[2,1,3,1], v2[2,1,3,2], v2[2,1,3,3]}});
 z[2,2] = FunctionTests.VectorizedCall4.f({{w2[2,2,1,1], w2[2,2,1,2], w2[2,2,1,3]}, {w2[2,2,2,1], w2[2,2,2,2], w2[2,2,2,3]}, {w2[2,2,3,1], w2[2,2,3,2], w2[2,2,3,3]}}, {{v2[2,2,1,1], v2[2,2,1,2], v2[2,2,1,3]}, {v2[2,2,2,1], v2[2,2,2,2], v2[2,2,2,3]}, {v2[2,2,3,1], v2[2,2,3,2], v2[2,2,3,3]}});

public
 function FunctionTests.VectorizedCall4.f
  input Real[:, :] x1;
  input Real[:, :] x2;
  output Real y;
  Real temp_1;
  Real[:,:] temp_2;
  Real temp_3;
 algorithm
  size(temp_2) := {size(x1, 1), size(x2, 2)};
  for i3 in 1:size(x1, 1) loop
   for i4 in 1:size(x2, 2) loop
    temp_3 := 0.0;
    for i5 in 1:size(x2, 1) loop
     temp_3 := temp_3 + x1[i3,i5] * x2[i5,i4];
    end for;
    temp_2[i3,i4] := temp_3;
   end for;
  end for;
  temp_1 := 0.0;
  for i1 in 1:size(x1, 1) loop
   for i2 in 1:size(x2, 2) loop
    temp_1 := temp_1 + temp_2[i1,i2];
   end for;
  end for;
  y := temp_1;
  return;
 end FunctionTests.VectorizedCall4.f;

end FunctionTests.VectorizedCall4;
			
")})));
end VectorizedCall4;


model VectorizedCall5
	record R
		Real a;
		Real b;
	end R;
	
    function f
        input R x;
        output Real y;
    algorithm
        y := 2 * x.a + x.b;
    end f;
    
	R[2] w = {R(1,2), R(3,4)};
    Real z[2] = f(w);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="VectorizedCall5",
			description="Vectorization: scalarized record arg",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.VectorizedCall5
 Real w[1].a;
 Real w[1].b;
 Real w[2].a;
 Real w[2].b;
 Real z[1];
 Real z[2];
equation
 w[1].a = 1;
 w[2].a = 3;
 w[1].b = 2;
 w[2].b = 4;
 z[1] = FunctionTests.VectorizedCall5.f(FunctionTests.VectorizedCall5.R(w[1].a, w[1].b));
 z[2] = FunctionTests.VectorizedCall5.f(FunctionTests.VectorizedCall5.R(w[2].a, w[2].b));

public
 function FunctionTests.VectorizedCall5.f
  input FunctionTests.VectorizedCall5.R x;
  output Real y;
 algorithm
  y := 2 * x.a + x.b;
  return;
 end FunctionTests.VectorizedCall5.f;

 record FunctionTests.VectorizedCall5.R
  Real a;
  Real b;
 end FunctionTests.VectorizedCall5.R;

end FunctionTests.VectorizedCall5;
")})));
end VectorizedCall5;


model Lapack_dgeqpf
  Real A[2,2] = {{1,2},{3,4}};
  Real QR[2,2];
  Real tau[2];
equation 
  (QR,tau,) = Modelica.Math.Matrices.LAPACK.dgeqpf(A);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Lapack_dgeqpf",
			description="Test scalarization of LAPACK function that has had some issues",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.Lapack_dgeqpf
 Real A[1,1];
 Real A[1,2];
 Real A[2,1];
 Real A[2,2];
 Real QR[1,1];
 Real QR[1,2];
 Real QR[2,1];
 Real QR[2,2];
 Real tau[1];
 Real tau[2];
equation
 ({{QR[1,1], QR[1,2]}, {QR[2,1], QR[2,2]}}, {tau[1], tau[2]}, ) = Modelica.Math.Matrices.LAPACK.dgeqpf({{A[1,1], A[1,2]}, {A[2,1], A[2,2]}});
 A[1,1] = 1;
 A[1,2] = 2;
 A[2,1] = 3;
 A[2,2] = 4;

public
 function Modelica.Math.Matrices.LAPACK.dgeqpf
  input Real[:, :] A;
  output Real[size(A, 1), size(A, 2)] QR;
  output Real[min(size(A, 1), size(A, 2))] tau;
  output Integer[size(A, 2)] p;
  output Integer info;
  Integer lda;
  Integer ncol;
  Real[:] work;
 algorithm
  size(work) := {3 * size(A, 2)};
  for i1 in 1:size(A, 1) loop
   for i2 in 1:size(A, 2) loop
    QR[i1,i2] := A[i1,i2];
   end for;
  end for;
  for i1 in 1:size(A, 2) loop
   p[i1] := 0;
  end for;
  lda := max(1, size(A, 1));
  ncol := size(A, 2);
  external \"FORTRAN 77\" dgeqpf(size(A, 1), ncol, QR, lda, p, tau, work, info);
  return;
 end Modelica.Math.Matrices.LAPACK.dgeqpf;

end FunctionTests.Lapack_dgeqpf;
")})));
end Lapack_dgeqpf;

model Lapack_QR
 Real A[2,2] = {{5,6},{7,8}};
 Real Q[2,2];
 Real R[2,2];
 //Integer piv[2];
equation 
 (Q,R,) = Modelica.Math.Matrices.QR(A);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Lapack_QR",
			description="",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.Lapack_QR
 Real A[1,1];
 Real A[1,2];
 Real A[2,1];
 Real A[2,2];
 Real Q[1,1];
 Real Q[1,2];
 Real Q[2,1];
 Real Q[2,2];
 Real R[1,1];
 Real R[1,2];
 Real R[2,1];
 Real R[2,2];
equation
 ({{Q[1,1], Q[1,2]}, {Q[2,1], Q[2,2]}}, {{R[1,1], R[1,2]}, {R[2,1], R[2,2]}}, ) = Modelica.Math.Matrices.QR({{A[1,1], A[1,2]}, {A[2,1], A[2,2]}}, true);
 A[1,1] = 5;
 A[1,2] = 6;
 A[2,1] = 7;
 A[2,2] = 8;

public
 function Modelica.Math.Matrices.QR
  input Real[:, :] A;
  input Boolean pivoting;
  output Real[size(A, 1), size(A, 2)] Q;
  output Real[size(A, 2), size(A, 2)] R;
  output Integer[size(A, 2)] p;
  Integer nrow;
  Integer ncol;
  Real[:] tau;
 algorithm
  size(tau) := {size(A, 2)};
  nrow := size(A, 1);
  ncol := size(A, 2);
  assert(nrow >= ncol, \"\\nInput matrix A[\" + String(nrow) + \",\" + String(ncol) + \"] has more columns as rows.
This is not allowed when calling Modelica.Matrices.QR(A).\");
  if pivoting then
   (Q, tau, p) := Modelica.Math.Matrices.LAPACK.dgeqpf(A);
  else
   (Q, tau) := Modelica.Math.Matrices.LAPACK.dgeqrf(A);
   for i1 in 1:ncol loop
    p[i1] := i1;
   end for;
  end if;
  for i1 in 1:ncol loop
   for i2 in 1:ncol loop
    R[i1,i2] := 0;
   end for;
  end for;
  for i in 1:ncol loop
   for j in i:ncol loop
    R[i,j] := Q[i,j];
   end for;
  end for;
  (Q) := Modelica.Math.Matrices.LAPACK.dorgqr(Q, tau);
  return;
 end Modelica.Math.Matrices.QR;

 function Modelica.Math.Matrices.LAPACK.dgeqpf
  input Real[:, :] A;
  output Real[size(A, 1), size(A, 2)] QR;
  output Real[min(size(A, 1), size(A, 2))] tau;
  output Integer[size(A, 2)] p;
  output Integer info;
  Integer lda;
  Integer ncol;
  Real[:] work;
 algorithm
  size(work) := {3 * size(A, 2)};
  for i1 in 1:size(A, 1) loop
   for i2 in 1:size(A, 2) loop
    QR[i1,i2] := A[i1,i2];
   end for;
  end for;
  for i1 in 1:size(A, 2) loop
   p[i1] := 0;
  end for;
  lda := max(1, size(A, 1));
  ncol := size(A, 2);
  external \"FORTRAN 77\" dgeqpf(size(A, 1), ncol, QR, lda, p, tau, work, info);
  return;
 end Modelica.Math.Matrices.LAPACK.dgeqpf;

 function Modelica.Math.Matrices.LAPACK.dgeqrf
  input Real[:, :] A;
  output Real[size(A, 1), size(A, 2)] Aout;
  output Real[min(size(A, 1), size(A, 2))] tau;
  output Integer info;
  output Real[3 * max(1, size(A, 2))] work;
  Integer m;
  Integer n;
  Integer lda;
  Integer lwork;
 algorithm
  for i1 in 1:size(A, 1) loop
   for i2 in 1:size(A, 2) loop
    Aout[i1,i2] := A[i1,i2];
   end for;
  end for;
  m := size(A, 1);
  n := size(A, 2);
  lda := max(1, m);
  lwork := 3 * max(1, n);
  external \"FORTRAN 77\" dgeqrf(m, n, Aout, lda, tau, work, lwork, info);
  return;
 end Modelica.Math.Matrices.LAPACK.dgeqrf;

 function Modelica.Math.Matrices.LAPACK.dorgqr
  input Real[:, :] QR;
  input Real[min(size(QR, 1), size(QR, 2))] tau;
  output Real[size(QR, 1), size(QR, 2)] Q;
  output Integer info;
  Integer lda;
  Integer lwork;
  Real[:] work;
 algorithm
  size(work) := {max(1, min(10, size(QR, 2)) * size(QR, 2))};
  for i1 in 1:size(QR, 1) loop
   for i2 in 1:size(QR, 2) loop
    Q[i1,i2] := QR[i1,i2];
   end for;
  end for;
  lda := max(1, size(Q, 1));
  lwork := max(1, min(10, size(QR, 2)) * size(QR, 2));
  external \"FORTRAN 77\" dorgqr(size(QR, 1), size(QR, 2), size(tau, 1), Q, lda, tau, work, lwork, info);
  return;
 end Modelica.Math.Matrices.LAPACK.dorgqr;

end FunctionTests.Lapack_QR;
")})));
end Lapack_QR;

model BindingSort1
	function f
		input Real x;
		output Real y = a + 1;
	protected
        Real a = b + e;
	    Real b = c + d;
	    Real c = x + d;
	    Real d = e + 1;
	    Real e = x + 1;
	algorithm
		y := y + x;
	end f;
	
	Real x = f(y);
	Real y = 1;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="BindingSort1",
			description="Test sorting of binding expressions",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.BindingSort1
 Real x;
 Real y;
equation
 x = FunctionTests.BindingSort1.f(y);
 y = 1;

public
 function FunctionTests.BindingSort1.f
  input Real x;
  output Real y;
  Real a;
  Real b;
  Real c;
  Real d;
  Real e;
 algorithm
  e := x + 1;
  d := e + 1;
  c := x + d;
  b := c + d;
  a := b + e;
  y := a + 1;
  y := y + x;
  return;
 end FunctionTests.BindingSort1.f;

end FunctionTests.BindingSort1;
")})));
end BindingSort1;

model Interpolate
    function interp
        input Real u;
        output Real value;
    algorithm
	   value := u*2;
	   annotation(derivative=Interpolate.interpDer);
	end interp;

    function interpDer
        input Real u;
        output Real value;
	algorithm
        value := u*3;
    end interpDer;
end Interpolate;

model UseInterpolate	
 Real result;
 Real i = 1.0;
equation
	 result = Interpolate.interp(i);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="UseInterpolate",
			description="",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass FunctionTests.UseInterpolate
 Real result;
 Real i;
equation
 result = FunctionTests.Interpolate.interp(i);
 i = 1.0;

public
 function FunctionTests.Interpolate.interp
  input Real u;
  output Real value;
 algorithm
  value := u * 2;
  return;
 end FunctionTests.Interpolate.interp;

end FunctionTests.UseInterpolate;
")})));
end UseInterpolate;


model Table1DfromFile
  Modelica.Blocks.Sources.Sine sine(freqHz=1, amplitude=2);
  Modelica.Blocks.Tables.CombiTable1D modelicaTable1D(
    tableOnFile=true,
    tableName="spring_data",
    fileName="lr_spring.tab");
equation
  connect(sine.y, modelicaTable1D.u[1]);
end Table1DfromFile;


model ComponentFunc1
    model A
        partial function f
            input Real x;
            output Real y;
        end f;
        
        Real z(start = 2);
    equation
        der(z) = -z;
    end A;
    
    model B
        extends A;
        redeclare function extends f
        algorithm
            y := 2 * x;
        end f;
    end B;
    
    model C
        extends A;
        redeclare function extends f
        algorithm
            y := x * x;
        end f;
    end C;
    
    B b1;
    C c1;
    Real w = b1.f(v) + c1.f(v);
    Real v = 3;

    annotation(__JModelica(UnitTesting(tests={
        TransformCanonicalTestCase(
            name="ComponentFunc1",
            description="Calling functions in components",
			variability_propagation=false,
			inline_functions="none",
            flatModel="
fclass FunctionTests.ComponentFunc1
 Real b1.z(start = 2);
 Real c1.z(start = 2);
 Real w;
 Real v;
initial equation 
 b1.z = 2;
 c1.z = 2;
equation
 b1.der(z) = - b1.z;
 c1.der(z) = - c1.z;
 w = FunctionTests.ComponentFunc1.b1.f(v) + FunctionTests.ComponentFunc1.c1.f(v);
 v = 3;

public
 function FunctionTests.ComponentFunc1.b1.f
  input Real x;
  output Real y;
 algorithm
  y := 2 * x;
  return;
 end FunctionTests.ComponentFunc1.b1.f;

 function FunctionTests.ComponentFunc1.c1.f
  input Real x;
  output Real y;
 algorithm
  y := x * x;
  return;
 end FunctionTests.ComponentFunc1.c1.f;

end FunctionTests.ComponentFunc1;
")})));
end ComponentFunc1;


model ComponentFunc2
    model A
        partial function f
            input Real x;
            output Real y;
        end f;
        
        Real z(start = 2);
    equation
        der(z) = -z;
    end A;
    
    model B
        extends A;
        redeclare function extends f
        algorithm
            y := 2 * x;
        end f;
    end B;
    
    model C
        extends A;
        redeclare function extends f
        algorithm
            y := x * x;
        end f;
    end C;
    
	model D
		outer A a;
	    Real v = 3;
		Real w = a.f(v);
	end D;
	
	model E
		replaceable model F = A;
		inner F a;
		D d;
	end E;
	
    E eb(redeclare model F = B);
    E ec(redeclare model F = C);

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="ComponentFunc2",
			description="Calling functions in inner/outer components",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.ComponentFunc2
 Real eb.a.z(start = 2);
 Real eb.d.v = 3;
 Real eb.d.w = FunctionTests.ComponentFunc2.eb.a.f(eb.d.v);
 Real ec.a.z(start = 2);
 Real ec.d.v = 3;
 Real ec.d.w = FunctionTests.ComponentFunc2.ec.a.f(ec.d.v);
equation
 eb.a.der(z) = - eb.a.z;
 ec.a.der(z) = - ec.a.z;

public
 function FunctionTests.ComponentFunc2.eb.a.f
  input Real x;
  output Real y;
 algorithm
  y := 2 * x;
  return;
 end FunctionTests.ComponentFunc2.eb.a.f;

 function FunctionTests.ComponentFunc2.ec.a.f
  input Real x;
  output Real y;
 algorithm
  y := x * x;
  return;
 end FunctionTests.ComponentFunc2.ec.a.f;

end FunctionTests.ComponentFunc2;
")})));
end ComponentFunc2;


model ComponentFunc3
    model A
        function f = f2(a = 2);
        Real x = 1;
    end A;
    
    function f2
        input Real a;
        output Real b;
    algorithm
        b := a + 1;
        b := b + a;
    end f2;
    
    A a;
    Real y = a.f();

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="ComponentFunc3",
			description="",
			flatModel="
fclass FunctionTests.ComponentFunc3
 Real a.x = 1;
 Real y = FunctionTests.ComponentFunc3.a.f(2);

public
 function FunctionTests.ComponentFunc3.a.f
  input Real a := 2;
  output Real b;
 algorithm
  b := a + 1;
  b := b + a;
  return;
 end FunctionTests.ComponentFunc3.a.f;

end FunctionTests.ComponentFunc3;
")})));
end ComponentFunc3;


model ComponentFunc4
    model A
        function f = f2(c = 2);
        Real x = 1;
    end A;
    
    function f2
        input Real a;
        input real c;
        output Real b;
    algorithm
        b := a + 1;
        b := b + c;
    end f2;
    
    A a;
    Real y = a.f(a.x);
end ComponentFunc4;


model MinOnInput1
    function F
        input Real x(min=0) = 3.14;
        output Real y;
    algorithm
        y := x * 42;
    end F;
	
    Real y = F();

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="MinOnInput1",
			description="Test that default arguments are correctly identified with modification on input",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.MinOnInput1
 Real y = FunctionTests.MinOnInput1.F(3.14);

public
 function FunctionTests.MinOnInput1.F
  input Real x := 3.14;
  output Real y;
 algorithm
  y := x * 42;
  return;
 end FunctionTests.MinOnInput1.F;

end FunctionTests.MinOnInput1;
")})));
end MinOnInput1;



package FunctionLike

package NumericConversion

model Abs1
    Real x = abs(1);
    Real y[3] = abs({2,3,4});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_NumericConversion_Abs1",
			description="Basic test of abs().",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.FunctionLike.NumericConversion.Abs1
 Real x;
 Real y[1];
 Real y[2];
 Real y[3];
equation
 x = abs(1);
 y[1] = abs(2);
 y[2] = abs(3);
 y[3] = abs(4);
end FunctionTests.FunctionLike.NumericConversion.Abs1;
")})));
end Abs1;

model Abs2
    constant Real[2,2] c = {{-1, 2}, {3, -4}};
    constant Real[2,2] d = abs(c);
    Real[2,2] x = c;
    Real[2,2] y = d;
    Real[2,2] z = abs(x);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_NumericConversion_Abs2",
			description="Test of vectorized abs()",
			flatModel="
fclass FunctionTests.FunctionLike.NumericConversion.Abs2
 constant Real c[1,1] = - 1;
 constant Real c[1,2] = 2;
 constant Real c[2,1] = 3;
 constant Real c[2,2] = - 4;
 constant Real d[1,1] = abs(-1.0);
 constant Real d[1,2] = abs(2.0);
 constant Real d[2,1] = abs(3.0);
 constant Real d[2,2] = abs(-4.0);
 constant Real x[1,1] = -1.0;
 constant Real x[1,2] = 2.0;
 constant Real x[2,1] = 3.0;
 constant Real x[2,2] = -4.0;
 constant Real y[1,1] = 1.0;
 constant Real y[1,2] = 2.0;
 constant Real y[2,1] = 3.0;
 constant Real y[2,2] = 4.0;
 constant Real z[1,1] = 1.0;
 constant Real z[1,2] = 2.0;
 constant Real z[2,1] = 3.0;
 constant Real z[2,2] = 4.0;
end FunctionTests.FunctionLike.NumericConversion.Abs2;
")})));
end Abs2;

model Abs3
    constant Real x = abs(-35);
    constant Real y = abs(0);
	constant Real z = abs(42);

	annotation(__JModelica(UnitTesting(tests={
		EvalTestCase(
			name="FunctionLike_NumericConversion_Abs3",
			description="Evaluation of the abs operator.",
			variables="
x
y
z
",
			values="
35.0
0.0
42.0
")})));
end Abs3;

model Sign1
    Real x = sign(1);
    Real y[3] = sign({2,3,4});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_NumericConversion_Sign1",
			description="Basic test of sign().",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.FunctionLike.NumericConversion.Sign1
 Real x;
 Real y[1];
 Real y[2];
 Real y[3];
equation
 x = sign(1);
 y[1] = sign(2);
 y[2] = sign(3);
 y[3] = sign(4);
end FunctionTests.FunctionLike.NumericConversion.Sign1;
")})));
end Sign1;

model Sign2
    constant Real[2,2] c = {{-1, 2}, {3, -4}};
    constant Real[2,2] d = sign(c);
    Real[2,2] x = c;
    Real[2,2] y = d;
    Real[2,2] z = sign(x);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_NumericConversion_Sign2",
			description="Test of vectorized sign()",
			flatModel="
fclass FunctionTests.FunctionLike.NumericConversion.Sign2
 constant Real c[1,1] = - 1;
 constant Real c[1,2] = 2;
 constant Real c[2,1] = 3;
 constant Real c[2,2] = - 4;
 constant Real d[1,1] = sign(-1.0);
 constant Real d[1,2] = sign(2.0);
 constant Real d[2,1] = sign(3.0);
 constant Real d[2,2] = sign(-4.0);
 constant Real x[1,1] = -1.0;
 constant Real x[1,2] = 2.0;
 constant Real x[2,1] = 3.0;
 constant Real x[2,2] = -4.0;
 constant Real y[1,1] = -1.0;
 constant Real y[1,2] = 1.0;
 constant Real y[2,1] = 1.0;
 constant Real y[2,2] = -1.0;
 constant Real z[1,1] = -1;
 constant Real z[1,2] = 1;
 constant Real z[2,1] = 1;
 constant Real z[2,2] = -1;
end FunctionTests.FunctionLike.NumericConversion.Sign2;
")})));
end Sign2;

model Sign3
    constant Real x = sign(-35);
    constant Real y = sign(0);
	constant Real z = sign(42);

	annotation(__JModelica(UnitTesting(tests={
		EvalTestCase(
			name="FunctionLike_NumericConversion_Sign3",
			description="Evaluation of the sign operator.",
			variables="
x
y
z
",
			values="
-1.0
0.0
1.0
")})));
end Sign3;

model Sqrt1
    Real x = sqrt(1);
    Real y[3] = sqrt({2,3,4});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_NumericConversion_Sqrt1",
			description="Basic test of sqrt().",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.FunctionLike.NumericConversion.Sqrt1
 Real x;
 Real y[1];
 Real y[2];
 Real y[3];
equation
 x = sqrt(1);
 y[1] = sqrt(2);
 y[2] = sqrt(3);
 y[3] = sqrt(4);
end FunctionTests.FunctionLike.NumericConversion.Sqrt1;
")})));
end Sqrt1;

model Sqrt2
    constant Real x = sqrt(1);
    constant Real y = sqrt(4);
	constant Real z = sqrt(9);
	
	annotation(__JModelica(UnitTesting(tests={
		EvalTestCase(
			name="FunctionLike_NumericConversion_Sqrt2",
			description="Evaluation of the sqrt operator.",
			variables="
x
y
z
",
			values="
1.0
2.0
3.0
")})));
end Sqrt2;


model Integer1
    type E = enumeration(x,a,b,c);
    Real x = Integer(E.x);
    Real y[3] = Integer({E.a,E.b,E.c});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_NumericConversion_Integer1",
			description="Basic test of Integer().",
			variability_propagation=false,
			flatModel="
fclass FunctionTests.FunctionLike.NumericConversion.Integer1
 Real x;
 Real y[1];
 Real y[2];
 Real y[3];
equation
 x = Integer(FunctionTests.FunctionLike.NumericConversion.Integer1.E.x);
 y[1] = Integer(FunctionTests.FunctionLike.NumericConversion.Integer1.E.a);
 y[2] = Integer(FunctionTests.FunctionLike.NumericConversion.Integer1.E.b);
 y[3] = Integer(FunctionTests.FunctionLike.NumericConversion.Integer1.E.c);

public
 type FunctionTests.FunctionLike.NumericConversion.Integer1.E = enumeration(x, a, b, c);

end FunctionTests.FunctionLike.NumericConversion.Integer1;
")})));
end Integer1;

model Integer2
    type E = enumeration(x,a,b,c);
    constant Real x = Integer(E.x);
	constant Real y = Integer(E.b);
	constant Real z = Integer(E.c);

	annotation(__JModelica(UnitTesting(tests={
		EvalTestCase(
			name="FunctionLike_NumericConversion_Integer2",
			description="Evaluation of the Integer operator.",
			variables="
x
y
z
",
			values="
1.0
3.0
4.0
")})));
end Integer2;

end NumericConversion;



package EventGen
	
model Div1
	Real x    = div(time, 2);
	Real y[2] = div({time,time},2);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_EventGen_Div1",
			description="Basic test of div().",
			flatModel="
fclass FunctionTests.FunctionLike.EventGen.Div1
 Real x;
 Real y[1];
 Real y[2];
 discrete Real temp_1;
 discrete Real temp_2;
 discrete Real temp_3;
initial equation 
 pre(temp_1) = 0.0;
 pre(temp_2) = 0.0;
 pre(temp_3) = 0.0;
equation
 x = temp_3;
 y[1] = temp_2;
 y[2] = temp_1;
 temp_1 = if div(time, 2) < pre(temp_1) or div(time, 2) >= pre(temp_1) + 1 or initial() then div(time, 2) else pre(temp_1);
 temp_2 = if div(time, 2) < pre(temp_2) or div(time, 2) >= pre(temp_2) + 1 or initial() then div(time, 2) else pre(temp_2);
 temp_3 = if div(time, 2) < pre(temp_3) or div(time, 2) >= pre(temp_3) + 1 or initial() then div(time, 2) else pre(temp_3);
end FunctionTests.FunctionLike.EventGen.Div1;
			
")})));
end Div1;

model Div2
	constant Real x = div(42.9,3);
	constant Integer y = div(42,42);

	annotation(__JModelica(UnitTesting(tests={
		EvalTestCase(
			name="FunctionLike_EventGen_Div2",
			description="Evaluation of the div operator.",
			variables="
x
y
",
			values="
14.0
1
")})));
end Div2;

model Mod1
	Real x    = mod(time, 2);
	Real y[2] = mod({time,time},2);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_EventGen_Mod1",
			description="Basic test of mod().",
			flatModel="
fclass FunctionTests.FunctionLike.EventGen.Mod1
 Real x;
 Real y[1];
 Real y[2];
 discrete Real temp_1;
 discrete Real temp_2;
 discrete Real temp_3;
initial equation 
 pre(temp_1) = 0.0;
 pre(temp_2) = 0.0;
 pre(temp_3) = 0.0;
equation
 x = time - temp_3 * 2;
 y[1] = time - temp_2 * 2;
 y[2] = time - temp_1 * 2;
 temp_1 = if time / 2 < pre(temp_1) or time / 2 >= pre(temp_1) + 1 or initial() then floor(time / 2) else pre(temp_1);
 temp_2 = if time / 2 < pre(temp_2) or time / 2 >= pre(temp_2) + 1 or initial() then floor(time / 2) else pre(temp_2);
 temp_3 = if time / 2 < pre(temp_3) or time / 2 >= pre(temp_3) + 1 or initial() then floor(time / 2) else pre(temp_3);
end FunctionTests.FunctionLike.EventGen.Mod1;
			
")})));
end Mod1;

model Mod2
	constant Real x = mod(3.0,1.4);
	constant Real y = mod(-3.0,1.4);
	constant Real z = mod(3,-1.4);
	constant Integer a = mod(3,-5);

	annotation(__JModelica(UnitTesting(tests={
		EvalTestCase(
			name="FunctionLike_EventGen_Mod2",
			description="Evaluation of the mod operator.",
			variables="
x
y
z
a
",
			values="
0.20000000000000018
1.1999999999999993
-1.1999999999999993
-2
")})));
end Mod2;

model Rem1
	Real x    = rem(time, 2);
	Real y[2] = rem({time,time},2);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_EventGen_Rem1",
			description="Basic test of rem().",
			flatModel="
fclass FunctionTests.FunctionLike.EventGen.Rem1
 Real x;
 Real y[1];
 Real y[2];
 discrete Real temp_1;
 discrete Real temp_2;
 discrete Real temp_3;
initial equation 
 pre(temp_1) = 0.0;
 pre(temp_2) = 0.0;
 pre(temp_3) = 0.0;
equation
 x = time - temp_3 * 2;
 y[1] = time - temp_2 * 2;
 y[2] = time - temp_1 * 2;
 temp_1 = if div(time, 2) < pre(temp_1) or div(time, 2) >= pre(temp_1) + 1 or initial() then div(time, 2) else pre(temp_1);
 temp_2 = if div(time, 2) < pre(temp_2) or div(time, 2) >= pre(temp_2) + 1 or initial() then div(time, 2) else pre(temp_2);
 temp_3 = if div(time, 2) < pre(temp_3) or div(time, 2) >= pre(temp_3) + 1 or initial() then div(time, 2) else pre(temp_3);
end FunctionTests.FunctionLike.EventGen.Rem1;
			
")})));
end Rem1;

model Rem2
	constant Real x = rem(3.0,1.4);
	constant Real y = rem(-3.0,1.4);
	constant Real z = rem(3.0,-1.4);
	constant Integer a = rem(3,-5);
	
	annotation(__JModelica(UnitTesting(tests={
		EvalTestCase(
			name="FunctionLike_EventGen_Rem2",
			description="Evaluation of the rem operator.",
			variables="
x
y
z
a
",
			values="
0.20000000000000018
-0.20000000000000018
0.20000000000000018
3
")})));
end Rem2;

model Ceil1
	Real x = 4 + ceil((time * 0.3) + 4.2) * 4;
	Real y[2] = ceil({time,time*2});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_EventGen_Ceil1",
			description="Basic test of ceil().",
			flatModel="
fclass FunctionTests.FunctionLike.EventGen.Ceil1
 Real x;
 Real y[1];
 Real y[2];
 discrete Real temp_1;
 discrete Real temp_2;
 discrete Real temp_3;
initial equation 
 pre(temp_1) = 0.0;
 pre(temp_2) = 0.0;
 pre(temp_3) = 0.0;
equation
 x = 4 + temp_3 * 4;
 y[1] = temp_2;
 y[2] = temp_1;
 temp_1 = if time * 2 <= pre(temp_1) - 1 or time * 2 > pre(temp_1) or initial() then ceil(time * 2) else pre(temp_1);
 temp_2 = if time <= pre(temp_2) - 1 or time > pre(temp_2) or initial() then ceil(time) else pre(temp_2);
 temp_3 = if time * 0.3 + 4.2 <= pre(temp_3) - 1 or time * 0.3 + 4.2 > pre(temp_3) or initial() then ceil(time * 0.3 + 4.2) else pre(temp_3);
end FunctionTests.FunctionLike.EventGen.Ceil1;
			
")})));
end Ceil1;

model Ceil2
	constant Real x = ceil(42.9);
	constant Real y = ceil(42.0);

	annotation(__JModelica(UnitTesting(tests={
		EvalTestCase(
			name="FunctionLike_EventGen_Ceil2",
			description="Evaluation of the ceil operator.",
			variables="
x
y
",
			values="
43.0
42.0
")})));
end Ceil2;

model Floor1
	Real x = 4 + floor((time * 0.3) + 4.2) * 4;
	Real y[2] = floor({time,time*2});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_EventGen_Floor1",
			description="Basic test of floor().",
			flatModel="
fclass FunctionTests.FunctionLike.EventGen.Floor1
 Real x;
 Real y[1];
 Real y[2];
 discrete Real temp_1;
 discrete Real temp_2;
 discrete Real temp_3;
initial equation 
 pre(temp_1) = 0.0;
 pre(temp_2) = 0.0;
 pre(temp_3) = 0.0;
equation
 x = 4 + temp_3 * 4;
 y[1] = temp_2;
 y[2] = temp_1;
 temp_1 = if time * 2 < pre(temp_1) or time * 2 >= pre(temp_1) + 1 or initial() then floor(time * 2) else pre(temp_1);
 temp_2 = if time < pre(temp_2) or time >= pre(temp_2) + 1 or initial() then floor(time) else pre(temp_2);
 temp_3 = if time * 0.3 + 4.2 < pre(temp_3) or time * 0.3 + 4.2 >= pre(temp_3) + 1 or initial() then floor(time * 0.3 + 4.2) else pre(temp_3);
end FunctionTests.FunctionLike.EventGen.Floor1;
			
")})));
end Floor1;

model Floor2
	constant Real x = floor(42.9);
	constant Real y = floor(42.0);

	annotation(__JModelica(UnitTesting(tests={
		EvalTestCase(
			name="FunctionLike_EventGen_Floor2",
			description="Evaluation of the floor operator.",
			variables="
x
y
",
			values="
42.0
42.0
")})));
end Floor2;

model Integer1
	Real x = integer((0.9 + time/10) * 3.14);
	Real y[2] = integer({time,time*2});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_EventGen_Integer1",
			description="Basic test of integer().",
			flatModel="
fclass FunctionTests.FunctionLike.EventGen.Integer1
 Real x;
 Real y[1];
 Real y[2];
 discrete Integer temp_1;
 discrete Integer temp_2;
 discrete Integer temp_3;
initial equation 
 pre(temp_1) = 0;
 pre(temp_2) = 0;
 pre(temp_3) = 0;
equation
 x = temp_3;
 y[1] = temp_2;
 y[2] = temp_1;
 temp_1 = if time * 2 < pre(temp_1) or time * 2 >= pre(temp_1) + 1 or initial() then integer(time * 2) else pre(temp_1);
 temp_2 = if time < pre(temp_2) or time >= pre(temp_2) + 1 or initial() then integer(time) else pre(temp_2);
 temp_3 = if (0.9 + time / 10) * 3.14 < pre(temp_3) or (0.9 + time / 10) * 3.14 >= pre(temp_3) + 1 or initial() then integer((0.9 + time / 10) * 3.14) else pre(temp_3);
end FunctionTests.FunctionLike.EventGen.Integer1;
			
")})));
end Integer1;

model Integer2
	constant Integer x = integer(42.9);
	constant Integer y = integer(42.0);

	annotation(__JModelica(UnitTesting(tests={
		EvalTestCase(
			name="FunctionLike_EventGen_IntegerTest2",
			description="Evaluation of the integer operator.",
			variables="
x
y
",
			values="
42
42
")})));
end Integer2;

end EventGen;



package Math

model Sin
	Real x = sin(time);
	Real y[2] = sin({time,time*2});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_Math_Sin",
			description="Basic test of sin().",
			flatModel="
fclass FunctionTests.FunctionLike.Math.Sin
 Real x;
 Real y[1];
 Real y[2];
equation
 x = sin(time);
 y[1] = sin(time);
 y[2] = sin(time * 2);
end FunctionTests.FunctionLike.Math.Sin;
")})));
end Sin;

model Cos
	Real x = cos(time);
	Real y[2] = cos({time,time*2});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_Math_Cos",
			description="Basic test of cos().",
			flatModel="
fclass FunctionTests.FunctionLike.Math.Cos
 Real x;
 Real y[1];
 Real y[2];
equation
 x = cos(time);
 y[1] = cos(time);
 y[2] = cos(time * 2);
end FunctionTests.FunctionLike.Math.Cos;
")})));
end Cos;

model Tan
	Real x = tan(time);
	Real y[2] = tan({time,time*2});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_Math_Tan",
			description="Basic test of tan().",
			flatModel="
fclass FunctionTests.FunctionLike.Math.Tan
 Real x;
 Real y[1];
 Real y[2];
equation
 x = tan(time);
 y[1] = tan(time);
 y[2] = tan(time * 2);
end FunctionTests.FunctionLike.Math.Tan;
")})));
end Tan;

model Asin
	Real x = asin(time);
	Real y[2] = asin({time,time*2});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_Math_Asin",
			description="Basic test of asin().",
			flatModel="
fclass FunctionTests.FunctionLike.Math.Asin
 Real x;
 Real y[1];
 Real y[2];
equation
 x = asin(time);
 y[1] = asin(time);
 y[2] = asin(time * 2);
end FunctionTests.FunctionLike.Math.Asin;
")})));
end Asin;

model Acos
	Real x = acos(time);
	Real y[2] = acos({time,time*2});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_Math_Acos",
			description="Basic test of acos().",
			flatModel="
fclass FunctionTests.FunctionLike.Math.Acos
 Real x;
 Real y[1];
 Real y[2];
equation
 x = acos(time);
 y[1] = acos(time);
 y[2] = acos(time * 2);
end FunctionTests.FunctionLike.Math.Acos;
")})));
end Acos;

model Atan
	Real x = atan(time);
	Real y[2] = atan({time,time*2});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_Math_Atan",
			description="Basic test of atan().",
			flatModel="
fclass FunctionTests.FunctionLike.Math.Atan
 Real x;
 Real y[1];
 Real y[2];
equation
 x = atan(time);
 y[1] = atan(time);
 y[2] = atan(time * 2);
end FunctionTests.FunctionLike.Math.Atan;
")})));
end Atan;

model Atan2
	Real x = atan2(time,5);
	Real y[2] = atan2({time,time*2}, {5,6});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_Math_Atan2",
			description="Basic test of atan2().",
			flatModel="
fclass FunctionTests.FunctionLike.Math.Atan2
 Real x;
 Real y[1];
 Real y[2];
equation
 x = atan2(time, 5);
 y[1] = atan2(time, 5);
 y[2] = atan2(time * 2, 6);
end FunctionTests.FunctionLike.Math.Atan2;
")})));
end Atan2;

model Sinh
	Real x = sinh(time);
	Real y[2] = sinh({time,time*2});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_Math_Sinh",
			description="Basic test of sinh().",
			flatModel="
fclass FunctionTests.FunctionLike.Math.Sinh
 Real x;
 Real y[1];
 Real y[2];
equation
 x = sinh(time);
 y[1] = sinh(time);
 y[2] = sinh(time * 2);
end FunctionTests.FunctionLike.Math.Sinh;
")})));
end Sinh;

model Cosh
	Real x = cosh(time);
	Real y[2] = cosh({time,time*2});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_Math_Cosh",
			description="Basic test of cosh().",
			flatModel="
fclass FunctionTests.FunctionLike.Math.Cosh
 Real x;
 Real y[1];
 Real y[2];
equation
 x = cosh(time);
 y[1] = cosh(time);
 y[2] = cosh(time * 2);
end FunctionTests.FunctionLike.Math.Cosh;
")})));
end Cosh;

model Tanh
	Real x = tanh(time);
	Real y[2] = tanh({time,time*2});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_Math_Tanh",
			description="Basic test of tanh().",
			flatModel="
fclass FunctionTests.FunctionLike.Math.Tanh
 Real x;
 Real y[1];
 Real y[2];
equation
 x = tanh(time);
 y[1] = tanh(time);
 y[2] = tanh(time * 2);
end FunctionTests.FunctionLike.Math.Tanh;
")})));
end Tanh;

model Exp
	Real x = exp(time);
	Real y[2] = exp({time,time*2});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_Math_Exp",
			description="Basic test of exp().",
			flatModel="
fclass FunctionTests.FunctionLike.Math.Exp
 Real x;
 Real y[1];
 Real y[2];
equation
 x = exp(time);
 y[1] = exp(time);
 y[2] = exp(time * 2);
end FunctionTests.FunctionLike.Math.Exp;
")})));
end Exp;

model Log
	Real x = log(time);
	Real y[2] = log({time,time*2});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_Math_Log",
			description="Basic test of log().",
			flatModel="
fclass FunctionTests.FunctionLike.Math.Log
 Real x;
 Real y[1];
 Real y[2];
equation
 x = log(time);
 y[1] = log(time);
 y[2] = log(time * 2);
end FunctionTests.FunctionLike.Math.Log;
")})));
end Log;

model Log10
	Real x = log10(time);
	Real y[2] = log10({time,time*2});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_Math_Log10",
			description="Basic test of log10().",
			flatModel="
fclass FunctionTests.FunctionLike.Math.Log10
 Real x;
 Real y[1];
 Real y[2];
equation
 x = log10(time);
 y[1] = log10(time);
 y[2] = log10(time * 2);
end FunctionTests.FunctionLike.Math.Log10;
")})));
end Log10;

end Math;



package Special

model Homotopy1
  Real x = homotopy(sin(time*10) .+ 1, 1);
  Real y[2] = homotopy({sin(time*10),time} .+ 1, {1,1});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_Special_Homotopy1",
			description="Basic test of the homotopy() operator.",
			flatModel="
fclass FunctionTests.FunctionLike.Special.Homotopy1
 Real x;
 Real y[1];
 Real y[2];
equation
 x = sin(time * 10) .+ 1;
 y[1] = sin(time * 10) .+ 1;
 y[2] = time .+ 1;
end FunctionTests.FunctionLike.Special.Homotopy1;
")})));
end Homotopy1;

model Homotopy2
  Real x = homotopy(1,time);

  annotation(__JModelica(UnitTesting(tests={
		EvalTestCase(
			name="FunctionLike_Special_Homotopy2",
			description="Evaluation test of the homotopy() operator.",
			variables="
x
",
			values="
1.0
")})));
	  
end Homotopy2;

model SemiLinear1
  Real x = semiLinear(sin(time*10),2,-10);
  Real y[2] = semiLinear({sin(time*10),time},{2,2},{-10,3});
  parameter Real a;
  parameter Real p = semiLinear(a,1,2);
  discrete Real k;
initial equation
  k = semiLinear(time,1,2);
equation
	when time > 1 then
		k = semiLinear(time,1,2);
	end when;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_Special_SemiLinear1",
			description="Basic test of the semiLinear() operator.",
			flatModel="
fclass FunctionTests.FunctionLike.Special.SemiLinear1
 Real x;
 Real y[1];
 Real y[2];
 parameter Real a;
 parameter Real p;
 discrete Real k;
 discrete Boolean temp_1;
initial equation 
 k = if time >= 0.0 then time else time * 2;
 pre(temp_1) = false;
parameter equation
 p = if a >= 0.0 then a else a * 2;
equation
 temp_1 = time > 1;
 k = if temp_1 and not pre(temp_1) then if time >= 0.0 then time else time * 2 else pre(k);
 x = if sin(time * 10) >= 0.0 then sin(time * 10) * 2 else sin(time * 10) * -10;
 y[1] = if sin(time * 10) >= 0.0 then sin(time * 10) * 2 else sin(time * 10) * -10;
 y[2] = if time >= 0.0 then time * 2 else time * 3;
end FunctionTests.FunctionLike.Special.SemiLinear1;
			
")})));
end SemiLinear1;

model SemiLinear2
  Real x = semiLinear(1,2,3);

  annotation(__JModelica(UnitTesting(tests={
		EvalTestCase(
			name="FunctionLike_Special_SemiLinear2",
			description="Evaluation test of the semiLinear() operator.",
			variables="
x
",
			values="
2.0
")})));
	  
end SemiLinear2;

model SemiLinear3
  Real x = 0;
  Real y = 0;
  Real sa,sb;
  parameter Real p1(fixed=false);
  parameter Real p2 = 2;
  discrete Real r1,r2;
initial equation
	y = semiLinear(x,r1,r2);
	y = semiLinear(x,p1,p2);
equation
  sa = time;
  y = semiLinear(x,sa,sb);
  
  when time > 1 then
	  r2 = 2;
	  r1 = 2;
  end when;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_Special_SemiLinear3",
			description="Test of the semiLinear() operator.",
			flatModel="
fclass FunctionTests.FunctionLike.Special.SemiLinear3
 constant Real x = 0;
 constant Real y = 0;
 Real sa;
 Real sb;
 parameter Real p1(fixed = false);
 parameter Real p2 = 2 /* 2 */;
 discrete Real r1;
 discrete Real r2;
 discrete Boolean temp_1;
initial equation 
 r1 = r2;
 p1 = p2;
 pre(r2) = 0.0;
 pre(temp_1) = false;
equation
 sa = time;
 sa = sb;
 temp_1 = time > 1;
 r1 = if temp_1 and not pre(temp_1) then 2 else pre(r1);
 r2 = if temp_1 and not pre(temp_1) then 2 else pre(r2);
end FunctionTests.FunctionLike.Special.SemiLinear3;
			
")})));
end SemiLinear3;

end Special;



package EventRel

model NoEventArray1
	Real x[2] = {1, 2};
	Real y[2] = noEvent(x);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_EventRel_NoEventArray1",
			description="noEvent() for Real array",
			flatModel="
fclass FunctionTests.FunctionLike.EventRel.NoEventArray1
 constant Real x[1] = 1;
 constant Real x[2] = 2;
 constant Real y[1] = 1.0;
 constant Real y[2] = 2.0;
end FunctionTests.FunctionLike.EventRel.NoEventArray1;
")})));
end NoEventArray1;

model NoEventArray2
	parameter Boolean x[2] = {true, false};
	parameter Boolean y[2] = noEvent(x);  // Not very logical, but we need to test this

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_EventRel_NoEventArray2",
			description="noEvent() for Boolean array",
			flatModel="
fclass FunctionTests.FunctionLike.EventRel.NoEventArray2
 parameter Boolean x[1] = true /* true */;
 parameter Boolean x[2] = false /* false */;
 parameter Boolean y[1];
 parameter Boolean y[2];
parameter equation
 y[1] = noEvent(x[1]);
 y[2] = noEvent(x[2]);
end FunctionTests.FunctionLike.EventRel.NoEventArray2;
")})));
end NoEventArray2;

model NoEventRecord1
	record A
		Real a;
		Real b;
	end A;
	
	A x = A(1, 2);
	A y = noEvent(x);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_EventRel_NoEventRecord1",
			description="",
			flatModel="
fclass FunctionTests.FunctionLike.EventRel.NoEventRecord1
 constant Real x.a = 1;
 constant Real x.b = 2;
 constant Real y.a = 1.0;
 constant Real y.b = 2.0;

public
 record FunctionTests.FunctionLike.EventRel.NoEventRecord1.A
  Real a;
  Real b;
 end FunctionTests.FunctionLike.EventRel.NoEventRecord1.A;

end FunctionTests.FunctionLike.EventRel.NoEventRecord1;
")})));
end NoEventRecord1;

model Smooth
    Real x = smooth(2,time);
    Real y[3] = smooth(2, {1,2,3}*time);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_EventRel_Smooth",
			description="",
			flatModel="
fclass FunctionTests.FunctionLike.EventRel.Smooth
 Real x;
 Real y[1];
 Real y[2];
 Real y[3];
equation
 x = smooth(2, time);
 y[1] = smooth(2, time);
 y[2] = smooth(2, 2 * time);
 y[3] = smooth(2, 3 * time);
end FunctionTests.FunctionLike.EventRel.Smooth;
")})));
end Smooth;

model Smooth2
    Real a,b,c, d;
equation
    b = time;
    c = b * 2;
    d = c + b;
    a = smooth(0, if a < 0.65 then b / c * d else 0.42250000000000004 / b + d * (b - 0.65) / c);
    
	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_EventRel_Smooth2",
			description="",
			flatModel="
fclass FunctionTests.FunctionLike.EventRel.Smooth2
 Real a;
 Real b;
 Real c;
 Real d;
equation
 b = time;
 c = b * 2;
 d = c + b;
 a = smooth(0, if a < 0.65 then b / c * d else 0.42250000000000004 / b + d * (b - 0.65) / c);
end FunctionTests.FunctionLike.EventRel.Smooth2;
")})));
end Smooth2;

model Pre1
	discrete Integer x;
	Real y = pre(x);
	discrete Integer x2[2] = {x, x};
	Real y2[2] = pre(x2);
equation
	when time > 1 then
		x = 1;
	end when;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_EventRel_Pre1",
			description="pre(): basic test",
			eliminate_alias_variables=false,
			flatModel="
fclass FunctionTests.FunctionLike.EventRel.Pre1
 discrete Integer x;
 Real y;
 discrete Integer x2[1];
 discrete Integer x2[2];
 Real y2[1];
 Real y2[2];
 discrete Boolean temp_1;
initial equation 
 pre(x) = 0;
 pre(x2[1]) = 0;
 pre(x2[2]) = 0;
 pre(temp_1) = false;
equation
 temp_1 = time > 1;
 x = if temp_1 and not pre(temp_1) then 1 else pre(x);
 y = pre(x);
 x2[1] = x;
 x2[2] = x;
 y2[1] = pre(x2[1]);
 y2[2] = pre(x2[2]);
end FunctionTests.FunctionLike.EventRel.Pre1;
			
")})));
end Pre1;

model Pre2
	constant Real x = 42.9;
	constant Real y = pre(x);

	annotation(__JModelica(UnitTesting(tests={
		EvalTestCase(
			name="FunctionLike_EventRel_Pre2",
			description="Evaluation of the pre operator.",
			variables="y",
			values="42.9"
 )})));
end Pre2;

model Edge1
	Boolean x = time > 1;
	Boolean y = edge(x);
	Boolean x2[2] = {x, x};
	Boolean y2[2] = edge(x2);
equation

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_EventRel_Edge1",
			description="edge(): basic test",
			eliminate_alias_variables=false,
			flatModel="
fclass FunctionTests.FunctionLike.EventRel.Edge1
 discrete Boolean x;
 discrete Boolean y;
 discrete Boolean x2[1];
 discrete Boolean x2[2];
 discrete Boolean y2[1];
 discrete Boolean y2[2];
initial equation 
 pre(x) = false;
 pre(y) = false;
 pre(x2[1]) = false;
 pre(x2[2]) = false;
 pre(y2[1]) = false;
 pre(y2[2]) = false;
equation
 x = time > 1;
 y = x and not pre(x);
 x2[1] = x;
 x2[2] = x;
 y2[1] = x2[1] and not pre(x2[1]);
 y2[2] = x2[2] and not pre(x2[2]);
end FunctionTests.FunctionLike.EventRel.Edge1;
			
")})));
end Edge1;

model Edge2
	constant Boolean x = true;
	constant Boolean y = edge(x);

	annotation(__JModelica(UnitTesting(tests={
		EvalTestCase(
			name="FunctionLike_EventRel_Edge2",
			description="Evaluation of the edge operator.",
			variables="y",
			values="false")})));
end Edge2;

model Change1
	Real x = time;
	Boolean y;
	Real x2[2] = ones(2)*time;
	Boolean y2[2];
equation
	when time > 1 then
		y = change(x);
		y2 = change(x2);
	end when;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_EventRel_Change1",
			description="change(): basic test",
			flatModel="
fclass FunctionTests.FunctionLike.EventRel.Change1
 Real x;
 discrete Boolean y;
 Real x2[1];
 Real x2[2];
 discrete Boolean y2[1];
 discrete Boolean y2[2];
 discrete Boolean temp_1;
initial equation 
 pre(y) = false;
 pre(y2[1]) = false;
 pre(y2[2]) = false;
 pre(temp_1) = false;
equation
 temp_1 = time > 1;
 y = if temp_1 and not pre(temp_1) then x <> pre(x) else pre(y);
 y2[1] = if temp_1 and not pre(temp_1) then x2[1] <> pre(x2[1]) else pre(y2[1]);
 y2[2] = if temp_1 and not pre(temp_1) then x2[2] <> pre(x2[2]) else pre(y2[2]);
 x = time;
 x2[1] = time;
 x2[2] = time;
end FunctionTests.FunctionLike.EventRel.Change1;
			
")})));
end Change1;

model Change2
	constant Boolean x = true;
	constant Boolean y = change(x);

	annotation(__JModelica(UnitTesting(tests={
		EvalTestCase(
			name="FunctionLike_EventRel_Change2",
			description="Evaluation of the change operator.",
			variables="y",
			values="false"
 )})));
end Change2;

model SampleTest1
	Boolean x = sample(0, 1);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_EventRel_SampleTest1",
			description="sample(): basic test",
			flatModel="
fclass FunctionTests.FunctionLike.EventRel.SampleTest1
 discrete Boolean x;
initial equation 
 pre(x) = false;
equation
 x = sample(0, 1);
end FunctionTests.FunctionLike.EventRel.SampleTest1;
")})));
end SampleTest1;

end EventRel;

end FunctionLike;



end FunctionTests;
