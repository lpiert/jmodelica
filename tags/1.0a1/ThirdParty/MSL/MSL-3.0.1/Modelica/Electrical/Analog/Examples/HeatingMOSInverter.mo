within Modelica.Electrical.Analog.Examples;
model HeatingMOSInverter "Heating MOS Inverter"
  extends Modelica.Icons.Example;
  Modelica.Electrical.Analog.Basic.Ground G 
  annotation (Placement(transformation(extent={{-80,-40},{-60,-20}}, rotation=0)));
  Modelica.Electrical.Analog.Sources.SineVoltage Sin(V=5) 
  annotation (Placement(transformation(
        origin={-70,0},
        extent={{-10,-10},{10,10}},
        rotation=270)));

annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={Text(
          extent={{-100,100},{-6,72}},
          textString="Heating MOS Inverter",
          lineColor={0,0,255})}),   Documentation(info="<HTML>
<P>
The heating MOS inverter shows a heat flow always if a transistor is leading.
</P>
<P>
Simulate until T=5 s.
</P>
<P>
Plot in separate windows:<br> <br>
Sin.p.v  and  Capacitor1.p.v <br>
HeatCapacitor1.port.T and H_PMOS.heatPort.T and H_NMOS.heatPort.T<br>
H_PMOS.heatPort.Q_flow and H_NMOS.heatPort.Q_flow<br>
</P>
 
</HTML>
", revisions="<html>
<p><b>Release Notes:</b></p>
<ul>
<li><i>Mai 6, 2004   </i>
       by Christoph Clauss<br> realized<br>
       </li>
</ul>
</html>"));
  Modelica.Electrical.Analog.Basic.Capacitor Capacitor1(C=0.00001) 
  annotation (Placement(transformation(
        origin={30,10},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor HeatCapacitor1(C=0.01) 
  annotation (Placement(transformation(
        origin={70,-60},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor TC1(G=0.01) 
  annotation (Placement(transformation(extent={{0,-50},{20,-30}}, rotation=0)));
  Semiconductors.HeatingPMOS H_PMOS 
  annotation (Placement(transformation(extent={{-40,40},{-20,60}}, rotation=0)));
  Semiconductors.HeatingNMOS H_NMOS 
  annotation (Placement(transformation(extent={{-40,0},{-20,20}}, rotation=0)));
  Modelica.Electrical.Analog.Sources.RampVoltage V(V=5, duration=1.e-2) 
  annotation (Placement(transformation(
        origin={50,50},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor TC2(G=0.01) 
  annotation (Placement(transformation(extent={{0,-90},{20,-70}}, rotation=0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature FixedTemperature1(T=
        300) 
           annotation (Placement(transformation(
        origin={90,-30},
        extent={{-10,-10},{10,10}},
        rotation=180)));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor TC3(G=0.01) 
  annotation (Placement(transformation(extent={{50,-40},{70,-20}}, rotation=0)));
equation
  connect(Sin.n, G.p) 
  annotation (Line(points={{-70,-10},{-70,-20}}, color={0,0,255}));
  connect(Capacitor1.n, G.p) 
  annotation (Line(points={{30,0},{30,-20},{-70,-20}}, color={0,0,255}));
annotation (Documentation(info="<HTML>
<P>
The heating MOS inverter shows a heat flow always if a transistor is leading.
</P>
<P>
Simulate until T=5 s.
</P>
<P>
Plot in separate windows:<br> <br>
Sin.p.v  and  Capacitor1.p.v <br>
HeatCapacitor1.port.T and H_PMOS.heatPort.T and H_NMOS.heatPort.T<br>
H_PMOS.heatPort.Q_flow and H_NMOS.heatPort.Q_flow<br>
</P>
<p><b>Release Notes:</b></p>
<ul>
<li><i>Mai 6, 2004   </i>
       by Christoph Clauss<br> realized<br>
       </li>
</ul>
</HTML>
"),
  experiment(
     StopTime=5));
  connect(H_NMOS.G, H_PMOS.G) 
  annotation (Line(points={{-40,5},{-40,45}}, color={0,0,255}));

  connect(H_NMOS.G, Sin.p) 
  annotation (Line(points={{-40,5},{-40,10},{-70,10}}, color={0,0,255}));
  connect(H_PMOS.S, H_NMOS.D) 
  annotation (Line(points={{-20,45},{-20,15}}, color={0,0,255}));
  connect(H_NMOS.D, Capacitor1.p) 
  annotation (Line(points={{-20,15},{-20,20},{30,20}}, color={0,0,255}));
  connect(H_NMOS.B, H_NMOS.S) 
  annotation (Line(points={{-20,10},{-20,5}}, color={0,0,255}));
  connect(H_NMOS.S, G.p) 
  annotation (Line(points={{-20,5},{-20,-20},{-70,-20}}, color={0,0,255}));
  connect(H_PMOS.B, H_PMOS.D) 
  annotation (Line(points={{-20,50},{-20,55}}, color={0,0,255}));
  connect(V.p, H_PMOS.D) 
  annotation (Line(points={{50,60},{-20,60},{-20,55}}, color={0,0,255}));
  connect(V.n, G.p) 
  annotation (Line(points={{50,40},{50,-20},{-70,-20}}, color={0,0,255}));
  connect(TC1.port_b, HeatCapacitor1.port) 
                                         annotation (Line(points={{20,-40},{40,
          -40},{40,-60},{60,-60}}, color={191,0,0}));
  connect(TC2.port_b, HeatCapacitor1.port) 
                                         annotation (Line(points={{20,-80},{40,
          -80},{40,-60},{60,-60}}, color={191,0,0}));
  connect(TC1.port_a, H_PMOS.heatPort) 
                                     annotation (Line(points={{0,-40},{-10,-40},
          {-10,40},{-30,40}}, color={191,0,0}));
  connect(TC2.port_a, H_NMOS.heatPort) 
  annotation (Line(points={{0,-80},{-30,-80},{-30,0}}, color={191,0,0}));
  connect(TC3.port_b, FixedTemperature1.port) 
                                            annotation (Line(points={{70,-30},{
          80,-30}},                   color={191,0,0}));
  connect(TC3.port_a, HeatCapacitor1.port) 
                                         annotation (Line(points={{50,-30},{40,
          -30},{40,-60},{60,-60}}, color={191,0,0}));
end HeatingMOSInverter;
