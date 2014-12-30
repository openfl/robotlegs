//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl;

/**
 * Utility for generating unique object IDs
 */
class UID
{

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
	public static function create(source:Dynamic = null):String
	{
		var className = UID.classID(source);
		return (source ? source + '-':'')
			+ StringTools.hex(_i++, 16)
			+ '-'
			+ StringTools.hex(Math.floor(Math.random() * 255), 16);
	}
	
	public static function classID(source:Dynamic = null):String
	{
		var className = "";
		if (Type.getClass(source) != null) {
			className = Type.getClassName(Type.getClass(source)); 
		}
		return className;
	}
}