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
import robotlegs.bender.bundles.mvcs.Mediator;
import robotlegs.bender.framework.impl.Guard;
import robotlegs.bender.framework.impl.Hook;

/**
 * @private
 */
@:keepSub
class MediatorMapping implements IMediatorMapping implements IMediatorConfigurator {
	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/
	public var matcher(get, null):ITypeFilter;

	function get_matcher():ITypeFilter {
		return matcher;
	}

	public var mediatorClass(get, null):Class<Mediator>;

	function get_mediatorClass():Class<Mediator> {
		return mediatorClass;
	}

	public var guards(get, null):Array<Guard> = new Array<Guard>();

	function get_guards():Array<Guard> {
		return guards;
	}

	public var hooks(get, null):Array<Hook> = new Array<Hook>();

	function get_hooks():Array<Hook> {
		return hooks;
	}

	public var autoRemoveEnabled(get, null):Bool = true;

	function get_autoRemoveEnabled():Bool {
		return autoRemoveEnabled;
	}

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/
	/**
	 * @private
	 */
	public function new(matcher:ITypeFilter, mediatorClass:Class<Mediator>) {
		this.matcher = matcher;
		this.mediatorClass = mediatorClass;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/
	/**
	 * @inheritDoc
	 */
	public function withGuards(?guards:Array<Guard>, ?guard:Guard):IMediatorConfigurator {
		if (guards != null) {
			for (i in 0...guards.length) {
				this.guards.push(guards[i]);
			}
		}
		if (guard != null) {
			this.guards.push(guard);
		}
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function withHooks(?hooks:Array<Hook>, ?hook:Hook):IMediatorConfigurator {
		if (hooks != null) {
			for (i in 0...hooks.length) {
				this.hooks.push(hooks[i]);
			}
		}
		if (hook != null) {
			this.hooks.push(hook);
		}
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function autoRemove(value:Bool = true):IMediatorConfigurator {
		this.autoRemoveEnabled = value;
		return this;
	}
}
