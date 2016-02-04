package robotlegs.bender.extensions.stage3D.base.impl;

import msignal.Signal.Signal0;
import openfl.display.Stage3D;
import openfl.display3D.Context3D;
import openfl.display3D.Context3DCompareMode;
import openfl.display3D.Context3DRenderMode;
import openfl.display3D.Context3DStencilAction;
import openfl.display3D.Context3DTriangleFace;
import openfl.errors.Error;
import openfl.events.Event;
import robotlegs.bender.extensions.contextView.ContextView;
import robotlegs.bender.extensions.stage3D.base.api.ILayer;
import robotlegs.bender.extensions.stage3D.base.api.IRenderer;
import robotlegs.bender.extensions.stage3D.base.api.IViewport;
import robotlegs.bender.framework.api.IInjector;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.ILogger;

/**
 * ...
 * @author P.J.Shand
 * 
 */
@:rtti
@:keepSub
class Renderer implements IRenderer
{
	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/
	private var _injector:IInjector;
	private var _logger:ILogger;
	private var _onReady:Signal0 = new Signal0();
	private var _onActiveChange:Signal0 = new Signal0();
	
	@inject public var contextView:ContextView;
	@inject public var viewport:IViewport;
	
	private var layers = new Array<ILayer>();
	//private var stage3DManager:Stage3DManager;
	//private var _stage3DProxy:Stage3DProxy;
	private var _profile:Dynamic;
	private var freeFreeStage3DIndex:Int = 0;
	private var _stage3D:Stage3D;
	private var _context3D:Context3D;
	public var antiAlias:Int;
	
	private var _active:Bool = true;
	public var active(get, set):Bool;
	
	public var onActiveChange(get, null):Signal0;
	
	public var onReady(get, null):Signal0;
	public var stage3D(get, null):Stage3D;
	public var context3D(get, null):Context3D;
	
	public var profile(get, null):String;
	public var numLayers(get, null):Int;
	
	private static var count:Int = -1;
	private var index:Int = 0;
	
	private var random:Int;
	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/
	public function new(context:IContext)
	{
		count++;
		index = count;
		random = Math.round(Math.random() * 10000);
		
		_injector = context.injector;
		_logger = context.getLogger(this);
	}
	
	public function init(profile:Dynamic, antiAlias:Int=0):Void
	{
		this.antiAlias = antiAlias;
		_profile = profile;
		
		_stage3D = contextView.view.stage.stage3Ds[freeFreeStage3DIndex];
		_stage3D.x = Math.random() * 2000;
		stage3D.addEventListener(Event.CONTEXT3D_CREATE, contextCreatedHandler);
		
		var renderMode:Context3DRenderMode = Context3DRenderMode.AUTO;
        
		#if flash
			stage3D.requestContext3D(renderMode, _profile);
		#else
			stage3D.requestContext3D(Std.string(renderMode));
		#end
		freeFreeStage3DIndex++;
	}
	
	private function contextCreatedHandler(e:Event):Void 
	{
		_context3D = stage3D.context3D;
		context3D.configureBackBuffer(contextView.view.stage.stageWidth, contextView.view.stage.stageHeight, antiAlias, true);
		
		context3D.setStencilActions(
			cast Context3DTriangleFace.FRONT_AND_BACK,
			cast Context3DCompareMode.EQUAL, 
			cast Context3DStencilAction.DECREMENT_SATURATE
		);
		
		viewport.init();
		viewport.onChange.add(OnViewportChange);
		viewport.rect.setTo(0, 0, contextView.view.stage.stageWidth, contextView.view.stage.stageHeight);
		
		_onReady.dispatch();
	}
	
	private function OnViewportChange():Void 
	{
		stage3D.x = viewport.rect.x;
		stage3D.y = viewport.rect.y;
		
		if (context3D != null) {
			var width:Int = cast viewport.rect.width;
			if (width < 32) width = 32;
			var height:Int = cast viewport.rect.height;
			if (height < 32) height = 32;
			try {
				context3D.configureBackBuffer(width, height, antiAlias, true);
			}
			catch (e:Error) {
				trace("e = " + e);
			}
		}
		
		for (i in 0...layers.length)
		{
			layers[i].rect = viewport.rect;
		}
	}
	
	public function start():Void
	{
		trace("start" + " : " + random);
		contextView.view.stage.addEventListener(Event.ENTER_FRAME, Update);
	}
	
	public function stop():Void
	{
		contextView.view.stage.removeEventListener(Event.ENTER_FRAME, Update);
	}
	
	public function addLayer(layer:ILayer):Void
	{
		layer.iRenderer = this;
		layers.push(layer);
	}
	
	public function addLayerAt(layer:ILayer, index:Int):Void
	{
		layer.iRenderer = this;
		if (layers.length < index) {
			trace("[Renderer, addLayerAt], index outside bounds, reverting to addLayer");
			addLayer(layer);
			return;
		}
		
		//layers.splice(index, 0, layer);
		
		if (index == layers.length) {
			layers.push(layer);
			return;
		}
		// CHECK
		var copyLayers = layers.copy();
		layers = new Array<ILayer>();
		for (i in 0...copyLayers.length) 
		{
			if (i == index) {
				layers.push(layer);
			}
			layers.push(copyLayers[i]);
		}
	}
	
	public function removeLayer(layer:ILayer):Void
	{
		layer.iRenderer = null;
		for (i in 0...layers.length) 
		{
			if (layers[i] == layer) {
				layers.splice(i, 1);
			}
		}
	}
	
	public function getLayerIndex(layer:ILayer):Int
	{
		for (i in 0...layers.length) 
		{
			if (layers[i] == layer) {
				return i;
			}
		}
		return -1;
	}
	
	public function render():Void
	{
		Update(null);
	}
	
	private function Update(e:Event):Void 
	{
		//if (layers.length == 0) return;
		if (_stage3D == null) return;
		if (context3D == null) return;
		
		if (index == count) context3D.clear(viewport.red / 255, viewport.green / 255, viewport.blue / 255);
		if (active){
			for (i in 0...layers.length) 
			{
				layers[i].process();
			}
		}
		if (index == 0) context3D.present();
	}
	
	
	public function get_onActiveChange():Signal0
	{
		return _onActiveChange;
	}
	
	public function get_onReady():Signal0
	{
		return _onReady;
	}
	
	public function get_stage3D():Stage3D 
	{
		return _stage3D;
	}
	
	public function get_context3D():Context3D
	{
		return _context3D;
	}
	
	public function get_profile():String 
	{
		return _profile;
	}
	
	public function get_numLayers():Int 
	{
		return layers.length;
	}
	
	function get_active():Bool 
	{
		return _active;
	}
	
	function set_active(value:Bool):Bool 
	{
		if (_active == value) return value;
		_active = value;
		_onActiveChange.dispatch();
		if (_active) count++;
		else count--;
		return _active;
	}
}