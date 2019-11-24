package robotlegs.bender.extensions.display.base.impl;


import haxe.Timer;
import org.swiftsuspenders.utils.DescribedType;
import robotlegs.bender.extensions.display.base.api.ILayerInitializer;
import robotlegs.bender.extensions.display.base.api.ILayers;
import robotlegs.bender.extensions.display.base.api.IStack;
import robotlegs.bender.framework.api.IInjector;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.ILogger;

/**
 * ...
 * @author P.J.Shand
 * 
 */
class Stack implements DescribedType implements IStack
{
	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/
	private var _injector:IInjector;
	private var _logger:ILogger;
	private var context:IContext;
	private var initializers:Array<ILayerInitializer> = [];
	
	@inject public var layers:ILayers;
	
	public static var layerCount:Int = 0;
	
	private var preContextLayers:Array<LayerInfo> = [];
	private var setupTimer:Timer;
	
	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/
	public function new(context:IContext)
	{
		this.context = context;
		_injector = context.injector;
		_logger = context.getLogger(this);
		
		#if away3d
			addInitializerType(robotlegs.bender.extensions.display.stage3D.away3d.impl.Away3DInitializer);
		#end
		
		#if starling
			addInitializerType(robotlegs.bender.extensions.display.stage3D.starling.impl.StarlingInitializer);
		#end
		
		#if fuse
			addInitializerType(robotlegs.bender.extensions.display.stage3D.fuse.impl.FuseInitializer);
		#end
		
		#if threejs
			addInitializerType(robotlegs.bender.extensions.display.webGL.threejs.impl.ThreeJsInitializer);
		#end
	}
	
	inline public function addInitializerType(type:Class<ILayerInitializer>) 
	{
		_injector.map(type);
		var initializer:ILayerInitializer = _injector.getInstance(type);
		initializers.push(initializer);
	}
	public function addInitializer(initializer:ILayerInitializer) 
	{
		initializers.push(initializer);
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
		preContextLayers.push( { LayerClass:LayerClass, index:index, id:id } );
		layerCount++;
		
		if(setupTimer == null) setupTimer = Timer.delay(setupLayers, 1);
	}
	
	function setupLayers() 
	{
		setupTimer = null;
		
		for(layerInfo in preContextLayers){
			var initializer = getInitializer(layerInfo.LayerClass);
			if (initializer == null){
				throw "Can't find initializer for class " + Type.getClassName(layerInfo.LayerClass);
			}
			
			initializer.addLayer(layerInfo.LayerClass, layerInfo.index, layerCount, layerInfo.id);
		}
		preContextLayers = [];
	}
	
	public function removeLayerAt(index:Int):Void
	{
		layers.removeLayerAt(index);
	}
	
	function getInitializer(layerClass:Class<Dynamic>):ILayerInitializer 
	{
		for (initializer in initializers){
			if (initializer.checkLayerType(layerClass)){
				return initializer;
			}
		}
		return null;
	}
}

typedef LayerInfo =
{
	LayerClass:Class<Dynamic>,
	index:Int,
	id:String
}