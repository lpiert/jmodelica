#Copyright (C) 2013 Modelon AB

#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, version 3 of the License.

#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.

#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <http://www.gnu.org/licenses/>.

import os
from tests_jmodelica import testattr, get_files_path
try:
    import casadi
    from casadi import is_equal
    from modelicacasadi_transfer import *
    # Common variables used in the tests
    x1 = MX.sym("x1")
    x2 = MX.sym("x2")
    x3 = MX.sym("x3")
    der_x1 = MX.sym("der(x1)")
except (NameError, ImportError):
    pass

modelFile = os.path.join(get_files_path(), 'Modelica', 'TestModelicaModels.mo')
optproblemsFile = os.path.join(get_files_path(), 'Modelica', 'TestOptimizationProblems.mop')
import platform

## In this file there are tests for transferModelica, transferOptimica and tests for
## the correct transfer of the MX representation of expressions and various Modelica constructs
## from JModelica.org.

def load_optimization_problem(*args, **kwargs):
    ocp = OptimizationProblem()
    transfer_optimization_problem(ocp, *args, **kwargs)
    return ocp

def strnorm(StringnotNorm):
    caracters = ['\n','\t',' ']
    StringnotNorm = str(StringnotNorm)
    for c in caracters:
        StringnotNorm = StringnotNorm.replace(c, '')
    return StringnotNorm
    
def check_strnorm(got, expected):
    got, expected = str(got), str(expected)
    if strnorm(got) != strnorm(expected):
        raise AssertionError("Expected:\n" + expected + "\ngot:\n" + got + "\n");

def assertNear(val1, val2, tol):
    assert abs(val1 - val2) < tol
    
##############################################
#                                            # 
#          MODELICA TRANSFER TESTS           #
#                                            #
##############################################

