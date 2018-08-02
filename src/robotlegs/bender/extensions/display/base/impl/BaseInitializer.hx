package robotlegs.bender.extensions.display.base.impl; 

import org.swiftsuspenders.utils.DescribedType;
import robotlegs.bender.extensions.contextView.ContextView;
import robotlegs.bender.extensions.display.base.api.ILayerInitializer;
import robotlegs.bender.extensions.display.base.api.ILayers;
import robotlegs.bender.extensions.display.base.api.IRenderContext;
import robotlegs.bender.extensions.display.base.api.IRenderer;
import robotlegs.bender.framework.api.IContext;
/**
 * ...
 * @author P.J.Shand
 */
class BaseInitializer implements DescribedType implements ILayerInitializer
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
	
	public function checkLayerType(ViewClass:Class<Dynamic>):Bool 
	{
		throw "Must override";
	}
	
	public function addLayer(ViewClass:Class<Dynamic>, index:Int, total:Int, id:String):Void 
	{
		throw "Must override";
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
	
	
	
	function CheckClass(layerClass:Class<Dynamic>, _Class:Class<Dynamic>):Bool
	{
		if (layerClass == _Class) return true;
		else {
			var superClass:Class<Dynamic> = Type.getSuperClass(layerClass);
			if (superClass == null) return false;
			else return CheckClass(superClass, _Class);
		}
	}
}