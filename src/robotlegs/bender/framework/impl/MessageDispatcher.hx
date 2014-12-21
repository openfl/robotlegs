//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl;

import openfl.utils.Dictionary;

/**
 * Message Dispatcher implementation.
 */
public class MessageDispatcher
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _handlers:Dictionary = new Dictionary();

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * Registers a message handler with a MessageDispatcher.
	 * @param message The interesting message
	 * @param handler The handler function
	 */
	public function addMessageHandler(message:Dynamic, handler:Function):Void
	{
		var messageHandlers:Array<Dynamic> = _handlers[message];
		if (messageHandlers)
		{
			if (messageHandlers.indexOf(handler) == -1)
				messageHandlers.push(handler);
		}
		else
		{
			_handlers[message] = [handler];
		}
	}

	/**
	 * Checks whether the MessageDispatcher has any handlers registered for a specific message.
	 * @param message The interesting message
	 * @return A value of true if a handler of the specified message is registered; false otherwise.
	 */
	public function hasMessageHandler(message:Dynamic):Bool
	{
		return _handlers[message];
	}

	/**
	 * Removes a message handler from a MessageDispatcher
	 * @param message The interesting message
	 * @param handler The handler function
	 */
	public function removeMessageHandler(message:Dynamic, handler:Function):Void
	{
		var messageHandlers:Array<Dynamic> = _handlers[message];
		var index:Int = messageHandlers ? messageHandlers.indexOf(handler):-1;
		if (index != -1)
		{
			messageHandlers.splice(index, 1);
			if (messageHandlers.length == 0)
				delete _handlers[message];
		}
	}

	/**
	 * Dispatches a message into the message flow.
	 * @param message The interesting message
	 * @param callback The completion callback function
	 * @param reverse Should handlers be called in reverse order
	 */
	public function dispatchMessage(message:Dynamic, callback:Function = null, reverse:Bool = false):Void
	{
		var handlers:Array<Dynamic> = _handlers[message];
		if (handlers)
		{
			handlers = handlers.concat();
			reverse || handlers.reverse();
			new MessageRunner(message, handlers, callback).run();
		}
		else
		{
			callback && SafelyCallBack.call(callback);
		}
	}
}

import robotlegs.bender.framework.impl.SafelyCallBack;

class MessageRunner
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _message:Dynamic;

	private var _handlers:Array<Dynamic>;

	private var _callback:Function;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function new(message:Dynamic, handlers:Array<Dynamic>, callback:Function)
	{
		_message = message;
		_handlers = handlers;
		_callback = callback;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function run():Void
	{
		next();
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	private function next():Void
	{
		// Try to keep things synchronous with a simple loop,
		// forcefully breaking out for async handlers and recursing.
		// We do this to avoid increasing the stack depth unnecessarily.
		var handler:Function;
		while (handler = _handlers.pop())
		{
			if (handler.length == 0) // sync handler: ()
			{
				handler();
			}
			else if (handler.length == 1) // sync handler: (message)
			{
				handler(_message);
			}
			else if (handler.length == 2) // sync or async handler: (message, callback)
			{
				var handled:Bool;
				handler(_message, function(error:Dynamic = null, msg:Dynamic = null):Void
				{
					// handler must not invoke the callback more than once
					if (handled) return;

					handled = true;
					if (error || _handlers.length == 0)
					{
						_callback && SafelyCallBack.call(_callback, error, _message);
					}
					else
					{
						next();
					}
				});
				// IMPORTANT: MUST break this loop with a RETURN. See top.
				return;
			}
			else // ERROR: this should NEVER happen
			{
				throw new Error("Bad handler signature");
			}
		}
		// If we got here then this loop finished synchronously.
		// Nobody broke out, so we are done.
		// This relies on the various return statements above. Be careful.
		_callback && SafelyCallBack.call(_callback, null, _message);
	}
}
