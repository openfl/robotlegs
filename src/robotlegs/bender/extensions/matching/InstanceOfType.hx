//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------
package robotlegs.bender.extensions.matching;

import robotlegs.bender.framework.api.IMatcher;

@:keepSub
class InstanceOfType {
	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/
	/**
	 * Creates a matcher that matches objects of the given type
	 * @param type The type to match
	 * @return A matcher
	 */
	public static function call(type:Class<Dynamic>):IMatcher {
		return new InstanceOfMatcher(type);
	}
}

/**
 * @private
 */
@:keepSub
class InstanceOfMatcher implements IMatcher {
	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/
	private var _type:Class<Dynamic>;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/
	/**
	 * @private
	 */
	public function new(type:Class<Dynamic>) {
		_type = type;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/
	/**
	 * @inheritDoc
	 */
	public function matches(item:Dynamic):Bool {
		return Std.is(item, _type);
	}
}
