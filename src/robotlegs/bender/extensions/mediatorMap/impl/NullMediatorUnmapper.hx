//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl;

import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorUnmapper;

/**
 * @private
 */

@:keepSub
class NullMediatorUnmapper implements IMediatorUnmapper
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
	public function fromMediator(mediatorClass:Class<Dynamic>):Void
	{
	}

	/**
	 * @private
	 */
	public function fromAll():Void
	{
	}
}