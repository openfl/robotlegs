//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------
package robotlegs.bender.extensions.directCommandMap.api;

/**
 * Maps commands for direct (manual) execution
 */
interface IDirectCommandMap extends IDirectCommandMapper {
	/**
	 * Pins a command in memory
	 * @param command the command instance to pin
	 */
	function detain(command:Dynamic):Void;

	/**
	 * Unpins a command instance from memory
	 * @param command the command instance to unpin
	 */
	function release(command:Dynamic):Void;

	/**
	 * Adds a handler to process mappings
	 * @param handler Function that accepts a mapping
	 * @return Self
	 */
	function addMappingProcessor(handler:Void->Void):IDirectCommandMap;
}
