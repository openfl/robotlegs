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
	public var matcher(get, null):ITypeFilter;
	function get_matcher():ITypeFilter { 
	   return matcher;
	}
	
	public var mediatorClass(get, null):Class<Dynamic>;
	function get_mediatorClass():Class<Dynamic>
	{
		return mediatorClass;
	}

	public var guards(get, null):Array<Dynamic> = new Array<Dynamic>();
	function get_guards():Array<Dynamic>
	{
		return guards;
	}

	public var hooks(get, null):Array<Dynamic> = new Array<Dynamic>();
	function get_hooks():Array<Dynamic>
	{
		return hooks;
	}

	public var autoRemoveEnabled(get, null):Bool;
	function get_autoRemoveEnabled():Bool
	{
		return autoRemoveEnabled;
	}

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function new(matcher:ITypeFilter, mediatorClass:Class<Dynamic>)
	{
		this.matcher = matcher;
		this.mediatorClass = mediatorClass;
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
			this.guards.push(guards[i]);
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
			this.hooks.push(hooks[i]);
		}
		//_hooks = _hooks.concat.apply(null, hooks);
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function autoRemove(value:Bool = true):IMediatorConfigurator
	{
		this.autoRemoveEnabled = value;
		return this;
	}
}