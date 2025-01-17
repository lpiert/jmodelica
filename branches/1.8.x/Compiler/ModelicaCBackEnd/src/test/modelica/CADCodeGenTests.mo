package CADCodeGenTests

model CADsin
 annotation(JModelica(unitTesting = JModelica.UnitTesting(testCase={
     JModelica.UnitTesting.CADCodeGenTestCase(
         name="CADsin",
         description="",
         generate_dae_jacobian=true,
         template="$C_DAE_equation_directional_derivative$",
         generatedCode="
jmi_ad_var_t v_0;
jmi_ad_var_t d_0;
v_0 = sin(_x1_1);
d_0 = (*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx] * cos(_x1_1);
(*res)[0] = v_0 - _y_0;
(*dF)[0] = d_0 - (*dz)[jmi_get_index_from_value_ref(0)-jmi->offs_real_dx];
(*res)[1] = 1 - _x1_1;
(*dF)[1] = AD_WRAP_LITERAL(0) - (*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx];
")})));

	Real y;
	Real x1(start=1.5);
equation
	y = sin(x1);
	x1 = 1;
end CADsin;

model CADcos
 annotation(JModelica(unitTesting = JModelica.UnitTesting(testCase={
     JModelica.UnitTesting.CADCodeGenTestCase(
         name="CADcos",
         description="",
         generate_dae_jacobian=true,
         template="$C_DAE_equation_directional_derivative$",
         generatedCode="
jmi_ad_var_t v_0;
jmi_ad_var_t d_0;
v_0 = cos(_x1_1);
d_0 = (*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx] * -sin(_x1_1);
(*res)[0] = v_0 - _y_0;
(*dF)[0] = d_0 - (*dz)[jmi_get_index_from_value_ref(0)-jmi->offs_real_dx];
(*res)[1] = 1 - _x1_1;
(*dF)[1] = AD_WRAP_LITERAL(0) - (*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx];
")})));

  Real y;
  Real x1(start=1.5); 
equation 
  y = cos(x1);
  x1 = 1;
end CADcos;

model CADtan
 annotation(JModelica(unitTesting = JModelica.UnitTesting(testCase={
     JModelica.UnitTesting.CADCodeGenTestCase(
         name="CADtan",
         description="",
         generate_dae_jacobian=true,
         template="$C_DAE_equation_directional_derivative$",
         generatedCode="
jmi_ad_var_t v_0;
jmi_ad_var_t d_0;
v_0 = tan(_x1_1);
d_0 = (*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx] * 1/(cos(_x1_1)*cos(_x1_1));
(*res)[0] = v_0 - _y_0;
(*dF)[0] = d_0 - (*dz)[jmi_get_index_from_value_ref(0)-jmi->offs_real_dx];
(*res)[1] = 1 - _x1_1;
(*dF)[1] = AD_WRAP_LITERAL(0) - (*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx];
")})));

	Real y;
	Real x1(start=1.5);
equation
	y = tan(x1);
	x1 = 1;
end CADtan;

model CADasin
 annotation(JModelica(unitTesting = JModelica.UnitTesting(testCase={
     JModelica.UnitTesting.CADCodeGenTestCase(
         name="CADasin",
         description="",
         generate_dae_jacobian=true,
         template="$C_DAE_equation_directional_derivative$",
         generatedCode="
jmi_ad_var_t v_0;
jmi_ad_var_t d_0;
v_0 = asin(_x1_1);
d_0 = (*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx] * 1/(sqrt(1 -_x1_1*_x1_1));
(*res)[0] = v_0 - _y_0;
(*dF)[0] = d_0 - (*dz)[jmi_get_index_from_value_ref(0)-jmi->offs_real_dx];
(*res)[1] = 1 - _x1_1;
(*dF)[1] = AD_WRAP_LITERAL(0) - (*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx];
")})));


	Real y;
	Real x1(start=1.5);
equation
	y = asin(x1);
	x1 = 1;
end CADasin;

model CADacos
 annotation(JModelica(unitTesting = JModelica.UnitTesting(testCase={
     JModelica.UnitTesting.CADCodeGenTestCase(
         name="CADacos",
         description="",
         generate_dae_jacobian=true,
         template="$C_DAE_equation_directional_derivative$",
         generatedCode="
jmi_ad_var_t v_0;
jmi_ad_var_t d_0;
v_0 = acos(_x1_1);
d_0 = -(*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx] * 1/(sqrt(1 -_x1_1*_x1_1));
(*res)[0] = v_0 - _y_0;
(*dF)[0] = d_0 - (*dz)[jmi_get_index_from_value_ref(0)-jmi->offs_real_dx];
(*res)[1] = 1 - _x1_1;
(*dF)[1] = AD_WRAP_LITERAL(0) - (*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx];
")})));


	Real y;
	Real x1(start=1.5);
equation
	y = acos(x1);
	x1 = 1;
end CADacos;

model CADatan
 annotation(JModelica(unitTesting = JModelica.UnitTesting(testCase={
     JModelica.UnitTesting.CADCodeGenTestCase(
         name="CADatan",
         description="",
         generate_dae_jacobian=true,
         template="$C_DAE_equation_directional_derivative$",
         generatedCode="
jmi_ad_var_t v_0;
jmi_ad_var_t d_0;
v_0 = atan(_x1_1);
d_0 = (*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx] * 1/(1 +_x1_1*_x1_1);
(*res)[0] = v_0 - _y_0;
(*dF)[0] = d_0 - (*dz)[jmi_get_index_from_value_ref(0)-jmi->offs_real_dx];
(*res)[1] = 1 - _x1_1;
(*dF)[1] = AD_WRAP_LITERAL(0) - (*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx];
")})));


	Real y;
	Real x1(start=1.5);
equation
	y = atan(x1);
	x1 = 1;
end CADatan;

model CADatan2
 annotation(JModelica(unitTesting = JModelica.UnitTesting(testCase={
     JModelica.UnitTesting.CADCodeGenTestCase(
         name="CADatan2",
         description="",
         generate_dae_jacobian=true,
         template="$C_DAE_equation_directional_derivative$",
         generatedCode="
jmi_ad_var_t v_0;
jmi_ad_var_t d_0;

jmi_ad_var_t v_1;
jmi_ad_var_t d_1;
v_0 = atan2(_x1_1,_x2_2);
d_0 = ((*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx] * _x2_2 - _x1_1 * (*dz)[jmi_get_index_from_value_ref(2)-jmi->offs_real_dx] ) / ( _x2_2*_x2_2 + _x1_1*_x1_1);
(*res)[0] = v_0 - _y_0;
(*dF)[0] = d_0 - (*dz)[jmi_get_index_from_value_ref(0)-jmi->offs_real_dx];
(*res)[1] = 1 - _x1_1;
(*dF)[1] = AD_WRAP_LITERAL(0) - (*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx];
v_1 = -1.5;
d_1 = -AD_WRAP_LITERAL(0);
(*res)[2] = v_1 - _x2_2;
(*dF)[2] = d_1 - (*dz)[jmi_get_index_from_value_ref(2)-jmi->offs_real_dx];
")})));


	Real y;
	Real x1(start=1.5);
	Real x2(start=2.0);
equation
	y = atan2(x1,x2);
	x1 = 1;
	x2 = (-1.5);
end CADatan2;

model CADsinh
 annotation(JModelica(unitTesting = JModelica.UnitTesting(testCase={
     JModelica.UnitTesting.CADCodeGenTestCase(
         name="CADsinh",
         description="",
         generate_dae_jacobian=true,
         template="$C_DAE_equation_directional_derivative$",
         generatedCode="
jmi_ad_var_t v_0;
jmi_ad_var_t d_0;
v_0 = sinh(_x1_1);
d_0 = (*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx] * cosh(_x1_1);
(*res)[0] = v_0 - _y_0;
(*dF)[0] = d_0 - (*dz)[jmi_get_index_from_value_ref(0)-jmi->offs_real_dx];
(*res)[1] = 1 - _x1_1;
(*dF)[1] = AD_WRAP_LITERAL(0) - (*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx];
")})));


	Real y;
	Real x1(start=1.5);
equation
	y = sinh(x1);
	x1 = 1;
end CADsinh;

model CADcosh
 annotation(JModelica(unitTesting = JModelica.UnitTesting(testCase={
     JModelica.UnitTesting.CADCodeGenTestCase(
         name="CADcosh",
         description="",
         generate_dae_jacobian=true,
         template="$C_DAE_equation_directional_derivative$",
         generatedCode="
jmi_ad_var_t v_0;
jmi_ad_var_t d_0;
v_0 = cosh(_x1_1);
d_0 = (*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx] * sinh(_x1_1);
(*res)[0] = v_0 - _y_0;
(*dF)[0] = d_0 - (*dz)[jmi_get_index_from_value_ref(0)-jmi->offs_real_dx];
(*res)[1] = 1 - _x1_1;
(*dF)[1] = AD_WRAP_LITERAL(0) - (*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx];
")})));


	Real y;
	Real x1(start=1.5);
equation
	y = cosh(x1);
	x1 = 1;
end CADcosh;

model CADtanh
 annotation(JModelica(unitTesting = JModelica.UnitTesting(testCase={
     JModelica.UnitTesting.CADCodeGenTestCase(
         name="CADtanh",
         description="",
         generate_dae_jacobian=true,
         template="$C_DAE_equation_directional_derivative$",
         generatedCode="
jmi_ad_var_t v_0;
jmi_ad_var_t d_0;
v_0 = tanh(_x1_1);
d_0 = (*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx] * (1 - tanh(_x1_1) * tanh(_x1_1));
(*res)[0] = v_0 - _y_0;
(*dF)[0] = d_0 - (*dz)[jmi_get_index_from_value_ref(0)-jmi->offs_real_dx];
(*res)[1] = 1 - _x1_1;
(*dF)[1] = AD_WRAP_LITERAL(0) - (*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx];
")})));



	Real y;
	Real x1(start=1.5);
equation
	y = tanh(x1);
	x1 = 1;
end CADtanh;

model CADexp
 annotation(JModelica(unitTesting = JModelica.UnitTesting(testCase={
     JModelica.UnitTesting.CADCodeGenTestCase(
         name="CADexp",
         description="",
         generate_dae_jacobian=true,
         template="$C_DAE_equation_directional_derivative$",
         generatedCode="
jmi_ad_var_t v_0;
jmi_ad_var_t d_0;
v_0 = exp(_x1_1);
d_0 = (*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx] * exp(_x1_1);
(*res)[0] = v_0 - _y_0;
(*dF)[0] = d_0 - (*dz)[jmi_get_index_from_value_ref(0)-jmi->offs_real_dx];
(*res)[1] = 1 - _x1_1;
(*dF)[1] = AD_WRAP_LITERAL(0) - (*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx];
")})));



	Real y;
	Real x1(start=1.5);
equation
	y = exp(x1);
	x1 = 1;
end CADexp;

model CADlog
 annotation(JModelica(unitTesting = JModelica.UnitTesting(testCase={
     JModelica.UnitTesting.CADCodeGenTestCase(
         name="CADlog",
         description="",
         generate_dae_jacobian=true,
         template="$C_DAE_equation_directional_derivative$",
         generatedCode="
jmi_ad_var_t v_0;
jmi_ad_var_t d_0;
v_0 = log(_x1_1);
d_0 = (*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx] * 1/(_x1_1);
(*res)[0] = v_0 - _y_0;
(*dF)[0] = d_0 - (*dz)[jmi_get_index_from_value_ref(0)-jmi->offs_real_dx];
(*res)[1] = 2 - _x1_1;
(*dF)[1] = AD_WRAP_LITERAL(0) - (*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx];
")})));



	Real y;
	Real x1(start=1.5);
equation
	y = log(x1);
	x1 = 2;
end CADlog;

model CADlog10
 annotation(JModelica(unitTesting = JModelica.UnitTesting(testCase={
     JModelica.UnitTesting.CADCodeGenTestCase(
         name="CADlog10",
         description="",
         generate_dae_jacobian=true,
         template="$C_DAE_equation_directional_derivative$",
         generatedCode="
jmi_ad_var_t v_0;
jmi_ad_var_t d_0;
v_0 = log10(_x1_1);
d_0 = (*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx] * log10(exp(1))*1/(_x1_1);
(*res)[0] = v_0 - _y_0;
(*dF)[0] = d_0 - (*dz)[jmi_get_index_from_value_ref(0)-jmi->offs_real_dx];
(*res)[1] = 1 - _x1_1;
(*dF)[1] = AD_WRAP_LITERAL(0) - (*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx];
")})));



	Real y;
	Real x1(start=1.5);
equation
	y = log10(x1);
	x1 = 1;
end CADlog10;

model CADsqrt
 annotation(JModelica(unitTesting = JModelica.UnitTesting(testCase={
     JModelica.UnitTesting.CADCodeGenTestCase(
         name="CADsqrt",
         description="",
         generate_dae_jacobian=true,
         template="$C_DAE_equation_directional_derivative$",
         generatedCode="
jmi_ad_var_t v_0;
jmi_ad_var_t d_0;
v_0 = sqrt(_x1_1);
d_0 = (*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx] * 1/(2*sqrt(_x1_1));
(*res)[0] = v_0 - _y_0;
(*dF)[0] = d_0 - (*dz)[jmi_get_index_from_value_ref(0)-jmi->offs_real_dx];
(*res)[1] = 2 - _x1_1;
(*dF)[1] = AD_WRAP_LITERAL(0) - (*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx];
")})));



 	Real y;
	Real x1(start=1.5);
equation
	y = sqrt(x1);
	x1 = 2;
end CADsqrt;

model CADadd
 annotation(JModelica(unitTesting = JModelica.UnitTesting(testCase={
     JModelica.UnitTesting.CADCodeGenTestCase(
         name="CADadd",
         description="",
         generate_dae_jacobian=true,
         template="$C_DAE_equation_directional_derivative$",
         generatedCode="
jmi_ad_var_t v_0;
jmi_ad_var_t d_0;
v_0 = _x1_1 + _x2_2;
d_0 = (*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx] + (*dz)[jmi_get_index_from_value_ref(2)-jmi->offs_real_dx];
(*res)[0] = v_0 - _y_0;
(*dF)[0] = d_0 - (*dz)[jmi_get_index_from_value_ref(0)-jmi->offs_real_dx];
(*res)[1] = 1 - _x1_1;
(*dF)[1] = AD_WRAP_LITERAL(0) - (*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx];
(*res)[2] = 3 - _x2_2;
(*dF)[2] = AD_WRAP_LITERAL(0) - (*dz)[jmi_get_index_from_value_ref(2)-jmi->offs_real_dx];
")})));




	Real y;
	Real x1(start=1.5);
	Real x2(start=2.0);
equation
	y = x1 + x2;
	x1 = 1;
	x2 = 3;
end CADadd;

model CADsub
 annotation(JModelica(unitTesting = JModelica.UnitTesting(testCase={
     JModelica.UnitTesting.CADCodeGenTestCase(
         name="CADsub",
         description="",
         generate_dae_jacobian=true,
         template="$C_DAE_equation_directional_derivative$",
         generatedCode="
jmi_ad_var_t v_0;
jmi_ad_var_t d_0;
v_0 = _x1_1 - _x2_2;
d_0 = (*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx] - (*dz)[jmi_get_index_from_value_ref(2)-jmi->offs_real_dx];
(*res)[0] = v_0 - _y_0;
(*dF)[0] = d_0 - (*dz)[jmi_get_index_from_value_ref(0)-jmi->offs_real_dx];
(*res)[1] = 1 - _x1_1;
(*dF)[1] = AD_WRAP_LITERAL(0) - (*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx];
(*res)[2] = 3 - _x2_2;
(*dF)[2] = AD_WRAP_LITERAL(0) - (*dz)[jmi_get_index_from_value_ref(2)-jmi->offs_real_dx];
")})));




	Real y;
	Real x1(start=1.5);
	Real x2(start=2.0);
equation
	y = x1 - x2;
	x1 = 1;
	x2 = 3;
end CADsub;

model CADmul
 annotation(JModelica(unitTesting = JModelica.UnitTesting(testCase={
     JModelica.UnitTesting.CADCodeGenTestCase(
         name="CADmul",
         description="",
         generate_dae_jacobian=true,
         template="$C_DAE_equation_directional_derivative$",
         generatedCode="
jmi_ad_var_t v_0;
jmi_ad_var_t d_0;
v_0 = _x1_1 * _x2_2;
d_0 = ((*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx] * _x2_2 + _x1_1 * (*dz)[jmi_get_index_from_value_ref(2)-jmi->offs_real_dx]);
(*res)[0] = v_0 - _y_0;
(*dF)[0] = d_0 - (*dz)[jmi_get_index_from_value_ref(0)-jmi->offs_real_dx];
(*res)[1] = 1 - _x1_1;
(*dF)[1] = AD_WRAP_LITERAL(0) - (*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx];
(*res)[2] = 3 - _x2_2;
(*dF)[2] = AD_WRAP_LITERAL(0) - (*dz)[jmi_get_index_from_value_ref(2)-jmi->offs_real_dx];
")})));




	Real y;
	Real x1(start=1.5);
	Real x2(start=2.0);
equation
	y = x1 * x2;
	x1 = 1;
	x2 = 3;
end CADmul;

model CADdiv
 annotation(JModelica(unitTesting = JModelica.UnitTesting(testCase={
     JModelica.UnitTesting.CADCodeGenTestCase(
         name="CADdiv",
         description="",
         generate_dae_jacobian=true,
         template="$C_DAE_equation_directional_derivative$",
         generatedCode="
jmi_ad_var_t v_0;
jmi_ad_var_t d_0;
v_0 = _x1_1 / _x2_2;
d_0 = ((*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx] * _x2_2 - _x1_1 * (*dz)[jmi_get_index_from_value_ref(2)-jmi->offs_real_dx] ) / ( _x2_2 * _x2_2);
(*res)[0] = v_0 - _y_0;
(*dF)[0] = d_0 - (*dz)[jmi_get_index_from_value_ref(0)-jmi->offs_real_dx];
(*res)[1] = 1 - _x1_1;
(*dF)[1] = AD_WRAP_LITERAL(0) - (*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx];
(*res)[2] = 3 - _x2_2;
(*dF)[2] = AD_WRAP_LITERAL(0) - (*dz)[jmi_get_index_from_value_ref(2)-jmi->offs_real_dx];
")})));




	Real y;
	Real x1(start=1.5);
	Real x2(start=2.0);
equation
	y = x1 / x2;
	x1 = 1;
	x2 = 3;
end CADdiv;

model CADpow
 annotation(JModelica(unitTesting = JModelica.UnitTesting(testCase={
     JModelica.UnitTesting.CADCodeGenTestCase(
         name="CADpow",
         description="",
         generate_dae_jacobian=true,
         template="$C_DAE_equation_directional_derivative$",
         generatedCode="
jmi_ad_var_t v_0;
jmi_ad_var_t d_0;
v_0 = pow(_x1_1 , _x2_2);
if(_x1_1== 0){
d_0=0;
} else{
d_0 = v_0 * ((*dz)[jmi_get_index_from_value_ref(2)-jmi->offs_real_dx] * log(jmi_abs(_x1_1)) + _x2_2 * (*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx] / _x1_1);
}
(*res)[0] = v_0 - _y_0;
(*dF)[0] = d_0 - (*dz)[jmi_get_index_from_value_ref(0)-jmi->offs_real_dx];
(*res)[1] = 2 - _x1_1;
(*dF)[1] = AD_WRAP_LITERAL(0) - (*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx];
(*res)[2] = 3 - _x2_2;
(*dF)[2] = AD_WRAP_LITERAL(0) - (*dz)[jmi_get_index_from_value_ref(2)-jmi->offs_real_dx];
")})));




	Real y;
	Real x1(start=1.5);
	Real x2(start=2.0);
equation
	y = x1^x2;
	x1 = 2;
	x2 = 3;
end CADpow;

model CADabs
 annotation(JModelica(unitTesting = JModelica.UnitTesting(testCase={
     JModelica.UnitTesting.CADCodeGenTestCase(
         name="CADabs",
         description="",
         generate_dae_jacobian=true,
         template="$C_DAE_equation_directional_derivative$",
         generatedCode="
jmi_ad_var_t v_0;
jmi_ad_var_t d_0;

jmi_ad_var_t v_1;
jmi_ad_var_t d_1;
v_0 = jmi_abs(_x1_1);
if(_x1_1 < 0){
    d_0 = -(*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx];
}else {
    d_0 = (*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx];
}
(*res)[0] = v_0 - _y_0;
(*dF)[0] = d_0 - (*dz)[jmi_get_index_from_value_ref(0)-jmi->offs_real_dx];
v_1 = -1;
d_1 = -AD_WRAP_LITERAL(0);
(*res)[1] = v_1 - _x1_1;
(*dF)[1] = d_1 - (*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx];
")})));




	Real y;
	Real x1(start=1.5);
equation
	y = abs(x1);
	x1 = -1;
end CADabs;

model IfExpExample1
 annotation(JModelica(unitTesting = JModelica.UnitTesting(testCase={
     JModelica.UnitTesting.CADCodeGenTestCase(
         name="IfExpExample1",
         description="",
         generate_dae_jacobian=true,
         template="$C_DAE_equation_directional_derivative$",
         generatedCode="
jmi_ad_var_t v_0;
jmi_ad_var_t d_0;

jmi_ad_var_t v_1;
jmi_ad_var_t d_1;

jmi_ad_var_t v_2;
jmi_ad_var_t d_2;

jmi_ad_var_t v_3;
jmi_ad_var_t d_3;

jmi_ad_var_t v_4;
jmi_ad_var_t d_4;

jmi_ad_var_t v_5;
jmi_ad_var_t d_5;

jmi_ad_var_t v_6;
jmi_ad_var_t d_6;

jmi_ad_var_t v_7;
jmi_ad_var_t d_7;

jmi_ad_var_t v_8;
jmi_ad_var_t d_8;

jmi_ad_var_t v_9;
jmi_ad_var_t d_9;

jmi_ad_var_t v_10;
jmi_ad_var_t d_10;

jmi_ad_var_t v_11;
jmi_ad_var_t d_11;

jmi_ad_var_t v_12;
jmi_ad_var_t d_12;

jmi_ad_var_t v_13;
jmi_ad_var_t d_13;

jmi_ad_var_t v_14;
jmi_ad_var_t d_14;

jmi_ad_var_t v_15;
jmi_ad_var_t d_15;

jmi_ad_var_t v_16;
jmi_ad_var_t d_16;

jmi_ad_var_t v_17;
jmi_ad_var_t d_17;

jmi_ad_var_t v_18;
jmi_ad_var_t d_18;

jmi_ad_var_t v_19;
jmi_ad_var_t d_19;
v_8 = _time;
d_8 = (*dz)[jmi->offs_t];
v_7 = sin(v_8);
d_7 = d_8 * cos(v_8);
v_15 = _time;
d_15 = (*dz)[jmi->offs_t];
v_16 = AD_WRAP_LITERAL(3.141592653589793) / AD_WRAP_LITERAL(2);
d_16 = (AD_WRAP_LITERAL(0) * AD_WRAP_LITERAL(2) - AD_WRAP_LITERAL(3.141592653589793) * AD_WRAP_LITERAL(0) ) / ( AD_WRAP_LITERAL(2) * AD_WRAP_LITERAL(2));
v_14 = v_15 - v_16;
d_14 = d_15 - d_16;
v_13 = sin(v_14);
d_13 = d_14 * cos(v_14);
 v_9 = COND_EXP_EQ(COND_EXP_LE(_time, AD_WRAP_LITERAL(3.141592653589793), JMI_TRUE, JMI_FALSE), JMI_TRUE, AD_WRAP_LITERAL(1), v_13);
 d_9 = COND_EXP_EQ(COND_EXP_LE(_time, AD_WRAP_LITERAL(3.141592653589793), JMI_TRUE, JMI_FALSE), JMI_TRUE, AD_WRAP_LITERAL(0), d_13);
 v_3 = COND_EXP_EQ(COND_EXP_LE(_time, jmi_divide(AD_WRAP_LITERAL(3.141592653589793),AD_WRAP_LITERAL(2),\"Divide by zero: ( 3.141592653589793 ) / ( 2 )\"), JMI_TRUE, JMI_FALSE), JMI_TRUE, v_7, v_9);
 d_3 = COND_EXP_EQ(COND_EXP_LE(_time, jmi_divide(AD_WRAP_LITERAL(3.141592653589793),AD_WRAP_LITERAL(2),\"Divide by zero: ( 3.141592653589793 ) / ( 2 )\"), JMI_TRUE, JMI_FALSE), JMI_TRUE, d_7, d_9);
v_2 = v_3;
d_2 = d_3;
v_19 = AD_WRAP_LITERAL(3) * _x_0;
d_19 = (AD_WRAP_LITERAL(0) * _x_0 + AD_WRAP_LITERAL(3) * (*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx]);
v_18 = sin(v_19);
d_18 = d_19 * cos(v_19);
v_17 = v_18;
d_17 = d_18;
 v_0 = COND_EXP_EQ(_sw(0), JMI_TRUE, v_2, v_17);
 d_0 = COND_EXP_EQ(_sw(0), JMI_TRUE, d_2, d_17);
(*res)[0] = v_0 - _u_1;
(*dF)[0] = d_0 - (*dz)[jmi_get_index_from_value_ref(2)-jmi->offs_real_dx];
(*res)[1] = _u_1 - _der_x_2;
(*dF)[1] = (*dz)[jmi_get_index_from_value_ref(2)-jmi->offs_real_dx] - (*dz)[jmi_get_index_from_value_ref(0)-jmi->offs_real_dx];
")})));
   
    Real x,u;
equation
    u = if(x > 3) then noEvent(if time<=Modelica.Constants.pi/2 then sin(time) elseif 
              noEvent(time<=Modelica.Constants.pi) then 1 else sin(time-Modelica.Constants.pi/2)) else noEvent(sin(3*x));
    der(x) = u;
end IfExpExample1;

model IfExpExample2
 annotation(JModelica(unitTesting = JModelica.UnitTesting(testCase={
     JModelica.UnitTesting.CADCodeGenTestCase(
         name="IfExpExample2",
         description="",
         generate_dae_jacobian=true,
         template="$C_DAE_equation_directional_derivative$",
         generatedCode="
jmi_ad_var_t v_0;
jmi_ad_var_t d_0;

jmi_ad_var_t v_1;
jmi_ad_var_t d_1;

jmi_ad_var_t v_2;
jmi_ad_var_t d_2;

jmi_ad_var_t v_3;
jmi_ad_var_t d_3;

jmi_ad_var_t v_4;
jmi_ad_var_t d_4;

jmi_ad_var_t v_5;
jmi_ad_var_t d_5;

jmi_ad_var_t v_6;
jmi_ad_var_t d_6;

jmi_ad_var_t v_7;
jmi_ad_var_t d_7;

jmi_ad_var_t v_8;
jmi_ad_var_t d_8;

jmi_ad_var_t v_9;
jmi_ad_var_t d_9;

jmi_ad_var_t v_10;
jmi_ad_var_t d_10;

jmi_ad_var_t v_11;
jmi_ad_var_t d_11;

jmi_ad_var_t v_12;
jmi_ad_var_t d_12;
v_5 = _time;
d_5 = (*dz)[jmi->offs_t];
v_4 = sin(v_5);
d_4 = d_5 * cos(v_5);
v_11 = _time;
d_11 = (*dz)[jmi->offs_t];
v_12 = AD_WRAP_LITERAL(3.141592653589793) / AD_WRAP_LITERAL(2);
d_12 = (AD_WRAP_LITERAL(0) * AD_WRAP_LITERAL(2) - AD_WRAP_LITERAL(3.141592653589793) * AD_WRAP_LITERAL(0) ) / ( AD_WRAP_LITERAL(2) * AD_WRAP_LITERAL(2));
v_10 = v_11 - v_12;
d_10 = d_11 - d_12;
v_9 = sin(v_10);
d_9 = d_10 * cos(v_10);
 v_6 = COND_EXP_EQ(_sw(1), JMI_TRUE, AD_WRAP_LITERAL(1), v_9);
 d_6 = COND_EXP_EQ(_sw(1), JMI_TRUE, AD_WRAP_LITERAL(0), d_9);
 v_0 = COND_EXP_EQ(_sw(0), JMI_TRUE, v_4, v_6);
 d_0 = COND_EXP_EQ(_sw(0), JMI_TRUE, d_4, d_6);
(*res)[0] = v_0 - _u_1;
(*dF)[0] = d_0 - (*dz)[jmi_get_index_from_value_ref(2)-jmi->offs_real_dx];
(*res)[1] = _u_1 - _der_x_2;
(*dF)[1] = (*dz)[jmi_get_index_from_value_ref(2)-jmi->offs_real_dx] - (*dz)[jmi_get_index_from_value_ref(0)-jmi->offs_real_dx];
")})));

Real x,u;
equation
    u = if time<=Modelica.Constants.pi/2 then sin(time) elseif 
              time<=Modelica.Constants.pi then 1 else sin(time-Modelica.Constants.pi/2);
    der(x) = u;
end IfExpExample2;


  model CADFunction1		  
 annotation(JModelica(unitTesting = JModelica.UnitTesting(testCase={
     JModelica.UnitTesting.CADCodeGenTestCase(
         name="CADFunction1",
         description="",
         generate_dae_jacobian=true,
         template="$CAD_functions$,$C_DAE_equation_directional_derivative$",
         generatedCode="
void func_CADCodeGenTests_CADFunction1_F_der_AD(jmi_ad_var_t x_var_v, jmi_ad_var_t x_der_v, jmi_ad_var_t* y_var_o, jmi_ad_var_t* y_der_o) {
    JMI_DYNAMIC_INIT()
    jmi_ad_var_t y_var_v;
    jmi_ad_var_t y_der_v;
y_var_v = x_var_v;
y_der_v = x_der_v;

if (y_var_o != NULL) *y_var_o = y_var_v;
if (y_der_o != NULL) *y_der_o = y_der_v;
JMI_DYNAMIC_FREE()
return;
}

,
jmi_ad_var_t v_0;
jmi_ad_var_t d_0;
func_CADCodeGenTests_CADFunction1_F_der_AD(_a_0, (*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx],&v_0, &d_0);
(*res)[0] = v_0 - _der_a_1;
(*dF)[0] = d_0 - (*dz)[jmi_get_index_from_value_ref(0)-jmi->offs_real_dx];
")})));

				  
	function F
		input Real x;
		output Real y;
	algorithm
		y := x;
	end F;
	Real a(start=2);
	equation
		der(a) = F(a);
  end CADFunction1;

  model CADFunction2	  
 annotation(JModelica(unitTesting = JModelica.UnitTesting(testCase={
     JModelica.UnitTesting.CADCodeGenTestCase(
         name="CADFunction2",
         description="",
         generate_dae_jacobian=true,
         template="$CAD_functions$,$C_DAE_equation_directional_derivative$",
         generatedCode="
void func_CADCodeGenTests_CADFunction2_F_der_AD(jmi_ad_var_t x_var_v, jmi_ad_var_t x_der_v, jmi_ad_var_t* a_var_o, jmi_ad_var_t* b_var_o, jmi_ad_var_t* c_var_o, jmi_ad_var_t* a_der_o, jmi_ad_var_t* b_der_o, jmi_ad_var_t* c_der_o) {
    JMI_DYNAMIC_INIT()
    jmi_ad_var_t a_var_v;
    jmi_ad_var_t a_der_v;
    jmi_ad_var_t b_var_v;
    jmi_ad_var_t b_der_v;
    jmi_ad_var_t c_var_v;
    jmi_ad_var_t c_der_v;

jmi_ad_var_t v_0;
jmi_ad_var_t d_0;

jmi_ad_var_t v_1;
jmi_ad_var_t d_1;

jmi_ad_var_t v_2;
jmi_ad_var_t d_2;
v_0 = x_var_v * 2;
d_0 = (x_der_v * 2 + x_var_v * AD_WRAP_LITERAL(0));
a_var_v = v_0;
a_der_v = d_0;
v_1 = x_var_v * 4;
d_1 = (x_der_v * 4 + x_var_v * AD_WRAP_LITERAL(0));
b_var_v = v_1;
b_der_v = d_1;
v_2 = x_var_v * 8;
d_2 = (x_der_v * 8 + x_var_v * AD_WRAP_LITERAL(0));
c_var_v = v_2;
c_der_v = d_2;

if (a_var_o != NULL) *a_var_o = a_var_v;
if (a_der_o != NULL) *a_der_o = a_der_v;
if (b_var_o != NULL) *b_var_o = b_var_v;
if (b_der_o != NULL) *b_der_o = b_der_v;
if (c_var_o != NULL) *c_var_o = c_var_v;
if (c_der_o != NULL) *c_der_o = c_der_v;
JMI_DYNAMIC_FREE()
return;
}

,
jmi_ad_var_t v_3;
jmi_ad_var_t d_3;
func_CADCodeGenTests_CADFunction2_F_der_AD(_x_0, (*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx],&v_3, NULL, NULL,&d_3, NULL, NULL);
(*res)[0] = v_3 - _der_x_1;
(*dF)[0] = d_3 - (*dz)[jmi_get_index_from_value_ref(0)-jmi->offs_real_dx];
")})));

	function F
		input Real x;
		output Real a;
		output Real b;
		output Real c;
	algorithm
		a := x*2;
		b := x*4;
		c := x*8;
	end F;
	Real x(start=5);
	equation
		der(x) = F(x);
  end CADFunction2; 
  

  model CADFunction3	  
 annotation(JModelica(unitTesting = JModelica.UnitTesting(testCase={
     JModelica.UnitTesting.CADCodeGenTestCase(
         name="CADFunction3",
         description="",
         generate_dae_jacobian=true,
         template="$CAD_functions$,$C_DAE_equation_directional_derivative$",
         generatedCode="
void func_CADCodeGenTests_CADFunction3_F_der_AD(jmi_ad_var_t x_var_v, jmi_ad_var_t x_der_v, jmi_ad_var_t* y_var_o, jmi_ad_var_t* y_der_o) {
    JMI_DYNAMIC_INIT()
    jmi_ad_var_t y_var_v;
    jmi_ad_var_t y_der_v;

jmi_ad_var_t v_0;
jmi_ad_var_t d_0;

jmi_ad_var_t v_1;
jmi_ad_var_t d_1;
func_CADCodeGenTests_CADFunction3_F2_der_AD(x_var_v, x_der_v,&v_1, &d_1);
v_0 = pow(v_1 , 2);
if(v_1== 0){
d_0=0;
} else{
d_0 = v_0 * (AD_WRAP_LITERAL(0) * log(jmi_abs(v_1)) + 2 * d_1 / v_1);
}
y_var_v = v_0;
y_der_v = d_0;

if (y_var_o != NULL) *y_var_o = y_var_v;
if (y_der_o != NULL) *y_der_o = y_der_v;
JMI_DYNAMIC_FREE()
return;
}

void func_CADCodeGenTests_CADFunction3_F2_der_AD(jmi_ad_var_t x_var_v, jmi_ad_var_t x_der_v, jmi_ad_var_t* y_var_o, jmi_ad_var_t* y_der_o) {
    JMI_DYNAMIC_INIT()
    jmi_ad_var_t y_var_v;
    jmi_ad_var_t y_der_v;

jmi_ad_var_t v_2;
jmi_ad_var_t d_2;

jmi_ad_var_t v_3;
jmi_ad_var_t d_3;
func_CADCodeGenTests_CADFunction3_F3_der_AD(x_var_v, x_der_v,&v_3, &d_3);
v_2 = pow(v_3 , 2);
if(v_3== 0){
d_2=0;
} else{
d_2 = v_2 * (AD_WRAP_LITERAL(0) * log(jmi_abs(v_3)) + 2 * d_3 / v_3);
}
y_var_v = v_2;
y_der_v = d_2;

if (y_var_o != NULL) *y_var_o = y_var_v;
if (y_der_o != NULL) *y_der_o = y_der_v;
JMI_DYNAMIC_FREE()
return;
}

void func_CADCodeGenTests_CADFunction3_F3_der_AD(jmi_ad_var_t x_var_v, jmi_ad_var_t x_der_v, jmi_ad_var_t* y_var_o, jmi_ad_var_t* y_der_o) {
    JMI_DYNAMIC_INIT()
    jmi_ad_var_t y_var_v;
    jmi_ad_var_t y_der_v;

jmi_ad_var_t v_4;
jmi_ad_var_t d_4;
v_4 = pow(x_var_v , 2);
if(x_var_v== 0){
d_4=0;
} else{
d_4 = v_4 * (AD_WRAP_LITERAL(0) * log(jmi_abs(x_var_v)) + 2 * x_der_v / x_var_v);
}
y_var_v = v_4;
y_der_v = d_4;

if (y_var_o != NULL) *y_var_o = y_var_v;
if (y_der_o != NULL) *y_der_o = y_der_v;
JMI_DYNAMIC_FREE()
return;
}

,
jmi_ad_var_t v_5;
jmi_ad_var_t d_5;

jmi_ad_var_t v_6;
jmi_ad_var_t d_6;

jmi_ad_var_t v_7;
jmi_ad_var_t d_7;
func_CADCodeGenTests_CADFunction3_F_der_AD(_a_0, (*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx],&v_6, &d_6);
func_CADCodeGenTests_CADFunction3_F2_der_AD(_a_0, (*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx],&v_7, &d_7);
v_5 = v_6 + v_7;
d_5 = d_6 + d_7;
(*res)[0] = v_5 - _der_a_1;
(*dF)[0] = d_5 - (*dz)[jmi_get_index_from_value_ref(0)-jmi->offs_real_dx];
")})));

	function F
		input Real x;
		output Real y;
	algorithm
		y := F2(x)^2;
	end F;
	function F2
		input Real x;
		output Real y;
	algorithm
		y := F3(x)^2;
	end F2;
	function F3
		input Real x;
		output Real y;
	algorithm
		y := x^2;
	end F3;
	Real a(start=5);
	equation
		der(a) = F(a)+F2(a);
  end CADFunction3; 
  
  
    model CADFunction4	
 annotation(JModelica(unitTesting = JModelica.UnitTesting(testCase={
     JModelica.UnitTesting.CADCodeGenTestCase(
         name="CADFunction4",
         description="",
         generate_dae_jacobian=true,
         template="$CAD_functions$,$C_DAE_equation_directional_derivative$",
         generatedCode="
void func_CADCodeGenTests_CADFunction4_F2_der_AD(jmi_ad_var_t x_var_v, jmi_ad_var_t x_der_v, jmi_ad_var_t* a_var_o, jmi_ad_var_t* a_der_o) {
    JMI_DYNAMIC_INIT()
    jmi_ad_var_t a_var_v;
    jmi_ad_var_t a_der_v;

jmi_ad_var_t v_0;
jmi_ad_var_t d_0;

jmi_ad_var_t v_1;
jmi_ad_var_t d_1;
func_CADCodeGenTests_CADFunction4_F_der_AD(x_var_v, x_der_v,&v_1, NULL, NULL,&d_1, NULL, NULL);
v_0 = v_1 * x_var_v;
d_0 = (d_1 * x_var_v + v_1 * x_der_v);
a_var_v = v_0;
a_der_v = d_0;

if (a_var_o != NULL) *a_var_o = a_var_v;
if (a_der_o != NULL) *a_der_o = a_der_v;
JMI_DYNAMIC_FREE()
return;
}

void func_CADCodeGenTests_CADFunction4_F_der_AD(jmi_ad_var_t x_var_v, jmi_ad_var_t x_der_v, jmi_ad_var_t* a_var_o, jmi_ad_var_t* b_var_o, jmi_ad_var_t* c_var_o, jmi_ad_var_t* a_der_o, jmi_ad_var_t* b_der_o, jmi_ad_var_t* c_der_o) {
    JMI_DYNAMIC_INIT()
    jmi_ad_var_t a_var_v;
    jmi_ad_var_t a_der_v;
    jmi_ad_var_t b_var_v;
    jmi_ad_var_t b_der_v;
    jmi_ad_var_t c_var_v;
    jmi_ad_var_t c_der_v;

jmi_ad_var_t v_2;
jmi_ad_var_t d_2;

jmi_ad_var_t v_3;
jmi_ad_var_t d_3;

jmi_ad_var_t v_4;
jmi_ad_var_t d_4;
v_2 = x_var_v * 2;
d_2 = (x_der_v * 2 + x_var_v * AD_WRAP_LITERAL(0));
a_var_v = v_2;
a_der_v = d_2;
v_3 = x_var_v * 4;
d_3 = (x_der_v * 4 + x_var_v * AD_WRAP_LITERAL(0));
b_var_v = v_3;
b_der_v = d_3;
v_4 = x_var_v * 8;
d_4 = (x_der_v * 8 + x_var_v * AD_WRAP_LITERAL(0));
c_var_v = v_4;
c_der_v = d_4;

if (a_var_o != NULL) *a_var_o = a_var_v;
if (a_der_o != NULL) *a_der_o = a_der_v;
if (b_var_o != NULL) *b_var_o = b_var_v;
if (b_der_o != NULL) *b_der_o = b_der_v;
if (c_var_o != NULL) *c_var_o = c_var_v;
if (c_der_o != NULL) *c_der_o = c_der_v;
JMI_DYNAMIC_FREE()
return;
}

,
jmi_ad_var_t v_5;
jmi_ad_var_t d_5;
func_CADCodeGenTests_CADFunction4_F2_der_AD(_x_0, (*dz)[jmi_get_index_from_value_ref(1)-jmi->offs_real_dx],&v_5, &d_5);
(*res)[0] = v_5 - _der_x_1;
(*dF)[0] = d_5 - (*dz)[jmi_get_index_from_value_ref(0)-jmi->offs_real_dx];
")})));

	function F
		input Real x; 
		output Real a;
		output Real b;
		output Real c;
	algorithm
		a := x*2;
		b := x*4;
		c := x*8;
	end F;
	function F2
		input Real x;
		output Real a;
	algorithm
		a := F(x)*x;
	end F2;
	Real x(start=5);
	equation
		der(x) = F2(x);
  end CADFunction4; 


model SparseJacTest1
 annotation(JModelica(unitTesting = JModelica.UnitTesting(testCase={
     JModelica.UnitTesting.CADCodeGenTestCase(
         name="SparseJacTest1",
         description="Test that sparsity information is generated correctly",
	 generate_dae_jacobian=true,
         template="
$C_DAE_equation_sparsity$
",
         generatedCode="
static const int CAD_dae_real_p_opt_n_nz = 0;
static const int CAD_dae_real_dx_n_nz = 5;
static const int CAD_dae_real_x_n_nz = 5;
static const int CAD_dae_real_u_n_nz = 5;
static const int CAD_dae_real_w_n_nz = 7;
static int CAD_dae_n_nz = 22;
static const int CAD_dae_nz_rows[22] = {0,1,2,3,4,0,1,2,3,4,2,3,4,8,8,2,5,3,6,4,7,8};
static const int CAD_dae_nz_cols[22] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,15,16,16,17,17,18};
")})));

 parameter Real p1=2;
 parameter Integer p2 = 1;
 parameter Boolean p3 = false;
 Real x[3]; 
 Real x2[2];
 Real y[3];
 Real y2;
 input Real u[3];
 input Real u2[2];
equation
 der(x2) = -x2;
 der(x) = x + y + u;
 y = {1,2,3};
 y2 = sum(u2);
end SparseJacTest1;

model SparseJacTest2
 annotation(JModelica(unitTesting = JModelica.UnitTesting(testCase={
     JModelica.UnitTesting.CADCodeGenTestCase(
         name="SparseJacTest2",
         description="Test that sparsity information is generated correctly",
	 generate_dae_jacobian=true,
         template="
$C_DAE_equation_sparsity$
",
         generatedCode="
static const int CAD_dae_real_p_opt_n_nz = 0;
static const int CAD_dae_real_dx_n_nz = 0;
static const int CAD_dae_real_x_n_nz = 0;
static const int CAD_dae_real_u_n_nz = 0;
static const int CAD_dae_real_w_n_nz = 4;
static int CAD_dae_n_nz = 4;
static const int CAD_dae_nz_rows[4] = {1,2,3,0};
static const int CAD_dae_nz_cols[4] = {0,1,2,3};
")})));
    function F1
      input Real x1[3];
      input Real x2;
      input Real x3;
      output Real y1;
      output Real y2[3];
    algorithm
      y1 := x1[1]+x2;
      y2 := {x1[1],x2,x3} + x1;
    end F1;
    Real y[3](start={1,2,3});
    Real a(start = 3);
    parameter Real x[3](start={3,2,2});
    parameter Real z(start=1);
    parameter Real w(start =3);
equation
    (a,y) = F1(x,z,w);

end SparseJacTest2;

model SparseJacTest3
 annotation(JModelica(unitTesting = JModelica.UnitTesting(testCase={
     JModelica.UnitTesting.CADCodeGenTestCase(
         name="SparseJacTest3",
         description="Test that sparsity information is generated correctly",
	 generate_dae_jacobian=true,
         template="
$C_DAE_equation_sparsity$
",
         generatedCode="
static const int CAD_dae_real_p_opt_n_nz = 0;
static const int CAD_dae_real_dx_n_nz = 0;
static const int CAD_dae_real_x_n_nz = 0;
static const int CAD_dae_real_u_n_nz = 0;
static const int CAD_dae_real_w_n_nz = 12;
static int CAD_dae_n_nz = 12;
static const int CAD_dae_nz_rows[12] = {1,2,3,0,1,2,3,0,1,2,3,4};
static const int CAD_dae_nz_cols[12] = {0,1,2,3,3,3,3,4,4,4,4,4};
")})));
    function F1
      input Real x1[3];
      input Real x2;
      input Real x3;
      output Real y1;
      output Real y2[3];
    algorithm
      y1 := x1[1]+x2;
      y2 := {x1[1],x2,x3} + x1;
    end F1;
    Real y[3](start={1,2,3});
    Real a(start = 3);
    Real q = 3;
    parameter Real x[3](start={3,2,2});
    parameter Real z(start=1);
    parameter Real w(start =3);
equation
    (a,y) = F1(x,q,a);

end SparseJacTest3;

model SparseJacTest4
 annotation(JModelica(unitTesting = JModelica.UnitTesting(testCase={
     JModelica.UnitTesting.CADCodeGenTestCase(
         name="SparseJacTest4",
         description="Test that sparsity information is generated correctly",
	 generate_dae_jacobian=true,
         template="
$C_DAE_equation_sparsity$
",
         generatedCode="
static const int CAD_dae_real_p_opt_n_nz = 0;
static const int CAD_dae_real_dx_n_nz = 0;
static const int CAD_dae_real_x_n_nz = 0;
static const int CAD_dae_real_u_n_nz = 12;
static const int CAD_dae_real_w_n_nz = 12;
static int CAD_dae_n_nz = 24;
static const int CAD_dae_nz_rows[24] = {0,1,2,3,0,1,2,3,0,1,2,3,1,2,3,0,1,2,3,0,1,2,3,4};
static const int CAD_dae_nz_cols[24] = {0,0,0,0,1,1,1,1,2,2,2,2,3,4,5,6,6,6,6,7,7,7,7,7};
")})));
    function F1
      input Real x1[3];
      input Real x2;
      input Real x3;
      output Real y1;
      output Real y2[3];
    algorithm
      y1 := x1[1]+x2;
      y2 := {x1[1],x2,x3} + x1;
    end F1;
    Real y[3](start={1,2,3});
    Real a(start = 3);
    Real q = 3;
    input Real x[3](start={3,2,2});
equation
    (a,y) = F1(x,q,a);

end SparseJacTest4;

model SparseJacTest5
 annotation(JModelica(unitTesting = JModelica.UnitTesting(testCase={
     JModelica.UnitTesting.CADCodeGenTestCase(
         name="SparseJacTest5",
         description="Test that sparsity information is generated correctly",
	 generate_dae_jacobian=true,
         template="
$C_DAE_equation_sparsity$
",
         generatedCode="
static const int CAD_dae_real_p_opt_n_nz = 0;
static const int CAD_dae_real_dx_n_nz = 15;
static const int CAD_dae_real_x_n_nz = 15;
static const int CAD_dae_real_u_n_nz = 0;
static const int CAD_dae_real_w_n_nz = 12;
static int CAD_dae_n_nz = 42;
static const int CAD_dae_nz_rows[42] = {0,1,2,3,4,0,1,2,3,5,0,1,2,3,6,0,1,2,3,4,0,1,2,3,5,0,1,2,3,6,1,2,3,0,1,2,3,0,1,2,3,7};
static const int CAD_dae_nz_cols[42] = {0,0,0,0,0,1,1,1,1,1,2,2,2,2,2,3,3,3,3,3,4,4,4,4,4,5,5,5,5,5,6,7,8,9,9,9,9,10,10,10,10,10};

")})));
    function F1
      input Real x1[3];
      input Real x2;
      input Real x3;
      output Real y1;
      output Real y2[3];
    algorithm
      y1 := x1[1]+x2;
      y2 := {x1[1],x2,x3} + x1;
    end F1;
    Real y[3](start={1,2,3});
    Real a(start = 3);
    Real q = 3;
    Real x[3](start={3,2,2});
equation
    (a,y) = F1(der(x)+x,q,a);
    der(x) = -x;
end SparseJacTest5;


end CADCodeGenTests;