class ModelicaTransfer(object):
    """Base class for Modelica transfer tests. Subclasses define load_model"""
    
    def __init__(self):
    
        test_dir = os.path.dirname(os.path.abspath(__file__))
        
        self.res_dir = os.path.join(test_dir, "files", "Results",
                                    "casadiinterface_transfer_results")
                                
            
        if not os.path.exists(self.res_dir):
            os.makedirs(self.res_dir)
                               
    def _make_path(self, file_name):
        return os.path.join(self.res_dir, file_name)
        
    def check_result(self, got, path, update=False):
        """
        Help function for comparing test result to the string
        in the reference file.
        
            Parameters:
            
                got --
                    The test result
                
                path --
                    Path to the reference file
                    
                update --
                    Boolean setting whether the reference file
                    should be updated according to the test result.
                    Default: False
        """


        try:
            expected  = self.expected_string(path)
        except IOError:
            if update:
                expected = self.update_ref(str(got), path)
            else:
                raise AssertionError("Reference file " + path 
                                     + " not found!")
                
        got, expected = str(got), str(expected)
        if strnorm(got) != strnorm(expected):
            if update:
                self.update_ref(str(got), path)
            else:
                raise AssertionError("Expected:\n" + expected 
                                     + "\ngot:\n" + got + "\n")
            
    def update_ref(self, actual, path):
        """ 
        Updates the strings in reference file case
        """
        
        with open(path, 'w') as f:
            f.write(actual)
        
        return actual
            
    def expected_string(self, path):
        """
        Read the expected string from file
        """    
        
        with open(path, 'r') as f:
            expected = f.read()
        
        return expected

    @testattr(casadi = True)
    def test_ModelicaAliasVariables(self):
        model = self.load_model("atomicModelAlias", modelFile)
        assert not model.getVariable("x").isNegated()
        assert model.getVariable("z").isNegated()
        check_strnorm(model.getVariable("x"), "Real x(alias: y);")
        check_strnorm(model.getModelVariable("x"), "Real y;")
        check_strnorm(model.getVariable("y"), "Real y;")
        check_strnorm(model.getModelVariable("y"), "Real y;")
        check_strnorm(model.getVariable("z"), "Real z(alias: y);")
        check_strnorm(model.getModelVariable("z"), "Real y;")
    

    @testattr(casadi = True)
    def test_ModelicaSimpleEquation(self):
        check_strnorm(self.load_model("AtomicModelSimpleEquation", modelFile).getDaeResidual(), der_x1 - x1) 

    @testattr(casadi = True)
    def test_ModelicaSimpleInitialEquation(self):
        check_strnorm(self.load_model("AtomicModelSimpleInitialEquation", modelFile).getInitialResidual(), x1 - MX(1))

    @testattr(casadi = True)
    def test_ModelicaFunctionCallEquations(self):
        expected = self._make_path("ModelicaFunctionCallEquations.txt")
        self.check_result(repr(self.load_model("AtomicModelFunctionCallEquation", modelFile, compiler_options={"inline_functions":"none"}).getDaeResidual()),
            expected)

    @testattr(casadi = True)
    def test_ModelicaBindingExpression(self):
        model =  self.load_model("AtomicModelAttributeBindingExpression", modelFile)
        dependent =  model.getVariables(Model.REAL_PARAMETER_DEPENDENT)
        independent =  model.getVariables(Model.REAL_PARAMETER_INDEPENDENT)
        actual =  str(independent[0].getAttribute("bindingExpression")) + str(dependent[0].getAttribute("bindingExpression"))
        expected = str(MX(2)) + str(MX.sym("p1"))
        check_strnorm(actual, expected)

    @testattr(casadi = True)
    def test_ModelicaUnit(self):
        model =  self.load_model("AtomicModelAttributeUnit", modelFile)
        diffs =  model.getVariables(Model.DIFFERENTIATED)
        check_strnorm(diffs[0].getAttribute("unit"), MX.sym("kg"))

    @testattr(casadi = True)
    def test_ModelicaQuantity(self):
        model =  self.load_model("AtomicModelAttributeQuantity", modelFile)
        diffs =  model.getVariables(Model.DIFFERENTIATED)
        check_strnorm(diffs[0].getAttribute("quantity"), MX.sym("kg")) 

    @testattr(casadi = True)
    def test_ModelicaDisplayUnit(self):
        model =  self.load_model("AtomicModelAttributeDisplayUnit", modelFile)
        diffs =  model.getVariables(Model.DIFFERENTIATED)
        check_strnorm(diffs[0].getAttribute("displayUnit"), MX.sym("kg")) 

    @testattr(casadi = True)
    def test_ModelicaMin(self):
        model =  self.load_model("AtomicModelAttributeMin", modelFile)
        diffs =  model.getVariables(Model.DIFFERENTIATED)
        check_strnorm((diffs[0].getAttribute("min")), MX(0)) 

    @testattr(casadi = True)
    def test_ModelicaMax(self):
        model =  self.load_model("AtomicModelAttributeMax", modelFile)
        diffs =  model.getVariables(Model.DIFFERENTIATED)
        check_strnorm(diffs[0].getAttribute("max"), MX(100))

    @testattr(casadi = True)
    def test_ModelicaStart(self):
        model =  self.load_model("AtomicModelAttributeStart", modelFile)
        diffs =  model.getVariables(Model.DIFFERENTIATED)
        check_strnorm(diffs[0].getAttribute("start"), MX(0.0005))

    @testattr(casadi = True)
    def test_ModelicaFixed(self):
        model =  self.load_model("AtomicModelAttributeFixed", modelFile)
        diffs =  model.getVariables(Model.DIFFERENTIATED)
        check_strnorm(diffs[0].getAttribute("fixed"), MX(True))

    @testattr(casadi = True)
    def test_ModelicaNominal(self):
        model =  self.load_model("AtomicModelAttributeNominal", modelFile)
        diffs =  model.getVariables(Model.DIFFERENTIATED)
        check_strnorm(diffs[0].getAttribute("nominal"), MX(0.1))

    @testattr(casadi = True)
    def test_ModelicaComment(self):
        model =  self.load_model("AtomicModelComment", modelFile)
        diffs =  model.getVariables(Model.DIFFERENTIATED)
        check_strnorm(diffs[0].getAttribute("comment"), MX.sym("I am x1's comment"))

    @testattr(casadi = True)
    def test_ModelicaRealDeclaredType(self):
        model =  self.load_model("AtomicModelDerivedRealTypeVoltage", modelFile)
        check_strnorm(model.getVariableType("Voltage"), "Voltage type = Real (quantity = ElectricalPotential, unit = V);")

    @testattr(casadi = True)
    def test_ModelicaDerivedTypeDefaultType(self):
        model =  self.load_model("AtomicModelDerivedTypeAndDefaultType", modelFile)
        diffs =  model.getVariables(Model.DIFFERENTIATED)
        assert int(diffs[0].getDeclaredType().this) == int(model.getVariableType("Voltage").this)
        assert int(diffs[1].getDeclaredType().this) == int(model.getVariableType("Real").this)

    @testattr(casadi = True)
    def test_ModelicaIntegerDeclaredType(self):
        model =  self.load_model("AtomicModelDerivedIntegerTypeSteps", modelFile)
        check_strnorm(model.getVariableType("Steps"), "Steps type = Integer (quantity = steps);")

    @testattr(casadi = True)
    def test_ModelicaBooleanDeclaredType(self):
        model =  self.load_model("AtomicModelDerivedBooleanTypeIsDone", modelFile)
        check_strnorm(model.getVariableType("IsDone"), "IsDone type = Boolean (quantity = Done);")

    @testattr(casadi = True)
    def test_ModelicaRealConstant(self):
        model =  self.load_model("atomicModelRealConstant", modelFile)
        constVars =  model.getVariables(Model.REAL_CONSTANT)
        check_strnorm(constVars[0].getVar(), MX.sym("pi"))
        assertNear(float(constVars[0].getAttribute("bindingExpression")), 3.14, 0.0000001)

    @testattr(casadi = True)
    def test_ModelicaRealIndependentParameter(self):
        model =  self.load_model("atomicModelRealIndependentParameter", modelFile)
        indepParam =  model.getVariables(Model.REAL_PARAMETER_INDEPENDENT)
        check_strnorm(indepParam[0].getVar(), MX.sym("pi"))
        assertNear(float(indepParam[0].getAttribute("bindingExpression")), 3.14, 0.0000001)

    @testattr(casadi = True)
    def test_ModelicaRealDependentParameter(self):
        model =  self.load_model("atomicModelRealDependentParameter", modelFile)
        depParam =  model.getVariables(Model.REAL_PARAMETER_DEPENDENT)
        indepParam =  model.getVariables(Model.REAL_PARAMETER_INDEPENDENT)
        check_strnorm(2*(indepParam[0].getVar()), depParam[0].getAttribute("bindingExpression"))

    @testattr(casadi = True)
    def test_ModelicaDerivative(self):
        model =  self.load_model("atomicModelRealDerivative", modelFile)
        check_strnorm(model.getVariables(Model.DERIVATIVE)[0].getVar(), der_x1)

    @testattr(casadi = True)
    def test_ModelicaDifferentiated(self):
        model = self.load_model("atomicModelRealDifferentiated", modelFile)
        diff = model.getVariables(Model.DIFFERENTIATED)
        check_strnorm(diff[0].getVar(), x1)

    @testattr(casadi = True)
    def test_ModelicaRealInput(self):
        model =  self.load_model("atomicModelRealInput", modelFile)
        ins =  model.getVariables(Model.REAL_INPUT)
        check_strnorm(ins[0].getVar(), x1)

    @testattr(casadi = True)
    def test_ModelicaAlgebraic(self):
        model =  self.load_model("atomicModelRealAlgebraic", modelFile)
        alg =  model.getVariables(Model.REAL_ALGEBRAIC)
        check_strnorm(alg[0].getVar(), x1)

    @testattr(casadi = True)
    def test_ModelicaRealDisrete(self):
        model =  self.load_model("atomicModelRealDiscrete", modelFile)
        realDisc =  model.getVariables(Model.REAL_DISCRETE)
        check_strnorm(realDisc[0].getVar(), x1)

    @testattr(casadi = True)
    def test_ModelicaIntegerConstant(self):
        model =  self.load_model("atomicModelIntegerConstant", modelFile)
        constVars =  model.getVariables(Model.INTEGER_CONSTANT)
        check_strnorm(constVars[0].getVar(), MX.sym("pi"))
        assertNear( float(constVars[0].getAttribute("bindingExpression")), 3, 0.0000001)

    @testattr(casadi = True)
    def test_ModelicaIntegerIndependentParameter(self):
        model =  self.load_model("atomicModelIntegerIndependentParameter", modelFile)
        indepParam =  model.getVariables(Model.INTEGER_PARAMETER_INDEPENDENT)
        check_strnorm(indepParam[0].getVar(), MX.sym("pi"))
        assertNear( float(indepParam[0].getAttribute("bindingExpression")), 3, 0.0000001 )

    @testattr(casadi = True)
    def test_ModelicaIntegerDependentConstants(self):
        model =  self.load_model("atomicModelIntegerDependentParameter", modelFile)    
        depParam =  model.getVariables(Model.INTEGER_PARAMETER_DEPENDENT)
        indepParam =  model.getVariables(Model.INTEGER_PARAMETER_INDEPENDENT)
        check_strnorm(2*(indepParam[0].getVar()), depParam[0].getAttribute("bindingExpression"))

    @testattr(casadi = True)
    def test_ModelicaIntegerDiscrete(self):
        model =  self.load_model("atomicModelIntegerDiscrete", modelFile)
        intDisc =  model.getVariables(Model.INTEGER_DISCRETE)
        check_strnorm(intDisc[0].getVar(), x1)

    @testattr(casadi = True)
    def test_ModelicaIntegerInput(self):
        model =  self.load_model("atomicModelIntegerInput", modelFile)    
        intIns =  model.getVariables(Model.INTEGER_INPUT)
        check_strnorm(intIns[0].getVar(), x1)

    @testattr(casadi = True)
    def test_ModelicaBooleanConstant(self):
        model =  self.load_model("atomicModelBooleanConstant", modelFile)
        constVars =  model.getVariables(Model.BOOLEAN_CONSTANT)
        check_strnorm(constVars[0].getVar(), MX.sym("pi"))
        assertNear( float(constVars[0].getAttribute("bindingExpression")), float(MX(True)), 0.0000001 )

    @testattr(casadi = True)
    def test_ModelicaBooleanIndependentParameter(self):
        model =  self.load_model("atomicModelBooleanIndependentParameter", modelFile)
        indepParam =  model.getVariables(Model.BOOLEAN_PARAMETER_INDEPENDENT)
        check_strnorm(indepParam[0].getVar(), MX.sym("pi"))
        assertNear( float(indepParam[0].getAttribute("bindingExpression")), float(MX(True)), 0.0000001 )

    @testattr(casadi = True)
    def test_ModelicaBooleanDependentParameter(self):
        model =  self.load_model("atomicModelBooleanDependentParameter", modelFile)    
        depParam =  model.getVariables(Model.BOOLEAN_PARAMETER_DEPENDENT)  
        indepParam =  model.getVariables(Model.BOOLEAN_PARAMETER_INDEPENDENT)
        check_strnorm( casadi.logic_and(indepParam[0].getVar(), (MX(True))), depParam[0].getAttribute("bindingExpression"))

    @testattr(casadi = True)
    def test_ModelicaBooleanDiscrete(self):
        model =  self.load_model("atomicModelBooleanDiscrete", modelFile)        
        boolDisc =  model.getVariables(Model.BOOLEAN_DISCRETE)
        check_strnorm(boolDisc[0].getVar(), x1)

    @testattr(casadi = True)
    def test_ModelicaBooleanInput(self):
        model =  self.load_model("atomicModelBooleanInput", modelFile)
        boolIns =  model.getVariables(Model.BOOLEAN_INPUT)
        check_strnorm(boolIns[0].getVar(), x1)

    @testattr(casadi = True)
    def test_ModelicaModelFunction(self):
        model =  self.load_model("simpleModelWithFunctions", modelFile)
        mf_1 = model.getModelFunction("simpleModelWithFunctions_f")
        mf_2 = model.getModelFunction("simpleModelWithFunctions_f2")
        actual = str(mf_1) + str(mf_2)
        expected = self._make_path("ModelicaModelFunction.txt")
        self.check_result(actual, expected)

    @testattr(casadi = True)
    def test_ModelicaDependentParametersCalculated(self):
        model =  self.load_model("atomicModelDependentParameter", modelFile)
        model.calculateValuesForDependentParameters()
        depVars = model.getVariables(Model.REAL_PARAMETER_DEPENDENT)
        assert float(depVars[0].getAttribute("evaluatedBindingExpression")) == 20
        assert float(depVars[1].getAttribute("evaluatedBindingExpression")) == 20
        assert float(depVars[2].getAttribute("evaluatedBindingExpression")) == 200

    @testattr(casadi = True)
    def test_ModelicaFunctionCallEquationForParameterBinding(self):
        model =  self.load_model("atomicModelPolyOutFunctionCallForDependentParameter", modelFile, compiler_options={"inline_functions":"none"})
        model.calculateValuesForDependentParameters()
        expected = self._make_path("ModelicaFunctionCallEquationForParameterBinding.txt")       
        actual = ""
        for var in model.getVariables(Model.REAL_PARAMETER_DEPENDENT):
            actual += str(var) + "\n"
        self.check_result(actual, expected)


    @testattr(casadi = True)
    def test_ModelicaTimeVariable(self):
        model = self.load_model("atomicModelTime", modelFile)
        t = model.getTimeVariable()
        eq = model.getDaeResidual()
        assert is_equal(eq[1].dep(1).dep(1), t) and is_equal(eq[0].dep(1), t)

    ##############################################
    #                                            # 
    #         CONSTRUCTS TRANSFER TESTS          #
    #                                            #
    ##############################################
    
    @testattr(casadi = True)
    def test_ConstructElementaryDivision(self):
        model = self.load_model("AtomicModelElementaryDivision", modelFile)
        params = model.getVariables(model.REAL_PARAMETER_DEPENDENT)
        expected = self._make_path("ConstructElementaryDivision.txt")
        self.check_result(repr(params), expected)
        
    @testattr(casadi = True)
    def test_ConstructElementaryMultiplication(self):
        model = self.load_model("AtomicModelElementaryMultiplication", modelFile)
        params = model.getVariables(model.REAL_PARAMETER_DEPENDENT)
        expected = self._make_path("ConstructElementaryMultiplication.txt")
        self.check_result(repr(params), expected)
        
    @testattr(casadi = True)
    def test_ConstructElementaryAddition(self):
        model = self.load_model("AtomicModelElementaryAddition", modelFile)
        params = model.getVariables(model.REAL_PARAMETER_DEPENDENT)
        expected = self._make_path("ConstructElementaryAddition.txt")
        self.check_result(repr(params), expected)
        
    @testattr(casadi = True)
    def test_ConstructElementarySubtraction(self):
        model = self.load_model("AtomicModelElementarySubtraction", modelFile)
        params = model.getVariables(model.REAL_PARAMETER_DEPENDENT)
        expected = self._make_path("ConstructElementarySubtraction.txt")
        self.check_result(repr(params), expected)
        
    @testattr(casadi = True)
    def test_ConstructElementaryExponentiation(self):
        model = self.load_model("AtomicModelElementaryExponentiation", modelFile)
        params = model.getVariables(model.REAL_PARAMETER_DEPENDENT)
        expected = self._make_path("ConstructElementaryExponentiation.txt")
        self.check_result(repr(params), expected) 
    
    @testattr(casadi = True)
    def test_ConstructElementaryExpression(self):
        dae = self.load_model("AtomicModelElementaryExpressions", modelFile).getDaeResidual()
        expected ="MX(vertcat((der(x1)-(2+x1)), (der(x2)-(x2-x1)), (der(x3)-(x3*x2)), (der(x4)-(x4/x3))))"
        check_strnorm(repr(dae), expected) 

    @testattr(casadi = True)
    def test_ConstructElementaryFunctions(self):
        dae = self.load_model("AtomicModelElementaryFunctions", modelFile).getDaeResidual()
        expected = ("MX(vertcat((der(x1)-pow(x1,5)), (der(x2)-fabs(x2)), (der(x3)-fmin(x3,x2)), (der(x4)-fmax(x4,x3)), (der(x5)-sqrt(x5)), (der(x6)-sin(x6)), (der(x7)-cos(x7)), (der(x8)-tan(x8)), (der(x9)-asin(x9)), (der(x10)-acos(x10)), (der(x11)-atan(x11)), (der(x12)-atan2(x12,x11)), (der(x13)-sinh(x13)), (der(x14)-cosh(x14)), (der(x15)-tanh(x15)), (der(x16)-exp(x16)), (der(x17)-log(x17)), (der(x18)-(0.434294*log(x18))), (der(x19)+x18)))")# CasADi converts log10 to log with constant.
        check_strnorm(repr(dae), expected)

    @testattr(casadi = True)
    def test_ConstructBooleanExpressions(self):
        dae = self.load_model("AtomicModelBooleanExpressions", modelFile).getDaeResidual()
        expected = self._make_path("ConstructBooleanExpressions.txt")
        self.check_result(repr(dae), expected)

    @testattr(casadi = True)
    def test_ConstructMisc(self):
        model = self.load_model("AtomicModelMisc", modelFile)
        expected = self._make_path("ConstructMisc.txt")
        self.check_result(repr(model.getDaeResidual()) + repr(model.getInitialResidual()), expected)

    @testattr(casadi = True)
    def test_ConstructVariableLaziness(self):
        model = self.load_model("AtomicModelVariableLaziness", modelFile)
        x2_eq = model.getDaeResidual()[0].dep(1)
        x1_eq = model.getDaeResidual()[1].dep(1)
        x1_var = model.getVariables(Model.DIFFERENTIATED)[0].getVar()
        x2_var = model.getVariables(Model.DIFFERENTIATED)[1].getVar()
        assert is_equal(x1_var, x1_eq) and is_equal(x2_var, x2_eq)

    @testattr(casadi = True)
    def test_ConstructArrayInOutFunction1(self):
        model = self.load_model("AtomicModelVector1", modelFile, compiler_options={"inline_functions":"none"})
        expected = self._make_path("ConstructArrayInOutFunction1a.txt")
        self.check_result(model.getModelFunction("AtomicModelVector1_f"), expected)
        expected = self._make_path("ConstructArrayInOutFunction1b.txt")
        self.check_result(model.getDaeResidual(), expected)

    @testattr(casadi = True)
    def test_ConstructArrayInOutFunction2(self):
        model = self.load_model("AtomicModelVector2", modelFile, compiler_options={"inline_functions":"none"})
        expected = self._make_path("test_ConstructArrayInOutFunction2a.txt")
        self.check_result(model.getModelFunction("AtomicModelVector2_f"), expected)
        expected = self._make_path("test_ConstructArrayInOutFunction2b.txt")
        self.check_result(model.getDaeResidual(), expected)

    @testattr(casadi = True)
    def test_ConstructArrayInOutFunctionCallEquation(self):
        model = self.load_model("AtomicModelVector3", modelFile, compiler_options={"inline_functions":"none", "variability_propagation":False})
        expected = self._make_path("ConstructArrayInOutFunctionCallEquationA.txt")
        self.check_result(model.getModelFunction("AtomicModelVector3_f"), expected)
        expected = self._make_path("ConstructArrayInOutFunctionCallEquationB.txt")
        self.check_result(model.getDaeResidual(), expected)

    @testattr(casadi = True)
    def test_FunctionCallEquationOmittedOuts(self):
        model = self.load_model("atomicModelFunctionCallEquationIgnoredOuts", modelFile, compiler_options={"inline_functions":"none", "variability_propagation":False})
        expected = self._make_path("FunctionCallEquationOmittedOuts.txt")
        self.check_result(model.getDaeResidual(), expected)  

    @testattr(casadi = True)
    def test_FunctionCallStatementOmittedOuts(self):
        model = self.load_model("atomicModelFunctionCallStatementIgnoredOuts", modelFile, compiler_options={"inline_functions":"none"})
        expected = self._make_path("FunctionCallStatementOmittedOuts.txt")
        self.check_result(model.getModelFunction("atomicModelFunctionCallStatementIgnoredOuts_f2"), expected)
    
    @testattr(casadi = True)
    def test_ParameterIndexing(self):
        model = self.load_model("ParameterIndexing1", modelFile)
        expected = "[x[1] = 0 x[2] = 2]"
        assert strnorm(model.getDaeEquations()) == strnorm(expected)
    
    @testattr(casadi = True)
    def test_OmittedArrayRecordOuts(self):
        model = self.load_model("atomicModelFunctionCallStatementIgnoredArrayRecordOuts", modelFile, compiler_options={"inline_functions":"none"})
        expectedFunction = self._make_path("OmittedArrayRecordOutsFunction.txt")
        expectedResidual = self._make_path("OmittedArrayRecordOutsResidual.txt")
        self.check_result(model.getModelFunction("atomicModelFunctionCallStatementIgnoredArrayRecordOuts_f2"), expectedFunction)
        self.check_result(model.getDaeResidual(), expectedResidual)

    @testattr(casadi = True)
    def test_ConstructFunctionMatrix(self):
        model = self.load_model("AtomicModelMatrix", modelFile, compiler_options={"inline_functions":"none","variability_propagation":False})
        expected = self._make_path("ConstructFunctionMatrixA.txt")
        self.check_result(model.getModelFunction("AtomicModelMatrix_f"), expected)
        expected = self._make_path("ConstructFunctionMatrixB.txt")
        self.check_result(model.getDaeResidual(), expected)

    @testattr(casadi = True)
    def test_ConstructFunctionMatrixDimsGreaterThanTwo(self):
        model = self.load_model("AtomicModelLargerThanTwoDimensionArray", modelFile, compiler_options={"inline_functions":"none"})
        expected = self._make_path("ConstructFunctionMatrixDimsGreaterThanTwoFunction.txt")
        self.check_result(model.getModelFunction("AtomicModelLargerThanTwoDimensionArray_f"), expected)
        expected = self._make_path("ConstructFunctionMatrixDimsGreaterThanTwoResidual.txt")
        self.check_result(model.getDaeResidual(), expected)

    @testattr(casadi = True)
    def test_ConstructNestedRecordFunctions(self):
        model = self.load_model("AtomicModelRecordNestedArray",  modelFile, compiler_options={"inline_functions":"none"})
        expected = self._make_path("ConstructNestedRecordFunctionsA.txt")    
        self.check_result(model.getModelFunction("AtomicModelRecordNestedArray_generateCurves"), expected)
        expected =self._make_path("ConstructNestedRecordFunctionsB.txt")
        self.check_result(model.getDaeResidual(), expected)


    @testattr(casadi = True)
    def test_ConstructRecordInFunctionInFunction(self):
        model = self.load_model("AtomicModelRecordInOutFunctionCallStatement", modelFile, compiler_options={"inline_functions":"none"})
        expected = self._make_path("ConstructRecordInFunctionInFunctionA.txt")
        funcStr = str(model.getModelFunction("AtomicModelRecordInOutFunctionCallStatement_f1")) + str(model.getModelFunction("AtomicModelRecordInOutFunctionCallStatement_f2"))
        self.check_result(funcStr, expected)
        expected = self._make_path("ConstructRecordInFunctionInFunctionB.txt")
        self.check_result(model.getDaeResidual(), expected)



    @testattr(casadi = True)
    def test_ConstructRecordArbitraryDimension(self):
        model = self.load_model("AtomicModelRecordArbitraryDimension", modelFile, compiler_options={"inline_functions":"none"})
        expected = self._make_path("ConstructRecordArbitraryDimensionA.txt")
        self.check_result(model.getModelFunction("AtomicModelRecordArbitraryDimension_f"), expected)
        expected = self._make_path("ConstructRecordArbitraryDimensionB.txt")
        self.check_result(model.getDaeResidual(), expected)



    @testattr(casadi = True)
    def test_ConstructArrayFlattening(self):
        model =  self.load_model("atomicModelSimpleArrayIndexing", modelFile, compiler_options={"inline_functions":"none"})
        expected = self._make_path("ConstructArrayFlattening.txt")
        self.check_result(model.getModelFunction("atomicModelSimpleArrayIndexing_f"), expected)

    @testattr(casadi = True)
    def test_ConstructRecordNestedSeveralVars(self):
        model = self.load_model("AtomicModelRecordSeveralVars", modelFile, compiler_options={"inline_functions":"none"})
        expected = self._make_path("ConstructRecordNestedSeveralVarsA.txt")
        self.check_result(model.getModelFunction("AtomicModelRecordSeveralVars_f"), expected)
        expected = self._make_path("ConstructRecordNestedSeveralVarsB.txt")
        self.check_result(model.getDaeResidual(), expected)



    @testattr(casadi = True)
    def test_ConstructFunctionsInRhs(self):
        model = self.load_model("AtomicModelAtomicRealFunctions", modelFile, compiler_options={"inline_functions":"none"})
        expected = self._make_path("ConstructFunctionsInRhsA.txt")
        self.check_result(model.getDaeResidual(), expected)


        model = self.load_model("AtomicModelAtomicIntegerFunctions", modelFile, compiler_options={"inline_functions":"none"})
        expected = self._make_path("ConstructFunctionsInRhsB.txt")
        self.check_result(model.getDaeResidual(), expected) 


        model = self.load_model("AtomicModelAtomicBooleanFunctions", modelFile, compiler_options={"inline_functions":"none"})
        expected = self._make_path("ConstructFunctionsInRhsC.txt")
        self.check_result(model.getDaeResidual(), expected) 



    @testattr(casadi = True)
    def test_ConstructVariousRealValuedFunctions(self):
        model = self.load_model("AtomicModelAtomicRealFunctions", modelFile, compiler_options={"inline_functions":"none"},compiler_log_level="e")
        #function monoInMonoOut
            #input Real x
            #output Real y
        #algorithm
            #y := x
        #end monoInMonoOut
        expected = self._make_path("ConstructVariousRealValuedFunctionsA.txt")
        self.check_result(model.getModelFunction("AtomicModelAtomicRealFunctions_monoInMonoOut"), expected) 

        #function polyInMonoOut
            #input Real x1
            #input Real x2
            #output Real y
        #algorithm
            #y := x1+x2
        #end polyInMonoOut
        #end monoInMonoOut
        expected = self._make_path("ConstructVariousRealValuedFunctionsB.txt")
        self.check_result(model.getModelFunction("AtomicModelAtomicRealFunctions_polyInMonoOut"), expected) 

        #function monoInPolyOut
            #input Real x
            #output Real y1
            #output Real y2
        #algorithm
            #y1 := if(x > 2) then 1 else 5
            #y2 := x
        #end monoInPolyOut
        expected = self._make_path("ConstructVariousRealValuedFunctionsC.txt")
        self.check_result(model.getModelFunction("AtomicModelAtomicRealFunctions_monoInPolyOut"), expected)

        #function polyInPolyOut
            #input Real x1
            #input Real x2
            #output Real y1
            #output Real y2
        #algorithm
            #y1 := x1
            #y2 := x2
        #end polyInPolyOut
        expected = self._make_path("ConstructVariousRealValuedFunctionsD.txt")
        self.check_result(model.getModelFunction("AtomicModelAtomicRealFunctions_polyInPolyOut"), expected)

        #function monoInMonoOutReturn
            #input Real x
            #output Real y
        #algorithm
            #y := x
            #return
            #y := 2*x
        #end monoInMonoOutReturn
        expected = self._make_path("ConstructVariousRealValuedFunctionsE.txt")
        self.check_result(model.getModelFunction("AtomicModelAtomicRealFunctions_monoInMonoOutReturn"), expected)

        #function functionCallInFunction
            #input Real x
            #output Real y
        #algorithm
            #y := monoInMonoOut(x)
        #end functionCallInFunction
        expected = self._make_path("ConstructVariousRealValuedFunctionsBF.txt")
        self.check_result(model.getModelFunction("AtomicModelAtomicRealFunctions_functionCallInFunction"), expected)

        #function functionCallEquationInFunction
            #input Real x
            #Real internal
            #output Real y
        #algorithm
            #(y,internal) := monoInPolyOut(x)
        #end functionCallEquationInFunction
        expected = self._make_path("ConstructVariousRealValuedFunctionsG.txt")
        self.check_result(model.getModelFunction("AtomicModelAtomicRealFunctions_functionCallEquationInFunction"), expected)

        #function monoInMonoOutInternal
            #input Real x
            #Real internal
            #output Real y
        #algorithm
            #internal := sin(x)
            #y := x*internal
            #internal := sin(y)
            #y := x + internal
        #end monoInMonoOutInternal
        expected = self._make_path("ConstructVariousRealValuedFunctionsH.txt")
        self.check_result(model.getModelFunction("AtomicModelAtomicRealFunctions_monoInMonoOutInternal"), expected)

        #function polyInPolyOutInternal
            #input Real x1
            #input Real x2
            #Real internal1
            #Real internal2
            #output Real y1
            #output Real y2
        #algorithm
            #internal1 := x1
            #internal2 := x2 + internal1
            #y1 := internal1
            #y2 := internal2 + x1
            #y2 := 1
        #end polyInPolyOutInternal
        expected = self._make_path("ConstructVariousRealValuedFunctionsI.txt")
        self.check_result(model.getModelFunction("AtomicModelAtomicRealFunctions_polyInPolyOutInternal"), expected)


    @testattr(casadi = True)
    def test_ConstructVariousIntegerValuedFunctions(self):
        model = self.load_model("AtomicModelAtomicIntegerFunctions", modelFile, compiler_options={"inline_functions":"none"},compiler_log_level="e")
        #function monoInMonoOut
            #input Integer x
            #output Integer y
        #algorithm
            #y := x
        #end monoInMonoOut
        expected = self._make_path("ConstructVariousIntegerValuedFunctionsA.txt")
        self.check_result(model.getModelFunction("AtomicModelAtomicIntegerFunctions_monoInMonoOut"), expected) 

        #function polyInMonoOut
            #input Integer x1
            #input Integer x2
            #output Integer y
        #algorithm
            #y := x1+x2
        #end polyInMonoOut
        #end monoInMonoOut
        expected = self._make_path("ConstructVariousIntegerValuedFunctionsB.txt")
        self.check_result(model.getModelFunction("AtomicModelAtomicIntegerFunctions_polyInMonoOut"), expected) 

        #function monoInPolyOut
            #input Integer x
            #output Integer y1
            #output Integer y2
        #algorithm
            #y1 := if(x > 2) then 1 else 5
            #y2 := x
        #end monoInPolyOut
        expected = self._make_path("ConstructVariousIntegerValuedFunctionsC.txt")
        self.check_result(model.getModelFunction("AtomicModelAtomicIntegerFunctions_monoInPolyOut"), expected)

        #function polyInPolyOut
            #input Integer x1
            #input Integer x2
            #output Integer y1
            #output Integer y2
        #algorithm
            #y1 := x1
            #y2 := x2
        #end polyInPolyOut
        expected = self._make_path("ConstructVariousIntegerValuedFunctionsD.txt")
        self.check_result(model.getModelFunction("AtomicModelAtomicIntegerFunctions_polyInPolyOut"), expected)

        #function monoInMonoOutReturn
            #input Integer x
            #output Integer y
        #algorithm
            #y := x
            #return
            #y := 2*x
        #end monoInMonoOutReturn
        expected = self._make_path("ConstructVariousIntegerValuedFunctionsE.txt")
        self.check_result(model.getModelFunction("AtomicModelAtomicIntegerFunctions_monoInMonoOutReturn"), expected)

        #function functionCallInFunction
            #input Integer x
            #output Integer y
        #algorithm
            #y := monoInMonoOut(x)
        #end functionCallInFunction
        expected = self._make_path("ConstructVariousIntegerValuedFunctionsF.txt")
        self.check_result(model.getModelFunction("AtomicModelAtomicIntegerFunctions_functionCallInFunction"), expected)

        #function functionCallEquationInFunction
            #input Integer x
            #Integer internal
            #output Integer y
        #algorithm
            #(y,internal) := monoInPolyOut(x)
        #end functionCallEquationInFunction
        expected = self._make_path("ConstructVariousIntegerValuedFunctionsG.txt")
        self.check_result(model.getModelFunction("AtomicModelAtomicIntegerFunctions_functionCallEquationInFunction"), expected)

        #function monoInMonoOutInternal
            #input Integer x
            #Integer internal
            #output Integer y
        #algorithm
            #internal := 3*x
            #y := x*internal
            #internal := 1+y
            #y := x + internal
        #end monoInMonoOutInternal
        expected = self._make_path("ConstructVariousIntegerValuedFunctionsH.txt")
        self.check_result(model.getModelFunction("AtomicModelAtomicIntegerFunctions_monoInMonoOutInternal"), expected)

        #function polyInPolyOutInternal
            #input Integer x1
            #input Integer x2
            #Integer internal1
            #Integer internal2
            #output Integer y1
            #output Integer y2
        #algorithm
            #internal1 := x1
            #internal2 := x2 + internal1
            #y1 := internal1
            #y2 := internal2 + x1
            #y2 := 1
        #end polyInPolyOutInternal
        expected = self._make_path("ConstructVariousIntegerValuedFunctionsI.txt")
        self.check_result(model.getModelFunction("AtomicModelAtomicIntegerFunctions_polyInPolyOutInternal"), expected)


    @testattr(casadi = True)
    def test_ConstructVariousBooleanValuedFunctions(self):
        model = self.load_model("AtomicModelAtomicBooleanFunctions", modelFile, compiler_options={"inline_functions":"none"},compiler_log_level="e")
        #function monoInMonoOut
            #input Boolean x
            #output Boolean y
        #algorithm
            #y := x
        #end monoInMonoOut
        expected = self._make_path("ConstructVariousBooleanValuedFunctionsA.txt")
        self.check_result(model.getModelFunction("AtomicModelAtomicBooleanFunctions_monoInMonoOut"), expected) 

        #function polyInMonoOut
            #input Boolean x1
            #input Boolean x2
            #output Boolean y
        #algorithm
            #y := x1 and x2
        #end polyInMonoOut
        expected = self._make_path("ConstructVariousBooleanValuedFunctionsB.txt")
        self.check_result(model.getModelFunction("AtomicModelAtomicBooleanFunctions_polyInMonoOut"), expected) 

        #function monoInPolyOut
            #input Boolean x
            #output Boolean y1
            #output Boolean y2
        #algorithm
            #y1 := if(x) then false else (x or false)
            #y2 := x
        #end monoInPolyOut
        expected = self._make_path("ConstructVariousBooleanValuedFunctionsC.txt")
        self.check_result(model.getModelFunction("AtomicModelAtomicBooleanFunctions_monoInPolyOut"), expected)

        #function polyInPolyOut
            #input Boolean x1
            #input Boolean x2
            #output Boolean y1
            #output Boolean y2
        #algorithm
            #y1 := x1
            #y2 := x2
        #end polyInPolyOut
        expected = self._make_path("ConstructVariousBooleanValuedFunctionsD.txt")
        self.check_result(model.getModelFunction("AtomicModelAtomicBooleanFunctions_polyInPolyOut"), expected)

        #function monoInMonoOutReturn
            #input Boolean x
            #output Boolean y
        #algorithm
            #y := x
            #return
            #y := x or false
        #end monoInMonoOutReturn
        expected = self._make_path("ConstructVariousBooleanValuedFunctionsE.txt")
        self.check_result(model.getModelFunction("AtomicModelAtomicBooleanFunctions_monoInMonoOutReturn"), expected)

        #function functionCallInFunction
            #input Boolean x
            #output Boolean y
        #algorithm
            #y := monoInMonoOut(x)
        #end functionCallInFunction
        expected = self._make_path("ConstructVariousBooleanValuedFunctionsF.txt")
        self.check_result(model.getModelFunction("AtomicModelAtomicBooleanFunctions_functionCallInFunction"), expected)

        #function functionCallEquationInFunction
            #input Boolean x
            #Boolean internal
            #output Boolean y
        #algorithm
            #(y,internal) := monoInPolyOut(x)
        #end functionCallEquationInFunction
        expected = self._make_path("ConstructVariousBooleanValuedFunctionsG.txt")
        self.check_result(model.getModelFunction("AtomicModelAtomicBooleanFunctions_functionCallEquationInFunction"), expected)

        #function monoInMonoOutInternal
            #input Boolean x
            #Boolean internal
            #output Boolean y
        #algorithm
            #internal := x
            #y := x and internal
            #internal := false or y
            #y := false or internal
        #end monoInMonoOutInternal
        expected = self._make_path("ConstructVariousBooleanValuedFunctionsH.txt")
        self.check_result(model.getModelFunction("AtomicModelAtomicBooleanFunctions_monoInMonoOutInternal"), expected)

        #function polyInPolyOutInternal
            #input Boolean x1
            #input Boolean x2
            #Boolean internal1
            #Boolean internal2
            #output Boolean y1
            #output Boolean y2
        #algorithm
            #internal1 := x1
            #internal2 := x2  or internal1
            #y1 := internal1
            #y2 := internal2 or x1
            #y2 := true
        #end polyInPolyOutInternal
        expected = self._make_path("ConstructVariousBooleanValuedFunctionsI.txt")
        self.check_result(model.getModelFunction("AtomicModelAtomicBooleanFunctions_polyInPolyOutInternal"), expected)

    @testattr(casadi = True)
    def test_TransferVariableType(self):
        model = self.load_model("AtomicModelMisc", modelFile)
        x1 = model.getVariable('x1')
        assert isinstance(x1, RealVariable)
        assert isinstance(x1.getMyDerivativeVariable(), DerivativeVariable)
        assert isinstance(model.getVariable('x2'), IntegerVariable)
        assert isinstance(model.getVariable('x3'), BooleanVariable)
        assert isinstance(model.getVariable('x4'), BooleanVariable)

    @testattr(casadi = True)
    def test_ModelIdentifier(self):
        model = self.load_model("identifierTest.identfierTestModel", modelFile)
        assert model.getIdentifier().replace('\n','') ==\
               "identifierTest_identfierTestModel".replace('\n','')


