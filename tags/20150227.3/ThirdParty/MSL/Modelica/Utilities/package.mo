within Modelica;
package Utilities "Library of utility functions dedicated to scripting (operating on files, streams, strings, system)"
  extends Modelica.Icons.Package;


package UsersGuide "User's Guide of Utilities Library"
  extends Modelica.Icons.Information;

  class ImplementationNotes "Implementation Notes"
    extends Modelica.Icons.Information;

    annotation (Documentation(info="<html>
<p>
Below the major design decisions of this library are summarized.
</p>
<ul>
<li> <b>C-Function Interface</b><br>
     This library contains several interfaces to C-functions in order
     to operate with the environment. As will become clear, it is usually
     required that a Modelica tool vendor provides an implementation
     of these C-functions that are suited for his environment.
     In directory \"Modelica/Resources/C-Sources\" a reference implementation
     is given for Microsoft Windows Systems and for POSIX environments.
     The files \"ModelicaInternal.c\" and \"ModelicaStrings.c\" can be
     used as a basis for the integration in the vendors environment.<br>&nbsp;</li>
<li> <b>Character Encoding</b><br>
     The representation of characters is different in operating systems.
     The more modern ones (e.g., Windows-NT) use an early variant of
     Unicode (16 bit per character)
     other (e.g., Windows-ME) use 8-bit encoding. Also 32 bit per character
     and multi-byte representations are in use. This is important, since e.g.,
     Japanese Modelica users need Unicode representation. The design in this
     library is done in such a way that a basic set of calls to the operating
     system hides the actual character representation. This means, that all
     functions of this package can be used independent from the underlying
     character representation.<br>
     The C-interface of the Modelica language provides only an 8-bit
     character encoding passing mechanism of strings. As a result, the
     reference implementation in \"Modelica.Utilities\\C-Source\" needs to
     be adapted to the character representation supported in the
     Modelica vendor environment.<br>&nbsp;</li>
<li> <b>Internal String Representation</b><br>
     The design of this package was made in order that string handling
     is convenient. This is in contrast to, e.g., the C-language, where
     string handling is inconvenient, cumbersome and error prone, but on the
     other hand is in some sense \"efficient\".
     The standard reference implementation in \"Modelica.Utilities\\C-Source\"
     is based on the standard C definition of a string, i.e., a pointer to
     a sequence of characters, ended with a null terminating character.
     In order that the string handling in this package is convenient,
     some assumptions have been made, especially, that the access to
     a substring is efficient (O(1) access instead of O(n) as in standard C).
     This allows to hide string pointer arithmetic from the user.
     In such a case, a similar efficiency as in C can be expected for
     most high level operations, such as find, sort, replace.
     The \"efficient character access\" can be reached if, e.g.,
     the number of characters
     are stored in a string, and the length of a character is fixed,
     say 16 or 32 bit (if all Unicode characters shall be represented).
     A vendor should adapt the reference implementation in this
     respect.<br>&nbsp;</li>
<li> <b>String copy = pointer copy</b><br>
     The Modelica language has no mechanism to change a character
     of a string. When a string has to be modified, the only way
     to achieve this is to generate it newly. The advantage is that
     a Modelica tool can treat a string as a constant entity and
     can replace (expensive) string copy operations by pointer
     copy operations. For example, when sorting a set of strings
     the following type of operations occur:
     <pre>
     String s[:], s_temp;
      ...
     s_temp := s[i];
     s[i]   := s[j];
     s[j]   := s_temp;
     </pre>
     Formally, three strings are copied. Due to the feature
     sketched above, a Modelica tool can replace this
     copy operation by pointer assignments, a very \"cheap\"
     operation. The Modelica.Utilities functions will perform
     efficiently, if such types of optimizations are supported
     by the tool.</li>
</ul>
</html>"));
  end ImplementationNotes;

  class ReleaseNotes "Release notes"
    extends Modelica.Icons.ReleaseNotes;

    annotation (Documentation(info="<HTML>
<h4>Version 1.0, 2004-09-29</h4>
<p>
First version implemented.
</p>
</html>"));
  end ReleaseNotes;

  class Contact "Contact"
    extends Modelica.Icons.Contact;

    annotation (Documentation(info="<html>
<dl>
<dt><b>Responsible for Library:</b>
<dd>Dag Br&uuml;ck, Dassault Syst&egrave;mes AB, Sweden.<br>
    email: <A HREF=\"mailto:Dag.BRUCK@3ds.com\">Dag.BRUCK@3ds.com</A><br>
</dl>
<p><b>Acknowledgements:</b></p>
<ul>
<li> This library has been designed by:<br>
     <blockquote>
     Dag Br&uuml;ck, Dassault Syst&egrave;mes AB, Sweden <br>
     Hilding Elmqvist, Dassault Syst&egrave;mes AB, Sweden <br>
     Hans Olsson, Dassault Syst&egrave;mes AB, Sweden <br>
     Martin Otter, DLR Oberpfaffenhofen, Germany.
     </blockquote></li>
<li> The library including the C reference implementation has
     been implemented by Martin Otter and Dag Br&uuml;ck.</li>
<li> The Examples.calculator demonstration to implement a calculator
     with this library is from Hilding Elmqvist.</li>
<li> Helpful comments from Kaj Nystr&ouml;m, PELAB, Link&ouml;ping, Sweden,
     are appreciated, as well as discussions at the 34th, 36th, and 40th
     Modelica Design Meetings in Vienna, Link&ouml;ping, and Dresden. </li>
</ul>
</html>"));
  end Contact;

  annotation (DocumentationClass=true, Documentation(info="<HTML>
<p>
Library <b>Modelica.Utilities</b> contains Modelica <b>functions</b> that are
especially suited for <b>scripting</b>. Currently, only a rudimentary
User's Guide is present. This will be improved in the next releases.
The User's Guide has currently the following chapters:
</p>
<ol>
<li>
<a href=\"modelica://Modelica.Utilities.UsersGuide.ReleaseNotes\">Release Notes</a>
  summarizes the differences between different versions of this
  library.
</li>
<li>
<a href=\"modelica://Modelica.Utilities.UsersGuide.ImplementationNotes\">ImplementationNotes</a>
  describes design decisions for this library especially for
  Modelica tool vendors.
</li>
<li>
<a href=\"modelica://Modelica.Utilities.UsersGuide.Contact\">Contact</a> provides
  information about the authors of the library as well as acknowledgments.
</li>
</ol>
<p>
<b>Error handling</b><br>
In case of error, all functions in this library use a Modelica \"assert(..)\"
to provide an error message and to cancel all actions. This means that
functions do not return, if an error is triggered inside the function.
In the near future, an exception handling mechanism will be introduced
in Modelica that will allow to catch errors at a defined place.
</p>
</HTML>"));
end UsersGuide;








    annotation (
Icon(coordinateSystem(extent={{-100.0,-100.0},{100.0,100.0}}), graphics={
    Polygon(
      origin={1.3835,-4.1418},
      rotation=45.0,
      fillColor={64,64,64},
      pattern=LinePattern.None,
      fillPattern=FillPattern.Solid,
      points={{-15.0,93.333},{-15.0,68.333},{0.0,58.333},{15.0,68.333},{15.0,93.333},{20.0,93.333},{25.0,83.333},{25.0,58.333},{10.0,43.333},{10.0,-41.667},{25.0,-56.667},{25.0,-76.667},{10.0,-91.667},{0.0,-91.667},{0.0,-81.667},{5.0,-81.667},{15.0,-71.667},{15.0,-61.667},{5.0,-51.667},{-5.0,-51.667},{-15.0,-61.667},{-15.0,-71.667},{-5.0,-81.667},{0.0,-81.667},{0.0,-91.667},{-10.0,-91.667},{-25.0,-76.667},{-25.0,-56.667},{-10.0,-41.667},{-10.0,43.333},{-25.0,58.333},{-25.0,83.333},{-20.0,93.333}}),
    Polygon(
      origin={10.1018,5.218},
      rotation=-45.0,
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid,
      points={{-15.0,87.273},{15.0,87.273},{20.0,82.273},{20.0,27.273},{10.0,17.273},{10.0,7.273},{20.0,2.273},{20.0,-2.727},{5.0,-2.727},{5.0,-77.727},{10.0,-87.727},{5.0,-112.727},{-5.0,-112.727},{-10.0,-87.727},{-5.0,-77.727},{-5.0,-2.727},{-20.0,-2.727},{-20.0,2.273},{-10.0,7.273},{-10.0,17.273},{-20.0,27.273},{-20.0,82.273}})}),
Documentation(info="<html>
<p>
This package contains Modelica <b>functions</b> that are
especially suited for <b>scripting</b>. The functions might
be used to work with strings, read data from file, write data
to file or copy, move and remove files.
</p>
<p>
For an introduction, have especially a look at:
</p>
<ul>
<li> <a href=\"modelica://Modelica.Utilities.UsersGuide\">Modelica.Utilities.User's Guide</a>
     discusses the most important aspects of this library.</li>
<li> <a href=\"modelica://Modelica.Utilities.Examples\">Modelica.Utilities.Examples</a>
     contains examples that demonstrate the usage of this library.</li>
</ul>
<p>
The following main sublibraries are available:
</p>
<ul>
<li> <a href=\"modelica://Modelica.Utilities.Files\">Files</a>
     provides functions to operate on files and directories, e.g.,
     to copy, move, remove files.</li>
<li> <a href=\"modelica://Modelica.Utilities.Streams\">Streams</a>
     provides functions to read from files and write to files.</li>
<li> <a href=\"modelica://Modelica.Utilities.Strings\">Strings</a>
     provides functions to operate on strings. E.g.
     substring, find, replace, sort, scanToken.</li>
<li> <a href=\"modelica://Modelica.Utilities.System\">System</a>
     provides functions to interact with the environment.
     E.g., get or set the working directory or environment
     variables and to send a command to the default shell.</li>
</ul>

<p>
Copyright &copy; 1998-2015, Modelica Association, DLR, and Dassault Syst&egrave;mes AB.
</p>

<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"https://www.modelica.org/licenses/ModelicaLicense2\"> https://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>

</html>"));
end Utilities;
