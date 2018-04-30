//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager.impl;

import openfl.display.DisplayObjectContainer;
import openfl.errors.Error;
import openfl.events.EventDispatcher;
import robotlegs.bender.extensions.viewManager.api.IViewHandler;
import robotlegs.bender.extensions.viewManager.api.IViewManager;

@:meta(Event(name="containerAdd", type="robotlegs.bender.extensions.viewManager.impl.ViewManagerEvent"))
@:meta(Event(name="containerRemove", type="robotlegs.bender.extensions.viewManager.impl.ViewManagerEvent"))
@:meta(Event(name="handlerAdd", type="robotlegs.bender.extensions.viewManager.impl.ViewManagerEvent"))
@:meta(Event(name="handlerRemove", type="robotlegs.bender.extensions.viewManager.impl.ViewManagerEvent"))
/**
 * @private
 */
@:build(org.swiftsuspenders.macros.ReflectorMacro.check())
class ViewManager extends EventDispatcher implements IViewManager
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	//private var _containers = new Array<DisplayObjectContainer>();
	public var containers(get, null):Array<DisplayObjectContainer> = new Array<DisplayObjectContainer>();
	public function get_containers():Array<DisplayObjectContainer>
	{
		return this.containers;
	}
	/**
	 * @inheritDoc
	 */
	/*public function get_containers():Array<DisplayObjectContainer>
	{
		return _containers;
	}*/

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _handlers = new Array<IViewHandler>();

	private var _registry:ContainerRegistry;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function new(containerRegistry:ContainerRegistry)
	{
		_registry = containerRegistry;
		super();
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @inheritDoc
	 */
	public function addContainer(container:DisplayObjectContainer):Void
	{
		if (validContainer(container) == false)
			return;

		this.containers.push(container);

		for (handler in _handlers)
		{
			_registry.addContainer(container).addHandler(handler);
		}
		dispatchEvent(new ViewManagerEvent(ViewManagerEvent.CONTAINER_ADD, container));
	}

	/**
	 * @inheritDoc
	 */
	public function removeContainer(container:DisplayObjectContainer):Void
	{
		var index:Int = this.containers.indexOf(container);
		if (index == -1)
			return;

		this.containers.splice(index, 1);

		var binding:ContainerBinding = _registry.getBinding(container);
		for (handler in _handlers)
		{
			binding.removeHandler(handler);
		}
		dispatchEvent(new ViewManagerEvent(ViewManagerEvent.CONTAINER_REMOVE, container));
	}

	/**
	 * @inheritDoc
	 */
	public function addViewHandler(handler:IViewHandler):Void
	{
		if (_handlers.indexOf(handler) != -1)
			return;

		_handlers.push(handler);

		for (container in this.containers)
		{
			_registry.addContainer(container).addHandler(handler);
		}
		dispatchEvent(new ViewManagerEvent(ViewManagerEvent.HANDLER_ADD, null, handler));
	}

	/**
	 * @inheritDoc
	 */
	public function removeViewHandler(handler:IViewHandler):Void
	{
		var index:Int = _handlers.indexOf(handler);
		if (index == -1)
			return;

		_handlers.splice(index, 1);

		for (container in this.containers)
		{
			_registry.getBinding(container).removeHandler(handler);
		}
		dispatchEvent(new ViewManagerEvent(ViewManagerEvent.HANDLER_REMOVE, null, handler));
	}

	/**
	 * @inheritDoc
	 */
	public function removeAllHandlers():Void
	{
		for (container in this.containers)
		{
			var binding:ContainerBinding = _registry.getBinding(container);
			for (handler in _handlers)
			{
				binding.removeHandler(handler);
			}
		}
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	private function validContainer(container:DisplayObjectContainer):Bool
	{
		for (registeredContainer in this.containers)
		{
			if (container == registeredContainer)
				return false;

			if (registeredContainer.contains(container) || container.contains(registeredContainer))
				throw new Error("Containers can not be nested");
		}
		return true;
	}
}