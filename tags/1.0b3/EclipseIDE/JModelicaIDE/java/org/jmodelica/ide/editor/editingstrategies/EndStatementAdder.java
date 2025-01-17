package org.jmodelica.ide.editor.editingstrategies;

import org.eclipse.jface.text.BadLocationException;
import org.eclipse.jface.text.IAutoEditStrategy;
import org.eclipse.jface.text.IDocument;
import org.eclipse.jface.text.IRegion;
import org.jmodelica.ide.editor.actions.ToggleComment;
import org.jmodelica.ide.helpers.Util;
import org.jmodelica.ide.indent.IndentedSection;


public abstract class EndStatementAdder implements IAutoEditStrategy {

/**
 * Checks if endStmnt occurs among the source code lines after
 * <code> offset </code>, within or at the end of the scope at
 * <code> offset </code> (scope heuristically determined by indentation).
 * 
 */
protected boolean endExists(String endStmnt, IDocument d, int offset)
        throws BadLocationException {
    
    int startLine = d.getLineOfOffset(offset);
    int startIndent = IndentedSection.countIndent(Util.getLine(d, startLine));
    
    int i;    
    for (i = startLine; i < d.getNumberOfLines() - 1; i++) {
        
        String line = Util.getLine(d, i);
        
        boolean ignoreLine = line.trim().equals("") || 
            ToggleComment.isCommented(line) ||
            Util.is(line.trim().split("\\s+")[0]).among(
                    "intitial", "equation", "algorithm", "public", "protected");  
        
        if (ignoreLine)
            continue;
        
        boolean endStatementAtLine = 
            line.contains(endStmnt);
        
        boolean leftScope = 
            i > startLine && 
            IndentedSection.countIndent(line) <= startIndent;
        
        if (endStatementAtLine || leftScope)  
            break;
        
    }
    
    return Util.getLine(d, i).contains(endStmnt);
}

/**
 * Scans document and adds endStmnt if it can't find it already, 
 * within the current scope. 
 * @param end 
 * @param d
 * @param offset
 */
public void addEndIfNotPresent(String end, IDocument d, int offset) {

    try {

        if (endExists(end.trim(), d, offset))
            return;
        
        IRegion line = d.getLineInformationOfOffset(offset);
        int lineEnd = line.getOffset() + line.getLength();

        String endStatement; 
        {
            int lineStart = line.getOffset();
            int indentWidth = IndentedSection.countIndent(
                d.get(lineStart, offset - lineStart));
            
            endStatement = IndentedSection.lineSep +
                new IndentedSection(end).offsetIndentTo(indentWidth);
        }

        //
        // another adverse effect of the completely retarded DocumentCommand 
        // class:
        // 
        // must insert end statement with d.replace, as if using the
        // DocumentCommand class, it seems impossible to position cursor in 
        // the middle of the command.text. this causes this class to create two
        // undo entries. TODO: fix if possible
        d.replace(lineEnd, 0, endStatement);

    } catch (BadLocationException e) {
        e.printStackTrace();
    }
}
}