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
class MediatorMapping implements IMediatorMapping implements IMediatorConfigurator
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	private var _matcher:ITypeFilter;
	public var matcher(get, null):ITypeFilter;
	/**
	 * @inheritDoc
	 */
	public function get_matcher():ITypeFilter
	{
		return _matcher;
	}

	private var _mediatorClass:Class<Dynamic>;
	public var mediatorClass(get, null):Class<Dynamic>;
	/**
	 * @inheritDoc
	 */
	public function get_mediatorClass():Class<Dynamic>
	{
		return _mediatorClass;
	}

	private var _guards:Array<Dynamic> = [];
	public var guards(get, null):Array<Dynamic>;
	/**
	 * @inheritDoc
	 */
	public function get_guards():Array<Dynamic>
	{
		return _guards;
	}

	private var _hooks:Array<Dynamic> = [];
	public var hooks(get, null):Array<Dynamic>;
	/**
	 * @inheritDoc
	 */
	public function get_hooks():Array<Dynamic>
	{
		return _hooks;
	}

	private var _autoRemoveEnabled:Bool = true;
	public var autoRemoveEnabled(get, null):Bool;
	/**
	 * @inheritDoc
	 */
	public function get_autoRemoveEnabled():Bool
	{
		return _autoRemoveEnabled;
	}

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function new(matcher:ITypeFilter, mediatorClass:Class<Dynamic>)
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
	public function withGuards(guards:Array<Dynamic>):IMediatorConfigurator
	{
		for (i in 0...guards.length) 
		{
			_guards.push(guards[i]);
		}
		//_guards = _guards.concat.apply(null, guards);
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function withHooks(hooks:Array<Dynamic>):IMediatorConfigurator
	{
		for (i in 0...hooks.length) 
		{
			_hooks.push(hooks[i]);
		}
		//_hooks = _hooks.concat.apply(null, hooks);
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