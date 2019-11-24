//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl;

//import robotlegs.bender.framework.impl.safelyCallBack;
import robotlegs.bender.framework.impl.SafelyCallBack;
/**
 * Message Dispatcher implementation.
 */
class MessageDispatcher
{
	private var _handlers = new Map<String, Array<Callback>>();

	public function new()
	{
	}
	/**
	 * Registers a message handler with a MessageDispatcher.
	 * @param message The interesting message
	 * @param handler The handler function
	 */
	public function addMessageHandler(message:String, handler:Function):Void
	{
		var messageHandlers:Array<Callback> = _handlers.get(message);
		var callback:Callback = new Callback(handler);
		if (messageHandlers != null)
		{
			if (messageHandlers.indexOf(callback) == -1)
				messageHandlers.push(callback);
		}
		else
		{
			_handlers.set(message, [callback]);
		}
	}

	/**
	 * Checks whether the MessageDispatcher has any handlers registered for a specific message.
	 * @param message The interesting message
	 * @return A value of true if a handler of the specified message is registered; false otherwise.
	 */
	public function hasMessageHandler(message:String):Bool
	{
		return _handlers.get(message) != null;
	}

	/**
	 * Removes a message handler from a MessageDispatcher
	 * @param message The interesting message
	 * @param handler The handler function
	 */
	public function removeMessageHandler(message:String, handler:Function):Void
	{
		var messageHandlers:Array<Callback> = _handlers.get(message);
		var index:Int = messageHandlers != null ? messageHandlers.indexOf(handler) : -1;
		if (index != -1)
		{
			messageHandlers.splice(index, 1);
			if (messageHandlers.length == 0){
				_handlers.remove(message);
				//delete _handlers[message];
			}
				
		}
	}

	/**
	 * Dispatches a message into the message flow.
	 * @param message The interesting message
	 * @param callback The completion callback function
	 * @param reverse Should handlers be called in reverse order
	 */
	public function dispatchMessage(message:String, func:Function = null, reverse:Bool = false):Void
	{
		var handlers:Array<Callback> = _handlers.get(message);
		var callback:Callback = new Callback(func);
		if (handlers != null)
		{
			handlers = handlers.concat([]);
			if (reverse) handlers.reverse();
			new MessageRunner(message, handlers, callback).run();
		}
		else
		{
			if (callback != null) {
				callback.call(null, null);
				//SafelyCallBack.call(callback);
			}
		}
	}
}

class MessageRunner
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _message:String;

	private var _handlers:Array<Callback>;

	private var _callback:Callback;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function new(message:String, handlers:Array<Callback>, callback:Callback)
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
		var handler:Callback;
		while ((handler = _handlers.pop()) != null)
		{
			if (handler.length == 0) // sync handler: ()
			{
				handler.call(null, null);
			}
			else if (handler.length == 1) // sync handler: (message)
			{
				handler.call(_message, null);
			}
			else if (handler.length == 2) // sync or async handler: (message, callback)
			{
				var handled:Bool = false;
				handler.call(_message, function(error:Dynamic = null, msg:Dynamic = null):Void
				{
					// handler must not invoke the callback more than once
					if (handled) return;

					handled = true;
					if (error || _handlers.length == 0)
					{
						if (_callback != null) {
							_callback.call(error, _message);
							//SafelyCallBack.call(_callback, error, _message);
						}
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
				throw "Bad handler signature";
			}
		}
		// If we got here then th
		// is loop finished synchronously.
		// Nobody broke out, so we are done.
		// This relies on the various return statements above. Be careful.
		if (_callback != null) {
			_callback.call(null, _message);
			//SafelyCallBack.call(_callback, null, _message);
		}
	}
}

typedef Function = Dynamic;

/*typedef Callback = {
	callback0:Void -> Void;
	callback1:Dynamic -> Void;
	callback2:Dynamic -> Dynamic -> Void;
	length:Int
}*/

class Callback
{
	public var call:Dynamic -> Dynamic -> Void;
	public var length:Int = 0;
	public function new(value:Dynamic){
		var func0:Void -> Void = null;
		try {
			func0 = value;
			call = (v1:Dynamic, v2:Dynamic) -> {
				func0();
			}
			length = 0;
		} catch (e:Dynamic){
			var func1:Dynamic -> Void = null;
			try {
				func1 = value;
				call = (v1:Dynamic, v2:Dynamic) -> {
					func1(v1);
				}
				length = 1;
			} catch (e:Dynamic){
				var func2:Dynamic -> Dynamic -> Void = null;
				try {
					func2 = value;
					call = (v1:Dynamic, v2:Dynamic) -> {
						func2(v1, v2);
					}
					length = 2;
				} catch (e:Dynamic){
					throw "Bad handler signature";
					call = null;
				}
			}
		}
	}
}