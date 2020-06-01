package robotlegs.bender.extensions.display.webGL.threejs.impl;

import js.Browser;
import three.cameras.PerspectiveCamera;
import three.scenes.Scene;
import three.renderers.WebGLRenderer;
import three.renderers.WebGLRenderer.WebGLRendererParameters;
import openfl.display.Sprite;
import robotlegs.bender.extensions.display.base.api.ILayer;
import robotlegs.bender.extensions.display.base.api.IRenderContext;
import resize.Resize;

/**
 * ...
 * @author P.J.Shand
 */
@:keepSub
class ThreeJsLayer extends Sprite implements ILayer {
	@:isVar public var renderContext(get, set):IRenderContext;

	public var active:Bool = true;
	public var scene = new Scene();

	public var renderer:WebGLRenderer;

	public var camera:PerspectiveCamera;
	public var changeAvailable(get, null):Bool;

	var _width:Float = 0;
	var _height:Float = 0;

	public function new() {
		super();

		// Create renderer, camera and scene in extending class
	}

	public function process():Void {
		render();
	}

	public function snap():Void {
		render();
	}

	function render():Void {
		//
	}

	public function setTo(x:Float, y:Float, width:Float, height:Float):Void {
		//
	}

	public function set_renderContext(value:IRenderContext):IRenderContext {
		return renderContext = value;
	}

	public function get_renderContext():IRenderContext {
		return renderContext;
	}

	function get_changeAvailable():Bool {
		return true;
	}
}
