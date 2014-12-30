//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager.impl;

import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;

/**
 * @private
 */
class ManualStageObserver
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

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
		// We care about all containers (not just roots)
		_registry.addEventListener(ContainerRegistryEvent.CONTAINER_ADD, onContainerAdd);
		_registry.addEventListener(ContainerRegistryEvent.CONTAINER_REMOVE, onContainerRemove);
		// We might have arrived late on the scene
		for each (var binding:ContainerBinding in _registry.bindings)
		{
			addContainerListener(binding.container);
		}
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function destroy():Void
	{
		_registry.removeEventListener(ContainerRegistryEvent.CONTAINER_ADD, onContainerAdd);
		_registry.removeEventListener(ContainerRegistryEvent.CONTAINER_REMOVE, onContainerRemove);
		for each (var binding:ContainerBinding in _registry.bindings)
		{
			removeContainerListener(binding.container);
		}
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	private function onContainerAdd(event:ContainerRegistryEvent):Void
	{
		addContainerListener(event.container);
	}

	private function onContainerRemove(event:ContainerRegistryEvent):Void
	{
		removeContainerListener(event.container);
	}

	private function addContainerListener(container:DisplayObjectContainer):Void
	{
		// We're interested in ALL container bindings
		// but just for normal, bubbling events
		container.addEventListener(ConfigureViewEvent.CONFIGURE_VIEW, onConfigureView);
	}

	private function removeContainerListener(container:DisplayObjectContainer):Void
	{
		container.removeEventListener(ConfigureViewEvent.CONFIGURE_VIEW, onConfigureView);
	}

	private function onConfigureView(event:ConfigureViewEvent):Void
	{
		// Stop that event!
		event.stopImmediatePropagation();
		var container:DisplayObjectContainer = cast(event.currentTarget, DisplayObjectContainer);
		var view:DisplayObject = cast(event.target, DisplayObject);
		var type:Class<Dynamic> = Type.getClass(view);
		_registry.getBinding(container).handleView(view, type);
	}
}