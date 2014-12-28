//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.impl;


import org.swiftsuspenders.utils.UID;
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

	private var _mappingsByCommand = new Map<String,Dynamic>();

	private var _mappings = new Array<ICommandMapping>();

	private var _trigger:ICommandTrigger;

	private var _processors:Array<Dynamic>;

	private var _logger:ILogger;

	private var _compareFunction:Dynamic;

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
		if (!_sorted) sortMappings();
		return _mappings.concat([]);
	}

	/**
	 * @inheritDoc
	 */
	public function withSortFunction(sorter:Dynamic):ICommandMappingList
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
		var oldMapping:ICommandMapping = _mappingsByCommand[UID.instanceID(mapping.commandClass)];
		if (oldMapping != null)
		{
			overwriteMapping(oldMapping, mapping);
		}
		else
		{
			storeMapping(mapping);
			if (_mappings.length == 1) _trigger.activate();
		}
	}

	/**
	 * @inheritDoc
	 */
	public function removeMapping(mapping:ICommandMapping):Void
	{
		if (_mappingsByCommand[UID.clearInstanceID(mapping.commandClass)])
		{
			deleteMapping(mapping);
			if (_mappings.length == 0) _trigger.deactivate();
		}
	}

	/**
	 * @inheritDoc
	 */
	public function removeMappingFor(commandClass:Class<Dynamic>):Void
	{
		var mapping:ICommandMapping = _mappingsByCommand[UID.instanceID(commandClass)];
		if (mapping != null) removeMapping(mapping);
	}

	/**
	 * @inheritDoc
	 */
	public function removeAllMappings():Void
	{
		if (_mappings.length > 0)
		{
			var list:Array<ICommandMapping> = _mappings.concat([]);
			var length:Int = list.length;
			while (length-- > 0)
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
		_mappingsByCommand[UID.instanceID(mapping.commandClass)] = mapping;
		_mappings.push(mapping);
		if (_logger != null) _logger.debug('{0} mapped to {1}', [_trigger, mapping]);
	}

	private function deleteMapping(mapping:ICommandMapping):Void
	{
		_mappingsByCommand.remove(UID.clearInstanceID(mapping.commandClass));
		_mappings.splice(_mappings.indexOf(mapping), 1);
		if (_logger != null) _logger.debug('{0} unmapped from {1}', [_trigger, mapping]);
	}

	private function overwriteMapping(oldMapping:ICommandMapping, newMapping:ICommandMapping):Void
	{
		if (_logger != null) {
			_logger.warn('{0} already mapped to {1}\n' + 'If you have overridden this mapping intentionally you can use "unmap()" ' + 'prior to your replacement mapping in order to avoid seeing this message.\n', [_trigger, oldMapping]);
		}
		deleteMapping(oldMapping);
		storeMapping(newMapping);
	}

	private function sortMappings():Void
	{
		// FIX
		/*if (_compareFunction != null)
		{
			_mappings = _mappings.sort(_compareFunction);
		}*/
		_sorted = true;
	}

	private function applyProcessors(mapping:ICommandMapping):Void
	{
		for (processor in _processors)
		{
			processor(mapping);
		}
	}
}