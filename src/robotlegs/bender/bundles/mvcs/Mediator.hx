//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.bundles.mvcs;

import openfl.events.Event;
import openfl.events.IEventDispatcher;
import robotlegs.bender.extensions.localEventMap.api.IEventMap;
import robotlegs.bender.extensions.mediatorMap.api.IMediator;

/**
 * Classic Robotlegs mediator implementation
 *
 * <p>Override initialize and destroy to hook into the mediator lifecycle.</p>
 */
class Mediator implements IMediator
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	@inject public var eventMap:IEventMap;

	@inject public var eventDispatcher:IEventDispatcher;

	private var _viewComponent:Dynamic;

	/**
	 * @private
	 */
	public function set_viewComponent(view:Dynamic):Void
	{
		_viewComponent = view;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @inheritDoc
	 */
	public function initialize():Void
	{
	}

	/**
	 * @inheritDoc
	 */
	public function destroy():Void
	{
	}

	/**
	 * Runs after the mediator has been destroyed.
	 * Cleans up listeners mapped through the local EventMap.
	 */
	public function postDestroy():Void
	{
		eventMap.unmapListeners();
	}

	/*============================================================================*/
	/* private Functions                                                        */
	/*============================================================================*/

	private function addViewListener(eventString:String, listener:Dynamic, eventClass:Class<Dynamic> = null):Void
	{
		eventMap.mapListener(cast(_viewComponent, IEventDispatcher), eventString, listener, eventClass);
	}

	private function addContextListener(eventString:String, listener:Dynamic, eventClass:Class<Dynamic> = null):Void
	{
		eventMap.mapListener(eventDispatcher, eventString, listener, eventClass);
	}

	private function removeViewListener(eventString:String, listener:Dynamic, eventClass:Class<Dynamic> = null):Void
	{
		eventMap.unmapListener(cast(_viewComponent, IEventDispatcher), eventString, listener, eventClass);
	}

	private function removeContextListener(eventString:String, listener:Dynamic, eventClass:Class<Dynamic> = null):Void
	{
		eventMap.unmapListener(eventDispatcher, eventString, listener, eventClass);
	}

	private function dispatch(event:Event):Void
	{
		if (eventDispatcher.hasEventListener(event.type))
			eventDispatcher.dispatchEvent(event);
	}
}