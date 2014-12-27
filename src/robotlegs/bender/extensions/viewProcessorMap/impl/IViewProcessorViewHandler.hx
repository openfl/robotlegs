//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewProcessorMap.impl;

import robotlegs.bender.extensions.viewProcessorMap.dsl.IViewProcessorMapping;

/**
 * @private
 */
interface IViewProcessorViewHandler
{
	/**
	 * @private
	 */
	function addMapping(mapping:IViewProcessorMapping):Void;

	/**
	 * @private
	 */
	function removeMapping(mapping:IViewProcessorMapping):Void;

	/**
	 * @private
	 */
	function processItem(item:Dynamic, type:Class<Dynamic>):Void;

	/**
	 * @private
	 */
	function unprocessItem(item:Dynamic, type:Class<Dynamic>):Void;
}
