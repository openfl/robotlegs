//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------
package robotlegs.bender.framework.api;

import robotlegs.errors.Error;
import polyfill.events.Event;

/**
 * Robotlegs object lifecycle event
 */
@:keepSub
class LifecycleEvent extends Event {
	/*============================================================================*/
	/* Public Static Properties                                                   */
	/*============================================================================*/
	public static var ERROR:String = "_error";

	public static var STATE_CHANGE:String = "stateChange";

	public static var PRE_INITIALIZE:String = "preInitialize";

	public static var INITIALIZE:String = "initialize";

	public static var POST_INITIALIZE:String = "postInitialize";

	public static var PRE_SUSPEND:String = "preSuspend";

	public static var SUSPEND:String = "suspend";

	public static var POST_SUSPEND:String = "postSuspend";

	public static var PRE_RESUME:String = "preResume";

	public static var RESUME:String = "resume";

	public static var POST_RESUME:String = "postResume";

	public static var PRE_DESTROY:String = "preDestroy";

	public static var DESTROY:String = "destroy";

	public static var POST_DESTROY:String = "postDestroy";

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/
	private var _error:Error;

	public var error(default, null):Error;

	/**
	 * Associated lifecycle error
	 */
	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/
	/**
	 * Creates a Lifecycle Event
	 * @param type The event type
	 * @param error Optional error
	 */
	public function new(type:String, error:Error = null) {
		super(type);
		_error = error;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/
	/**
	 * @inheritDoc
	 */
	override public function clone():Event {
		return new LifecycleEvent(type, error);
	}
}
