//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager;

import openfl.display.DisplayObjectContainer;
import robotlegs.bender.extensions.contextView.ContextView;
import robotlegs.bender.extensions.viewManager.api.IViewManager;
import robotlegs.bender.extensions.viewManager.impl.ContainerBinding;
import robotlegs.bender.extensions.viewManager.impl.ContainerRegistry;
import robotlegs.bender.extensions.viewManager.impl.StageCrawler;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;
import robotlegs.bender.framework.api.IInjector;
import robotlegs.bender.framework.api.ILogger;

/**
 * View Handlers (like the MediatorMap) handle views as they land on stage.
 *
 * This extension checks for views that might already be on the stage
 * after context initialization and ensures that those views are handled.
 */
class StageCrawlerExtension implements IExtension
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _logger:ILogger;

	private var _injector:IInjector;

	private var _containerRegistry:ContainerRegistry;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @inheritDoc
	 */
	public function extend(context:IContext):Void
	{
		_injector = context.injector;
		_logger = context.getLogger(this);
		context.afterInitializing(afterInitializing);
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	private function afterInitializing():Void
	{
		_containerRegistry = _injector.getInstance(ContainerRegistry);
		_injector.hasDirectMapping(IViewManager)
			? scanViewManagedContainers()
			: scanContextView();
	}

	private function scanViewManagedContainers():Void
	{
		_logger.debug("ViewManager is installed. Checking for managed containers...");
		var viewManager:IViewManager = _injector.getInstance(IViewManager);
		for (container in viewManager.containers)
		{
			if (container.stage != null) scanContainer(container);
		}
	}

	private function scanContextView():Void
	{
		_logger.debug("ViewManager is not installed. Checking the ContextView...");
		var contextView:ContextView = _injector.getInstance(ContextView);
		if (contextView.view.stage != null) scanContainer(contextView.view);
	}

	private function scanContainer(container:DisplayObjectContainer):Void
	{
		var binding:ContainerBinding = _containerRegistry.getBinding(container);
		_logger.debug("StageCrawler scanning container {0} ...", [container]);
		new StageCrawler(binding).scan(container);
		_logger.debug("StageCrawler finished scanning {0}", [container]);
	}
}