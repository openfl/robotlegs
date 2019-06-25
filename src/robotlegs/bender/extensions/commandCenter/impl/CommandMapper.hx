//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------
package robotlegs.bender.extensions.commandCenter.impl;

import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
import robotlegs.bender.extensions.commandCenter.api.ICommandMappingList;
import robotlegs.bender.extensions.commandCenter.dsl.ICommandConfigurator;
import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;
import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;
import robotlegs.bender.framework.impl.Guard;
import robotlegs.bender.framework.impl.Hook;

/**
 * @private
 */
@:keepSub
class CommandMapper implements ICommandMapper implements ICommandUnmapper implements ICommandConfigurator {
	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/
	private var _mappings:ICommandMappingList;

	private var _mapping:ICommandMapping;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/
	/**
	 * Creates a Command Mapper
	 * @param mappings The command mapping list to add mappings to
	 */
	public function new(mappings:ICommandMappingList) {
		_mappings = mappings;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/
	/**
	 * @inheritDoc
	 */
	public function toCommand(commandClass:Class<Dynamic>):ICommandConfigurator {
		_mapping = new CommandMapping(commandClass);
		_mappings.addMapping(_mapping);
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function fromCommand(commandClass:Class<Dynamic>):Void {
		_mappings.removeMappingFor(commandClass);
	}

	/**
	 * @inheritDoc
	 */
	public function fromAll():Void {
		_mappings.removeAllMappings();
	}

	/**
	 * @inheritDoc
	 */
	public function once(value:Bool = true):ICommandConfigurator {
		_mapping.setFireOnce(value);
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function withGuards(?guards:Array<Guard>, ?guard:Guard):ICommandConfigurator {
		_mapping.addGuards(guards, guard);
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function withHooks(?hooks:Array<Hook>, ?hook:Hook):ICommandConfigurator {
		_mapping.addHooks(hooks, hook);
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function withExecuteMethod(name:String):ICommandConfigurator {
		_mapping.setExecuteMethod(name);
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function withPayloadInjection(value:Bool = true):ICommandConfigurator {
		_mapping.setPayloadInjectionEnabled(value);
		return this;
	}
}
