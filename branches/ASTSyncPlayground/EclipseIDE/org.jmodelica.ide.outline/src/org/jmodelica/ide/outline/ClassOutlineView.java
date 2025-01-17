/*
    Copyright (C) 2009 Modelon AB

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, version 3 of the License.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package org.jmodelica.ide.outline;

import java.util.HashMap;
import java.util.Map;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.resources.IProject;
import org.eclipse.ui.IEditorInput;
import org.eclipse.ui.IFileEditorInput;
import org.eclipse.ui.IWorkbenchPart;
import org.eclipse.ui.part.IPage;
import org.eclipse.ui.texteditor.AbstractTextEditor;
import org.eclipse.ui.views.contentoutline.IContentOutlinePage;
import org.jastadd.ed.core.model.IASTEditor;
import org.jmodelica.ide.helpers.ICurrentClassListener;
import org.jmodelica.ide.helpers.EclipseUtil;

public class ClassOutlineView extends OutlineView {

	private Map<IProject, ClassOutlinePage> mapProjToPage = new HashMap<IProject, ClassOutlinePage>();
	private ICurrentClassListener tempPagePart = null;
	private ClassOutlinePage tempPage = null;

	protected IContentOutlinePage setupOutlinePage(IWorkbenchPart part) {
		if (part instanceof AbstractTextEditor) {
			AbstractTextEditor editor = (AbstractTextEditor) part;
			IProject project = getProjectOfEditor(editor);
			if (project != null) {
				ClassOutlinePage page = mapProjToPage.get(project);
				if (page == null && EclipseUtil.isModelicaProject(project)) {
					page = new ClassOutlinePage(project, editor);
					mapProjToPage.put(project, page);
					initPage(page);
					page.createControl(getPageBook());
				} else {
					IFileEditorInput fInput = (IFileEditorInput) editor
							.getEditorInput();
					IFile file = fInput.getFile();
					page.addFileListener(file);
				}
				if (editor instanceof ICurrentClassListener)
					page.addCurrentClassListener((ICurrentClassListener) editor);
				return page;
			}
		}
		return null;
	}

	protected void doDestroyPage(IWorkbenchPart part, PageRec rec) {
		/**
		 * IFileEditorInput fInput = (IFileEditorInput) ((AbstractTextEditor)
		 * part) .getEditorInput(); IFile file = fInput.getFile();
		 * ClassOutlinePage page = mapProjToPage.get(file.getProject()); if
		 * (page != null) page.removeFileListener(file);
		 */
		if (part instanceof AbstractTextEditor)
			mapProjToPage.remove(getProjectOfEditor((AbstractTextEditor) part));
		super.doDestroyPage(part, rec);
	}

	public void partClosed(IWorkbenchPart part) {
		if (part instanceof AbstractTextEditor && part instanceof IFileEditorInput) {
			IFileEditorInput fInput = (IFileEditorInput) ((AbstractTextEditor) part)
					.getEditorInput();
			IFile file = fInput.getFile();
			ClassOutlinePage page2 = mapProjToPage.get(file.getProject());
			if (page2 != null) {
				page2.removeFileListener(file);
			}
		}
		if (part instanceof ICurrentClassListener) {
			PageRec rec = getPageRec(part);
			if (rec != null && rec.page instanceof ClassOutlinePage) {
				ClassOutlinePage page = (ClassOutlinePage) rec.page;
				page.removeCurrentClassListener((ICurrentClassListener) part);
			}
		}
		super.partClosed(part);
	}

	/**
	 * Get the project connected to the given text editor's opened file, if any.
	 */
	protected IProject getProjectOfEditor(AbstractTextEditor editor) {
		IEditorInput input = editor.getEditorInput();
		if (input instanceof IFileEditorInput) {
			IFile file = ((IFileEditorInput) input).getFile();
			if (file != null)
				return file.getProject();
		}
		return null;
	}

	protected boolean isImportant(IWorkbenchPart part) {
		if (part instanceof AbstractTextEditor) {
			IProject project = getProjectOfEditor((AbstractTextEditor) part);
			return EclipseUtil.isModelicaProject(project);
		} else {
			return false;
		}
	}

	public void partActivated(IWorkbenchPart part) {
		if (isImportant(part))
			super.partActivated(part);
		else if (part instanceof ICurrentClassListener)
			connectTempPage((ICurrentClassListener) part);
	}

	private void connectTempPage(ICurrentClassListener part) {
		IPage page = getCurrentPage();
		if (page instanceof ClassOutlinePage) {
			disconnectTempPage();
			((ClassOutlinePage) page).addCurrentClassListener(part);
			tempPagePart = part;
			tempPage = ((ClassOutlinePage) page);
		}
	}

	private void disconnectTempPage() {
		if (tempPage != null) {
			tempPage.removeCurrentClassListener(tempPagePart);
			tempPage = null;
			tempPagePart = null;
		}
	}

	public void partBroughtToTop(IWorkbenchPart part) {
		partActivated(part);
	}

	protected void partHidden(IWorkbenchPart part) {
		disconnectTempPage();
	}

	protected IContentOutlinePage getOutlinePage(IASTEditor part) {
		return null;
	}
}