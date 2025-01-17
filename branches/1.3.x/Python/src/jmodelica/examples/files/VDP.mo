package VDP_pack

  model VDP
    // State start values
    parameter Real x1_0 = 0;
    parameter Real x2_0 = 1;

    // The states
    Real x1(start = x1_0);
    Real x2(start = x2_0);

    // The control signal
    input Real u;

  equation
    der(x1) = (1 - x2^2) * x1 - x2 + u;
    der(x2) = x1;
  end VDP;

  optimization VDP_Opt (objective = cost(finalTime),
                         startTime = 0,
                         finalTime = 20)

    parameter Real p1 = 2;             

    extends VDP(x1(fixed=true),x2(fixed=true));

    Real cost(start=0,fixed=true);

  equation
    der(cost) = exp(p1) * (x1^2 + x2^2 + u^2);
  constraint 
     u<=0.75;
  end VDP_Opt;

  optimization VDP_Opt_Min_Time (objective = finalTime,
                         startTime = 0,
                         finalTime(free=true,min=0.2,initialGuess=1)) 

    extends VDP(x1(fixed=true),x2(fixed=true),u(min=-1,max=1));

  constraint
    // terminal constraints
    x1(finalTime)=0;
    x2(finalTime)=0;
  end VDP_Opt_Min_Time;

end VDP_pack;
