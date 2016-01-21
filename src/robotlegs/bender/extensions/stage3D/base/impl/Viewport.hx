package robotlegs.bender.extensions.stage3D.base.impl;

import msignal.Signal.Signal0;
import openfl.events.Event;
import openfl.geom.Rectangle;
import robotlegs.bender.extensions.contextView.ContextView;
import robotlegs.bender.extensions.stage3D.base.api.IViewport;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IInjector;
import robotlegs.bender.framework.api.ILogger;
/**
 * ...
 * @author P.J.Shand
 */
@:rtti
@:keepSub
class Viewport implements IViewport
{
	
	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/
	private var _injector:IInjector;
	private var _logger:ILogger;
	@inject public var contextView:ContextView;
	
	private var _rect = new Rectangle();
	private var lastRect = new Rectangle();
	
	private var _onChange = new Signal0();
	
	public var rect(get, set):Rectangle;
	public var onChange(get, null):Signal0;
	
	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/
	public function Viewport(context:IContext)
	{
		
		_injector = context.injector;
		_logger = context.getLogger(this);
	}
	
	public function init():Void
	{
		contextView.view.stage.addEventListener(Event.ENTER_FRAME, CheckForChange);
	}
	
	private function CheckForChange(e:Event):Void 
	{
		if (_rect.x != lastRect.x) onChange.dispatch();
		else if (_rect.y != lastRect.y) onChange.dispatch();
		else if (_rect.width != lastRect.width) onChange.dispatch();
		else if (_rect.height != lastRect.height) onChange.dispatch();
		lastRect.setTo(_rect.x, _rect.y, _rect.width, _rect.height);
	}
	
	public function get_rect():Rectangle 
	{
		return _rect;
	}
	
	public function set_rect(value:Rectangle):Rectangle 
	{
		_rect = value;
		return value;
	}
	
	public function get_onChange():Signal0 
	{
		return _onChange;
	}
}