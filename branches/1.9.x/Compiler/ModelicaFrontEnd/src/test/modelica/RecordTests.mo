/*
    Copyright (C) 2009 Modelon AB

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

package RecordTests



model RecordFlat1
 record A
  Real a;
  Real b;
 end A;
 
 A x;
 A y;
equation
 y = x;

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="RecordFlat1",
			description="Records: basic flattening test",
			flatModel="
fclass RecordTests.RecordFlat1
 RecordTests.RecordFlat1.A x;
 RecordTests.RecordFlat1.A y;
equation
 y = x;

public
 record RecordTests.RecordFlat1.A
  Real a;
  Real b;
 end RecordTests.RecordFlat1.A;

end RecordTests.RecordFlat1;
")})));
end RecordFlat1;


model RecordFlat2
 record A
  Real a;
  Real b;
 end A;
 
 A x;
 A y;
equation
 y = x;
 x.a = 1;
 x.b = 2;

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="RecordFlat2",
			description="Records: accessing components",
			flatModel="
fclass RecordTests.RecordFlat2
 RecordTests.RecordFlat2.A x;
 RecordTests.RecordFlat2.A y;
equation
 y = x;
 x.a = 1;
 x.b = 2;

public
 record RecordTests.RecordFlat2.A
  Real a;
  Real b;
 end RecordTests.RecordFlat2.A;

end RecordTests.RecordFlat2;
")})));
end RecordFlat2;


model RecordFlat3
 record A
  Real a;
  Real b;
 end A;
 
 A x(a=1, b=2);
 A y;
equation
 y = x;

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="RecordFlat3",
			description="Records: modification",
			flatModel="
fclass RecordTests.RecordFlat3
 RecordTests.RecordFlat3.A x(a = 1,b = 2);
 RecordTests.RecordFlat3.A y;
equation
 y = x;

public
 record RecordTests.RecordFlat3.A
  Real a;
  Real b;
 end RecordTests.RecordFlat3.A;

end RecordTests.RecordFlat3;
")})));
end RecordFlat3;


model RecordFlat4
 record A
  Real a;
  Real b;
 end A;

 record B
  Real c;
  Real d;
 end B;
 
 B y;
 A x;

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="RecordFlat4",
			description="Records: two records",
			flatModel="
fclass RecordTests.RecordFlat4
 RecordTests.RecordFlat4.B y;
 RecordTests.RecordFlat4.A x;

public
 record RecordTests.RecordFlat4.B
  Real c;
  Real d;
 end RecordTests.RecordFlat4.B;

 record RecordTests.RecordFlat4.A
  Real a;
  Real b;
 end RecordTests.RecordFlat4.A;

end RecordTests.RecordFlat4;
")})));
end RecordFlat4;


model RecordFlat5
 record A
  Real a;
  B b;
 end A;
 
 record B
  Real c;
  Real d;
 end B;
 
 A x;

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="RecordFlat5",
			description="Records: nestled records",
			flatModel="
fclass RecordTests.RecordFlat5
 RecordTests.RecordFlat5.A x;

public
 record RecordTests.RecordFlat5.B
  Real c;
  Real d;
 end RecordTests.RecordFlat5.B;

 record RecordTests.RecordFlat5.A
  Real a;
  RecordTests.RecordFlat5.B b;
 end RecordTests.RecordFlat5.A;

end RecordTests.RecordFlat5;
")})));
end RecordFlat5;



model RecordType1
 record A
  Real a;
  Real b;
 end A;

 record B
  Real a;
  Real b;
 end B;
 
 A x;
 B y;
equation
 y = x;

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="RecordType1",
			description="Records: equivalent types",
			flatModel="
fclass RecordTests.RecordType1
 RecordTests.RecordType1.A x;
 RecordTests.RecordType1.B y;
equation
 y = x;

public
 record RecordTests.RecordType1.A
  Real a;
  Real b;
 end RecordTests.RecordType1.A;

 record RecordTests.RecordType1.B
  Real a;
  Real b;
 end RecordTests.RecordType1.B;

end RecordTests.RecordType1;
")})));
end RecordType1;


model RecordType2
 record A
  Real a;
  Real b;
 end A;

 record B
  Real a;
  Real c;
 end B;
 
 A x;
 B y;
equation
 y = x;

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="RecordType2",
			description="Records: non-equivalent types (component name)",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/RecordTests.mo':
Semantic error at line 246, column 2:
  The right and left expression types of equation are not compatible
")})));
end RecordType2;


model RecordType3
 record A
  Real a;
  Real b;
 end A;

 record B
  Real a;
  Boolean b;
 end B;
 
 A x;
 B y;
equation
 y = x;

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="RecordType3",
			description="Records: non-equivalent types (component type)",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/RecordTests.mo':
Semantic error at line 275, column 2:
  The right and left expression types of equation are not compatible
")})));
end RecordType3;


model RecordType4
 record A
  Real a;
  Real b;
 end A;

 record B
  Real a;
  Real b;
 end B;
 
 record C
  A a;
  Real e;
 end C;

 record D
  B a;
  Real e;
 end D;
 
 C x;
 D y;
equation
 y = x;

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="RecordType4",
			description="Records: equivalent nested types",
			flatModel="
fclass RecordTests.RecordType4
 RecordTests.RecordType4.C x;
 RecordTests.RecordType4.D y;
equation
 y = x;

public
 record RecordTests.RecordType4.A
  Real a;
  Real b;
 end RecordTests.RecordType4.A;

 record RecordTests.RecordType4.C
  RecordTests.RecordType4.A a;
  Real e;
 end RecordTests.RecordType4.C;

 record RecordTests.RecordType4.B
  Real a;
  Real b;
 end RecordTests.RecordType4.B;

 record RecordTests.RecordType4.D
  RecordTests.RecordType4.B a;
  Real e;
 end RecordTests.RecordType4.D;

end RecordTests.RecordType4;
")})));
end RecordType4;


model RecordType5
 record A
  Real a;
  Real b;
 end A;

 record B
  Real a;
  Real c;
 end B;
 
 record C
  A a;
  Real e;
 end C;

 record D
  B a;
  Real e;
 end D;
 
 C x;
 D y;
equation
 y = x;

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="RecordType5",
			description="Records: non-equivalent nested types",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/RecordTests.mo':
Semantic error at line 342, column 2:
  The right and left expression types of equation are not compatible
")})));
end RecordType5;


model RecordType6
 record A
  Real a;
  Real b;
 end A;

 record B
  extends C;
 end B;

 record C
  extends D;
  Real a;
 end C;

 record D
  Real b;
 end D;
 
 A x(a=1, b=2);
 B y;
equation
 y = x;		

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="RecordType6",
			description="Records: Inheritance",
			flatModel="
fclass RecordTests.RecordType6
 RecordTests.RecordType6.A x(a = 1,b = 2);
 RecordTests.RecordType6.B y;
equation
 y = x;

public
 record RecordTests.RecordType6.A
  Real a;
  Real b;
 end RecordTests.RecordType6.A;

 record RecordTests.RecordType6.B
  Real a;
  Real b;
 end RecordTests.RecordType6.B;

end RecordTests.RecordType6;
")})));
end RecordType6;


model RecordType7
	record A 
		Real x;
	end A;
	
	A a[:];

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="RecordType7",
			description="",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/RecordTests.mo':
Semantic error at line 458, column 7:
  Can not infer array size of the variable a
")})));
end RecordType7;



model RecordBinding1
 record A
  Real a;
  Real b;
 end A;
 
 A x = y;
 A y;

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="RecordBinding1",
			description="Records: binding expression, same record type",
			flatModel="
fclass RecordTests.RecordBinding1
 RecordTests.RecordBinding1.A x = y;
 RecordTests.RecordBinding1.A y;

public
 record RecordTests.RecordBinding1.A
  Real a;
  Real b;
 end RecordTests.RecordBinding1.A;

end RecordTests.RecordBinding1;
")})));
end RecordBinding1;


model RecordBinding2
 record A
  Real a;
  Real b;
 end A;

 record B
  Real a;
  Real b;
 end B;
 
 A x = y;
 B y;

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="RecordBinding2",
			description="Records: binding expression, equivalent record type",
			flatModel="
fclass RecordTests.RecordBinding2
 RecordTests.RecordBinding2.A x = y;
 RecordTests.RecordBinding2.B y;

public
 record RecordTests.RecordBinding2.A
  Real a;
  Real b;
 end RecordTests.RecordBinding2.A;

 record RecordTests.RecordBinding2.B
  Real a;
  Real b;
 end RecordTests.RecordBinding2.B;

end RecordTests.RecordBinding2;
")})));
end RecordBinding2;


model RecordBinding3
 record A
  Real a;
  Real b;
 end A;

 record B
  Real a;
  Real c;
 end B;
 
 A x = y;
 B y;

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="RecordBinding3",
			description="Records: binding expression, wrong type (incompatible record)",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/RecordTests.mo':
Semantic error at line 466, column 4:
  The binding expression of the variable x does not match the declared type of the variable
")})));
end RecordBinding3;


model RecordBinding4
 record A
  Real a;
  Real b;
 end A;
 
 A x = y;
 A y[2];

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="RecordBinding4",
			description="Records: binding expression, wrong array size",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/RecordTests.mo':
Semantic error at line 499, column 4:
  Array size mismatch in declaration of x, size of declaration is scalar and size of binding expression is [2]
")})));
end RecordBinding4;


model RecordBinding5
 record A
  Real a;
  Real b;
 end A;
 
 A x(a = 1, b = "foo");

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="RecordBinding5",
			description="Records: wrong type of binding exp of component",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/RecordTests.mo':
Semantic error at line 507, column 8:
  The binding expression of the variable b does not match the declared type of the variable
")})));
end RecordBinding5;



model RecordArray1
 record A
  Real a[2];
  Real b;
 end A;
 
 A x(a={1,2}, b=1);

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="RecordArray1",
			description="Record containing array: modification",
			flatModel="
fclass RecordTests.RecordArray1
 RecordTests.RecordArray1.A x(a = {1,2},b = 1);

public
 record RecordTests.RecordArray1.A
  Real a[2];
  Real b;
 end RecordTests.RecordArray1.A;

end RecordTests.RecordArray1;
")})));
end RecordArray1;


model RecordArray2
 record A
  Real a[2];
  Real b;
 end A;
 
 A x;
equation
 x.a[1] = 1;
 x.a[2] = 2;
 x.b = 1;

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="RecordArray2",
			description="Record containing array: equation with access",
			flatModel="
fclass RecordTests.RecordArray2
 RecordTests.RecordArray2.A x;
equation
 x.a[1] = 1;
 x.a[2] = 2;
 x.b = 1;

public
 record RecordTests.RecordArray2.A
  Real a[2];
  Real b;
 end RecordTests.RecordArray2.A;

end RecordTests.RecordArray2;
")})));
end RecordArray2;


model RecordArray3
 record A
  Real a[2];
  Real b;
 end A;
 
 A x;
 A y;
equation
 x = y;

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="RecordArray3",
			description="Record containing array: equation with other record",
			flatModel="
fclass RecordTests.RecordArray3
 RecordTests.RecordArray3.A x;
 RecordTests.RecordArray3.A y;
equation
 x = y;

public
 record RecordTests.RecordArray3.A
  Real a[2];
  Real b;
 end RecordTests.RecordArray3.A;

end RecordTests.RecordArray3;
")})));
end RecordArray3;


model RecordArray4
 record A
  Real a;
  Real b;
 end A;
 
 A x[2](each a=1, b={1,2});

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="RecordArray4",
			description="Array of records: modification",
			flatModel="
fclass RecordTests.RecordArray4
 RecordTests.RecordArray4.A x[2](each a = 1,b = {1,2});

public
 record RecordTests.RecordArray4.A
  Real a;
  Real b;
 end RecordTests.RecordArray4.A;

end RecordTests.RecordArray4;
")})));
end RecordArray4;


model RecordArray5
 record A
  Real a;
  Real b;
 end A;
 
 A x[2];
equation
 x[1].a = 1;
 x[1].b = 2;
 x[2].a = 3;
 x[2].b = 4;

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="RecordArray5",
			description="Array of records: accesses",
			flatModel="
fclass RecordTests.RecordArray5
 RecordTests.RecordArray5.A x[2];
equation
 x[1].a = 1;
 x[1].b = 2;
 x[2].a = 3;
 x[2].b = 4;

public
 record RecordTests.RecordArray5.A
  Real a;
  Real b;
 end RecordTests.RecordArray5.A;

end RecordTests.RecordArray5;
")})));
end RecordArray5;


model RecordArray6
    record A
        Real x;
        Real y;
        Real z;
    end A;
    
    constant A b[2,2];
    constant A c[2,2] = b;

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="RecordArray6",
			description="Constant array of records with missing binding expression",
			flatModel="
fclass RecordTests.RecordArray6
 constant RecordTests.RecordArray6.A b[2,2];
 constant RecordTests.RecordArray6.A c[2,2] = {{RecordTests.RecordArray6.A(0.0, 0.0, 0.0), RecordTests.RecordArray6.A(0.0, 0.0, 0.0)}, {RecordTests.RecordArray6.A(0.0, 0.0, 0.0), RecordTests.RecordArray6.A(0.0, 0.0, 0.0)}};

public
 record RecordTests.RecordArray6.A
  Real x;
  Real y;
  Real z;
 end RecordTests.RecordArray6.A;

end RecordTests.RecordArray6;
")})));
end RecordArray6;



model RecordConstructor1
 record A
  Real a;
  Integer b;
  parameter String c;
 end A;
 
 A x = A(1.0, 2, "foo");

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="RecordConstructor1",
			description="Record constructors: basic test",
			flatModel="
fclass RecordTests.RecordConstructor1
 RecordTests.RecordConstructor1.A x = RecordTests.RecordConstructor1.A(1.0, 2, \"foo\");

public
 record RecordTests.RecordConstructor1.A
  Real a;
  discrete Integer b;
  parameter String c;
 end RecordTests.RecordConstructor1.A;

end RecordTests.RecordConstructor1;
")})));
end RecordConstructor1;


model RecordConstructor2
 record A
  Real a;
  Integer b;
  parameter String c;
 end A;
 
 A x = A(c="foo", a=1.0, b=2);

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="RecordConstructor2",
			description="Record constructors: named args",
			flatModel="
fclass RecordTests.RecordConstructor2
 RecordTests.RecordConstructor2.A x = RecordTests.RecordConstructor2.A(1.0, 2, \"foo\");

public
 record RecordTests.RecordConstructor2.A
  Real a;
  discrete Integer b;
  parameter String c;
 end RecordTests.RecordConstructor2.A;

end RecordTests.RecordConstructor2;
")})));
end RecordConstructor2;


model RecordConstructor3
 record A
  Real a;
  Integer b = 0;
  constant String c = "foo";
 end A;
 
 A x = A(1, 2);

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="RecordConstructor3",
			description="Record constructors: default args",
			flatModel="
fclass RecordTests.RecordConstructor3
 RecordTests.RecordConstructor3.A x = RecordTests.RecordConstructor3.A(1, 2, \"foo\");

public
 record RecordTests.RecordConstructor3.A
  Real a;
  discrete Integer b = 0;
  constant String c = \"foo\";
 end RecordTests.RecordConstructor3.A;

end RecordTests.RecordConstructor3;
")})));
end RecordConstructor3;


model RecordConstructor4
 record A
  Real a;
  Integer b;
  parameter String c;
 end A;
 
 A x = A(1.0, 2, 3);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="RecordConstructor4",
			description="Record constructors: wrong type of arg",
			errorMessage="
2 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/RecordTests.mo':
Semantic error at line 775, column 18:
  Record constructor for A: types of positional argument 3 and input c are not compatible
")})));
end RecordConstructor4;


model RecordConstructor5
 record A
  Real a;
  Integer b;
  parameter String c;
 end A;
 
 A x = A(1.0, 2);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="RecordConstructor5",
			description="Record constructors: too few args",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/RecordTests.mo':
Semantic error at line 786, column 8:
  Record constructor for A: missing argument for required input c
")})));
end RecordConstructor5;


model RecordConstructor6
 record A
  Real a;
  Integer b;
  parameter String c;
 end A;
 
 A x = A(1.0, 2, "foo", 0);

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="RecordConstructor6",
			description="Record constructors: too many args",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/RecordTests.mo':
Semantic error at line 808, column 25:
  Record constructor for A: too many positional arguments
")})));
end RecordConstructor6;


model RecordConstructor7
    record A
        Real x;
    end A;
    
    record B
        extends A;
        Real y;
    end B;
    
    constant B b = B(y=2, x=1);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordConstructor7",
			description="Constant evaluation of record constructors for records with inherited components",
			flatModel="
fclass RecordTests.RecordConstructor7
 constant Real b.y = 2;
 constant Real b.x = 1;

public
 record RecordTests.RecordConstructor7.B
  Real y;
  Real x;
 end RecordTests.RecordConstructor7.B;

end RecordTests.RecordConstructor7;
")})));
end RecordConstructor7;



model RecordScalarize1
 record A
  Real a;
  Real b;
 end A;
 
 A x(a=1, b=2);
 A y;
equation
 y = x;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordScalarize1",
			description="Scalarization of records: modification",
			eliminate_alias_variables=false,
			flatModel="
fclass RecordTests.RecordScalarize1
 Real x.a;
 Real x.b;
 Real y.a;
 Real y.b;
equation
 y.a = x.a;
 y.b = x.b;
 x.a = 1;
 x.b = 2;

public
 record RecordTests.RecordScalarize1.A
  Real a;
  Real b;
 end RecordTests.RecordScalarize1.A;

end RecordTests.RecordScalarize1;
")})));
end RecordScalarize1;


model RecordScalarize2
 record A
  Real a;
  Real b;
 end A;
 
 A x;
 A y;
equation
 y = x;
 x.a = 1;
 x.b = 2;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordScalarize2",
			description="Scalarization of records: basic test",
			eliminate_alias_variables=false,
			flatModel="
fclass RecordTests.RecordScalarize2
 Real x.a;
 Real x.b;
 Real y.a;
 Real y.b;
equation
 y.a = x.a;
 y.b = x.b;
 x.a = 1;
 x.b = 2;

public
 record RecordTests.RecordScalarize2.A
  Real a;
  Real b;
 end RecordTests.RecordScalarize2.A;

end RecordTests.RecordScalarize2;
")})));
end RecordScalarize2;


model RecordScalarize3
 record A
  Real b;
  Real a;
 end A;
 
 A x = A(1, 2);
 A y;
equation
 y = x;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordScalarize3",
			description="Scalarization of records: record constructor",
			eliminate_alias_variables=false,
			flatModel="
fclass RecordTests.RecordScalarize3
 Real x.b;
 Real x.a;
 Real y.b;
 Real y.a;
equation
 y.b = x.b;
 y.a = x.a;
 x.b = 1;
 x.a = 2;

public
 record RecordTests.RecordScalarize3.A
  Real b;
  Real a;
 end RecordTests.RecordScalarize3.A;

end RecordTests.RecordScalarize3;
")})));
end RecordScalarize3;


model RecordScalarize4
 record A
  Real a;
  Real b;
 end A;

 record B
  Real c;
  Real d;
 end B;
 
 A x = A(1, 2);
 B y = B(3, 4);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordScalarize4",
			description="Scalarization of records: two different records, record constructors",
			eliminate_alias_variables=false,
			flatModel="
fclass RecordTests.RecordScalarize4
 Real x.a;
 Real x.b;
 Real y.c;
 Real y.d;
equation
 x.a = 1;
 x.b = 2;
 y.c = 3;
 y.d = 4;

public
 record RecordTests.RecordScalarize4.A
  Real a;
  Real b;
 end RecordTests.RecordScalarize4.A;

 record RecordTests.RecordScalarize4.B
  Real c;
  Real d;
 end RecordTests.RecordScalarize4.B;

end RecordTests.RecordScalarize4;
")})));
end RecordScalarize4;


model RecordScalarize5

 record A
  Real a;
  B b;
 end A;
 
 record B
  Real c;
  Real d;
 end B;
 
 A x = A(1, y);
 B y = B(2, 3);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordScalarize5",
			description="Scalarization of records: nestled records",
			eliminate_alias_variables=false,
			flatModel="
fclass RecordTests.RecordScalarize5
 Real x.a;
 Real x.b.c;
 Real x.b.d;
 Real y.c;
 Real y.d;
equation
 x.a = 1;
 x.b.c = y.c;
 x.b.d = y.d;
 y.c = 2;
 y.d = 3;

public
 record RecordTests.RecordScalarize5.B
  Real c;
  Real d;
 end RecordTests.RecordScalarize5.B;

 record RecordTests.RecordScalarize5.A
  Real a;
  RecordTests.RecordScalarize5.B b;
 end RecordTests.RecordScalarize5.A;

end RecordTests.RecordScalarize5;
")})));
end RecordScalarize5;


model RecordScalarize6
 record A
  Real a;
  Real b;
 end A;

 record B
  Real b;
  Real a;
 end B;
 
 A x = B(2, 1);
 B y;
equation
 y = x;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordScalarize6",
			description="Scalarization of records: equivalent records",
			eliminate_alias_variables=false,
			flatModel="
fclass RecordTests.RecordScalarize6
 Real x.a;
 Real x.b;
 Real y.b;
 Real y.a;
equation
 y.b = x.b;
 y.a = x.a;
 x.a = 1;
 x.b = 2;

public
 record RecordTests.RecordScalarize6.A
  Real a;
  Real b;
 end RecordTests.RecordScalarize6.A;

 record RecordTests.RecordScalarize6.B
  Real b;
  Real a;
 end RecordTests.RecordScalarize6.B;

end RecordTests.RecordScalarize6;
")})));
end RecordScalarize6;


model RecordScalarize7
 record A
  Real b;
  Real a;
 end A;

 record B
  Real a;
  Real b;
 end B;
 
 record C
  Real c;
  A x;
 end C;

 record D
  B x;
  Real c;
 end D;
 
 C x = D(B(3, 2), 1);
 D y;
equation
 y = x;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordScalarize7",
			description="Scalarization of records: equivalent nestled records",
			eliminate_alias_variables=false,
			flatModel="
fclass RecordTests.RecordScalarize7
 Real x.c;
 Real x.x.b;
 Real x.x.a;
 Real y.x.a;
 Real y.x.b;
 Real y.c;
equation
 y.x.a = x.x.a;
 y.x.b = x.x.b;
 y.c = x.c;
 x.c = 1;
 x.x.b = 2;
 x.x.a = 3;

public
 record RecordTests.RecordScalarize7.A
  Real b;
  Real a;
 end RecordTests.RecordScalarize7.A;

 record RecordTests.RecordScalarize7.C
  Real c;
  RecordTests.RecordScalarize7.A x;
 end RecordTests.RecordScalarize7.C;

 record RecordTests.RecordScalarize7.B
  Real a;
  Real b;
 end RecordTests.RecordScalarize7.B;

 record RecordTests.RecordScalarize7.D
  RecordTests.RecordScalarize7.B x;
  Real c;
 end RecordTests.RecordScalarize7.D;

end RecordTests.RecordScalarize7;
")})));
end RecordScalarize7;


model RecordScalarize8
 record A
  Real a[2];
  Real b;
 end A;
 
 A x(a={1,2}, b=1);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordScalarize8",
			description="Scalarization of records: modification of array component",
			flatModel="
fclass RecordTests.RecordScalarize8
 Real x.a[1];
 Real x.a[2];
 Real x.b;
equation
 x.a[1] = 1;
 x.a[2] = 2;
 x.b = 1;

public
 record RecordTests.RecordScalarize8.A
  Real a[2];
  Real b;
 end RecordTests.RecordScalarize8.A;

end RecordTests.RecordScalarize8;
")})));
end RecordScalarize8;


model RecordScalarize9
 record A
  Real a[2];
  Real b;
 end A;
 
 A x;
equation
 x.a[1] = 1;
 x.a[2] = 2;
 x.b = 1;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordScalarize9",
			description="Scalarization of records: record containing array",
			flatModel="
fclass RecordTests.RecordScalarize9
 Real x.a[1];
 Real x.a[2];
 Real x.b;
equation
 x.a[1] = 1;
 x.a[2] = 2;
 x.b = 1;

public
 record RecordTests.RecordScalarize9.A
  Real a[2];
  Real b;
 end RecordTests.RecordScalarize9.A;

end RecordTests.RecordScalarize9;
")})));
end RecordScalarize9;


model RecordScalarize10
 record A
  Real a[2];
  Real b;
 end A;
 
 A x = A({1,2}, 3);
 A y;
equation
 x = y;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordScalarize10",
			description="Scalarization of records: record containing array, using record constructor",
			eliminate_alias_variables=false,
			flatModel="
fclass RecordTests.RecordScalarize10
 Real x.a[1];
 Real x.a[2];
 Real x.b;
 Real y.a[1];
 Real y.a[2];
 Real y.b;
equation
 x.a[1] = y.a[1];
 x.a[2] = y.a[2];
 x.b = y.b;
 x.a[1] = 1;
 x.a[2] = 2;
 x.b = 3;

public
 record RecordTests.RecordScalarize10.A
  Real a[2];
  Real b;
 end RecordTests.RecordScalarize10.A;

end RecordTests.RecordScalarize10;
")})));
end RecordScalarize10;


model RecordScalarize11
 record A
  Real a;
  Real b;
 end A;
 
 A x[2](each a=1, b={1,2});
end RecordScalarize11;


model RecordScalarize12
 record A
  Real a;
  Real b;
 end A;
 
 A x[2];
equation
 x[1].a = 1;
 x[1].b = 2;
 x[2].a = 3;
 x[2].b = 4;

	annotation(__JModelica(UnitTesting(tests={
		FlatteningTestCase(
			name="RecordScalarize12",
			description="Scalarization of records: array of records",
			flatModel="
fclass RecordTests.RecordScalarize12
 RecordTests.RecordScalarize12.A x[2];
equation
 x[1].a = 1;
 x[1].b = 2;
 x[2].a = 3;
 x[2].b = 4;

public
 record RecordTests.RecordScalarize12.A
  Real a;
  Real b;
 end RecordTests.RecordScalarize12.A;

end RecordTests.RecordScalarize12;
")})));
end RecordScalarize12;


model RecordScalarize13
 record A
  Real a;
  Real b;
 end A;
 
 A x[2] = {A(1,2), A(3,4)};
 A y[2];
equation
 x = y;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordScalarize13",
			description="Scalarization of records: arrays of records, binding exp + record equation",
			eliminate_alias_variables=false,
			flatModel="
fclass RecordTests.RecordScalarize13
 Real x[1].a;
 Real x[1].b;
 Real x[2].a;
 Real x[2].b;
 Real y[1].a;
 Real y[1].b;
 Real y[2].a;
 Real y[2].b;
equation
 x[1].a = y[1].a;
 x[1].b = y[1].b;
 x[2].a = y[2].a;
 x[2].b = y[2].b;
 x[1].a = 1;
 x[2].a = 3;
 x[1].b = 2;
 x[2].b = 4;

public
 record RecordTests.RecordScalarize13.A
  Real a;
  Real b;
 end RecordTests.RecordScalarize13.A;

end RecordTests.RecordScalarize13;
")})));
end RecordScalarize13;


model RecordScalarize14
 record A
  B b[2];
 end A;
 
 record B
  Real a[2];
 end B;
 
 A x[2] = { A({ B({1,2}), B({3,4}) }), A({ B({5,6}), B({7,8}) }) };
 A y[2];
equation
 x = y;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordScalarize14",
			description="Scalarization of records: nestled records and arrays",
			eliminate_alias_variables=false,
			flatModel="
fclass RecordTests.RecordScalarize14
 Real x[1].b[1].a[1];
 Real x[1].b[1].a[2];
 Real x[1].b[2].a[1];
 Real x[1].b[2].a[2];
 Real x[2].b[1].a[1];
 Real x[2].b[1].a[2];
 Real x[2].b[2].a[1];
 Real x[2].b[2].a[2];
 Real y[1].b[1].a[1];
 Real y[1].b[1].a[2];
 Real y[1].b[2].a[1];
 Real y[1].b[2].a[2];
 Real y[2].b[1].a[1];
 Real y[2].b[1].a[2];
 Real y[2].b[2].a[1];
 Real y[2].b[2].a[2];
equation
 x[1].b[1].a[1] = y[1].b[1].a[1];
 x[1].b[1].a[2] = y[1].b[1].a[2];
 x[1].b[2].a[1] = y[1].b[2].a[1];
 x[1].b[2].a[2] = y[1].b[2].a[2];
 x[2].b[1].a[1] = y[2].b[1].a[1];
 x[2].b[1].a[2] = y[2].b[1].a[2];
 x[2].b[2].a[1] = y[2].b[2].a[1];
 x[2].b[2].a[2] = y[2].b[2].a[2];
 x[1].b[1].a[1] = 1;
 x[1].b[1].a[2] = 2;
 x[1].b[2].a[1] = 3;
 x[1].b[2].a[2] = 4;
 x[2].b[1].a[1] = 5;
 x[2].b[1].a[2] = 6;
 x[2].b[2].a[1] = 7;
 x[2].b[2].a[2] = 8;

public
 record RecordTests.RecordScalarize14.B
  Real a[2];
 end RecordTests.RecordScalarize14.B;

 record RecordTests.RecordScalarize14.A
  RecordTests.RecordScalarize14.B b[2];
 end RecordTests.RecordScalarize14.A;

end RecordTests.RecordScalarize14;
")})));
end RecordScalarize14;


model RecordScalarize15
 record A
  B b[2];
 end A;
 
 record B
  Real a[2];
 end B;
 
 A x[2] = { A({ B({1,2}), B({3,4}) }), A({ B({5,6}), B({7,8}) }) };
 Real y = x[1].b[1].a[2];

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordScalarize15",
			description="Scalarization of records: access of nestled primitive",
			eliminate_alias_variables=false,
			flatModel="
fclass RecordTests.RecordScalarize15
 Real x[1].b[1].a[1];
 Real x[1].b[1].a[2];
 Real x[1].b[2].a[1];
 Real x[1].b[2].a[2];
 Real x[2].b[1].a[1];
 Real x[2].b[1].a[2];
 Real x[2].b[2].a[1];
 Real x[2].b[2].a[2];
 Real y;
equation
 x[1].b[1].a[1] = 1;
 x[1].b[1].a[2] = 2;
 x[1].b[2].a[1] = 3;
 x[1].b[2].a[2] = 4;
 x[2].b[1].a[1] = 5;
 x[2].b[1].a[2] = 6;
 x[2].b[2].a[1] = 7;
 x[2].b[2].a[2] = 8;
 y = x[1].b[1].a[2];

public
 record RecordTests.RecordScalarize15.B
  Real a[2];
 end RecordTests.RecordScalarize15.B;

 record RecordTests.RecordScalarize15.A
  RecordTests.RecordScalarize15.B b[2];
 end RecordTests.RecordScalarize15.A;

end RecordTests.RecordScalarize15;
")})));
end RecordScalarize15;


model RecordScalarize16
 record A
  B b[2];
 end A;
 
 record B
  Real a[2];
 end B;
 
 A x[2] = { A({ B({1,2}), B({3,4}) }), A({ B({5,6}), B({7,8}) }) };
 B y = x[1].b[2];

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordScalarize16",
			description="Scalarization of records: access of nested record",
			flatModel="
fclass RecordTests.RecordScalarize16
 Real x[1].b[1].a[1];
 Real x[1].b[1].a[2];
 Real x[2].b[1].a[1];
 Real x[2].b[1].a[2];
 Real x[2].b[2].a[1];
 Real x[2].b[2].a[2];
 Real y.a[1];
 Real y.a[2];
equation
 x[1].b[1].a[1] = 1;
 x[1].b[1].a[2] = 2;
 y.a[1] = 3;
 y.a[2] = 4;
 x[2].b[1].a[1] = 5;
 x[2].b[1].a[2] = 6;
 x[2].b[2].a[1] = 7;
 x[2].b[2].a[2] = 8;

public
 record RecordTests.RecordScalarize16.B
  Real a[2];
 end RecordTests.RecordScalarize16.B;

 record RecordTests.RecordScalarize16.A
  RecordTests.RecordScalarize16.B b[2];
 end RecordTests.RecordScalarize16.A;

end RecordTests.RecordScalarize16;
")})));
end RecordScalarize16;


model RecordScalarize17
 record A
  Real a;
  Real b;
 end A;
 
 A x(b(start=3)) = A(1,2);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordScalarize17",
			description="Scalarization of records: attribute on primitive in record",
			flatModel="
fclass RecordTests.RecordScalarize17
 Real x.a;
 Real x.b(start = 3);
equation
 x.a = 1;
 x.b = 2;

public
 record RecordTests.RecordScalarize17.A
  Real a;
  Real b;
 end RecordTests.RecordScalarize17.A;

end RecordTests.RecordScalarize17;
")})));
end RecordScalarize17;


model RecordScalarize18
 record A
  Real a;
 end A;
 
 record B
  A b1;
  A b2;
 end B;
 
 B x(b1(a(start=3)), b2.a(start=4)) = B(A(1),A(2));

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordScalarize18",
			description="Scalarization of records: attributes on primitives in nestled records",
			flatModel="
fclass RecordTests.RecordScalarize18
 Real x.b1.a(start = 3);
 Real x.b2.a(start = 4);
equation
 x.b1.a = 1;
 x.b2.a = 2;

public
 record RecordTests.RecordScalarize18.A
  Real a;
 end RecordTests.RecordScalarize18.A;

 record RecordTests.RecordScalarize18.B
  RecordTests.RecordScalarize18.A b1;
  RecordTests.RecordScalarize18.A b2;
 end RecordTests.RecordScalarize18.B;

end RecordTests.RecordScalarize18;
")})));
end RecordScalarize18;


model RecordScalarize19
    record A
        Real x[2];
    end A;
	
    A a1(x(stateSelect={StateSelect.default,StateSelect.default},start={1,2}));
equation
    der(a1.x) = -a1.x;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordScalarize19",
			description="Scalarization of attributes of record members, from modification",
			flatModel="
fclass RecordTests.RecordScalarize19
 Real a1.x[1](stateSelect = StateSelect.default,start = 1);
 Real a1.x[2](stateSelect = StateSelect.default,start = 2);
initial equation 
 a1.x[1] = 1;
 a1.x[2] = 2;
equation
 a1.der(x[1]) = - a1.x[1];
 a1.der(x[2]) = - a1.x[2];

public
 record RecordTests.RecordScalarize19.A
  Real x[2];
 end RecordTests.RecordScalarize19.A;

 type StateSelect = enumeration(never \"Do not use as state at all.\", avoid \"Use as state, if it cannot be avoided (but only if variable appears differentiated and no other potential state with attribute default, prefer, or always can be selected).\", default \"Use as state if appropriate, but only if variable appears differentiated.\", prefer \"Prefer it as state over those having the default value (also variables can be selected, which do not appear differentiated). \", always \"Do use it as a state.\");

end RecordTests.RecordScalarize19;
")})));
end RecordScalarize19;


model RecordScalarize20
    record A
        Real x[2](stateSelect={StateSelect.default,StateSelect.default},start={1,2});
    end A;

    A a1;
equation
    der(a1.x) = -a1.x;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordScalarize20",
			description="Scalarization of attributes of record members, from record declaration",
			flatModel="
fclass RecordTests.RecordScalarize20
 Real a1.x[1](stateSelect = StateSelect.default,start = 1);
 Real a1.x[2](stateSelect = StateSelect.default,start = 2);
initial equation 
 a1.x[1] = 1;
 a1.x[2] = 2;
equation
 a1.der(x[1]) = - a1.x[1];
 a1.der(x[2]) = - a1.x[2];

public
 record RecordTests.RecordScalarize20.A
  Real x[2](stateSelect = {StateSelect.default, StateSelect.default},start = {1, 2});
 end RecordTests.RecordScalarize20.A;

 type StateSelect = enumeration(never \"Do not use as state at all.\", avoid \"Use as state, if it cannot be avoided (but only if variable appears differentiated and no other potential state with attribute default, prefer, or always can be selected).\", default \"Use as state if appropriate, but only if variable appears differentiated.\", prefer \"Prefer it as state over those having the default value (also variables can be selected, which do not appear differentiated). \", always \"Do use it as a state.\");

end RecordTests.RecordScalarize20;
")})));
end RecordScalarize20;


model RecordScalarize21
	record A
		Real x[2];
		Real y;
	end A;
	
	parameter Real y_start = 3;
	
	A a(y(start=y_start));
equation
	a = A({1,2}, 4);

	annotation(__JModelica(UnitTesting(tests={ 
		TransformCanonicalTestCase(
			name="RecordScalarize21",
			description="Modifiers on record members using parameters",
			flatModel="
fclass RecordTests.RecordScalarize21
 parameter Real y_start = 3 /* 3 */;
 Real a.x[1];
 Real a.x[2];
 Real a.y(start = y_start);
