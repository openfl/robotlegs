//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------
package robotlegs.bender.extensions.enhancedLogging.impl;

import org.swiftsuspenders.InjectionEvent;
import org.swiftsuspenders.mapping.MappingEvent;
import robotlegs.bender.framework.api.IInjector;
import robotlegs.bender.framework.api.ILogger;

/**
 * @private
 */
@:keepSub
class InjectorListener {
	/*============================================================================*/
	/* Private Static Properties                                                  */
	/*============================================================================*/
	private static var INJECTION_TYPES:Array<Dynamic> = [
		InjectionEvent.POST_CONSTRUCT,
		InjectionEvent.POST_INSTANTIATE,
		InjectionEvent.PRE_CONSTRUCT
	];

	private static var MAPPING_TYPES:Array<Dynamic> = [
		MappingEvent.MAPPING_OVERRIDE,
		MappingEvent.POST_MAPPING_CHANGE,
		MappingEvent.POST_MAPPING_CREATE,
		MappingEvent.POST_MAPPING_REMOVE,
		MappingEvent.PRE_MAPPING_CHANGE,
		MappingEvent.PRE_MAPPING_CREATE
	];

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/
	private var _injector:IInjector;

	private var _logger:ILogger;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/
	/**
	 * Creates an Injector Listener
	 * @param injector Injector
	 * @param logger Logger
	 */
	public function new(injector:IInjector, logger:ILogger) {
		_injector = injector;
		_logger = logger;
		addListeners();
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/
	/**
	 * Destroys this listener
	 */
	public function destroy():Void {
		var type:String;
		for (type in INJECTION_TYPES) {
			_injector.removeEventListener(type, onInjectionEvent);
		}
		for (type in MAPPING_TYPES) {
			_injector.removeEventListener(type, onMappingEvent);
		}
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/
	private function addListeners():Void {
		var type:String;
		for (type in INJECTION_TYPES) {
			_injector.addEventListener(type, onInjectionEvent);
		}
		for (type in MAPPING_TYPES) {
			_injector.addEventListener(type, onMappingEvent);
		}
	}

	private function onInjectionEvent(event:InjectionEvent):Void {
		_logger.debug("Injection event of type {0}. Instance: {1}. Instance type: {2}", [event.type, event.instance, event.instanceType]);
	}

	private function onMappingEvent(event:MappingEvent):Void {
		_logger.debug("Mapping event of type {0}. Mapped type: {1}. Mapped name: {2}", [event.type, event.mappedType, event.mappedName]);
	}
}
