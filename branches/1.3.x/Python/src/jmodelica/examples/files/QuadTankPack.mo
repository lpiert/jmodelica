package QuadTankPack
	       
  model PRBS1
    Modelica.Blocks.Interfaces.RealOutput y;
    parameter Integer N = 10;
    parameter Real ts[N] = {  0. ,   3.3,   9.3,  15.3,  24.3,  36.3,  39.3,  42.3,  54.3,  57.3};
    parameter Real ys[N] = { 5.,  6.,  5.,  6.,  5.,  6.,  5.,  6.,  5.,  6.};
   equation
    y = noEvent(if time <= ts[2] then ys[1] else
        if time <= ts[3] then ys[2] else
        if time <= ts[4] then ys[3] else
        if time <= ts[5] then ys[4] else
        if time <= ts[6] then ys[5] else
        if time <= ts[7] then ys[6] else
        if time <= ts[8] then ys[7] else
        if time <= ts[9] then ys[8] else
        if time <= ts[10] then ys[9] else ys[10]);
  end PRBS1;

model PRBS2
    Modelica.Blocks.Interfaces.RealOutput y;
    parameter Integer N = 11;
    parameter Real ts[N] = { 0. ,   0.3,   9.3,  21.3,  24.3,  27.3,  39.3,  42.3,  48.3,
        51.3,  57.3};
    parameter Real ys[N] = {5.,  6.,  5.,  6.,  5.,  6.,  5.,  6.,  5.,  6.,  5.};
  
 equation
    y = noEvent(if time <= ts[2] then ys[1] else
        if time <= ts[3] then ys[2] else
        if time <= ts[4] then ys[3] else
        if time <= ts[5] then ys[4] else
        if time <= ts[6] then ys[5] else
        if time <= ts[7] then ys[6] else
        if time <= ts[8] then ys[7] else
        if time <= ts[9] then ys[8] else
        if time <= ts[10] then ys[9] else
        if time <= ts[11] then ys[10] else ys[11]);
  end PRBS2;

  model TestPRBS
    PRBS1 prbs1;
    PRBS2 prbs2;
    Real x;
  equation
    der(x) = 1;
  end TestPRBS;

  model Sim_QuadTank
    QuadTank qt;
    input Real u1 = qt.u1;
    input Real u2 = qt.u2;
initial equation
  qt.x1 = 0.0627;
  qt.x2 = 0.06044;
  qt.x3 = 0.024;
  qt.x4 = 0.023;
  end Sim_QuadTank;

  model QuadTank
    // Process parameters
	parameter Modelica.SIunits.Area A1=4.9e-4, A2=4.9e-4, A3=4.9e-4, A4=4.9e-4;
	parameter Modelica.SIunits.Area a1=0.03e-4, a2=0.03e-4, a3=0.03e-4, a4=0.03e-4;
	parameter Modelica.SIunits.Acceleration g=9.81;
	parameter Real k1_nmp(unit="m3^/s/V") = 0.56e-6, k2_nmp(unit="m^3/s/V") = 0.56e-6;
	parameter Real g1_nmp=0.30, g2_nmp=0.30;

    // Initial tank levels
	parameter Modelica.SIunits.Length x1_0 = 0.04102638;
	parameter Modelica.SIunits.Length x2_0 = 0.06607553;
	parameter Modelica.SIunits.Length x3_0 = 0.00393984;
	parameter Modelica.SIunits.Length x4_0 = 0.00556818;
	
    // Tank levels
	Modelica.SIunits.Length x1(start=x1_0,min=0.0001/*,max=0.20*/);
	Modelica.SIunits.Length x2(start=x2_0,min=0.0001/*,max=0.20*/);
	Modelica.SIunits.Length x3(start=x3_0,min=0.0001/*,max=0.20*/);
	Modelica.SIunits.Length x4(start=x4_0,min=0.0001/*,max=0.20*/);

	// Inputs
	input Modelica.SIunits.Voltage u1;
	input Modelica.SIunits.Voltage u2;

  equation
    	der(x1) = -a1/A1*sqrt(2*g*x1) + a3/A1*sqrt(2*g*x3) +
					g1_nmp*k1_nmp/A1*u1;
	der(x2) = -a2/A2*sqrt(2*g*x2) + a4/A2*sqrt(2*g*x4) +
					g2_nmp*k2_nmp/A2*u2;
	der(x3) = -a3/A3*sqrt(2*g*x3) + (1-g2_nmp)*k2_nmp/A3*u2;
	der(x4) = -a4/A4*sqrt(2*g*x4) + (1-g1_nmp)*k1_nmp/A4*u1;

