package NominalTests

model NominalTest1
  Real y(start=1e4, nominal=1e4);
  Real x(start=3);
  Real z(start=10000,nominal=10000)=4;
  parameter Real p(nominal=4) =1;
equation
 der(x) = 3;
 der(y) = -y;
end NominalTest1;

optimization NominalOptTest1(objective=y(finalTime),startTime=0,finalTime=10)
extends NominalTest1(x(fixed=true),y(fixed=true));
end NominalOptTest1;

optimization NominalOptTest2(objective=cost(finalTime),startTime=0,finalTime=10)
  parameter Integer i = 1;
  parameter Boolean b = true;
  Real x(start=10000, fixed=true,nominal=10000);
  input Real u(min=-1000,max=1000, nominal = 5000);
  Real cost(start=0,fixed=true, nominal=1e6);
equation
  der(x) = -x + u;
  der(cost) = x^2 + u^2;
end NominalOptTest2;

end NominalTests;