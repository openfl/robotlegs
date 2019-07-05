//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------
package robotlegs.bender.extensions.mediatorMap.api;

import robotlegs.bender.extensions.matching.ITypeFilter;
import robotlegs.bender.framework.impl.Guard;
import robotlegs.bender.bundles.mvcs.Mediator;

/**
 * Represents a Mediator mapping
 */
interface IMediatorMapping {
	/**
	 * The matcher for this mapping
	 */
	public var matcher(get, null):ITypeFilter;

	/**
	 * The concrete mediator class
	 */
	public var mediatorClass(get, null):Class<Mediator>;

	/**
	 * A list of guards to check before allowing mediator creation
	 */
	public var guards(get, null):Array<Guard>;

	/**
	 * A list of hooks to run before creating a mediator
	 */
	public var hooks(get, null):Array<Dynamic>;

	/**
	 * Should the mediator be removed when the mediated item looses scope?
	 */
	public var autoRemoveEnabled(get, null):Bool;
}
