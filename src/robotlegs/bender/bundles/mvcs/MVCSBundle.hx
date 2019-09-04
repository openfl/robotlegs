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
import robotlegs.bender.extensions.mediatorMap.MediatorMapExtension;
import robotlegs.bender.extensions.modularity.ModularityExtension;
import robotlegs.bender.extensions.viewManager.StageCrawlerExtension;
import robotlegs.bender.extensions.viewManager.StageObserverExtension;
import robotlegs.bender.extensions.viewManager.ViewManagerExtension;
import robotlegs.bender.extensions.viewProcessorMap.ViewProcessorMapExtension;

import robotlegs.bender.framework.api.IBundle;
import robotlegs.bender.framework.api.IContext;

/**
 * For that Classic Robotlegs flavour
 *
 * <p>This bundle installs a number of extensions commonly used
 * in typical Robotlegs applications and modules.</p>
 */
@:keepSub
class MVCSBundle extends MCSBundle implements IBundle {
	public function new() {}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/
	/**
	 * @inheritDoc
	 */
	public function extend(context:IContext):Void {
		super.extend(context);

		context.install(ContextViewExtension);
		context.install(StageSyncExtension);
		context.install(ModularityExtension);
		context.install(MediatorMapExtension);
		context.install(ViewManagerExtension);
		context.install(StageObserverExtension);
		context.install(ViewProcessorMapExtension);
		context.install(StageCrawlerExtension);
		context.configure(ContextViewListenerConfig);
	}
}
