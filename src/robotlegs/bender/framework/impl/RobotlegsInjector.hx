//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl;

import openfl.system.ApplicationDomain;
import org.swiftsuspenders.Injector;
import robotlegs.bender.framework.api.IInjector;

/**
 * Robotlegs IInjector Adapter
 */
class RobotlegsInjector extends Injector implements IInjector
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	/**
	 * @inheritDoc
	 */
	public function set parent(parentInjector:IInjector):Void
	{
		this.parentInjector = parentInjector as RobotlegsInjector;
	}

	/**
	 * @inheritDoc
	 */
	public function get parent():IInjector
	{
		return this.parentInjector as RobotlegsInjector;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	* @inheritDoc
	*/
	public function createChild(applicationDomain:ApplicationDomain = null):IInjector
	{
		var childInjector:IInjector = new RobotlegsInjector();
		childInjector.applicationDomain = applicationDomain || this.applicationDomain;
		childInjector.parent = this;
		return childInjector;
	}
}
