//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventDispatcher;

import openfl.events.EventDispatcher;
import openfl.events.IEventDispatcher;
import robotlegs.bender.extensions.eventDispatcher.impl.LifecycleEventRelay;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;

/**
 * This extension maps an IEventDispatcher into a context's injector.
 */

@:keepSub
class EventDispatcherExtension implements IExtension
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _context:IContext;

	private var _eventDispatcher:IEventDispatcher;

	private var _lifecycleRelay:LifecycleEventRelay;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * Creates an Event Dispatcher Extension
	 * @param eventDispatcher Optional IEventDispatcher instance to share
	 */
	public function new(eventDispatcher:IEventDispatcher = null)
	{
		if (eventDispatcher != null) _eventDispatcher = eventDispatcher;
		else _eventDispatcher = new EventDispatcher();
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @inheritDoc
	 */
	public function extend(context:IContext):Void
	{
		_context = context;
		_context.injector.map(IEventDispatcher).toValue(_eventDispatcher);
		_context.beforeInitializing(configureLifecycleEventRelay);
		_context.afterDestroying(destroyLifecycleEventRelay);
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	private function configureLifecycleEventRelay():Void
	{
		_lifecycleRelay = new LifecycleEventRelay(_context, _eventDispatcher);
	}

	private function destroyLifecycleEventRelay():Void
	{
		_lifecycleRelay.destroy();
	}
}