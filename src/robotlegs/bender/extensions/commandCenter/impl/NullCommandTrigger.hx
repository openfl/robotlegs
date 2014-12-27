//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.impl;

import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;

/**
 * @private
 */
class NullCommandTrigger implements ICommandTrigger
{
	public function new()
	{
		
	}
	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function activate():Void
	{
	}

	/**
	 * @private
	 */
	public function deactivate():Void
	{
	}
}