end QuadTank;

model QuadTankInit
  extends QuadTank;
initial equation
  der(x1) = 0;
  der(x2) = 0;
  der(x3) = 0;
  der(x4) = 0;
end QuadTankInit;

optimization QuadTank_Opt (objective = cost(finalTime),
                     startTime = 0,
                     finalTime = 50)

    extends QuadTank(u1(initialGuess=u1_r),u2(initialGuess=u2_r),
                     x1(initialGuess=x1_0,fixed=true),
    	         x2(initialGuess=x2_0,fixed=true),
                     x3(initialGuess=x3_0,fixed=true),
                     x4(initialGuess=x4_0,fixed=true));

// Reference values
    parameter Modelica.SIunits.Length x1_r = 0.06410371;
    parameter Modelica.SIunits.Length x2_r = 0.10324302;
    parameter Modelica.SIunits.Length x3_r = 0.006156;
    parameter Modelica.SIunits.Length x4_r = 0.00870028;
    parameter Modelica.SIunits.Voltage u1_r = 2.5;
    parameter Modelica.SIunits.Voltage u2_r = 2.5;

    Real cost(start=0,fixed=true);

    equation
      der(cost) = 40000*((x1_r - x1))^2 + 
                        40000*((x2_r - x2))^2 + 
                        40000*((x3_r - x3))^2 + 
                        40000*((x4_r - x4))^2 + 
                        ((u1_r - u1))^2 + 
                        ((u2_r - u2))^2;

end QuadTank_Opt;

optimization QuadTank_Static(objective=(x1_meas-x1)^2 + (x2_meas-x2)^2 + 
                                       (x3_meas-x3)^2 + (x4_meas-x4)^2, static=true)
  
  extends QuadTank(a1(free=true),a2(free=true));

 parameter Real x1_meas = x1_0+0.01;
 parameter Real x2_meas = x2_0-0.01;
 parameter Real x3_meas = x3_0-0.01;
 parameter Real x4_meas = x4_0+0.01;

initial equation
 der(x1) = 0;
 der(x2) = 0;
 der(x3) = 0;
 der(x4) = 0;

end QuadTank_Static;

optimization QuadTank_ParEst (objective=sum((y1_meas[i] - qt.x1(t_meas[i]))^2 + 
                                            (y2_meas[i] - qt.x2(t_meas[i]))^2 for i in 1:N_meas),
                                             startTime=0,finalTime=60)
    
    // Initial tank levels
	parameter Modelica.SIunits.Length x1_0 = 0.06255;
	parameter Modelica.SIunits.Length x2_0 = 0.06045;
	parameter Modelica.SIunits.Length x3_0 = 0.02395;
	parameter Modelica.SIunits.Length x4_0 = 0.02325;

   QuadTank qt(x1(fixed=true),x1_0=x1_0,
    	             x2(fixed=true),x2_0=x2_0,
                     x3(fixed=true),x3_0=x3_0,
                     x4(fixed=true),x4_0=x4_0,
                     a1(free=true,initialGuess = 0.03e-4,min=0,max=0.1e-4),
                     a2(free=true,initialGuess = 0.03e-4,min=0,max=0.1e-4));

    // Number of measurement points
    parameter Integer N_meas = 61;
    // Vector of measurement times
    parameter Real t_meas[N_meas] = 0:60.0/(N_meas-1):60;
    // Measurement values for x1 
    // Notice that dummy values are entered here:
    // the real measurement values will be set from Python
    parameter Real y1_meas[N_meas] = ones(N_meas);
    // Measurement values for x2 	
    parameter Real y2_meas[N_meas] = ones(N_meas);
    // Input trajectory for u1 
    PRBS1 prbs1;
    // Input trajectory for u2
    PRBS2 prbs2;	