equation
 a.x[1] = 1;
 a.x[2] = 2;
 a.y = 4;

public
 record RecordTests.RecordScalarize21.A
  Real x[2];
  Real y;
 end RecordTests.RecordScalarize21.A;

end RecordTests.RecordScalarize21;
")})));
end RecordScalarize21;


model RecordScalarize22
    function f1
        output Real o;
        input A x[3];
    algorithm
        o := x[1].b[2].c;
    end f1;

    function f2
        input Real o;
        output A x;
    algorithm
        x := A(o, {B(o + 1), B(o + 2)});
    end f2;

    function f3
        input Real o;
        output B x;
    algorithm
        x := B(o);
    end f3;
 
    record A
        Real a;
        B b[2];
    end A;
 
    record B
        Real c;
    end B;
 
    Real x = f1({A(1,{B(2),B(3)}),f2(4),A(7,{f3(8),f3(9)})});

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordScalarize22",
			description="Array of records as argument to function",
			flatModel="
fclass RecordTests.RecordScalarize22
 Real x;
 Real temp_1.a;
 Real temp_1.b[1].c;
 Real temp_1.b[2].c;
 Real temp_2.c;
 Real temp_3.c;
equation
 (RecordTests.RecordScalarize22.A(temp_1.a, {RecordTests.RecordScalarize22.B(temp_1.b[1].c), RecordTests.RecordScalarize22.B(temp_1.b[2].c)})) = RecordTests.RecordScalarize22.f2(4);
 (RecordTests.RecordScalarize22.B(temp_2.c)) = RecordTests.RecordScalarize22.f3(8);
 (RecordTests.RecordScalarize22.B(temp_3.c)) = RecordTests.RecordScalarize22.f3(9);
 x = RecordTests.RecordScalarize22.f1({RecordTests.RecordScalarize22.A(1, {RecordTests.RecordScalarize22.B(2), RecordTests.RecordScalarize22.B(3)}), RecordTests.RecordScalarize22.A(temp_1.a, {RecordTests.RecordScalarize22.B(temp_1.b[1].c), RecordTests.RecordScalarize22.B(temp_1.b[2].c)}), RecordTests.RecordScalarize22.A(7, {temp_2, temp_3})});

