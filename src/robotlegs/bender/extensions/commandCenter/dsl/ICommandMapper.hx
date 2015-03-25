//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.dsl;

/**
 * @private
 */
interface ICommandMapper
{
	/**
	 * Creates a command mapping
	 * @param commandClass The Command Class<Dynamic> to map
	 * @return Mapping configurator
	 */
	function toCommand(commandClass:Class<Dynamic>):ICommandConfigurator;
}