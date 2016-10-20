package robotlegs.bender.extensions.display.webGL.threejs.impl;

import openfl.events.Event;
import org.swiftsuspenders.utils.CallProxy;
import robotlegs.bender.extensions.display.stage3D.away3d.impl.AwayCollection;
import robotlegs.bender.extensions.display.base.impl.BaseInitializer;
/**
 * ...
 * @author P.J.Shand
 */
@:rtti
@:keepSub
class ThreeJsInitializer extends BaseInitializer
{
	
	public function new() 
	{
		
	}
	
	override public function addLayer(ViewClass:Class<Dynamic>, index:Int, id:String):Void
	{
		if (id == "") id = autoID(ViewClass);
		var threeJsLayer:ThreeJsLayer = CallProxy.createInstance(ViewClass, []);
		threeJsLayer.renderContext = renderContext;
		
		var threeJsCollection = new ThreeJsCollection([threeJsLayer, id]);
		context.configure([threeJsCollection]);
		contextView.view.addChild(threeJsLayer);
		
		if (index == -1) layers.addLayer(threeJsLayer);
		else layers.addLayerAt(threeJsLayer, index);
	}
}