public
 function RecordTests.RecordScalarize22.f1
  output Real o;
  input RecordTests.RecordScalarize22.A[3] x;
 algorithm
  o := x[1].b[2].c;
  return;
 end RecordTests.RecordScalarize22.f1;

 function RecordTests.RecordScalarize22.f2
  input Real o;
  output RecordTests.RecordScalarize22.A x;
 algorithm
  x.a := o;
  x.b[1].c := o + 1;
  x.b[2].c := o + 2;
  return;
 end RecordTests.RecordScalarize22.f2;

 function RecordTests.RecordScalarize22.f3
  input Real o;
  output RecordTests.RecordScalarize22.B x;
 algorithm
  x.c := o;
  return;
 end RecordTests.RecordScalarize22.f3;

 record RecordTests.RecordScalarize22.B
  Real c;
 end RecordTests.RecordScalarize22.B;

 record RecordTests.RecordScalarize22.A
  Real a;
  RecordTests.RecordScalarize22.B b[2];
 end RecordTests.RecordScalarize22.A;

end RecordTests.RecordScalarize22;
")})));
end RecordScalarize22;

// TODO: Add more complicated combinations of arrays, records and modifiers



model RecordFunc1
 record A
  Real x;
  Real y;
 end A;
 
 function f
  input Real ix;
  input Real iy;
  output Real o;
  protected A z;
 algorithm
  z.x := ix;
  z.y := iy;
  o := z.x * z.y;
 end f;
 
 Real q = f(1, 2);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordFunc1",
			description="Scalarization of records in functions: accesses of components",
			flatModel="
