package org.jmodelica.ide.compiler;

import java.io.File;
import java.io.FileNotFoundException;

import org.eclipse.core.resources.IProject;
import org.jmodelica.ide.IDEConstants;
import org.jmodelica.ide.helpers.Util;
import org.jmodelica.ide.preferences.Preferences;
import org.jmodelica.modelica.compiler.ModelicaCompiler;
import org.jmodelica.util.OptionRegistry;
import org.xml.sax.SAXException;

/**
 * OptionsRegistry for use in the JModelica IDE.
 * 
 * @author philip
 *
 */
public class IDEOptions extends OptionRegistry {

public IDEOptions(IProject project) {
    addStringOption("MODELICAPATH", "");
    addStringOption(IDEConstants.PACKAGES_IN_WORKSPACE_OPTION, "");
    
	if (project == null)
		return;
    
    try {
        String dir = Preferences.get(project, IDEConstants.PREFERENCE_OPTIONS_PATH_ID);
        if (dir != null) {
			String path = dir + File.separator + "options.xml";
			try {
				copyAllOptions(new OptionRegistry(path));
			} catch (FileNotFoundException e) {
			} catch (SAXException e) {
			}
        }
		
	    String modelicaPath = Preferences.get(project, IDEConstants.PREFERENCE_LIBRARIES_ID);
		setStringOption("MODELICAPATH", modelicaPath);

		// Set standard options for FMU
        ModelicaCompiler mc = new ModelicaCompiler(this);
        mc.defaultOptionsFMU();
    } catch (Exception e) {
    	// TODO: Do something constructive. An error message or something.
        e.printStackTrace();
    }
    

}

}
