//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.impl;


import org.swiftsuspenders.utils.UID;
import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
import robotlegs.bender.extensions.eventCommandMap.impl.EventCommandTrigger;

/**
 * @private
 */
class CommandTriggerMap
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _triggers = new Map<String,Dynamic>();

	private var _keyFactory:String -> Class<Dynamic> -> String;

	private var _triggerFactory:String -> Class<Dynamic> -> EventCommandTrigger;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * Creates a command trigger map
	 * @param keyFactory Factory function to creates keys
	 * @param triggerFactory Factory function to create triggers
	 */
	public function new(keyFactory:String -> Class<Dynamic> -> String, triggerFactory:String -> Class<Dynamic> -> EventCommandTrigger)
	{
		_keyFactory = keyFactory;
		_triggerFactory = triggerFactory;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @private
	 */
	
	public function getTrigger(params:Array<Dynamic>):ICommandTrigger
	{
		//CHECK
		var key:Dynamic = getKey(params);
		if (_triggers[UID.instanceID(key)] == null) {
			_triggers[UID.instanceID(key)] = createTrigger(params);
		}
		return _triggers[UID.instanceID(key)];
		
		//return _triggers[UID.instanceID(key)] ||= createTrigger(params);
	}

	/**
	 * @private
	 */
	public function removeTrigger(params:Array<Dynamic>):ICommandTrigger
	{
		return destroyTrigger(getKey(params));
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	private function getKey(mapperArgs:Array<Dynamic>):Dynamic
	{
		return Reflect.callMethod (null, _keyFactory, mapperArgs);
		//return _keyFactory.apply(null, mapperArgs);
	}

	private function createTrigger(mapperArgs:Array<Dynamic>):ICommandTrigger
	{
		return Reflect.callMethod (null, _triggerFactory, mapperArgs);
		//return _triggerFactory.apply(null, mapperArgs);
	}

	private function destroyTrigger(key:Dynamic):ICommandTrigger
	{
		var id:String = UID.clearInstanceID(key);
		var trigger:ICommandTrigger = _triggers[id];
		if (trigger != null)
		{
			trigger.deactivate();
			_triggers.remove(id);
		}
		return trigger;
	}
}