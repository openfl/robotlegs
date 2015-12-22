package robotlegs.bender.extensions.stage3D.starling.impl;

import openfl.geom.Rectangle;
import robotlegs.bender.extensions.stage3D.base.api.ILayer;
import robotlegs.bender.extensions.stage3D.base.api.IRenderer;
import starling.core.Starling;
import starling.display.Sprite;
/**
 * ...
 * @author P.J.Shand
 */
@:rtti
@:keepSub
class StarlingLayer extends Sprite implements ILayer
{
	private var _iRenderer:IRenderer;
	private var starling:Starling;
	
	public var rect(null, set):Rectangle;
	public var iRenderer(get, set):IRenderer;
	
	public function new() 
	{
		super();
	}
	
	public function process():Void
	{
		if (starling != null) starling.nextFrame();
	}
	
	public function setStarling(starling:Starling):Void
	{
		this.starling = starling;
	}
	
	public function set_rect(rect:Rectangle):Rectangle
	{
		starling.viewPort.setTo(rect.x, rect.y, rect.width, rect.height);
		starling.stage.stageWidth = cast rect.width;
		starling.stage.stageHeight = cast rect.height;
		return rect;
	}
	
	public function set_iRenderer(value:IRenderer):IRenderer 
	{
		return _iRenderer = value;
	}
	
	public function get_iRenderer():IRenderer 
	{
		return _iRenderer;
	}
}