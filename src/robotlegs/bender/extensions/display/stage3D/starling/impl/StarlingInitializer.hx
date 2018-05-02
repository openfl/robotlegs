package robotlegs.bender.extensions.display.stage3D.starling.impl;

import flash.display3D.Context3DRenderMode;
import openfl.geom.Rectangle;
import robotlegs.bender.extensions.display.base.impl.BaseInitializer;
import robotlegs.bender.extensions.display.base.impl.Viewport;
import robotlegs.bender.extensions.display.stage3D.starling.impl.StarlingCollection;
import starling.core.Starling;
import starling.events.Event;

#if !starling_1_x
import starling.rendering.Painter;
#end

/**
 * ...
 * @author P.J.Shand
 */
class StarlingInitializer extends BaseInitializer
{
	public static var multitouchEnabled:Bool = true;
	
	public function new() 
	{
		if (Starling.current == null){
			Starling.multitouchEnabled = multitouchEnabled;
		}
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
		var profile:String = stage3DRenderContext.profile;
		
		var starling:Starling = new Starling(
			cast ViewClass, 
			contextView.view.stage, 
			viewRectangle, 
			stage3DRenderContext.stage3D, 
			Context3DRenderMode.AUTO, 
			profile
		#if !starling_1_x	,true #end
		);
		#if !starling_1_x
		starling.skipUnchangedFrames = true;
		#end
		starling.simulateMultitouch = true;
		//starling.enableErrorChecking = Capabilities.isDebugger;
		starling.shareContext = true;
		starling.start();
		
		#if !starling_1_x
		Painter.DEFAULT_STENCIL_VALUE = 0;
		#end
		
		//if (debug) starling.showStats = true;
		
		context.configure(new StarlingCollection(starling, id));
		
		var placeHolderLayer:PlaceHolderLayer = new PlaceHolderLayer();
		if (index == -1) layers.addLayer(placeHolderLayer);
		else layers.addLayerAt(placeHolderLayer, index);
		var insertIndex:Int = layers.getLayerIndex(placeHolderLayer);
		
		var onStarlingReady = function(e:Event):Void 
		{
			var starling:Starling = cast(e.target, Starling);
			#if debug
				//starling.showStats = true;
			#end
			var layer:StarlingLayer = cast (starling.root, StarlingLayer);
			layer.setStarling(starling);
			layers.removeLayer(placeHolderLayer);
			layers.addLayerAt(layer, insertIndex);
		}
		
		starling.addEventListener(Event.ROOT_CREATED, onStarlingReady);
	}
}