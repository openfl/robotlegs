package robotlegs.bender.extensions.display.stage3D.fuse.impl;

import flash.display3D.Context3DRenderMode;
import fuse.Fuse;
import fuse.core.front.FuseConfig;
import fuse.events.FuseEvent;
import openfl.events.Event;
import robotlegs.bender.extensions.display.base.impl.BaseInitializer;

/**
 * ...
 * @author P.J.Shand
 */
class FuseInitializer extends BaseInitializer
{
	var onFuseReady:Event->Void;
	public static var multitouchEnabled:Bool = true;
	
	public function new() 
	{
		
	}
	
	override public function checkLayerType(ViewClass:Class<Dynamic>):Bool 
	{
		return CheckClass(ViewClass, FuseLayer);
	}
	
	override public function addLayer(ViewClass:Class<Dynamic>, index:Int, total:Int, id:String):Void 
	{
		var fuseConfig:FuseConfig = { frameRate:60 };
		fuseConfig.useCacheLayers = true;
		fuseConfig.debugTextureAtlas = false;
		fuseConfig.debugSkipRender = false;
		
		var stage3DRenderContext:Stage3DRenderContext = cast renderContext;
		
		var fuse:Fuse = new Fuse(
			untyped ViewClass, 
			fuseConfig, 
			stage3DRenderContext.stage3D, 
			Context3DRenderMode.AUTO,
			[stage3DRenderContext.profile]
		);
		
		var fuseCollection:FuseCollection = new FuseCollection([fuse, id]);
		context.configure(fuseCollection);
		
		var placeHolderLayer:PlaceHolderLayer = new PlaceHolderLayer();
		if (index == -1) layers.addLayer(placeHolderLayer);
		else layers.addLayerAt(placeHolderLayer, index);
		var insertIndex:Int = layers.getLayerIndex(placeHolderLayer);
		
		onFuseReady = function(e:Event):Void 
		{
			var layer:FuseLayer = cast (Fuse.current.root, FuseLayer);
			layer.setFuse(fuse);
			layers.removeLayer(placeHolderLayer);
			layers.addLayerAt(layer, insertIndex);
		}
		
		fuse.addEventListener(FuseEvent.ROOT_CREATED, onFuseReady);
		fuse.init();
	}
}