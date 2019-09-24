package robotlegs.bender.bundles.threejs;

import robotlegs.bender.extensions.display.webGL.WebGLStackExtension;
import robotlegs.bender.framework.api.IBundle;
import robotlegs.bender.framework.api.IContext;

@:keepSub
class WebGLBundle implements IBundle {
	public function new() {}

	public function extend(context:IContext):Void {
		context.install(WebGLStackExtension);
	}
}
