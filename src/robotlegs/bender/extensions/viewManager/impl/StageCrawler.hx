//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager.impl;

import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;

/**
 * @private
 */
class StageCrawler
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _binding:ContainerBinding;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function new(containerBinding:ContainerBinding)
	{
		_binding = containerBinding;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function scan(view:DisplayObjectContainer):Void
	{
		scanContainer(view);
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	private function scanContainer(container:DisplayObjectContainer):Void
	{
		processView(container);
		var numChildren:Int = container.numChildren;
		for (var i:Int = 0; i < numChildren; i++)
		{
			var child:DisplayObject = container.getChildAt(i);
			child is DisplayObjectContainer
				? scanContainer(child as DisplayObjectContainer)
				: processView(child);
		}
	}

	private function processView(view:DisplayObject):Void
	{
		_binding.handleView(view, view['constructor']);
	}
}