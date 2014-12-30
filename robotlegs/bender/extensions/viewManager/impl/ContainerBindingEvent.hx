//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager.impl;

import openfl.events.Event;

/**
 * @private
 */
class ContainerBindingEvent extends Event
{

	/*============================================================================*/
	/* Public Static Properties                                                   */
	/*============================================================================*/

	public static var BINDING_EMPTY:String = 'bindingEmpty';

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function new(type:String)
	{
		super(type);
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @inheritDoc
	 */
	override public function clone():Event
	{
		return new ContainerBindingEvent(type);
	}
}