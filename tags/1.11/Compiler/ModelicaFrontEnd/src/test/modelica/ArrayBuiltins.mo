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

within ;
package ArrayBuiltins
	
	

package Size
	
model SizeExp1
 Real x = size(ones(2), 1);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Size_SizeExp1",
			description="Size operator: first dim",
			flatModel="
fclass ArrayBuiltins.Size.SizeExp1
 constant Real x = 2;
end ArrayBuiltins.Size.SizeExp1;
")})));
end SizeExp1;


model SizeExp2
 Real x = size(ones(2, 3), 2);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Size_SizeExp2",
			description="Size operator: second dim",
			flatModel="
fclass ArrayBuiltins.Size.SizeExp2
 constant Real x = 3;
end ArrayBuiltins.Size.SizeExp2;
")})));
end SizeExp2;


model SizeExp3
 Real x[1] = size(ones(2));

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Size_SizeExp3",
			description="Size operator: without dim",
			flatModel="
fclass ArrayBuiltins.Size.SizeExp3
 constant Real x[1] = 2;
end ArrayBuiltins.Size.SizeExp3;
")})));
end SizeExp3;


model SizeExp4
 Real x[2] = size(ones(2, 3));

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Size_SizeExp4",
			description="Size operator: without dim",
			flatModel="
fclass ArrayBuiltins.Size.SizeExp4
 constant Real x[1] = 2;
 constant Real x[2] = 3;
end ArrayBuiltins.Size.SizeExp4;
")})));
end SizeExp4;


model SizeExp5
 parameter Integer p = 1;
 Real x = size(ones(2, 3), p);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Size_SizeExp5",
			description="Size operator: using parameter",
			flatModel="
fclass ArrayBuiltins.Size.SizeExp5
 parameter Integer p = 1 /* 1 */;
 constant Real x = 2;
end ArrayBuiltins.Size.SizeExp5;
")})));
end SizeExp5;


model SizeExp6
 Integer d = 1;
 Real x = size(ones(2, 3), d);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="SizeExp6",
			description="Size operator: too high variability of dim",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 793, column 11:
  Type error in expression: size(ones(2, 3), d)
")})));
end SizeExp6;


model SizeExp7
 Real x = size(ones(2, 3), {1, 2});

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="SizeExp7",
			description="Size operator: array as dim",
			errorMessage="
2 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 145, column 11:
  Type error in expression: size(ones(2, 3), {1, 2})
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 145, column 28:
  Calling function size(): types of positional argument 2 and input d are not compatible
")})));
end SizeExp7;


model SizeExp8
 Real x = size(ones(2, 3), 1.0);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="SizeExp8",
			description="Size operator: Real as dim",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 828, column 11:
  Type error in expression: size(ones(2, 3), 1.0)
")})));
end SizeExp8;


model SizeExp9
 Real x = size(ones(2, 3), 0);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="SizeExp9",
			description="Size operator: too low dim",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 844, column 11:
  Type error in expression: size(ones(2, 3), 0)
")})));
end SizeExp9;


model SizeExp10
 Real x = size(ones(2, 3), 3);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="SizeExp10",
			description="Size operator: too high dim",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 860, column 11:
  Type error in expression: size(ones(2, 3), 3)
")})));
end SizeExp10;


model SizeExp11
    model A
        Real x;
    end A;
    
    A[2] y(x = ones(z));
	parameter Integer z = size(y, 1);

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="Size_SizeExp11",
			description="",
			flatModel="
fclass ArrayBuiltins.Size.SizeExp11
 Real y[1].x = 1;
 Real y[2].x = 1;
 parameter Integer z = size(zeros(2), 1) /* 2 */;
end ArrayBuiltins.Size.SizeExp11;
")})));
end SizeExp11;


model SizeExp12
    record A
        Real x;
    end A;
    
    A[2] y = fill(A(1), size(y, 1));

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="Size_SizeExp12",
			description="Size operator: array of records",
			flatModel="
fclass ArrayBuiltins.Size.SizeExp12
 ArrayBuiltins.Size.SizeExp12.A y[2] = fill(ArrayBuiltins.Size.SizeExp12.A(1), size(y, 1));

public
 record ArrayBuiltins.Size.SizeExp12.A
  Real x;
 end ArrayBuiltins.Size.SizeExp12.A;

end ArrayBuiltins.Size.SizeExp12;
")})));
end SizeExp12;

end Size;



package Fill
	
model FillExp1
 Real x[2] = fill(1 + 2, 2);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Fill_FillExp1",
			description="Fill operator: one dim",
			flatModel="
fclass ArrayBuiltins.Fill.FillExp1
 constant Real x[1] = 3;
 constant Real x[2] = 3;
end ArrayBuiltins.Fill.FillExp1;
")})));
end FillExp1;


model FillExp2
 Real x[2,3,4] = fill(1 + 2, 2, 3, 4);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Fill_FillExp2",
			description="Fill operator: three dims",
			flatModel="
fclass ArrayBuiltins.Fill.FillExp2
 constant Real x[1,1,1] = 3;
 constant Real x[1,1,2] = 3;
 constant Real x[1,1,3] = 3;
 constant Real x[1,1,4] = 3;
 constant Real x[1,2,1] = 3;
 constant Real x[1,2,2] = 3;
 constant Real x[1,2,3] = 3;
 constant Real x[1,2,4] = 3;
 constant Real x[1,3,1] = 3;
 constant Real x[1,3,2] = 3;
 constant Real x[1,3,3] = 3;
 constant Real x[1,3,4] = 3;
 constant Real x[2,1,1] = 3;
 constant Real x[2,1,2] = 3;
 constant Real x[2,1,3] = 3;
 constant Real x[2,1,4] = 3;
 constant Real x[2,2,1] = 3;
 constant Real x[2,2,2] = 3;
 constant Real x[2,2,3] = 3;
 constant Real x[2,2,4] = 3;
 constant Real x[2,3,1] = 3;
 constant Real x[2,3,2] = 3;
 constant Real x[2,3,3] = 3;
 constant Real x[2,3,4] = 3;
end ArrayBuiltins.Fill.FillExp2;
")})));
end FillExp2;


model FillExp3
 Real x = fill(1 + 2);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="FillExp3",
			description="Fill operator: no size args",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 892, column 11:
  Too few arguments to fill(), must have at least 2
")})));
end FillExp3;


model FillExp4
 Real x[2] = fill(1 + 2, 3);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="FillExp4",
			description="Fill operator:",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 897, column 7:
  Array size mismatch in declaration of x, size of declaration is [2] and size of binding expression is [3]
")})));
end FillExp4;


model FillExp5
 Real x[2] = fill(1 + 2, 2.0);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="FillExp5",
			description="Fill operator: Real size arg",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 897, column 26:
  Argument of fill() is not compatible with Integer: 2.0
")})));
end FillExp5;


model FillExp6
 Integer n = 2;
 Real x[2] = fill(1 + 2, n);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="FillExp6",
			description="Fill operator: too high variability of size arg",
			errorMessage="
2 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 1145, column 7:
  Array size mismatch in declaration of x, size of declaration is [2] and size of binding expression is [n]
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 1145, column 26:
  Argument of fill() does not have constant or parameter variability: n
")})));
end FillExp6;


model FillExp7
 Real x[2] = fill();

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="FillExp7",
			description="Fill operator: no arguments at all",
			errorMessage="
2 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 1259, column 7:
  Array size mismatch in declaration of x, size of declaration is [2] and size of binding expression is scalar
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 1259, column 14:
  Calling function fill(): missing argument for required input s
")})));
end FillExp7;


model FillExp8
 Real x[3,2] = fill({1,2}, 3);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Fill_FillExp8",
			description="Fill operator: filling with array",
			flatModel="
fclass ArrayBuiltins.Fill.FillExp8
 constant Real x[1,1] = 1;
 constant Real x[1,2] = 2;
 constant Real x[2,1] = 1;
 constant Real x[2,2] = 2;
 constant Real x[3,1] = 1;
 constant Real x[3,2] = 2;
end ArrayBuiltins.Fill.FillExp8;
")})));
end FillExp8;
 
end Fill;



package Min
	
model MinExp1
 constant Real x = min(1+2, 3+4);
 Real y = x;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Min_MinExp1",
			description="Min operator: 2 scalar args",
			flatModel="
fclass ArrayBuiltins.Min.MinExp1
 constant Real x = min(1 + 2, 3 + 4);
 constant Real y = 3.0;
end ArrayBuiltins.Min.MinExp1;
")})));
end MinExp1;


model MinExp2
 constant Real x = min({{1,2},{3,4}});
 Real y = x;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Min_MinExp2",
			description="Min operator: 1 array arg",
			flatModel="
fclass ArrayBuiltins.Min.MinExp2
 constant Real x = min(min(min(1, 2), 3), 4);
 constant Real y = 1.0;
end ArrayBuiltins.Min.MinExp2;
")})));
end MinExp2;


model MinExp3
 constant String x = min("foo", "bar");
 parameter String y = x;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="MinExp3",
			description="Min operator: strings",
			flatModel="
