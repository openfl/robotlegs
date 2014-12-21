//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewProcessorMap.impl;

import openfl.utils.Dictionary;
import robotlegs.bender.extensions.matching.ITypeFilter;
import robotlegs.bender.extensions.viewProcessorMap.dsl.IViewProcessorMapper;
import robotlegs.bender.extensions.viewProcessorMap.dsl.IViewProcessorMapping;
import robotlegs.bender.extensions.viewProcessorMap.dsl.IViewProcessorMappingConfig;
import robotlegs.bender.extensions.viewProcessorMap.dsl.IViewProcessorUnmapper;
import robotlegs.bender.framework.api.ILogger;

/**
 * @private
 */
class ViewProcessorMapper implements IViewProcessorMapper, IViewProcessorUnmapper
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _mappings:Dictionary = new Dictionary();

	private var _handler:IViewProcessorViewHandler;

	private var _matcher:ITypeFilter;

	private var _logger:ILogger;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function new(matcher:ITypeFilter, handler:IViewProcessorViewHandler, logger:ILogger = null)
	{
		_handler = handler;
		_matcher = matcher;
		_logger = logger;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @inheritDoc
	 */
	public function toProcess(processClassOrInstance:Dynamic):IViewProcessorMappingConfig
	{
		var mapping:IViewProcessorMapping = _mappings[processClassOrInstance];
		return mapping
			? overwriteMapping(mapping, processClassOrInstance)
			: createMapping(processClassOrInstance);
	}

	/**
	 * @inheritDoc
	 */
	public function toInjection():IViewProcessorMappingConfig
	{
		return toProcess(ViewInjectionProcessor);
	}

	/**
	 * @inheritDoc
	 */
	public function toNoProcess():IViewProcessorMappingConfig
	{
		return toProcess(NullProcessor);
	}

	/**
	 * @inheritDoc
	 */
	public function fromProcess(processorClassOrInstance:Dynamic):Void
	{
		var mapping:IViewProcessorMapping = _mappings[processorClassOrInstance];
		mapping && deleteMapping(mapping);
	}

	/**
	 * @inheritDoc
	 */
	public function fromAll():Void
	{
		for (var processor:Dynamic in _mappings)
		{
			fromProcess(processor);
		}
	}

	/**
	 * @inheritDoc
	 */
	public function fromNoProcess():Void
	{
		fromProcess(NullProcessor);
	}

	/**
	 * @inheritDoc
	 */
	public function fromInjection():Void
	{
		fromProcess(ViewInjectionProcessor);
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	private function createMapping(processor:Dynamic):ViewProcessorMapping
	{
		var mapping:ViewProcessorMapping = new ViewProcessorMapping(_matcher, processor);
		_handler.addMapping(mapping);
		_mappings[processor] = mapping;
		_logger && _logger.debug('{0} mapped to {1}', [_matcher, mapping]);
		return mapping;
	}

	private function deleteMapping(mapping:IViewProcessorMapping):Void
	{
		_handler.removeMapping(mapping);
		delete _mappings[mapping.processor];
		_logger && _logger.debug('{0} unmapped from {1}', [_matcher, mapping]);
	}

	private function overwriteMapping(mapping:IViewProcessorMapping,
		processClassOrInstance:Dynamic):IViewProcessorMappingConfig
	{
		_logger && _logger.warn('{0} is already mapped to {1}.\n' +
			'If you have overridden this mapping intentionally you can use "unmap()" ' +
			'prior to your replacement mapping in order to avoid seeing this message.\n',
			[_matcher, mapping]);
		deleteMapping(mapping);
		return createMapping(processClassOrInstance);
	}
}