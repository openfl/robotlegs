//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.modularity.impl;

import openfl.display.DisplayObjectContainer;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.ILogger;

/**
 * @private
 */

@:keepSub
class ContextViewBasedExistenceWatcher
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _logger:ILogger;

	private var _contextView:DisplayObjectContainer;

	private var _context:IContext;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function new(context:IContext, contextView:DisplayObjectContainer)
	{
		_logger = context.getLogger(this);
		_contextView = contextView;
		_context = context;
		_context.whenDestroying(destroy);
		init();
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	private function init():Void
	{
		_logger.debug("Listening for context existence events on contextView {0}", [_contextView]);
		_contextView.addEventListener(ModularContextEvent.CONTEXT_ADD, onContextAdd);
	}

	private function destroy():Void
	{
		_logger.debug("Removing modular context existence event listener from contextView {0}", [_contextView]);
		_contextView.removeEventListener(ModularContextEvent.CONTEXT_ADD, onContextAdd);
	}

	private function onContextAdd(event:ModularContextEvent):Void
	{
		// We might catch out own existence event, so ignore that
		if (event.context != _context)
		{
			event.stopImmediatePropagation();
			_logger.debug("Context existence event caught. Configuring child context {0}", [event.context]);
			_context.addChild(event.context);
		}
	}
}