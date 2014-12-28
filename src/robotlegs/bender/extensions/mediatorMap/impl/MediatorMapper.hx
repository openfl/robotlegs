//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl;


import org.swiftsuspenders.utils.UID;
import robotlegs.bender.extensions.matching.ITypeFilter;
import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;
import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorConfigurator;
import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMapper;
import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorUnmapper;
import robotlegs.bender.framework.api.ILogger;

/**
 * @private
 */
class MediatorMapper implements IMediatorMapper implements IMediatorUnmapper
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _mappings = new Map<String,Dynamic>();

	private var _typeFilter:ITypeFilter;

	private var _handler:MediatorViewHandler;

	private var _logger:ILogger;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function new(typeFilter:ITypeFilter, handler:MediatorViewHandler, logger:ILogger = null)
	{
		_typeFilter = typeFilter;
		_handler = handler;
		_logger = logger;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @inheritDoc
	 */
	public function toMediator(mediatorClass:Class<Dynamic>):IMediatorConfigurator
	{
		var mapping:IMediatorMapping = _mappings[UID.classID(mediatorClass)];
		return (mapping != null)
			? overwriteMapping(mapping)
			: createMapping(mediatorClass);
	}

	/**
	 * @inheritDoc
	 */
	public function fromMediator(mediatorClass:Class<Dynamic>):Void
	{
		var mapping:IMediatorMapping = _mappings[UID.classID(mediatorClass)];
		if (mapping != null) deleteMapping(mapping);
	}

	/**
	 * @inheritDoc
	 */
	public function fromAll():Void
	{
		for (mapping in _mappings)
		{
			deleteMapping(mapping);
		}
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	private function createMapping(mediatorClass:Class<Dynamic>):MediatorMapping
	{
		var mapping:MediatorMapping = new MediatorMapping(_typeFilter, mediatorClass);
		_handler.addMapping(mapping);
		_mappings[UID.classID(mediatorClass)] = mapping;
		if (_logger != null) _logger.debug('{0} mapped to {1}', [_typeFilter, mapping]);
		return mapping;
	}

	private function deleteMapping(mapping:IMediatorMapping):Void
	{
		_handler.removeMapping(mapping);
		_mappings.remove(UID.classID(mapping.mediatorClass));
		if (_logger != null) _logger.debug('{0} unmapped from {1}', [_typeFilter, mapping]);
	}

	private function overwriteMapping(mapping:IMediatorMapping):IMediatorConfigurator
	{
		if (_logger != null) _logger.warn('{0} already mapped to {1}\n' +
			'If you have overridden this mapping intentionally you can use "unmap()" ' +
			'prior to your replacement mapping in order to avoid seeing this message.\n',
			[_typeFilter, mapping]);
		deleteMapping(mapping);
		return createMapping(mapping.mediatorClass);
	}
}