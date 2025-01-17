package org.jmodelica.ide.namecomplete;


import org.eclipse.core.resources.IFile;
import org.eclipse.jface.text.Document;
import org.jmodelica.ide.ModelicaCompiler;
import org.jmodelica.ide.OffsetDocument;
import org.jmodelica.ide.helpers.Maybe;
import org.jmodelica.ide.indent.DocUtil;
import org.jmodelica.modelica.compiler.SourceRoot;
import org.jmodelica.modelica.compiler.StoredDefinition;
import org.jmodelica.modelica.parser.ModelicaParser;

public class Recompiler {

public final static ModelicaCompiler compiler =
    new ModelicaCompiler(new ModelicaParser.CollectingReport());

/**
 * Recompile active file and add new AST to project AST
 */
public StoredDefinition recompilePartial(
    OffsetDocument d, 
    Maybe<SourceRoot> mProjectRoot,
    IFile file) 
{
    
    /* remove the current (partial) line when compiling, to make error
       recovery easier */
    String fileContents = 
        new DocUtil(
            new Document(d.get()))
        .replaceLineAt(d.offset, "")
        .get();

    /* re-parse and add new AST to project AST */
    StoredDefinition def; {
        def = compiler.recompile(fileContents, file);
        if (mProjectRoot.hasValue())
            mProjectRoot
                .value()
                .getProgram()
                .dynamicAddStoredDefinition(def);
        
    }
    
    return def;
}

}
