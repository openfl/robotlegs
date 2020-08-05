//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------
package robotlegs.bender.framework.impl;

import org.swiftsuspenders.utils.UID as BaseUID;

/**
 * Utility for generating unique object IDs
 */
@:keepSub
class UID {
	/*============================================================================*/
	/* Private Static Properties                                                  */
	/*============================================================================*/
	private static var _i:UInt;

	/*============================================================================*/
	/* Public Static Functions                                                    */
	/*============================================================================*/
	/**
	 * Generates a UID for a given source object or class
	 * @param source The source object or class
	 * @return Generated UID
	 */
	public static function create(source:Dynamic = null):String {
		return BaseUID.create(source);
	}

	public static function classID(source:Dynamic = null):String {
		return BaseUID.classID(source);
	}
}
