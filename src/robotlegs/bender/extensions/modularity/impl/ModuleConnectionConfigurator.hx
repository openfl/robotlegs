//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------
package robotlegs.bender.extensions.modularity.impl;

import polyfill.events.IEventDispatcher;
import robotlegs.bender.extensions.eventDispatcher.impl.EventRelay;
import robotlegs.bender.extensions.modularity.dsl.IModuleConnectionAction;

/**
 * @private
 */
@:keepSub
class ModuleConnectionConfigurator implements IModuleConnectionAction {
	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/
	private var _channelToLocalRelay:EventRelay;

	private var _localToChannelRelay:EventRelay;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/
	/**
	 * @private
	 */
	public function new(localDispatcher:IEventDispatcher, channelDispatcher:IEventDispatcher) {
		_localToChannelRelay = new EventRelay(localDispatcher, channelDispatcher).start();
		_channelToLocalRelay = new EventRelay(channelDispatcher, localDispatcher).start();
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/
	/**
	 * @inheritDoc
	 */
	public function relayEvent(eventType:String):IModuleConnectionAction {
		_localToChannelRelay.addType(eventType);
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function receiveEvent(eventType:String):IModuleConnectionAction {
		_channelToLocalRelay.addType(eventType);
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function suspend():Void {
		_channelToLocalRelay.stop();
		_localToChannelRelay.stop();
	}

	/**
	 * @inheritDoc
	 */
	public function resume():Void {
		_channelToLocalRelay.start();
		_localToChannelRelay.start();
	}

	/**
	 * @private
	 */
	public function destroy():Void {
		_localToChannelRelay.stop();
		_localToChannelRelay = null;
		_channelToLocalRelay.stop();
		_channelToLocalRelay = null;
	}
}
