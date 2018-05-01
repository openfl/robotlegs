package robotlegs.bender.extensions.display.stage3D.starling.impl;

import openfl.display3D.Context3DBlendFactor;
import openfl.geom.Rectangle;
import org.swiftsuspenders.utils.DescribedType;
import robotlegs.bender.extensions.display.base.api.ILayer;
import robotlegs.bender.extensions.display.base.api.IRenderContext;
import robotlegs.bender.extensions.display.base.api.IRenderer;
import starling.core.Starling;
import starling.display.Sprite;
/**
 * ...
 * @author P.J.Shand
 */
class StarlingLayer extends Sprite implements ILayer implements DescribedType
{
	public var active:Bool = true;
	private var starling:Starling;
	public var changeAvailable(get, null):Bool;
	@:isVar public var renderContext(get, set):IRenderContext;
	
	public function new() 
	{
		super();
	}
	
	public function process():Void
	{
		if (starling != null /*&& renderContext.active*/) {
			starling.nextFrame();
		}
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
	
	public function set_renderContext(value:IRenderContext):IRenderContext 
	{
		return renderContext = value;
	}
	
	public function get_renderContext():IRenderContext 
	{
		return renderContext;
	}
	
	function get_changeAvailable():Bool 
	{
		return true;
	}
}