//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.enhancedLogging.impl;


import org.swiftsuspenders.Injector;
import org.swiftsuspenders.dependencyproviders.DependencyProvider;
import robotlegs.bender.framework.api.IContext;

/**
 * @private
 */
class LoggerProvider implements DependencyProvider
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _context:IContext;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function new(context:IContext)
	{
		_context = context;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @inheritDoc
	 */
	public function apply(targetType:Class<Dynamic>, activeInjector:Injector, injectParameters:Map<Dynamic,Dynamic>):Dynamic
	{
		return _context.getLogger(targetType);
	}

	/**
	 * @inheritDoc
	 */
	public function destroy():Void
	{
	}
}