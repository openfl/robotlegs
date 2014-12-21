//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.api;

import openfl.events.Event;

/**
 * Detain/release pin Event
 */
class PinEvent extends Event
{

	/*============================================================================*/
	/* Public Static Properties                                                   */
	/*============================================================================*/

	public static var DETAIN:String = "detain";

	public static var RELEASE:String = "release";

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	private var _instance:Dynamic;

	/**
	 * The instance being detained or released
	 */
	public function get instance():Dynamic
	{
		return _instance;
	}

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * Create a Pin Event
	 * @param type The event type
	 * @param instance The associated instance
	 */
	public function new(type:String, instance:Dynamic)
	{
		super(type);
		_instance = instance;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @inheritDoc
	 */
	override public function clone():Event
	{
		return new PinEvent(type, _instance);
	}
}
