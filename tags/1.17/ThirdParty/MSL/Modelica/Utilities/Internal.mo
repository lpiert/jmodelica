within Modelica.Utilities;
package Internal
  "Internal components that a user should usually not directly utilize"
  extends Modelica.Icons.InternalPackage;
partial package PartialModelicaServices
    "Interfaces of components requiring a tool specific implementation"
    extends Modelica.Icons.InternalPackage;
  package Animation "Models and functions for 3-dim. animation"
    extends Modelica.Icons.Package;
  partial model PartialShape "Interface for 3D animation of elementary shapes"

        import SI = Modelica.SIunits;
        import Modelica.Mechanics.MultiBody.Frames;
        import Modelica.Mechanics.MultiBody.Types;

    parameter Types.ShapeType shapeType="box"
          "Type of shape (box, sphere, cylinder, pipecylinder, cone, pipe, beam, gearwheel, spring, <external shape>)";
    input Frames.Orientation R=Frames.nullRotation()
          "Orientation object to rotate the world frame into the object frame"
                                                                            annotation(Dialog);
    input SI.Position r[3]={0,0,0}
          "Position vector from origin of world frame to origin of object frame, resolved in world frame"
                                                                                                      annotation(Dialog);
    input SI.Position r_shape[3]={0,0,0}
          "Position vector from origin of object frame to shape origin, resolved in object frame"
                                                                                              annotation(Dialog);
    input Real lengthDirection[3](each final unit="1")={1,0,0}
          "Vector in length direction, resolved in object frame"
                                                              annotation(Dialog);
    input Real widthDirection[3](each final unit="1")={0,1,0}
          "Vector in width direction, resolved in object frame"
                                                             annotation(Dialog);
    input SI.Length length=0 "Length of visual object"  annotation(Dialog);
    input SI.Length width=0 "Width of visual object"  annotation(Dialog);
    input SI.Length height=0 "Height of visual object"  annotation(Dialog);
    input Types.ShapeExtra extra=0.0
          "Additional size data for some of the shape types"                             annotation(Dialog);
    input Real color[3]={255,0,0} "Color of shape"               annotation(Dialog(colorSelector=true));
    input Types.SpecularCoefficient specularCoefficient = 0.7
          "Reflection of ambient light (= 0: light is completely absorbed)"
                                                                        annotation(Dialog);
    annotation (
      Documentation(info="<html>

<p>
This model is documented at
<a href=\"modelica://Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape\">Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape</a>.
</p>

</html>"));

  end PartialShape;

    model PartialSurface "Interface for 3D animation of surfaces"

        import Modelica.Mechanics.MultiBody.Frames;
        import Modelica.Mechanics.MultiBody.Types;

      input Frames.Orientation R=Frames.nullRotation()
          "Orientation object to rotate the world frame into the surface frame"
        annotation(Dialog(group="Surface frame"));
      input Modelica.SIunits.Position r_0[3]={0,0,0}
          "Position vector from origin of world frame to origin of surface frame, resolved in world frame"
        annotation(Dialog(group="Surface frame"));

      parameter Integer nu=2 "Number of points in u-Dimension" annotation(Dialog(group="Surface properties"));
      parameter Integer nv=2 "Number of points in v-Dimension" annotation(Dialog(group="Surface properties"));
      replaceable function surfaceCharacteristic =
         Modelica.Mechanics.MultiBody.Interfaces.partialSurfaceCharacteristic
          "Function defining the surface characteristic"
              annotation(choicesAllMatching=true,Dialog(group="Surface properties"));

      parameter Boolean wireframe=false
          "= true: 3D model will be displayed without faces"
        annotation (Dialog(group="Material properties"),choices(checkBox=true));
      parameter Boolean multiColoredSurface=false
          "= true: Color is defined for each surface point"
          annotation(Dialog(group="Material properties"),choices(checkBox=true));
      input Real color[3]={255,0,0} "Color of surface" annotation(Dialog(colorSelector=true,group="Material properties", enable=not multiColoredSurface));
      input Types.SpecularCoefficient specularCoefficient = 0.7
          "Reflection of ambient light (= 0: light is completely absorbed)"
                                                                          annotation(Dialog(group="Material properties"));
      input Real transparency=0
          "Transparency of shape: 0 (= opaque) ... 1 (= fully transparent)"
                                   annotation(Dialog(group="Material properties"));
      annotation (Documentation(info="<html>
<p>
This model is documented at
<a href=\"modelica://Modelica.Mechanics.MultiBody.Visualizers.Advanced.Surface\">Modelica.Mechanics.MultiBody.Visualizers.Advanced.Surface</a>.
</p>

</html>"));
    end PartialSurface;
  end Animation;

  package ExternalReferences "Functions to access external resources"
    extends Modelica.Icons.InternalPackage;
    partial function PartialLoadResource
        "Interface for tool specific function to return the absolute path name of a URI or local file name"
      extends Modelica.Icons.Function;
      input String uri "URI or local file name";
      output String fileReference "Absolute path name of file";
      annotation (Documentation(info="<html>
<p>
This partial function defines the function interface of a tool-specific implementation
in package ModelicaServices. The interface is documented at
<a href=\"modelica://Modelica.Utilities.Files.loadResource\">Modelica.Utilities.Internal.FileSystem.loadResource</a>.
</p>

</html>"));
    end PartialLoadResource;
  end ExternalReferences;
    annotation (Documentation(info="<html>

<p>
This package contains interfaces of a set of functions and models used in the
Modelica Standard Library that requires a <b>tool specific implementation</b>.
There is an associated package called <b>ModelicaServices</b>. A tool vendor
should provide a proper implementation of this library for the corresponding
tool. The default implementation is \"do nothing\".
In the Modelica Standard Library, the models and functions of ModelicaServices
are used.
</p>
</html>"));
end PartialModelicaServices;

package FileSystem
    "Internal package with external functions as interface to the file system"
 extends Modelica.Icons.InternalPackage;

  function mkdir "Make directory (POSIX: 'mkdir')"
    extends Modelica.Icons.Function;
    input String directoryName "Make a new directory";
  external "C" ModelicaInternal_mkdir(directoryName) annotation(Library="ModelicaExternalC");
  end mkdir;

  function rmdir "Remove empty directory (POSIX function 'rmdir')"
    extends Modelica.Icons.Function;
    input String directoryName "Empty directory to be removed";
  external "C" ModelicaInternal_rmdir(directoryName) annotation(Library="ModelicaExternalC");
  end rmdir;

  function stat "Inquire file information (POSIX function 'stat')"
    extends Modelica.Icons.Function;
    input String name "Name of file, directory, pipe etc.";
    output Types.FileType fileType "Type of file";
  external "C" fileType=  ModelicaInternal_stat(name) annotation(Library="ModelicaExternalC");
  end stat;

  function rename "Rename existing file or directory (C function 'rename')"
    extends Modelica.Icons.Function;
    input String oldName "Current name";
    input String newName "New name";
  external "C" ModelicaInternal_rename(oldName, newName) annotation(Library="ModelicaExternalC");
  end rename;

  function removeFile "Remove existing file (C function 'remove')"
    extends Modelica.Icons.Function;
    input String fileName "File to be removed";
  external "C" ModelicaInternal_removeFile(fileName) annotation(Library="ModelicaExternalC");
  end removeFile;

  function copyFile
      "Copy existing file (C functions 'fopen', 'getc', 'putc', 'fclose')"
    extends Modelica.Icons.Function;
    input String fromName "Name of file to be copied";
    input String toName "Name of copy of file";
  external "C" ModelicaInternal_copyFile(fromName, toName) annotation(Library="ModelicaExternalC");
  end copyFile;

  function readDirectory
      "Read names of a directory (POSIX functions opendir, readdir, closedir)"
    extends Modelica.Icons.Function;
    input String directory
        "Name of the directory from which information is desired";
    input Integer nNames
        "Number of names that are returned (inquire with getNumberOfFiles)";
    output String names[nNames]
        "All file and directory names in any order from the desired directory";
    external "C" ModelicaInternal_readDirectory(directory,nNames,names) annotation(Library="ModelicaExternalC");
  end readDirectory;

function getNumberOfFiles
      "Get number of files and directories in a directory (POSIX functions opendir, readdir, closedir)"
  extends Modelica.Icons.Function;
  input String directory "Directory name";
  output Integer result
        "Number of files and directories present in 'directory'";
  external "C" result = ModelicaInternal_getNumberOfFiles(directory) annotation(Library="ModelicaExternalC");
end getNumberOfFiles;

  annotation (
Documentation(info="<html>
<p>
Package <b>Internal.FileSystem</b> is an internal package that contains
low level functions as interface to the file system.
These functions should not be called directly in a scripting
environment since more convenient functions are provided
in packages Files and Systems.
</p>
<p>
Note, the functions in this package are direct interfaces to
functions of POSIX and of the standard C library. Errors
occurring in these functions are treated by triggering
a Modelica assert. Therefore, the functions in this package
return only for a successful operation. Furthermore, the
representation of a string is hidden by this interface,
especially if the operating system supports Unicode characters.
</p>
</html>"));
end FileSystem;
end Internal;
