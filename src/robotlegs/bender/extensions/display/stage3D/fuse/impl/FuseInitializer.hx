package robotlegs.bender.extensions.display.stage3D.fuse.impl;

import flash.display3D.Context3DRenderMode;
import fuse.Fuse;
import fuse.core.front.FuseConfig;
import fuse.events.FuseEvent;
import openfl.events.Event;
import openfl.geom.Rectangle;
import robotlegs.bender.extensions.display.base.impl.BaseInitializer;
import robotlegs.bender.extensions.display.base.impl.Viewport;

/**
 * ...
 * @author P.J.Shand
 */
@:rtti
@:keepSub
class FuseInitializer extends BaseInitializer
{
	var onFuseReady:Event->Void;
	//private static var fuseCollection:FuseCollection;
	public static var multitouchEnabled:Bool = true;
	
	public function new() 
	{
		
	}
	
	override public function addLayer(ViewClass:Class<Dynamic>, index:Int, id:String):Void 
	{
		trace("addLayer");
		
		var fuseConfig:FuseConfig = { frameRate:60 };
		fuseConfig.useCacheLayers = true;
		fuseConfig.debugTextureAtlas = false;
		fuseConfig.debugSkipRender = false;
		
		var stage3DRenderContext:Stage3DRenderContext = cast renderContext;
		
		var fuse:Fuse = new Fuse(untyped ViewClass, fuseConfig, stage3DRenderContext.stage3D);
		
		//fuse.start();
		
		////var viewRectangle:Rectangle = new Rectangle(0,0, Viewport.width, Viewport.height);
		//var viewRectangle:Rectangle = new Rectangle(0,0, contextView.view.stage.stageWidth, contextView.view.stage.stageHeight);
		//if (id == "") id = autoID(ViewClass);
		//
		//if (Fuse.current == null){
			//Fuse.multitouchEnabled = multitouchEnabled;// true;// DeviceInfo.isMobile ? true:false; // for Multitouch Scene
			////Fuse.handleLostContext = true; // recommended everwhere when using AssetManager
		//}
		//
		///*if (renderer.stage3D.context3D == null && renderer.context3D != null) {
			//renderer.stage3D.context3D = renderer.context3D;
		//}*/
		//
		//
		//
		//var fuse:Fuse = new Fuse(cast ViewClass, contextView.view.stage, viewRectangle, stage3DRenderContext.stage3D, Context3DRenderMode.AUTO, stage3DRenderContext.profile);
		//fuse.simulateMultitouch = true;
		////fuse.enableErrorChecking = Capabilities.isDebugger;
		//fuse.shareContext = true;
		//fuse.start();
		//
		//if (debug) fuse.showStats = true;
		//
		////if (fuseCollection == null) {
			var fuseCollection:FuseCollection = new FuseCollection([fuse, id]);
			context.configure(fuseCollection);
		////}
		////else {
		////	fuseCollection.addItem(fuse, id);
		////}
		//
		var placeHolderLayer:PlaceHolderLayer = new PlaceHolderLayer();
		if (index == -1) layers.addLayer(placeHolderLayer);
		else layers.addLayerAt(placeHolderLayer, index);
		var insertIndex:Int = layers.getLayerIndex(placeHolderLayer);
		
		onFuseReady = function(e:Event):Void 
		{
			trace("onFuseReady");
			//var fuse:Fuse = cast(e.target, Fuse);
			//#if debug
			//	fuse.showStats = true;
			//#end
			
			var layer:FuseLayer = cast (Fuse.current.root, FuseLayer);
			layer.setFuse(fuse);
			layers.removeLayer(placeHolderLayer);
			layers.addLayerAt(layer, insertIndex);
		}
		
		
		fuse.addEventListener(FuseEvent.ROOT_CREATED, onFuseReady);
		trace("WAIT");
		
		fuse.init();
	}
}