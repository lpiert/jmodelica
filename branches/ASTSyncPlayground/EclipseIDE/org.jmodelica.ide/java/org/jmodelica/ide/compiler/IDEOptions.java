package org.jmodelica.ide.compiler;

import org.eclipse.core.resources.IProject;
import org.eclipse.core.resources.IResource;
import org.jmodelica.ide.IDEConstants;
import org.jmodelica.ide.helpers.Util;
import org.jmodelica.modelica.compiler.ModelicaCompiler;
import org.jmodelica.util.OptionRegistry;

/**
 * OptionsRegistry for use in the JModelica IDE.
 * 
 * @author philip
 * 
 */
public class IDEOptions extends OptionRegistry {

	public IDEOptions(IProject project) {
		addStringOption(IDEConstants.MODELICAPATH, "");
		addStringOption(IDEConstants.PACKAGES_IN_WORKSPACE_OPTION, "");

		if (project == null)
			return;

		IResource options = project.findMember(IDEConstants.COMPILER_OPTIONS_FILE);
		try {
			if (options != null)
				loadOptions(options.getRawLocation().toOSString());
		} catch (Exception e) {
			// TODO: Do something constructive. An error message or something.
			e.printStackTrace();
		}

		try {
			String modelicaPath = ModelicaPreferences.INSTANCE.get(project, IDEConstants.PREFERENCE_LIBRARIES_ID);
			setStringOption(IDEConstants.MODELICAPATH, modelicaPath);

			// Set standard options for FMU
			ModelicaCompiler mc = new ModelicaCompiler(this);
			mc.defaultOptionsFMUME();
		} catch (Exception e) {
			// TODO: Do something constructive. An error message or something.
			e.printStackTrace();
		}

	}

}
