package org.jmodelica.ide.error;

import org.jmodelica.modelica.compiler.ASTNode;

public class InstanceWarning extends InstanceProblem {

	public InstanceWarning(String msg, ASTNode<?> n) {
		super(msg, n);
	}

	public Severity getSeverity() {
		return Severity.WARNING;
	}

	public boolean isError() {
		return false;
	}

	public String getSeverityString() {
		return "Warning";
	}
}
