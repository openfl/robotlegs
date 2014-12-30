//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl;

import robotlegs.bender.framework.api.ILogTarget;
import robotlegs.bender.framework.api.ILogger;
import robotlegs.bender.framework.api.LogLevel;

/**
 * The log manager creates loggers and is itself a log target
 *
 * @private
 */
class LogManager implements ILogTarget
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	private var _logLevel:UInt = LogLevel.INFO;

	/**
	 * The current log level
	 */
	public var logLevel(get, set):UInt;
	function get_logLevel():UInt
	{
		return _logLevel;
	}

	/**
	 * Sets the current log level
	 */
	function set_logLevel(value:UInt):UInt
	{
		_logLevel = value;
		return _logLevel;
	}

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _targets:Array<ILogTarget> = [];

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * Retrieves a logger for a given source
	 * @param source Logging source
	 * @return Logger
	 */
	public function getLogger(source:Dynamic):ILogger
	{
		return new Logger(source, this);
	}

	/**
	 * Adds a custom log target
	 * @param target Log target
	 * @return this
	 */
	public function addLogTarget(target:ILogTarget):Void
	{
		_targets.push(target);
	}

	/**
	 * @inheritDoc
	 */
	public function log(source:Dynamic, level:UInt, timestamp:Int, message:String, params:Array<Dynamic> = null):Void
	{
		if (level > _logLevel)
			return;

		for (target in _targets)
		{
			target.log(source, level, timestamp, message, params);
		}
	}

	public function removeAllTargets():Void
	{
		_targets = [];
	}
}