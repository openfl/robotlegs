//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------
package robotlegs.bender.bundles.mvcs;

import robotlegs.bender.extensions.contextView.ContextViewExtension;
import robotlegs.bender.extensions.contextView.StageSyncExtension;
import robotlegs.bender.extensions.contextView.ContextViewListenerConfig;
import robotlegs.bender.extensions.directCommandMap.DirectCommandMapExtension;
import robotlegs.bender.extensions.enhancedLogging.InjectableLoggerExtension;
// import robotlegs.bender.extensions.enhancedLogging.TraceLoggingExtension;
import robotlegs.bender.extensions.eventCommandMap.EventCommandMapExtension;
import robotlegs.bender.extensions.eventDispatcher.EventDispatcherExtension;
import robotlegs.bender.extensions.localEventMap.LocalEventMapExtension;
import robotlegs.bender.extensions.logicMap.LogicMapExtension;
import robotlegs.bender.extensions.modelMap.ModelExtension;
import robotlegs.bender.extensions.mediatorMap.MediatorMapExtension;
import robotlegs.bender.extensions.modularity.ModularityExtension;
import robotlegs.bender.extensions.signalCommandMap.SignalCommandMapExtension;
import robotlegs.bender.extensions.viewManager.StageCrawlerExtension;
import robotlegs.bender.extensions.viewManager.StageObserverExtension;
import robotlegs.bender.extensions.viewManager.ViewManagerExtension;
import robotlegs.bender.extensions.viewProcessorMap.ViewProcessorMapExtension;
import robotlegs.bender.extensions.vigilance.VigilanceExtension;
import robotlegs.bender.extensions.config.ConfigExtension;
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
class MVCSBundle implements IBundle {
	public function new() {}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/
	/**
	 * @inheritDoc
	 */
	public function extend(context:IContext):Void {
		context.logLevel = LogLevel.INFO;

		context.install(InjectableLoggerExtension);
		context.install(ContextViewExtension);
		context.install(EventDispatcherExtension);
		context.install(ModularityExtension);
		context.install(DirectCommandMapExtension);
		context.install(EventCommandMapExtension);
		context.install(SignalCommandMapExtension);
		context.install(LocalEventMapExtension);
		context.install(ViewManagerExtension);
		context.install(StageObserverExtension);
		context.install(MediatorMapExtension);
		context.install(LogicMapExtension);
		context.install(ModelExtension);
		context.install(ViewProcessorMapExtension);
		context.install(StageCrawlerExtension);
		context.install(StageSyncExtension);
		context.install(ConfigExtension);

		context.configure(ContextViewListenerConfig);
	}
}
