package robotlegs.bender.extensions.display.base.impl;


import org.swiftsuspenders.utils.DescribedType;
import robotlegs.bender.extensions.display.base.api.ILayers;
import robotlegs.bender.extensions.display.base.api.IRenderContext;
import robotlegs.bender.extensions.display.base.api.IStack;
import robotlegs.bender.framework.api.IInjector;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.ILogger;

#if away3d
	import robotlegs.bender.extensions.display.stage3D.away3d.impl.Away3DInitializer;
	import robotlegs.bender.extensions.display.stage3D.away3d.impl.AwayLayer;
	import robotlegs.bender.extensions.display.stage3D.away3d.impl.AwayStereoLayer;
#end

#if starling
	import robotlegs.bender.extensions.display.stage3D.starling.impl.StarlingInitializer;
	import robotlegs.bender.extensions.display.stage3D.starling.impl.StarlingLayer;
#end

#if fuse
	import fuse.Fuse;
	import robotlegs.bender.extensions.display.stage3D.fuse.impl.FuseInitializer;
	import robotlegs.bender.extensions.display.stage3D.fuse.impl.FuseLayer;
#end

#if threejs
	import robotlegs.bender.extensions.display.webGL.threejs.impl.ThreeJsInitializer;
	import robotlegs.bender.extensions.display.webGL.threejs.impl.ThreeJsLayer;
#end

/**
 * ...
 * @author P.J.Shand
 * 
 */
class Stack extends DescribedType implements IStack
{
	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/
	private var _injector:IInjector;
	private var _logger:ILogger;
	private var context:IContext;
	
	@inject public var renderContext:IRenderContext;
	@inject public var layers:ILayers;
	
	public var away3DInitializer:BaseInitializer;
	public var starlingInitializer:BaseInitializer;
	public var threeJsInitializer:BaseInitializer;
	public var fuseInitializer:BaseInitializer;
	
	public var layerCount:Int = 0;
	
	//private var preContextLayers:Array<LayerInfo> = [];
	
	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/
	public function new(context:IContext)
	{
		this.context = context;
		_injector = context.injector;
		_logger = context.getLogger(this);
		
		#if away3d
			_injector.map(Away3DInitializer);
			away3DInitializer = _injector.getInstance(Away3DInitializer);
		#end
		
		#if starling
			_injector.map(StarlingInitializer);
			starlingInitializer = _injector.getInstance(StarlingInitializer);
		#end
		
		#if fuse
			_injector.map(FuseInitializer);
			fuseInitializer = _injector.getInstance(FuseInitializer);
		#end
		
		#if threejs
			_injector.map(ThreeJsInitializer);
			threeJsInitializer = _injector.getInstance(ThreeJsInitializer);
		#end
	}
	
	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/
	
	public function addLayer(LayerClass:Class<Dynamic>, id:String=""):Void
	{
		addLayerAt(LayerClass, -1, id);
	}
	
	public function addLayerAt(LayerClass:Class<Dynamic>, index:Int, id:String=""):Void
	{
		var addFunc = getAddFunc(LayerClass);
		if (addFunc != null) {
			addFunc(LayerClass, index, id);
		}
		layerCount++;
		#if fuse
			trace("layerCount = " + layerCount);
			//if (Fuse.current != null){
				//if (layerCount > 1) {
					//Fuse.current.cleanContext = true;
				//}
				//else {
					//Fuse.current.cleanContext = false;
				//}
			//}
		#end
	}
	
	public function removeLayerAt(index:Int):Void
	{
		layers.removeLayerAt(index);
	}
	
	function getAddFunc(layerClass:Class<Dynamic>):Class<Dynamic> -> Int -> String -> Void 
	{
		#if away3d
			if (CheckClass(layerClass, AwayLayer) || CheckClass(layerClass, AwayStereoLayer))
				return addAway3DAt;
		#end
		
		#if starling
			if (CheckClass(layerClass, StarlingLayer)) return addStarlingAt;
		#end
		
		#if fuse
			if (CheckClass(layerClass, FuseLayer)) return addFuseAt;
		#end
		
		#if threejs
			if (CheckClass(layerClass, ThreeJsLayer)) return addThreeJsAt;
		#end
		
		return null;
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
	
	/*============================================================================*/
	/* Private Functions                                                           */
	/*============================================================================*/
	#if away3d
	private function addAway3DAt(AwayClass:Class<Dynamic>, index:Int, id:String=""):Void
	{
		away3DInitializer.addLayer(AwayClass, index, id);
	}
	#end
	
	#if starling
	private function addStarlingAt(StarlingLayerClass:Class<Dynamic>, index:Int, id:String=""):Void
	{
		starlingInitializer.addLayer(StarlingLayerClass, index, id);
	}
	#end
	
	#if fuse
	private function addFuseAt(FuseLayerClass:Class<Dynamic>, index:Int, id:String=""):Void
	{
		fuseInitializer.addLayer(FuseLayerClass, index, id);
	}
	#end
	
	#if threejs
	private function addThreeJsAt(ThreeJSClass:Class<Dynamic>, index:Int, id:String=""):Void
	{
		threeJsInitializer.addLayer(ThreeJSClass, index, id);
	}
	#end	
}

typedef LayerInfo =
{
	LayerClass:Class<Dynamic>,
	index:Int,
	id:String
}