fclass RecordTests.RecordFunc1
 Real q;
equation
 q = RecordTests.RecordFunc1.f(1, 2);

public
 function RecordTests.RecordFunc1.f
  input Real ix;
  input Real iy;
  output Real o;
  RecordTests.RecordFunc1.A z;
 algorithm
  z.x := ix;
  z.y := iy;
  o := z.x * z.y;
  return;
 end RecordTests.RecordFunc1.f;

 record RecordTests.RecordFunc1.A
  Real x;
  Real y;
 end RecordTests.RecordFunc1.A;

end RecordTests.RecordFunc1;
")})));
end RecordFunc1;


model RecordFunc2
 record A
  Real x;
  Real y;
 end A;
 
 function f
  input Real ix;
  input Real iy;
  output Real o;
  protected A z;
  protected A w;
 algorithm
  z.x := ix;
  z.y := iy;
  w := z;
  o := w.x * w.y;
 end f;
 
 Real q = f(1, 2);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordFunc2",
			description="Scalarization of records in functions: assignment",
			flatModel="
fclass RecordTests.RecordFunc2
 Real q;
equation
 q = RecordTests.RecordFunc2.f(1, 2);

public
 function RecordTests.RecordFunc2.f
  input Real ix;
  input Real iy;
  output Real o;
  RecordTests.RecordFunc2.A z;
  RecordTests.RecordFunc2.A w;
 algorithm
  z.x := ix;
  z.y := iy;
  w.x := z.x;
  w.y := z.y;
  o := w.x * w.y;
  return;
 end RecordTests.RecordFunc2.f;

 record RecordTests.RecordFunc2.A
  Real x;
  Real y;
 end RecordTests.RecordFunc2.A;

