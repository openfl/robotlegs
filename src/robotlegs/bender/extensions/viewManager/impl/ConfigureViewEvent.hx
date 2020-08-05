//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------
package robotlegs.bender.extensions.viewManager.impl;

import openfl.display.DisplayObject;
import polyfill.events.Event;

/**
 * View Configuration Event
 * @private
 */
@:keepSub
class ConfigureViewEvent extends Event {
	/*============================================================================*/
	/* Public Static Properties                                                   */
	/*============================================================================*/
	public static var CONFIGURE_VIEW:String = 'configureView';

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/
	private var _view:DisplayObject;

	public var view(default, null):DisplayObject;

	/**
	 * The view instance associated with this event
	 */
	/*public function get_view():DisplayObject
		{
			return _view;
	}*/
	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/
	/**
	 * Creates a view configuration event
	 * @param type The event type
	 * @param view The associated view instance
	 */
	public function new(type:String, view:DisplayObject = null) {
		super(type, true, true);
		_view = view;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/
	/**
	 * @inheritDoc
	 */
	override public function clone():Event {
		return new ConfigureViewEvent(type, _view);
	}
}
