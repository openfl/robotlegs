//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.signalCommandMap.impl;

import msignal.Signal;
import robotlegs.bender.framework.api.IInjector;
import robotlegs.bender.extensions.commandCenter.api.ICommandExecutor;
import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
import robotlegs.bender.extensions.commandCenter.impl.CommandExecutor;
import robotlegs.bender.extensions.commandCenter.impl.CommandMapper;
import robotlegs.bender.extensions.commandCenter.impl.CommandMappingList;
import robotlegs.bender.extensions.commandCenter.api.CommandPayload;
import robotlegs.bender.framework.api.ILogger;

/**
 * @private
 */
@:keepSub
class SignalCommandTrigger implements ICommandTrigger
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _signalClass:Class<Dynamic>;

	private var _signal:AnySignal;

	private var _injector:IInjector;

	private var _mappings:CommandMappingList;

	private var _executor:ICommandExecutor;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function new(injector:IInjector, signalClass:Class<Dynamic>, processors:Array<Dynamic> = null, logger:ILogger = null)
	{
		_injector = injector;

		_signalClass = signalClass;
		_mappings = new CommandMappingList(this, processors, logger);
		_executor = new CommandExecutor(injector, _mappings.removeMapping);
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function createMapper():CommandMapper
	{
		return new CommandMapper(_mappings);
	}

	/**
	 * @inheritDoc
	 */
	public function activate():Void
	{
		if (!_injector.hasMapping(_signalClass))
			_injector.map(_signalClass).asSingleton();
		_signal = _injector.getInstance(_signalClass);
		// FIX
		_signal.add(routePayloadToCommands);
	}

	/**
	 * @inheritDoc
	 */
	public function deactivate():Void
	{
		// FIX
		//if (_signal != null)
		//	_signal.remove(routePayloadToCommands);
	}

	public function toString():String
	{
		return cast(_signalClass, String);
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	/*private function routePayloadToCommands(valueObjects:Array<Dynamic>):Void
	{
		var payload:CommandPayload = new CommandPayload(valueObjects, _signal.valueClasses);
		_executor.executeCommands(_mappings.getList(), payload);
	}*/
	
	private function routePayloadToCommands():Void
	{
		var payload:CommandPayload = new CommandPayload(null, _signal.valueClasses);
		_executor.executeCommands(_mappings.getList(), payload);
	}
}