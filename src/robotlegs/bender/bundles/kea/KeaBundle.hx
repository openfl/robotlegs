//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.bundles.kea;

import robotlegs.bender.extensions.directCommandMap.DirectCommandMapExtension;
import robotlegs.bender.extensions.enhancedLogging.InjectableLoggerExtension;
import robotlegs.bender.extensions.enhancedLogging.TraceLoggingExtension;
import robotlegs.bender.extensions.eventCommandMap.EventCommandMapExtension;
import robotlegs.bender.extensions.eventDispatcher.EventDispatcherExtension;
import robotlegs.bender.extensions.localEventMap.LocalEventMapExtension;
import robotlegs.bender.extensions.signalCommandMap.SignalCommandMapExtension;
import robotlegs.bender.extensions.vigilance.VigilanceExtension;
import robotlegs.bender.framework.api.IBundle;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.LogLevel;

/**
 * For that Classic Robotlegs flavour
 *
 * <p>This bundle installs a number of extensions commonly used
 * in typical Robotlegs applications and modules.</p>
 */

@:keepSub
class KeaBundle implements IBundle
{
	public function new() 
	{
		
	}
	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/
	
	/**
	 * @inheritDoc
	 */
	public function extend(context:IContext):Void
	{
		context.logLevel = LogLevel.INFO;
		
		context.install([
			TraceLoggingExtension,
			VigilanceExtension,
			InjectableLoggerExtension,
			EventDispatcherExtension,
			DirectCommandMapExtension,
			EventCommandMapExtension,
			SignalCommandMapExtension,
			LocalEventMapExtension
			]);
			
		//context.configure([ContextViewListenerConfig]);
	}
}
