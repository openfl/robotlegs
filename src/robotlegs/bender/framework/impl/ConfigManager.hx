//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------
package robotlegs.bender.framework.impl;

import org.swiftsuspenders.utils.CallProxy;
import org.swiftsuspenders.utils.UID;
import robotlegs.bender.framework.api.IConfig;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IInjector;
import robotlegs.bender.framework.api.ILogger;
import robotlegs.bender.framework.api.IMatcher;
import robotlegs.bender.framework.api.LifecycleEvent;
import robotlegs.bender.framework.api.IConfig.IConfig_Or_Class;

/**
 * The config manager handles configuration files and
 * allows the installation of custom configuration handlers.
 *
 * <p>It is pre-configured to handle plain objects and classes</p>
 *
 * @private
 */
@:keepSub
class ConfigManager {
	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/
	private var _objectProcessor:ObjectProcessor = new ObjectProcessor();

	private var _configs = new Map<String, Bool>();

	private var _queue:Array<Dynamic> = [];

	private var _injector:IInjector;

	private var _logger:ILogger;

	private var _initialized:Bool = false;

	private var _context:IContext;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/
	/**
	 * @private
	 */
	public function new(context:IContext) {
		_context = context;

		_injector = context.injector;
		_logger = context.getLogger(this);
		addConfigHandler(new ClassMatcher(), handleClass);
		addConfigHandler(new ObjectMatcher(), handleObject);
		// The ConfigManager should process the config queue
		// at the end of the INITIALIZE phase,
		// but *before* POST_INITIALIZE, so use low event priority
		context.addEventListener(LifecycleEvent.INITIALIZE, initialize, false, -100);
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/
	/**
	 * Process a given configuration object by running it through registered handlers.
	 * <p>If the manager is not initialized the configuration will be queued.</p>
	 * @param config The configuration object or class
	 */
	public function addConfig(config:IConfig_Or_Class):Void {
		if (config == null)
			return;

		#if (js)
		if (!Std.isOfType(config, Class)) {
			Reflect.setProperty(config, "constructor", Type.getClass(config));
		}
		#end

		var id = UID.instanceID(config);
		if (_configs[id] == null) {
			_configs[id] = true;
			_objectProcessor.processObject(config);
		}
	}

	/**
	 * Adds a custom configuration handlers
	 * @param matcher Pattern to match configuration objects
	 * @param handler Handler to process matching configurations
	 */
	public function addConfigHandler(matcher:IMatcher, handler:Dynamic):Void {
		_objectProcessor.addObjectHandler(matcher, handler);
	}

	/**
	 * Destroy
	 */
	public function destroy():Void {
		_context.removeEventListener(LifecycleEvent.INITIALIZE, initialize);
		_objectProcessor.removeAllHandlers();
		_queue = [];
		for (config in _configs) {
			_configs.remove(UID.clearInstanceID(config));
		}
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/
	private function initialize(event:LifecycleEvent):Void {
		if (_initialized == false) {
			_initialized = true;
			processQueue();
		}
	}

	private function handleClass(type:Class<Dynamic>):Void {
		if (_initialized) {
			_logger.debug("Already initialized. Instantiating config class {0}", [type]);
			processClass(type);
		} else {
			_logger.debug("Not yet initialized. Queuing config class {0}", [type]);
			_queue.push(type);
		}
	}

	private function handleObject(object:Dynamic):Void {
		if (_initialized) {
			_logger.debug("Already initialized. Injecting into config object {0}", [object]);
			processObject(object);
		} else {
			_logger.debug("Not yet initialized. Queuing config object {0}", [object]);
			_queue.push(object);
		}
	}

	private function processQueue():Void {
		for (config in _queue) {
			if (Std.isOfType(config, Class)) {
				#if js
				_logger.debug("Now initializing. Instantiating config class {0}", [Type.getClassName(config)]);
				#else
				_logger.debug("Now initializing. Instantiating config class {0}", [config]);
				#end

				processClass(cast(config, Class<Dynamic>));
			} else {
				#if js
				_logger.debug("Now initializing. Injecting into config object {0}", [Type.getClassName((Type.getClass(config)))]);
				#else
				_logger.debug("Now initializing. Injecting into config object {0}", [config]);
				#end

				processObject(config);
			}
		}
		_queue = [];
	}

	private function processClass(type:Class<Dynamic>):Void {
		processObject(_injector.getOrCreateNewInstance(type), false);
	}

	private function processObject(object:IConfig, inject:Bool = true):Void {
		if (object == null)
			return;
		if (inject)
			_injector.injectInto(object);

		var configure:Void->Void = object.configure;
		if (configure != null)
			configure();
	}
}