class TestModelicaTransfer(ModelicaTransfer):
    """Modelica transfer tests that use transfer_model to load the model"""
    
    def load_model(self, *args, **kwargs):
        model = Model()
        transfer_model(model, *args, **kwargs)
        return model

class TestModelicaTransferOpt(ModelicaTransfer):
    """Modelica transfer tests that use transfer_model to load the model"""
    
    def load_model(self, *args, **kwargs):
        model = OptimizationProblem()
        transfer_model(model, *args, **kwargs)
        return model


##############################################
#                                            # 
#          OPTIMICA TRANSFER TESTS           #
#                                            #
##############################################

def computeStringRepresentationForContainer(myContainer):
    stringRepr = ""
    for index in range(len(myContainer)):
        stringRepr += str(myContainer[index])
    return stringRepr
    
    
@testattr(casadi = True)    
def test_OptimicaLessThanPathConstraint():
    optProblem =  load_optimization_problem("atomicOptimizationLEQ", optproblemsFile)
    expected = str(x1.name()) + " <= " + str(1)
    check_strnorm(computeStringRepresentationForContainer(optProblem.getPathConstraints()), expected)

@testattr(casadi = True)
def test_OptimicaGreaterThanPathConstraint():
    optProblem =  load_optimization_problem("atomicOptimizationGEQ", optproblemsFile)
    expected = str(x1.name()) + " >= " + str(1)
    check_strnorm(computeStringRepresentationForContainer(optProblem.getPathConstraints()), expected)
    
