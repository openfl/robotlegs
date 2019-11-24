//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl;

import robotlegs.bender.framework.api.IMatcher;

/**
 * Robotlegs object processor
 *
 * @private
 */
@:keepSub
class ObjectProcessor
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _handlers:Array<Dynamic> = [];
	
	public function new()
	{
		
	}
	
	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * Add a handler to process objects that match a given matcher.
	 * @param matcher The matcher
	 * @param handler The handler function
	 */
	public function addObjectHandler(matcher:IMatcher, handler:Dynamic):Void
	{
		_handlers.push(new ObjectHandler(matcher, handler));
	}

	/**
	 * Process an object by running it through all registered handlers
	 * @param object The object instance to process.
	 */
	public function processObject(object:Dynamic):Void
	{
		for (handler in _handlers)
		{
			handler.handle(object);
		}
	}

	/**
	 * Removes all handlers
	 */
	public function removeAllHandlers():Void
	{
		_handlers = [];
	}
}