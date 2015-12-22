package robotlegs.bender.extensions.stage3D.base.impl; 

import robotlegs.bender.extensions.contextView.ContextView;
import robotlegs.bender.extensions.stage3D.base.api.IRenderer;
import robotlegs.bender.framework.api.IContext;
/**
 * ...
 * @author P.J.Shand
 */
@:keepSub
class BaseInitializer 
{
	public var renderer:IRenderer;
	public var contextView:ContextView;
	public var context:IContext;
	private var _debug:Bool = false;
	public var debug(get, set):Bool;
	
	public function BaseInitializer() 
	{
		
	}
	
	public function init(renderer:IRenderer, contextView:ContextView, context:IContext):Void
	{
		this.renderer = renderer;
		this.contextView = contextView;
		this.context = context;
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