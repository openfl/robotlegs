//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------
package robotlegs.bender.extensions.viewProcessorMap.impl;

import robotlegs.bender.extensions.viewProcessorMap.dsl.IViewProcessorUnmapper;

/**
 * @private
 */
@:keepSub
class NullViewProcessorUnmapper implements IViewProcessorUnmapper {
	public function new() {}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/
	/**
	 * @private
	 */
	public function fromProcess(processorClassOrInstance:Dynamic):Void {}

	/**
	 * @private
	 */
	public function fromAll():Void {}

	/**
	 * @private
	 */
	public function fromNoProcess():Void {}

	/**
	 * @private
	 */
	public function fromInjection():Void {}
}
