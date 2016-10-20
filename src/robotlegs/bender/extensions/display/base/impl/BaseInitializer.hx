package robotlegs.bender.extensions.display.base.impl; 

import robotlegs.bender.extensions.contextView.ContextView;
import robotlegs.bender.extensions.display.base.api.ILayers;
import robotlegs.bender.extensions.display.base.api.IRenderContext;
import robotlegs.bender.extensions.display.base.api.IRenderer;
import robotlegs.bender.framework.api.IContext;
/**
 * ...
 * @author P.J.Shand
 */
@:rtti
@:keepSub
class BaseInitializer 
{
	@inject public var renderer:IRenderer;
	@inject public var renderContext:IRenderContext;
	@inject public var contextView:ContextView;
	@inject public var context:IContext;
	@inject public var layers:ILayers;
	private var _debug:Bool = false;
	public var debug(get, set):Bool;
	
	public function BaseInitializer() 
	{
		
	}
	
	public function addLayer(ViewClass:Class<Dynamic>, index:Int, id:String):Void 
	{
		
	}
	
	private function autoID(ClassName:Class<Dynamic>):String 
	{
		// FIX
		/*var xml:XML = describeType(ClassName);
		var className:String = xml.@name;
		if (className.indexOf("::") == -1) return className;
		else return className.split("::")[1];*/
		return "" + (Math.random() * 1000);
	}
	
	public function set_debug(value:Bool):Bool 
	{
		_debug = value;
		return value;
	}
	
	public function get_debug():Bool 
	{
		return _debug;
	}
}