fclass ArrayBuiltins.Min.MinExp3
 constant String x = min(\"foo\", \"bar\");
 parameter String y = \"bar\";
end ArrayBuiltins.Min.MinExp3;
")})));
end MinExp3;


model MinExp4
 constant Boolean x = min(true, false);
 Boolean y = x;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Min_MinExp4",
			description="Min operator: booleans",
			flatModel="
fclass ArrayBuiltins.Min.MinExp4
 constant Boolean x = min(true, false);
 constant Boolean y = false;
end ArrayBuiltins.Min.MinExp4;
")})));
end MinExp4;


model MinExp5
 Real x = min(true, 0);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="MinExp5",
			description="Min operator: mixed types",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 958, column 11:
  Type error in expression: min(true, 0)
")})));
end MinExp5;


model MinExp6
 Real x = min({1,2}, {3,4});

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="MinExp6",
			description="Min operator: 2 array args",
			errorMessage="
2 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 974, column 15:
  Calling function min(): types of positional argument 1 and input x are not compatible
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 974, column 22:
  Calling function min(): types of positional argument 2 and input y are not compatible
")})));
end MinExp6;


model MinExp7
 Real x = min(1);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="MinExp7",
			description="Min operator: 1 scalar arg",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 993, column 15:
  Calling function min(): types of positional argument 1 and input x are not compatible
")})));
end MinExp7;


model MinExp8
 constant Real x = min(1.0 for i in 1:4, j in {2,3,5});
 Real y = x;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Min_MinExp8",
			description="Reduction-expression with min(): constant expression",
			flatModel="
fclass ArrayBuiltins.Min.MinExp8
 constant Real x = min(min(min(min(min(min(min(min(min(min(min(1.0, 1.0), 1.0), 1.0), 1.0), 1.0), 1.0), 1.0), 1.0), 1.0), 1.0), 1.0);
 constant Real y = 1.0;
end ArrayBuiltins.Min.MinExp8;
")})));
end MinExp8;


model MinExp9
 Real x = min(i * j for i in 1:3, j in {2,3,5});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Min_MinExp9",
			description="Reduction-expression with min(): basic test",
			flatModel="
fclass ArrayBuiltins.Min.MinExp9
 constant Real x = 2;
end ArrayBuiltins.Min.MinExp9;
")})));
end MinExp9;


model MinExp10
 Real x = min(i * j for i in {{1,2},{3,4}}, j in 2);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="MinExp10",
			description="Reduction-expression with min(): non-vector index expressions",
			errorMessage="
2 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 589, column 25:
  The expression of for index i must be a vector expression: {{1, 2}, {3, 4}} has 2 dimension(s)
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 589, column 45:
  The expression of for index j must be a vector expression: 2 has 0 dimension(s)
")})));
end MinExp10;


model MinExp11
 Real x = min({i * j, 2} for i in 1:4, j in 2:5);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="MinExp11",
			description="Reduction-expression with min(): non-scalar expression",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 645, column 11:
  The expression of a reduction-expression must be scalar, except for sum(): {i * j, 2} has 1 dimension(s)
")})));
end MinExp11;


model MinExp12
 Real x = min(false for i in 1:4, j in 2:5);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="MinExp12",
			description="Reduction-expression with min(): wrong type in expression",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 1193, column 7:
  The binding expression of the variable x does not match the declared type of the variable
")})));
end MinExp12;

end Min;



package Max
	
model MaxExp1
 constant Real x = max(1+2, 3+4);
 Real y = x;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Max_MaxExp1",
			description="Max operator: 2 scalar args",
			flatModel="
fclass ArrayBuiltins.Max.MaxExp1
 constant Real x = max(1 + 2, 3 + 4);
 constant Real y = 7.0;
end ArrayBuiltins.Max.MaxExp1;
")})));
end MaxExp1;


model MaxExp2
 constant Real x = max({{1,2},{3,4}});
 Real y = x;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Max_MaxExp2",
			description="Max operator: 1 array arg",
			flatModel="
fclass ArrayBuiltins.Max.MaxExp2
 constant Real x = max(max(max(1, 2), 3), 4);
 constant Real y = 4.0;
end ArrayBuiltins.Max.MaxExp2;
")})));
end MaxExp2;


model MaxExp3
 constant String x = max("foo", "bar");
 parameter String y = x;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="MaxExp3",
			description="Max operator: strings",
			flatModel="
fclass ArrayBuiltins.Max.MaxExp3
 constant String x = max(\"foo\", \"bar\");
 parameter String y = \"foo\";
end ArrayBuiltins.Max.MaxExp3;
")})));
end MaxExp3;


model MaxExp4
 constant Boolean x = max(true, false);
 Boolean y = x;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Max_MaxExp4",
			description="Max operator: booleans",
			flatModel="
fclass ArrayBuiltins.Max.MaxExp4
 constant Boolean x = max(true, false);
 constant Boolean y = true;
end ArrayBuiltins.Max.MaxExp4;
")})));
end MaxExp4;


model MaxExp5
 Real x = max(true, 0);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="MaxExp5",
			description="Max operator: mixed types",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 958, column 11:
  Type error in expression: max(true, 0)
")})));
end MaxExp5;


model MaxExp6
 Real x = max({1,2}, {3,4});

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="MaxExp6",
			description="Max operator: 2 array args",
			errorMessage="
2 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 974, column 15:
  Calling function max(): types of positional argument 1 and input x are not compatible
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 974, column 22:
  Calling function max(): types of positional argument 2 and input y are not compatible
")})));
end MaxExp6;


model MaxExp7
 Real x = max(1);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="MaxExp7",
			description="Max operator: 1 scalar arg",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 993, column 15:
  Calling function max(): types of positional argument 1 and input x are not compatible
")})));
end MaxExp7;


model MaxExp8
 Real x = max(1.0 for i in 1:4, j in {2,3,5});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Max_MaxExp8",
			description="Reduction-expression with max(): constant expression",
			flatModel="
fclass ArrayBuiltins.Max.MaxExp8
 constant Real x = 1.0;
end ArrayBuiltins.Max.MaxExp8;
")})));
end MaxExp8;


model MaxExp9
 constant Real x = max(i * j for i in 1:4, j in {2,3,5});
 Real y = x;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Max_MaxExp9",
			description="Reduction-expression with max(): basic test",
			flatModel="
fclass ArrayBuiltins.Max.MaxExp9
 constant Real x = max(max(max(max(max(max(max(max(max(max(max(2, 2 * 2), 3 * 2), 4 * 2), 3), 2 * 3), 3 * 3), 4 * 3), 5), 2 * 5), 3 * 5), 4 * 5);
 constant Real y = 20.0;
end ArrayBuiltins.Max.MaxExp9;
")})));
end MaxExp9;


model MaxExp10
 Real x = max(i * j for i in {{1,2},{3,4}}, j in 2);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="MaxExp10",
			description="Reduction-expression with max(): non-vector index expressions",
			errorMessage="
2 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 812, column 25:
  The expression of for index i must be a vector expression: {{1, 2}, {3, 4}} has 2 dimension(s)
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 812, column 45:
  The expression of for index j must be a vector expression: 2 has 0 dimension(s)
")})));
end MaxExp10;


model MaxExp11
 Real x = max({i * j, 2} for i in 1:4, j in 2:5);
end MaxExp11;


model MaxExp12
 Real x = max(false for i in 1:4, j in 2:5);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="MaxExp12",
			description="Reduction-expression with max(): wrong type in expression",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 1462, column 7:
  The binding expression of the variable x does not match the declared type of the variable
")})));
end MaxExp12;

end Max;



package Sum
	
model SumExp1
 constant Real x = sum({1,2,3,4});
 Real y = x;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Sum_SumExp1",
			description="sum() expressions: basic test",
			flatModel="
fclass ArrayBuiltins.Sum.SumExp1
 constant Real x = 1 + 2 + 3 + 4;
 constant Real y = 10.0;
end ArrayBuiltins.Sum.SumExp1;
")})));
end SumExp1;


model SumExp2
 constant Real x = sum(i * j for i in 1:3, j in 1:3);
 Real y = x;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Sum_SumExp2",
			description="sum() expressions: reduction-expression",
			flatModel="
fclass ArrayBuiltins.Sum.SumExp2
 constant Real x = 1 + 2 + 3 + 2 + 2 * 2 + 3 * 2 + 3 + 2 * 3 + 3 * 3;
 constant Real y = 36.0;
end ArrayBuiltins.Sum.SumExp2;
")})));
end SumExp2;


model SumExp3
 constant Real x[2] = sum({i, j} for i in 1:3, j in 2:4);
 Real y[2] = x;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Sum_SumExp3",
			description="sum() expressions: reduction-expression over array",
			flatModel="
fclass ArrayBuiltins.Sum.SumExp3
 constant Real x[1] = 1 + 2 + 3 + 1 + 2 + 3 + 1 + 2 + 3;
 constant Real x[2] = 2 + 2 + 2 + 3 + 3 + 3 + 4 + 4 + 4;
 constant Real y[1] = 18.0;
 constant Real y[2] = 27.0;
end ArrayBuiltins.Sum.SumExp3;
")})));
end SumExp3;


model SumExp4
 constant Real x = sum( { {i, j} for i in 1:3, j in 2:4 } );
 Real y = x;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Sum_SumExp4",
			description="sum() expressions: over array constructor with iterators",
			flatModel="
fclass ArrayBuiltins.Sum.SumExp4
 constant Real x = 1 + 2 + 2 + 2 + 3 + 2 + 1 + 3 + 2 + 3 + 3 + 3 + 1 + 4 + 2 + 4 + 3 + 4;
 constant Real y = 45.0;
end ArrayBuiltins.Sum.SumExp4;
")})));
end SumExp4;


model SumExp5
 Real x = sum(1);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="Sum_SumExp5",
			description="sum() expressions: scalar input",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 878, column 15:
  Calling function sum(): types of positional argument 1 and input A are not compatible
")})));
end SumExp5;


model SumExp6
	parameter Integer N = 3;
	Real wbar[N];
	Real dMdt[N + 1] ;
equation
	dMdt = 1:(N + 1);
	for j in 1:N loop
		wbar[j] = sum(dMdt[1:j+1]) + dMdt[j] / 2;
	end for;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Sum_SumExp6",
			description="",
			flatModel="
fclass ArrayBuiltins.Sum.SumExp6
 parameter Integer N = 3 /* 3 */;
 constant Real wbar[1] = 3.5;
 constant Real wbar[2] = 7.0;
 constant Real wbar[3] = 11.5;
 constant Real dMdt[1] = 1;
 constant Real dMdt[2] = 2;
 constant Real dMdt[3] = 3;
 constant Real dMdt[4] = 4;
end ArrayBuiltins.Sum.SumExp6;
")})));
end SumExp6;


model SumExp7
	parameter Integer N = 3;
	Real wbar[N + 1];
	Real dMdt[N] ;
equation
	dMdt = 1:N;
	for j in 1:(N + 1) loop
		wbar[j] = sum(dMdt[1:j-1]) + dMdt[j] / 2;
	end for;
end SumExp7;


model SumExp8
	parameter Real x = sum(fill(2, 0));

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Sum_SumExp8",
			description="sum() expressions: empty array",
			flatModel="
fclass ArrayBuiltins.Sum.SumExp8
 parameter Real x = 0 /* 0 */;
end ArrayBuiltins.Sum.SumExp8;
")})));
end SumExp8;

end Sum;



package Product

model ProductExp1
 constant Real x = product({1,2,3,4});
 Real y = x;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Product_ProductExp1",
			description="product() expressions: basic test",
			flatModel="
fclass ArrayBuiltins.Product.ProductExp1
 constant Real x = 2 * 3 * 4;
 constant Real y = 24.0;
end ArrayBuiltins.Product.ProductExp1;
")})));
end ProductExp1;

model ProductExp2
 constant Real x = product(i * j for i in 1:3, j in 1:3);
 Real y = x;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Product_ProductExp2",
			description="product() expressions: reduction-expression",
			flatModel="
fclass ArrayBuiltins.Product.ProductExp2
 constant Real x = 2 * 3 * 2 * (2 * 2) * (3 * 2) * 3 * (2 * 3) * (3 * 3);
 constant Real y = 46656.0;
end ArrayBuiltins.Product.ProductExp2;
")})));
end ProductExp2;

model ProductExp3
 constant Real x[2] = product({i, j} for i in 1:3, j in 2:4);
 Real y[2] = x;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Product_ProductExp3",
			description="product() expressions: reduction-expression over array",
			flatModel="
fclass ArrayBuiltins.Product.ProductExp3
 constant Real x[1] = 2 * 3 * 2 * 3 * 2 * 3;
 constant Real x[2] = 2 * 2 * 2 * 3 * 3 * 3 * 4 * 4 * 4;
 constant Real y[1] = 216.0;
 constant Real y[2] = 13824.0;
end ArrayBuiltins.Product.ProductExp3;
")})));
end ProductExp3;

model ProductExp4
 constant Real x = product( { {i, j} for i in 1:3, j in 2:4 } );
 Real y = x;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Product_ProductExp4",
			description="product() expressions: over array constructor with iterators",
			flatModel="
fclass ArrayBuiltins.Product.ProductExp4
 constant Real x = 2 * 2 * 2 * 3 * 2 * 3 * 2 * 3 * 3 * 3 * 4 * 2 * 4 * 3 * 4;
 constant Real y = 2985984.0;
end ArrayBuiltins.Product.ProductExp4;
")})));
end ProductExp4;

model ProductExp5
 Real x = product();

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="Product_ProductExp5",
			description="product() expressions: no input",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 1005, column 11:
  Calling function product(): missing argument for required input A
")})));
end ProductExp5;

model ProductExp6
 Real x = product(42);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="Product_ProductExp6",
			description="product() expressions: scalar input",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 1020, column 19:
  Calling function product(): types of positional argument 1 and input A are not compatible
")})));
end ProductExp6;

model ProductExp7
 parameter Real x = product(fill(2, 0));

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Product_ProductExp7",
			description="product() expressions: empty array",
			flatModel="
fclass ArrayBuiltins.Product.ProductExp7
 parameter Real x = 1 /* 0 */;
end ArrayBuiltins.Product.ProductExp7;
")})));
end ProductExp7;

model ProductExp8
     function f
        input Real[:,:] x1;
        output Real y;
    algorithm
        y := product(x1);
    end f;

 parameter Real x = f({{1,2},{3,4}});
    

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Product_ProductExp8",
			description="product() expressions: in a function",
			flatModel="
fclass ArrayBuiltins.Product.ProductExp8
 parameter Real x = 24.0 /* 24.0 */;
end ArrayBuiltins.Product.ProductExp8;
")})));
end ProductExp8;

model ProductExp9
 function f
        input Real[:,:] x1;
        input Real[:,:] x2;
        output Real y;
    algorithm
        y := product(x1 + x2);
    end f;
 Real[2,2] v1 = {{1,2},{3,4}};
 Real[2,2] v2 = {{5,6},{7,8}};
 parameter Real x = f(v1,v2);
 
	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Product_ProductExp9",
			description="product() expressions: in a function",
			variability_propagation=false,
			flatModel="
fclass ArrayBuiltins.Product.ProductExp9
 Real v1[1,1];
 Real v1[1,2];
 Real v1[2,1];
 Real v1[2,2];
 Real v2[1,1];
 Real v2[1,2];
 Real v2[2,1];
 Real v2[2,2];
 parameter Real x;
parameter equation
 x = ArrayBuiltins.Product.ProductExp9.f({{v1[1,1], v1[1,2]}, {v1[2,1], v1[2,2]}}, {{v2[1,1], v2[1,2]}, {v2[2,1], v2[2,2]}});
equation
 v1[1,1] = 1;
 v1[1,2] = 2;
 v1[2,1] = 3;
 v1[2,2] = 4;
 v2[1,1] = 5;
 v2[1,2] = 6;
 v2[2,1] = 7;
 v2[2,2] = 8;

public
 function ArrayBuiltins.Product.ProductExp9.f
  input Real[:, :] x1;
  input Real[:, :] x2;
  output Real y;
  Real temp_1;
 algorithm
  temp_1 := 1;
  for i1 in 1:size(x1, 1) loop
   for i2 in 1:size(x1, 2) loop
    temp_1 := temp_1 * (x1[i1,i2] + x2[i1,i2]);
   end for;
  end for;
  y := temp_1;
  return;
 end ArrayBuiltins.Product.ProductExp9.f;

end ArrayBuiltins.Product.ProductExp9;
")})));
end ProductExp9;

end Product;



package Transpose
	
model Transpose1
 Real x[2,2] = transpose({{1,2},{3,4}});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Transpose_Transpose1",
			description="Scalarization of transpose operator: Integer[2,2]",
			flatModel="
fclass ArrayBuiltins.Transpose.Transpose1
 constant Real x[1,1] = 1;
 constant Real x[1,2] = 3;
 constant Real x[2,1] = 2;
 constant Real x[2,2] = 4;
end ArrayBuiltins.Transpose.Transpose1;
")})));
end Transpose1;


model Transpose2
 Real x[2,3] = transpose({{1,2},{3,4},{5,6}});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Transpose_Transpose2",
			description="Scalarization of transpose operator: Integer[3,2]",
			flatModel="
fclass ArrayBuiltins.Transpose.Transpose2
 constant Real x[1,1] = 1;
 constant Real x[1,2] = 3;
 constant Real x[1,3] = 5;
 constant Real x[2,1] = 2;
 constant Real x[2,2] = 4;
 constant Real x[2,3] = 6;
end ArrayBuiltins.Transpose.Transpose2;
")})));
end Transpose2;


model Transpose3
 Real x[2,1] = transpose({{1,2}});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Transpose_Transpose3",
			description="Scalarization of transpose operator: Integer[1,2]",
			flatModel="
fclass ArrayBuiltins.Transpose.Transpose3
 constant Real x[1,1] = 1;
 constant Real x[2,1] = 2;
end ArrayBuiltins.Transpose.Transpose3;
")})));
end Transpose3;


model Transpose4
 Integer x[2,2,2] = transpose({{{1,2},{3,4}},{{5,6},{7,8}}});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Transpose_Transpose4",
			description="Scalarization of transpose operator: Integer[2,2,2]",
			flatModel="
fclass ArrayBuiltins.Transpose.Transpose4
 constant Integer x[1,1,1] = 1;
 constant Integer x[1,1,2] = 2;
 constant Integer x[1,2,1] = 5;
 constant Integer x[1,2,2] = 6;
 constant Integer x[2,1,1] = 3;
 constant Integer x[2,1,2] = 4;
 constant Integer x[2,2,1] = 7;
 constant Integer x[2,2,2] = 8;
end ArrayBuiltins.Transpose.Transpose4;
")})));
end Transpose4;


model Transpose5
  Real x[2] = {1,2};
  Real y[2];
equation
  y=transpose(x)*x;

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="Transpose5",
			description="Scalarization of transpose operator: too few dimensions of arg",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 6377, column 15:
  Calling function transpose(): types of positional argument 1 and input A are not compatible
")})));
end Transpose5;


model Transpose6
 Real x[2] = transpose(1);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="Transpose6",
			description="Scalarization of transpose operator: Integer",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 4876, column 24:
  Calling function transpose(): types of positional argument 1 and input A are not compatible
")})));
end Transpose6;


model Transpose7
 Integer x[2,1] = transpose({{1.0,2}});

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="Transpose7",
			description="Scalarization of transpose operator: Real[1,2] -> Integer[2,1]",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 4892, column 10:
  The binding expression of the variable x does not match the declared type of the variable
")})));
end Transpose7;


model Transpose8
    Real[3,2] x = {{1,2},{3,4},{5,6}};
    Real[2,3] y = transpose(x) .+ 1;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Transpose_Transpose8",
			description="Scalarization of transpose operator: access to variable",
			flatModel="
fclass ArrayBuiltins.Transpose.Transpose8
 constant Real x[1,1] = 1;
 constant Real x[1,2] = 2;
 constant Real x[2,1] = 3;
 constant Real x[2,2] = 4;
 constant Real x[3,1] = 5;
 constant Real x[3,2] = 6;
 constant Real y[1,1] = 2.0;
 constant Real y[1,2] = 4.0;
 constant Real y[1,3] = 6.0;
 constant Real y[2,1] = 3.0;
 constant Real y[2,2] = 5.0;
 constant Real y[2,3] = 7.0;
end ArrayBuiltins.Transpose.Transpose8;
")})));
end Transpose8;

end Transpose;



package Cross
	
model Cross1
 Real x[3] = cross({1,2,3}, {4.0,5,6});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Cross_Cross1",
			description="cross() operator: Real result",
			flatModel="
fclass ArrayBuiltins.Cross.Cross1
 constant Real x[1] = -3;
 constant Real x[2] = 6.0;
 constant Real x[3] = -3.0;
end ArrayBuiltins.Cross.Cross1;
")})));
end Cross1; 


model Cross2
 Integer x[3] = cross({1,2,3}, {4,5,6});

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="Cross2",
			description="cross() operator: Integer result",
			flatModel="
fclass ArrayBuiltins.Cross.Cross2
 discrete Integer x[3] = cross({1,2,3}, {4,5,6});

end ArrayBuiltins.Cross.Cross2;
")})));
end Cross2; 


model Cross3
 Integer x[3] = cross({1.0,2,3}, {4,5,6});

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="Cross3",
			description="cross() operator: Real arg, assigning Integer component",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 6359, column 10:
  The binding expression of the variable x does not match the declared type of the variable
")})));
end Cross3; 


model Cross4
 Integer x = cross(1, 2);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="Cross4",
			description="cross() operator: scalar arguments",
			errorMessage="
2 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 6401, column 20:
  Calling function cross(): types of positional argument 1 and input x are not compatible
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 6401, column 23:
  Calling function cross(): types of positional argument 2 and input y are not compatible
")})));
end Cross4; 


model Cross5
 Integer x[4] = cross({1,2,3,4}, {4,5,6,7});

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="Cross5",
			description="cross() operator: Integer[4] arguments",
			errorMessage="
2 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 6437, column 23:
  Calling function cross(): types of positional argument 1 and input x are not compatible
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 6437, column 34:
  Calling function cross(): types of positional argument 2 and input y are not compatible
")})));
end Cross5; 


model Cross6
 String x[3] = cross({"1","2","3"}, {"4","5","6"});

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="Cross6",
			description="cross() operator: String[3] arguments",
			errorMessage="
2 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 6456, column 22:
  Calling function cross(): types of positional argument 1 and input x are not compatible
  Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 6456, column 37:
  Calling function cross(): types of positional argument 2 and input y are not compatible
")})));
end Cross6; 


model Cross7
 Integer x[3,3] = cross({{1,2,3},{1,2,3},{1,2,3}}, {{4,5,6},{4,5,6},{4,5,6}});

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="Cross7",
			description="cross() operator: too many dims",
			errorMessage="
2 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 6475, column 25:
  Calling function cross(): types of positional argument 1 and input x are not compatible
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 6475, column 52:
  Calling function cross(): types of positional argument 2 and input y are not compatible
")})));
end Cross7; 

end Cross;



package Skew

model Skew1
	Real x[3] = {1,2,3};
    Real y[3,3] = skew(x);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Skew_Skew1",
			description="skew() operator: basic test",
			eliminate_alias_variables=false,
			flatModel="
fclass ArrayBuiltins.Skew.Skew1
 constant Real x[1] = 1;
 constant Real x[2] = 2;
 constant Real x[3] = 3;
 constant Real y[1,1] = 0;
 constant Real y[1,2] = -3.0;
 constant Real y[1,3] = 2.0;
 constant Real y[2,1] = 3.0;
 constant Real y[2,2] = 0;
 constant Real y[2,3] = -1.0;
 constant Real y[3,1] = -2.0;
 constant Real y[3,2] = 1.0;
 constant Real y[3,3] = 0;
end ArrayBuiltins.Skew.Skew1;
")})));
end Skew1;


model Skew2
    Real x[3,3] = skew({1,2,3,4});
    String y[3,3] = skew({"1","2","3"});
	
	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="Skew_Skew2",
			description="skew() operator: bad arg",
			errorMessage="
2 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 1425, column 24:
  Calling function skew(): types of positional argument 1 and input x are not compatible
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 1426, column 26:
  Calling function skew(): types of positional argument 1 and input x are not compatible
")})));
end Skew2;

end Skew;



package OuterProduct
	
model OuterProduct1
 Real x[3,2] = outerProduct({1,2,3}, {4.0,5});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="OuterProduct_OuterProduct1",
			description="outerProduct() operator: basic test",
			flatModel="
fclass ArrayBuiltins.OuterProduct.OuterProduct1
 constant Real x[1,1] = 4.0;
 constant Real x[1,2] = 5;
 constant Real x[2,1] = 8.0;
 constant Real x[2,2] = 10;
 constant Real x[3,1] = 12.0;
 constant Real x[3,2] = 15;
end ArrayBuiltins.OuterProduct.OuterProduct1;
")})));
end OuterProduct1; 


model OuterProduct2
 Integer x[3,3] = outerProduct({1,2,3}, {4,5,6});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="OuterProduct_OuterProduct2",
			description="outerProduct() operator: basic test",
			flatModel="
fclass ArrayBuiltins.OuterProduct.OuterProduct2
 constant Integer x[1,1] = 4;
 constant Integer x[1,2] = 5;
 constant Integer x[1,3] = 6;
 constant Integer x[2,1] = 8;
 constant Integer x[2,2] = 10;
 constant Integer x[2,3] = 12;
 constant Integer x[3,1] = 12;
 constant Integer x[3,2] = 15;
 constant Integer x[3,3] = 18;
end ArrayBuiltins.OuterProduct.OuterProduct2;
")})));
end OuterProduct2; 


model OuterProduct3
 Integer x[3,3] = outerProduct({1.0,2,3}, {4,5,6});

	annotation(__JModelica(UnitTesting(tests={ 
		ErrorTestCase(
			name="OuterProduct3",
			description="outerProduct() operator: wrong numeric type",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 1463, column 19:
  The binding expression of the variable x does not match the declared type of the variable
")})));
end OuterProduct3; 


model OuterProduct4
 Integer x = outerProduct(1, 2);

	annotation(__JModelica(UnitTesting(tests={ 
		ErrorTestCase(
			name="OuterProduct4",
			description="outerProduct() operator: scalar arguments",
			errorMessage="
2 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 1479, column 27:
  Calling function outerProduct(): types of positional argument 1 and input x are not compatible
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 1479, column 30:
  Calling function outerProduct(): types of positional argument 2 and input y are not compatible
")})));
end OuterProduct4; 


model OuterProduct5
 String x[3,3] = outerProduct({"1","2","3"}, {"4","5","6"});

	annotation(__JModelica(UnitTesting(tests={ 
		ErrorTestCase(
			name="OuterProduct5",
			description="outerProduct() operator: wrong type",
			errorMessage="
2 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 1498, column 31:
  Calling function outerProduct(): types of positional argument 1 and input x are not compatible
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 1498, column 46:
  Calling function outerProduct(): types of positional argument 2 and input y are not compatible
")})));
end OuterProduct5; 


model OuterProduct6
 Integer x[3,3,3,3] = outerProduct({{1,2,3},{1,2,3},{1,2,3}}, {{4,5,6},{4,5,6},{4,5,6}});

	annotation(__JModelica(UnitTesting(tests={ 
		ErrorTestCase(
			name="OuterProduct6",
			description="outerProduct() operator: too many dims",
			errorMessage="
2 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 1517, column 36:
  Calling function outerProduct(): types of positional argument 1 and input x are not compatible
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 1517, column 63:
  Calling function outerProduct(): types of positional argument 2 and input y are not compatible
")})));
end OuterProduct6; 
		
end OuterProduct;


package Cat
	
model ArrayCat1
 Real x[5,2] = cat(1, {{1,2},{3,4}}, {{5,6}}, {{7,8},{9,0}});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Cat_ArrayCat1",
			description="cat() operator: basic test",
			flatModel="
fclass ArrayBuiltins.Cat.ArrayCat1
 constant Real x[1,1] = 1;
 constant Real x[1,2] = 2;
 constant Real x[2,1] = 3;
 constant Real x[2,2] = 4;
 constant Real x[3,1] = 5;
 constant Real x[3,2] = 6;
 constant Real x[4,1] = 7;
 constant Real x[4,2] = 8;
 constant Real x[5,1] = 9;
 constant Real x[5,2] = 0;
end ArrayBuiltins.Cat.ArrayCat1;
")})));
end ArrayCat1;


model ArrayCat2
 Real x[2,5] = cat(2, {{1.0,2.0},{6,7}}, {{3},{8}}, {{4,5},{9,0}});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Cat_ArrayCat2",
			description="cat() operator: basic test",
			flatModel="
fclass ArrayBuiltins.Cat.ArrayCat2
 constant Real x[1,1] = 1.0;
 constant Real x[1,2] = 2.0;
 constant Real x[1,3] = 3;
 constant Real x[1,4] = 4;
 constant Real x[1,5] = 5;
 constant Real x[2,1] = 6;
 constant Real x[2,2] = 7;
 constant Real x[2,3] = 8;
 constant Real x[2,4] = 9;
 constant Real x[2,5] = 0;
end ArrayBuiltins.Cat.ArrayCat2;
")})));
end ArrayCat2;


model ArrayCat3
 parameter String x[2,5] = cat(2, {{"1","2"},{"6","7"}}, {{"3"},{"8"}}, {{"4","5"},{"9","0"}});

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="ArrayCat3",
			description="cat() operator: using strings",
			flatModel="
fclass ArrayBuiltins.Cat.ArrayCat3
 parameter String x[2,5] = cat(2, {{\"1\",\"2\"},{\"6\",\"7\"}}, {{\"3\"},{\"8\"}}, {{\"4\",\"5\"},{\"9\",\"0\"}});

end ArrayBuiltins.Cat.ArrayCat3;
")})));
end ArrayCat3;


model ArrayCat4
 Integer x[5,2] = cat(2, {{1,2},{3,4}}, {{5,6,0}}, {{7,8},{9,0}});

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="ArrayCat4",
			description="cat() operator: size mismatch",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 6656, column 19:
  Types do not match in array concatenation
")})));
end ArrayCat4;


model ArrayCat5
 Integer x[2,5] = cat(2, {{1,2},{6,7}}, {{3},{8},{0}}, {{4,5},{9,0}});

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="ArrayCat5",
			description="cat() operator: size mismatch",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 6672, column 19:
  Types do not match in array concatenation
")})));
end ArrayCat5;


model ArrayCat6
 Integer x[2,5] = cat(2, {{1.0,2},{6,7}}, {{3},{8}}, {{4,5},{9,0}});

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="ArrayCat6",
			description="cat() operator: type mismatch",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 6688, column 10:
  The binding expression of the variable x does not match the declared type of the variable
")})));
end ArrayCat6;


model ArrayCat6b
 Integer x[2,5] = cat(2, {{"1","2"},{"6","7"}}, {{3},{8}}, {{4,5},{9,0}});

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="ArrayCat6b",
			description="cat() operator: type mismatch",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 6704, column 19:
  Types do not match in array concatenation
")})));
end ArrayCat6b;


model ArrayCat7
 Integer d = 1;
 Integer x[4] = cat(d, {1,2}, {4,5});

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="ArrayCat7",
			description="cat() operator: to high variability of dim",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 6721, column 17:
  Dimension argument of cat() does not have constant or parameter variability: d
")})));
end ArrayCat7;


model ArrayCat8
 parameter Integer d = 1;
 Integer x[4] = cat(d, {1,2}, {4,5});

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="ArrayCat8",
			description="cat() operator: parameter dim",
			flatModel="
fclass ArrayBuiltins.Cat.ArrayCat8
 parameter Integer d = 1 /* 1 */;
 discrete Integer x[4] = cat(d, {1,2}, {4,5});

end ArrayBuiltins.Cat.ArrayCat8;
")})));
end ArrayCat8;


model ArrayCat9
 Integer x[4] = cat(1.0, {1,2}, {4,5});

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="ArrayCat9",
			description="cat() operator: non-Integer dim",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 6743, column 17:
  Dimension argument of cat() is not compatible with Integer: 1.0
")})));
end ArrayCat9;


model ArrayCat10
  Real x[2] = cat(1, {1}, 2);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="ArrayCat10",
			description="Records:",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 6797, column 15:
  Types do not match in array concatenation
")})));
end ArrayCat10;



model ArrayShortCat1
 Real x[2,3] = [1,2,3; 4,5,6];

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Cat_ArrayShortCat1",
			description="Shorthand array concatenation operator: basic test",
			flatModel="
fclass ArrayBuiltins.Cat.ArrayShortCat1
 constant Real x[1,1] = 1;
 constant Real x[1,2] = 2;
 constant Real x[1,3] = 3;
 constant Real x[2,1] = 4;
 constant Real x[2,2] = 5;
 constant Real x[2,3] = 6;
end ArrayBuiltins.Cat.ArrayShortCat1;
")})));
end ArrayShortCat1;

model ArrayShortCat2
 Real x[3,3] = [a, b; c, d];
 Real a = 1;
 Real b[1,2] = {{2,3}};
 Real c[2] = {4,7};
 Real d[2,2] = {{5,6},{8,9}};

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Cat_ArrayShortCat2",
			description="Shorthand array concatenation operator: different sizes",
			flatModel="
fclass ArrayBuiltins.Cat.ArrayShortCat2
 constant Real x[1,1] = 1;
 constant Real x[1,2] = 2;
 constant Real x[1,3] = 3;
 constant Real x[2,1] = 4;
 constant Real x[2,2] = 5;
 constant Real x[2,3] = 6;
 constant Real x[3,1] = 7;
 constant Real x[3,2] = 8;
 constant Real x[3,3] = 9;
end ArrayBuiltins.Cat.ArrayShortCat2;
")})));
end ArrayShortCat2;


model ArrayShortCat3
 Real x[2,2,2,1] = [{{{{1},{2}}}}, {{{3,4}}}; {{{5,6}}}, {{{7,8}}}];

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Cat_ArrayShortCat3",
			description="Shorthand array concatenation operator: more than 2 dimensions",
			flatModel="
fclass ArrayBuiltins.Cat.ArrayShortCat3
 constant Real x[1,1,1,1] = 1;
 constant Real x[1,1,2,1] = 2;
 constant Real x[1,2,1,1] = 3;
 constant Real x[1,2,2,1] = 4;
 constant Real x[2,1,1,1] = 5;
 constant Real x[2,1,2,1] = 6;
 constant Real x[2,2,1,1] = 7;
 constant Real x[2,2,2,1] = 8;
end ArrayBuiltins.Cat.ArrayShortCat3;
")})));
end ArrayShortCat3;


model ArrayShortCat4
 Real x[2,3] = [{{1,2,3}}; {{4,5}}];

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="ArrayShortCat4",
			description="Shorthand array concatenation operator:",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 6862, column 16:
  Types do not match in array concatenation
")})));
end ArrayShortCat4;


model ArrayShortCat5
 Real x[3,2] = [{1,2,3}, {4,5}];

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="ArrayShortCat5",
			description="Shorthand array concatenation operator:",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 6878, column 17:
  Types do not match in array concatenation
")})));
end ArrayShortCat5;

end Cat;



package End
	
model ArrayEnd1
 Real x[4] = {1,2,3,4};
 Real y[2] = x[2:end-1] * 2;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="End_ArrayEnd1",
			description="end operator: basic test",
			flatModel="
fclass ArrayBuiltins.End.ArrayEnd1
 constant Real x[1] = 1;
 constant Real x[2] = 2;
 constant Real x[3] = 3;
 constant Real x[4] = 4;
 constant Real y[1] = 4.0;
 constant Real y[2] = 6.0;
end ArrayBuiltins.End.ArrayEnd1;
")})));
end ArrayEnd1;


model ArrayEnd2
 Real x[4] = {1,2,3,4};
 Real y = 2 - end;

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="ArrayEnd2",
			description="End operator: using in wrong place",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 6924, column 15:
  The end operator may only be used in array subscripts
")})));
end ArrayEnd2;


model ArrayEnd3
 constant Integer x1[4] = {1,2,3,4};
 Real x2[5] = {5,6,7,8,9};
 Real y[2] = x2[end.-x1[2:end-1]];

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="End_ArrayEnd3",
			description="End operator: nestled array subscripts",
			eliminate_alias_variables=false,
			flatModel="
fclass ArrayBuiltins.End.ArrayEnd3
 constant Integer x1[1] = 1;
 constant Integer x1[2] = 2;
 constant Integer x1[3] = 3;
 constant Integer x1[4] = 4;
 constant Real x2[1] = 5;
 constant Real x2[2] = 6;
 constant Real x2[3] = 7;
 constant Real x2[4] = 8;
 constant Real x2[5] = 9;
 constant Real y[1] = 7.0;
 constant Real y[2] = 6.0;
end ArrayBuiltins.End.ArrayEnd3;
")})));
end ArrayEnd3;

end End;



package DimensionConvert

model Scalar1
	Real[1,1,1] x = {{{1}}};
	Real y = scalar(x) + 1;
	Real z = scalar({{{{2}}}});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="DimensionConvert_Scalar1",
			description="Scalar operator: basic test",
			flatModel="
fclass ArrayBuiltins.DimensionConvert.Scalar1
 constant Real x[1,1,1] = 1;
 constant Real y = 2.0;
 constant Real z = 2;
end ArrayBuiltins.DimensionConvert.Scalar1;
")})));
end Scalar1;

model Scalar2
    Real[1,1,2] x = {{{1,2}}};
    Real y = scalar(x) + 1;
    Real z = scalar({{{{3},{4}}}});
	Real w = scalar(1);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="DimensionConvert_Scalar2",
			description="Scalar operator: bad size",
			errorMessage="
3 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 1795, column 21:
  Calling function scalar(): types of positional argument 1 and input A are not compatible
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 1796, column 21:
  Calling function scalar(): types of positional argument 1 and input A are not compatible
")})));
end Scalar2;


model Vector1
    Real[1,1,1] x = {{{1}}};
    Real[1] y = vector(x) .+ 1;
    Real[1] z = vector(2);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="DimensionConvert_Vector1",
			description="Vector operator: scalar arg",
			flatModel="
fclass ArrayBuiltins.DimensionConvert.Vector1
 constant Real x[1,1,1] = 1;
 constant Real y[1] = 2.0;
 constant Real z[1] = 2;
end ArrayBuiltins.DimensionConvert.Vector1;
")})));
end Vector1;

model Vector2
    Real[2] x = vector({1,2});
    Real[2] y = vector({{1},{2}});
    Real[2] z = vector({{1,2}});
    Real[2] w = vector({{{{1}},{{2}}}});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="DimensionConvert_Vector2",
			description="Vector operator: basic test",
			flatModel="
fclass ArrayBuiltins.DimensionConvert.Vector2
 constant Real x[1] = 1;
 constant Real x[2] = 2;
 constant Real y[1] = 1;
 constant Real y[2] = 2;
 constant Real z[1] = 1;
 constant Real z[2] = 2;
 constant Real w[1] = 1;
 constant Real w[2] = 2;
end ArrayBuiltins.DimensionConvert.Vector2;
")})));
end Vector2;

model Vector3
    Real[2] x = vector({{1,2},{3,4}});
    Real[2] y = vector({{{{{1},{2}}},{{{3},{4}}}}});

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="DimensionConvert_Vector3",
			description="Vector operator: bad size",
			errorMessage="
2 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 2069, column 24:
  Calling function vector(): types of positional argument 1 and input A are not compatible
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 2070, column 24:
  Calling function vector(): types of positional argument 1 and input A are not compatible
")})));
end Vector3;


model Matrix1
	Real[1,1] x = matrix(1);
    Real[2,1] y = matrix({1,2});
    Real[2,2] z = matrix({{1,2},{3,4}});
    Real[2,2] w = matrix({{{1},{2}},{{3},{4}}});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="DimensionConvert_Matrix1",
			description="Matrix operator: basic test",
			flatModel="
fclass ArrayBuiltins.DimensionConvert.Matrix1
 constant Real x[1,1] = 1;
 constant Real y[1,1] = 1;
 constant Real y[2,1] = 2;
 constant Real z[1,1] = 1;
 constant Real z[1,2] = 2;
 constant Real z[2,1] = 3;
 constant Real z[2,2] = 4;
 constant Real w[1,1] = 1;
 constant Real w[1,2] = 2;
 constant Real w[2,1] = 3;
 constant Real w[2,2] = 4;
end ArrayBuiltins.DimensionConvert.Matrix1;
")})));
end Matrix1;

model Matrix2
    Real[1,2] z = matrix({{{1,2},{3,4}}});

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="DimensionConvert_Matrix2",
			description="Matrix operator: bad size",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 2132, column 26:
  Calling function matrix(): types of positional argument 1 and input A are not compatible
")})));
end Matrix2;

end DimensionConvert;



model Linspace1
 Real x[4] = linspace(1, 3, 4);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Linspace1",
			description="Linspace operator: basic test",
			flatModel="
fclass ArrayBuiltins.Linspace1
 constant Real x[1] = 1;
 constant Real x[2] = 1.6666666666666665;
 constant Real x[3] = 2.333333333333333;
 constant Real x[4] = 3.0;
end ArrayBuiltins.Linspace1;
")})));
end Linspace1;


model Linspace2
 Real a = 1;
 Real b = 2;
 parameter Integer c = 3;
 Real x[3] = linspace(a, b, c);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Linspace2",
			description="Linspace operator: using parameter component as n",
			variability_propagation=false,
			eliminate_alias_variables=false,
			flatModel="
fclass ArrayBuiltins.Linspace2
 Real a;
 Real b;
 parameter Integer c = 3 /* 3 */;
 Real x[1];
 Real x[2];
 Real x[3];
equation
 a = 1;
 b = 2;
 x[1] = a;
 x[2] = a + (b - a) / 2;
 x[3] = a + 2 * ((b - a) / 2);
end ArrayBuiltins.Linspace2;
")})));
end Linspace2;


model Linspace3
 Real a = 1;
 Real b = 2;
 parameter Real c = 3;
 Real x[3] = linspace(a, b, c);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="Linspace3",
			description="Linspace operator: wrong type of n",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 7033, column 29:
  Calling function linspace(): types of positional argument 3 and input n are not compatible
")})));
end Linspace3;


model Linspace4
 Real a = 1;
 Real b = 2;
 Integer c = 3;
 Real x[3] = linspace(a, b, c);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="Linspace4",
			description="Linspace operator: wrong variability of n",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 7052, column 14:
  Type error in expression: linspace(a, b, c)
")})));
end Linspace4;


model Linspace5
 Integer x[4] = linspace(1, 3, 3);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="Linspace5",
			description="Linspace operator: using result as Integer",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 7057, column 10:
  The binding expression of the variable x does not match the declared type of the variable
")})));
end Linspace5;


model Linspace6
	model A
		parameter Real x;
	end A;
	
    parameter Real b = 1.5;
    parameter Real c = 3;
    parameter Integer d = 3;
	
	A a[d](x = linspace(b, c, d));

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Linspace6",
			description="Linspace operator: parameter args",
			flatModel="
fclass ArrayBuiltins.Linspace6
 parameter Real b = 1.5 /* 1.5 */;
 parameter Real c = 3 /* 3 */;
 parameter Integer d = 3 /* 3 */;
 parameter Real a[1].x;
 parameter Real a[2].x;
 parameter Real a[3].x;
parameter equation
 a[1].x = b;
 a[2].x = b + (c - b) / 2;
 a[3].x = b + 2 * ((c - b) / 2);
end ArrayBuiltins.Linspace6;
")})));
end Linspace6;



model NdimsExp1
 constant Integer n = ndims({{1,2},{3,4}});
 Integer x = n * 2;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="NdimsExp1",
			description="Ndims operator: basic test",
			flatModel="
fclass ArrayBuiltins.NdimsExp1
 constant Integer n = 2;
 constant Integer x = 4;
end ArrayBuiltins.NdimsExp1;
")})));
end NdimsExp1;

model ArrayIfExp1
  parameter Integer N = 3;
  parameter Real A[N,N] = identity(N);
  Real x[N](each start = 1);
equation
  der(x) = if time>=3 then A*x/N else -A*x/N;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayIfExp1",
			description="Array if expressions",
			automatic_add_initial_equations=false,
			flatModel="
fclass ArrayBuiltins.ArrayIfExp1
 parameter Integer N = 3 /* 3 */;
 parameter Real A[1,1] = 1 /* 1 */;
 parameter Real A[1,2] = 0 /* 0 */;
 parameter Real A[1,3] = 0 /* 0 */;
 parameter Real A[2,1] = 0 /* 0 */;
 parameter Real A[2,2] = 1 /* 1 */;
 parameter Real A[2,3] = 0 /* 0 */;
 parameter Real A[3,1] = 0 /* 0 */;
 parameter Real A[3,2] = 0 /* 0 */;
 parameter Real A[3,3] = 1 /* 1 */;
 Real x[1](start = 1);
 Real x[2](start = 1);
 Real x[3](start = 1);
equation
 der(x[1]) = if time >= 3 then (A[1,1] * x[1] + A[1,2] * x[2] + A[1,3] * x[3]) / 3 else ((- A[1,1]) * x[1] + (- A[1,2]) * x[2] + (- A[1,3]) * x[3]) / 3;
 der(x[2]) = if time >= 3 then (A[2,1] * x[1] + A[2,2] * x[2] + A[2,3] * x[3]) / 3 else ((- A[2,1]) * x[1] + (- A[2,2]) * x[2] + (- A[2,3]) * x[3]) / 3;
 der(x[3]) = if time >= 3 then (A[3,1] * x[1] + A[3,2] * x[2] + A[3,3] * x[3]) / 3 else ((- A[3,1]) * x[1] + (- A[3,2]) * x[2] + (- A[3,3]) * x[3]) / 3;
end ArrayBuiltins.ArrayIfExp1;
")})));
end ArrayIfExp1;


model ArrayIfExp2
  constant Real a = if 1 > 2 then 5 elseif 1 < 2 then 6 else 7;
  Real b = a;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayIfExp2",
			description="Constant evaluation of if expression",
			flatModel="
fclass ArrayBuiltins.ArrayIfExp2
 constant Real a = 6;
 constant Real b = 6.0;
end ArrayBuiltins.ArrayIfExp2;
")})));
end ArrayIfExp2;


model ArrayIfExp3
    parameter Real tableA[:, :] = fill(0.0, 0, 2);
    parameter Real tableB[:, :] = fill(1.0, 1, 2);
    parameter Boolean useTableA = false;
    Real y;
equation
    y = if useTableA then tableA[1, 1] else tableB[1, 1];

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="ArrayIfExp3",
			description="Eliminate branches causing index out of bounds",
			eliminate_alias_variables=false,
			flatModel="
fclass ArrayBuiltins.ArrayIfExp3
 parameter Real tableB[1,1] = 1.0 /* 1.0 */;
 parameter Real tableB[1,2] = 1.0 /* 1.0 */;
 parameter Boolean useTableA = false /* false */;
 parameter Real y;
parameter equation
 y = tableB[1,1];
end ArrayBuiltins.ArrayIfExp3;
")})));
end ArrayIfExp3;



model Identity1
  parameter Real A[3,3] = identity(3);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Identity1",
			description="identity() operator: basic test",
			flatModel="
fclass ArrayBuiltins.Identity1
 parameter Real A[1,1] = 1 /* 1.0 */;
 parameter Real A[1,2] = 0 /* 0.0 */;
 parameter Real A[1,3] = 0 /* 0.0 */;
 parameter Real A[2,1] = 0 /* 0.0 */;
 parameter Real A[2,2] = 1 /* 1.0 */;
 parameter Real A[2,3] = 0 /* 0.0 */;
 parameter Real A[3,1] = 0 /* 0.0 */;
 parameter Real A[3,2] = 0 /* 0.0 */;
 parameter Real A[3,3] = 1 /* 1.0 */;

end ArrayBuiltins.Identity1;
")})));
end Identity1;


model Identity2
  parameter Real A = identity(3);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="Identity2",
			description="identity() operator:",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 7207, column 18:
  Array size mismatch in declaration of A, size of declaration is scalar and size of binding expression is [3, 3]
")})));
end Identity2;


model Identity3
  Integer n = 3;
  parameter Real A[3,3] = identity(n);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="Identity3",
			description="identity() operator:",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 7224, column 27:
  Type error in expression: identity(n)
")})));
end Identity3;


model Identity4
  parameter Real A[3,3] = identity(3.0);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="Identity4",
			description="identity() operator:",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 7240, column 36:
  Calling function identity(): types of positional argument 1 and input n are not compatible
")})));
end Identity4;



model Diagonal1
	Real x[2,2] = diagonal({1,2});
    Integer y[3,3] = diagonal({1,2,3});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="Diagonal1",
			description="diagonal() operator: basic test",
			flatModel="
fclass ArrayBuiltins.Diagonal1
 constant Real x[1,1] = 1;
 constant Real x[1,2] = 0;
 constant Real x[2,1] = 0;
 constant Real x[2,2] = 2;
 constant Integer y[1,1] = 1;
 constant Integer y[1,2] = 0;
 constant Integer y[1,3] = 0;
 constant Integer y[2,1] = 0;
 constant Integer y[2,2] = 2;
 constant Integer y[2,3] = 0;
 constant Integer y[3,1] = 0;
 constant Integer y[3,2] = 0;
 constant Integer y[3,3] = 3;
end ArrayBuiltins.Diagonal1;
")})));
end Diagonal1;


model Diagonal2
    Real x[2,2] = diagonal({{1,2},{3,4}});
    Real y[:,:] = diagonal(1);
    Boolean z[2,2] = diagonal({true,true});

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="Diagonal2",
			description="diagonal() operator: wrong type of arg",
			errorMessage="
3 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 2508, column 28:
  Calling function diagonal(): types of positional argument 1 and input v are not compatible
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 2509, column 28:
  Calling function diagonal(): types of positional argument 1 and input v are not compatible
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 2510, column 31:
  Calling function diagonal(): types of positional argument 1 and input v are not compatible
")})));
end Diagonal2;



model ScalarSize1
  Real x[1] = cat(1, {1}, size(Modelica.Constants.pi));

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="ScalarSize1",
			description="Size of zero-length vector",
			flatModel="
fclass ArrayBuiltins.ScalarSize1
 Real x[1] = cat(1, {1}, size(3.141592653589793));

end ArrayBuiltins.ScalarSize1;
")})));
end ScalarSize1;


model ScalarSize2
  Real x[1] = {1} + Modelica.Constants.pi;

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="ScalarSize2",
			description="Size of scalar dotted access",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 7272, column 15:
  Type error in expression: {1} + Modelica.Constants.pi
")})));
end ScalarSize2;

model VectorizedAbsTest
    constant Real[2,2] c = {{-1, 2}, {3, -4}};
    constant Real[2,2] d = abs(c);
    Real[2,2] x = c;
    Real[2,2] y = d;
    Real[2,2] z = abs(x);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="VectorizedAbsTest",
			description="Test of vectorized abs()",
			flatModel="
fclass ArrayBuiltins.VectorizedAbsTest
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
end ArrayBuiltins.VectorizedAbsTest;
")})));
end VectorizedAbsTest;

model VectorizedSignTest
    constant Real[2,2] c = {{-1, 2}, {3, -4}};
    constant Real[2,2] d = sign(c);
    Real[2,2] x = c;
    Real[2,2] y = d;
    Real[2,2] z = sign(x);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="VectorizedSignTest",
			description="Test of vectorized sign()",
			flatModel="
fclass ArrayBuiltins.VectorizedSignTest
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
end ArrayBuiltins.VectorizedSignTest;
")})));
end VectorizedSignTest;

model VectorizedSmoothTest
    Real x[3] = {1,2,3};
    Real y[3] = smooth(2, x);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="VectorizedSmoothTest",
			description="",
			flatModel="
fclass ArrayBuiltins.VectorizedSmoothTest
 constant Real x[1] = 1;
 constant Real x[2] = 2;
 constant Real x[3] = 3;
 constant Real y[1] = 1.0;
 constant Real y[2] = 2.0;
 constant Real y[3] = 3.0;
end ArrayBuiltins.VectorizedSmoothTest;
")})));
end VectorizedSmoothTest;



model NonVectorizedSalarization1
    function f1
        input Real x1[3];
        output Real y1[3];
    algorithm
        y1 := f2(x1) * x1;
    end f1;
    
    function f2
        input Real x2[3];
        output Real y2;
    algorithm
        y2 := sum(x2);
    end f2;
    
    Real x[3] = {1,2,3};
    Real y[3] = f1(x);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="NonVectorizedSalarization1",
			description="Test of accesses that should be kept without indices during scalarization",
			flatModel="
fclass ArrayBuiltins.NonVectorizedSalarization1
 constant Real x[1] = 1;
 constant Real x[2] = 2;
 constant Real x[3] = 3;
 constant Real y[1] = 6.0;
 constant Real y[2] = 12.0;
 constant Real y[3] = 18.0;
end ArrayBuiltins.NonVectorizedSalarization1;
")})));
end NonVectorizedSalarization1;


model NonVectorizedSalarization2
    function f1
        input Real x1[:];
        output Real y1[size(x1,1)];
    algorithm
        y1 := f2(x1) * x1;
    end f1;
    
    function f2
        input Real x2[:];
        output Real y2;
    algorithm
        y2 := sum(x2);
    end f2;
    
    Real x[3] = {1,2,3};
    Real y[3] = f1(x);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="NonVectorizedSalarization2",
			description="Test of accesses that should be kept without indices during scalarization",
			flatModel="
fclass ArrayBuiltins.NonVectorizedSalarization2
 constant Real x[1] = 1;
 constant Real x[2] = 2;
 constant Real x[3] = 3;
 constant Real y[1] = 6.0;
 constant Real y[2] = 12.0;
 constant Real y[3] = 18.0;
end ArrayBuiltins.NonVectorizedSalarization2;
")})));
end NonVectorizedSalarization2;


model NonVectorizedSalarization3
    Real x[3] = {1,2,3};
    Real y[3] = Modelica.Math.Vectors.normalize(x);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="NonVectorizedSalarization3",
			description="Test of accesses that should be kept without indices during scalarization",
			variability_propagation=false,
			inline_functions="none",
			flatModel="
fclass ArrayBuiltins.NonVectorizedSalarization3
 Real x[1];
 Real x[2];
 Real x[3];
 Real y[1];
 Real y[2];
 Real y[3];
equation
 x[1] = 1;
 x[2] = 2;
 x[3] = 3;
 ({y[1], y[2], y[3]}) = Modelica.Math.Vectors.normalize({x[1], x[2], x[3]}, 100 * 1.0E-15);

public
 function Modelica.Math.Vectors.normalize
  input Real[:] v;
  input Real eps;
  output Real[size(v, 1)] result;
 algorithm
  for i1 in 1:size(result, 1) loop
   result[i1] := smooth(0, noEvent(if Modelica.Math.Vectors.length(v) >= eps then v[i1] / Modelica.Math.Vectors.length(v) else v[i1] / eps));
  end for;
  return;
 end Modelica.Math.Vectors.normalize;

 function Modelica.Math.Vectors.length
  input Real[:] v;
  output Real result;
  Real temp_1;
 algorithm
  temp_1 := 0.0;
  for i1 in 1:size(v, 1) loop
   temp_1 := temp_1 + v[i1] * v[i1];
  end for;
  result := sqrt(temp_1);
  return;
 end Modelica.Math.Vectors.length;

end ArrayBuiltins.NonVectorizedSalarization3;
")})));
end NonVectorizedSalarization3;


model InfArgsWithNamed
	Real x[2,2] = ones(2, 2, xxx = 3);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="InfArgsWithNamed",
			description="",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/ArrayBuiltins.mo':
Semantic error at line 2720, column 27:
  Calling function ones(): no input matching named argument xxx found
")})));
end InfArgsWithNamed;



package FunctionLike

package NumericConversion

model Abs
    Real x = abs(1);
    Real y[3] = abs({2,3,4});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_NumericConversion_Abs",
			description="Basic test of abs().",
			variability_propagation=false,
			flatModel="
fclass ArrayBuiltins.FunctionLike.NumericConversion.Abs
 Real x;
 Real y[1];
 Real y[2];
 Real y[3];
equation
 x = abs(1);
 y[1] = abs(2);
 y[2] = abs(3);
 y[3] = abs(4);
end ArrayBuiltins.FunctionLike.NumericConversion.Abs;
")})));
end Abs;

model Sign
    Real x = sign(1);
    Real y[3] = sign({2,3,4});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_NumericConversion_Sign",
			description="Basic test of sign().",
			variability_propagation=false,
			flatModel="
fclass ArrayBuiltins.FunctionLike.NumericConversion.Sign
 Real x;
 Real y[1];
 Real y[2];
 Real y[3];
equation
 x = sign(1);
 y[1] = sign(2);
 y[2] = sign(3);
 y[3] = sign(4);
end ArrayBuiltins.FunctionLike.NumericConversion.Sign;
")})));
end Sign;

model Sqrt
    Real x = sqrt(1);
    Real y[3] = sqrt({2,3,4});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_NumericConversion_Sqrt",
			description="Basic test of sqrt().",
			variability_propagation=false,
			flatModel="
fclass ArrayBuiltins.FunctionLike.NumericConversion.Sqrt
 Real x;
 Real y[1];
 Real y[2];
 Real y[3];
equation
 x = sqrt(1);
 y[1] = sqrt(2);
 y[2] = sqrt(3);
 y[3] = sqrt(4);
end ArrayBuiltins.FunctionLike.NumericConversion.Sqrt;
")})));
end Sqrt;

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
fclass ArrayBuiltins.FunctionLike.NumericConversion.Integer1
 Real x;
 Real y[1];
 Real y[2];
 Real y[3];
equation
 x = Integer(ArrayBuiltins.FunctionLike.NumericConversion.Integer1.E.x);
 y[1] = Integer(ArrayBuiltins.FunctionLike.NumericConversion.Integer1.E.a);
 y[2] = Integer(ArrayBuiltins.FunctionLike.NumericConversion.Integer1.E.b);
 y[3] = Integer(ArrayBuiltins.FunctionLike.NumericConversion.Integer1.E.c);

public
 type ArrayBuiltins.FunctionLike.NumericConversion.Integer1.E = enumeration(x, a, b, c);

end ArrayBuiltins.FunctionLike.NumericConversion.Integer1;
")})));
end Integer1;

end NumericConversion;



package EventGen
	
model Div
	Real x    = div(time, 2);
	Real y[2] = div({time,time},2);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_EventGen_Div",
			description="Basic test of div().",
			flatModel="
fclass ArrayBuiltins.FunctionLike.EventGen.Div
 Real x;
 Real y[1];
 Real y[2];
 discrete Real temp_1;
 discrete Real temp_2;
 discrete Real temp_3;
initial equation 
 temp_1 = div(time, 2);
 temp_2 = div(time, 2);
 temp_3 = div(time, 2);
equation
 x = temp_3;
 y[1] = temp_2;
 y[2] = temp_1;
 when {div(time, 2) < pre(temp_1), div(time, 2) >= pre(temp_1) + 1} then
  temp_1 = div(time, 2);
 end when;
 when {div(time, 2) < pre(temp_2), div(time, 2) >= pre(temp_2) + 1} then
  temp_2 = div(time, 2);
 end when;
 when {div(time, 2) < pre(temp_3), div(time, 2) >= pre(temp_3) + 1} then
  temp_3 = div(time, 2);
 end when;
end ArrayBuiltins.FunctionLike.EventGen.Div;
")})));
end Div;

model Mod
	Real x    = mod(time, 2);
	Real y[2] = mod({time,time},2);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_EventGen_Mod",
			description="Basic test of mod().",
			flatModel="
fclass ArrayBuiltins.FunctionLike.EventGen.Mod
 Real x;
 Real y[1];
 Real y[2];
 discrete Real temp_1;
 discrete Real temp_2;
 discrete Real temp_3;
initial equation 
 temp_1 = floor(time / 2);
 temp_2 = floor(time / 2);
 temp_3 = floor(time / 2);
equation
 x = time - temp_3 * 2;
 y[1] = time - temp_2 * 2;
 y[2] = time - temp_1 * 2;
 when {time / 2 < pre(temp_1), time / 2 >= pre(temp_1) + 1} then
  temp_1 = floor(time / 2);
 end when;
 when {time / 2 < pre(temp_2), time / 2 >= pre(temp_2) + 1} then
  temp_2 = floor(time / 2);
 end when;
 when {time / 2 < pre(temp_3), time / 2 >= pre(temp_3) + 1} then
  temp_3 = floor(time / 2);
 end when;
end ArrayBuiltins.FunctionLike.EventGen.Mod;
")})));
end Mod;

model Rem
	Real x    = rem(time, 2);
	Real y[2] = rem({time,time},2);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_EventGen_Rem",
			description="Basic test of rem().",
			flatModel="
fclass ArrayBuiltins.FunctionLike.EventGen.Rem
 Real x;
 Real y[1];
 Real y[2];
 discrete Real temp_1;
 discrete Real temp_2;
 discrete Real temp_3;
initial equation 
 temp_1 = div(time, 2);
 temp_2 = div(time, 2);
 temp_3 = div(time, 2);
equation
 x = time - temp_3 * 2;
 y[1] = time - temp_2 * 2;
 y[2] = time - temp_1 * 2;
 when {div(time, 2) < pre(temp_1), div(time, 2) >= pre(temp_1) + 1} then
  temp_1 = div(time, 2);
 end when;
 when {div(time, 2) < pre(temp_2), div(time, 2) >= pre(temp_2) + 1} then
  temp_2 = div(time, 2);
 end when;
 when {div(time, 2) < pre(temp_3), div(time, 2) >= pre(temp_3) + 1} then
  temp_3 = div(time, 2);
 end when;
end ArrayBuiltins.FunctionLike.EventGen.Rem;
")})));
end Rem;

model Ceil
	Real x = 4 + ceil((time * 0.3) + 4.2) * 4;
	Real y[2] = ceil({time,time*2});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_EventGen_Ceil",
			description="Basic test of ceil().",
			flatModel="
fclass ArrayBuiltins.FunctionLike.EventGen.Ceil
 Real x;
 Real y[1];
 Real y[2];
 discrete Real temp_1;
 discrete Real temp_2;
 discrete Real temp_3;
initial equation 
 temp_1 = ceil(time * 2);
 temp_2 = ceil(time);
 temp_3 = ceil(time * 0.3 + 4.2);
equation
 x = 4 + temp_3 * 4;
 y[1] = temp_2;
 y[2] = temp_1;
 when {time * 2 <= pre(temp_1) - 1, time * 2 > pre(temp_1)} then
  temp_1 = ceil(time * 2);
 end when;
 when {time <= pre(temp_2) - 1, time > pre(temp_2)} then
  temp_2 = ceil(time);
 end when;
 when {time * 0.3 + 4.2 <= pre(temp_3) - 1, time * 0.3 + 4.2 > pre(temp_3)} then
  temp_3 = ceil(time * 0.3 + 4.2);
 end when;
end ArrayBuiltins.FunctionLike.EventGen.Ceil;
")})));
end Ceil;

model Floor
	Real x = 4 + floor((time * 0.3) + 4.2) * 4;
	Real y[2] = floor({time,time*2});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_EventGen_Floor",
			description="Basic test of floor().",
			flatModel="
fclass ArrayBuiltins.FunctionLike.EventGen.Floor
 Real x;
 Real y[1];
 Real y[2];
 discrete Real temp_1;
 discrete Real temp_2;
 discrete Real temp_3;
initial equation 
 temp_1 = floor(time * 2);
 temp_2 = floor(time);
 temp_3 = floor(time * 0.3 + 4.2);
equation
 x = 4 + temp_3 * 4;
 y[1] = temp_2;
 y[2] = temp_1;
 when {time * 2 < pre(temp_1), time * 2 >= pre(temp_1) + 1} then
  temp_1 = floor(time * 2);
 end when;
 when {time < pre(temp_2), time >= pre(temp_2) + 1} then
  temp_2 = floor(time);
 end when;
 when {time * 0.3 + 4.2 < pre(temp_3), time * 0.3 + 4.2 >= pre(temp_3) + 1} then
  temp_3 = floor(time * 0.3 + 4.2);
 end when;
end ArrayBuiltins.FunctionLike.EventGen.Floor;
")})));
end Floor;

model Integer
	Real x = integer((0.9 + time/10) * 3.14);
	Real y[2] = integer({time,time*2});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_EventGen_Integer",
			description="Basic test of integer().",
			flatModel="
fclass ArrayBuiltins.FunctionLike.EventGen.Integer
 Real x;
 Real y[1];
 Real y[2];
 discrete Integer temp_1;
 discrete Integer temp_2;
 discrete Integer temp_3;
initial equation 
 temp_1 = integer(time * 2);
 temp_2 = integer(time);
 temp_3 = integer((0.9 + time / 10) * 3.14);
equation
 x = temp_3;
 y[1] = temp_2;
 y[2] = temp_1;
 when {time * 2 < pre(temp_1), time * 2 >= pre(temp_1) + 1} then
  temp_1 = integer(time * 2);
 end when;
 when {time < pre(temp_2), time >= pre(temp_2) + 1} then
  temp_2 = integer(time);
 end when;
 when {(0.9 + time / 10) * 3.14 < pre(temp_3), (0.9 + time / 10) * 3.14 >= pre(temp_3) + 1} then
  temp_3 = integer((0.9 + time / 10) * 3.14);
 end when;
end ArrayBuiltins.FunctionLike.EventGen.Integer;
")})));
end Integer;

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
fclass ArrayBuiltins.FunctionLike.Math.Sin
 Real x;
 Real y[1];
 Real y[2];
equation
 x = sin(time);
 y[1] = sin(time);
 y[2] = sin(time * 2);
end ArrayBuiltins.FunctionLike.Math.Sin;
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
fclass ArrayBuiltins.FunctionLike.Math.Cos
 Real x;
 Real y[1];
 Real y[2];
equation
 x = cos(time);
 y[1] = cos(time);
 y[2] = cos(time * 2);
end ArrayBuiltins.FunctionLike.Math.Cos;
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
fclass ArrayBuiltins.FunctionLike.Math.Tan
 Real x;
 Real y[1];
 Real y[2];
equation
 x = tan(time);
 y[1] = tan(time);
 y[2] = tan(time * 2);
end ArrayBuiltins.FunctionLike.Math.Tan;
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
fclass ArrayBuiltins.FunctionLike.Math.Asin
 Real x;
 Real y[1];
 Real y[2];
equation
 x = asin(time);
 y[1] = asin(time);
 y[2] = asin(time * 2);
end ArrayBuiltins.FunctionLike.Math.Asin;
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
fclass ArrayBuiltins.FunctionLike.Math.Acos
 Real x;
 Real y[1];
 Real y[2];
equation
 x = acos(time);
 y[1] = acos(time);
 y[2] = acos(time * 2);
end ArrayBuiltins.FunctionLike.Math.Acos;
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
fclass ArrayBuiltins.FunctionLike.Math.Atan
 Real x;
 Real y[1];
 Real y[2];
equation
 x = atan(time);
 y[1] = atan(time);
 y[2] = atan(time * 2);
end ArrayBuiltins.FunctionLike.Math.Atan;
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
fclass ArrayBuiltins.FunctionLike.Math.Atan2
 Real x;
 Real y[1];
 Real y[2];
equation
 x = atan2(time, 5);
 y[1] = atan2(time, 5);
 y[2] = atan2(time * 2, 6);
end ArrayBuiltins.FunctionLike.Math.Atan2;
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
fclass ArrayBuiltins.FunctionLike.Math.Sinh
 Real x;
 Real y[1];
 Real y[2];
equation
 x = sinh(time);
 y[1] = sinh(time);
 y[2] = sinh(time * 2);
end ArrayBuiltins.FunctionLike.Math.Sinh;
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
fclass ArrayBuiltins.FunctionLike.Math.Cosh
 Real x;
 Real y[1];
 Real y[2];
equation
 x = cosh(time);
 y[1] = cosh(time);
 y[2] = cosh(time * 2);
end ArrayBuiltins.FunctionLike.Math.Cosh;
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
fclass ArrayBuiltins.FunctionLike.Math.Tanh
 Real x;
 Real y[1];
 Real y[2];
equation
 x = tanh(time);
 y[1] = tanh(time);
 y[2] = tanh(time * 2);
end ArrayBuiltins.FunctionLike.Math.Tanh;
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
fclass ArrayBuiltins.FunctionLike.Math.Exp
 Real x;
 Real y[1];
 Real y[2];
equation
 x = exp(time);
 y[1] = exp(time);
 y[2] = exp(time * 2);
end ArrayBuiltins.FunctionLike.Math.Exp;
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
fclass ArrayBuiltins.FunctionLike.Math.Log
 Real x;
 Real y[1];
 Real y[2];
equation
 x = log(time);
 y[1] = log(time);
 y[2] = log(time * 2);
end ArrayBuiltins.FunctionLike.Math.Log;
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
fclass ArrayBuiltins.FunctionLike.Math.Log10
 Real x;
 Real y[1];
 Real y[2];
equation
 x = log10(time);
 y[1] = log10(time);
 y[2] = log10(time * 2);
end ArrayBuiltins.FunctionLike.Math.Log10;
")})));
end Log10;

end Math;



package Special

model SemiLinear1
  Real x = semiLinear(sin(time*10),2,-10);
  Real y[2] = semiLinear({sin(time*10),time},{2,2},{-10,3});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_Special_SemiLinear1",
			description="Basic test of the semiLinear() operator.",
			flatModel="
fclass ArrayBuiltins.FunctionLike.Special.SemiLinear1
 Real x;
 Real y[1];
 Real y[2];
equation
 x = if sin(time * 10) >= 0.0 then sin(time * 10) * 2 else sin(time * 10) * -10;
 y[1] = if sin(time * 10) >= 0.0 then sin(time * 10) * 2 else sin(time * 10) * -10;
 y[2] = if time >= 0.0 then time * 2 else time * 3;
end ArrayBuiltins.FunctionLike.Special.SemiLinear1;
")})));
end SemiLinear1;

model SemiLinear2
  Real x = 0;
  Real y = 0;
  Real sa,sb;
equation
  sa = time;
  y = semiLinear(x,sa,sb);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_Special_SemiLinear2",
			description="Test of the semiLinear() operator.",
			flatModel="
fclass ArrayBuiltins.FunctionLike.Special.SemiLinear2
 constant Real x = 0;
 constant Real y = 0;
 Real sa;
 Real sb;
equation
 sa = time;
 sa = sb;
end ArrayBuiltins.FunctionLike.Special.SemiLinear2;
")})));
end SemiLinear2;

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
fclass ArrayBuiltins.FunctionLike.EventRel.NoEventArray1
 constant Real x[1] = 1;
 constant Real x[2] = 2;
 constant Real y[1] = 1.0;
 constant Real y[2] = 2.0;
end ArrayBuiltins.FunctionLike.EventRel.NoEventArray1;
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
fclass ArrayBuiltins.FunctionLike.EventRel.NoEventArray2
 parameter Boolean x[1] = true /* true */;
 parameter Boolean x[2] = false /* false */;
 parameter Boolean y[1];
 parameter Boolean y[2];
parameter equation
 y[1] = noEvent(x[1]);
 y[2] = noEvent(x[2]);
end ArrayBuiltins.FunctionLike.EventRel.NoEventArray2;
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
fclass ArrayBuiltins.FunctionLike.EventRel.NoEventRecord1
 constant Real x.a = 1;
 constant Real x.b = 2;
 constant Real y.a = 1.0;
 constant Real y.b = 2.0;

public
 record ArrayBuiltins.FunctionLike.EventRel.NoEventRecord1.A
  Real a;
  Real b;
 end ArrayBuiltins.FunctionLike.EventRel.NoEventRecord1.A;

end ArrayBuiltins.FunctionLike.EventRel.NoEventRecord1;
")})));
end NoEventRecord1;

model PreTest1
	parameter Integer x = 1;
	Real y = pre(x);
	parameter Integer x2[2] = ones(2);
	Real y2[2] = pre(x2);
equation

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_EventRel_PreTest1",
			description="pre(): basic test",
			flatModel="
fclass ArrayBuiltins.FunctionLike.EventRel.PreTest1
 parameter Integer x = 1 /* 1 */;
 parameter Real y;
 parameter Integer x2[1] = 1 /* 1 */;
 parameter Integer x2[2] = 1 /* 1 */;
 parameter Real y2[1];
 parameter Real y2[2];
parameter equation
 y = pre(x);
 y2[1] = pre(x2[1]);
 y2[2] = pre(x2[2]);
end ArrayBuiltins.FunctionLike.EventRel.PreTest1;
")})));
end PreTest1;

model EdgeTest1
	parameter Boolean x = true;
	Boolean y = edge(x);
	parameter Boolean x2[2] = {true,true};
	Boolean y2[2] = edge(x2);
equation

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_EventRel_EdgeTest1",
			description="edge(): basic test",
			flatModel="
fclass ArrayBuiltins.FunctionLike.EventRel.EdgeTest1
 parameter Boolean x = true /* true */;
 parameter Boolean y;
 parameter Boolean x2[1] = true /* true */;
 parameter Boolean x2[2] = true /* true */;
 parameter Boolean y2[1];
 parameter Boolean y2[2];
parameter equation
 y = x and not pre(x);
 y2[1] = x2[1] and not pre(x2[1]);
 y2[2] = x2[2] and not pre(x2[2]);
end ArrayBuiltins.FunctionLike.EventRel.EdgeTest1;
")})));
end EdgeTest1;

model ChangeTest1
	parameter Real x = 1;
	Boolean y = change(x);
	parameter Real x2[2] = ones(2);
	Boolean y2[2] = change(x2);
equation

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_EventRel_ChangeTest1",
			description="change(): basic test",
			flatModel="
fclass ArrayBuiltins.FunctionLike.EventRel.ChangeTest1
 parameter Real x = 1 /* 1 */;
 parameter Boolean y;
 parameter Real x2[1] = 1 /* 1 */;
 parameter Real x2[2] = 1 /* 1 */;
 parameter Boolean y2[1];
 parameter Boolean y2[2];
parameter equation
 y = x <> pre(x);
 y2[1] = x2[1] <> pre(x2[1]);
 y2[2] = x2[2] <> pre(x2[2]);
end ArrayBuiltins.FunctionLike.EventRel.ChangeTest1;
")})));
end ChangeTest1;

model SampleTest1
	Boolean x = sample(0, 1);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="FunctionLike_EventRel_SampleTest1",
			description="sample(): basic test",
			flatModel="
fclass ArrayBuiltins.FunctionLike.EventRel.SampleTest1
 discrete Boolean x;
initial equation 
 pre(x) = false;
equation
 x = sample(0, 1);
end ArrayBuiltins.FunctionLike.EventRel.SampleTest1;
")})));
end SampleTest1;

end EventRel;

end FunctionLike;

end ArrayBuiltins;
