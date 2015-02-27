//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl;

import openfl.events.IEventDispatcher;
import robotlegs.bender.framework.api.PinEvent;

/**
 * Pins objects in memory
 *
 * @private
 */
@:keepSub
class Pin
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _instances = new Map<String, Dynamic>();

	private var _dispatcher:IEventDispatcher;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function new(dispatcher:IEventDispatcher)
	{
		_dispatcher = dispatcher;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * Pin an object in memory
	 * @param instance Instance to pin
	 */
	public function detain(instance:Dynamic):Void
	{
		if (_instances[instance] == null)
		{
			_instances[instance] = true;
			_dispatcher.dispatchEvent(new PinEvent(PinEvent.DETAIN, instance));
		}
	}

	/**
	 * Unpins an object
	 * @param instance Instance to unpin
	 */
	public function release(instance:Dynamic):Void
	{
		if (_instances[instance])
		{
			_instances.remove(instance);
			_dispatcher.dispatchEvent(new PinEvent(PinEvent.RELEASE, instance));
		}
	}

	/**
	 * Removes all pins
	 */
	public function releaseAll():Void
	{
		for (instance in _instances)
		{
			release(instance);
		}
	}
}