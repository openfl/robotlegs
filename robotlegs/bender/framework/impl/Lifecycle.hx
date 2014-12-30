//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl;

import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.IEventDispatcher;

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
	
	//[Bindable("stateChange")]
	@:meta(Bindable('stateChange'))
	public var state(get, null):String;
	/**
	 * @inheritDoc
	 */
	public function get_state():String
	{
		return _state;
	}

	private var _target:Dynamic;
	public var target(get, null):Dynamic;
	
	/**
	 * @inheritDoc
	 */
	public function get_target():Dynamic
	{
		return _target;
	}

	/**
	 * @inheritDoc
	 */
	public var uninitialized(get_uninitialized, null):Bool;
	public function get_uninitialized():Bool
	{
		return _state == LifecycleState.UNINITIALIZED;
	}

	/**
	 * @inheritDoc
	 */
	public var initialized(get_initialized, null):Bool;
	public function get_initialized():Bool
	{
		return _state != LifecycleState.UNINITIALIZED
			&& _state != LifecycleState.INITIALIZING;
	}

	/**
	 * @inheritDoc
	 */
	public var active(get_active, null):Bool;
	public function get_active():Bool
	{
		return _state == LifecycleState.ACTIVE;
	}

	/**
	 * @inheritDoc
	 */
	public var suspended(get_suspended, null):Bool;
	public function get_suspended():Bool
	{
		return _state == LifecycleState.SUSPENDED;
	}

	/**
	 * @inheritDoc
	 */
	public var destroyed(get_destroyed, null):Bool;
	public function get_destroyed():Bool
	{
		return _state == LifecycleState.DESTROYED;
	}

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _reversedEventTypes = new Map<String,Dynamic>();

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
		if (cast(target, IEventDispatcher) != null) _dispatcher = cast(target, IEventDispatcher);
		else _dispatcher = new EventDispatcher(this);
		configureTransitions();
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @inheritDoc
	 */
	public function initialize(callback:Void->Void = null):Void
	{
		_initialize.enter(callback);
	}

	/**
	 * @inheritDoc
	 */
	public function suspend(callback:Void->Void = null):Void
	{
		_suspend.enter(callback);
	}

	/**
	 * @inheritDoc
	 */
	public function resume(callback:Void->Void = null):Void
	{
		_resume.enter(callback);
	}

	/**
	 * @inheritDoc
	 */
	public function destroy(callback:Void->Void = null):Void
	{
		_destroy.enter(callback);
	}

	/**
	 * @inheritDoc
	 */
	public function beforeInitializing(handler:Dynamic):ILifecycle
	{
		// CHECK
		if (!uninitialized) reportError(LifecycleError.LATE_HANDLER_ERROR_MESSAGE);
		_initialize.addBeforeHandler(handler);
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function whenInitializing(handler:Dynamic):ILifecycle
	{
		// CHECK
		if (initialized) reportError(LifecycleError.LATE_HANDLER_ERROR_MESSAGE);
		addEventListener(LifecycleEvent.INITIALIZE, createSyncLifecycleListener(handler, true));
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function afterInitializing(handler:Dynamic):ILifecycle
	{
		// CHECK
		if (initialized) reportError(LifecycleError.LATE_HANDLER_ERROR_MESSAGE);
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

	public function setCurrentState(state:String):Void
	{
		if (_state == state)
			return;
		_state = state;
		dispatchEvent(new LifecycleEvent(LifecycleEvent.STATE_CHANGE));
	}
	
	//public function addReversedEventTypes(type:String/*... types*/):Void
	public function addReversedEventTypes(types:Array<String>):Void
	{
		for (i in 0...types.length)
		{
			_reversedEventTypes[types[i]] = true;
		}
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	private function configureTransitions():Void
	{
		_initialize = new LifecycleTransition(LifecycleEvent.PRE_INITIALIZE, this)
			.fromStates([LifecycleState.UNINITIALIZED])
			.toStates(LifecycleState.INITIALIZING, LifecycleState.ACTIVE)
			.withEvents(LifecycleEvent.PRE_INITIALIZE, LifecycleEvent.INITIALIZE, LifecycleEvent.POST_INITIALIZE);

		_suspend = new LifecycleTransition(LifecycleEvent.PRE_SUSPEND, this)
			.fromStates([LifecycleState.ACTIVE])
			.toStates(LifecycleState.SUSPENDING, LifecycleState.SUSPENDED)
			.withEvents(LifecycleEvent.PRE_SUSPEND, LifecycleEvent.SUSPEND, LifecycleEvent.POST_SUSPEND)
			.inReverse();
		
		_resume = new LifecycleTransition(LifecycleEvent.PRE_RESUME, this)
			.fromStates([LifecycleState.SUSPENDED])
			.toStates(LifecycleState.RESUMING, LifecycleState.ACTIVE)
			.withEvents(LifecycleEvent.PRE_RESUME, LifecycleEvent.RESUME, LifecycleEvent.POST_RESUME);
			
		_destroy = new LifecycleTransition(LifecycleEvent.PRE_DESTROY, this)
			.fromStates([LifecycleState.SUSPENDED, LifecycleState.ACTIVE])
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
		
		// CHECK
		var syncLifecycleListener:SyncLifecycleListener = new SyncLifecycleListener();
		return syncLifecycleListener.init(handler, once, handler.length);
		
		// A handler that accepts 1 argument is provided with the event type
		/*if (handler.length == 1)
		{
			return function(event:LifecycleEvent):Void {
				//once && IEventDispatcher(event.target).removeEventListener(event.type, arguments.callee);
				if (once) cast(event.target, IEventDispatcher).removeEventListener(event.type, arguments.callee);
				handler(event.type);
			};
		}

		// Or, just call the handler
		return function(event:LifecycleEvent):Void {
			//once && IEventDispatcher(event.target).removeEventListener(event.type, arguments.callee);
			if (once) cast(event.target, IEventDispatcher).removeEventListener(event.type, arguments.callee);
			handler();
		};*/
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

class SyncLifecycleListener
{
	private var once:Bool;
	private var handler:Dynamic;
	
	public function new()
	{
		
	}
	
	public function init(handler:Dynamic, once:Bool, handlerLength:Int) 
	{
		this.handler = handler;
		this.once = once;
		if (handlerLength == 1) return createSyncLifecycleListenerFunction;
		return createSyncLifecycleListenerFunction2;
	}
	
	private function createSyncLifecycleListenerFunction(event:LifecycleEvent):Void
	{
		if (once) cast(event.target, IEventDispatcher).removeEventListener(event.type, createSyncLifecycleListenerFunction);
		handler(event.type);
	}

	private function createSyncLifecycleListenerFunction2(event:LifecycleEvent):Void
	{
		if (once) cast(event.target, IEventDispatcher).removeEventListener(event.type, createSyncLifecycleListenerFunction2);
		handler();
	}
}