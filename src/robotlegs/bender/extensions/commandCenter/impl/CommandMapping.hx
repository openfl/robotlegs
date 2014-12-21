//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.impl;

import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;

/**
 * @private
 */
class CommandMapping implements ICommandMapping
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	private var _commandClass:Class;

	/**
	 * @inheritDoc
	 */
	public function get commandClass():Class
	{
		return _commandClass;
	}

	private var _executeMethod:String = "execute";

	/**
	 * @inheritDoc
	 */
	public function get executeMethod():String
	{
		return _executeMethod;
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

	private var _fireOnce:Bool;

	/**
	 * @inheritDoc
	 */
	public function get fireOnce():Bool
	{
		return _fireOnce;
	}

	private var _payloadInjectionEnabled:Bool = true;

	/**
	 * @inheritDoc
	 */
	public function get payloadInjectionEnabled():Bool
	{
		return _payloadInjectionEnabled;
	}

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * Creates a Command Mapping
	 * @param commandClass The concrete Command class
	 */
	public function new(commandClass:Class)
	{
		_commandClass = commandClass;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @inheritDoc
	 */
	public function setExecuteMethod(name:String):ICommandMapping
	{
		_executeMethod = name;
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function addGuards(... guards):ICommandMapping
	{
		_guards = _guards.concat.apply(null, guards);
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function addHooks(... hooks):ICommandMapping
	{
		_hooks = _hooks.concat.apply(null, hooks);
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function setFireOnce(value:Bool):ICommandMapping
	{
		_fireOnce = value;
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function setPayloadInjectionEnabled(value:Bool):ICommandMapping
	{
		_payloadInjectionEnabled = value;
		return this;
	}

	public function toString():String
	{
		return 'Command ' + _commandClass;
	}
}