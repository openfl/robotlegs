package robotlegs.bender.extensions.stage3D.away3d.impl;

import openfl.events.Event;
import org.swiftsuspenders.utils.CallProxy;
import robotlegs.bender.extensions.stage3D.away3d.impl.AwayCollection;
import robotlegs.bender.extensions.stage3D.base.impl.BaseInitializer;
/**
 * ...
 * @author P.J.Shand
 */
@:rtti
@:keepSub
class Away3DInitializer extends BaseInitializer
{
	
	public function new() 
	{
		
	}
	
	override public function addLayer(ViewClass:Class<Dynamic>, index:Int, id:String):Void
	{
		if (id == "") id = autoID(ViewClass);
		var awayLayer:AwayLayer = CallProxy.createInstance(ViewClass, [renderer.profile]);
		awayLayer.iRenderer = renderer;
		
		var awayCollection = new AwayCollection([awayLayer, id]);
		context.configure([awayCollection]);
		contextView.view.addChild(awayLayer);
		
		if (index == -1) renderer.addLayer(awayLayer);
		else renderer.addLayerAt(awayLayer, index);
	}
}