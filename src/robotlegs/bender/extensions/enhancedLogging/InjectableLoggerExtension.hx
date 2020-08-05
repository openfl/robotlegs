//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------
package robotlegs.bender.extensions.enhancedLogging;

import robotlegs.bender.extensions.enhancedLogging.impl.LoggerProvider;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;
import robotlegs.bender.framework.api.ILogger;

/**
 * Allows you to @inject unique loggers into your objects.
 *
 * <code>
 *     @inject
 *     public var logger:ILogger;
 * </code>
 */
@:keepSub
class InjectableLoggerExtension implements IExtension {
	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/
	/**
	 * @inheritDoc
	 */
	public function extend(context:IContext):Void {
		context.injector.map(ILogger).toProvider(new LoggerProvider(context));
	}
}
