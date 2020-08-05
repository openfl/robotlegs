//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------
package robotlegs.bender.extensions.viewManager.impl;

import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import polyfill.events.EventDispatcher;
import robotlegs.bender.extensions.viewManager.api.IViewHandler;

@:meta(Event(name = "bindingEmpty", type = "robotlegs.bender.extensions.viewManager.impl.ContainerBindingEvent"))

/**
 * @private
 */
@:keepSub
class ContainerBinding extends EventDispatcher {
	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/
	private var _parent:ContainerBinding;

	public var parent(get, set):ContainerBinding;

	/**
	 * @private
	 */
	public function get_parent():ContainerBinding {
		return _parent;
	}

	/**
	 * @private
	 */
	public function set_parent(value:ContainerBinding):ContainerBinding {
		_parent = value;
		return _parent;
	}

	private var _container:DisplayObjectContainer;

	public var container(get, null):DisplayObjectContainer;

	/**
	 * @private
	 */
	public function get_container():DisplayObjectContainer {
		return _container;
	}

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/
	private var _handlers = new Array<IViewHandler>();

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/
	/**
	 * @private
	 */
	public function new(container:DisplayObjectContainer) {
		_container = container;
		super(null);
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/
	/**
	 * @private
	 */
	public function addHandler(handler:IViewHandler):Void {
		if (_handlers.indexOf(handler) > -1)
			return;
		_handlers.push(handler);
	}

	/**
	 * @private
	 */
	public function removeHandler(handler:IViewHandler):Void {
		var index:Int = _handlers.indexOf(handler);
		if (index > -1) {
			_handlers.splice(index, 1);
			if (_handlers.length == 0) {
				dispatchEvent(new ContainerBindingEvent(ContainerBindingEvent.BINDING_EMPTY));
			}
		}
	}

	/**
	 * @private
	 */
	public function handleView(view:Dynamic, type:Class<Dynamic>):Void {
		var length:UInt = _handlers.length;
		for (i in 0...length) {
			var handler:IViewHandler = cast(_handlers[i], IViewHandler);
			handler.handleView(view, type);
		}
	}
}
