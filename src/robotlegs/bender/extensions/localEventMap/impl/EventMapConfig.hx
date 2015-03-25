//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.localEventMap.impl;

import openfl.events.IEventDispatcher;

/**
 * @private
 */

@:keepSub
class EventMapConfig
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	private var _dispatcher:IEventDispatcher;
	public var dispatcher(default, null):IEventDispatcher;
	/**
	 * @private
	 */
	/*public function get_dispatcher():IEventDispatcher
	{
		return _dispatcher;
	}*/

	private var _eventString:String;
	public var eventString(default, null):String;
	/**
	 * @private
	 */
	/*public function get_eventString():String
	{
		return _eventString;
	}*/

	private var _listener:Void->Void;
	public var listener(default, null):Void->Void;
	/**
	 * @private
	 */
	/*public function get_listener():Void->Void
	{
		return _listener;
	}*/

	private var _eventClass:Class<Dynamic>;
	public var eventClass(default, null):Class<Dynamic>;
	/**
	 * @private
	 */
	/*public function get_eventClass():Class<Dynamic>
	{
		return _eventClass;
	}*/

	private var _callback:Dynamic->Void;
	public var callback(default, null):Dynamic->Void;
	/**
	 * @private
	 */
	/*public function get_callback():Void->Void
	{
		return _callback;
	}*/

	private var _useCapture:Bool = false;
	public var useCapture(default, null):Bool;
	/**
	 * @private
	 */
	/*public function get_useCapture():Bool
	{
		return _useCapture;
	}*/

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function new(dispatcher:IEventDispatcher, eventString:String, listener:Void->Void, eventClass:Class<Dynamic>, callback:Dynamic->Void, useCapture:Bool)
	{
		_dispatcher = dispatcher;
		_eventString = eventString;
		_listener = listener;
		_eventClass = eventClass;
		_callback = callback;
		_useCapture = useCapture;
	}

	public function equalTo(dispatcher:IEventDispatcher, eventString:String, listener:Void->Void, eventClass:Class<Dynamic>, useCapture:Bool):Bool
	{
		return _eventString == eventString
			&& _eventClass == eventClass
			&& _dispatcher == dispatcher
			&& _listener == listener
			&& _useCapture == useCapture;
	}
}