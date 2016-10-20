package robotlegs.bender.bundles.threejs;

import robotlegs.bender.extensions.display.webGL.threejs.ThreeJsIntegrationExtension;
import robotlegs.bender.framework.api.IBundle;
import robotlegs.bender.framework.api.IContext;

@:keepSub
class ThreeJSBundle implements IBundle
{
	#if !threejs_noEmbed
	static function __init__() : Void
	{
		haxe.macro.Compiler.includeFile("js/three/three.js");
		haxe.macro.Compiler.includeFile("js/three/DeviceOrientationControls.js");
		haxe.macro.Compiler.includeFile("js/three/StereoEffect.js");
		haxe.macro.Compiler.includeFile("js/three/OrbitControls.js");
	}
	#end
	
	public function new() { }
	
	public function extend(context:IContext):Void
	{
		context.install([
			ThreeJsIntegrationExtension,
		]);
	}
}
