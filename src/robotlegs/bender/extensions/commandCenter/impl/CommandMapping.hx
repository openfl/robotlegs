//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------
package robotlegs.bender.extensions.commandCenter.impl;

import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
import robotlegs.bender.framework.impl.Guard;
import robotlegs.bender.framework.impl.Hook;

/**
 * @private
 */
@:keepSub
class CommandMapping implements ICommandMapping {
	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/
	private var _commandClass:Class<Dynamic>;

	public var commandClass(get, null):Class<Dynamic>;

	/**
	 * @inheritDoc
	 */
	public function get_commandClass():Class<Dynamic> {
		return _commandClass;
	}

	private var _executeMethod:String = "execute";

	public var executeMethod(get, null):String;

	/**
	 * @inheritDoc
	 */
	public function get_executeMethod():String {
		return _executeMethod;
	}

	private var _guards:Array<Guard> = [];

	public var guards(get, null):Array<Guard>;

	/**
	 * @inheritDoc
	 */
	public function get_guards():Array<Guard> {
		return _guards;
	}

	private var _hooks:Array<Hook> = [];

	public var hooks(get, null):Array<Hook>;

	/**
	 * @inheritDoc
	 */
	public function get_hooks():Array<Hook> {
		return _hooks;
	}

	private var _fireOnce:Bool = false;

	public var fireOnce(get, null):Bool;

	/**
	 * @inheritDoc
	 */
	public function get_fireOnce():Bool {
		return _fireOnce;
	}

	private var _payloadInjectionEnabled:Bool = true;

	public var payloadInjectionEnabled(get, null):Bool;

	/**
	 * @inheritDoc
	 */
	public function get_payloadInjectionEnabled():Bool {
		return _payloadInjectionEnabled;
	}

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/
	/**
	 * Creates a Command Mapping
	 * @param commandClass The concrete Command class
	 */
	public function new(commandClass:Class<Dynamic>) {
		_commandClass = commandClass;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/
	/**
	 * @inheritDoc
	 */
	public function setExecuteMethod(name:String):ICommandMapping {
		_executeMethod = name;
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function addGuards(?guards:Array<Guard>, ?guard:Guard):ICommandMapping {
		if (guards != null) {
			for (i in 0...guards.length) {
				_guards.push(guards[i]);
			}
		}
		if (guard != null) {
			_guards.push(guard);
		}
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function addHooks(?hooks:Array<Hook>, ?hook:Hook):ICommandMapping {
		if (hooks != null) {
			for (i in 0...hooks.length) {
				_hooks.push(hooks[i]);
			}
		}
		if (hook != null) {
			_hooks.push(hook);
		}
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function setFireOnce(value:Bool):ICommandMapping {
		_fireOnce = value;
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function setPayloadInjectionEnabled(value:Bool):ICommandMapping {
		_payloadInjectionEnabled = value;
		return this;
	}

	public function toString():String {
		return 'Command ' + _commandClass;
	}
}
