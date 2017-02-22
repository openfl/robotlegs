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


@:meta(Event(name="containerAdd", type="robotlegs.bender.extensions.viewManager.impl.ContainerRegistryEvent"))
@:meta(Event(name="containerRemove", type="robotlegs.bender.extensions.viewManager.impl.ContainerRegistryEvent"))
@:meta(Event(name="rootContainerAdd", type="robotlegs.bender.extensions.viewManager.impl.ContainerRegistryEvent"))
@:meta(Event(name="rootContainerRemove", type="robotlegs.bender.extensions.viewManager.impl.ContainerRegistryEvent"))
/**
 * @private
 */
@:rtti
@:keepSub
class ContainerRegistry extends EventDispatcher
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	//public var bindings = new Array<ContainerBinding>();
	public var bindings(get, null):Array<ContainerBinding> = new Array<ContainerBinding>();
	/**
	 * @private
	 */
	public function get_bindings():Array<ContainerBinding>
	{
		return this.bindings;
	}

	//public var rootBindings = new Array<ContainerBinding>();
	public var rootBindings(get, null):Array<ContainerBinding> = new Array<ContainerBinding>();
	/**
	 * @private
	 */
	
	public function get_rootBindings():Array<ContainerBinding>
	{
		return this.rootBindings;
	}

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _bindingByContainer = new Map<DisplayObject,Dynamic>();

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function addContainer(container:DisplayObjectContainer):ContainerBinding
	{
		if (!_bindingByContainer.exists(container)) {
			_bindingByContainer.set(container, createBinding(container));
		}
		
		return _bindingByContainer.get(container);
	}

	/**
	 * @private
	 */
	public function removeContainer(container:DisplayObjectContainer):ContainerBinding
	{
		var binding:ContainerBinding = _bindingByContainer.get(container);
		if (binding != null) removeBinding(binding);
		return binding;
	}

	/**
	 * Finds the closest parent binding for a given display object
	 *
	 * @private
	 */
	public function findParentBinding(target:DisplayObject):ContainerBinding
	{
		var parent:DisplayObjectContainer = target.parent;
		while (parent != null)
		{
			var binding:ContainerBinding = _bindingByContainer.get(parent);
			if (binding != null)
			{
				return binding;
			}
			parent = parent.parent;
		}
		return null;
	}

	/**
	 * @private
	 */
	public function getBinding(container:DisplayObjectContainer):ContainerBinding
	{
		return _bindingByContainer.get(container);
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	private function createBinding(container:DisplayObjectContainer):ContainerBinding
	{
		trace("create: " + container);
		var binding:ContainerBinding = new ContainerBinding(container);
		trace("binding.container = " + binding.container);
		
		this.bindings.push(binding);

		// Add a listener so that we can remove this binding when it has no handlers
		binding.addEventListener(ContainerBindingEvent.BINDING_EMPTY, onBindingEmpty);

		// If the new binding doesn't have a parent it is a Root
		binding.parent = findParentBinding(container);
		if (binding.parent == null)
		{
			addRootBinding(binding);
		}

		// Reparent any bindings which are contained within the new binding AND
		// A. Don't have a parent, OR
		// B. Have a parent that is not contained within the new binding
		for (childBinding in _bindingByContainer)
		{
			trace("container = " + container);
			trace(childBinding);
			trace(childBinding.container);
			
			if (childBinding.container != null && container.contains(childBinding.container))
			{
				if (childBinding.parent == null)
				{
					// CHECK
					removeRootBinding(cast(childBinding, ContainerBinding));
					childBinding.parent = binding;
				}
				else if (container.contains(childBinding.parent.container))
				{
					childBinding.parent = binding;
				}
			}
		}

		dispatchEvent(new ContainerRegistryEvent(ContainerRegistryEvent.CONTAINER_ADD, binding.container));
		return binding;
	}

	private function removeBinding(binding:ContainerBinding):Void
	{
		// Remove the binding itself
		_bindingByContainer.remove(binding.container);
		var index:Int = this.bindings.indexOf(binding);
		this.bindings.splice(index, 1);

		// Drop the empty binding listener
		binding.removeEventListener(ContainerBindingEvent.BINDING_EMPTY, onBindingEmpty);

		if (binding.parent == null)
		{
			// This binding didn't have a parent, so it was a Root
			removeRootBinding(binding);
		}

		// Re-parent the bindings
		for (childBinding in _bindingByContainer)
		{
			if (childBinding.parent == binding)
			{
				childBinding.parent = binding.parent;
				if (childBinding.parent == null)
				{
					// This binding used to have a parent,
					// but no longer does, so it is now a Root
					// CHECK
					addRootBinding(cast(childBinding, ContainerBinding));
				}
			}
		}

		dispatchEvent(new ContainerRegistryEvent(ContainerRegistryEvent.CONTAINER_REMOVE, binding.container));
	}

	private function addRootBinding(binding:ContainerBinding):Void
	{
		this.rootBindings.push(binding);
		dispatchEvent(new ContainerRegistryEvent(ContainerRegistryEvent.ROOT_CONTAINER_ADD, binding.container));
	}

	private function removeRootBinding(binding:ContainerBinding):Void
	{
		var index:Int = this.rootBindings.indexOf(binding);
		this.rootBindings.splice(index, 1);
		dispatchEvent(new ContainerRegistryEvent(ContainerRegistryEvent.ROOT_CONTAINER_REMOVE, binding.container));
	}

	private function onBindingEmpty(event:ContainerBindingEvent):Void
	{
		removeBinding(cast(event.target, ContainerBinding));
	}
}