package org.jmodelica.ide.graphical.editparts;

import org.eclipse.gef.EditPolicy;
import org.eclipse.gef.GraphicalEditPart;
import org.eclipse.gef.Request;
import org.eclipse.gef.commands.Command;
import org.eclipse.gef.requests.GroupRequest;
import org.eclipse.ui.views.properties.IPropertyDescriptor;
import org.eclipse.ui.views.properties.IPropertySource;
import org.eclipse.ui.views.properties.PropertyDescriptor;
import org.eclipse.ui.views.properties.TextPropertyDescriptor;
import org.jmodelica.icons.Component;
import org.jmodelica.icons.Icon;
import org.jmodelica.icons.Layer;
import org.jmodelica.icons.Observable;
import org.jmodelica.icons.coord.Extent;
import org.jmodelica.icons.coord.Placement;
import org.jmodelica.icons.coord.Point;
import org.jmodelica.icons.coord.Transformation;
import org.jmodelica.icons.primitives.Color;
import org.jmodelica.icons.primitives.Line;
import org.jmodelica.ide.graphical.commands.DeleteComponentCommand;
import org.jmodelica.ide.graphical.commands.RotateComponentCommand;
import org.jmodelica.ide.graphical.editparts.primitives.AbstractPolygonEditPart;
import org.jmodelica.ide.graphical.editparts.primitives.GraphicEditPart;
import org.jmodelica.ide.graphical.graphics.IconLayer;
import org.jmodelica.ide.graphical.util.ASTNodeResourceProvider;
import org.jmodelica.ide.graphical.util.ASTResourceProvider;
import org.jmodelica.ide.graphical.util.Converter;
import org.jmodelica.ide.graphical.util.Transform;
import org.jmodelica.modelica.compiler.InstComponentDecl;
import org.jmodelica.modelica.compiler.InstPrimitive;

public class ComponentEditPart extends AbstractIconEditPart implements IPropertySource, ASTNodeResourceProvider {

	private ASTResourceProvider provider;
	
	public ComponentEditPart(Component component, ASTResourceProvider provider) {
		super(component);
		this.provider = provider;
	}

	@Override
	public void activate() {
		super.activate();
		getModel().getPlacement().getTransformation().addObserver(this);
		getModel().getPlacement().addObserver(this);
	}

	@Override
	public void deactivate() {
		getModel().getPlacement().getTransformation().removeObserver(this);
		getModel().getPlacement().removeObserver(this);
		super.deactivate();
	}

	@Override
	protected IconLayer createFigure() {
		return new IconLayer();
	}

	@Override
	public IconLayer getFigure() {
		return (IconLayer) super.getFigure();
	}

	@Override
	public Component getModel() {
		return (Component) super.getModel();
	}

	@Override
	public Icon getIcon() {
		return getModel().getIcon();
	}

	@Override
	protected void createEditPolicies() {
		installEditPolicy(EditPolicy.COMPONENT_ROLE, new RotationEditPolicy() {

			@Override
			protected Command createRotateCommand(Request request, double angle) {
				return new RotateComponentCommand(getModel(), angle);
			}

			@Override
			protected Command createDeleteCommand(GroupRequest deleteRequest) {
				return new DeleteComponentCommand(getParent().getIcon(), getModel());
			}
		});
	}

	@Override
	protected void refreshVisuals() {
		if (getIcon().getLayer() == Layer.NO_LAYER) {
			getFigure().setVisible(false);
			return;
		}
		invalidateTransform();
		for (Object part : getChildren()) {
			if (part instanceof GraphicEditPart)
				((GraphicEditPart) part).refresh();
			if (part instanceof ComponentEditPart)
				((ComponentEditPart) part).refreshVisuals();

		}
		getFigure().setDeclaredBounds(Converter.convert(getComponentTransform().transform(Transform.yInverter.transform(getModel().getPlacement().getTransformation().getExtent()))));
		getFigure().figureMoved(null);
		((GraphicalEditPart) getParent()).setLayoutConstraint(this, getFigure(), getFigure().getBounds());

	}

	@Override
	public AbstractIconEditPart getParent() {
		return (AbstractIconEditPart) super.getParent();
	}

	public Transform getParentTransform() {
		if (getParent() instanceof AbstractIconEditPart) {
			return ((AbstractIconEditPart) getParent()).getTransform();
		}
		return null;
	}

	private Transform componentTransform;

	public Transform getComponentTransform() {
		// Make sure it's calculated and up to date.
		getTransform();
		return componentTransform.clone();
	}

