package robotlegs.bender.extensions.display.webGL.threejs.impl; 

import js.three.PerspectiveCamera;
import js.three.Scene;
import js.three.StereoEffect;
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
	private var renderer = new WebGLRenderer();
	private var effect:StereoEffect;
	private var camera:PerspectiveCamera;
	
	public function new()
	{
		super();
		
		effect = new StereoEffect(renderer);
		
		camera = new PerspectiveCamera(90, 1, 0.001, 700);
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
		effect.render(scene, camera);
    }

	public function setTo(x:Float, y:Float, width:Float, height:Float):Void
	{
		camera.aspect = width / height;
		camera.updateProjectionMatrix();
		
		renderer.setSize(width, height);
		effect.setSize(width, height);
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