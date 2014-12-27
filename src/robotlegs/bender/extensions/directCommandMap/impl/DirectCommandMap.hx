//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.directCommandMap.impl;

import robotlegs.bender.extensions.commandCenter.api.ICommandExecutor;
import robotlegs.bender.extensions.commandCenter.impl.CommandExecutor;
import robotlegs.bender.extensions.commandCenter.impl.CommandMappingList;
import robotlegs.bender.extensions.commandCenter.api.CommandPayload;
import robotlegs.bender.extensions.commandCenter.impl.NullCommandTrigger;
import robotlegs.bender.extensions.directCommandMap.api.IDirectCommandMap;
import robotlegs.bender.extensions.directCommandMap.dsl.IDirectCommandConfigurator;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IInjector;

/**
 * Maps commands for direct (manual) execution
 */
class DirectCommandMap implements IDirectCommandMap
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _mappingProcessors:Array<Dynamic> = [];

	private var _context:IContext;

	private var _executor:ICommandExecutor;

	private var _mappings:CommandMappingList;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * Creates a Direct Command Map
	 * @param context The context that owns this map
	 */
	public function new(context:IContext)
	{
		_context = context;
		var sandboxedInjector:IInjector = context.injector.createChild();
		// allow access to this specific instance in the commands
		sandboxedInjector.map(IDirectCommandMap).toValue(this);
		_mappings = new CommandMappingList(
			new NullCommandTrigger(), _mappingProcessors, context.getLogger(this));
		_executor = new CommandExecutor(sandboxedInjector, _mappings.removeMapping);
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @inheritDoc
	 */
	public function map(commandClass:Class<Dynamic>):IDirectCommandConfigurator
	{
		return new DirectCommandMapper(_executor, _mappings, commandClass);
	}

	/**
	 * @inheritDoc
	 */
	public function detain(command:Dynamic):Void
	{
		_context.detain(command);
	}

	/**
	 * @inheritDoc
	 */
	public function release(command:Dynamic):Void
	{
		_context.release(command);
	}

	/**
	 * @inheritDoc
	 */
	public function execute(payload:CommandPayload = null):Void
	{
		_executor.executeCommands(_mappings.getList(), payload);
	}

	/**
	 * @inheritDoc
	 */
	public function addMappingProcessor(handler:Void->Void):IDirectCommandMap
	{
		if (_mappingProcessors.indexOf(handler) == -1)
			_mappingProcessors.push(handler);
		return this;
	}
}