end RecordTests.RecordFunc2;
")})));
end RecordFunc2;


model RecordFunc3
 record A
  Real x;
  Real y;
 end A;
 
 function f
  input Real ix;
  input Real iy;
  output Real o;
  protected A z;
 algorithm
  z := A(ix, iy);
  o := z.x * z.y;
 end f;
 
 Real q = f(1, 2);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordFunc3",
			description="Scalarization of records in functions: record constructor",
			flatModel="
fclass RecordTests.RecordFunc3
 Real q;
equation
 q = RecordTests.RecordFunc3.f(1, 2);

public
 function RecordTests.RecordFunc3.f
  input Real ix;
  input Real iy;
  output Real o;
  RecordTests.RecordFunc3.A z;
 algorithm
  z.x := ix;
  z.y := iy;
  o := z.x * z.y;
  return;
 end RecordTests.RecordFunc3.f;

 record RecordTests.RecordFunc3.A
  Real x;
  Real y;
 end RecordTests.RecordFunc3.A;

end RecordTests.RecordFunc3;
")})));
end RecordFunc3;


model RecordFunc3b
 record A
  Real x;
  Real y;
 end A;
 
 record B
  Real x;
  Real y;
 end B;
 
 function f
  input Real ix;
  input Real iy;
  output Real o;
  protected A z;
 algorithm
  z := B(ix, iy);
  o := z.x * z.y;
 end f;
 
 Real q = f(1, 2);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordFunc3b",
			description="Scalarization of records in functions: record constructor for equivalent record",
			flatModel="
fclass RecordTests.RecordFunc3b
 Real q;
equation
 q = RecordTests.RecordFunc3b.f(1, 2);

public
 function RecordTests.RecordFunc3b.f
  input Real ix;
  input Real iy;
  output Real o;
  RecordTests.RecordFunc3b.A z;
 algorithm
  z.x := ix;
  z.y := iy;
  o := z.x * z.y;
  return;
 end RecordTests.RecordFunc3b.f;

 record RecordTests.RecordFunc3b.A
  Real x;
  Real y;
 end RecordTests.RecordFunc3b.A;

end RecordTests.RecordFunc3b;
")})));
end RecordFunc3b;


model RecordFunc4
 record A
  Real x[2];
 end A;
 
 function f
  input Real ix;
  input Real iy;
  output Real o;
  protected A z;
 algorithm
  z.x[1] := ix;
  z.x[2] := iy;
  o := z.x[1] * z.x[2];
 end f;
 
 Real q = f(1, 2);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordFunc4",
			description="Scalarization of records in functions: inner array, access",
			flatModel="
fclass RecordTests.RecordFunc4
 Real q;
equation
 q = RecordTests.RecordFunc4.f(1, 2);

public
 function RecordTests.RecordFunc4.f
  input Real ix;
  input Real iy;
  output Real o;
  RecordTests.RecordFunc4.A z;
 algorithm
  z.x[1] := ix;
  z.x[2] := iy;
  o := z.x[1] * z.x[2];
  return;
 end RecordTests.RecordFunc4.f;

 record RecordTests.RecordFunc4.A
  Real x[2];
 end RecordTests.RecordFunc4.A;

end RecordTests.RecordFunc4;
")})));
end RecordFunc4;


model RecordFunc5
 record A
  Real x[2];
 end A;
 
 function f
  input Real ix;
  input Real iy;
  output Real o;
  protected A z;
  protected A w;
 algorithm
  z.x[1] := ix;
  z.x[2] := iy;
  w := z;
  o := w.x[1] * w.x[2];
 end f;
 
 Real q = f(1, 2);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordFunc5",
			description="Scalarization of records in functions: inner array, assignment",
			flatModel="
fclass RecordTests.RecordFunc5
 Real q;
equation
 q = RecordTests.RecordFunc5.f(1, 2);

public
 function RecordTests.RecordFunc5.f
  input Real ix;
  input Real iy;
  output Real o;
  RecordTests.RecordFunc5.A z;
  RecordTests.RecordFunc5.A w;
 algorithm
  z.x[1] := ix;
  z.x[2] := iy;
  w.x[1] := z.x[1];
  w.x[2] := z.x[2];
  o := w.x[1] * w.x[2];
  return;
 end RecordTests.RecordFunc5.f;

 record RecordTests.RecordFunc5.A
  Real x[2];
 end RecordTests.RecordFunc5.A;

end RecordTests.RecordFunc5;
")})));
end RecordFunc5;


model RecordFunc6
 record A
  Real x[2];
 end A;
 
 function f
  input Real ix;
  input Real iy;
  output Real o;
  protected A z;
 algorithm
  z := A({ix, iy});
  o := z.x[1] * z.x[2];
 end f;
 
 Real q = f(1, 2);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordFunc6",
			description="Scalarization of records in functions: record constructor",
			flatModel="
fclass RecordTests.RecordFunc6
 Real q;
equation
 q = RecordTests.RecordFunc6.f(1, 2);

public
 function RecordTests.RecordFunc6.f
  input Real ix;
  input Real iy;
  output Real o;
  RecordTests.RecordFunc6.A z;
 algorithm
  z.x[1] := ix;
  z.x[2] := iy;
  o := z.x[1] * z.x[2];
  return;
 end RecordTests.RecordFunc6.f;

 record RecordTests.RecordFunc6.A
  Real x[2];
 end RecordTests.RecordFunc6.A;

end RecordTests.RecordFunc6;
")})));
end RecordFunc6;


model RecordFunc7
 record A
  Real x;
 end A;
 
 function f
  input Real ix;
  input Real iy;
  output Real o;
  protected A z[2];
 algorithm
  z[1].x := ix;
  z[2].x := iy;
  o := z[1].x * z[2].x;
 end f;
 
 Real q = f(1, 2);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordFunc7",
			description="Scalarization of records in functions: array of records, access",
			flatModel="
fclass RecordTests.RecordFunc7
 Real q;
equation
 q = RecordTests.RecordFunc7.f(1, 2);

public
 function RecordTests.RecordFunc7.f
  input Real ix;
  input Real iy;
  output Real o;
  RecordTests.RecordFunc7.A[2] z;
 algorithm
  z[1].x := ix;
  z[2].x := iy;
  o := z[1].x * z[2].x;
  return;
 end RecordTests.RecordFunc7.f;

 record RecordTests.RecordFunc7.A
  Real x;
 end RecordTests.RecordFunc7.A;

end RecordTests.RecordFunc7;
")})));
end RecordFunc7;