equation
    connect(prbs1.y,qt.u1);
    connect(prbs2.y,qt.u2);
end QuadTank_ParEst;

optimization QuadTank_ParEst2 (objective=sum((y1_meas[i] - qt.x1(t_meas[i]))^2 + 
                                            (y2_meas[i] - qt.x2(t_meas[i]))^2 +
                                             (y3_meas[i] - qt.x3(t_meas[i]))^2 +
                                             (y4_meas[i] - qt.x4(t_meas[i]))^2 for i in 1:N_meas),
                                             startTime=0,finalTime=60)
    
    // Initial tank levels
	parameter Modelica.SIunits.Length x1_0 = 0.06255;
	parameter Modelica.SIunits.Length x2_0 = 0.06045;
	parameter Modelica.SIunits.Length x3_0 = 0.02395;
	parameter Modelica.SIunits.Length x4_0 = 0.02325;

   QuadTank qt(x1(fixed=true),x1_0=x1_0,
    	             x2(fixed=true),x2_0=x2_0,
                     x3(fixed=true),x3_0=x3_0,
                     x4(fixed=true),x4_0=x4_0,
                     a1(free=true,initialGuess = 0.03e-4,nominal=0.03e-4,min=0,max=0.1e-4),
                     a2(free=true,initialGuess = 0.03e-4,nominal=0.03e-4,min=0,max=0.1e-4),
                     a3(free=true,initialGuess = 0.03e-4,nominal=0.03e-4,min=0,max=0.1e-4),
                     a4(free=true,initialGuess = 0.03e-4,nominal=0.03e-4,min=0,max=0.1e-4));

    parameter Integer N_meas = 61;
    parameter Real t_meas[N_meas] = 0:60.0/(N_meas-1):60; 
    parameter Real y1_meas[N_meas] = ones(N_meas); 	
    parameter Real y2_meas[N_meas] = ones(N_meas); 
    parameter Real y3_meas[N_meas] = ones(N_meas); 	
    parameter Real y4_meas[N_meas] = ones(N_meas); 
    PRBS1 prbs1;
    PRBS2 prbs2;	
equation
    connect(prbs1.y,qt.u1);
    connect(prbs2.y,qt.u2);
end QuadTank_ParEst2;


optimization QuadTank_Sens 
    
    // Initial tank levels
	parameter Modelica.SIunits.Length x1_0 = 0.06255;
	parameter Modelica.SIunits.Length x2_0 = 0.06045;
	parameter Modelica.SIunits.Length x3_0 = 0.02395;
	parameter Modelica.SIunits.Length x4_0 = 0.02325;

   QuadTank qt(x1(fixed=true),x1_0=x1_0,
    	             x2(fixed=true),x2_0=x2_0,
                     x3(fixed=true),x3_0=x3_0,
                     x4(fixed=true),x4_0=x4_0,
                     a1(free=true,initialGuess = 0.03e-4,nominal=0.03e-4,min=0,max=0.1e-4),
                     a2(free=true,initialGuess = 0.03e-4,nominal=0.03e-4,min=0,max=0.1e-4));

    PRBS1 prbs1;
    PRBS2 prbs2;	
equation
    connect(prbs1.y,qt.u1);
    connect(prbs2.y,qt.u2);
end QuadTank_Sens;


end QuadTankPack;
