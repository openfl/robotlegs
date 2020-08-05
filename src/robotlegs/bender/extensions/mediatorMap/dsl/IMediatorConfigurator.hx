//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------
package robotlegs.bender.extensions.mediatorMap.dsl;

import robotlegs.bender.framework.impl.Guard;
import robotlegs.bender.framework.impl.Hook;

/**
 * Configures a mediator mapping
 */
interface IMediatorConfigurator {
	/**
	 * Guards to check before allowing a mediator to be created
	 * @param guards Guards
	 * @return Self
	 */
	function withGuards(?guards:Array<Guard>, ?guard:Guard):IMediatorConfigurator;

	/**
	 * Hooks to run before a mediator is created
	 * @param hooks Hooks
	 * @return Self
	 */
	function withHooks(?hooks:Array<Hook>, ?hook:Hook):IMediatorConfigurator;

	/**
	 * Should the mediator be removed when the mediated item looses scope?
	 *
	 * <p>Usually this would be when the mediated item is a Display Dynamic
	 * and it leaves the stage.</p>
	 *
	 * @param value Bool
	 * @return Self
	 */
	function autoRemove(value:Bool = true):IMediatorConfigurator;
}
