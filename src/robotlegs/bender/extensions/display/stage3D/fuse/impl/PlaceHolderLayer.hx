package robotlegs.bender.extensions.display.stage3D.fuse.impl;

import fuse.Fuse;
import robotlegs.bender.extensions.display.base.api.ILayer;
import robotlegs.bender.extensions.display.base.api.IRenderContext;
import robotlegs.bender.extensions.display.base.api.IRenderer;

/**
 * ...
 * @author P.J.Shand
 */
class PlaceHolderLayer implements ILayer
{
	public var active:Bool = true;
	private var fuse:Fuse;
	public var changeAvailable(get, null):Bool;
	@:isVar public var renderContext(get, set):IRenderContext;
	
	public function new() { }
	
	public function set_renderContext(value:IRenderContext):IRenderContext 
	{
		return renderContext = value;
	}
	
	public function get_renderContext():IRenderContext 
	{
		return renderContext;
	}
	
	public function setTo(x:Float, y:Float, width:Float, height:Float):Void
	{
		
	}
	
	public function process():Void 
	{
		
	}
	
	function get_changeAvailable():Bool 
	{
		return false;
	}
}