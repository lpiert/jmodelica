package org.jmodelica.ide.editor.actions;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.OutputStream;

import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.IStatus;
import org.eclipse.core.runtime.Status;
import org.eclipse.core.runtime.jobs.IJobChangeEvent;
import org.eclipse.core.runtime.jobs.IJobChangeListener;
import org.eclipse.core.runtime.jobs.Job;
import org.eclipse.jface.action.Action;
import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.DirectoryDialog;
import org.eclipse.swt.widgets.MessageBox;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.ui.IWorkbenchPage;
import org.eclipse.ui.PartInitException;
import org.eclipse.ui.PlatformUI;
import org.eclipse.ui.console.ConsolePlugin;
import org.eclipse.ui.console.IConsole;
import org.eclipse.ui.console.IConsoleConstants;
import org.eclipse.ui.console.MessageConsole;
import org.eclipse.ui.console.MessageConsoleStream;
import org.jmodelica.ide.IDEConstants;
import org.jmodelica.ide.editor.Editor;
import org.jmodelica.modelica.compiler.BaseClassDecl;
import org.jmodelica.modelica.compiler.CompilationAbortedException;
import org.jmodelica.modelica.compiler.CompilationHooks;
import org.jmodelica.modelica.compiler.CompilerException;
import org.jmodelica.modelica.compiler.FClass;
import org.jmodelica.modelica.compiler.InstClassDecl;
import org.jmodelica.modelica.compiler.ModelicaClassNotFoundException;
import org.jmodelica.modelica.compiler.ModelicaCompiler;
import org.jmodelica.modelica.compiler.SourceRoot;
import org.jmodelica.util.DummyOutputStream;
import org.jmodelica.util.OptionRegistry;

public class CompileFMUAction extends CurrentClassAction implements IJobChangeListener {
	
	// TODO: Open a console and run compilation there
	// TODO: Add preference for default output dir
	// TODO: Take "current class" from outline instead of editor
	
	protected Editor editor;
	protected DirectoryDialog outputDirDlg;
	
	public CompileFMUAction(Editor editor) {
		super();
		super.setActionDefinitionId(IDEConstants.COMMAND_COMPILE_FMU_ID);
		super.setId(IDEConstants.ACTION_COMPILE_FMU_ID);
		this.editor = editor;
	}

	@Override
	protected String getNewText(BaseClassDecl currentClass) {
        if (currentClass != null) 
            return "Compile '" + currentClass.getName().getID() + "' to FMU";
        else
        	return IDEConstants.ACTION_COMPILE_FMU_TEXT;
	}
	
	@Override
	public boolean isEnabled() {
		if (!super.isEnabled())
			return false;
		String jmHome = ModelicaCompiler.getJModelicaHome();
		if (jmHome == null)
			return false;
		return new File(jmHome).isDirectory();
	}

	@Override
	public void run() {
		String dir = askForDir();
		if (dir != null) {
			showConsole();
			OptionRegistry opt = new OptionRegistry(currentClass.root().options);
			String className = currentClass.qualifiedName();
			String[] paths = editor.editorFile().getPaths();
			Job job = new CompileJob(className, paths, dir, opt);
			job.setUser(true);
			job.addJobChangeListener(this);
			job.schedule();
		}
	}

	public void showConsole() {
		IWorkbenchPage page = PlatformUI.getWorkbench().getActiveWorkbenchWindow().getActivePage();
		 try {
			page.showView(IConsoleConstants.ID_CONSOLE_VIEW);
		} catch (PartInitException e) {
		}
	}

	protected String askForDir() {
		if (outputDirDlg == null || outputDirDlg.getParent().isDisposed()) {
			Shell shell = PlatformUI.getWorkbench().getDisplay().getActiveShell();
			outputDirDlg = new DirectoryDialog(shell);
			outputDirDlg.setMessage("Select output directory for FMU");
			outputDirDlg.setText("Select output directory");
		}		
		return outputDirDlg.open();
	}

	public void done(IJobChangeEvent event) {
		if (event.getResult().getSeverity() == IStatus.ERROR) {
			Shell shell = PlatformUI.getWorkbench().getDisplay().getActiveShell();
			String title = event.getJob().getName();
			MessageDialog.openError(shell, title, event.getResult().getMessage());
		}
	}

	public void aboutToRun(IJobChangeEvent event) {
	}

	public void awake(IJobChangeEvent event) {
	}

	public void running(IJobChangeEvent event) {
	}

