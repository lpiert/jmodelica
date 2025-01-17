package OperatorTests "Some tests for operators" 

model SemiLinearTest
  Real x,y;
equation
  x = time*time - 1;
  y = semiLinear(x,3,-5);
end SemiLinearTest;

model DivTest
  Real x;
  Real y;
equation 
  x = div(time*time*10, 2);
  y = div(time*time*10, -2);
end DivTest;

model ModTest
  Real x;
  Real y;
equation 
  x = mod(time*time*10, 2);
  y = mod(time*time*10, -2);
end ModTest;

model RemTest
  Real x;
  Real y;
equation 
  x = rem(time*time*10, 2);
  y = rem(time*time*10, -2);
end RemTest;

model CeilTest
  Real x;
  Real y;
equation 
  x = 4*sin(2*Modelica.Constants.pi*time);
  y = ceil(x);
end CeilTest;

model FloorTest
  Real x;
  Real y;
equation 
  x = 4*sin(2*Modelica.Constants.pi*time);
  y = floor(x);
end FloorTest;

model IntegerTest
  Real x;
  Integer y;
equation 
  x = 4*sin(2*Modelica.Constants.pi*time);
  y = integer(x);
end IntegerTest;

model NestedTest
  Real x;
  Real y;
equation 
  x = 8*sin(2*Modelica.Constants.pi*time);
  y = integer(1.5 + floor(x/2));
end NestedTest;

model SignTest
  Real[2,2] a = {{-1,2},{3,-4}} * time;
  discrete Real b;
  Real[2,2] x;
  Real y,z;
initial equation
  b = 1;
equation 
  x = sign(a);
  y = sign(-7.9*time);
  z = sign(2*b);
  when time > 0.5 then
    b = 0;
  end when;
end SignTest;

model EdgeTest
  discrete Boolean b;
  discrete Boolean x;
  discrete Boolean y;
initial equation 
  b = false;
  x = false;
equation 
  y = edge(b);
  when {time > 0.5, time > 1.5} then
    x = edge(b);
    b = not(pre(b));
  end when;
end EdgeTest;

model ChangeTest
  discrete Boolean b;
  discrete Boolean x;
  discrete Boolean y;
initial equation 
  b = false;
  x = false;
equation 
  y = change(b);
  when {time > 0.5, time > 1.5} then
    x = change(b);
    b = not(pre(b));
  end when;
end ChangeTest;

end OperatorTests;