model RecordFunc8
 record A
  Real x;
  Real y;
 end A;
 
 function f
  input Real ix;
  input Real iy;
  output Real o;
  protected A z[2];
  protected A w[2];
 algorithm
  z[1].x := ix;
  z[1].y := iy;
  z[2].x := ix;
  z[2].y := iy;
  w := z;
  o := w[1].x * w[2].x;
 end f;
 
 Real q = f(1, 2);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordFunc8",
			description="Scalarization of records in functions: array of records, assignment",
			flatModel="
fclass RecordTests.RecordFunc8
 Real q;
equation
 q = RecordTests.RecordFunc8.f(1, 2);

public
 function RecordTests.RecordFunc8.f
  input Real ix;
  input Real iy;
  output Real o;
  RecordTests.RecordFunc8.A[2] z;
  RecordTests.RecordFunc8.A[2] w;
 algorithm
  z[1].x := ix;
  z[1].y := iy;
  z[2].x := ix;
  z[2].y := iy;
  w[1].x := z[1].x;
  w[1].y := z[1].y;
  w[2].x := z[2].x;
  w[2].y := z[2].y;
  o := w[1].x * w[2].x;
  return;
 end RecordTests.RecordFunc8.f;

 record RecordTests.RecordFunc8.A
  Real x;
  Real y;
 end RecordTests.RecordFunc8.A;

end RecordTests.RecordFunc8;
")})));
end RecordFunc8;


model RecordFunc9
 record A
  Real x;
  Real y;
 end A;
 
 function f
  input Real ix;
  input Real iy;
  output Real o;
  protected A z[2];
 algorithm
  z := {A(ix, iy), A(ix+2, iy+2)};
  o := z[1].x * z[2].x;
 end f;
 
 Real q = f(1, 2);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordFunc9",
			description="Scalarization of records in functions: array of records, constructor",
			flatModel="
fclass RecordTests.RecordFunc9
 Real q;
equation
 q = RecordTests.RecordFunc9.f(1, 2);

public
 function RecordTests.RecordFunc9.f
  input Real ix;
  input Real iy;
  output Real o;
  RecordTests.RecordFunc9.A[2] z;
 algorithm
  z[1].x := ix;
  z[1].y := iy;
  z[2].x := ix + 2;
  z[2].y := iy + 2;
  o := z[1].x * z[2].x;
  return;
 end RecordTests.RecordFunc9.f;

 record RecordTests.RecordFunc9.A
  Real x;
  Real y;
 end RecordTests.RecordFunc9.A;

end RecordTests.RecordFunc9;
")})));
end RecordFunc9;



model RecordOutput1
 record A
  Real y;
  Real x;
 end A;
 
 function f
  output A o = A(1, 2);
 algorithm
 end f;
 
 A z = f();

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordOutput1",
			description="Scalarization of records in functions: record output: basic test",
			eliminate_alias_variables=false,
			flatModel="
fclass RecordTests.RecordOutput1
 Real z.y;
 Real z.x;
 Real temp_1.y;
 Real temp_1.x;
equation
 (RecordTests.RecordOutput1.A(temp_1.y, temp_1.x)) = RecordTests.RecordOutput1.f();
 z.y = temp_1.y;
 z.x = temp_1.x;

public
 function RecordTests.RecordOutput1.f
  output RecordTests.RecordOutput1.A o;
 algorithm
  o.y := 1;
  o.x := 2;
  return;
 end RecordTests.RecordOutput1.f;

 record RecordTests.RecordOutput1.A
  Real y;
  Real x;
 end RecordTests.RecordOutput1.A;

end RecordTests.RecordOutput1;
")})));
end RecordOutput1;


model RecordOutput2
 record A
  Real x;
  Real y;
 end A;
 
 function f
  output A o[2] = {A(1, 2), A(3, 4)};
 algorithm
 end f;
 
 A x[2] = f();

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordOutput2",
			description="Scalarization of records in functions: record output: array of records",
			flatModel="
fclass RecordTests.RecordOutput2
 Real x[1].x;
 Real x[1].y;
 Real x[2].x;
 Real x[2].y;
equation
 ({RecordTests.RecordOutput2.A(x[1].x, x[1].y),RecordTests.RecordOutput2.A(x[2].x, x[2].y)}) = RecordTests.RecordOutput2.f();

public
 function RecordTests.RecordOutput2.f
  output RecordTests.RecordOutput2.A[2] o;
 algorithm
  o[1].x := 1;
  o[1].y := 2;
  o[2].x := 3;
  o[2].y := 4;
  return;
 end RecordTests.RecordOutput2.f;

 record RecordTests.RecordOutput2.A
  Real x;
  Real y;
 end RecordTests.RecordOutput2.A;

end RecordTests.RecordOutput2;
")})));
end RecordOutput2;


model RecordOutput3
 record A
  Real x[2];
  Real y[3];
 end A;
 
 function f
  output A o = A({1,2}, {3,4,5});
 algorithm
 end f;
 
 A x = f();

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordOutput3",
			description="Scalarization of records in functions: record output: record containing array",
			flatModel="
fclass RecordTests.RecordOutput3
 Real x.x[1];
 Real x.x[2];
 Real x.y[1];
 Real x.y[2];
 Real x.y[3];
equation
 (RecordTests.RecordOutput3.A({x.x[1],x.x[2]}, {x.y[1],x.y[2],x.y[3]})) = RecordTests.RecordOutput3.f();

public
 function RecordTests.RecordOutput3.f
  output RecordTests.RecordOutput3.A o;
 algorithm
  o.x[1] := 1;
  o.x[2] := 2;
  o.y[1] := 3;
  o.y[2] := 4;
  o.y[3] := 5;
  return;
 end RecordTests.RecordOutput3.f;

 record RecordTests.RecordOutput3.A
  Real x[2];
  Real y[3];
 end RecordTests.RecordOutput3.A;

end RecordTests.RecordOutput3;
")})));
end RecordOutput3;


model RecordOutput4
 record A
  Real x;
  Real y;
 end A;
 
 record B
  A x;
  Real y;
 end B;
 
 function f
  output B o = B(A(1, 2), 3);
 algorithm
 end f;
 
 B x = f();

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordOutput4",
			description="Scalarization of records in functions: record output: nestled records",
			flatModel="
fclass RecordTests.RecordOutput4
 Real x.x.x;
 Real x.x.y;
 Real x.y;
equation
 (RecordTests.RecordOutput4.B(RecordTests.RecordOutput4.A(x.x.x, x.x.y), x.y)) = RecordTests.RecordOutput4.f();

public
 function RecordTests.RecordOutput4.f
  output RecordTests.RecordOutput4.B o;
 algorithm
  o.x.x := 1;
  o.x.y := 2;
  o.y := 3;
  return;
 end RecordTests.RecordOutput4.f;

 record RecordTests.RecordOutput4.A
  Real x;
  Real y;
 end RecordTests.RecordOutput4.A;

 record RecordTests.RecordOutput4.B
  RecordTests.RecordOutput4.A x;
  Real y;
 end RecordTests.RecordOutput4.B;

end RecordTests.RecordOutput4;
")})));
end RecordOutput4;


model RecordOutput5
    record R
        Real x;
        Real y;
    end R;

    function f
        input Real u;
        output R ry;
        output Real y;
    algorithm
        ry := R(1,2);
        y := u;
    end f;

    R ry;
    Real z;
equation
    (ry,z) = f(3);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordOutput5",
			description="Test scalarization of function call equation left of record type",
			flatModel="
fclass RecordTests.RecordOutput5
 Real ry.x;
 Real ry.y;
 Real z;
equation
 (RecordTests.RecordOutput5.R(ry.x, ry.y), z) = RecordTests.RecordOutput5.f(3);

public
 function RecordTests.RecordOutput5.f
  input Real u;
  output RecordTests.RecordOutput5.R ry;
  output Real y;
 algorithm
  ry.x := 1;
  ry.y := 2;
  y := u;
  return;
 end RecordTests.RecordOutput5.f;

 record RecordTests.RecordOutput5.R
  Real x;
  Real y;
 end RecordTests.RecordOutput5.R;

end RecordTests.RecordOutput5;
")})));
end RecordOutput5;


model RecordOutput6
    record R
        Real x;
        Real y;
    end R;

    function f
        input R rx;
        output R ry;
    algorithm
        ry := rx;
    end f;

    R ry = f(R(5,6));
    Real u;
    Real y = 3;
equation
    y = u;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordOutput6",
			description="Test that access to record member with same name as alias variable isn't changed in alias elimination",
			flatModel="
fclass RecordTests.RecordOutput6
 Real ry.x;
 Real ry.y;
 Real y;
equation
 (RecordTests.RecordOutput6.R(ry.x, ry.y)) = RecordTests.RecordOutput6.f(RecordTests.RecordOutput6.R(5, 6));
 y = 3;

public
 function RecordTests.RecordOutput6.f
  input RecordTests.RecordOutput6.R rx;
  output RecordTests.RecordOutput6.R ry;
 algorithm
  ry.x := rx.x;
  ry.y := rx.y;
  return;
 end RecordTests.RecordOutput6.f;

 record RecordTests.RecordOutput6.R
  Real x;
  Real y;
 end RecordTests.RecordOutput6.R;

end RecordTests.RecordOutput6;
")})));
end RecordOutput6;



model RecordInput1
 record A
  Real x;
  Real y;
 end A;
 
 function f
  input A i;
  output Real o;
 algorithm
  o := i.x + i.y;
 end f;
 
 Real x = f(A(1,{2,3}*{4,5}));

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordInput1",
			description="Scalarization of records in functions: record input: record constructor",
			flatModel="
fclass RecordTests.RecordInput1
 Real x;
equation
 x = RecordTests.RecordInput1.f(RecordTests.RecordInput1.A(1, 2 * 4 + 3 * 5));

