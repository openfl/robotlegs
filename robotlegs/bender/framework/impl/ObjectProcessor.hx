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

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * Add a handler to process objects that match a given matcher.
	 * @param matcher The matcher
	 * @param handler The handler function
	 */
	public function addObjectHandler(matcher:IMatcher, handler:Void->Void):Void
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


@:keepSub
class ObjectHandler
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _matcher:IMatcher;

	private var _handler:Dynamic;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function new(matcher:IMatcher, handler:Dynamic)
	{
		_matcher = matcher;
		_handler = handler;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function handle(object:Dynamic):Void
	{
		if (_matcher.matches(object)) {
			_handler(object);
		}
	}
}
