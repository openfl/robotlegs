//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.api;

/**
 * Robotlegs log level
 */
@:keepSub
class LogLevel
{

	/*============================================================================*/
	/* Public Static Properties                                                   */
	/*============================================================================*/

	public static var FATAL:UInt = 2;

	public static var ERROR:UInt = 4;

	public static var WARN:UInt = 8;

	public static var INFO:UInt = 16;

	public static var DEBUG:UInt = 32;

	public static var NAME:Array<Dynamic> = [
		0, 0, 'FATAL', // 2
		0, 'ERROR', // 4
		0, 0, 0, 'WARN', // 8
		0, 0, 0, 0, 0, 0, 0, 'INFO', // 16
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'DEBUG']; // 32
}