@testattr(casadi = True)    
def test_OptimicaSevaralPathConstraints():
    optProblem =  load_optimization_problem("atomicOptimizationGEQandLEQ", optproblemsFile)
    expected = str(x2.name()) + " <= " + str(1) +  str(x1.name()) + " >= " + str(1) 
    check_strnorm(computeStringRepresentationForContainer(optProblem.getPathConstraints()), expected)    

@testattr(casadi = True)
def test_OptimicaEqualityPointConstraint():
    optProblem =  load_optimization_problem("atomicOptimizationEQpoint", optproblemsFile)
    expected = str(MX.sym("x1(finalTime)").name()) + " = " + str(1)
    check_strnorm(computeStringRepresentationForContainer(optProblem.getPointConstraints()), expected)
    
@testattr(casadi = True)    
def test_OptimicaLessThanPointConstraint():
    optProblem =  load_optimization_problem("atomicOptimizationLEQpoint", optproblemsFile)
    expected = str(MX.sym("x1(finalTime)").name()) + " <= " + str(1)
    check_strnorm(computeStringRepresentationForContainer(optProblem.getPointConstraints()), expected)

@testattr(casadi = True)
def test_OptimicaGreaterThanPointConstraint():
    optProblem =  load_optimization_problem("atomicOptimizationGEQpoint", optproblemsFile)
    expected = str(MX.sym("x1(finalTime)").name()) + " >= " + str(1)
    check_strnorm(computeStringRepresentationForContainer(optProblem.getPointConstraints()), expected)
    
