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
	
	public var iRenderer(get, set):IRenderer;
	
	public function new() 
	{
		super();
	}
	
	public function process():Void
	{
		if (starling != null && _iRenderer.active) starling.nextFrame();
	}
	
	public function setStarling(starling:Starling):Void
	{
		this.starling = starling;
	}
	
	public function setTo(x:Float, y:Float, width:Float, height:Float):Void
	{
		starling.viewPort.setTo(x, y, width, height);
		starling.stage.stageWidth = cast width;
		starling.stage.stageHeight = cast height;
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