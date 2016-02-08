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

	public var dispatcher(default, null):IEventDispatcher;

	public var eventString(default, null):String;

	public var listener(default, null):Void->Void;

	public var eventClass(default, null):Class<Dynamic>;

	public var callback(default, null):Dynamic->Void;

	public var useCapture(default, null):Bool = false;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function new(dispatcher:IEventDispatcher, eventString:String, listener:Void->Void, eventClass:Class<Dynamic>, callback:Dynamic->Void, useCapture:Bool)
	{
		this.dispatcher = dispatcher;
		this.eventString = eventString;
		this.listener = listener;
		this.eventClass = eventClass;
		this.callback = callback;
		this.useCapture = useCapture;
	}

	public function equalTo(dispatcher:IEventDispatcher, eventString:String, listener:Void->Void, eventClass:Class<Dynamic>, useCapture:Bool):Bool
	{
		return this.eventString == eventString
			&& this.eventClass == eventClass
			&& this.dispatcher == dispatcher
			&& this.listener == listener
			&& this.useCapture == useCapture;
	}
}