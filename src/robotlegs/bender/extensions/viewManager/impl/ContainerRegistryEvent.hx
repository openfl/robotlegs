//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------
package robotlegs.bender.extensions.viewManager.impl;

import openfl.display.DisplayObjectContainer;
import polyfill.events.Event;

/**
 * Container existence event
 * @private
 */
@:keepSub
class ContainerRegistryEvent extends Event {
	/*============================================================================*/
	/* Public Static Properties                                                   */
	/*============================================================================*/
	public static var CONTAINER_ADD:String = 'containerAdd';

	public static var CONTAINER_REMOVE:String = 'containerRemove';

	public static var ROOT_CONTAINER_ADD:String = 'rootContainerAdd';

	public static var ROOT_CONTAINER_REMOVE:String = 'rootContainerRemove';

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/
	public var container:DisplayObjectContainer;

	// public var container(default, null):DisplayObjectContainer;

	/**
	 * The container associated with this event
	 */
	/*public function get_container():DisplayObjectContainer
		{
			return _container;
	}*/
	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/
	/**
	 * Creates a new container existence event
	 * @param type The event type
	 * @param container The container associated with this event
	 */
	public function new(type:String, container:DisplayObjectContainer) {
		super(type);
		this.container = container;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/
	/**
	 * @inheritDoc
	 */
	override public function clone():Event {
		return new ContainerRegistryEvent(type, container);
	}
}
