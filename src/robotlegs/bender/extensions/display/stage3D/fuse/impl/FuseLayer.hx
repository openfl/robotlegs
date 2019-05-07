package robotlegs.bender.extensions.display.stage3D.fuse.impl;

import fuse.Fuse;
import fuse.display.Sprite;
import org.swiftsuspenders.utils.DescribedType;
import robotlegs.bender.extensions.display.base.api.ILayer;
import robotlegs.bender.extensions.display.base.api.IRenderContext;
import robotlegs.bender.extensions.display.base.impl.Stack;
/**
 * ...
 * @author P.J.Shand
 */
class FuseLayer extends Sprite implements ILayer implements DescribedType
{
	public var active:Bool = true;
	private var fuse:Fuse;
	public var changeAvailable(get, null):Bool;
	@:isVar public var renderContext(get, set):IRenderContext;
	
	public function new() 
	{
		super();
	}
	
	public function process():Void
	{
		if (Stack.layerCount > 1) Fuse.current.cleanContext = true;
		else Fuse.current.cleanContext = false;
		
		if (fuse != null /*&& renderContext.active*/) {
			fuse.process();
		}
	}
	
	public function snap():Void
	{
        process();
    }
	
	public function setFuse(fuse:Fuse):Void
	{
		this.fuse = fuse;
	}
	
	public function setTo(x:Float, y:Float, width:Float, height:Float):Void
	{
		//trace([x, y, width, height]);
		//fuse.viewPort.setTo(x, y, width, height);
		fuse.stage.updateDimensions(Math.floor(width), Math.floor(height));
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
		//#if air
			if (Fuse.skipUnchangedFrames) {
				return Fuse.current.conductorData.changeAvailable == 1;
			}
			else return true;
		//#else
		//	return true;
		//#end
	}
}