package robotlegs.bender.extensions.stage3D.base.impl
{
	//import away3d.core.managers.Stage3DManager;
	//import away3d.core.managers.Stage3DProxy;
	//import away3d.events.Stage3DEvent;
	import flash.display.Stage;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.events.Event;
	import org.osflash.signals.Signal;
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
	public class Renderer implements IRenderer
	{
		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/
		private var _injector:IInjector;
		private var _logger:ILogger;
		private var _onReady:Signal = new Signal();
		
		[Inject] public var contextView:ContextView;
		[Inject] public var viewport:IViewport;
		
		private var layers:Vector.<ILayer> = new Vector.<ILayer>();
		//private var stage3DManager:Stage3DManager;
		//private var _stage3DProxy:Stage3DProxy;
		private var _profile:String;
		private var freeFreeStage3DIndex:int = 0;
		private var _stage3D:Stage3D;
		
		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/
		public function Renderer(context:IContext)
		{
			_injector = context.injector;
			_logger = context.getLogger(this);
		}
		
		public function init(profile:String, antiAlias:int=0):void
		{
			_profile = profile;
			
			_stage3D = contextView.view.stage.stage3Ds[freeFreeStage3DIndex];
			stage3D.addEventListener(Event.CONTEXT3D_CREATE, contextCreatedHandler);
			stage3D.requestContext3D("auto", profile);
			freeFreeStage3DIndex++;
		}
		
		private function contextCreatedHandler(e:Event):void 
		{
			stage3D.context3D.configureBackBuffer(contextView.view.stage.stageWidth, contextView.view.stage.stageHeight, 0, true);
			
			_onReady.dispatch();
			
			viewport.init();
			viewport.onChange.add(OnViewportChange);
			viewport.rect.setTo(0, 0, contextView.view.stage.stageWidth, contextView.view.stage.stageHeight);
		}
		
		private function OnViewportChange():void 
		{
			// FIX
			//_stage3DProxy.x = viewport.rect.x;
			//_stage3DProxy.y = viewport.rect.y;
			//_stage3DProxy.width = viewport.rect.width;
			//_stage3DProxy.height = viewport.rect.height;
			
			for (var i:int = 0; i < layers.length; i++) 
			{
				layers[i].rect = viewport.rect;
			}
		}
		
		public function start():void
		{
			contextView.view.stage.addEventListener(Event.ENTER_FRAME, Update);
		}
		
		public function stop():void
		{
			contextView.view.stage.removeEventListener(Event.ENTER_FRAME, Update);
		}
		
		public function addLayer(layer:ILayer):void
		{
			trace("addLayer: " + layer);
			layers.push(layer);
		}
		
		public function addLayerAt(layer:ILayer, index:int):void
		{
			trace("addLayerAt: " + layer);
			
			if (layers.length < index) {
				trace("[Renderer, addLayerAt], index outside bounds, reverting to addLayerAt");
				addLayer(layer);
				return;
			}
			layers.splice(index, 0, layer);
		}
		
		public function removeLayer(layer:ILayer):void
		{
			for (var i:int = 0; i < layers.length; i++) 
			{
				if (layers[i] == layer) {
					layers.splice(i, 1);
				}
			}
		}
		
		public function render():void
		{
			Update(null);
		}
		
		private function Update(e:Event):void 
		{
			if (layers.length == 0) return;
			
			if (!_stage3D.context3D) return;
			
			stage3D.context3D.clear();
			for (var i:int = 0; i < layers.length; i++) 
			{
				layers[i].process();
			}
			stage3D.context3D.present();
			
			/*stage3DProxy.clear();
			for (var i:int = 0; i < layers.length; i++) 
			{
				layers[i].update();
			}
			stage3DProxy.present();*/
		}
		
		public function get onReady():Signal 
		{
			return _onReady;
		}
		
		/*public function get stage3DProxy():Stage3DProxy 
		{
			return _stage3DProxy;
		}*/
		
		public function get stage3D():Stage3D 
		{
			return _stage3D;
		}
		
		
		public function get profile():String 
		{
			return _profile;
		}
	}
}
