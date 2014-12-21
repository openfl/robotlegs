//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager.impl;

import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.events.EventDispatcher;
import robotlegs.bender.extensions.viewManager.api.IViewHandler;

@:meta(Event(name="bindingEmpty", type="robotlegs.bender.extensions.viewManager.impl.ContainerBindingEvent"))
/**
 * @private
 */
class ContainerBinding extends EventDispatcher
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	private var _parent:ContainerBinding;

	/**
	 * @private
	 */
	public function get parent():ContainerBinding
	{
		return _parent;
	}

	/**
	 * @private
	 */
	public function set parent(value:ContainerBinding):Void
	{
		_parent = value;
	}

	private var _container:DisplayObjectContainer;

	/**
	 * @private
	 */
	public function get container():DisplayObjectContainer
	{
		return _container;
	}

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _handlers:Array<IViewHandler> = new Array<IViewHandler>;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function new(container:DisplayObjectContainer)
	{
		_container = container;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function addHandler(handler:IViewHandler):Void
	{
		if (_handlers.indexOf(handler) > -1)
			return;
		_handlers.push(handler);
	}

	/**
	 * @private
	 */
	public function removeHandler(handler:IViewHandler):Void
	{
		var index:Int = _handlers.indexOf(handler);
		if (index > -1)
		{
			_handlers.splice(index, 1);
			if (_handlers.length == 0)
			{
				dispatchEvent(new ContainerBindingEvent(ContainerBindingEvent.BINDING_EMPTY));
			}
		}
	}

	/**
	 * @private
	 */
	public function handleView(view:DisplayObject, type:Class):Void
	{
		var length:UInt = _handlers.length;
		for (var i:Int = 0; i < length; i++)
		{
			var handler:IViewHandler = _handlers[i] as IViewHandler;
			handler.handleView(view, type);
		}
	}
}