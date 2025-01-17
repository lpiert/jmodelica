within Modelica.Blocks;
package Interfaces
  "Library of connectors and partial models for input/output blocks"
  import Modelica.SIunits;
  extends Modelica.Icons.InterfacesPackage;

  connector RealInput = input Real "'input Real' as connector" annotation (
    defaultComponentName="u",
    Icon(graphics={
      Polygon(
        lineColor={0,0,127},
        fillColor={0,0,127},
        fillPattern=FillPattern.Solid,
        points={{-100.0,100.0},{100.0,0.0},{-100.0,-100.0}})},
      coordinateSystem(extent={{-100.0,-100.0},{100.0,100.0}},
        preserveAspectRatio=true,
        initialScale=0.2)),
    Diagram(
      coordinateSystem(preserveAspectRatio=true,
        initialScale=0.2,
        extent={{-100.0,-100.0},{100.0,100.0}}),
        graphics={
      Polygon(
        lineColor={0,0,127},
        fillColor={0,0,127},
        fillPattern=FillPattern.Solid,
        points={{0.0,50.0},{100.0,0.0},{0.0,-50.0},{0.0,50.0}}),
      Text(
        lineColor={0,0,127},
        extent={{-10.0,60.0},{-10.0,85.0}},
        textString="%name")}),
    Documentation(info="<html>
<p>
Connector with one input signal of type Real.
</p>
</html>"));

  connector RealOutput = output Real "'output Real' as connector" annotation (
    defaultComponentName="y",
    Icon(
      coordinateSystem(preserveAspectRatio=true,
        extent={{-100.0,-100.0},{100.0,100.0}},
        initialScale=0.1),
        graphics={
      Polygon(
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid,
        points={{-100.0,100.0},{100.0,0.0},{-100.0,-100.0}})}),
    Diagram(
      coordinateSystem(preserveAspectRatio=true,
        extent={{-100.0,-100.0},{100.0,100.0}},
        initialScale=0.1),
        graphics={
      Polygon(
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid,
        points={{-100.0,50.0},{0.0,0.0},{-100.0,-50.0}}),
      Text(
        lineColor={0,0,127},
        extent={{30.0,60.0},{30.0,110.0}},
        textString="%name")}),
    Documentation(info="<html>
<p>
Connector with one output signal of type Real.
</p>
</html>"));

  connector BooleanInput = input Boolean "'input Boolean' as connector"
    annotation (
    defaultComponentName="u",
    Icon(graphics={Polygon(
          points={{-100,100},{100,0},{-100,-100},{-100,100}},
          lineColor={255,0,255},
          fillColor={255,0,255},
          fillPattern=FillPattern.Solid)}, coordinateSystem(
        extent={{-100,-100},{100,100}},
        preserveAspectRatio=true,
        initialScale=0.2)),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        initialScale=0.2,
        extent={{-100,-100},{100,100}}), graphics={Polygon(
          points={{0,50},{100,0},{0,-50},{0,50}},
          lineColor={255,0,255},
          fillColor={255,0,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-10,85},{-10,60}},
          lineColor={255,0,255},
          textString="%name")}),
    Documentation(info="<html>
<p>
Connector with one input signal of type Boolean.
</p>
</html>"));

  connector BooleanOutput = output Boolean "'output Boolean' as connector"
    annotation (
    defaultComponentName="y",
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={Polygon(
          points={{-100,100},{100,0},{-100,-100},{-100,100}},
          lineColor={255,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={Polygon(
          points={{-100,50},{0,0},{-100,-50},{-100,50}},
          lineColor={255,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{30,110},{30,60}},
          lineColor={255,0,255},
          textString="%name")}),
    Documentation(info="<html>
<p>
Connector with one output signal of type Boolean.
</p>
</html>"));

  connector IntegerInput = input Integer "'input Integer' as connector"
    annotation (
    defaultComponentName="u",
    Icon(graphics={Polygon(
          points={{-100,100},{100,0},{-100,-100},{-100,100}},
          lineColor={255,127,0},
          fillColor={255,127,0},
          fillPattern=FillPattern.Solid)}, coordinateSystem(
        extent={{-100,-100},{100,100}},
        preserveAspectRatio=true,
        initialScale=0.2)),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        initialScale=0.2,
        extent={{-100,-100},{100,100}}), graphics={Polygon(
          points={{0,50},{100,0},{0,-50},{0,50}},
          lineColor={255,127,0},
          fillColor={255,127,0},
          fillPattern=FillPattern.Solid), Text(
          extent={{-10,85},{-10,60}},
          lineColor={255,127,0},
          textString="%name")}),
    Documentation(info="<html>
<p>
Connector with one input signal of type Integer.
</p>
</html>"));

  connector IntegerOutput = output Integer "'output Integer' as connector"
    annotation (
    defaultComponentName="y",
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={Polygon(
          points={{-100,100},{100,0},{-100,-100},{-100,100}},
          lineColor={255,127,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={Polygon(
          points={{-100,50},{0,0},{-100,-50},{-100,50}},
          lineColor={255,127,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{30,110},{30,60}},
          lineColor={255,127,0},
          textString="%name")}),
    Documentation(info="<html>
<p>
Connector with one output signal of type Integer.
</p>
</html>"));
  connector RealVectorInput = input Real
    "Real input connector used for vector of connectors" annotation (
    defaultComponentName="u",
    Icon(graphics={Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid)}, coordinateSystem(
        extent={{-100,-100},{100,100}},
        preserveAspectRatio=true,
        initialScale=0.2)),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        initialScale=0.2,
        extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{-10,85},{-10,60}},
          lineColor={0,0,127},
          textString="%name"), Ellipse(
          extent={{-50,50},{50,-50}},
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
Real input connector that is used for a vector of connectors,
for example <a href=\"modelica://Modelica.Blocks.Interfaces.PartialRealMISO\">PartialRealMISO</a>,
and has therefore a different icon as RealInput connector.
</p>
</html>"));

  connector IntegerVectorInput = input Integer
    "Integer input connector used for vector of connectors" annotation (
    defaultComponentName="u",
    Icon(graphics={Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={255,128,0},
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid)}, coordinateSystem(
        extent={{-100,-100},{100,100}},
        preserveAspectRatio=true,
        initialScale=0.2)),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        initialScale=0.2,
        extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{-10,85},{-10,60}},
          lineColor={255,128,0},
          textString="%name"), Ellipse(
          extent={{-50,50},{50,-50}},
          lineColor={255,128,0},
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>

<p>
Integer input connector that is used for a vector of connectors,
for example <a href=\"modelica://Modelica.Blocks.Interfaces.PartialIntegerMISO\">PartialIntegerMISO</a>,
and has therefore a different icon as IntegerInput connector.
</p>

</html>"));
  connector BooleanVectorInput = input Boolean
    "Boolean input connector used for vector of connectors" annotation (
    defaultComponentName="u",
    Icon(graphics={Ellipse(
          extent={{-100,-100},{100,100}},
          lineColor={255,0,255},
          fillColor={255,0,255},
          fillPattern=FillPattern.Solid)}, coordinateSystem(
        extent={{-100,-100},{100,100}},
        preserveAspectRatio=false,
        initialScale=0.2)),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        initialScale=0.2,
        extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{-10,85},{-10,60}},
          lineColor={255,0,255},
          textString="%name"), Ellipse(
          extent={{-50,50},{50,-50}},
          lineColor={255,0,255},
          fillColor={255,0,255},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
Boolean input connector that is used for a vector of connectors,
for example <a href=\"modelica://Modelica.Blocks.Interfaces.PartialBooleanMISO\">PartialBooleanMISO</a>,
and has therefore a different icon as BooleanInput connector.
</p>
</html>"));

  partial block SO "Single Output continuous control block"
    extends Modelica.Blocks.Icons.Block;

    RealOutput y "Connector of Real output signal" annotation (Placement(
          transformation(extent={{100,-10},{120,10}}, rotation=0)));
    annotation (Documentation(info="<html>
<p>
Block has one continuous Real output signal.
</p>
</html>"));

  end SO;

  partial block MO "Multiple Output continuous control block"
    extends Modelica.Blocks.Icons.Block;

    parameter Integer nout(min=1) = 1 "Number of outputs";
    RealOutput y[nout] "Connector of Real output signals" annotation (Placement(
          transformation(extent={{100,-10},{120,10}}, rotation=0)));
    annotation (Documentation(info="<html>
<p>
Block has one continuous Real output signal vector.
</p>
</html>"));

  end MO;

  partial block SISO "Single Input Single Output continuous control block"
    extends Modelica.Blocks.Icons.Block;

    RealInput u "Connector of Real input signal" annotation (Placement(
          transformation(extent={{-140,-20},{-100,20}}, rotation=0)));
    RealOutput y "Connector of Real output signal" annotation (Placement(
          transformation(extent={{100,-10},{120,10}}, rotation=0)));
    annotation (Documentation(info="<html>
<p>
Block has one continuous Real input and one continuous Real output signal.
</p>
</html>"));
  end SISO;

  partial block SI2SO
    "2 Single Input / 1 Single Output continuous control block"
    extends Modelica.Blocks.Icons.Block;

    RealInput u1 "Connector of Real input signal 1" annotation (Placement(
          transformation(extent={{-140,40},{-100,80}}, rotation=0)));
    RealInput u2 "Connector of Real input signal 2" annotation (Placement(
          transformation(extent={{-140,-80},{-100,-40}}, rotation=0)));
    RealOutput y "Connector of Real output signal" annotation (Placement(
          transformation(extent={{100,-10},{120,10}}, rotation=0)));

    annotation (Documentation(info="<html>
<p>
Block has two continuous Real input signals u1 and u2 and one
continuous Real output signal y.
</p>
</html>"));

  end SI2SO;

  partial block SIMO "Single Input Multiple Output continuous control block"
    extends Modelica.Blocks.Icons.Block;
    parameter Integer nout=1 "Number of outputs";
    RealInput u "Connector of Real input signal" annotation (Placement(
          transformation(extent={{-140,-20},{-100,20}}, rotation=0)));
    RealOutput y[nout] "Connector of Real output signals" annotation (Placement(
          transformation(extent={{100,-10},{120,10}}, rotation=0)));

    annotation (Documentation(info="<HTML>
<p> Block has one continuous Real input signal and a
    vector of continuous Real output signals.</p>

</html>"));
  end SIMO;

  partial block MISO "Multiple Input Single Output continuous control block"

    extends Modelica.Blocks.Icons.Block;
    parameter Integer nin=1 "Number of inputs";
    RealInput u[nin] "Connector of Real input signals" annotation (Placement(
          transformation(extent={{-140,-20},{-100,20}}, rotation=0)));
    RealOutput y "Connector of Real output signal" annotation (Placement(
          transformation(extent={{100,-10},{120,10}}, rotation=0)));
    annotation (Documentation(info="<HTML>
<p>
Block has a vector of continuous Real input signals and
one continuous Real output signal.
</p>
</html>"));
  end MISO;

  partial block PartialRealMISO
    "Partial block with a RealVectorInput and a RealOutput signal"

    parameter Integer significantDigits(min=1) = 3
      "Number of significant digits to be shown in dynamic diagram layer for y"
      annotation (Dialog(tab="Advanced"));
    parameter Integer nu(min=0) = 0 "Number of input connections"
      annotation (Dialog(connectorSizing=true), HideResult=true);
    Modelica.Blocks.Interfaces.RealVectorInput u[nu]
      annotation (Placement(transformation(extent={{-120,70},{-80,-70}})));
    Modelica.Blocks.Interfaces.RealOutput y
      annotation (Placement(transformation(extent={{100,-17},{134,17}})));
    annotation (Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          initialScale=0.06), graphics={
          Text(
            extent={{110,-50},{300,-70}},
            lineColor={0,0,0},
            textString=DynamicSelect(" ", String(y, significantDigits=
                significantDigits))),
          Text(
            extent={{-250,170},{250,110}},
            textString="%name",
            lineColor={0,0,255}),
          Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={255,137,0},
            lineThickness=5.0,
            fillColor={255,255,255},
            borderPattern=BorderPattern.Raised,
            fillPattern=FillPattern.Solid)}));
  end PartialRealMISO;

  partial block MIMO "Multiple Input Multiple Output continuous control block"

    extends Modelica.Blocks.Icons.Block;
    parameter Integer nin=1 "Number of inputs";
    parameter Integer nout=1 "Number of outputs";
    RealInput u[nin] "Connector of Real input signals" annotation (Placement(
          transformation(extent={{-140,-20},{-100,20}}, rotation=0)));
    RealOutput y[nout] "Connector of Real output signals" annotation (Placement(
          transformation(extent={{100,-10},{120,10}}, rotation=0)));
    annotation (Documentation(info="<HTML>
<p>
Block has a continuous Real input and a continuous Real output signal vector.
The signal sizes of the input and output vector may be different.
</p>
</html>"));
  end MIMO;

  partial block MIMOs
    "Multiple Input Multiple Output continuous control block with same number of inputs and outputs"

    extends Modelica.Blocks.Icons.Block;
    parameter Integer n=1 "Number of inputs (= number of outputs)";
    RealInput u[n] "Connector of Real input signals" annotation (Placement(
          transformation(extent={{-140,-20},{-100,20}}, rotation=0)));
    RealOutput y[n] "Connector of Real output signals" annotation (Placement(
          transformation(extent={{100,-10},{120,10}}, rotation=0)));
    annotation (Documentation(info="<HTML>
<p>
Block has a continuous Real input and a continuous Real output signal vector
where the signal sizes of the input and output vector are identical.
</p>
</html>"));
  end MIMOs;

  partial block MI2MO
    "2 Multiple Input / Multiple Output continuous control block"
    extends Modelica.Blocks.Icons.Block;

    parameter Integer n=1 "Dimension of input and output vectors.";

    RealInput u1[n] "Connector 1 of Real input signals" annotation (Placement(
          transformation(extent={{-140,40},{-100,80}}, rotation=0)));
    RealInput u2[n] "Connector 2 of Real input signals" annotation (Placement(
          transformation(extent={{-140,-80},{-100,-40}}, rotation=0)));
    RealOutput y[n] "Connector of Real output signals" annotation (Placement(
          transformation(extent={{100,-10},{120,10}}, rotation=0)));
    annotation (Documentation(info="<html>
<p>
Block has two continuous Real input vectors u1 and u2 and one
continuous Real output vector y.
All vectors have the same number of elements.
</p>
</html>"));

  end MI2MO;

  partial block SignalSource "Base class for continuous signal source"
    extends SO;
    parameter Real offset=0 "Offset of output signal y";
    parameter SIunits.Time startTime=0 "Output y = offset for time < startTime";
    annotation (Documentation(info="<html>
<p>
Basic block for Real sources of package Blocks.Sources.
This component has one continuous Real output signal y
and two parameters (offset, startTime) to shift the
generated signal.
</p>
</html>"));
  end SignalSource;

  partial block SVcontrol "Single-Variable continuous controller"
    extends Modelica.Blocks.Icons.Block;

    RealInput u_s "Connector of setpoint input signal" annotation (Placement(
          transformation(extent={{-140,-20},{-100,20}}, rotation=0)));
    RealInput u_m "Connector of measurement input signal" annotation (Placement(
          transformation(
          origin={0,-120},
          extent={{20,-20},{-20,20}},
          rotation=270)));
    RealOutput y "Connector of actuator output signal" annotation (Placement(
          transformation(extent={{100,-10},{120,10}}, rotation=0)));
    annotation (Diagram(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics={Text(
              extent={{-102,34},{-142,24}},
              textString="(setpoint)",
              lineColor={0,0,255}),Text(
              extent={{100,24},{140,14}},
              textString="(actuator)",
              lineColor={0,0,255}),Text(
              extent={{-83,-112},{-33,-102}},
              textString=" (measurement)",
              lineColor={0,0,255})}), Documentation(info="<html>
<p>
Block has two continuous Real input signals and one
continuous Real output signal. The block is designed
to be used as base class for a corresponding controller.
</p>
</html>"));
  end SVcontrol;

  partial block MVcontrol "Multi-Variable continuous controller"
    extends Modelica.Blocks.Icons.Block;

    parameter Integer nu_s=1 "Number of setpoint inputs";
    parameter Integer nu_m=1 "Number of measurement inputs";
    parameter Integer ny=1 "Number of actuator outputs";
    RealInput u_s[nu_s] "Connector of setpoint input signals" annotation (
        Placement(transformation(extent={{-140,-20},{-100,20}}, rotation=0)));
    RealInput u_m[nu_m] "Connector of measurement input signals" annotation (
        Placement(transformation(
          origin={0,-120},
          extent={{20,-20},{-20,20}},
          rotation=270)));
    RealOutput y[ny] "Connector of actuator output signals" annotation (
        Placement(transformation(extent={{100,-10},{120,10}}, rotation=0)));
    annotation (Diagram(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics={Text(
              extent={{-100,36},{-140,26}},
              textString="(setpoint)",
              lineColor={0,0,255}),Text(
              extent={{102,24},{142,14}},
              textString="(actuator)",
              lineColor={0,0,255}),Text(
              extent={{-75,-108},{-25,-98}},
              textString=" (measurement)",
              lineColor={0,0,255})}), Documentation(info="<html>
<p>
Block has two continuous Real input signal vectors and one
continuous Real output signal vector. The block is designed
to be used as base class for a corresponding controller.
</p>
</html>"));
  end MVcontrol;

  partial block DiscreteBlock "Base class of discrete control blocks"
    extends Modelica.Blocks.Icons.DiscreteBlock;

    parameter SI.Time samplePeriod(min=100*Modelica.Constants.eps, start=0.1)
      "Sample period of component";
    parameter SI.Time startTime=0 "First sample time instant";
  protected
    output Boolean sampleTrigger "True, if sample time instant";
    output Boolean firstTrigger "Rising edge signals first sample instant";
  equation
    sampleTrigger = sample(startTime, samplePeriod);
    when sampleTrigger then
      firstTrigger = time <= startTime + samplePeriod/2;
    end when;
    annotation (Documentation(info="<html>
<p>
Basic definitions of a discrete block of library
Blocks.Discrete.
</p>
</html>"));
  end DiscreteBlock;

  partial block DiscreteSISO
    "Single Input Single Output discrete control block"

    extends DiscreteBlock;

    Modelica.Blocks.Interfaces.RealInput u "Continuous input signal"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}},
            rotation=0)));
    Modelica.Blocks.Interfaces.RealOutput y "Continuous output signal"
      annotation (Placement(transformation(extent={{100,-10},{120,10}},
            rotation=0)));
    annotation (Documentation(info="<html>
<p>
Block has one continuous input and one continuous output signal
which are sampled due to the defined <b>samplePeriod</b> parameter.
</p>
</html>"));
  end DiscreteSISO;

  partial block DiscreteMIMO
    "Multiple Input Multiple Output discrete control block"

    extends DiscreteBlock;
    parameter Integer nin=1 "Number of inputs";
    parameter Integer nout=1 "Number of outputs";

    Modelica.Blocks.Interfaces.RealInput u[nin] "Continuous input signals"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}},
            rotation=0)));
    Modelica.Blocks.Interfaces.RealOutput y[nout] "Continuous output signals"
      annotation (Placement(transformation(extent={{100,-10},{120,10}},
            rotation=0)));

    annotation (Documentation(info="<html>
<p>
Block has a continuous input and a continuous output signal vector
which are sampled due to the defined <b>samplePeriod</b> parameter.
</p>
</html>"));
  end DiscreteMIMO;

  partial block DiscreteMIMOs
    "Multiple Input Multiple Output discrete control block"
    parameter Integer n=1 "Number of inputs (= number of outputs)";
    extends DiscreteBlock;

    Modelica.Blocks.Interfaces.RealInput u[n] "Continuous input signals"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}},
            rotation=0)));
    Modelica.Blocks.Interfaces.RealOutput y[n] "Continuous output signals"
      annotation (Placement(transformation(extent={{100,-10},{120,10}},
            rotation=0)));

    annotation (Documentation(info="<html>
<p>
Block has a continuous input and a continuous output signal vector
where the signal sizes of the input and output vector are identical.
These signals are sampled due to the defined <b>samplePeriod</b> parameter.
</p>
</html>"));

  end DiscreteMIMOs;

  partial block SVdiscrete "Discrete Single-Variable controller"
    extends DiscreteBlock;

    Discrete.Sampler sampler_s(final samplePeriod=samplePeriod, final startTime=
         startTime) annotation (Placement(transformation(extent={{-100,-10},{-80,
              10}}, rotation=0)));
    Discrete.Sampler sampler_m(final samplePeriod=samplePeriod, final startTime=
         startTime) annotation (Placement(transformation(
          origin={0,-90},
          extent={{-10,-10},{10,10}},
          rotation=90)));
    Modelica.Blocks.Interfaces.RealInput u_s
      "Continuous scalar setpoint input signal" annotation (Placement(
          transformation(extent={{-140,-20},{-100,20}}, rotation=0)));
    Modelica.Blocks.Interfaces.RealInput u_m
      "Continuous scalar measurement input signal" annotation (Placement(
          transformation(
          origin={0,-120},
          extent={{20,-20},{-20,20}},
          rotation=270)));
    Modelica.Blocks.Interfaces.RealOutput y
      "Continuous scalar actuator output signal" annotation (Placement(
          transformation(extent={{100,-10},{120,10}}, rotation=0)));
  equation
    connect(u_s, sampler_s.u) annotation (Line(points={{-120,0},{-102,0}}));
    connect(u_m, sampler_m.u)
      annotation (Line(points={{0,-120},{0,-111},{0,-102}}));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics={Text(
              extent={{-100,34},{-140,24}},
              lineColor={0,0,0},
              textString="(setpoint)"),Text(
              extent={{100,22},{130,14}},
              lineColor={0,0,0},
              textString="(actuator)"),Text(
              extent={{-70,-112},{-20,-102}},
              lineColor={0,0,0},
              textString=" (measurement)")}), Documentation(info="<html>
<p>
Block has two continuous Real input signals and one
continuous Real output signal
that are sampled due to the defined <b>samplePeriod</b> parameter.
The block is designed
to be used as base class for a corresponding controller.
</p>
</html>"));
  end SVdiscrete;

  partial block MVdiscrete "Discrete Multi-Variable controller"
    extends DiscreteBlock;
    parameter Integer nu_s=1 "Number of setpoint inputs";
    parameter Integer nu_m=1 "Number of measurement inputs";
    parameter Integer ny=1 "Number of actuator outputs";
    Discrete.Sampler sampler_s[nu_s](each final samplePeriod=samplePeriod,
        each final startTime=startTime) annotation (Placement(transformation(
            extent={{-90,-10},{-70,10}}, rotation=0)));
    Discrete.Sampler sampler_m[nu_m](each final samplePeriod=samplePeriod,
        each final startTime=startTime) annotation (Placement(transformation(
          origin={0,-80},
          extent={{-10,-10},{10,10}},
          rotation=90)));
    Modelica.Blocks.Interfaces.RealInput u_s[nu_s]
      "Continuous setpoint input signals" annotation (Placement(transformation(
            extent={{-140,-20},{-100,20}}, rotation=0)));
    Modelica.Blocks.Interfaces.RealInput u_m[nu_m]
      "Continuous measurement input signals" annotation (Placement(
          transformation(
          origin={0,-120},
          extent={{20,-20},{-20,20}},
          rotation=270)));
    Modelica.Blocks.Interfaces.RealOutput y[ny]
      "Continuous actuator output signals" annotation (Placement(transformation(
            extent={{100,-10},{120,10}}, rotation=0)));
  equation
    connect(u_s, sampler_s.u) annotation (Line(points={{-120,0},{-92,0}}));
    connect(u_m, sampler_m.u)
      annotation (Line(points={{0,-120},{0,-106},{0,-92}}));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics={Text(
              extent={{-100,-10},{-80,-30}},
              textString="u_s",
              lineColor={0,0,255}),Text(
              extent={{-98,34},{-138,24}},
              lineColor={0,0,0},
              textString="(setpoint)"),Text(
              extent={{98,24},{138,14}},
              lineColor={0,0,0},
              textString="(actuator)"),Text(
              extent={{-62,-110},{-12,-100}},
              lineColor={0,0,0},
              textString=" (measurement)")}), Documentation(info="<html>
<p>
Block has two continuous Real input signal vectors and one
continuous Real output signal vector. The vector signals
are sampled due to the defined <b>samplePeriod</b> parameter.
The block is designed
to be used as base class for a corresponding controller.
</p>
</html>"));
  end MVdiscrete;

  partial block BooleanSISO
    "Single Input Single Output control block with signals of type Boolean"

    extends Modelica.Blocks.Icons.BooleanBlock;

  public
    BooleanInput u "Connector of Boolean input signal" annotation (Placement(
          transformation(extent={{-140,-20},{-100,20}}, rotation=0)));
    BooleanOutput y "Connector of Boolean output signal" annotation (Placement(
          transformation(extent={{100,-10},{120,10}}, rotation=0)));

    annotation (Documentation(info="<html>
<p>
Block has one continuous Boolean input and one continuous Boolean output signal.
</p>
</html>"));
  end BooleanSISO;

  partial block BooleanMIMOs
    "Multiple Input Multiple Output continuous control block with same number of inputs and outputs of Boolean type"

    extends Modelica.Blocks.Icons.BooleanBlock;
    parameter Integer n=1 "Number of inputs (= number of outputs)";
    BooleanInput u[n] "Connector of Boolean input signals" annotation (
        Placement(transformation(extent={{-140,-20},{-100,20}}, rotation=0)));
    BooleanOutput y[n] "Connector of Boolean output signals" annotation (
        Placement(transformation(extent={{100,-10},{120,10}}, rotation=0)));
    annotation (Documentation(info="<HTML>
<p>
Block has a continuous Boolean input and a continuous Boolean output signal vector
where the signal sizes of the input and output vector are identical.
</p>
</html>"));
  end BooleanMIMOs;

  partial block MI2BooleanMOs
    "2 Multiple Input / Boolean Multiple Output block with same signal lengths"

    extends Modelica.Blocks.Icons.BooleanBlock;
    parameter Integer n=1 "Dimension of input and output vectors.";
    RealInput u1[n] "Connector 1 of Boolean input signals" annotation (
        Placement(transformation(extent={{-140,40},{-100,80}}, rotation=0)));
    RealInput u2[n] "Connector 2 of Boolean input signals" annotation (
        Placement(transformation(extent={{-140,-80},{-100,-40}}, rotation=0)));
    BooleanOutput y[n] "Connector of Boolean output signals" annotation (
        Placement(transformation(extent={{100,-10},{120,10}}, rotation=0)));
    annotation (Documentation(info="<html>
<p>Block has two Boolean input vectors u1 and u2 and one Boolean output
vector y. All vectors have the same number of elements.</p>
</html>"));
  end MI2BooleanMOs;

  partial block SI2BooleanSO "2 Single Input / Boolean Single Output block"

    extends Modelica.Blocks.Icons.BooleanBlock;
    BooleanInput u1 "Connector 1 of Boolean input signals" annotation (
        Placement(transformation(extent={{-140,40},{-100,80}}, rotation=0)));
    BooleanInput u2 "Connector 2 of Boolean input signals" annotation (
        Placement(transformation(extent={{-140,-80},{-100,-40}}, rotation=0)));
    BooleanOutput y "Connector of Boolean output signals" annotation (
        Placement(transformation(extent={{100,-10},{120,10}}, rotation=0)));
    annotation (Documentation(info="<html>
<p>
Block has two Boolean input signals u1 and u2 and one Boolean output signal y.
</p>
</html>"));

  end SI2BooleanSO;

  partial block BooleanSignalSource "Base class for Boolean signal sources"

    extends Modelica.Blocks.Icons.BooleanBlock;
    BooleanOutput y "Connector of Boolean output signal" annotation (Placement(
          transformation(extent={{100,-10},{120,10}}, rotation=0)));
    annotation (Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics={
          Line(points={{-80,68},{-80,-80}}, color={192,192,192}),
          Polygon(
            points={{-80,90},{-88,68},{-72,68},{-80,90}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Line(points={{-90,-70},{68,-70}}, color={192,192,192}),
          Polygon(
            points={{90,-70},{68,-62},{68,-78},{90,-70}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid)}), Documentation(info="<html>
<p>
Basic block for Boolean sources of package Blocks.Sources.
This component has one continuous Boolean output signal y.
</p>
</html>"));

  end BooleanSignalSource;

  partial block IntegerSO "Single Integer Output continuous control block"
    extends Modelica.Blocks.Icons.IntegerBlock;

    IntegerOutput y "Connector of Integer output signal" annotation (Placement(
          transformation(extent={{100,-10},{120,10}}, rotation=0)));
    annotation (Documentation(info="<html>
<p>
Block has one continuous Integer output signal.
</p>
</html>"));
  end IntegerSO;

  partial block IntegerMO "Multiple Integer Output continuous control block"
    extends Modelica.Blocks.Icons.IntegerBlock;

    parameter Integer nout(min=1) = 1 "Number of outputs";
    IntegerOutput y[nout] "Connector of Integer output signals" annotation (
        Placement(transformation(extent={{100,-10},{120,10}}, rotation=0)));
    annotation (Documentation(info="<html>
<p>
Block has one continuous Integer output signal vector.
</p>
</html>"));
  end IntegerMO;

  partial block IntegerSignalSource
    "Base class for continuous Integer signal source"
    extends IntegerSO;
    parameter Integer offset=0 "Offset of output signal y";
    parameter SI.Time startTime=0 "Output y = offset for time < startTime";
    annotation (Documentation(info="<html>
<p>
Basic block for Integer sources of package Blocks.Sources.
This component has one continuous Integer output signal y
and two parameters (offset, startTime) to shift the
generated signal.
</p>
</html>"));
  end IntegerSignalSource;

  partial block IntegerSIBooleanSO
    "Integer Input Boolean Output continuous control block"

    extends Modelica.Blocks.Icons.BooleanBlock;
    IntegerInput u "Connector of Integer input signal" annotation (Placement(
          transformation(extent={{-140,-20},{-100,20}}, rotation=0)));
    BooleanOutput y "Connector of Boolean output signal" annotation (Placement(
          transformation(extent={{100,-10},{120,10}}, rotation=0)));
    annotation (Documentation(info="<HTML>
<p>
Block has a continuous Integer input and a continuous Boolean output signal.
</p>
</html>"));
  end IntegerSIBooleanSO;

  partial block IntegerMIBooleanMOs
    "Multiple Integer Input Multiple Boolean Output continuous control block with same number of inputs and outputs"

    extends Modelica.Blocks.Icons.BooleanBlock;
    parameter Integer n=1 "Number of inputs (= number of outputs)";
    IntegerInput u[n] "Connector of Integer input signals" annotation (
        Placement(transformation(extent={{-140,-20},{-100,20}}, rotation=0)));
    BooleanOutput y[n] "Connector of Boolean output signals" annotation (
        Placement(transformation(extent={{100,-10},{120,10}}, rotation=0)));
    annotation (Documentation(info="<HTML>
<p>
Block has a continuous Integer input and a continuous Boolean output signal vector
where the signal sizes of the input and output vector are identical.
</p>
</html>"));
  end IntegerMIBooleanMOs;

  partial block PartialIntegerSISO
    "Partial block with a IntegerInput and an IntegerOutput signal"

    Modelica.Blocks.Interfaces.IntegerInput u "Integer input signal"
      annotation (Placement(transformation(extent={{-180,-40},{-100,40}})));
    Modelica.Blocks.Interfaces.IntegerOutput y "Integer output signal"
      annotation (Placement(transformation(extent={{100,-20},{140,20}})));
    annotation (Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          initialScale=0.06), graphics={
          Text(
            extent={{110,-50},{250,-70}},
            lineColor={0,0,0},
            textString=DynamicSelect(" ", String(
                  y,
                  minimumLength=1,
                  significantDigits=0))),
          Text(
            extent={{-250,170},{250,110}},
            textString="%name",
            lineColor={0,0,255}),
          Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            lineThickness=5.0,
            fillColor={255,213,170},
            fillPattern=FillPattern.Solid,
            borderPattern=BorderPattern.Raised)}));
  end PartialIntegerSISO;

  partial block PartialIntegerMISO
    "Partial block with an IntegerVectorInput and an IntegerOutput signal"

    parameter Integer nu(min=0) = 0 "Number of input connections"
      annotation (Dialog(connectorSizing=true), HideResult=true);
    Modelica.Blocks.Interfaces.IntegerVectorInput u[nu]
      "Vector of Integer input signals"
      annotation (Placement(transformation(extent={{-120,70},{-80,-70}})));
    Modelica.Blocks.Interfaces.IntegerOutput y "Integer output signal"
      annotation (Placement(transformation(extent={{100,-15},{130,15}})));
    annotation (Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          initialScale=0.06), graphics={
          Text(
            extent={{110,-50},{250,-70}},
            lineColor={0,0,0},
            textString=DynamicSelect(" ", String(
                  y,
                  minimumLength=1,
                  significantDigits=0))),
          Text(
            extent={{-250,170},{250,110}},
            textString="%name",
            lineColor={0,0,255}),
          Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={255,137,0},
            lineThickness=5.0,
            fillColor={255,213,170},
            borderPattern=BorderPattern.Raised,
            fillPattern=FillPattern.Solid)}));
  end PartialIntegerMISO;

  partial block partialBooleanSISO
    "Partial block with 1 input and 1 output Boolean signal"
    extends Modelica.Blocks.Icons.PartialBooleanBlock;
    Blocks.Interfaces.BooleanInput u "Connector of Boolean input signal"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}},
            rotation=0)));
    Blocks.Interfaces.BooleanOutput y "Connector of Boolean output signal"
      annotation (Placement(transformation(extent={{100,-10},{120,10}},
            rotation=0)));

    annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
              {100,100}}), graphics={Ellipse(
            extent={{-71,7},{-85,-7}},
            lineColor=DynamicSelect({235,235,235}, if u > 0.5 then {0,255,0}
                 else {235,235,235}),
            fillColor=DynamicSelect({235,235,235}, if u > 0.5 then {0,255,0}
                 else {235,235,235}),
            fillPattern=FillPattern.Solid), Ellipse(
            extent={{71,7},{85,-7}},
            lineColor=DynamicSelect({235,235,235}, if y > 0.5 then {0,255,0}
                 else {235,235,235}),
            fillColor=DynamicSelect({235,235,235}, if y > 0.5 then {0,255,0}
                 else {235,235,235}),
            fillPattern=FillPattern.Solid)}), Documentation(info="<html>
<p>
Block has one continuous Boolean input and one continuous Boolean output signal
with a 3D icon (e.g., used in Blocks.Logical library).
</p>
</html>"));

  end partialBooleanSISO;

  partial block partialBooleanSI2SO
    "Partial block with 2 input and 1 output Boolean signal"
    extends Modelica.Blocks.Icons.PartialBooleanBlock;
    Blocks.Interfaces.BooleanInput u1 "Connector of first Boolean input signal"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}},
            rotation=0)));
    Blocks.Interfaces.BooleanInput u2
      "Connector of second Boolean input signal" annotation (Placement(
          transformation(extent={{-140,-100},{-100,-60}}, rotation=0)));
    Blocks.Interfaces.BooleanOutput y "Connector of Boolean output signal"
      annotation (Placement(transformation(extent={{100,-10},{120,10}},
            rotation=0)));

    annotation (Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics={
          Ellipse(
            extent={{-71,7},{-85,-7}},
            lineColor=DynamicSelect({235,235,235}, if u1 > 0.5 then {0,255,0}
                 else {235,235,235}),
            fillColor=DynamicSelect({235,235,235}, if u1 > 0.5 then {0,255,0}
                 else {235,235,235}),
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{-71,-74},{-85,-88}},
            lineColor=DynamicSelect({235,235,235}, if u2 > 0.5 then {0,255,0}
                 else {235,235,235}),
            fillColor=DynamicSelect({235,235,235}, if u2 > 0.5 then {0,255,0}
                 else {235,235,235}),
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{71,7},{85,-7}},
            lineColor=DynamicSelect({235,235,235}, if y > 0.5 then {0,255,0}
                 else {235,235,235}),
            fillColor=DynamicSelect({235,235,235}, if y > 0.5 then {0,255,0}
                 else {235,235,235}),
            fillPattern=FillPattern.Solid)}), Documentation(info="<html>
<p>
Block has two continuous Boolean input and one continuous Boolean output signal
with a 3D icon (e.g., used in Blocks.Logical library).
</p>
</html>"));

  end partialBooleanSI2SO;

  partial block partialBooleanSI3SO
    "Partial block with 3 input and 1 output Boolean signal"
    extends Modelica.Blocks.Icons.PartialBooleanBlock;
    Blocks.Interfaces.BooleanInput u1 "Connector of first Boolean input signal"
      annotation (Placement(transformation(extent={{-140,60},{-100,100}},
            rotation=0)));
    Blocks.Interfaces.BooleanInput u2
      "Connector of second Boolean input signal" annotation (Placement(
          transformation(extent={{-140,-20},{-100,20}}, rotation=0)));
    Blocks.Interfaces.BooleanInput u3 "Connector of third Boolean input signal"
      annotation (Placement(transformation(extent={{-140,-100},{-100,-60}},
            rotation=0)));
    Blocks.Interfaces.BooleanOutput y "Connector of Boolean output signal"
      annotation (Placement(transformation(extent={{100,-10},{120,10}},
            rotation=0)));

    annotation (Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics={
          Ellipse(
            extent={{-71,74},{-85,88}},
            lineColor=DynamicSelect({235,235,235}, if u1 > 0.5 then {0,255,0}
                 else {235,235,235}),
            fillColor=DynamicSelect({235,235,235}, if u1 > 0.5 then {0,255,0}
                 else {235,235,235}),
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{-71,7},{-85,-7}},
            lineColor=DynamicSelect({235,235,235}, if u2 > 0.5 then {0,255,0}
                 else {235,235,235}),
            fillColor=DynamicSelect({235,235,235}, if u2 > 0.5 then {0,255,0}
                 else {235,235,235}),
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{-71,-74},{-85,-88}},
            lineColor=DynamicSelect({235,235,235}, if u3 > 0.5 then {0,255,0}
                 else {235,235,235}),
            fillColor=DynamicSelect({235,235,235}, if u3 > 0.5 then {0,255,0}
                 else {235,235,235}),
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{71,7},{85,-7}},
            lineColor=DynamicSelect({235,235,235}, if y > 0.5 then {0,255,0}
                 else {235,235,235}),
            fillColor=DynamicSelect({235,235,235}, if y > 0.5 then {0,255,0}
                 else {235,235,235}),
            fillPattern=FillPattern.Solid)}), Documentation(info="<html><p>
Block has three continuous Boolean input and one continuous Boolean output signal
with a 3D icon (e.g., used in Blocks.Logical library).
</p>
</html>"));

  end partialBooleanSI3SO;

  partial block partialBooleanSI "Partial block with 1 input Boolean signal"
    extends Modelica.Blocks.Icons.PartialBooleanBlock;

    Blocks.Interfaces.BooleanInput u "Connector of Boolean input signal"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}},
            rotation=0)));

    annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
              {100,100}}), graphics={Ellipse(
            extent={{-71,7},{-85,-7}},
            lineColor=DynamicSelect({235,235,235}, if u > 0.5 then {0,255,0}
                 else {235,235,235}),
            fillColor=DynamicSelect({235,235,235}, if u > 0.5 then {0,255,0}
                 else {235,235,235}),
            fillPattern=FillPattern.Solid)}), Documentation(info="<html>
<p>
Block has one continuous Boolean input signal
with a 3D icon (e.g., used in Blocks.Logical library).
</p>
</html>"));

  end partialBooleanSI;

  partial block partialBooleanSO "Partial block with 1 output Boolean signal"

    Blocks.Interfaces.BooleanOutput y "Connector of Boolean output signal"
      annotation (Placement(transformation(extent={{100,-10},{120,10}},
            rotation=0)));
    extends Modelica.Blocks.Icons.PartialBooleanBlock;

    annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
              {100,100}}), graphics={Ellipse(
            extent={{71,7},{85,-7}},
            lineColor=DynamicSelect({235,235,235}, if y > 0.5 then {0,255,0}
                 else {235,235,235}),
            fillColor=DynamicSelect({235,235,235}, if y > 0.5 then {0,255,0}
                 else {235,235,235}),
            fillPattern=FillPattern.Solid)}), Documentation(info="<html>
<p>
Block has one continuous Boolean output signal
with a 3D icon (e.g., used in Blocks.Logical library).
</p>
</html>"));

  end partialBooleanSO;

  partial block partialBooleanSource
    "Partial source block (has 1 output Boolean signal and an appropriate default icon)"
    extends Modelica.Blocks.Icons.PartialBooleanBlock;

    Blocks.Interfaces.BooleanOutput y "Connector of Boolean output signal"
      annotation (Placement(transformation(extent={{100,-10},{120,10}},
            rotation=0)));

    annotation (
      Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
              100}}), graphics={
          Polygon(
            points={{-80,88},{-88,66},{-72,66},{-80,88}},
            lineColor={255,0,255},
            fillColor={255,0,255},
            fillPattern=FillPattern.Solid),
          Line(points={{-80,66},{-80,-82}}, color={255,0,255}),
          Line(points={{-90,-70},{72,-70}}, color={255,0,255}),
          Polygon(
            points={{90,-70},{68,-62},{68,-78},{90,-70}},
            lineColor={255,0,255},
            fillColor={255,0,255},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{71,7},{85,-7}},
            lineColor=DynamicSelect({235,235,235}, if y > 0.5 then {0,255,0}
                 else {235,235,235}),
            fillColor=DynamicSelect({235,235,235}, if y > 0.5 then {0,255,0}
                 else {235,235,235}),
            fillPattern=FillPattern.Solid)}),
      Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
              100,100}}), graphics={Polygon(
              points={{-70,92},{-76,70},{-64,70},{-70,92}},
              lineColor={95,95,95},
              fillColor={95,95,95},
              fillPattern=FillPattern.Solid),Line(points={{-70,70},{-70,-88}},
            color={95,95,95}),Line(points={{-90,-70},{68,-70}}, color={95,95,95}),
            Polygon(
              points={{90,-70},{68,-64},{68,-76},{90,-70}},
              lineColor={95,95,95},
              fillColor={95,95,95},
              fillPattern=FillPattern.Solid),Text(
              extent={{54,-80},{106,-92}},
              lineColor={0,0,0},
              textString="time"),Text(
              extent={{-64,92},{-46,74}},
              lineColor={0,0,0},
              textString="y")}),
      Documentation(info="<html>
<p>
Basic block for Boolean sources of package Blocks.Sources.
This component has one continuous Boolean output signal y
and a 3D icon (e.g., used in Blocks.Logical library).
</p>
</html>"));

  end partialBooleanSource;

  partial block partialBooleanThresholdComparison
    "Partial block to compare the Real input u with a threshold and provide the result as 1 Boolean output signal"

    parameter Real threshold=0 "Comparison with respect to threshold";

    Blocks.Interfaces.RealInput u "Connector of Boolean input signal"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}},
            rotation=0)));
    Blocks.Interfaces.BooleanOutput y "Connector of Boolean output signal"
      annotation (Placement(transformation(extent={{100,-10},{120,10}},
            rotation=0)));

    annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
              {100,100}}), graphics={
          Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            lineThickness=5.0,
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            borderPattern=BorderPattern.Raised),
          Text(
            extent={{-150,-140},{150,-110}},
            lineColor={0,0,0},
            textString="%threshold"),
          Ellipse(
            extent={{71,7},{85,-7}},
            lineColor=DynamicSelect({235,235,235}, if y > 0.5 then {0,255,0}
                 else {235,235,235}),
            fillColor=DynamicSelect({235,235,235}, if y > 0.5 then {0,255,0}
                 else {235,235,235}),
            fillPattern=FillPattern.Solid)}), Documentation(info="<html>
<p>
Block has one continuous Real input and one continuous Boolean output signal
as well as a 3D icon (e.g., used in Blocks.Logical library).
</p>
</html>"));

  end partialBooleanThresholdComparison;

  partial block partialBooleanComparison
    "Partial block with 2 Real input and 1 Boolean output signal (the result of a comparison of the two Real inputs)"

    Blocks.Interfaces.RealInput u1 "Connector of first Boolean input signal"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}},
            rotation=0)));
    Blocks.Interfaces.RealInput u2 "Connector of second Boolean input signal"
      annotation (Placement(transformation(extent={{-140,-100},{-100,-60}},
            rotation=0)));
    Blocks.Interfaces.BooleanOutput y "Connector of Boolean output signal"
      annotation (Placement(transformation(extent={{100,-10},{120,10}},
            rotation=0)));

    annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
              {100,100}}), graphics={
          Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            lineThickness=5.0,
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            borderPattern=BorderPattern.Raised),
          Ellipse(
            extent={{73,7},{87,-7}},
            lineColor=DynamicSelect({235,235,235}, if y > 0.5 then {0,255,0}
                 else {235,235,235}),
            fillColor=DynamicSelect({235,235,235}, if y > 0.5 then {0,255,0}
                 else {235,235,235}),
            fillPattern=FillPattern.Solid),
          Ellipse(extent={{32,10},{52,-10}}, lineColor={0,0,127}),
          Line(points={{-100,-80},{42,-80},{42,0}}, color={0,0,127})}),
        Documentation(info="<html>
<p>
Block has two continuous Real input and one continuous Boolean output signal
as a result of the comparison of the two input signals. The block
has a 3D icon (e.g., used in Blocks.Logical library).
</p>
</html>"));

  end partialBooleanComparison;

  partial block PartialBooleanSISO_small
    "Partial block with a BooleanInput and a BooleanOutput signal and a small block icon"

    Modelica.Blocks.Interfaces.BooleanInput u "Boolean input signal"
      annotation (Placement(transformation(extent={{-180,-40},{-100,40}})));
    Modelica.Blocks.Interfaces.BooleanOutput y "Boolean output signal"
      annotation (Placement(transformation(extent={{100,-20},{140,20}})));
    annotation (Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          initialScale=0.04), graphics={
          Text(
            extent={{-250,170},{250,110}},
            textString="%name",
            lineColor={0,0,255}),
          Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            lineThickness=5.0,
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid,
            borderPattern=BorderPattern.Raised),
          Ellipse(
            extent={{60,10},{80,-10}},
            lineColor=DynamicSelect({235,235,235}, if y > 0.5 then {0,255,0}
                 else {235,235,235}),
            fillColor=DynamicSelect({235,235,235}, if y > 0.5 then {0,255,0}
                 else {235,235,235}),
            fillPattern=FillPattern.Solid)}));
  end PartialBooleanSISO_small;

  partial block PartialBooleanMISO
    "Partial block with a BooleanVectorInput and a BooleanOutput signal"

    parameter Integer nu(min=0) = 0 "Number of input connections"
      annotation (Dialog(connectorSizing=true), HideResult=true);
    Modelica.Blocks.Interfaces.BooleanVectorInput u[nu]
      "Vector of Boolean input signals"
      annotation (Placement(transformation(extent={{-120,70},{-80,-70}})));
    Modelica.Blocks.Interfaces.BooleanOutput y "Boolean output signal"
      annotation (Placement(transformation(extent={{100,-15},{130,15}})));
    annotation (Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          initialScale=0.06), graphics={
          Text(
            extent={{-250,170},{250,110}},
            textString="%name",
            lineColor={0,0,255}),
          Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            lineThickness=5.0,
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid,
            borderPattern=BorderPattern.Raised),
          Ellipse(
            extent={{60,10},{80,-10}},
            lineColor=DynamicSelect({235,235,235}, if y > 0.5 then {0,255,0}
                 else {235,235,235}),
            fillColor=DynamicSelect({235,235,235}, if y > 0.5 then {0,255,0}
                 else {235,235,235}),
            fillPattern=FillPattern.Solid)}));
  end PartialBooleanMISO;

  package Adaptors
    "Obsolete package with components to send signals to a bus or receive signals from a bus (only for backward compatibility)"
    extends Modelica.Icons.Package;
    // extends Modelica.Icons.ObsoleteModel;

    block SendReal "Obsolete block to send Real signal to bus"
      // extends Modelica.Icons.ObsoleteModel;
      RealOutput toBus "Output signal to be connected to bus" annotation (
          Placement(transformation(extent={{100,-10},{120,10}}, rotation=0)));
      RealInput u "Input signal to be send to bus" annotation (Placement(
            transformation(extent={{-140,-20},{-100,20}}, rotation=0)));
    equation
      toBus = u;
      annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                -100},{100,100}}), graphics={Rectangle(
                  extent={{-100,40},{100,-40}},
                  lineColor={0,0,127},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),Text(
                  extent={{-144,96},{144,46}},
                  lineColor={0,0,0},
                  textString="%name"),Text(
                  extent={{-100,30},{100,-30}},
                  lineColor={0,0,127},
                  textString="send")}), Documentation(info="<html>
<p>
Obsolete block that was previously used to connect a Real signal
to a signal in a connector. This block is only provided for
backward compatibility.
</p>

<p>
It is much more convenient and more powerful to use \"expandable connectors\"
for signal buses, see example
<a href=\"modelica://Modelica.Blocks.Examples.BusUsage\">BusUsage</a>.
</p>
</html>"));
    end SendReal;

    block SendBoolean "Obsolete block to send Boolean signal to bus"
      // extends Modelica.Icons.ObsoleteModel;
      BooleanOutput toBus "Output signal to be connected to bus" annotation (
          Placement(transformation(extent={{100,-10},{120,10}}, rotation=0)));
      BooleanInput u "Input signal to be send to bus" annotation (Placement(
            transformation(extent={{-140,-20},{-100,20}}, rotation=0)));
    equation
      toBus = u;
      annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                -100},{100,100}}), graphics={Rectangle(
                  extent={{-100,40},{100,-40}},
                  lineColor={255,0,255},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),Text(
                  extent={{-144,96},{144,46}},
                  lineColor={0,0,0},
                  textString="%name"),Text(
                  extent={{-100,30},{100,-30}},
                  lineColor={255,0,255},
                  textString="send")}), Documentation(info="<html>
<p>
Obsolete block that was previously used to connect a Boolean signal
to a signal in a connector. This block is only provided for
backward compatibility.
</p>

<p>
It is much more convenient and more powerful to use \"expandable connectors\"
for signal buses, see example
<a href=\"modelica://Modelica.Blocks.Examples.BusUsage\">BusUsage</a>.
</p>
</html>"));
    end SendBoolean;

    block SendInteger "Obsolete block to send Integer signal to bus"
      // extends Modelica.Icons.ObsoleteModel;
      IntegerOutput toBus "Output signal to be connected to bus" annotation (
          Placement(transformation(extent={{100,-10},{120,10}}, rotation=0)));
      IntegerInput u "Input signal to be send to bus" annotation (Placement(
            transformation(extent={{-140,-20},{-100,20}}, rotation=0)));
    equation
      toBus = u;
      annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                -100},{100,100}}), graphics={Rectangle(
                  extent={{-100,40},{100,-40}},
                  lineColor={255,127,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),Text(
                  extent={{-144,96},{144,46}},
                  lineColor={0,0,0},
                  textString="%name"),Text(
                  extent={{-100,30},{100,-30}},
                  lineColor={255,127,0},
                  textString="send")}), Documentation(info="<html>
<p>
Obsolete block that was previously used to connect an Integer signal
to a signal in a connector. This block is only provided for
backward compatibility.
</p>

<p>
It is much more convenient and more powerful to use \"expandable connectors\"
for signal buses, see example
<a href=\"modelica://Modelica.Blocks.Examples.BusUsage\">BusUsage</a>.
</p>
</html>"));
    end SendInteger;

    block ReceiveReal "Obsolete block to receive Real signal from bus"
      // extends Modelica.Icons.ObsoleteModel;
      RealInput fromBus "To be connected with signal on bus" annotation (
          Placement(transformation(extent={{-120,-10},{-100,10}}, rotation=0)));
      RealOutput y "Output signal to be received from bus" annotation (
          Placement(transformation(extent={{100,-10},{120,10}}, rotation=0)));
    equation
      y = fromBus;
      annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                -100},{100,100}}), graphics={Rectangle(
                  extent={{-100,40},{100,-40}},
                  lineColor={0,0,127},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),Text(
                  extent={{-100,30},{100,-30}},
                  lineColor={0,0,127},
                  textString="receive"),Text(
                  extent={{-144,96},{144,46}},
                  lineColor={0,0,0},
                  textString="%name")}), Documentation(info="<html>
<p>
Obsolete block that was previously used to connect a Real signal
in a connector to an input of a block. This block is only provided for
backward compatibility.
</p>

<p>
It is much more convenient and more powerful to use \"expandable connectors\"
for signal buses, see example
<a href=\"modelica://Modelica.Blocks.Examples.BusUsage\">BusUsage</a>.
</p>
</html>"));
    end ReceiveReal;

    block ReceiveBoolean "Obsolete block to receive Boolean signal from bus"
      // extends Modelica.Icons.ObsoleteModel;
      BooleanInput fromBus "To be connected with signal on bus" annotation (
          Placement(transformation(extent={{-120,-10},{-100,10}}, rotation=0)));
      BooleanOutput y "Output signal to be received from bus" annotation (
          Placement(transformation(extent={{100,-10},{120,10}}, rotation=0)));
    equation
      y = fromBus;
      annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                -100},{100,100}}), graphics={Rectangle(
                  extent={{-100,40},{100,-40}},
                  lineColor={255,0,255},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),Text(
                  extent={{-100,30},{100,-30}},
                  lineColor={255,0,255},
                  textString="receive"),Text(
                  extent={{-144,96},{144,46}},
                  lineColor={0,0,0},
                  textString="%name")}), Documentation(info="<html>
<p>
Obsolete block that was previously used to connect a Boolean signal
in a connector to an input of a block. This block is only provided for
backward compatibility.
</p>

<p>
It is much more convenient and more powerful to use \"expandable connectors\"
for signal buses, see example
<a href=\"modelica://Modelica.Blocks.Examples.BusUsage\">BusUsage</a>.
</p>
</html>"));
    end ReceiveBoolean;

    block ReceiveInteger "Obsolete block to receive Integer signal from bus"
      // extends Modelica.Icons.ObsoleteModel;
      IntegerInput fromBus "To be connected with signal on bus" annotation (
          Placement(transformation(extent={{-120,-10},{-100,10}}, rotation=0)));
      IntegerOutput y "Output signal to be received from bus" annotation (
          Placement(transformation(extent={{100,-10},{120,10}}, rotation=0)));
    equation
      y = fromBus;
      annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                -100},{100,100}}), graphics={Rectangle(
                  extent={{-100,40},{100,-40}},
                  lineColor={255,127,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),Text(
                  extent={{-100,30},{100,-30}},
                  lineColor={255,127,0},
                  textString="receive"),Text(
                  extent={{-144,96},{144,46}},
                  lineColor={0,0,0},
                  textString="%name")}), Documentation(info="<html>
<p>
Obsolete block that was previously used to connect an Integer signal
in a connector to an input of a block. This block is only provided for
backward compatibility.
</p>

<p>
It is much more convenient and more powerful to use \"expandable connectors\"
for signal buses, see example
<a href=\"modelica://Modelica.Blocks.Examples.BusUsage\">BusUsage</a>.
</p>
</html>"));
    end ReceiveInteger;

    annotation (Documentation(info="<html>
<p>
The components of this package should no longer be used.
They are only provided for backward compatibility.
It is much more convenient and more powerful to use \"expandable connectors\"
for signal buses, see example
<a href=\"modelica://Modelica.Blocks.Examples.BusUsage\">BusUsage</a>.
</p>
</html>"));
  end Adaptors;

  partial block PartialConversionBlock
    "Partial block defining the interface for conversion blocks"

    RealInput u "Connector of Real input signal to be converted" annotation (
        Placement(transformation(extent={{-140,-20},{-100,20}}, rotation=0)));
    RealOutput y
      "Connector of Real output signal containing input signal u in another unit"
      annotation (Placement(transformation(extent={{100,-10},{120,10}},
            rotation=0)));
    annotation (
      Icon(
        coordinateSystem(preserveAspectRatio=true,
          extent={{-100.0,-100.0},{100.0,100.0}},
          initialScale=0.1),
          graphics={
        Rectangle(
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100.0,-100.0},{100.0,100.0}}),
        Line(
          points={{-90.0,0.0},{30.0,0.0}},
          color={191,0,0}),
        Polygon(
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid,
          points={{90.0,0.0},{30.0,20.0},{30.0,-20.0},{90.0,0.0}}),
        Text(
          lineColor={0,0,255},
          extent={{-115.0,105.0},{115.0,155.0}},
          textString="%name")}), Documentation(info="<html>
<p>
This block defines the interface of a conversion block that
converts from one unit into another one.
</p>

</html>"));

  end PartialConversionBlock;

  partial block BlockIcon
    "This icon will be removed in future Modelica versions, use Modelica.Blocks.Icons.Block instead."
    // extends Modelica.Icons.ObsoleteModel;

    annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
              {100,100}}), graphics={Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid), Text(
            extent={{-150,150},{150,110}},
            textString="%name",
            lineColor={0,0,255})}), Documentation(info="<html>
<p>
This icon will be removed in future versions of the Modelica Standard Library.
Instead the icon <a href=\"modelica://Modelica.Blocks.Icons.Block\">Modelica.Blocks.Icons.Block</a> shall be used.
</p>
</html>"));

  end BlockIcon;

  partial block BooleanBlockIcon
    "This icon will be removed in future Modelica versions, use Modelica.Blocks.Icons.BooleanBlock instead."
    // extends Modelica.Icons.ObsoleteModel;

    annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
              {100,100}}), graphics={Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={255,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid), Text(
            extent={{-150,150},{150,110}},
            textString="%name",
            lineColor={0,0,255})}), Documentation(info="<html>
<p>
This icon will be removed in future versions of the Modelica Standard Library.
Instead the icon <a href=\"modelica://Modelica.Blocks.Icons.BooleanBlock\">Modelica.Blocks.Icons.BooleanBlock</a> shall be used.
</p>
</html>"));

  end BooleanBlockIcon;

  partial block DiscreteBlockIcon
    "This icon will be removed in future Modelica versions, use Modelica.Blocks.Icons.DiscreteBlock instead."
    // extends Modelica.Icons.ObsoleteModel;

    annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
              {100,100}}), graphics={Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={0,0,127},
            lineThickness=5.0,
            fillColor={223,211,169},
            fillPattern=FillPattern.Solid,
            borderPattern=BorderPattern.Raised), Text(
            extent={{-150,150},{150,110}},
            textString="%name",
            lineColor={0,0,255})}), Documentation(info="<html>
<p>
This icon will be removed in future versions of the Modelica Standard Library.
Instead the icon <a href=\"modelica://Modelica.Blocks.Icons.DiscreteBlock\">Modelica.Blocks.Icons.DiscreteBlock</a> shall be used.
</p>
</html>"));
  end DiscreteBlockIcon;

  partial block IntegerBlockIcon
    "This icon will be removed in future Modelica versions, use Modelica.Blocks.Icons.IntegerBlock instead."
    // extends Modelica.Icons.ObsoleteModel;

    annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
              {100,100}}), graphics={Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={255,127,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid), Text(
            extent={{-150,150},{150,110}},
            textString="%name",
            lineColor={0,0,255})}), Documentation(info="<html>
<p>
This icon will be removed in future versions of the Modelica Standard Library.
Instead the icon <a href=\"modelica://Modelica.Blocks.Icons.IntegerBlock\">Modelica.Blocks.Icons.IntegerBlock</a> shall be used.
</p>
</html>"));
  end IntegerBlockIcon;

  partial block partialBooleanBlockIcon
    "This icon will be removed in future Modelica versions, use Modelica.Blocks.Icons.PartialBooleanBlock instead."
    // extends Modelica.Icons.ObsoleteModel;

    annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
              {100,100}}), graphics={Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            lineThickness=5.0,
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            borderPattern=BorderPattern.Raised), Text(
            extent={{-150,150},{150,110}},
            textString="%name",
            lineColor={0,0,255})}), Documentation(info="<html>
<p>
This icon will be removed in future versions of the Modelica Standard Library.
Instead the icon <a href=\"modelica://Modelica.Blocks.Icons.PartialBooleanBlock\">Modelica.Blocks.Icons.PartialBooleanBlock</a> shall be used.
</p>
</html>"));
  end partialBooleanBlockIcon;
  annotation (Documentation(info="<HTML>
<p>
This package contains interface definitions for
<b>continuous</b> input/output blocks with Real,
Integer and Boolean signals. Furthermore, it contains
partial models for continuous and discrete blocks.
</p>

</html>", revisions="<html>
<ul>
<li><i>Oct. 21, 2002</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>
       and <a href=\"http://www.robotic.dlr.de/Christian.Schweiger/\">Christian Schweiger</a>:<br>
       Added several new interfaces.
<li><i>Oct. 24, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       RealInputSignal renamed to RealInput. RealOutputSignal renamed to
       output RealOutput. GraphBlock renamed to BlockIcon. SISOreal renamed to
       SISO. SOreal renamed to SO. I2SOreal renamed to M2SO.
       SignalGenerator renamed to SignalSource. Introduced the following
       new models: MIMO, MIMOs, SVcontrol, MVcontrol, DiscreteBlockIcon,
       DiscreteBlock, DiscreteSISO, DiscreteMIMO, DiscreteMIMOs,
       BooleanBlockIcon, BooleanSISO, BooleanSignalSource, MI2BooleanMOs.</li>
<li><i>June 30, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Realized a first version, based on an existing Dymola library
       of Dieter Moormann and Hilding Elmqvist.</li>
</ul>
</html>"));
end Interfaces;
