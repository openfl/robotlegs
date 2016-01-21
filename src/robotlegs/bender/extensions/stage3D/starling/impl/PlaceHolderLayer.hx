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
	
	public var _rect:Rectangle;
	public var rect(null, set):Rectangle;
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
	
	public function get_rect():Rectangle 
	{
		return _rect;
	}
	
	public function set_rect(value:Rectangle):Rectangle 
	{
		return _rect = value;
	}
	
	public function process():Void 
	{
		
	}
	
}