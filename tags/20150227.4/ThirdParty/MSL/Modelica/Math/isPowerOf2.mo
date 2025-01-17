within Modelica.Math;
function isPowerOf2 "Determine if the integer input is a power of 2"
  extends Modelica.Icons.Function;
  input Integer i(min=1) "Integer scalar";
  output Boolean result "= true, if integer scalar is a power of 2";
algorithm
  assert(i>=1, "Integer input to isPowerOf2 has to be >= 1");
  result := i == 2^integer(log(i)/log(2)+0.5);
  annotation (Inline=true, Documentation(info="<HTML>
<h4>Syntax</h4>
<blockquote><pre>
Math.<b>isPowerOf2</b>(i);
</pre></blockquote>
<h4>Description</h4>
<p>
The function call \"<code>Math.isPowerOf2(i)</code>\" returns <b>true</b>,
if the Integer input i is a power of 2. Otherwise the function
returns <b>false</b>. The Integer input has to be &gt;=1.
</p>
<h4>Example</h4>
<blockquote><pre>
  Integer i1 = 1;
  Integer i2 = 4;
  Integer i3 = 9;
  Boolean result;
<b>algorithm</b>
  result := Math.isPowerOf2(i1);     // = <b>true</b> 2^0
  result := Math.isPowerOf2(i2);     // = <b>true</b> 2^2
  result := Math.isPowerOf2(i3);     // = <b>false</b>
</pre></blockquote>
</HTML>"));
end isPowerOf2;
