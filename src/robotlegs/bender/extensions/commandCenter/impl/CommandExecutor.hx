//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.impl;

import robotlegs.bender.extensions.commandCenter.api.ICommandExecutor;
import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
import robotlegs.bender.framework.api.IInjector;
import robotlegs.bender.framework.impl.ApplyHooks;
import robotlegs.bender.framework.impl.GuardsApprove;
import robotlegs.bender.extensions.commandCenter.api.CommandPayload;

/**
 * @private
 */
class CommandExecutor implements ICommandExecutor
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _injector:IInjector;

	private var _removeMapping:Function;

	private var _handleResult:Function;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * Creates a Command Executor
	 * @param injector The Injector to use. A child injector will be created from it.
	 * @param removeMapping Remove mapping handler (optional)
	 * @param handleResult Result handler (optional)
	 */
	public function new(injector:IInjector, removeMapping:Function = null, handleResult:Function = null)
	{
		_injector = injector.createChild();
		_removeMapping = removeMapping;
		_handleResult = handleResult;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @inheritDoc
	 */
	public function executeCommands(mappings:Array<ICommandMapping>, payload:CommandPayload = null):Void
	{
		var length:Int = mappings.length;
		for (var i:Int = 0; i < length; i++)
		{
			executeCommand(mappings[i], payload);
		}
	}

	/**
	 * @inheritDoc
	 */
	public function executeCommand(mapping:ICommandMapping, payload:CommandPayload = null):Void
	{
		var hasPayload:Bool = payload && payload.hasPayload();
		var injectionEnabled:Bool = hasPayload && mapping.payloadInjectionEnabled;
		var command:Dynamic = null;

		injectionEnabled && mapPayload(payload);

		if (mapping.guards.length == 0 || GuardsApprove.call(mapping.guards, _injector))
		{
			var commandClass:Class = mapping.commandClass;
			mapping.fireOnce && _removeMapping && _removeMapping(mapping);
			command = _injector.getOrCreateNewInstance(commandClass);
			if (mapping.hooks.length > 0)
			{
				_injector.map(commandClass).toValue(command);
				ApplyHooks(mapping.hooks, _injector);
				_injector.unmap(commandClass);
			}
		}

		injectionEnabled && unmapPayload(payload);

		if (command && mapping.executeMethod)
		{
			var executeMethod:Function = command[mapping.executeMethod];
			var result:Dynamic = (hasPayload && executeMethod.length > 0)
				? executeMethod.apply(null, payload.values)
				: executeMethod();
			_handleResult && _handleResult(result, command, mapping);
		}
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	private function mapPayload(payload:CommandPayload):Void
	{
		var i:UInt = payload.length;
		while (i--)
		{
			_injector.map(payload.classes[i]).toValue(payload.values[i]);
		}
	}

	private function unmapPayload(payload:CommandPayload):Void
	{
		var i:UInt = payload.length;
		while (i--)
		{
			_injector.unmap(payload.classes[i]);
		}
	}
}
