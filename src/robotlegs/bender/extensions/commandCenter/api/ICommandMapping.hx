//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.api;

/**
 * @private
 */
interface ICommandMapping
{
	/**
	 * The concrete Command Class<Dynamic> for this mapping
	 */
	public var commandClass(get, null):Class<Dynamic>;
	function get_commandClass():Class<Dynamic>;
	
	/**
	 * The "execute" method to invoke on the Command instance
	 */
	public var executeMethod(get, null):String;
	function get_executeMethod():String;

	/**
	 * A list of Guards to query before execution
	 */
	public var guards(get, null):Array<Dynamic>;
	function get_guards():Array<Dynamic>;

	/**
	 * A list of Hooks to run during execution
	 */
	public var hooks(get, null):Array<Dynamic>;
	function get_hooks():Array<Dynamic>;

	/**
	 * Unmaps a Command after a successful execution
	 */
	public var fireOnce(get, null):Bool;
	function get_fireOnce():Bool;

	/**
	 * Supply the payload values via instance injection
	 */
	public var payloadInjectionEnabled(get, null):Bool;
	function get_payloadInjectionEnabled():Bool;

	/**
	 * The "execute" method to invoke on the Command instance
	 */
	function setExecuteMethod(name:String):ICommandMapping;

	/**
	 * A list of Guards to query before execution
	 */
	function addGuards(guards:Array<Dynamic>):ICommandMapping;

	/**
	 * A list of Hooks to run during execution
	 */
	function addHooks(hooks:Array<Dynamic>):ICommandMapping;

	/**
	 * Unmaps a Command after a successful execution
	 */
	function setFireOnce(value:Bool):ICommandMapping;

	/**
	 * Supply the payload values via instance injection
	 */
	function setPayloadInjectionEnabled(value:Bool):ICommandMapping;
}