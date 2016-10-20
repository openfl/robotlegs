package robotlegs.bender.extensions.display.stage3D.starling.impl;

import robotlegs.bender.extensions.display.base.api.ILayer;
import robotlegs.bender.extensions.display.base.api.IRenderContext;
import robotlegs.bender.extensions.display.base.api.IRenderer;
import starling.core.Starling;

/**
 * ...
 * @author P.J.Shand
 */
class PlaceHolderLayer implements ILayer
{
	private var starling:Starling;
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
}