public
 function RecordTests.RecordInput1.f
  input RecordTests.RecordInput1.A i;
  output Real o;
 algorithm
  o := i.x + i.y;
  return;
 end RecordTests.RecordInput1.f;

 record RecordTests.RecordInput1.A
  Real x;
  Real y;
 end RecordTests.RecordInput1.A;

end RecordTests.RecordInput1;
")})));
end RecordInput1;


model RecordInput2
 record A
  Real x;
  Real y;
 end A;
 
 function f
  input A i;
  output Real o;
 algorithm
  o := i.x + i.y;
 end f;
 
 A a = A(1,2);
 Real x = f(a);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordInput2",
			description="Scalarization of records in functions: record input:",
			flatModel="
fclass RecordTests.RecordInput2
 Real a.x;
 Real a.y;
 Real x;
equation
 a.x = 1;
 a.y = 2;
 x = RecordTests.RecordInput2.f(RecordTests.RecordInput2.A(a.x, a.y));

public
 function RecordTests.RecordInput2.f
  input RecordTests.RecordInput2.A i;
  output Real o;
 algorithm
  o := i.x + i.y;
  return;
 end RecordTests.RecordInput2.f;

 record RecordTests.RecordInput2.A
  Real x;
  Real y;
 end RecordTests.RecordInput2.A;

end RecordTests.RecordInput2;
")})));
end RecordInput2;


// TODO: Dont create temporary here, just send the returned array into the next function (cf. arrays)
model RecordInput3
 record A
  Real x;
  Real y;
 end A;
 
 function f1
  output A o;
 algorithm
  o := A(1,2);
 end f1;
 
 function f2
  input A i;
  output Real o;
 algorithm
  o := i.x + i.y;
 end f2;
 
 Real x = f2(f1());

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordInput3",
			description="Scalarization of records in functions: record input: output from another function",
			flatModel="
fclass RecordTests.RecordInput3
 Real x;
 Real temp_1.x;
 Real temp_1.y;
equation
 (RecordTests.RecordInput3.A(temp_1.x, temp_1.y)) = RecordTests.RecordInput3.f1();
 x = RecordTests.RecordInput3.f2(RecordTests.RecordInput3.A(temp_1.x, temp_1.y));

public
 function RecordTests.RecordInput3.f2
  input RecordTests.RecordInput3.A i;
  output Real o;
 algorithm
  o := i.x + i.y;
  return;
 end RecordTests.RecordInput3.f2;

 function RecordTests.RecordInput3.f1
  output RecordTests.RecordInput3.A o;
 algorithm
  o.x := 1;
  o.y := 2;
  return;
 end RecordTests.RecordInput3.f1;

 record RecordTests.RecordInput3.A
  Real x;
  Real y;
 end RecordTests.RecordInput3.A;

end RecordTests.RecordInput3;
")})));
end RecordInput3;


model RecordInput4
 record A
  Real x;
  Real y;
 end A;
 
 function f
  input A i[2];
  output Real o;
 algorithm
  o := i[1].x + i[2].y;
 end f;
 
 A a[2] = {A(1,2),A(3,4)};
 Real x = f(a);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordInput4",
			description="Scalarization of records in functions: record input: array of records",
			flatModel="
fclass RecordTests.RecordInput4
 Real a[1].x;
 Real a[1].y;
 Real a[2].x;
 Real a[2].y;
 Real x;
equation
 a[1].x = 1;
 a[2].x = 3;
 a[1].y = 2;
 a[2].y = 4;
 x = RecordTests.RecordInput4.f({RecordTests.RecordInput4.A(a[1].x, a[1].y),RecordTests.RecordInput4.A(a[2].x, a[2].y)});

public
 function RecordTests.RecordInput4.f
  input RecordTests.RecordInput4.A[2] i;
  output Real o;
 algorithm
  o := i[1].x + i[2].y;
  return;
 end RecordTests.RecordInput4.f;

 record RecordTests.RecordInput4.A
  Real x;
  Real y;
 end RecordTests.RecordInput4.A;

end RecordTests.RecordInput4;
")})));
end RecordInput4;


model RecordInput5
 record A
  Real x[2];
  Real y;
 end A;
 
 function f
  input A i;
  output Real o;
 algorithm
  o := i.x[1] + i.y;
 end f;
 
 A a = A({1,2}, 3);
 Real x = f(a);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordInput5",
			description="Scalarization of records in functions: record input: record containing array",
			flatModel="
fclass RecordTests.RecordInput5
 Real a.x[1];
 Real a.x[2];
 Real a.y;
 Real x;
equation
 a.x[1] = 1;
 a.x[2] = 2;
 a.y = 3;
 x = RecordTests.RecordInput5.f(RecordTests.RecordInput5.A({a.x[1],a.x[2]}, a.y));

public
 function RecordTests.RecordInput5.f
  input RecordTests.RecordInput5.A i;
  output Real o;
 algorithm
  o := i.x[1] + i.y;
  return;
 end RecordTests.RecordInput5.f;

 record RecordTests.RecordInput5.A
  Real x[2];
  Real y;
 end RecordTests.RecordInput5.A;

end RecordTests.RecordInput5;
")})));
end RecordInput5;


model RecordInput6
 record A
  B z;
 end A;
 
 record B
  Real x;
  Real y;
 end B;
 
 function f
  input A i;
  output Real o;
 algorithm
  o := i.z.x + i.z.y;
 end f;
 
 A a = A(B(1,2));
 Real x = f(a);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordInput6",
			description="Scalarization of records in functions: record input: nestled records",
			flatModel="
fclass RecordTests.RecordInput6
 Real a.z.x;
 Real a.z.y;
 Real x;
equation
 a.z.x = 1;
 a.z.y = 2;
 x = RecordTests.RecordInput6.f(RecordTests.RecordInput6.A(RecordTests.RecordInput6.B(a.z.x, a.z.y)));

public
 function RecordTests.RecordInput6.f
  input RecordTests.RecordInput6.A i;
  output Real o;
 algorithm
  o := i.z.x + i.z.y;
  return;
 end RecordTests.RecordInput6.f;

 record RecordTests.RecordInput6.B
  Real x;
  Real y;
 end RecordTests.RecordInput6.B;

 record RecordTests.RecordInput6.A
  RecordTests.RecordInput6.B z;
 end RecordTests.RecordInput6.A;

end RecordTests.RecordInput6;
")})));
end RecordInput6;


model RecordInput7
 record A
  Real x;
  Real y;
 end A;
 
 function f1
  input A i;
  output Real o;
 algorithm
  o := f2(i);
 end f1;
  
 function f2
  input A i;
  output Real o;
 algorithm
  o := i.x + i.y;
 end f2;
 
 A a = A(1,2);
 Real x = f1(a);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordInput7",
			description="Scalarization of records in functions: record input: in functions",
			flatModel="
fclass RecordTests.RecordInput7
 Real a.x;
 Real a.y;
 Real x;
equation
 a.x = 1;
 a.y = 2;
 x = RecordTests.RecordInput7.f1(RecordTests.RecordInput7.A(a.x, a.y));

public
 function RecordTests.RecordInput7.f1
  input RecordTests.RecordInput7.A i;
  output Real o;
 algorithm
  o := RecordTests.RecordInput7.f2(i);
  return;
 end RecordTests.RecordInput7.f1;

 function RecordTests.RecordInput7.f2
  input RecordTests.RecordInput7.A i;
  output Real o;
 algorithm
  o := i.x + i.y;
  return;
 end RecordTests.RecordInput7.f2;

 record RecordTests.RecordInput7.A
  Real x;
  Real y;
 end RecordTests.RecordInput7.A;

end RecordTests.RecordInput7;
")})));
end RecordInput7;



model RecordParBexp1
	record R
		Real x = 1;
		Real y = 1;
	end R;
	
	parameter R[2] r = {R(3,3),R(4,6)};

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordParBexp1",
			description="Parameter with array-of-records type and literal binding expression",
			checkAll=true,
			flatModel="
fclass RecordTests.RecordParBexp1
 parameter Real r[1].x = 3 /* 3 */;
 parameter Real r[1].y = 3 /* 3 */;
 parameter Real r[2].x = 4 /* 4 */;
 parameter Real r[2].y = 6 /* 6 */;

public
 record RecordTests.RecordParBexp1.R
  Real x = 1;
  Real y = 1;
 end RecordTests.RecordParBexp1.R;

end RecordTests.RecordParBexp1;
")})));
end RecordParBexp1;



model RecordWithParam1
	record R
		parameter Real a;
		Real b;
	end R;
	
	R c(a = 1, b = 2);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordWithParam1",
			description="Record with independent parameter getting value from modification",
			flatModel="
fclass RecordTests.RecordWithParam1
 parameter Real c.a = 1 /* 1 */;
 Real c.b;
equation
 c.b = 2;

public
 record RecordTests.RecordWithParam1.R
  parameter Real a;
  Real b;
 end RecordTests.RecordWithParam1.R;

end RecordTests.RecordWithParam1;
")})));
end RecordWithParam1;


model RecordWithParam2
	record R
		parameter Real a;
		Real b;
	end R;
	
	R c(a = d, b = 2);
	parameter Real d = 1;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordWithParam2",
			description="Record with dependent parameter getting value from modification",
			flatModel="
fclass RecordTests.RecordWithParam2
 parameter Real c.a;
 Real c.b;
 parameter Real d = 1 /* 1 */;
parameter equation
 c.a = d;
equation
 c.b = 2;

public
 record RecordTests.RecordWithParam2.R
  parameter Real a;
  Real b;
 end RecordTests.RecordWithParam2.R;

end RecordTests.RecordWithParam2;
")})));
end RecordWithParam2;



model RecordWithColonArray1
	record A
		Real a[:];
		Real b;
	end A;

	A c = A({1, 2, 3}, 4);
	A d = A({5, 6}, 7);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordWithColonArray1",
			description="Variable with : size in record",
			flatModel="
