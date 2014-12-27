//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.enhancedLogging.impl;

/**
 * @private
 */
class LogMessageParser
{

	public function new()
	{
		
	}
	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * Parse a parametrized message
	 * @param message The message string
	 * @param params The parameter values
	 * @return The parsed message
	 */
	public function parseMessage(message:String, params:Array<Dynamic>):String
	{
		if (params != null)
		{
			var numParams:Int = params.length;
			for (i in 0...numParams)
			{
				message = message.split("{" + i + "}").join(params[i]);
			}
		}
		return message;
	}
}