package ExtFunctionTests

model ExtFunctionTest1
 Real a(start=1) = 1;
 Real b(start=2) = 2;
 Real c(start=3);

 algorithm
  c := add(a,b);

end ExtFunctionTest1;

function add
 input Real a;
 input Real b;
 output Real c;

 external "C" annotation(Library="addNumbers",
                         Include="#include \"addNumbers.h\"");
end add;

//model ExtFunctionTest2
// Real a(start=1) = 1;
// Real b(start=2) = 2;
// Real c(start=3);
// Real d(start=3);
// 
// algorithm
//   c := add(a,b);
//   d := add2(a,b);
//   
//end ExtFunctionTest2;
//
//function add2
// input Real a;
// input Real b;
// output Real c;
// 
// external "C" annotation(Library="addNumbers",
//                         Include="#include \"addNumbers.h\"");
//end add2;

model ExtFunctionTest3
 Real a(start=10);
   
 equation
   testModelicaMessages();
   testModelicaErrorMessages();
   testModelicaAllocateStrings();
   der(a) = a;
 
end ExtFunctionTest3;

function testModelicaMessages
    external "C" annotation(Include="#include \"testModelicaUtilities.c\"");
end testModelicaMessages;

function testModelicaErrorMessages
    external "C" annotation(Include="#include \"testModelicaUtilities.c\"");
end testModelicaErrorMessages;

function testModelicaAllocateStrings
    external "C" annotation(Include="#include \"testModelicaUtilities.c\"");
end testModelicaAllocateStrings;

end ExtFunctionTests;
