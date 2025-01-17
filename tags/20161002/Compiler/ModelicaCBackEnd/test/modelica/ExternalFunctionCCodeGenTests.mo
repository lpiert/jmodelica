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


package ExternalFunctionCCodeGenTests

package ExternalFunction
package CEval
model Scalar
    type E = enumeration(A,B);
    function f
        input Real a1;
        input Integer a2;
        input Boolean a3;
        input String a4;
        input E a5;
        output Real b1;
        output Integer b2;
        output Boolean b3;
        output String b4;
        output E b5;
        external;
    end f;
    
    Real x1;
    Integer x2;
    Boolean x3;
    String x4;
    E x5;
equation
    (x1,x2,x3,x4,x5) = f(1,2,true,"s",E.A);

    annotation(__JModelica(UnitTesting(tests={
        CCodeGenTestCase(
            name="ExternalFunction_CEval_Scalar",
            description="Test code gen for external C functions evaluation. Scalars.",
            variability_propagation=false,
            inline_functions="none",
            template="
$ECE_external_includes$
$ECE_record_definitions$
$ECE_decl$
---
$ECE_setup_decl$
---
$ECE_setup_init$
---
$ECE_setup_free$
---
$ECE_calc_decl$
---
$ECE_calc_init$
---
$ECE_calc$
---
$ECE_calc_free$
---
$ECE_free$
",
            generatedCode="
---

---

---

---
        JMI_DEF(REA, a1_v)
        JMI_DEF(INT, a2_v)
        JMI_DEF(BOO, a3_v)
        JMI_DEF(STR, a4_v)
        JMI_DEF(ENU, a5_v)
        JMI_DEF(REA, b1_v)
        JMI_DEF(INT, b2_v)
        JMI_DEF(BOO, b3_v)
        JMI_DEF(STR, b4_v)
        JMI_DEF(ENU, b5_v)
        JMI_DEF(INT_EXT, tmp_1)
        JMI_DEF(BOO_EXT, tmp_2)
        JMI_DEF(ENU_EXT, tmp_3)
        JMI_DEF(INT_EXT, tmp_4)
        JMI_DEF(BOO_EXT, tmp_5)
        JMI_DEF(ENU_EXT, tmp_6)

---
        JMCEVAL_parse(Real, a1_v);
        JMCEVAL_parse(Integer, a2_v);
        JMCEVAL_parse(Boolean, a3_v);
        JMCEVAL_parse(String, a4_v);
        JMCEVAL_parse(Enum, a5_v);
        JMCEVAL_parse(Real, b1_v);
        JMCEVAL_parse(Integer, b2_v);
        JMCEVAL_parse(Boolean, b3_v);
        JMCEVAL_parse(String, b4_v);
        JMCEVAL_parse(Enum, b5_v);

---
            tmp_1 = (int)a2_v;
            tmp_2 = (int)a3_v;
            tmp_3 = (int)a5_v;
            tmp_4 = (int)b2_v;
            tmp_5 = (int)b3_v;
            tmp_6 = (int)b5_v;
            f(a1_v, tmp_1, tmp_2, a4_v, tmp_3, &b1_v, &tmp_4, &tmp_5, &b4_v, &tmp_6);
            b2_v = tmp_4;
            b3_v = tmp_5;
            b5_v = tmp_6;
            JMCEVAL_check(\"DONE\");
            JMCEVAL_print(Real, b1_v);
            JMCEVAL_print(Integer, b2_v);
            JMCEVAL_print(Boolean, b3_v);
            JMCEVAL_print(String, b4_v);
            JMCEVAL_print(Enum, b5_v);


---

---

")})));
end Scalar;

model Array
type E = enumeration(A,B);
function f
    input Real[:] a1;
    input Integer[:] a2;
    input Boolean[:] a3;
    input String[:] a4;
    input E[:] a5;
    output Real[size(a1,1)] b1;
    output Integer[size(a2,1)] b2;
    output Boolean[size(a3,1)] b3;
    output String[size(a4,1)] b4;
    output E[size(a5,1)] b5;
    external;
end f;
    Real[1] x1;
    Integer[1] x2;
    Boolean[1] x3;
    String[1] x4;
    E[1] x5;
equation
	(x1,x2,x3,x4,x5) = f({1},{2},{true},{"s"},{E.A});

    annotation(__JModelica(UnitTesting(tests={
        CCodeGenTestCase(
            name="ExternalFunction_CEval_Array",
            description="Test code gen for external C functions evaluation. Arrays.",
            variability_propagation=false,
            inline_functions="none",
            template="
$ECE_external_includes$
$ECE_record_definitions$
$ECE_decl$
---
$ECE_setup_decl$
---
$ECE_setup_init$
---
$ECE_setup_free$
---
$ECE_calc_decl$
---
$ECE_calc_init$
---
$ECE_calc$
---
$ECE_calc_free$
---
$ECE_free$
",
            generatedCode="
---

---

---

---
        JMI_ARR(DYNAREAL, jmi_ad_var_t, jmi_array_t, a1_a, -1, 1)
        JMI_ARR(DYNA, jmi_ad_var_t, jmi_array_t, a2_a, -1, 1)
        JMI_ARR(DYNA, jmi_ad_var_t, jmi_array_t, a3_a, -1, 1)
        JMI_ARR(DYNA, jmi_string_t, jmi_string_array_t, a4_a, -1, 1)
        JMI_ARR(DYNA, jmi_ad_var_t, jmi_array_t, a5_a, -1, 1)
        JMI_ARR(DYNAREAL, jmi_ad_var_t, jmi_array_t, b1_a, -1, 1)
        JMI_ARR(DYNA, jmi_ad_var_t, jmi_array_t, b2_a, -1, 1)
        JMI_ARR(DYNA, jmi_ad_var_t, jmi_array_t, b3_a, -1, 1)
        JMI_ARR(DYNA, jmi_string_t, jmi_string_array_t, b4_a, -1, 1)
        JMI_ARR(DYNA, jmi_ad_var_t, jmi_array_t, b5_a, -1, 1)
        JMI_ARR(DYNA, jmi_int_t, jmi_int_array_t, tmp_7, -1, 1)
        JMI_ARR(DYNA, jmi_int_t, jmi_int_array_t, tmp_8, -1, 1)
        JMI_ARR(DYNA, jmi_int_t, jmi_int_array_t, tmp_9, -1, 1)
        JMI_ARR(DYNA, jmi_int_t, jmi_int_array_t, tmp_10, -1, 1)
        JMI_ARR(DYNA, jmi_int_t, jmi_int_array_t, tmp_11, -1, 1)
        JMI_ARR(DYNA, jmi_int_t, jmi_int_array_t, tmp_12, -1, 1)

---
        JMCEVAL_parseArrayDims(1);
        JMI_ARRAY_INIT_1(DYNAREAL, jmi_ad_var_t, jmi_array_t, a1_a, d[0], 1, d[0])
        JMCEVAL_parseArray(Real, a1_a);
        JMCEVAL_parseArrayDims(1);
        JMI_ARRAY_INIT_1(DYNA, jmi_ad_var_t, jmi_array_t, a2_a, d[0], 1, d[0])
        JMCEVAL_parseArray(Integer, a2_a);
        JMCEVAL_parseArrayDims(1);
        JMI_ARRAY_INIT_1(DYNA, jmi_ad_var_t, jmi_array_t, a3_a, d[0], 1, d[0])
        JMCEVAL_parseArray(Boolean, a3_a);
        JMCEVAL_parseArrayDims(1);
        JMI_ARRAY_INIT_1(DYNA, jmi_string_t, jmi_string_array_t, a4_a, d[0], 1, d[0])
        JMCEVAL_parseArray(String, a4_a);
        JMCEVAL_parseArrayDims(1);
        JMI_ARRAY_INIT_1(DYNA, jmi_ad_var_t, jmi_array_t, a5_a, d[0], 1, d[0])
        JMCEVAL_parseArray(Enum, a5_a);
        JMCEVAL_parseArrayDims(1);
        JMI_ARRAY_INIT_1(DYNAREAL, jmi_ad_var_t, jmi_array_t, b1_a, d[0], 1, d[0])
        JMCEVAL_parseArray(Real, b1_a);
        JMCEVAL_parseArrayDims(1);
        JMI_ARRAY_INIT_1(DYNA, jmi_ad_var_t, jmi_array_t, b2_a, d[0], 1, d[0])
        JMCEVAL_parseArray(Integer, b2_a);
        JMCEVAL_parseArrayDims(1);
        JMI_ARRAY_INIT_1(DYNA, jmi_ad_var_t, jmi_array_t, b3_a, d[0], 1, d[0])
        JMCEVAL_parseArray(Boolean, b3_a);
        JMCEVAL_parseArrayDims(1);
        JMI_ARRAY_INIT_1(DYNA, jmi_string_t, jmi_string_array_t, b4_a, d[0], 1, d[0])
        JMCEVAL_parseArray(String, b4_a);
        JMCEVAL_parseArrayDims(1);
        JMI_ARRAY_INIT_1(DYNA, jmi_ad_var_t, jmi_array_t, b5_a, d[0], 1, d[0])
        JMCEVAL_parseArray(Enum, b5_a);

---
            JMI_ARRAY_INIT_1(DYNA, jmi_int_t, jmi_int_array_t, tmp_7, jmi_array_size(a2_a, 0), 1, jmi_array_size(a2_a, 0))
            jmi_copy_matrix_to_int(a2_a, a2_a->var, tmp_7->var);
            JMI_ARRAY_INIT_1(DYNA, jmi_int_t, jmi_int_array_t, tmp_8, jmi_array_size(a3_a, 0), 1, jmi_array_size(a3_a, 0))
            jmi_copy_matrix_to_int(a3_a, a3_a->var, tmp_8->var);
            JMI_ARRAY_INIT_1(DYNA, jmi_int_t, jmi_int_array_t, tmp_9, jmi_array_size(a5_a, 0), 1, jmi_array_size(a5_a, 0))
            jmi_copy_matrix_to_int(a5_a, a5_a->var, tmp_9->var);
            JMI_ARRAY_INIT_1(DYNA, jmi_int_t, jmi_int_array_t, tmp_10, jmi_array_size(b2_a, 0), 1, jmi_array_size(b2_a, 0))
            jmi_copy_matrix_to_int(b2_a, b2_a->var, tmp_10->var);
            JMI_ARRAY_INIT_1(DYNA, jmi_int_t, jmi_int_array_t, tmp_11, jmi_array_size(b3_a, 0), 1, jmi_array_size(b3_a, 0))
            jmi_copy_matrix_to_int(b3_a, b3_a->var, tmp_11->var);
            JMI_ARRAY_INIT_1(DYNA, jmi_int_t, jmi_int_array_t, tmp_12, jmi_array_size(b5_a, 0), 1, jmi_array_size(b5_a, 0))
            jmi_copy_matrix_to_int(b5_a, b5_a->var, tmp_12->var);
            f(a1_a->var, jmi_array_size(a1_a, 0), tmp_7->var, jmi_array_size(a2_a, 0), tmp_8->var, jmi_array_size(a3_a, 0), a4_a->var, jmi_array_size(a4_a, 0), tmp_9->var, jmi_array_size(a5_a, 0), b1_a->var, jmi_array_size(b1_a, 0), tmp_10->var, jmi_array_size(b2_a, 0), tmp_11->var, jmi_array_size(b3_a, 0), b4_a->var, jmi_array_size(b4_a, 0), tmp_12->var, jmi_array_size(b5_a, 0));
            jmi_copy_matrix_from_int(b2_a, tmp_10->var, b2_a->var);
            jmi_copy_matrix_from_int(b3_a, tmp_11->var, b3_a->var);
            jmi_copy_matrix_from_int(b5_a, tmp_12->var, b5_a->var);
            JMCEVAL_check(\"DONE\");
            JMCEVAL_printArray(Real, b1_a);
            JMCEVAL_printArray(Integer, b2_a);
            JMCEVAL_printArray(Boolean, b3_a);
            JMCEVAL_printArray(String, b4_a);
            JMCEVAL_printArray(Enum, b5_a);


---

---

")})));
end Array;

package Os
    class Obj1
        extends ExternalObject;
        function constructor
            input Real x;
            input Integer y;
            input Boolean b;
            input String s;
            output Obj1 o1;
            external "C" o1 = my_constructor1(x,y,b,s);
                annotation(Library="extObjects", Include="#include \"extObjects.h\"");
        end constructor;
        function destructor
            input Obj1 o1;
            external "C"
                annotation(Library="extObjects", Include="#include \"extObjects.h\"");
        end destructor;
    end Obj1;
    end Os;
model ExtObj1
    class Obj2
        extends ExternalObject;
        function constructor
            input Real[:] x;
            input Integer[2] y;
            input Boolean[:] b;
            input String[:] s;
            output Obj2 o2;
            external "C" my_constructor2(x,y,o2,b,s);
                annotation(Library="extObjects", Include="#include \"extObjects.h\"");
        end constructor;
        function destructor
            input Obj2 o2;
            external "C"
                annotation(Library="extObjects", Include="#include \"extObjects.h\"");
        end destructor;
    end Obj2;
    class Obj3
        extends ExternalObject;
        function constructor
            input Os.Obj1 o1;
            input Obj2[:] o2;
            output Obj3 o3;
            external "C" my_constructor3(o1,o2,o3);
                annotation(Library="extObjects", Include="#include \"extObjects.h\"");
        end constructor;
        function destructor
            input Obj3 o3;
            external "C"
                annotation(Library="extObjects", Include="#include \"extObjects.h\"");
        end destructor;
    end Obj3;
    function use2
        input  Obj2 o2;
        output Real x;
        external annotation(Library="extObjects", Include="#include \"extObjects.h\"");
    end use2;
    function use3
        input  Obj3 o3;
        output Real x;
        external annotation(Library="extObjects", Include="#include \"extObjects.h\"");
    end use3;
    Os.Obj1 o1 = Os.Obj1(3.13, 3, true, "A message");
    Obj2 o2 = Obj2({3.13,3.14}, {3,4}, {false, true}, {"A message 1", "A message 2"});
    Obj3 o3 = Obj3(o1,{o2,o2});
    Real x = use2(o2);

    annotation(__JModelica(UnitTesting(tests={
        CCodeGenTestCase(
            name="ExternalFunction_CEval_ExtObj1",
            description="Test code gen for external C functions evaluation. External objects.",
            variability_propagation=false,
            inline_functions="none",
            template="
$ECE_external_includes$
$ECE_record_definitions$
$ECE_decl$
---
$ECE_setup_decl$
---
$ECE_setup_init$
---
$ECE_setup_free$
---
$ECE_calc_decl$
---
$ECE_calc_init$
---
$ECE_calc$
---
$ECE_calc_free$
---
$ECE_free$
",
            generatedCode="
#include \"extObjects.h\"


        JMI_DEF(EXO, o2_v)

---
        JMI_ARR(DYNA, jmi_int_t, jmi_int_array_t, tmp_13, -1, 1)
        JMI_ARR(DYNA, jmi_int_t, jmi_int_array_t, tmp_14, -1, 1)
        JMI_ARR(DYNAREAL, jmi_ad_var_t, jmi_array_t, tmp_15_arg0, -1, 1)
        JMI_ARR(STAT, jmi_ad_var_t, jmi_array_t, tmp_15_arg1, 2, 1)
        JMI_ARR(DYNA, jmi_ad_var_t, jmi_array_t, tmp_15_arg2, -1, 1)
        JMI_ARR(DYNA, jmi_string_t, jmi_string_array_t, tmp_15_arg3, -1, 1)

---
        JMCEVAL_parseArrayDims(1);
        JMI_ARRAY_INIT_1(DYNAREAL, jmi_ad_var_t, jmi_array_t, tmp_15_arg0, d[0], 1, d[0])
        JMCEVAL_parseArray(Real, tmp_15_arg0);
        JMCEVAL_parseArrayDims(1);
        JMI_ARRAY_INIT_1(STAT, jmi_ad_var_t, jmi_array_t, tmp_15_arg1, d[0], 1, d[0])
        JMCEVAL_parseArray(Integer, tmp_15_arg1);
        JMCEVAL_parseArrayDims(1);
        JMI_ARRAY_INIT_1(DYNA, jmi_ad_var_t, jmi_array_t, tmp_15_arg2, d[0], 1, d[0])
        JMCEVAL_parseArray(Boolean, tmp_15_arg2);
        JMCEVAL_parseArrayDims(1);
        JMI_ARRAY_INIT_1(DYNA, jmi_string_t, jmi_string_array_t, tmp_15_arg3, d[0], 1, d[0])
        JMCEVAL_parseArray(String, tmp_15_arg3);
        JMI_ARRAY_INIT_1(DYNA, jmi_int_t, jmi_int_array_t, tmp_13, jmi_array_size(tmp_15_arg1, 0), 1, jmi_array_size(tmp_15_arg1, 0))
        jmi_copy_matrix_to_int(tmp_15_arg1, tmp_15_arg1->var, tmp_13->var);
        JMI_ARRAY_INIT_1(DYNA, jmi_int_t, jmi_int_array_t, tmp_14, jmi_array_size(tmp_15_arg2, 0), 1, jmi_array_size(tmp_15_arg2, 0))
        jmi_copy_matrix_to_int(tmp_15_arg2, tmp_15_arg2->var, tmp_14->var);
        my_constructor2(tmp_15_arg0->var, tmp_13->var, &o2_v, tmp_14->var, tmp_15_arg3->var);

---

---
        JMI_DEF(REA, x_v)

---
        JMCEVAL_parse(Real, x_v);

---
            x_v = use2(o2_v);
            JMCEVAL_check(\"DONE\");
            JMCEVAL_print(Real, x_v);


---

---
        destructor(o2_v);

")})));
end ExtObj1;

model ExtObj2
    extends ExtObj1(x=use3(o3));

    annotation(__JModelica(UnitTesting(tests={
        CCodeGenTestCase(
            name="ExternalFunction_CEval_ExtObj2",
            description="Test code gen for external C functions evaluation. External objects.",
            variability_propagation=false,
            inline_functions="none",
            template="
$ECE_external_includes$
$ECE_record_definitions$
$ECE_decl$
---
$ECE_setup_decl$
---
$ECE_setup_init$
---
$ECE_setup_free$
---
$ECE_calc_decl$
---
$ECE_calc_init$
---
$ECE_calc$
---
$ECE_calc_free$
---
$ECE_free$
",
            generatedCode="
#include \"extObjects.h\"


        JMI_DEF(EXO, o3_v)

---
        JMI_DEF(EXO, tmp_16_arg0)
        JMI_DEF(INT_EXT, tmp_17)
        JMI_DEF(BOO_EXT, tmp_18)
        JMI_DEF(REA, tmp_19_arg0)
        JMI_DEF(INT, tmp_19_arg1)
        JMI_DEF(BOO, tmp_19_arg2)
        JMI_DEF(STR, tmp_19_arg3)
        JMI_ARR(DYNA, jmi_extobj_t, jmi_extobj_array_t, tmp_16_arg1, -1, 1)
        JMI_DEF(REA, tmp_20)
        JMI_DEF(REA, tmp_20_max)
        JMI_ARR(DYNA, jmi_int_t, jmi_int_array_t, tmp_21, -1, 1)
        JMI_ARR(DYNA, jmi_int_t, jmi_int_array_t, tmp_22, -1, 1)
        JMI_ARR(DYNAREAL, jmi_ad_var_t, jmi_array_t, tmp_23_arg0, -1, 1)
        JMI_ARR(DYNA, jmi_ad_var_t, jmi_array_t, tmp_23_arg1, -1, 1)
        JMI_ARR(DYNA, jmi_ad_var_t, jmi_array_t, tmp_23_arg2, -1, 1)
        JMI_ARR(DYNA, jmi_string_t, jmi_string_array_t, tmp_23_arg3, -1, 1)

---
        JMCEVAL_parse(Real, tmp_19_arg0);
        JMCEVAL_parse(Integer, tmp_19_arg1);
        JMCEVAL_parse(Boolean, tmp_19_arg2);
        JMCEVAL_parse(String, tmp_19_arg3);
        tmp_17 = (int)tmp_19_arg1;
        tmp_18 = (int)tmp_19_arg2;
        tmp_16_arg0 = my_constructor1(tmp_19_arg0, tmp_17, tmp_18, tmp_19_arg3);
        JMCEVAL_parseArrayDims(1);
        JMI_ARRAY_INIT_1(DYNA, jmi_extobj_t, jmi_extobj_array_t, tmp_16_arg1, d[0], 1, d[0])
        tmp_20_max = d[0] + 1;
        for (tmp_20 = 1; tmp_20 < tmp_20_max; tmp_20++) {
            JMCEVAL_parseArrayDims(1);
            JMI_ARRAY_INIT_1(DYNAREAL, jmi_ad_var_t, jmi_array_t, tmp_23_arg0, d[0], 1, d[0])
            JMCEVAL_parseArray(Real, tmp_23_arg0);
            JMCEVAL_parseArrayDims(1);
            JMI_ARRAY_INIT_1(DYNA, jmi_ad_var_t, jmi_array_t, tmp_23_arg1, d[0], 1, d[0])
            JMCEVAL_parseArray(Integer, tmp_23_arg1);
            JMCEVAL_parseArrayDims(1);
            JMI_ARRAY_INIT_1(DYNA, jmi_ad_var_t, jmi_array_t, tmp_23_arg2, d[0], 1, d[0])
            JMCEVAL_parseArray(Boolean, tmp_23_arg2);
            JMCEVAL_parseArrayDims(1);
            JMI_ARRAY_INIT_1(DYNA, jmi_string_t, jmi_string_array_t, tmp_23_arg3, d[0], 1, d[0])
            JMCEVAL_parseArray(String, tmp_23_arg3);
            JMI_ARRAY_INIT_1(DYNA, jmi_int_t, jmi_int_array_t, tmp_21, jmi_array_size(tmp_23_arg1, 0), 1, jmi_array_size(tmp_23_arg1, 0))
            jmi_copy_matrix_to_int(tmp_23_arg1, tmp_23_arg1->var, tmp_21->var);
            JMI_ARRAY_INIT_1(DYNA, jmi_int_t, jmi_int_array_t, tmp_22, jmi_array_size(tmp_23_arg2, 0), 1, jmi_array_size(tmp_23_arg2, 0))
            jmi_copy_matrix_to_int(tmp_23_arg2, tmp_23_arg2->var, tmp_22->var);
            my_constructor2(tmp_23_arg0->var, tmp_21->var, &jmi_array_ref_1(tmp_16_arg1, tmp_20), tmp_22->var, tmp_23_arg3->var);
        }
        my_constructor3(tmp_16_arg0, tmp_16_arg1->var, &o3_v);

---
        destructor(tmp_16_arg0);
        for (tmp_20 = 1; tmp_20 < tmp_20_max; tmp_20++) {
            destructor(jmi_array_ref_1(tmp_16_arg1, tmp_20));
        }

---
        JMI_DEF(REA, x_v)

---
        JMCEVAL_parse(Real, x_v);

---
            x_v = use3(o3_v);
            JMCEVAL_check(\"DONE\");
            JMCEVAL_print(Real, x_v);


---

---
        destructor(o3_v);
")})));
end ExtObj2;

model Dgelsx
    function dgelsx
      "Computes the minimum-norm solution to a real linear least squares problem with rank deficient A"
      input Real A[:, :];
      input Real B[size(A, 1), :];
      input Real rcond=0.0 "Reciprocal condition number to estimate rank";
      output Real X[max(size(A, 1), size(A, 2)), size(B, 2)]=cat(
                1,
                B,
                zeros(max(nrow, ncol) - nrow, nrhs))
        "Solution is in first size(A,2) rows";
      output Integer info;
      output Integer rank "Effective rank of A";
    protected
      Integer nrow=size(A, 1);
      Integer ncol=size(A, 2);
      Integer nx=max(nrow, ncol);
      Integer nrhs=size(B, 2);
      Integer lwork=max(min(nrow, ncol) + 3*ncol, 2*min(nrow, ncol) + nrhs);
      Real work[max(min(size(A, 1), size(A, 2)) + 3*size(A, 2), 2*min(size(A, 1),
        size(A, 2)) + size(B, 2))];
      Real Awork[size(A, 1), size(A, 2)]=A;
      Integer jpvt[size(A, 2)]=zeros(ncol);
    external"FORTRAN 77" dgelsx(
              nrow,
              ncol,
              nrhs,
              Awork,
              nrow,
              X,
              nx,
              jpvt,
              rcond,
              rank,
              work,
              lwork,
              info);
    end dgelsx;
    
    Real[2,1] out;
    Real a;
    Real b;
  equation
    (out,a,b) = dgelsx({{1},{2}},{{1},{2}},1);

    annotation(__JModelica(UnitTesting(tests={
        CCodeGenTestCase(
            name="ExternalFunction_CEval_Dgelsx",
            description="Test code gen ceval of external functions.",
            variability_propagation=false,
            inline_functions="none",
            template="
$ECE_external_includes$
$ECE_record_definitions$
$ECE_decl$
---
$ECE_setup_decl$
---
$ECE_setup_init$
---
$ECE_setup_free$
---
$ECE_calc_decl$
---
$ECE_calc_init$
---
$ECE_calc$
---
$ECE_calc_free$
---
$ECE_free$
",
            generatedCode="
---

---

---

---
        JMI_DEF(INT, nrow_v)
        JMI_DEF(INT, ncol_v)
        JMI_DEF(INT, nrhs_v)
        JMI_ARR(DYNAREAL, jmi_ad_var_t, jmi_array_t, Awork_a, -1, 2)
        JMI_ARR(DYNAREAL, jmi_ad_var_t, jmi_array_t, X_a, -1, 2)
        JMI_DEF(INT, nx_v)
        JMI_ARR(DYNA, jmi_ad_var_t, jmi_array_t, jpvt_a, -1, 1)
        JMI_DEF(REA, rcond_v)
        JMI_DEF(INT, rank_v)
        JMI_ARR(DYNAREAL, jmi_ad_var_t, jmi_array_t, work_a, -1, 1)
        JMI_DEF(INT, lwork_v)
        JMI_DEF(INT, info_v)
        JMI_DEF(INT_EXT, tmp_24)
        JMI_DEF(INT_EXT, tmp_25)
        JMI_DEF(INT_EXT, tmp_26)
        JMI_ARR(DYNAREAL, jmi_ad_var_t, jmi_array_t, tmp_27, -1, 2)
        JMI_DEF(INT_EXT, tmp_28)
        JMI_ARR(DYNAREAL, jmi_ad_var_t, jmi_array_t, tmp_29, -1, 2)
        JMI_DEF(INT_EXT, tmp_30)
        JMI_ARR(DYNA, jmi_int_t, jmi_int_array_t, tmp_31, -1, 1)
        JMI_DEF(INT_EXT, tmp_32)
        JMI_DEF(INT_EXT, tmp_33)
        JMI_DEF(INT_EXT, tmp_34)
        extern void dgelsx_(int*, int*, int*, double*, int*, double*, int*, int*, double*, int*, double*, int*, int*);

---
        JMCEVAL_parse(Integer, nrow_v);
        JMCEVAL_parse(Integer, ncol_v);
        JMCEVAL_parse(Integer, nrhs_v);
        JMCEVAL_parseArrayDims(2);
        JMI_ARRAY_INIT_2(DYNAREAL, jmi_ad_var_t, jmi_array_t, Awork_a, d[0]*d[1], 2, d[0], d[1])
        JMCEVAL_parseArray(Real, Awork_a);
        JMCEVAL_parseArrayDims(2);
        JMI_ARRAY_INIT_2(DYNAREAL, jmi_ad_var_t, jmi_array_t, X_a, d[0]*d[1], 2, d[0], d[1])
        JMCEVAL_parseArray(Real, X_a);
        JMCEVAL_parse(Integer, nx_v);
        JMCEVAL_parseArrayDims(1);
        JMI_ARRAY_INIT_1(DYNA, jmi_ad_var_t, jmi_array_t, jpvt_a, d[0], 1, d[0])
        JMCEVAL_parseArray(Integer, jpvt_a);
        JMCEVAL_parse(Real, rcond_v);
        JMCEVAL_parse(Integer, rank_v);
        JMCEVAL_parseArrayDims(1);
        JMI_ARRAY_INIT_1(DYNAREAL, jmi_ad_var_t, jmi_array_t, work_a, d[0], 1, d[0])
        JMCEVAL_parseArray(Real, work_a);
        JMCEVAL_parse(Integer, lwork_v);
        JMCEVAL_parse(Integer, info_v);

---
            tmp_24 = (int)nrow_v;
            tmp_25 = (int)ncol_v;
            tmp_26 = (int)nrhs_v;
            JMI_ARRAY_INIT_2(DYNAREAL, jmi_ad_var_t, jmi_array_t, tmp_27, jmi_array_size(Awork_a, 0) * jmi_array_size(Awork_a, 1), 2, jmi_array_size(Awork_a, 0), jmi_array_size(Awork_a, 1))
            jmi_matrix_to_fortran_real(Awork_a, Awork_a->var, tmp_27->var);
            tmp_28 = (int)nrow_v;
            JMI_ARRAY_INIT_2(DYNAREAL, jmi_ad_var_t, jmi_array_t, tmp_29, jmi_array_size(X_a, 0) * jmi_array_size(X_a, 1), 2, jmi_array_size(X_a, 0), jmi_array_size(X_a, 1))
            jmi_matrix_to_fortran_real(X_a, X_a->var, tmp_29->var);
            tmp_30 = (int)nx_v;
            JMI_ARRAY_INIT_1(DYNA, jmi_int_t, jmi_int_array_t, tmp_31, jmi_array_size(jpvt_a, 0), 1, jmi_array_size(jpvt_a, 0))
            jmi_matrix_to_fortran_int(jpvt_a, jpvt_a->var, tmp_31->var);
            tmp_32 = (int)rank_v;
            tmp_33 = (int)lwork_v;
            tmp_34 = (int)info_v;
            dgelsx_(&tmp_24, &tmp_25, &tmp_26, tmp_27->var, &tmp_28, tmp_29->var, &tmp_30, tmp_31->var, &rcond_v, &tmp_32, work_a->var, &tmp_33, &tmp_34);
            jmi_matrix_from_fortran_real(X_a, tmp_29->var, X_a->var);
            rank_v = tmp_32;
            info_v = tmp_34;
            JMCEVAL_check(\"DONE\");
            JMCEVAL_printArray(Real, X_a);
            JMCEVAL_print(Integer, rank_v);
            JMCEVAL_print(Integer, info_v);


---

---

")})));
end Dgelsx;

model Record
    record R
        Real a1;
        Integer a2;
        Boolean a3;
        String a4;
        E a5;
        R2 r2;
    end R;
    record R2
        Real x;
    end R2;
    
    type E = enumeration(A,B);
    function f
        input R a;
        output R b;
        external f(a,b);
    end f;
    
    R r = f(R(1,2,true,"s",E.A, R2(3)));
    annotation(__JModelica(UnitTesting(tests={
        CCodeGenTestCase(
           name="ExternalFunction_CEval_Record",
            description="Test code gen for external C functions evaluation. Record.",
            template="
$ECE_external_includes$
$ECE_record_definitions$
$ECE_decl$
---
$ECE_setup_decl$
---
$ECE_setup_init$
---
$ECE_setup_free$
---
$ECE_calc_decl$
---
$ECE_calc_init$
---
$ECE_calc$
---
$ECE_calc_free$
---
$ECE_free$
",
            generatedCode="
    typedef struct R2_0_r_ R2_0_r;
    struct R2_0_r_ {
        jmi_ad_var_t x;
    };
    JMI_ARRAY_TYPE(R2_0_r, R2_0_ra)

    typedef struct R2_0_r_ext_ R2_0_r_ext;
    struct R2_0_r_ext_ {
        jmi_ad_var_t x;
    };

    typedef struct R_1_r_ R_1_r;
    struct R_1_r_ {
        jmi_ad_var_t a1;
        jmi_ad_var_t a2;
        jmi_ad_var_t a3;
        jmi_string_t a4;
        jmi_ad_var_t a5;
        R2_0_r* r2;
    };
    JMI_ARRAY_TYPE(R_1_r, R_1_ra)

    typedef struct R_1_r_ext_ R_1_r_ext;
    struct R_1_r_ext_ {
        jmi_ad_var_t a1;
        jmi_int_t a2;
        jmi_int_t a3;
        jmi_string_t a4;
        jmi_int_t a5;
        R2_0_r_ext r2;
    };



---

---

---

---
        JMI_RECORD_STATIC(R_1_r, a_v)
        JMI_RECORD_STATIC(R2_0_r, tmp_35)
        JMI_RECORD_STATIC(R_1_r, b_v)
        JMI_RECORD_STATIC(R2_0_r, tmp_36)
        JMI_RECORD_STATIC(R_1_r_ext, tmp_37)
        JMI_RECORD_STATIC(R_1_r_ext, tmp_38)

---
        JMCEVAL_parse(Real, a_v->a1);
        JMCEVAL_parse(Integer, a_v->a2);
        JMCEVAL_parse(Boolean, a_v->a3);
        JMCEVAL_parse(String, a_v->a4);
        JMCEVAL_parse(Enum, a_v->a5);
        JMCEVAL_parse(Real, tmp_35->x);
        a_v->r2 = tmp_35;
        JMCEVAL_parse(Real, b_v->a1);
        JMCEVAL_parse(Integer, b_v->a2);
        JMCEVAL_parse(Boolean, b_v->a3);
        JMCEVAL_parse(String, b_v->a4);
        JMCEVAL_parse(Enum, b_v->a5);
        JMCEVAL_parse(Real, tmp_36->x);
        b_v->r2 = tmp_36;

---
            tmp_37->a1 = (double)a_v->a1;
            tmp_37->a2 = (int)a_v->a2;
            tmp_37->a3 = (int)a_v->a3;
            JMI_ASG(STR, tmp_37->a4, a_v->a4)
            tmp_37->a5 = (int)a_v->a5;
            tmp_37->r2.x = (double)a_v->r2->x;
            tmp_38->a1 = (double)b_v->a1;
            tmp_38->a2 = (int)b_v->a2;
            tmp_38->a3 = (int)b_v->a3;
            JMI_ASG(STR, tmp_38->a4, b_v->a4)
            tmp_38->a5 = (int)b_v->a5;
            tmp_38->r2.x = (double)b_v->r2->x;
            f(tmp_37, tmp_38);
            b_v->a1 = tmp_38->a1;
            b_v->a2 = tmp_38->a2;
            b_v->a3 = tmp_38->a3;
            JMI_ASG(STR, tmp_38->a4, b_v->a4)
            b_v->a5 = tmp_38->a5;
            b_v->r2->x = tmp_38->r2.x;
            JMCEVAL_check(\"DONE\");
            JMCEVAL_print(Real, b_v->a1);
            JMCEVAL_print(Integer, b_v->a2);
            JMCEVAL_print(Boolean, b_v->a3);
            JMCEVAL_print(String, b_v->a4);
            JMCEVAL_print(Enum, b_v->a5);
            JMCEVAL_print(Real, b_v->r2->x);


---

---

")})));
end Record;

model RecordExternalObject
    record R1
        R2 r2;
    end R1;
    record R2
        Real x;
    end R2;
    
    model EO
        extends ExternalObject;
        function constructor
            input R1 r1;
            output EO eo;
            external;
        end constructor;
        function destructor
            input EO eo;
            external;
        end destructor;
    end EO;
    
    function f
        input EO eo;
        output Real y;
        external;
    end f;
    
    parameter EO eo = EO(R1(R2(3)));
    Real y = f(eo);
    
    annotation(__JModelica(UnitTesting(tests={
        CCodeGenTestCase(
           name="ExternalFunction_CEval_RecordExternalObject",
            description="Test code gen for external C functions evaluation. Record.",
            template="
$ECE_external_includes$
$ECE_record_definitions$
$ECE_decl$
---
$ECE_setup_decl$
---
$ECE_setup_init$
---
$ECE_setup_free$
---
$ECE_calc_decl$
---
$ECE_calc_init$
---
$ECE_calc$
---
$ECE_calc_free$
---
$ECE_free$
",
            generatedCode="
    typedef struct R2_0_r_ R2_0_r;
    struct R2_0_r_ {
        jmi_ad_var_t x;
    };
    JMI_ARRAY_TYPE(R2_0_r, R2_0_ra)

    typedef struct R2_0_r_ext_ R2_0_r_ext;
    struct R2_0_r_ext_ {
        jmi_ad_var_t x;
    };

    typedef struct R1_1_r_ R1_1_r;
    struct R1_1_r_ {
        R2_0_r* r2;
    };
    JMI_ARRAY_TYPE(R1_1_r, R1_1_ra)

    typedef struct R1_1_r_ext_ R1_1_r_ext;
    struct R1_1_r_ext_ {
        R2_0_r_ext r2;
    };


        JMI_DEF(EXO, eo_v)

---
        JMI_RECORD_STATIC(R1_1_r_ext, tmp_39)
        JMI_RECORD_STATIC(R1_1_r, tmp_40_arg0)
        JMI_RECORD_STATIC(R2_0_r, tmp_41)

---
        JMCEVAL_parse(Real, tmp_41->x);
        tmp_40_arg0->r2 = tmp_41;
        tmp_39->r2.x = (double)tmp_40_arg0->r2->x;
        eo_v = constructor(tmp_39);

---

---
        JMI_DEF(REA, y_v)

---
        JMCEVAL_parse(Real, y_v);

---
            y_v = f(eo_v);
            JMCEVAL_check(\"DONE\");
            JMCEVAL_print(Real, y_v);


---

---
        destructor(eo_v);
")})));
end RecordExternalObject;
end CEval;
end ExternalFunction;

end ExternalFunctionCCodeGenTests;