@testattr(casadi = True)    
def test_OptimicaSevaralPointConstraints():
    optProblem =  load_optimization_problem("atomicOptimizationGEQandLEQandEQpoint", optproblemsFile)
    expected = str(MX.sym("x2(startTime + 1)").name()) + " <= " + str(1) +  str(MX.sym("x1(startTime + 1)").name()) + " >= " + str(1) + str(MX.sym("x2(finalTime + 1)").name()) + " = " + str(1)
    check_strnorm(computeStringRepresentationForContainer(optProblem.getPointConstraints()), expected)
    
@testattr(casadi = True)    
def test_OptimicaMixedConstraints():
    optProblem =  load_optimization_problem("atomicOptimizationMixedConstraints", optproblemsFile)
    expectedPath = str(MX.sym("x3(startTime + 1)").name()) + " <= " + str(x1.name())
    expectedPoint =  str(MX.sym("x2(startTime + 1)").name()) + " <= " + str(1) +  str(MX.sym("x1(startTime + 1)").name()) + " >= " + str(1) 
    check_strnorm(computeStringRepresentationForContainer(optProblem.getPathConstraints()), expectedPath)
    check_strnorm(computeStringRepresentationForContainer(optProblem.getPointConstraints()), expectedPoint)
    
@testattr(casadi = True)    
def test_OptimicaTimedVariables():
    optProblem =  load_optimization_problem("atomicOptimizationTimedVariables", optproblemsFile)
    # test there are 3 timed
    timedVars = optProblem.getTimedVariables()
    assert len(timedVars) == 4

    # test they contain model vars
    x1 = optProblem.getVariable("x1")
    x2 = optProblem.getVariable("x2")
    x3 = optProblem.getVariable("x3")

    assert x1 == timedVars[0].getBaseVariable()
    assert x2 == timedVars[1].getBaseVariable()
    assert x3 == timedVars[2].getBaseVariable()
    assert x1 == timedVars[3].getBaseVariable()
        
        
    # Test their time expression has start/final parameter MX in them and
    # that timed variables are lazy.
    startTime = optProblem.getVariable("startTime")
    finalTime = optProblem.getVariable("finalTime")
    path_constraints = optProblem.getPathConstraints()
    point_constraints = optProblem.getPointConstraints()

    tp1 = timedVars[0].getTimePoint()
    tp2 = timedVars[1].getTimePoint()
    tp3 = timedVars[2].getTimePoint()
    tp4 = timedVars[3].getTimePoint()

    tv1 = timedVars[0].getVar()
    tv2 = timedVars[1].getVar()
    tv3 = timedVars[2].getVar()
    tv4 = timedVars[3].getVar()

    assert is_equal(tp1.dep(1), startTime.getVar())
    assert is_equal(tp2.dep(1), startTime.getVar())
    assert is_equal(tp3.dep(0), finalTime.getVar())
    assert is_equal(tp4, finalTime.getVar())

    assert is_equal(tv1, point_constraints[0].getLhs())
    assert is_equal(tv2, path_constraints[0].getLhs())
    assert is_equal(tv3, path_constraints[1].getLhs())
    assert is_equal(tv4, optProblem.getObjective())