	@Override
	protected Transform calculateTransform() {
		// Based on org.jmodelica.icons.drawing.AWTIconDrawer.setTransformation()
		Transformation compTransformation = getModel().getPlacement().getTransformation();
		Extent transformationExtent = compTransformation.getExtent();
		Extent componentExtent = getIcon().getLayer().getCoordinateSystem().getExtent();
		Transform transform = getParentTransform().clone();
		transform.translate(Transform.yInverter.transform(compTransformation.getOrigin()));
		componentTransform = transform.clone();
		transform.translate(Transform.yInverter.transform(transformationExtent.getMiddle()));

		if (transformationExtent.getP2().getX() < transformationExtent.getP1().getX()) {
			transform.scale(-1.0, 1.0);
			componentTransform.scale(-1.0, 1.0);
		}
		if (transformationExtent.getP2().getY() < transformationExtent.getP1().getY()) {
			transform.scale(1.0, -1.0);
			componentTransform.scale(1.0, -1.0);
		}

		double angle = -compTransformation.getRotation() * Math.PI / 180;
		transform.rotate(angle);
		componentTransform.rotate(angle);

		transform.scale(transformationExtent.getWidth() / componentExtent.getWidth(), transformationExtent.getHeight() / componentExtent.getHeight());

		return transform;
	}

	public Extent declaredExtent() {
		Extent e = getModel().getPlacement().getTransformation().getExtent();
		Point o = getModel().getPlacement().getTransformation().getOrigin();
		return new Extent(new Point(o.getX() + e.getP1().getX(), o.getY() + e.getP1().getY()), new Point(o.getX() + e.getP2().getX(), o.getY() + e.getP2().getY()));
	}

	@Override
	public void update(Observable o, Object flag, Object additionalInfo) {
		if (o == getModel().getPlacement()) {
			if (flag == Placement.TRANSFORMATION_SWAPPED)
				updateTransformation((Transformation) additionalInfo);
			else if (flag == Placement.VISIBLE_UPDATED)
				updateVisible();
		}
		if (o == getModel().getPlacement().getTransformation()) {
			if (flag == Transformation.ORIGIN_UPDATED)
				updateOrigin();
			else if (flag == Transformation.EXTENT_UPDATED)
				updateExtent();
			else if (flag == Transformation.ROTATION_CHANGED)
				updateRotation();
		}
//		if (o == getModel()) {
//			if (flag == Component.COMPONENT_NAME_CHANGED)
//				//TODO: this should probably not be supported
//		}

		super.update(o, flag, additionalInfo);
	}

	private void updateTransformation(Transformation oldTransformation) {
		if (oldTransformation != null)
			oldTransformation.removeObserver(this);
		getModel().getPlacement().getTransformation().addObserver(this);
	}

	private void updateVisible() {
		figure.setVisible(false);
	}

	private void updateOrigin() {
		refreshVisuals();
	}

	private void updateExtent() {
		refreshVisuals();
	}

	private void updateRotation() {
		refreshVisuals();
	}

	protected Color calculateConnectionColor() {
		for (Object o : getChildren()) {
			Color c = Line.DEFAULT_COLOR;
			if (o instanceof AbstractPolygonEditPart) {
				c = ((AbstractPolygonEditPart) o).getModel().getLineColor();
			} else if (o instanceof ComponentEditPart) {
				c = ((ComponentEditPart) o).calculateConnectionColor();
			}
			if (c != Line.DEFAULT_COLOR)
				return c;
		}
		return Line.DEFAULT_COLOR;
	}

	@Override
	public Object getEditableValue() {
		System.out.println("getEditableValue");
		return this;
	}

	@Override
	public IPropertyDescriptor[] getPropertyDescriptors() {
		return new IPropertyDescriptor[] { new TextPropertyDescriptor("componentName", "Component Name"), new PropertyDescriptor("readOnly", "Read only") };
	}

	@Override
	public Object getPropertyValue(Object id) {
		if ("componentName".equals(id))
			return getModel().getComponentName();
		else if ("readOnly".equals(id))
			return "value";
		else
			return null;
	}

	@Override
	public boolean isPropertySet(Object id) {
		System.out.println("isPropertySet");
		return false;
	}

	@Override
	public void resetPropertyValue(Object id) {
		System.out.println("resetPropertyValue");
	}

	@Override
	public void setPropertyValue(Object id, Object value) {
		System.out.println("setPropertyValue");
	}

	/*
	 * (non-Javadoc)
	 * @see org.jmodelica.ide.graphical.util.ASTNodeResourceProvider#getComponentName()
	 */
	@Override
	public String getComponentName() {
		return getModel().getComponentName();
	}

	/*
	 * (non-Javadoc)
	 * @see org.jmodelica.ide.graphical.util.ASTNodeResourceProvider#getClassName()
	 */
	@Override
	public String getClassName() {
		return getModel().getIcon().getClassName();
	}

	/*
	 * (non-Javadoc)
	 * @see org.jmodelica.ide.graphical.util.ASTNodeResourceProvider#getParameterValue(java.lang.String)
	 */
	@Override
	public String getParameterValue(String parameter) {
		InstComponentDecl icd = provider.getInstComponentDeclByName(getModel().getComponentName());
		if (icd == null)
			return null;
		for (Object o : icd.memberInstComponent(parameter)) {
			if (o instanceof InstPrimitive) {
				InstPrimitive ip = (InstPrimitive) o;
				return ip.ceval().toString();
			}
		}
		
		
		
		return null;
	}

}
