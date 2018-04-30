package robotlegs.bender.extensions.display.stage3D.fuse.impl;

import fuse.Fuse;
import fuse.display.Sprite;
import openfl.geom.Rectangle;
import robotlegs.bender.extensions.display.base.api.ILayer;
import robotlegs.bender.extensions.display.base.api.IRenderContext;
import robotlegs.bender.extensions.display.base.api.IRenderer;
/**
 * ...
 * @author P.J.Shand
 */
@:build(org.swiftsuspenders.macros.ReflectorMacro.check())
@:autoBuild(org.swiftsuspenders.macros.ReflectorMacro.check())
class FuseLayer extends Sprite implements ILayer
{
	public var active:Bool = true;
	private var fuse:Fuse;
	@:isVar public var renderContext(get, set):IRenderContext;
	
	public function new() 
	{
		super();
	}
	
	public function process():Void
	{
		if (fuse != null /*&& renderContext.active*/) {
			fuse.process();
		}
	}
	
	public function setFuse(fuse:Fuse):Void
	{
		this.fuse = fuse;
	}
	
	public function setTo(x:Float, y:Float, width:Float, height:Float):Void
	{
		//trace([x, y, width, height]);
		//fuse.viewPort.setTo(x, y, width, height);
		fuse.stage.stageWidth = Math.floor(width);
		fuse.stage.stageHeight = Math.floor(height);
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