package robotlegs.bender.extensions.display.webGL.threejs.impl; 

import js.three.PerspectiveCamera;
import js.three.Scene;
import js.three.WebGLRenderer;
import openfl.display.Sprite;
import robotlegs.bender.extensions.display.base.api.ILayer;
import robotlegs.bender.extensions.display.base.api.IRenderContext;

/**
 * ...
 * @author P.J.Shand
 */

@:keepSub
class ThreeJsLayer extends Sprite implements ILayer
{
	@:isVar public var renderContext(get, set):IRenderContext;
	
	public var scene = new Scene();
	private var renderer = new WebGLRenderer( { alpha:true, antialias: true } );
	
	public var camera:PerspectiveCamera;
	
	var _width:Float = 0;
	var _height:Float = 0;
	
	
	public function new(clearColor:UInt=0x00000)
	{
		super();
		
		renderer.setPixelRatio( js.Browser.window.devicePixelRatio==null ? 1 : js.Browser.window.devicePixelRatio );
		renderer.setClearColor ( clearColor, 1.0 );
		renderer.sortObjects = true;
		
		camera = new PerspectiveCamera(60, 1, 0.001, 700);
		camera.position.set(0, 10, 0);
		scene.add(camera);
	}
	
	public function process():Void
	{
		render();
	}
	
    function render():Void
	{
		camera.updateProjectionMatrix();
		renderer.render( scene, camera );
    }

	public function setTo(x:Float, y:Float, width:Float, height:Float):Void
	{
		_width = width;
		_height = height;
		
		camera.aspect = width / height;
		camera.updateProjectionMatrix();
		
		renderer.setSize(width, height);
	}
	
	public function set_renderContext(value:IRenderContext):IRenderContext 
	{
		return renderContext = value;
	}
	
	public function get_renderContext():IRenderContext 
	{
		return renderContext;
	}
}