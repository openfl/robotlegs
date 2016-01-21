package robotlegs.bender.extensions.stage3D.starling.impl;

import openfl.geom.Rectangle;
import robotlegs.bender.extensions.stage3D.base.impl.BaseInitializer;
import robotlegs.bender.extensions.stage3D.base.impl.Viewport;
import robotlegs.bender.extensions.stage3D.starling.impl.StarlingCollection;
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
	public function new() 
	{
		
	}
	
	override public function addLayer(ViewClass:Class<Dynamic>, index:Int, id:String):Void 
	{
		//var viewRectangle:Rectangle = new Rectangle(0,0, Viewport.width, Viewport.height);
		var viewRectangle:Rectangle = new Rectangle(0,0, contextView.view.stage.stageWidth, contextView.view.stage.stageHeight);
		if (id == "") id = autoID(ViewClass);
		
		if (Starling.current == null){
			Starling.multitouchEnabled = true;// DeviceInfo.isMobile ? true:false; // for Multitouch Scene
			Starling.handleLostContext = true; // recommended everwhere when using AssetManager
		}
		
		/*if (renderer.stage3D.context3D == null && renderer.context3D != null) {
			renderer.stage3D.context3D = renderer.context3D;
		}*/
		
		var starling:Starling = new Starling(ViewClass, contextView.view.stage, viewRectangle, renderer.stage3D, "auto", renderer.profile);
		starling.simulateMultitouch = true;
		//starling.enableErrorChecking = Capabilities.isDebugger;
		starling.shareContext = true;
		starling.start();
		
		if (debug) starling.showStats = true;
		
		context.configure(new StarlingCollection([starling, id]));
		
		var placeHolderLayer:PlaceHolderLayer = new PlaceHolderLayer();
		if (index == -1) renderer.addLayer(placeHolderLayer);
		else renderer.addLayerAt(placeHolderLayer, index);
		var insertIndex:Int = renderer.getLayerIndex(placeHolderLayer);
		
		var onStarlingReady = function(e:Event):Void 
		{
			var starling:Starling = cast(e.target, Starling);
			var layer:StarlingLayer = cast (starling.root, StarlingLayer);
			layer.setStarling(starling);
			renderer.removeLayer(placeHolderLayer);
			renderer.addLayerAt(layer, insertIndex);
		}
		
		starling.addEventListener(Event.ROOT_CREATED, onStarlingReady);
	}
}