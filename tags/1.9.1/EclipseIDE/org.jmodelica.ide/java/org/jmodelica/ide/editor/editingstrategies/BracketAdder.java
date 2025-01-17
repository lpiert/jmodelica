package org.jmodelica.ide.editor.editingstrategies;

import org.eclipse.jface.text.BadLocationException;
import org.eclipse.jface.text.DocumentCommand;
import org.eclipse.jface.text.IAutoEditStrategy;
import org.eclipse.jface.text.IDocument;
import org.jmodelica.ide.indent.DocUtil;


/**
 * Auto edit strategy for adding brackets as user types. Mimics the way JDT
 * inserts ending parenthesis.
 * 
 * @author philip
 * 
 */
public class BracketAdder implements IAutoEditStrategy {

final protected String startToken, endToken;

public BracketAdder(String startToken, String endToken) {
    this.startToken = startToken;
    this.endToken = endToken;
}

public void customizeDocumentCommand(IDocument doc, DocumentCommand c) {
    try {
        
        int endLine; {
            int line = 
                doc.getLineOfOffset(c.offset);
            endLine = 
                doc.getLineOffset(line) + doc.getLineLength(line);
        }

        boolean endTokenTrailingCaret = 
            doc.get(c.offset, endLine - c.offset).startsWith(endToken);
        
        if (c.text.equals(endToken) && endTokenTrailingCaret) {
            c.text = "";
            c.caretOffset = c.offset + 1;
        }
        
        else if (c.text.equals(startToken)) {
            
            boolean afterLastWordOnLine = 
                doc
                .get(c.offset, endLine - c.offset)
                .replaceAll("[^\\w]", "")
                .equals("");
        
            // prevent editor from inserting
            // e.g. ' or " twice, when unwanted
            boolean symmetricTokenOnLine =
                new DocUtil(doc)
                .getLine(c.offset)
                .contains(startToken);
            
            if (afterLastWordOnLine && !symmetricTokenOnLine) {
                c.text += endToken;
                c.shiftsCaret = false;
                c.caretOffset = c.offset + 1;
            }
        }
        
    } catch (BadLocationException e) {
        e.printStackTrace();
    }
}
}
