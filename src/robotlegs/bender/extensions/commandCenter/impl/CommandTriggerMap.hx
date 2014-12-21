//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.impl;

import openfl.utils.Dictionary;
import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;

/**
 * @private
 */
class CommandTriggerMap
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _triggers:Dictionary = new Dictionary();

	private var _keyFactory:Function;

	private var _triggerFactory:Function;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * Creates a command trigger map
	 * @param keyFactory Factory function to creates keys
	 * @param triggerFactory Factory function to create triggers
	 */
	public function new(keyFactory:Function, triggerFactory:Function)
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
	public function getTrigger(... params):ICommandTrigger
	{
		var key:Dynamic = getKey(params);
		return _triggers[key] ||= createTrigger(params);
	}

	/**
	 * @private
	 */
	public function removeTrigger(... params):ICommandTrigger
	{
		return destroyTrigger(getKey(params));
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	private function getKey(mapperArgs:Array<Dynamic>):Dynamic
	{
		return _keyFactory.apply(null, mapperArgs);
	}

	private function createTrigger(mapperArgs:Array<Dynamic>):ICommandTrigger
	{
		return _triggerFactory.apply(null, mapperArgs);
	}

	private function destroyTrigger(key:Dynamic):ICommandTrigger
	{
		var trigger:ICommandTrigger = _triggers[key];
		if (trigger)
		{
			trigger.deactivate();
			delete _triggers[key];
		}
		return trigger;
	}
}