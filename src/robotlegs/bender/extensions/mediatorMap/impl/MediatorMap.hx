//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl;

import org.swiftsuspenders.InjectorMacro;
import org.swiftsuspenders.utils.DescribedType;

import robotlegs.bender.extensions.matching.ITypeMatcher;
import robotlegs.bender.extensions.matching.TypeMatcher;
import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMapper;
import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorUnmapper;
import robotlegs.bender.extensions.viewManager.api.IViewHandler;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.ILogger;

/**
 * @private
 */

class MediatorMap implements DescribedType implements IMediatorMap implements IViewHandler
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _mappers:Map<String,Dynamic> = new Map<String,Dynamic>();

	private var _logger:ILogger;

	private var _factory:MediatorFactory;

	private var _viewHandler:MediatorViewHandler;

	private var NULL_UNMAPPER = new NullMediatorUnmapper();

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function new(context:IContext)
	{
		_logger = context.getLogger(this);
		_factory = new MediatorFactory(context.injector);
		_viewHandler = new MediatorViewHandler(_factory);
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @inheritDoc
	 */
	public function mapMatcher(matcher:ITypeMatcher):IMediatorMapper
	{
		var descriptor:String = matcher.createTypeFilter().descriptor;
		var mediatorMapper:IMediatorMapper = _mappers.get(descriptor);
		if (mediatorMapper == null) {
			mediatorMapper = createMapper(matcher);
			_mappers.set(descriptor, mediatorMapper);
		}
		return mediatorMapper;
	}

	/**
	 * @inheritDoc
	 */
	public function map(type:Class<Dynamic>):IMediatorMapper
	{
		return mapMatcher(new TypeMatcher().allOf([type]));
	}

	/**
	 * @inheritDoc
	 */
	public function unmapMatcher(matcher:ITypeMatcher):IMediatorUnmapper
	{
		var descriptor:String = matcher.createTypeFilter().descriptor;
		var val = _mappers.get(descriptor);
		if (val != null) return val;
		else return NULL_UNMAPPER;
		//return _mappers[matcher.createTypeFilter().descriptor] || NULL_UNMAPPER;
	}

	/**
	 * @inheritDoc
	 */
	public function unmap(type:Class<Dynamic>):IMediatorUnmapper
	{
		return unmapMatcher(new TypeMatcher().allOf([type]));
	}

	/**
	 * @inheritDoc
	 */
	public function handleView(view:Dynamic, type:Class<Dynamic>):Void
	{
		_viewHandler.handleView(view, type);
	}

	/**
	 * @inheritDoc
	 */
	public function mediate(item:Dynamic):Void
	{
		_viewHandler.handleItem(item, Type.getClass(item));
	}

	/**
	 * @inheritDoc
	 */
	public function unmediate(item:Dynamic):Void
	{
		_factory.removeMediators(item);
	}

	/**
	 * @inheritDoc
	 */
	public function unmediateAll():Void
	{
		_factory.removeAllMediators();
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	private function createMapper(matcher:ITypeMatcher):IMediatorMapper
	{
		return new MediatorMapper(matcher.createTypeFilter(), _viewHandler, _logger);
	}
}