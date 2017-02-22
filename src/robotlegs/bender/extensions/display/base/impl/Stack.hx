package robotlegs.bender.extensions.display.base.impl;

import openfl.errors.Error;
import org.swiftsuspenders.utils.CallProxy;
//import robotlegs.bender.extensions.contextView.ContextView;
import robotlegs.bender.extensions.display.base.api.IRenderContext;
//import robotlegs.bender.extensions.display.base.api.IRenderer;
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

#if threejs
	import robotlegs.bender.extensions.display.webGL.threejs.impl.ThreeJsInitializer;
	import robotlegs.bender.extensions.display.webGL.threejs.impl.ThreeJsLayer;
#end

/**
 * ...
 * @author P.J.Shand
 * 
 */
@:rtti 
@:keepSub
class Stack implements IStack
{
	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/
	private var _injector:IInjector;
	private var _logger:ILogger;
	private var context:IContext;
	//private var _debug:Bool = false;
	//private var classIDs:Array<Array<Dynamic>>;
	//private var initialized:Bool = false;
	
	//public var debug(get, set):Bool;
	
	//@inject public var contextView:ContextView;
	//@inject public var renderer:IRenderer;
	@inject public var renderContext:IRenderContext;
	
	//@inject("optional=true") public var away3DInitializerAvailable:Away3DInitializerAvailable;
	//@inject("optional=true") public var starlingInitializerAvailable:StarlingInitializerAvailable;
	//@inject("optional=true") public var threeJsInitializerAvailable:ThreeJsInitializerAvailable;
	
	public var away3DInitializer:BaseInitializer;
	public var starlingInitializer:BaseInitializer;
	public var threeJsInitializer:BaseInitializer;
	
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
		
		#if threejs
			_injector.map(ThreeJsInitializer);
			threeJsInitializer = _injector.getInstance(ThreeJsInitializer);
		#end
		
		/*classIDs = new Array<Array<Dynamic>>();
		classIDs.push(["robotlegs.bender.extensions.display.stage3D.away3d.impl", "AwayStereoLayer", addAway3DAt]);
		classIDs.push(["robotlegs.bender.extensions.display.stage3D.away3d.impl", "AwayLayer", addAway3DAt]);
		classIDs.push(["robotlegs.bender.extensions.display.stage3D.starling.impl", "StarlingLayer", addStarlingAt]);
		classIDs.push(["robotlegs.bender.extensions.display.webGL.threejs.impl", "ThreeJsLayer", addThreeJsAt]);*/
		
	}
	
	//private function initialize():Void 
	//{
		//if (initialized) return;
		//initialized = true;
		//
		//
		////away3DInitializer = createInitializer("robotlegs.bender.extensions.stage3D.away3d.impl.Away3DInitializer");
		////trace(classIDs[0][0] + ".Away3DInitializer");
		///*trace(classIDs[1][0] + ".Away3DInitializer");
		//away3DInitializer = createInitializer(classIDs[0][0] + ".Away3DInitializer");
		//away3DInitializer = createInitializer(classIDs[1][0] + ".Away3DInitializer");
		//
		//starlingInitializer = createInitializer(classIDs[2][0] + ".StarlingInitializer");
		//threeJsInitializer = createInitializer(classIDs[3][0] + ".ThreeJsInitializer");*/
	//}
	
	/*private function createInitializer(classAlias:String):BaseInitializer 
	{
		var initializer:BaseInitializer;
		var InitializerClass:Class<Dynamic> = Type.resolveClass(classAlias);
		if (InitializerClass != null) {
			
			_injector.map(InitializerClass);
			initializer = _injector.getInstance(InitializerClass);
			return initializer;
		}
		return null;
	}*/

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/
	
	public function addLayer(LayerClass:Class<Dynamic>, id:String=""):Void
	{
		addLayerAt(LayerClass, -1, id);
	}
	
	public function addLayerAt(LayerClass:Class<Dynamic>, index:Int, id:String=""):Void
	{
		//preContextLayers.push( { LayerClass:LayerClass, index:index, id:id } );
		
		var addFunc = getAddFunc(LayerClass);
		if (addFunc != null) {
			addFunc(LayerClass, index, id);
		}
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
		
		#if threejs
			if (CheckClass(layerClass, ThreeJsLayer)) return addThreeJsAt;
		#end
		
		return null;
	}
	
	function CheckClass(layerClass:Class<Dynamic>, _Class:Class<Dynamic>):Bool
	{
		trace(layerClass);
		trace(_Class);
		
		trace(layerClass == _Class);
		
		
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
	
	private function addAway3DAt(AwayClass:Class<Dynamic>, index:Int, id:String=""):Void
	{
		away3DInitializer.addLayer(AwayClass, index, id);
	}
	
	private function addThreeJsAt(ThreeJSClass:Class<Dynamic>, index:Int, id:String=""):Void
	{
		threeJsInitializer.addLayer(ThreeJSClass, index, id);
	}
	
	private function addStarlingAt(StarlingLayerClass:Class<Dynamic>, index:Int, id:String=""):Void
	{
		starlingInitializer.addLayer(StarlingLayerClass, index, id);
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////
	
	//public function get_debug():Bool 
	//{
		//return _debug;
	//}
	//
	//public function set_debug(value:Bool):Bool 
	//{
		//_debug = value;
		//return value;
	//}
	//
	//private function errorMsg(index:Int):String 
	//{
		//return "errorMsg";
		////return "[" + classIDs[index][0] + "] needs to be installed before this method can be called, eg: context.install(" + classIDs[index][1] + ");";
	//}	
}

typedef LayerInfo =
{
	LayerClass:Class<Dynamic>,
	index:Int,
	id:String
}