fclass RecordTests.RecordWithColonArray1
 Real c.a[1];
 Real c.a[2];
 Real c.a[3];
 Real c.b;
 Real d.a[1];
 Real d.a[2];
 Real d.b;
equation
 c.a[1] = 1;
 c.a[2] = 2;
 c.a[3] = 3;
 c.b = 4;
 d.a[1] = 5;
 d.a[2] = 6;
 d.b = 7;

public
 record RecordTests.RecordWithColonArray1.A
  Real a[:];
  Real b;
 end RecordTests.RecordWithColonArray1.A;

end RecordTests.RecordWithColonArray1;
")})));
end RecordWithColonArray1;


model RecordWithColonArray2
	record A
		Real a[:];
		Real b;
	end A;

	A c;

	annotation(__JModelica(UnitTesting(tests={
		ErrorTestCase(
			name="RecordWithColonArray2",
			description="Variable with : size without binding exp",
			errorMessage="
1 errors found:
Error: in file 'Compiler/ModelicaFrontEnd/src/test/modelica/RecordTests.mo':
Semantic error at line 2794, column 8:
  Can not infer array size of the variable a
")})));
end RecordWithColonArray2;


model RecordWithColonArray3
	record A
		Real a[:];
		Real b;
	end A;

	A c(a = {1, 2, 3}, b = 4);
	A d(a = {5, 6}, b = 7);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordWithColonArray3",
			description="Variable with : size in record",
			flatModel="
fclass RecordTests.RecordWithColonArray3
 Real c.a[1];
 Real c.a[2];
 Real c.a[3];
 Real c.b;
 Real d.a[1];
 Real d.a[2];
 Real d.b;
equation
 c.a[1] = 1;
 c.a[2] = 2;
 c.a[3] = 3;
 c.b = 4;
 d.a[1] = 5;
 d.a[2] = 6;
 d.b = 7;

public
 record RecordTests.RecordWithColonArray3.A
  Real a[:];
  Real b;
 end RecordTests.RecordWithColonArray3.A;

end RecordTests.RecordWithColonArray3;
")})));
end RecordWithColonArray3;


// TODO: causes exception during flattening
model RecordWithColonArray4
	record A
		B a[:];
		B b[:];
	end A;
	
	record B
		Real c[:];
		Real d[:];
	end B;

	// TODO: support different sizes for b[1].c & b[2].c, etc
	A e(a = {B(c = {1,2,3}, d = {1,2,3,4})}, b = {B(c = {1,2,3,4}, d = {1,2,3,4,5}), B(c = {1,2,3,4}, d = {1,2,3,4,5})});
end RecordWithColonArray4;



model RecordDer1
	record A
		Real x;
		Real y;
	end A;
	
	A a;
initial equation
	a = A(1, 0);
equation
	der(a.x) = -a.y;
	der(a.y) = -a.x;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordDer1",
			description="der() on record members",
			eliminate_alias_variables=false,
			flatModel="
fclass RecordTests.RecordDer1
 Real a.x;
 Real a.y;
initial equation 
 a.x = 1;
 a.y = 0;
equation
 a.der(x) = - a.y;
 a.der(y) = - a.x;

public
 record RecordTests.RecordDer1.A
  Real x;
  Real y;
 end RecordTests.RecordDer1.A;

end RecordTests.RecordDer1;
")})));
end RecordDer1;



model RecordParam1
	record A
		parameter Real x = 1;
		Real y;
	end A;
	
	A a1(y=2);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordParam1",
			description="Parameter with default value in record",
			flatModel="
fclass RecordTests.RecordParam1
 parameter Real a1.x = 1 /* 1 */;
 Real a1.y;
equation
 a1.y = 2;

public
 record RecordTests.RecordParam1.A
  parameter Real x = 1 /* 1 */;
  Real y;
 end RecordTests.RecordParam1.A;

end RecordTests.RecordParam1;
")})));
end RecordParam1;


model RecordParam2
	record A
		parameter Real x = 1;
		Real y;
	end A;
	
	A a1 = A(y=2);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordParam2",
			description="Parameter with default value in record",
			flatModel="
fclass RecordTests.RecordParam2
 parameter Real a1.x = 1 /* 1 */;
 Real a1.y;
equation
 a1.y = 2;

public
 record RecordTests.RecordParam2.A
  parameter Real x = 1 /* 1 */;
  Real y;
 end RecordTests.RecordParam2.A;

end RecordTests.RecordParam2;
")})));
end RecordParam2;


model RecordParam3
	function f
		input Real i;
		output Real[2] o = { i, -i };
	algorithm
	end f;
	
	record A
		parameter Real[2] x = f(1);
		Real y;
	end A;
	
	A a1(y=2);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordParam3",
			description="Parameter with default value in record",
			flatModel="
fclass RecordTests.RecordParam3
 parameter Real temp_1[1];
 parameter Real temp_1[2];
 Real a1.y;
 parameter Real a1.x[1];
 parameter Real a1.x[2];
parameter equation
 ({temp_1[1], temp_1[2]}) = RecordTests.RecordParam3.f(1);
 a1.x[1] = temp_1[1];
 a1.x[2] = temp_1[2];
equation
 a1.y = 2;

public
 function RecordTests.RecordParam3.f
  input Real i;
  output Real[2] o;
 algorithm
  o[1] := i;
  o[2] := - i;
  return;
 end RecordTests.RecordParam3.f;

 record RecordTests.RecordParam3.A
  parameter Real x[2] = RecordTests.RecordParam3.f(1);
  Real y;
 end RecordTests.RecordParam3.A;

end RecordTests.RecordParam3;
")})));
end RecordParam3;


model RecordParam4
	record A
		parameter Real x = 1;
		parameter Real z = x;
		Real y;
	end A;
	
	A a1(y=2);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordParam4",
			description="Parameter with default value in record",
			flatModel="
fclass RecordTests.RecordParam4
 parameter Real a1.x = 1 /* 1 */;
 parameter Real a1.z;
 Real a1.y;
parameter equation
 a1.z = a1.x;
equation
 a1.y = 2;

public
 record RecordTests.RecordParam4.A
  parameter Real x = 1 /* 1 */;
  parameter Real z = x;
  Real y;
 end RecordTests.RecordParam4.A;

end RecordTests.RecordParam4;
")})));
end RecordParam4;


model RecordParam5
	record A
		parameter Real x = 2;
		parameter Real z = 3;
		Real y;
	end A;
	
	A a1 = A(y = 2, x = 1, z = a1.x);

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordParam5",
			description="Parameter with default value in record",
			flatModel="
fclass RecordTests.RecordParam5
 parameter Real a1.x = 1 /* 1 */;
 parameter Real a1.z;
 Real a1.y;
parameter equation
 a1.z = a1.x;
equation
 a1.y = 2;

public
 record RecordTests.RecordParam5.A
  parameter Real x = 2 /* 2 */;
  parameter Real z = 3 /* 3 */;
  Real y;
 end RecordTests.RecordParam5.A;

end RecordTests.RecordParam5;
")})));
end RecordParam5;


model RecordParam6
	function f
		output Real[2] o = {1,2};
	algorithm
	end f;
	
	record A
		parameter Real x[2] = f();
		parameter Real y[2] = x;
	end A;
	
	A a1;
	A a2;

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordParam6",
			description="",
			flatModel="
fclass RecordTests.RecordParam6
 parameter Real temp_1[1];
 parameter Real temp_1[2];
 parameter Real temp_2[1];
 parameter Real temp_2[2];
 parameter Real a1.x[1];
 parameter Real a1.x[2];
 parameter Real a2.x[1];
 parameter Real a2.x[2];
 parameter Real a1.y[1];
 parameter Real a1.y[2];
 parameter Real a2.y[1];
 parameter Real a2.y[2];
parameter equation
 ({temp_1[1],temp_1[2]}) = RecordTests.RecordParam6.f();
 ({temp_2[1],temp_2[2]}) = RecordTests.RecordParam6.f();
 a1.x[1] = temp_1[1];
 a1.x[2] = temp_1[2];
 a2.x[1] = temp_2[1];
 a2.x[2] = temp_2[2];
 a1.y[1] = a1.x[1];
 a1.y[2] = a1.x[2];
 a2.y[1] = a2.x[1];
 a2.y[2] = a2.x[2];

public
 function RecordTests.RecordParam6.f
  output Real[2] o;
 algorithm
  o[1] := 1;
  o[2] := 2;
  return;
 end RecordTests.RecordParam6.f;

 record RecordTests.RecordParam6.A
  parameter Real x[2] = RecordTests.RecordParam6.f();
  parameter Real y[2] = x[1:2];
 end RecordTests.RecordParam6.A;

end RecordTests.RecordParam6;
")})));
end RecordParam6;


model RecordMerge1
    record R1
        Real x;
        Real y;
    end R1;
 
    record R2
        Real x;
        Real y;
    end R2;
 
    function F
        input R1 rin;
        output R2 rout;
    algorithm
        rout := rin;
    end F;
 
    R2 r2 = F(R1(1,2));

	annotation(__JModelica(UnitTesting(tests={
		TransformCanonicalTestCase(
			name="RecordMerge1",
			description="",
			flatModel="
fclass RecordTests.RecordMerge1
 Real r2.x;
 Real r2.y;
equation
 (RecordTests.RecordMerge1.R1(r2.x, r2.y)) = RecordTests.RecordMerge1.F(RecordTests.RecordMerge1.R1(1, 2));

public
 function RecordTests.RecordMerge1.F
  input RecordTests.RecordMerge1.R1 rin;
  output RecordTests.RecordMerge1.R1 rout;
 algorithm
  rout.x := rin.x;
  rout.y := rin.y;
  return;
 end RecordTests.RecordMerge1.F;

 record RecordTests.RecordMerge1.R1
  Real x;
  Real y;
 end RecordTests.RecordMerge1.R1;

end RecordTests.RecordMerge1;
")})));
end RecordMerge1;


end RecordTests;
