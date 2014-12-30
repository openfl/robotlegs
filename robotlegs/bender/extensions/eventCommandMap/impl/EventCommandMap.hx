//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventCommandMap.impl;

import openfl.events.IEventDispatcher;
import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;
import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;
import robotlegs.bender.extensions.commandCenter.impl.CommandTriggerMap;
import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IInjector;
import robotlegs.bender.framework.api.ILogger;

/**
 * @private
 */
@:rtti
class EventCommandMap implements IEventCommandMap
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _mappingProcessors:Array<Dynamic> = [];

	private var _injector:IInjector;

	private var _dispatcher:IEventDispatcher;

	private var _triggerMap:CommandTriggerMap;

	private var _logger:ILogger;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function new(context:IContext, dispatcher:IEventDispatcher)
	{
		_injector = context.injector;
		_logger = context.getLogger(this);
		_dispatcher = dispatcher;
		_triggerMap = new CommandTriggerMap(getKey, createTrigger);
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @inheritDoc
	 */
	public function map(type:String, eventClass:Class<Dynamic> = null):ICommandMapper
	{
		return getTrigger(type, eventClass).createMapper();
	}

	/**
	 * @inheritDoc
	 */
	public function unmap(type:String, eventClass:Class<Dynamic> = null):ICommandUnmapper
	{
		return getTrigger(type, eventClass).createMapper();
	}

	/**
	 * @inheritDoc
	 */
	public function addMappingProcessor(handler:Void->Void):IEventCommandMap
	{
		if (_mappingProcessors.indexOf(handler) == -1)
			_mappingProcessors.push(handler);
		return this;
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	private function getKey(type:String, eventClass:Class<Dynamic>):String
	{
		return type + eventClass;
	}

	private function getTrigger(type:String, eventClass:Class<Dynamic>):EventCommandTrigger
	{
		return cast(_triggerMap.getTrigger([type, eventClass]), EventCommandTrigger);
	}

	private function createTrigger(type:String, eventClass:Class<Dynamic>):EventCommandTrigger
	{
		return new EventCommandTrigger(_injector, _dispatcher, type, eventClass, _mappingProcessors, _logger);
	}
}