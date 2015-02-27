//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl;

import openfl.Lib;
import robotlegs.bender.framework.api.ILogTarget;
import robotlegs.bender.framework.api.ILogger;

/**
 * Default Robotlegs logger
 *
 * @private
 */
@:keepSub
class Logger implements ILogger
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _source:Dynamic;

	private var _target:ILogTarget;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * Creates a new logger
	 * @param source The log source object
	 * @param target The log target
	 */
	public function new(source:Dynamic, target:ILogTarget)
	{
		_source = source;
		_target = target;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @inheritDoc
	 */
	public function debug(message:Dynamic, params:Array<Dynamic> = null):Void
	{
		_target.log(_source, 32, Lib.getTimer(), message, params);
	}

	/**
	 * @inheritDoc
	 */
	public function info(message:Dynamic, params:Array<Dynamic> = null):Void
	{
		_target.log(_source, 16, Lib.getTimer(), message, params);
	}

	/**
	 * @inheritDoc
	 */
	public function warn(message:Dynamic, params:Array<Dynamic> = null):Void
	{
		_target.log(_source, 8, Lib.getTimer(), message, params);
	}

	/**
	 * @inheritDoc
	 */
	public function error(message:Dynamic, params:Array<Dynamic> = null):Void
	{
		_target.log(_source, 4, Lib.getTimer(), message, params);
	}

	/**
	 * @inheritDoc
	 */
	public function fatal(message:Dynamic, params:Array<Dynamic> = null):Void
	{
		_target.log(_source, 2, Lib.getTimer(), message, params);
	}
}
