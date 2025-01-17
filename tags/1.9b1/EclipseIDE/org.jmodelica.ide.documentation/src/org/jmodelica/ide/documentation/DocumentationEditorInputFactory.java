package org.jmodelica.ide.documentation;

import org.eclipse.core.resources.IProject;
import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.core.runtime.IAdaptable;
import org.eclipse.ui.IElementFactory;
import org.eclipse.ui.IMemento;

public class DocumentationEditorInputFactory implements IElementFactory {

	public static final String ID_FACTORY = "org.jmodelica.ide.documentation.documentationEditorInputFactory";
	private static final String TAG_PROJECT = "project";
	private static final String TAG_NAME = "name";
	
	@Override
	public IAdaptable createElement(IMemento memento) {
		String project = memento.getString(TAG_PROJECT);
		String name = memento.getString(TAG_NAME);
		if (project == null || name == null){
			return null;
		}
		IProject iProject = ResourcesPlugin.getWorkspace().getRoot().getProject(project);
		if (iProject != null) {
			return new DocumentationEditorInput(name, iProject);
		}
		return null;
	}
	public static void save(IMemento memento, DocumentationEditorInput input) {
		memento.putString(TAG_PROJECT, input.getProject().getFullPath().toString());
		memento.putString(TAG_NAME, input.getClassName());
	}

}
