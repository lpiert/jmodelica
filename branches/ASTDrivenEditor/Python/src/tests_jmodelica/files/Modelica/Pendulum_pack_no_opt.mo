package Pendulum_pack

  model Pendulum
    parameter Real th0=0.1;
    parameter Real dth0 = 0;
    parameter Real x0=0;
    parameter Real dx0 = 0;

    Real theta(start=th0);
    Real dtheta(start=dth0);
    Real x(start=x0);
    Real dx(start=dx0);
    input Real u;

  equation
    der(theta) = dtheta;
    der(dtheta) = sin(theta) + u*cos(theta);
    der(x) = dx;
    der(dx) = u;
  end Pendulum;
  
  model PlanarPendulum
    parameter Real L = 1 "Pendulum length";
    parameter Real g =9.81 "Acceleration due to gravity";
    Real x(start=0.1,stateSelect=StateSelect.always) "Cartesian x coordinate";
    Real y(start=-0.9,fixed=true) "Cartesian y coordinate";
    Real vx(stateSelect=StateSelect.always) "Velocity in x coordinate";
    Real vy "Velocity in y coordinate";
    Real lambda "Lagrange multiplier";
  equation
    der(x) = vx;
    der(y) = vy;
    der(vx) = lambda*x;
    der(vy) = lambda*y - g;
    x^2 + y^2 = L;
  end PlanarPendulum;

end Pendulum_pack;