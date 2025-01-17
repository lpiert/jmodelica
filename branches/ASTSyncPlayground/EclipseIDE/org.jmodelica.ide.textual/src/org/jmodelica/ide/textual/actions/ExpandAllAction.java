package org.jmodelica.ide.textual.actions;

import org.eclipse.jface.text.source.projection.ProjectionViewer;
import org.jmodelica.ide.IDEConstants;
import org.jmodelica.ide.textual.editor.Editor;

public class ExpandAllAction extends DoOperationAction {

public ExpandAllAction(Editor editor) {

    super("&Expand All", ProjectionViewer.EXPAND_ALL, editor);
    super.setId(IDEConstants.ACTION_EXPAND_ALL_ID);
    
}

}