	public void scheduled(IJobChangeEvent event) {
	}

	public void sleeping(IJobChangeEvent event) {
	}
	
	protected static class CompileJob extends Job implements CompilationHooks {

		private static final int WORK_PARSE       = 1;
		private static final int WORK_INSTANTIATE = 5;
		private static final int WORK_FLATTEN     = 1;
		private static final int WORK_TRANSFORM   = 1;
		private static final int WORK_FLAT_CHECK  = 1;
		private static final int WORK_GENERATE    = 1;
		private static final int WORK_COMPILE_C   = 2;
		private static final int WORK_PACK        = 1;
		
		private static final int WORK_TOTAL = 
			WORK_PARSE + WORK_INSTANTIATE + WORK_FLATTEN + WORK_TRANSFORM + 
			WORK_FLAT_CHECK + WORK_GENERATE + WORK_COMPILE_C + WORK_PACK;
		
		private IProgressMonitor mon;
		private String className;
		private String[] paths;
		private String dir;
		private OptionRegistry opt;
		private MessageConsole messageConsole;

		public CompileJob(String className, String[] paths, String dir, OptionRegistry opt) {
			super("Compiling " + className + " to FMU");
			this.className = className;
			this.paths = paths;
			this.dir = dir;
			this.opt = opt;
		}

		@Override
		protected IStatus run(IProgressMonitor monitor) {
			mon = monitor;
			mon.beginTask("Compiling to FMU", WORK_TOTAL);
			mon.subTask("Parsing...");
			IStatus status = Status.OK_STATUS;
			OutputStream out = newConsoleStream();
			ModelicaCompiler.setStreamLogger(out);
			ModelicaCompiler.setLogLevel(ModelicaCompiler.DEBUG);
			try {
				ModelicaCompiler mc = new ModelicaCompiler(opt);
				mc.addCompilationHooks(this);
				mc.setTempFileDir(getTempDir());
				mc.compileFMU(className, paths, "model_noad", dir);
			} catch (CompilationAbortedException e) {
				status = Status.CANCEL_STATUS;
			} catch (Exception e) {
				String msg = "Error compiling " + className + " to FMU";
				if (e.getMessage() != null)
					msg += ":\n" + e.getMessage();
				status = new Status(IStatus.ERROR, IDEConstants.PLUGIN_ID, msg, e); 
			}
			ModelicaCompiler.setDefaultLogger();
			ModelicaCompiler.closeStreamLogger();
			mon.done();
			return status;
		}

		public File getTempDir() {
			try {
				File tempDir = File.createTempFile("org.jmodelica.ide.", "");
				tempDir.delete();
				if (tempDir.mkdir()) {
					tempDir.deleteOnExit();
					return tempDir;
				}
			} catch (IOException e) {
			} catch (SecurityException e) {
			}
			return new File(System.getProperty("java.io.tmpdir"));
		}
		  
		 private OutputStream newConsoleStream() {
			 if (messageConsole == null) 
				 messageConsole = new MessageConsole("Modelica Compilation", null);  
			 ConsolePlugin.getDefault().getConsoleManager().addConsoles(new IConsole[] { messageConsole });
			 
			 return messageConsole.newMessageStream();
		 }  

		@Override
		public boolean shouldAbort() {
			return mon.isCanceled();
		}

		@Override
		public void filesParsed(SourceRoot sr) {
			mon.worked(WORK_PARSE);
			mon.subTask("Instantiating...");
		}

		@Override
		public void modelInstantiatied(InstClassDecl icd) {
			mon.worked(WORK_INSTANTIATE);
			mon.subTask("Flattening...");
		}

		@Override
		public void modelFlattened(FClass fc) {
			mon.worked(WORK_FLATTEN);
		}

		@Override
		public void modelTransformed(FClass fc) {
			mon.worked(WORK_TRANSFORM);
		}

		@Override
		public void flatModelChecked(FClass fc) {
			mon.worked(WORK_FLAT_CHECK);
			mon.subTask("Generating code...");
		}

		@Override
		public void codeGenerated() {
			mon.worked(WORK_GENERATE);
			mon.subTask("Compiling generated code...");
		}

		@Override
		public void codeCompiled() {
			mon.worked(WORK_COMPILE_C);
			mon.subTask("Packing FMU...");
		}

		@Override
		public void fmuPacked(String path) {
			mon.worked(WORK_PACK);
		}
		
	}

}
