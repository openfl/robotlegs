package robotlegs.bender.extensions.display.webGL.threejs.impl;

import org.swiftsuspenders.utils.CallProxy;
import robotlegs.bender.extensions.display.base.impl.BaseInitializer;
/**
 * ...
 * @author P.J.Shand
 */
class ThreeJsInitializer extends BaseInitializer
{
	
	public function new() 
	{
		
	}
	
	override public function checkLayerType(ViewClass:Class<Dynamic>):Bool 
	{
		return CheckClass(ViewClass, ThreeJsLayer);
	}
	
	override public function addLayer(ViewClass:Class<Dynamic>, index:Int, total:Int, id:String):Void
	{
		if (id == "") id = autoID(ViewClass);
		var threeJsLayer:ThreeJsLayer = Type.createInstance(ViewClass, []);
		threeJsLayer.renderContext = renderContext;
		
		var threeJsCollection = new ThreeJsCollection([threeJsLayer, id]);
		context.configure(threeJsCollection);
		contextView.view.addChild(threeJsLayer);
		
		if (index == -1) layers.addLayer(threeJsLayer);
		else layers.addLayerAt(threeJsLayer, index);
	}
}