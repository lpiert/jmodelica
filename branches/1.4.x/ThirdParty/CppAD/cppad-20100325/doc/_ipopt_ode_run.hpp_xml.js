var list_across0 = [
'_contents_xml.htm',
'_reference.xml',
'_index.xml',
'_search_xml.htm',
'_external.xml'
];
var list_up0 = [
'cppad.xml',
'example.xml',
'general.xml',
'cppad_ipopt_nlp.xml',
'cppad_ipopt_ode.xml',
'ipopt_ode_run.hpp.xml'
];
var list_down3 = [
'ad_fun.cpp.xml',
'ad_in_c.cpp.xml',
'hesminordet.cpp.xml',
'hesludet.cpp.xml',
'cppad_ipopt_nlp.xml',
'interface2c.cpp.xml',
'jacminordet.cpp.xml',
'jacludet.cpp.xml',
'mul_level.xml',
'odestiff.cpp.xml',
'ode_taylor.cpp.xml',
'ode_taylor_adolc.cpp.xml',
'stackmachine.cpp.xml'
];
var list_down2 = [
'cppad_ipopt_windows.xml',
'ipopt_get_started.cpp.xml',
'cppad_ipopt_ode.xml',
'ipopt_ode_speed.cpp.xml'
];
var list_down1 = [
'ipopt_ode_problem.xml',
'ipopt_ode_simple.xml',
'ipopt_ode_fast.xml',
'ipopt_ode_run.hpp.xml',
'ipopt_ode_check.cpp.xml'
];
function choose_across0(item)
{	var index          = item.selectedIndex;
	item.selectedIndex = 0;
	if(index > 0)
		document.location = list_across0[index-1];
}
function choose_up0(item)
{	var index          = item.selectedIndex;
	item.selectedIndex = 0;
	if(index > 0)
		document.location = list_up0[index-1];
}
function choose_down3(item)
{	var index          = item.selectedIndex;
	item.selectedIndex = 0;
	if(index > 0)
		document.location = list_down3[index-1];
}
function choose_down2(item)
{	var index          = item.selectedIndex;
	item.selectedIndex = 0;
	if(index > 0)
		document.location = list_down2[index-1];
}
function choose_down1(item)
{	var index          = item.selectedIndex;
	item.selectedIndex = 0;
	if(index > 0)
		document.location = list_down1[index-1];
}
function choose_down0(item)
{	var index          = item.selectedIndex;
	item.selectedIndex = 0;
	if(index > 0)
		document.location = list_down0[index-1];
}
function choose_current0(item)
{	var index          = item.selectedIndex;
	item.selectedIndex = 0;
	if(index > 0)
		document.location = list_current0[index-1];
}
