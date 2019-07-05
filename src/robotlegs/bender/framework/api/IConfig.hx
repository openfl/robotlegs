//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------
package robotlegs.bender.framework.api;

import haxe.extern.EitherType;

/**
 * Application configuration interface
 */
@:keepSub
interface IConfig {
	/**
	 * Configure will be invoked after dependencies have been supplied
	 */
	function configure():Void;
}

typedef IConfig_Or_Class = EitherType<IConfig, Class<IConfig>>;
