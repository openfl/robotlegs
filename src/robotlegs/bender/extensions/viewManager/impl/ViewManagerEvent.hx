//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager.impl;

import openfl.display.DisplayObjectContainer;
import openfl.events.Event;
import robotlegs.bender.extensions.viewManager.api.IViewHandler;

/**
 * Container existence event
 * @private
 */
class ViewManagerEvent extends Event
{

	/*============================================================================*/
	/* Public Static Properties                                                   */
	/*============================================================================*/

	public static var CONTAINER_ADD:String = 'containerAdd';

	public static var CONTAINER_REMOVE:String = 'containerRemove';

	public static var HANDLER_ADD:String = 'handlerAdd';

	public static var HANDLER_REMOVE:String = 'handlerRemove';

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	private var _container:DisplayObjectContainer;

	/**
	 * The container associated with this event
	 */
	public function get container():DisplayObjectContainer
	{
		return _container;
	}

	private var _handler:IViewHandler;

	/**
	 * The view handler associated with this event
	 */
	public function get handler():IViewHandler
	{
		return _handler;
	}

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * Creates a view manager event
	 * @param type The event type
	 * @param container The container associated with this event
	 * @param handler The view handler associated with this event
	 */
	public function new(type:String, container:DisplayObjectContainer = null, handler:IViewHandler = null)
	{
		super(type);
		_container = container;
		_handler = handler;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @inheritDoc
	 */
	override public function clone():Event
	{
		return new ViewManagerEvent(type, _container, _handler);
	}
}