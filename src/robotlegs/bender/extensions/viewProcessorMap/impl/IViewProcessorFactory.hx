//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------
package robotlegs.bender.extensions.viewProcessorMap.impl;

/**
 * @private
 */
interface IViewProcessorFactory {
	/**
	 * @private
	 */
	function runProcessors(view:Dynamic, type:Class<Dynamic>, processorMappings:Array<Dynamic>):Void;

	/**
	 * @private
	 */
	function runUnprocessors(view:Dynamic, type:Class<Dynamic>, processorMappings:Array<Dynamic>):Void;

	/**
	 * @private
	 */
	function runAllUnprocessors():Void;
}
