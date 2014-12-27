//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager.api;

import openfl.display.DisplayObjectContainer;
import openfl.events.IEventDispatcher;

@:meta(Event(name="containerAdd", type="robotlegs.bender.extensions.viewManager.impl.ViewManagerEvent"))
@:meta(Event(name="containerRemove", type="robotlegs.bender.extensions.viewManager.impl.ViewManagerEvent"))
@:meta(Event(name="handlerAdd", type="robotlegs.bender.extensions.viewManager.impl.ViewManagerEvent"))
@:meta(Event(name="handlerRemove", type="robotlegs.bender.extensions.viewManager.impl.ViewManagerEvent"))
/**
 * The View Manager allows you to add multiple "view root" containers to a context
 */
interface IViewManager extends IEventDispatcher
{

	/**
	 * A list of currently registered container
	 */
	public var containers(get, null):Array<DisplayObjectContainer>;
	function get_containers():Array<DisplayObjectContainer>;

	/**
	 * Adds a container as a "view root" into the context
	 * @param container
	 */
	function addContainer(container:DisplayObjectContainer):Void;

	/**
	 * Removes a container from this context
	 * @param container
	 */
	function removeContainer(container:DisplayObjectContainer):Void;

	/**
	 * Registers a view handler
	 * @param handler
	 */
	function addViewHandler(handler:IViewHandler):Void;

	/**
	 * Removes a view handler
	 * @param handler
	 */
	function removeViewHandler(handler:IViewHandler):Void;

	/**
	 * Removes all view handlers from this context
	 */
	function removeAllHandlers():Void;
}