package robotlegs.bender.extensions.stage3D.base.impl 
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	import org.osflash.signals.Signal;
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.extensions.stage3D.base.api.IViewport;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.bender.framework.api.ILogger;
	/**
	 * ...
	 * @author P.J.Shand
	 */
	public class Viewport implements IViewport
	{
		
		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/
		private var _injector:IInjector;
		private var _logger:ILogger;
		[Inject] public var contextView:ContextView;
		
		private var _rect:Rectangle = new Rectangle();
		private var lastRect:Rectangle = new Rectangle();
		
		private var _onChange:Signal = new Signal();
		
		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/
		public function Viewport(context:IContext)
		{
			_injector = context.injector;
			_logger = context.getLogger(this);
		}
		
		public function init():void
		{
			contextView.view.addEventListener(Event.ENTER_FRAME, CheckForChange);
		}
		
		private function CheckForChange(e:Event):void 
		{
			if (rect.x != lastRect.x) onChange.dispatch();
			else if (rect.y != lastRect.y) onChange.dispatch();
			else if (rect.width != lastRect.width) onChange.dispatch();
			else if (rect.height != lastRect.height) onChange.dispatch();
			lastRect.setTo(rect.x, rect.y, rect.width, rect.height);
		}
		
		public function get rect():Rectangle 
		{
			return _rect;
		}
		
		public function set rect(value:Rectangle):void 
		{
			_rect = value;
		}
		
		public function get onChange():Signal 
		{
			return _onChange;
		}
	}
}