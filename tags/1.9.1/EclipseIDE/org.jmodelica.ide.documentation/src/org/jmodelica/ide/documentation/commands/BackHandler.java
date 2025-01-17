package org.jmodelica.ide.documentation.commands;

import org.eclipse.core.commands.AbstractHandler;
import org.eclipse.core.commands.ExecutionEvent;
import org.eclipse.core.commands.ExecutionException;
import org.eclipse.core.commands.IHandler;
import org.eclipse.ui.IEditorPart;
import org.eclipse.ui.handlers.HandlerUtil;
import org.eclipse.ui.services.ISourceProviderService;
import org.jmodelica.ide.documentation.DocumentationEditor;

public class BackHandler extends AbstractHandler implements IHandler {

	@Override
	public Object execute(ExecutionEvent event) throws ExecutionException {
		IEditorPart e = HandlerUtil.getActiveEditor(event);
		boolean isEnabled = false;
		if (e instanceof DocumentationEditor){
			isEnabled = ((DocumentationEditor)e).back();
		}
		ISourceProviderService sourceProviderService = (ISourceProviderService) HandlerUtil.getActiveWorkbenchWindow(event).getService(ISourceProviderService.class);
		NavigationProvider navProv = (NavigationProvider) sourceProviderService.getSourceProvider(NavigationProvider.NAVIGATION_BACK);
		navProv.setBackEnabled(isEnabled);
		return null;
	}
}
