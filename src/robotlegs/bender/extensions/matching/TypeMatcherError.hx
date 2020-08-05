//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------
package robotlegs.bender.extensions.matching;

import robotlegs.errors.Error;

/**
 * Type Matcher Error
 */
@:keepSub
class TypeMatcherError extends Error {
	/*============================================================================*/
	/* Public Static Properties                                                   */
	/*============================================================================*/
	public static var EMPTY_MATCHER:String = "An empty matcher will create a filter which matches nothing. You should specify at least one condition for the filter.";

	public static var SEALED_MATCHER:String = "This matcher has been sealed and can no longer be configured.";

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/
	/**
	 * Creates a Type Matcher Error
	 * @param message The error message
	 */
	public function new(message:String) {
		super(message);
	}
}
