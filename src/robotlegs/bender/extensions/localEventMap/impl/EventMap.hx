//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.localEventMap.impl;

import openfl.events.Event;
import openfl.events.IEventDispatcher;
import robotlegs.bender.extensions.localEventMap.api.IEventMap;

/**
 * @private
 */

@:keepSub
@:rtti
class EventMap implements IEventMap
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _listeners = new Array<EventMapConfig>();

	private var _suspendedListeners:Array<EventMapConfig> = new Array<EventMapConfig>();

	private var _suspended:Bool = false;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @inheritDoc
	 */
	public function mapListener(dispatcher:IEventDispatcher, eventString:String, listener:Dynamic, eventClass:Class<Dynamic> = null, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = true):Void
	{
		// CHECK
		if (eventClass == null) {
			eventClass = Event;
		}
		//eventClass ||= Event;

		var currentListeners:Array<EventMapConfig> = _suspended
				? _suspendedListeners
				: _listeners;

		var config:EventMapConfig;

		var i:Int = currentListeners.length;
		while (i-- > 0)
		{
			config = currentListeners[i];
			if (config.equalTo(dispatcher, eventString, listener, eventClass, useCapture))
			{
				return;
			}
		}

		var callback:Dynamic = eventClass == Event
			? listener
			: function(event:Event):Void
			{
				routeEventToListener(event, listener, eventClass);
			};

		config = new EventMapConfig(dispatcher,
			eventString,
			listener,
			eventClass,
			callback,
			useCapture);

		currentListeners.push(config);

		if (!_suspended)
		{
			dispatcher.addEventListener(eventString, callback, useCapture, priority, useWeakReference);
		}
	}

	/**
	 * @inheritDoc
	 */
	public function unmapListener(dispatcher:IEventDispatcher,eventString:String,listener:Dynamic,eventClass:Class<Dynamic> = null,useCapture:Bool = false):Void
	{
		// CHECK
		if (eventClass == null) {
			eventClass = Event;
		}
		//eventClass ||= Event;

		var currentListeners:Array<EventMapConfig> = _suspended
			? _suspendedListeners
			: _listeners;

		var i:Int = currentListeners.length;
		while (i-- > 0)
		{
			var config:EventMapConfig = currentListeners[i];
			if (config.equalTo(dispatcher, eventString, listener, eventClass, useCapture))
			{
				if (!_suspended)
				{
					dispatcher.removeEventListener(eventString, config.callback, useCapture);
				}
				currentListeners.splice(i, 1);
				return;
			}
		}
	}

	/**
	 * @inheritDoc
	 */
	public function unmapListeners():Void
	{
		var currentListeners:Array<EventMapConfig> = _suspended ? _suspendedListeners:_listeners;

		var eventConfig:EventMapConfig;
		var dispatcher:IEventDispatcher;
		while ((eventConfig = currentListeners.pop()) != null)
		{
			if (!_suspended)
			{
				dispatcher = eventConfig.dispatcher;
				dispatcher.removeEventListener(eventConfig.eventString, eventConfig.callback, eventConfig.useCapture);
			}
		}
	}

	/**
	 * @inheritDoc
	 */
	public function suspend():Void
	{
		if (_suspended)
			return;

		_suspended = true;

		var eventConfig:EventMapConfig;
		var dispatcher:IEventDispatcher;
		while ((eventConfig = _listeners.pop()) != null)
		{
			dispatcher = eventConfig.dispatcher;
			dispatcher.removeEventListener(eventConfig.eventString, eventConfig.callback, eventConfig.useCapture);
			_suspendedListeners.push(eventConfig);
		}
	}

	/**
	 * @inheritDoc
	 */
	public function resume():Void
	{
		if (!_suspended)
			return;

		_suspended = false;

		var eventConfig:EventMapConfig;
		var dispatcher:IEventDispatcher;
		while ((eventConfig = _suspendedListeners.pop()) != null)
		{
			dispatcher = eventConfig.dispatcher;
			dispatcher.addEventListener(eventConfig.eventString, eventConfig.callback, eventConfig.useCapture);
			_listeners.push(eventConfig);
		}
	}

	/*============================================================================*/
	/* private Functions                                                        */
	/*============================================================================*/

	/**
	 * Event Handler
	 *
	 * @param event The <code>Event</code>
	 * @param listener
	 * @param originalEventClass
	 */
	private function routeEventToListener(event:Event, listener:Dynamic, originalEventClass:Class<Dynamic>):Void
	{
		if (Std.is(event, originalEventClass))
		{
			listener(event);
		}
	}

	public function new() {
		
    }
}