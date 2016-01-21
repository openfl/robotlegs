package robotlegs.bender.extensions.stage3D.base.impl 
{
	import flash.utils.describeType;
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.extensions.stage3D.base.api.IRenderer;
	import robotlegs.bender.framework.api.IContext;
	/**
	 * ...
	 * @author P.J.Shand
	 */
	public class BaseInitializer 
	{
		public var renderer:IRenderer;
		public var contextView:ContextView;
		public var context:IContext;
		private var _debug:Boolean = false;
		
		public function BaseInitializer() 
		{
			
		}
		
		public function init(renderer:IRenderer, contextView:ContextView, context:IContext):void
		{
			this.renderer = renderer;
			this.contextView = contextView;
			this.context = context;
		}
		
		public function addLayer(ViewClass:Class, index:int, id:String):void 
		{
			
		}
		
		protected function autoID(ClassName:Class):String 
		{
			var xml:XML = describeType(ClassName);
			var className:String = xml.@name;
			if (className.indexOf("::") == -1) return className;
			else return className.split("::")[1];
		}
		
		public function set debug(value:Boolean):void 
		{
			_debug = value;
		}
		
		public function get debug():Boolean 
		{
			return _debug;
		}
	}

}