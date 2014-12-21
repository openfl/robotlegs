//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl;

import openfl.events.EventDispatcher;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IInjector;
import robotlegs.bender.framework.api.ILogTarget;
import robotlegs.bender.framework.api.ILogger;
import robotlegs.bender.framework.api.IMatcher;
import robotlegs.bender.framework.api.LifecycleEvent;

@:meta(Event(name="destroy", type="robotlegs.bender.framework.api.LifecycleEvent"))
@:meta(Event(name="detain", type="robotlegs.bender.framework.api.PinEvent"))
@:meta(Event(name="initialize", type="robotlegs.bender.framework.api.LifecycleEvent"))
@:meta(Event(name="postDestroy", type="robotlegs.bender.framework.api.LifecycleEvent"))
@:meta(Event(name="postInitialize", type="robotlegs.bender.framework.api.LifecycleEvent"))
@:meta(Event(name="postResume", type="robotlegs.bender.framework.api.LifecycleEvent"))
@:meta(Event(name="postSuspend", type="robotlegs.bender.framework.api.LifecycleEvent"))
@:meta(Event(name="preDestroy", type="robotlegs.bender.framework.api.LifecycleEvent"))
@:meta(Event(name="preInitialize", type="robotlegs.bender.framework.api.LifecycleEvent"))
@:meta(Event(name="preResume", type="robotlegs.bender.framework.api.LifecycleEvent"))
@:meta(Event(name="preSuspend", type="robotlegs.bender.framework.api.LifecycleEvent"))
@:meta(Event(name="release", type="robotlegs.bender.framework.api.PinEvent"))
@:meta(Event(name="resume", type="robotlegs.bender.framework.api.LifecycleEvent"))
@:meta(Event(name="stateChange", type="robotlegs.bender.framework.api.LifecycleEvent"))
@:meta(Event(name="suspend", type="robotlegs.bender.framework.api.LifecycleEvent"))
/**
 * The core Robotlegs Context implementation
 */
