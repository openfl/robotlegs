//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.modularity.impl;

import openfl.events.Event;
import robotlegs.bender.framework.api.IContext;

/**
 * Module Context Event
 * @private
 */

@:keepSub
class ModularContextEvent extends Event
{

	/*============================================================================*/
	/* Public Static Properties                                                   */
	/*============================================================================*/

	public static var CONTEXT_ADD:String = "contextAdd";

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	private var _context:IContext;
	public var context(get, null):IContext;
	
	private function get_context():IContext
	{
		return _context;
	}
	
	/**
	 * The context associated with this event
	 */
	/*public function get_context():IContext
	{
		return _context;
	}*/

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * Creates a Module Context Event
	 * @param type The event type
	 * @param context The associated context
	 */
	public function new(type:String, context:IContext)
	{
		super(type, true, true);
		_context = context;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @inheritDoc
	 */
	override public function clone():Event
	{
		return new ModularContextEvent(type, context);
	}

	override public function toString():String
	{
		return "[ModularContextEvent, context]";
	}
}