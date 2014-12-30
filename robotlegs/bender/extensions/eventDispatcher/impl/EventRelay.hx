//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventDispatcher.impl;

import openfl.events.IEventDispatcher;

/**
 * Relays events from a source to a destination
 */
class EventRelay
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _source:IEventDispatcher;

	private var _destination:IEventDispatcher;

	private var _types:Array<Dynamic>;

	private var _active:Bool = false;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * Relays events from the source to the destination
	 * @param source Event Dispatcher
	 * @param destination Event Dispatcher
	 * @param types The list of event types to relay
	 */
	public function new(source:IEventDispatcher, destination:IEventDispatcher, types:Array<Dynamic> = null)
	{
		_source = source;
		_destination = destination;
		if (types != null) _types = types;
		else _types = [];
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * Start relaying events
	 * @return Self
	 */
	public function start():EventRelay
	{
		if (!_active)
		{
			_active = true;
			addListeners();
		}
		return this;
	}

	/**
	 * Stop relaying events
	 * @return Self
	 */
	public function stop():EventRelay
	{
		if (_active)
		{
			_active = false;
			removeListeners();
		}
		return this;
	}

	/**
	 * Add a new event type to relay
	 * @param eventType
	 */
	public function addType(eventType:String):Void
	{
		_types.push(eventType);
		if (_active) addListener(eventType);
	}

	/**
	 * Remove a relay event type
	 * @param eventType
	 */
	public function removeType(eventType:String):Void
	{
		var index:Int = _types.indexOf(eventType);
		if (index > -1)
		{
			_types.splice(index, 1);
			removeListener(eventType);
		}
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	private function removeListener(type:String):Void
	{
		_source.removeEventListener(type, _destination.dispatchEvent);
	}

	private function addListener(type:String):Void
	{
		_source.addEventListener(type, _destination.dispatchEvent);
	}

	private function addListeners():Void
	{
		for (type in _types)
		{
			addListener(type);
		}
	}

	private function removeListeners():Void
	{
		for (type in _types)
		{
			removeListener(type);
		}
	}
}