class Context extends EventDispatcher implements IContext
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	private var _injector:IInjector = new RobotlegsInjector();

	/**
	 * @inheritDoc
	 */
	public function get injector():IInjector
	{
		return _injector;
	}

	/**
	 * @inheritDoc
	 */
	public function get logLevel():UInt
	{
		return _logManager.logLevel;
	}

	/**
	 * @inheritDoc
	 */
	public function set logLevel(value:UInt):Void
	{
		_logManager.logLevel = value;
	}

	[Bindable("stateChange")]
	/**
	 * @inheritDoc
	 */
	public function get state():String
	{
		return _lifecycle.state;
	}

	/**
	 * @inheritDoc
	 */
	public function get uninitialized():Bool
	{
		return _lifecycle.uninitialized;
	}

	/**
	 * @inheritDoc
	 */
	public function get initialized():Bool
	{
		return _lifecycle.initialized;
	}

	/**
	 * @inheritDoc
	 */
	public function get active():Bool
	{
		return _lifecycle.active;
	}

	/**
	 * @inheritDoc
	 */
	public function get suspended():Bool
	{
		return _lifecycle.suspended;
	}

	/**
	 * @inheritDoc
	 */
	public function get destroyed():Bool
	{
		return _lifecycle.destroyed;
	}

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _uid:String = UID.create(Context);

	private var _logManager:LogManager = new LogManager();

	private var _children:Array<Dynamic> = [];

	private var _pin:Pin;

	private var _lifecycle:Lifecycle;

	private var _configManager:ConfigManager;

	private var _extensionInstaller:ExtensionInstaller;

	private var _logger:ILogger;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * Creates a new Context
	 */
	public function new()
	{
		setup();
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @inheritDoc
	 */
	public function initialize(callback:Function = null):Void
	{
		_lifecycle.initialize(callback);
	}

	/**
	 * @inheritDoc
	 */
	public function suspend(callback:Function = null):Void
	{
		_lifecycle.suspend(callback);
	}

	/**
	 * @inheritDoc
	 */
	public function resume(callback:Function = null):Void
	{
		_lifecycle.resume(callback);
	}

	/**
	 * @inheritDoc
	 */
	public function destroy(callback:Function = null):Void
	{
		_lifecycle.destroy(callback);
	}

	/**
	 * @inheritDoc
	 */
	public function beforeInitializing(handler:Function):IContext
	{
		_lifecycle.beforeInitializing(handler);
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function whenInitializing(handler:Function):IContext
	{
		_lifecycle.whenInitializing(handler);
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function afterInitializing(handler:Function):IContext
	{
		_lifecycle.afterInitializing(handler);
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function beforeSuspending(handler:Function):IContext
	{
		_lifecycle.beforeSuspending(handler);
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function whenSuspending(handler:Function):IContext
	{
		_lifecycle.whenSuspending(handler);
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function afterSuspending(handler:Function):IContext
	{
		_lifecycle.afterSuspending(handler);
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function beforeResuming(handler:Function):IContext
	{
		_lifecycle.beforeResuming(handler);
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function whenResuming(handler:Function):IContext
	{
		_lifecycle.whenResuming(handler);
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function afterResuming(handler:Function):IContext
	{
		_lifecycle.afterResuming(handler);
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function beforeDestroying(handler:Function):IContext
	{
		_lifecycle.beforeDestroying(handler);
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function whenDestroying(handler:Function):IContext
	{
		_lifecycle.whenDestroying(handler);
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function afterDestroying(handler:Function):IContext
	{
		_lifecycle.afterDestroying(handler);
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function install(... extensions):IContext
	{
		for each (var extension:Dynamic in extensions)
		{
			_extensionInstaller.install(extension);
		}
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function configure(... configs):IContext
	{
		for each (var config:Dynamic in configs)
		{
			_configManager.addConfig(config);
		}
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function addChild(child:IContext):IContext
	{
		if (_children.indexOf(child) == -1)
		{
			_logger.info("Adding child context {0}", [child]);
			if (child.uninitialized == null)
			{
				_logger.warn("Child context {0} must be uninitialized", [child]);
			}
			if (child.injector.parent)
			{
				_logger.warn("Child context {0} must not have a parent Injector", [child]);
			}
			_children.push(child);
			child.injector.parent = injector;
			child.addEventListener(LifecycleEvent.POST_DESTROY, onChildDestroy);
		}
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function removeChild(child:IContext):IContext
	{
		var childIndex:Int = _children.indexOf(child);
		if (childIndex > -1)
		{
			_logger.info("Removing child context {0}", [child]);
			_children.splice(childIndex, 1);
			child.injector.parent = null;
			child.removeEventListener(LifecycleEvent.POST_DESTROY, onChildDestroy);
		}
		else
		{
			_logger.warn("Child context {0} must be a child of {1}", [child, this]);
		}
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function addConfigHandler(matcher:IMatcher, handler:Function):IContext
	{
		_configManager.addConfigHandler(matcher, handler);
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function getLogger(source:Dynamic):ILogger
	{
		return _logManager.getLogger(source);
	}

	/**
	 * @inheritDoc
	 */
	public function addLogTarget(target:ILogTarget):IContext
	{
		_logManager.addLogTarget(target);
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function detain(... instances):IContext
	{
		for each (var instance:Dynamic in instances)
		{
			_pin.detain(instance);
		}
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function release(... instances):IContext
	{
		for each (var instance:Dynamic in instances)
		{
			_pin.release(instance);
		}
		return this;
	}

	/**
	 * @inheritDoc
	 */
	override public function toString():String
	{
		return _uid;
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	/**
	 * Configures mandatory context dependencies
	 */
	private function setup():Void
	{
		_injector.map(IInjector).toValue(_injector);
		_injector.map(IContext).toValue(this);
		_logger = _logManager.getLogger(this);
		_pin = new Pin(this);
		_lifecycle = new Lifecycle(this);
		_configManager = new ConfigManager(this);
		_extensionInstaller = new ExtensionInstaller(this);
		beforeInitializing(beforeInitializingCallback);
		afterInitializing(afterInitializingCallback);
		beforeDestroying(beforeDestroyingCallback);
		afterDestroying(afterDestroyingCallback);
	}

	private function beforeInitializingCallback():Void
	{
		_logger.info("Initializing...");
	}

	private function afterInitializingCallback():Void
	{
		_logger.info("Initialize complete");
	}

	private function beforeDestroyingCallback():Void
	{
		_logger.info("Destroying...");
	}

	private function afterDestroyingCallback():Void
	{
		_extensionInstaller.destroy();
		_configManager.destroy();
		_pin.releaseAll();
		_injector.teardown();
		removeChildren();
		_logger.info("Destroy complete");
		_logManager.removeAllTargets();
	}

	private function onChildDestroy(event:LifecycleEvent):Void
	{
		removeChild(event.target as IContext);
	}

	private function removeChildren():Void
	{
		for each (var child:IContext in _children.concat())
		{
			removeChild(child);
		}
		_children.length = 0;
	}
}