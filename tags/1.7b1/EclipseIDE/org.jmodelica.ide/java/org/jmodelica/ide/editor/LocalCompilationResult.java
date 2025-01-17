package org.jmodelica.ide.editor;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.resources.IProject;
import org.eclipse.jface.text.IDocument;
import org.eclipse.jface.text.reconciler.IReconcilingStrategy;
import org.jmodelica.ide.compiler.ModelicaEclipseCompiler;


public class LocalCompilationResult extends CompilationResult {

private final Editor editor;
private final ModelicaEclipseCompiler compiler;

public LocalCompilationResult(EditorFile ef, Editor ed) {

    compiler = new ModelicaEclipseCompiler();
    root = compiler.compileFile(ef.iFile());
    editor = ed;
    
}

public void update(IProject projChanged, String keyChanged) { }
public void update(IProject projChanged) { }
public void dispose(Editor editor) { }

public void recompileLocal(IDocument doc, IFile file) {
    root = compiler.recompile(doc, file).defaultTo(root);
}

@Override
public IReconcilingStrategy compilationStrategy() {
    return new LocalReconcilingStrategy(editor);
}

}