//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.vigilance;
import openfl.errors.Error;

/**
 * Vigilant Error
 */
@:keepSub
//class VigilantError extends Error
class VigilantError
{

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * Creates a Vigilant Error
	 * @param message The error message
	 */
	public function new(message:String)
	{
		//super(message);
		trace(message);
	}
}