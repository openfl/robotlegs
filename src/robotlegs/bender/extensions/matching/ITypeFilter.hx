//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------
package robotlegs.bender.extensions.matching;

import robotlegs.bender.framework.api.IMatcher;

/**
 * A Type Filter describes a Type Matcher
 */
interface ITypeFilter extends IMatcher {
	/**
	 * All types that an item must extend or implement
	 */
	public var allOfTypes(get, null):Array<Class<Dynamic>>;

	/**
	 * Any types that an item must extend or implement
	 */
	public var anyOfTypes(get, null):Array<Class<Dynamic>>;

	/**
	 * Types that an item must not extend or implement
	 */
	public var noneOfTypes(get, null):Array<Class<Dynamic>>;

	/**
	 * Unique description for this filter
	 */
	public var descriptor(get, null):String;
}
