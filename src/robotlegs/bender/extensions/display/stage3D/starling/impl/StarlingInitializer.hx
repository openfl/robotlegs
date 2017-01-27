package robotlegs.bender.extensions.display.stage3D.starling.impl;

import flash.display3D.Context3DRenderMode;
import openfl.geom.Rectangle;
import robotlegs.bender.extensions.display.base.impl.BaseInitializer;
import robotlegs.bender.extensions.display.base.impl.Viewport;
import robotlegs.bender.extensions.display.stage3D.starling.impl.StarlingCollection;
import starling.core.Starling;
import starling.events.Event;

/**
 * ...
 * @author P.J.Shand
 */
@:rtti
@:keepSub
class StarlingInitializer extends BaseInitializer
{
	//private static var starlingCollection:StarlingCollection;
	public static var multitouchEnabled:Bool = true;
	
	public function new() 
	{
		
	}
	
	override public function addLayer(ViewClass:Class<Dynamic>, index:Int, id:String):Void 
	{
		var stage3DRenderContext:Stage3DRenderContext = cast renderContext;
		//var viewRectangle:Rectangle = new Rectangle(0,0, Viewport.width, Viewport.height);
		var viewRectangle:Rectangle = new Rectangle(0,0, contextView.view.stage.stageWidth, contextView.view.stage.stageHeight);
		if (id == "") id = autoID(ViewClass);
		
		if (Starling.current == null){
			Starling.multitouchEnabled = multitouchEnabled;// true;// DeviceInfo.isMobile ? true:false; // for Multitouch Scene
			//Starling.handleLostContext = true; // recommended everwhere when using AssetManager
		}
		
		/*if (renderer.stage3D.context3D == null && renderer.context3D != null) {
			renderer.stage3D.context3D = renderer.context3D;
		}*/
		
		
		
		var starling:Starling = new Starling(cast ViewClass, contextView.view.stage, viewRectangle, stage3DRenderContext.stage3D, Context3DRenderMode.AUTO, stage3DRenderContext.profile);
		starling.simulateMultitouch = true;
		//starling.enableErrorChecking = Capabilities.isDebugger;
		starling.shareContext = true;
		starling.start();
		
		if (debug) starling.showStats = true;
		
		//if (starlingCollection == null) {
			var starlingCollection:StarlingCollection = new StarlingCollection([starling, id]);
			context.configure(starlingCollection);
		//}
		//else {
		//	starlingCollection.addItem(starling, id);
		//}
		
		var placeHolderLayer:PlaceHolderLayer = new PlaceHolderLayer();
		if (index == -1) layers.addLayer(placeHolderLayer);
		else layers.addLayerAt(placeHolderLayer, index);
		var insertIndex:Int = layers.getLayerIndex(placeHolderLayer);
		
		var onStarlingReady = function(e:Event):Void 
		{
			var starling:Starling = cast(e.target, Starling);
			#if debug
				starling.showStats = true;
			#end
			var layer:StarlingLayer = cast (starling.root, StarlingLayer);
			layer.setStarling(starling);
			layers.removeLayer(placeHolderLayer);
			layers.addLayerAt(layer, insertIndex);
		}
		
		starling.addEventListener(Event.ROOT_CREATED, onStarlingReady);
	}
}