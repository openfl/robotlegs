package robotlegs.bender.extensions.stage3D.away3d.impl 
{
	import away3d.containers.View3D;
	import away3d.core.managers.Stage3DManager;
	import away3d.core.managers.Stage3DProxy;
	import away3d.events.Stage3DEvent;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import robotlegs.bender.extensions.stage3D.base.api.ILayer;
	import robotlegs.bender.extensions.stage3D.base.api.IRenderer;
	
	/**
	 * ...
	 * @author P.J.Shand
	 */
	public class AwayLayer extends View3D implements ILayer
	{
		private var _iRenderer:IRenderer;
		
		private var stage3DManager:Stage3DManager;
		private var profile:String;
		
		public function AwayLayer(/*stage3DProxy:Stage3DProxy, */profile:String) 
		{
			super(null, null, null, false, profile);
			this.profile = profile;
			
			this.shareContext = true;
			
			
			
			/*this.stage3DProxy = stage3DProxy;*/
			this.rightClickMenuEnabled = false;
			
			addEventListener(Event.ADDED_TO_STAGE, OnAdd);
		}
		
		private function OnAdd(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, OnAdd);
			
			stage3DManager = Stage3DManager.getInstance(this.stage);
			_stage3DProxy = stage3DManager.getStage3DProxy(0, false, profile);
			_stage3DProxy.enableDepthAndStencil = true;
			_stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_CREATED, onContextCreated);
			//_stage3DProxy.antiAlias = antiAlias;
		}
		
		private function onContextCreated(e:Event):void 
		{
			//iRenderer.stage3D.context3D.
			//trace("onContextCreated");
			//trace(_iRenderer.stage3D.context3D);
			//trace(_stage3DProxy.context3D);
			//trace(_iRenderer.stage3D.context3D == _stage3DProxy.context3D);
			
		}
		
		public function process():void
		{
			this.render();
		}
		
		public function set rect(rect:Rectangle):void
		{
			this.x = rect.x;
			this.y = rect.y;
			this.width = rect.width;
			this.height = rect.height;
		}
		
		public function set iRenderer(value:IRenderer):void 
		{
			_iRenderer = value;
		}
	}
}