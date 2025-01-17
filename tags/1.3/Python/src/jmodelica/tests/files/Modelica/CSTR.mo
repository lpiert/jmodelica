package CSTR

model CSTR "A CSTR"
 
  parameter Modelica.SIunits.VolumeFlowRate F0=100/1000/60 "Inflow";
  parameter Modelica.SIunits.Concentration c0=1000 "Concentration of inflow"; 
  Modelica.Blocks.Interfaces.RealInput Tc "Cooling temperature"; 
  parameter Modelica.SIunits.VolumeFlowRate F=100/1000/60 "Outflow"; 
  parameter Modelica.SIunits.Temp_K T0 = 350;
  parameter Modelica.SIunits.Length r = 0.219;
  parameter Real k0 = 7.2e10/60;
  parameter Real EdivR = 8750;
  parameter Real U = 915.6;
  parameter Real rho = 1000;
  parameter Real Cp = 0.239*1000;
  parameter Real dH = -5e4;
  parameter Modelica.SIunits.Volume V = 100 "Reactor Volume";
  parameter Modelica.SIunits.Concentration c_init = 1000;
  parameter Modelica.SIunits.Temp_K T_init = 350;
  Real c(start=c_init,fixed=true,nominal=c0);
  Real T(start=T_init,fixed=true,nominal=T0);
equation 
  der(c) = F0*(c0-c)/V-k0*c*exp(-EdivR/T);
  der(T) = F0*(T0-T)/V-dH/(rho*Cp)*k0*c*exp(-EdivR/T)+2*U/(r*rho*Cp)*(Tc-T);
end CSTR;

model CSTR_Init
  extends CSTR(c(fixed=false),T(fixed=false));
initial equation
  der(c) = 0;
  der(T) = 0;
end CSTR_Init;

model CSTR_Init_Optimization

  CSTR cstr "CSTR component";
  input Real Tc_ref "Target input value";
  parameter Real Tc_0 = 300 "Initial input value";
  Real Tc(start=Tc_0,fixed=true) "Filtered input";
  Real u = Tc;
  parameter Real a_filt = 1/20 "Filter coefficient";
  Real cost(start=0,fixed=true);

  parameter Real c_ref = 500;
  parameter Real T_ref = 320;
  parameter Real q_c = 1;
  parameter Real q_T = 1;
  parameter Real q_Tc = 1;	

equation
  1/a_filt*der(Tc) = -Tc + Tc_ref;
  cstr.Tc = Tc; 
  der(cost) = q_c*(c_ref-cstr.c)^2 + q_T*(T_ref-cstr.T)^2 + 
                  q_Tc*(Tc_ref-cstr.Tc)^2;

end CSTR_Init_Optimization;

optimization CSTR_Opt(objective=(cost(finalTime)),
                      startTime=0.0,
                      finalTime=150)
 
  input Real u(start = 350,initialGuess=350)=cstr.Tc; 
  CSTR cstr(c(initialGuess=300),T(initialGuess=300),Tc(initialGuess=350));

  Real cost(start=0,fixed=true,initialGuess=500);
  parameter Real c_ref = 500;
  parameter Real T_ref = 320;
  parameter Real Tc_ref = 300;
  parameter Real q_c = 1;
  parameter Real q_T = 1;
  parameter Real q_Tc = 1;	
equation
  der(cost) = q_c*(c_ref-cstr.c)^2 + q_T*(T_ref-cstr.T)^2 + 
                  q_Tc*(Tc_ref-cstr.Tc)^2;
constraint
  cstr.T<=350;
  u>=230;
  u<=370;
end CSTR_Opt;

optimization CSTR_Opt_MPC(objective=(cost(finalTime)),
                      startTime=0.0,
                      finalTime=50)
 
  input Real u(start = 350,initialGuess=350)=cstr.Tc; 
  CSTR cstr(c(initialGuess=300),T(initialGuess=300),Tc(initialGuess=350));

  Real cost(start=0,fixed=true,initialGuess=500);
  parameter Real c_ref = 500;
  parameter Real T_ref = 320;
  parameter Real Tc_ref = 300;
  parameter Real q_c = 1;
  parameter Real q_T = 1;
  parameter Real q_Tc = 1;	
equation
  der(cost) = q_c*(c_ref-cstr.c)^2 + q_T*(T_ref-cstr.T)^2 + 
                  q_Tc*(Tc_ref-cstr.Tc)^2 + 
                  1000*(noEvent(if cstr.T <= 345 then 0 else (cstr.T-345)^4));
constraint
  cstr.T<=350;
  u>=230;
  u<=370;
end CSTR_Opt_MPC;


end CSTR;