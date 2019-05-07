package robotlegs.bender.extensions.display.stage3D.away3d.impl; 

import away3d.containers.View3D;
import away3d.core.managers.Stage3DManager;
import away3d.core.managers.Stage3DProxy;
import robotlegs.bender.extensions.display.base.api.ILayer;
import robotlegs.bender.extensions.display.base.api.IRenderContext;

/**
 * ...
 * @author P.J.Shand
 */

@:keepSub
class AwayLayer extends View3D implements ILayer implements IAwayLayer
{
	public var active:Bool = true;
	@:isVar public var renderContext(get, set):IRenderContext;
	
	public var changeAvailable(get, null):Bool;
	private var stage3DManager:Stage3DManager;
	private var profile:String;
	
	public function new(profile:String = "baseline", contextIndex:Int=0) 
	{
		super(null, null, null, false, profile, contextIndex);
		this.profile = profile;
		
		this.camera.lens.far = 20000;
		this.backgroundColor = 0x555555;
		this.shareContext = true;
	}
	
	public function process():Void
	{
		this.render();
		if (_mouse3DManager != null) _mouse3DManager.fireMouseEvents();
		if (_touch3DManager != null) _touch3DManager.fireTouchEvents();
	}
	
	public function process():Void
	{
		this.render();
    }
	
	public function setTo(x:Float, y:Float, width:Float, height:Float):Void
	{
		this.x = stage3DProxy.x = x;
		this.y = stage3DProxy.y = y;
		this.width = width;
		this.height = height;
		stage3DProxy.width = cast width;
		stage3DProxy.height = cast height;
	}
	
	private function set_renderContext(value:IRenderContext):IRenderContext 
	{
		renderContext = value;
		if (stage3DProxy != null) {
			stage3DProxy.antiAlias = value.antiAlias;
		}
		return value;
	}
	
	private function get_renderContext():IRenderContext 
	{
		return renderContext;
	}
	
	override private function set_stage3DProxy(stage3DProxy:Stage3DProxy) : Stage3DProxy
    {
		if (renderContext != null) {
			stage3DProxy.antiAlias = renderContext.antiAlias;
		}
		return super.set_stage3DProxy(stage3DProxy);
	}
	
	function get_changeAvailable():Bool 
	{
		return true;
	}
}