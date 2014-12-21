//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.impl;

import openfl.utils.Dictionary;
import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
import robotlegs.bender.extensions.commandCenter.api.ICommandMappingList;
import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
import robotlegs.bender.framework.api.ILogger;

/**
 * @private
 */
class CommandMappingList implements ICommandMappingList
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _mappingsByCommand:Dictionary = new Dictionary();

	private var _mappings:Array<ICommandMapping> = new Array<ICommandMapping>;

	private var _trigger:ICommandTrigger;

	private var _processors:Array<Dynamic>;

	private var _logger:ILogger;

	private var _compareFunction:Function;

	private var _sorted:Bool;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * Create a command mapping list
	 * @param trigger The trigger that owns this list
	 * @param processors A reference to the mapping processors for this command map
	 * @param logger Optional logger
	 */
	public function new(trigger:ICommandTrigger, processors:Array<Dynamic>, logger:ILogger = null)
	{
		_trigger = trigger;
		_processors = processors;
		_logger = logger;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @inheritDoc
	 */
	public function getList():Array<ICommandMapping>
	{
		_sorted || sortMappings();
		return _mappings.concat();
	}

	/**
	 * @inheritDoc
	 */
	public function withSortFunction(sorter:Function):ICommandMappingList
	{
		_sorted = false;
		_compareFunction = sorter;
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function addMapping(mapping:ICommandMapping):Void
	{
		_sorted = false;
		applyProcessors(mapping);
		var oldMapping:ICommandMapping = _mappingsByCommand[mapping.commandClass];
		if (oldMapping)
		{
			overwriteMapping(oldMapping, mapping);
		}
		else
		{
			storeMapping(mapping);
			_mappings.length == 1 && _trigger.activate();
		}
	}

	/**
	 * @inheritDoc
	 */
	public function removeMapping(mapping:ICommandMapping):Void
	{
		if (_mappingsByCommand[mapping.commandClass])
		{
			deleteMapping(mapping);
			_mappings.length == 0 && _trigger.deactivate();
		}
	}

	/**
	 * @inheritDoc
	 */
	public function removeMappingFor(commandClass:Class):Void
	{
		var mapping:ICommandMapping = _mappingsByCommand[commandClass];
		mapping && removeMapping(mapping);
	}

	/**
	 * @inheritDoc
	 */
	public function removeAllMappings():Void
	{
		if (_mappings.length > 0)
		{
			var list:Array<ICommandMapping> = _mappings.concat();
			var length:Int = list.length;
			while (length--)
			{
				deleteMapping(list[length]);
			}
			_trigger.deactivate();
		}
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	private function storeMapping(mapping:ICommandMapping):Void
	{
		_mappingsByCommand[mapping.commandClass] = mapping;
		_mappings.push(mapping);
		_logger && _logger.debug('{0} mapped to {1}', [_trigger, mapping]);
	}

	private function deleteMapping(mapping:ICommandMapping):Void
	{
		delete _mappingsByCommand[mapping.commandClass];
		_mappings.splice(_mappings.indexOf(mapping), 1);
		_logger && _logger.debug('{0} unmapped from {1}', [_trigger, mapping]);
	}

	private function overwriteMapping(oldMapping:ICommandMapping, newMapping:ICommandMapping):Void
	{
		_logger && _logger.warn('{0} already mapped to {1}\n' +
			'If you have overridden this mapping intentionally you can use "unmap()" ' +
			'prior to your replacement mapping in order to avoid seeing this message.\n',
			[_trigger, oldMapping]);
		deleteMapping(oldMapping);
		storeMapping(newMapping);
	}

	private function sortMappings():Void
	{
		if (_compareFunction != null)
		{
			_mappings = _mappings.sort(_compareFunction);
		}
		_sorted = true;
	}

	private function applyProcessors(mapping:ICommandMapping):Void
	{
		for each (var processor:Function in _processors)
		{
			processor(mapping);
		}
	}
}