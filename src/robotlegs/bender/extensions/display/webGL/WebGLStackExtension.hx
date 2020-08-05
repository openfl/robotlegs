package robotlegs.bender.extensions.display.webGL;

import robotlegs.bender.extensions.display.base.DisplayExtension;
import robotlegs.bender.extensions.display.base.api.IRenderContext;
import robotlegs.bender.extensions.display.webGL.WebGLRenderContext;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;

/**
 * ...
 * @author P.J.Shand
 *
 */
@:keepSub
class WebGLStackExtension implements IExtension {
	public function extend(context:IContext):Void {
		context.install(DisplayExtension);
		context.injector.map(IRenderContext).toSingleton(WebGLRenderContext);
	}
}
