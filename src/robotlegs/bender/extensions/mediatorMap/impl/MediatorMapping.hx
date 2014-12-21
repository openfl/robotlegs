//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl;

import robotlegs.bender.extensions.matching.ITypeFilter;
import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;
import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorConfigurator;

/**
 * @private
 */
class MediatorMapping implements IMediatorMapping, IMediatorConfigurator
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	private var _matcher:ITypeFilter;

	/**
	 * @inheritDoc
	 */
	public function get matcher():ITypeFilter
	{
		return _matcher;
	}

	private var _mediatorClass:Class;

	/**
	 * @inheritDoc
	 */
	public function get mediatorClass():Class
	{
		return _mediatorClass;
	}

	private var _guards:Array<Dynamic> = [];

	/**
	 * @inheritDoc
	 */
	public function get guards():Array
	{
		return _guards;
	}

	private var _hooks:Array<Dynamic> = [];

	/**
	 * @inheritDoc
	 */
	public function get hooks():Array
	{
		return _hooks;
	}

	private var _autoRemoveEnabled:Bool = true;

	/**
	 * @inheritDoc
	 */
	public function get autoRemoveEnabled():Bool
	{
		return _autoRemoveEnabled;
	}

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function new(matcher:ITypeFilter, mediatorClass:Class)
	{
		_matcher = matcher;
		_mediatorClass = mediatorClass;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @inheritDoc
	 */
	public function withGuards(... guards):IMediatorConfigurator
	{
		_guards = _guards.concat.apply(null, guards);
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function withHooks(... hooks):IMediatorConfigurator
	{
		_hooks = _hooks.concat.apply(null, hooks);
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function autoRemove(value:Bool = true):IMediatorConfigurator
	{
		_autoRemoveEnabled = value;
		return this;
	}
}