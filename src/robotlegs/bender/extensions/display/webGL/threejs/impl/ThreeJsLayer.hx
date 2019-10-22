package robotlegs.bender.extensions.display.webGL.threejs.impl;

import js.three.WebGLRendererParameters;
import js.Browser;
import js.three.PerspectiveCamera;
import js.three.Scene;
import js.three.WebGLRenderer;
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

	public var renderer = new WebGLRenderer();

	public var camera:PerspectiveCamera;
	public var changeAvailable(get, null):Bool;

	var _width:Float = 0;
	var _height:Float = 0;

	public function new(options:WebGLRendererParameters) {
		super();

		renderer = new WebGLRenderer(options);
		renderer.setPixelRatio(js.Browser.window.devicePixelRatio == null ? 1 : js.Browser.window.devicePixelRatio);

		if (options != null) {
			renderer.setClearColor(options.clearColor, 1.0);
		}

		renderer.sortObjects = false;

		renderer.domElement.style.top = "0px";
		renderer.domElement.style.position = "absolute";
		// renderer.domElement.style.zIndex = "-1";

		Browser.document.body.appendChild(renderer.domElement);

		camera = new PerspectiveCamera(45, js.Browser.window.innerWidth / js.Browser.window.innerHeight, 1, 10000);
		// camera.position.set( 100, 200, 300 );

		// camera = new PerspectiveCamera(60, 1, 0.001, 700);
		camera.position.set(0, 10, 0);
		scene.add(camera);

		Resize.add(onResize);
	}

	function onResize() {
		camera.aspect = Browser.window.innerWidth / Browser.window.innerHeight;
		camera.updateProjectionMatrix();

		renderer.setSize(Browser.window.innerWidth, Browser.window.innerHeight);
	}

	public function process():Void {
		render();
	}

	public function snap():Void {
		render();
	}

	function render():Void {
		camera.updateProjectionMatrix();
		renderer.render(scene, camera);
	}

	public function setTo(x:Float, y:Float, width:Float, height:Float):Void {
		_width = width;
		_height = height;

		camera.aspect = width / height;
		camera.updateProjectionMatrix();

		renderer.setSize(Math.floor(width), Math.floor(height));
		// camera.aspect = Browser.window.innerWidth / Browser.window.innerHeight;
		// camera.updateProjectionMatrix();
		// renderer.setSize(Browser.window.innerWidth, Browser.window.innerHeight);
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
