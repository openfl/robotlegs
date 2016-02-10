package robotlegs.bender.extensions.stage3D.starling.impl;

import openfl.geom.Rectangle;
import robotlegs.bender.extensions.stage3D.base.api.ILayer;
import robotlegs.bender.extensions.stage3D.base.api.IRenderer;
import starling.core.Starling;

/**
 * ...
 * @author P.J.Shand
 */
class PlaceHolderLayer implements ILayer
{
	private var _iRenderer:IRenderer;
	private var starling:Starling;
	
	public var iRenderer(get, set):IRenderer;
	
	public function new() 
	{
		//_rect = new Rectangle();
	}
	
	public function get_iRenderer():IRenderer 
	{
		return _iRenderer;
	}
	
	public function set_iRenderer(value:IRenderer):IRenderer 
	{
		return _iRenderer = value;
	}
	
	public function setTo(x:Float, y:Float, width:Float, height:Float):Void
	{
		
	}
	
	public function process():Void 
	{
		
	}
	
}