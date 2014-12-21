//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl;

import openfl.events.EventDispatcher;
import openfl.events.IEventDispatcher;
import openfl.utils.Dictionary;
import robotlegs.bender.framework.api.ILifecycle;
import robotlegs.bender.framework.api.LifecycleError;
import robotlegs.bender.framework.api.LifecycleEvent;
import robotlegs.bender.framework.api.LifecycleState;

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
 * Default object lifecycle
 *
 * @private
 */
class Lifecycle implements ILifecycle
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	private var _state:String = LifecycleState.UNINITIALIZED;

	[Bindable("stateChange")]
	/**
	 * @inheritDoc
	 */
	public function get state():String
	{
		return _state;
	}

	private var _target:Dynamic;

	/**
	 * @inheritDoc
	 */
	public function get target():Dynamic
	{
		return _target;
	}

	/**
	 * @inheritDoc
	 */
	public function get uninitialized():Bool
	{
		return _state == LifecycleState.UNINITIALIZED;
	}

	/**
	 * @inheritDoc
	 */
	public function get initialized():Bool
	{
		return _state != LifecycleState.UNINITIALIZED
			&& _state != LifecycleState.INITIALIZING;
	}

	/**
	 * @inheritDoc
	 */
	public function get active():Bool
	{
		return _state == LifecycleState.ACTIVE;
	}

	/**
	 * @inheritDoc
	 */
	public function get suspended():Bool
	{
		return _state == LifecycleState.SUSPENDED;
	}

	/**
	 * @inheritDoc
	 */
	public function get destroyed():Bool
	{
		return _state == LifecycleState.DESTROYED;
	}

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _reversedEventTypes:Dictionary = new Dictionary();

	private var _reversePriority:Int;

	private var _initialize:LifecycleTransition;

	private var _suspend:LifecycleTransition;

	private var _resume:LifecycleTransition;

	private var _destroy:LifecycleTransition;

	private var _dispatcher:IEventDispatcher;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * Creates a lifecycle for a given target object
	 * @param target The target object
	 */
	public function new(target:Dynamic)
	{
		_target = target;
		_dispatcher = target as IEventDispatcher || new EventDispatcher(this);
		configureTransitions();
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @inheritDoc
	 */
	public function initialize(callback:Dynamic = null):Void
	{
		_initialize.enter(callback);
	}

	/**
	 * @inheritDoc
	 */
	public function suspend(callback:Dynamic = null):Void
	{
		_suspend.enter(callback);
	}

	/**
	 * @inheritDoc
	 */
	public function resume(callback:Dynamic = null):Void
	{
		_resume.enter(callback);
	}

	/**
	 * @inheritDoc
	 */
	public function destroy(callback:Dynamic = null):Void
	{
		_destroy.enter(callback);
	}

	/**
	 * @inheritDoc
	 */
	public function beforeInitializing(handler:Dynamic):ILifecycle
	{
		uninitialized || reportError(LifecycleError.LATE_HANDLER_ERROR_MESSAGE);
		_initialize.addBeforeHandler(handler);
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function whenInitializing(handler:Dynamic):ILifecycle
	{
		initialized && reportError(LifecycleError.LATE_HANDLER_ERROR_MESSAGE);
		addEventListener(LifecycleEvent.INITIALIZE, createSyncLifecycleListener(handler, true));
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function afterInitializing(handler:Dynamic):ILifecycle
	{
		initialized && reportError(LifecycleError.LATE_HANDLER_ERROR_MESSAGE);
		addEventListener(LifecycleEvent.POST_INITIALIZE, createSyncLifecycleListener(handler, true));
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function beforeSuspending(handler:Dynamic):ILifecycle
	{
		_suspend.addBeforeHandler(handler);
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function whenSuspending(handler:Dynamic):ILifecycle
	{
		addEventListener(LifecycleEvent.SUSPEND, createSyncLifecycleListener(handler));
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function afterSuspending(handler:Dynamic):ILifecycle
	{
		addEventListener(LifecycleEvent.POST_SUSPEND, createSyncLifecycleListener(handler));
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function beforeResuming(handler:Dynamic):ILifecycle
	{
		_resume.addBeforeHandler(handler);
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function whenResuming(handler:Dynamic):ILifecycle
	{
		addEventListener(LifecycleEvent.RESUME, createSyncLifecycleListener(handler));
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function afterResuming(handler:Dynamic):ILifecycle
	{
		addEventListener(LifecycleEvent.POST_RESUME, createSyncLifecycleListener(handler));
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function beforeDestroying(handler:Dynamic):ILifecycle
	{
		_destroy.addBeforeHandler(handler);
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function whenDestroying(handler:Dynamic):ILifecycle
	{
		addEventListener(LifecycleEvent.DESTROY, createSyncLifecycleListener(handler, true));
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function afterDestroying(handler:Dynamic):ILifecycle
	{
		addEventListener(LifecycleEvent.POST_DESTROY, createSyncLifecycleListener(handler, true));
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function addEventListener(type:String, listener:Dynamic, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void
	{
		priority = flipPriority(type, priority);
		_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
	}

	/**
	 * @inheritDoc
	 */
	public function removeEventListener(type:String, listener:Dynamic, useCapture:Bool = false):Void
	{
		_dispatcher.removeEventListener(type, listener, useCapture);
	}

	/**
	 * @inheritDoc
	 */
	public function dispatchEvent(event:Event):Bool
	{
		return _dispatcher.dispatchEvent(event);
	}

	/**
	 * @inheritDoc
	 */
	public function hasEventListener(type:String):Bool
	{
		return _dispatcher.hasEventListener(type);
	}

	/**
	 * @inheritDoc
	 */
	public function willTrigger(type:String):Bool
	{
		return _dispatcher.willTrigger(type);
	}

	/*============================================================================*/
	/* Internal Functions                                                         */
	/*============================================================================*/

	internal function setCurrentState(state:String):Void
	{
		if (_state == state)
			return;
		_state = state;
		dispatchEvent(new LifecycleEvent(LifecycleEvent.STATE_CHANGE));
	}

	internal function addReversedEventTypes(... types):Void
	{
		for each (var type:String in types)
		{
			_reversedEventTypes[type] = true;
		}
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	private function configureTransitions():Void
	{
		_initialize = new LifecycleTransition(LifecycleEvent.PRE_INITIALIZE, this)
			.fromStates(LifecycleState.UNINITIALIZED)
			.toStates(LifecycleState.INITIALIZING, LifecycleState.ACTIVE)
			.withEvents(LifecycleEvent.PRE_INITIALIZE, LifecycleEvent.INITIALIZE, LifecycleEvent.POST_INITIALIZE);

		_suspend = new LifecycleTransition(LifecycleEvent.PRE_SUSPEND, this)
			.fromStates(LifecycleState.ACTIVE)
			.toStates(LifecycleState.SUSPENDING, LifecycleState.SUSPENDED)
			.withEvents(LifecycleEvent.PRE_SUSPEND, LifecycleEvent.SUSPEND, LifecycleEvent.POST_SUSPEND)
			.inReverse();

		_resume = new LifecycleTransition(LifecycleEvent.PRE_RESUME, this)
			.fromStates(LifecycleState.SUSPENDED)
			.toStates(LifecycleState.RESUMING, LifecycleState.ACTIVE)
			.withEvents(LifecycleEvent.PRE_RESUME, LifecycleEvent.RESUME, LifecycleEvent.POST_RESUME);

		_destroy = new LifecycleTransition(LifecycleEvent.PRE_DESTROY, this)
			.fromStates(LifecycleState.SUSPENDED, LifecycleState.ACTIVE)
			.toStates(LifecycleState.DESTROYING, LifecycleState.DESTROYED)
			.withEvents(LifecycleEvent.PRE_DESTROY, LifecycleEvent.DESTROY, LifecycleEvent.POST_DESTROY)
			.inReverse();
	}

	private function flipPriority(type:String, priority:Int):Int
	{
		return (priority == 0 && _reversedEventTypes[type])
			? _reversePriority++
			: priority;
	}

	private function createSyncLifecycleListener(handler:Dynamic, once:Bool = false):Dynamic
	{
		// When and After handlers can not be asynchronous
		if (handler.length > 1)
		{
			throw new LifecycleError(LifecycleError.SYNC_HANDLER_ARG_MISMATCH);
		}

		// A handler that accepts 1 argument is provided with the event type
		if (handler.length == 1)
		{
			return function(event:LifecycleEvent):Void {
				once && IEventDispatcher(event.target)
					.removeEventListener(event.type, arguments.callee);
				handler(event.type);
			};
		}

		// Or, just call the handler
		return function(event:LifecycleEvent):Void {
			once && IEventDispatcher(event.target)
				.removeEventListener(event.type, arguments.callee);
			handler();
		};
	}

	private function reportError(message:String):Void
	{
		var error:LifecycleError = new LifecycleError(message);
		if (hasEventListener(LifecycleEvent.ERROR))
		{
			var event:LifecycleEvent = new LifecycleEvent(LifecycleEvent.ERROR, error);
			dispatchEvent(event);
		}
		else
		{
			throw error;
		}
	}
}