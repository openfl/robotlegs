//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.api;

import openfl.events.IEventDispatcher;

@:meta(Event(name="destroy", type="robotlegs.bender.framework.api.LifecycleEvent"))
@:meta(Event(name="error", type="robotlegs.bender.framework.api.LifecycleEvent"))
@:meta(Event(name="initialize", type="robotlegs.bender.framework.api.LifecycleEvent"))
@:meta(Event(name="postDestroy", type="robotlegs.bender.framework.api.LifecycleEvent"))
@:meta(Event(name="postInitialize", type="robotlegs.bender.framework.api.LifecycleEvent"))
@:meta(Event(name="postResume", type="robotlegs.bender.framework.api.LifecycleEvent"))
@:meta(Event(name="postSuspend", type="robotlegs.bender.framework.api.LifecycleEvent"))
@:meta(Event(name="preDestroy", type="robotlegs.bender.framework.api.LifecycleEvent"))
@:meta(Event(name="preInitialize", type="robotlegs.bender.framework.api.LifecycleEvent"))
@:meta(Event(name="preResume", type="robotlegs.bender.framework.api.LifecycleEvent"))
@:meta(Event(name="preSuspend", type="robotlegs.bender.framework.api.LifecycleEvent"))
@:meta(Event(name="resume", type="robotlegs.bender.framework.api.LifecycleEvent"))
@:meta(Event(name="stateChange", type="robotlegs.bender.framework.api.LifecycleEvent"))
@:meta(Event(name="suspend", type="robotlegs.bender.framework.api.LifecycleEvent"))
/**
 * The Robotlegs object lifecycle contract
 */
interface ILifecycle extends IEventDispatcher
{
	/**
	 * The current lifecycle state of the target object
	 */
	function get_state():String;

	/**
	 * The target object associated with this lifecycle
	 */
	function get_target():Dynamic;

	/**
	 * Is this object uninitialized?
	 */
	function get_uninitialized():Bool;

	/**
	 * Has this object been fully initialized?
	 */
	function get_initialized():Bool;

	/**
	 * Is this object currently active?
	 */
	function get_active():Bool;

	/**
	 * Has this object been fully suspended?
	 */
	function get_suspended():Bool;

	/**
	 * Has this object been fully destroyed?
	 */
	function get_destroyed():Bool;

	/**
	 * Initializes the lifecycle
	 * @param callback Initialization callback
	 */
	function initialize(callback:Void->Void = null):Void;

	/**
	 * Suspends the lifecycle
	 * @param callback Suspension callback
	 */
	function suspend(callback:Void->Void = null):Void;

	/**
	 * Resumes a suspended lifecycle
	 * @param callback Resumption callback
	 */
	function resume(callback:Void->Void = null):Void;

	/**
	 * Destroys an active lifecycle
	 * @param callback Destruction callback
	 */
	function destroy(callback:Void->Void = null):Void;

	/**
	 * A handler to run before the target object is initialized
	 *
	 * <p>The handler can be asynchronous. See: readme-async</p>
	 *
	 * @param handler Pre-initialize handler
	 * @return Self
	 */
	function beforeInitializing(handler:Void->Void):ILifecycle;

	/**
	 * A handler to run during initialization
	 *
	 * <p>Note: The handler must be synchronous.</p>
	 * @param handler Initialization handler
	 * @return Self
	 */
	function whenInitializing(handler:Void->Void):ILifecycle;

	/**
	 * A handler to run after initialization
	 *
	 * <p>Note: The handler must be synchronous.</p>
	 * @param handler Post-initialize handler
	 * @return Self
	 */
	function afterInitializing(handler:Void->Void):ILifecycle;

	/**
	 * A handler to run before the target object is suspended
	 *
	 * <p>The handler can be asynchronous. See: readme-async</p>
	 *
	 * @param handler Pre-suspend handler
	 * @return Self
	 */
	function beforeSuspending(handler:Void->Void):ILifecycle;

	/**
	 * A handler to run during suspension
	 *
	 * <p>Note: The handler must be synchronous.</p>
	 * @param handler Suspension handler
	 * @return Self
	 */
	function whenSuspending(handler:Void->Void):ILifecycle;

	/**
	 * A handler to run after suspension
	 *
	 * <p>Note: The handler must be synchronous.</p>
	 * @param handler Post-suspend handler
	 * @return Self
	 */
	function afterSuspending(handler:Void->Void):ILifecycle;

	/**
	 * A handler to run before the target object is resumed
	 *
	 * <p>The handler can be asynchronous. See: readme-async</p>
	 *
	 * @param handler Pre-resume handler
	 * @return Self
	 */
	function beforeResuming(handler:Void->Void):ILifecycle;

	/**
	 * A handler to run during resumption
	 *
	 * <p>Note: The handler must be synchronous.</p>
	 * @param handler Resumption handler
	 * @return Self
	 */
	function whenResuming(handler:Void->Void):ILifecycle;

	/**
	 * A handler to run after resumption
	 *
	 * <p>Note: The handler must be synchronous.</p>
	 * @param handler Post-resume handler
	 * @return Self
	 */
	function afterResuming(handler:Void->Void):ILifecycle;

	/**
	 * A handler to run before the target object is destroyed
	 *
	 * <p>The handler can be asynchronous. See: readme-async</p>
	 *
	 * @param handler Pre-destroy handler
	 * @return Self
	 */
	function beforeDestroying(handler:Void->Void):ILifecycle;

	/**
	 * A handler to run during destruction
	 *
	 * <p>Note: The handler must be synchronous.</p>
	 * @param handler Destruction handler
	 * @return Self
	 */
	function whenDestroying(handler:Void->Void):ILifecycle;

	/**
	 * A handler to run after destruction
	 *
	 * <p>Note: The handler must be synchronous.</p>
	 * @param handler Post-destroy handler
	 * @return Self
	 */
	function afterDestroying(handler:Void->Void):ILifecycle;
}