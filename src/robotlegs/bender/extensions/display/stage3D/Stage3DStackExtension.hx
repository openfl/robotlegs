package robotlegs.bender.extensions.display.stage3D;

import robotlegs.bender.extensions.display.base.DisplayExtension;
import robotlegs.bender.extensions.display.base.api.IRenderContext;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;
import robotlegs.bender.framework.impl.UID;
/**
 * ...
 * @author P.J.Shand
 * 
 */
@:keepSub
class Stage3DStackExtension implements IExtension
{
	public function extend(context:IContext):Void
	{
		context.install([DisplayExtension]);
		context.injector.map(IRenderContext).toSingleton(Stage3DRenderContext);
	}
}