@testattr(casadi = True)
def test_OptimicaStartTime():
    optProblem =  load_optimization_problem("atomicOptimizationStart5", optproblemsFile)
    assert( float(optProblem.getStartTime()) == 5)
    
@testattr(casadi = True)    
def test_OptimicaFinalTime():
    optProblem =  load_optimization_problem("atomicOptimizationFinal10", optproblemsFile)
    assert( float(optProblem.getFinalTime()) == 10)

@testattr(casadi = True)
def test_OptimicaObjectiveIntegrand():
    optProblem =  load_optimization_problem("atomicLagrangeX1", optproblemsFile)
    assert str(optProblem.getObjectiveIntegrand()) == str(x1) 
    optProblem =  load_optimization_problem("atomicLagrangeNull", optproblemsFile)
    assert str(optProblem.getObjectiveIntegrand()) == str(MX(0))  

@testattr(casadi = True)
def test_OptimicaObjective():
    optProblem =  load_optimization_problem("atomicMayerFinalTime", optproblemsFile)
    assert str(optProblem.getObjective()) == str(MX.sym("finalTime")) 
    optProblem =  load_optimization_problem("atomicMayerNull", optproblemsFile)
    assert str(optProblem.getObjective()) == str(MX(0))

@testattr(casadi = True)
def test_OptimicaFree():
    model =  load_optimization_problem("atomicWithFree", optproblemsFile)
    diffs =  model.getVariables(Model.DIFFERENTIATED)
    assert str((diffs[0].getAttribute("free"))) == str(MX(False))

@testattr(casadi = True)
def test_OptimicaInitialGuess():
    model =  load_optimization_problem("atomicWithInitialGuess", optproblemsFile)
    diffs =  model.getVariables(Model.DIFFERENTIATED)
    assert str(diffs[0].getAttribute("initialGuess")) == str(MX(5))

@testattr(casadi = True)
def test_OptimicaNormalizedTimeFlag():
    optProblem = load_optimization_problem("atomicWithInitialGuess", optproblemsFile)
    assert optProblem.getNormalizedTimeFlag()
    optProblem = load_optimization_problem("atomicWithInitialGuess", optproblemsFile, compiler_options={"normalize_minimum_time_problems":True})
    assert optProblem.getNormalizedTimeFlag()
    optProblem = load_optimization_problem("atomicWithInitialGuess", optproblemsFile, compiler_options={"normalize_minimum_time_problems":False})
    assert not optProblem.getNormalizedTimeFlag()
    

@testattr(casadi = True)    
def test_ModelIdentifier():
    optProblem = load_optimization_problem("identifierTest.identfierTestModel", optproblemsFile)
    check_strnorm(optProblem.getIdentifier(), "identifierTest_identfierTestModel")
