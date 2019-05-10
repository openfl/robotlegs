//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.contextView;

import openfl.display.DisplayObjectContainer;

/**
 * The Context View represents the root DisplayObjectContainer for a Context
 */
class ContextView
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	public var view:DisplayObjectContainer;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * The Context View represents the root DisplayObjectContainer for a Context
	 * @param view The root DisplayObjectContainer for this Context
	 */
	public function new(view:DisplayObjectContainer)
	{
		this.view = view;
	}
}