//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewProcessorMap.impl;

import openfl.display.DisplayObject;
import openfl.utils.Dictionary;
import robotlegs.bender.extensions.matching.ITypeMatcher;
import robotlegs.bender.extensions.matching.TypeMatcher;
import robotlegs.bender.extensions.viewManager.api.IViewHandler;
import robotlegs.bender.extensions.viewProcessorMap.api.IViewProcessorMap;
import robotlegs.bender.extensions.viewProcessorMap.dsl.IViewProcessorMapper;
import robotlegs.bender.extensions.viewProcessorMap.dsl.IViewProcessorUnmapper;

/**
 * View Processor Map implementation
 * @private
 */
class ViewProcessorMap implements IViewProcessorMap, IViewHandler
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _mappers:Dictionary = new Dictionary();

	private var _handler:IViewProcessorViewHandler;

	private var NULL_UNMAPPER:IViewProcessorUnmapper = new NullViewProcessorUnmapper();

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function new(factory:IViewProcessorFactory, handler:IViewProcessorViewHandler = null)
	{
		_handler = handler || new ViewProcessorViewHandler(factory);
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @inheritDoc
	 */
	public function mapMatcher(matcher:ITypeMatcher):IViewProcessorMapper
	{
		return _mappers[matcher.createTypeFilter().descriptor] ||= createMapper(matcher);
	}

	/**
	 * @inheritDoc
	 */
	public function map(type:Class):IViewProcessorMapper
	{
		var matcher:ITypeMatcher = new TypeMatcher().allOf(type);
		return mapMatcher(matcher);
	}

	/**
	 * @inheritDoc
	 */
	public function unmapMatcher(matcher:ITypeMatcher):IViewProcessorUnmapper
	{
		return _mappers[matcher.createTypeFilter().descriptor] || NULL_UNMAPPER;
	}

	/**
	 * @inheritDoc
	 */
	public function unmap(type:Class):IViewProcessorUnmapper
	{
		var matcher:ITypeMatcher = new TypeMatcher().allOf(type);
		return unmapMatcher(matcher);
	}

	/**
	 * @inheritDoc
	 */
	public function process(item:Dynamic):Void
	{
		var type:Class = item.constructor as Class;
		_handler.processItem(item, type);
	}

	/**
	 * @inheritDoc
	 */
	public function unprocess(item:Dynamic):Void
	{
		var type:Class = item.constructor as Class;
		_handler.unprocessItem(item, type);
	}

	/**
	 * @inheritDoc
	 */
	public function handleView(view:DisplayObject, type:Class):Void
	{
		_handler.processItem(view, type);
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	private function createMapper(matcher:ITypeMatcher):IViewProcessorMapper
	{
		return new ViewProcessorMapper(matcher.createTypeFilter(), _handler);
	}
}