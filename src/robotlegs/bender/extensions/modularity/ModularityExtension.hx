//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------
package robotlegs.bender.extensions.modularity;

import openfl.display.DisplayObjectContainer;
import polyfill.events.Event;
import robotlegs.bender.extensions.contextView.ContextView;
import robotlegs.bender.extensions.matching.InstanceOfType;
import robotlegs.bender.extensions.modularity.api.IModuleConnector;
import robotlegs.bender.extensions.modularity.impl.ContextViewBasedExistenceWatcher;
import robotlegs.bender.extensions.modularity.impl.ModularContextEvent;
import robotlegs.bender.extensions.modularity.impl.ModuleConnector;
import robotlegs.bender.extensions.modularity.impl.ViewManagerBasedExistenceWatcher;
import robotlegs.bender.extensions.viewManager.api.IViewManager;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;
import robotlegs.bender.framework.api.IInjector;
import robotlegs.bender.framework.api.ILogger;

/**
 * This extension allows a context to inherit dependencies from a parent context,
 * and/or expose its dependencies to child contexts.
 *
 * <p>It must be installed before context initialization.</p>
 */
@:keepSub
class ModularityExtension implements IExtension {
	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/
	private var _context:IContext;

	private var _injector:IInjector;

	private var _logger:ILogger;

	private var _inherit:Bool = false;

	private var _expose:Bool = false;

	private var _contextView:DisplayObjectContainer;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/
	/**
	 * Modularity
	 *
	 * @param inherit Should this context inherit dependencies from a parent context?
	 * @param expose Should this context expose its dependencies to child contexts?
	 */
	public function new(inherit:Bool = true, expose:Bool = true) {
		_inherit = inherit;
		_expose = expose;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/
	/**
	 * @inheritDoc
	 */
	public function extend(context:IContext):Void {
		context.beforeInitializing(beforeInitializing);
		_context = context;
		_injector = context.injector;
		_logger = context.getLogger(this);
		_context.addConfigHandler(InstanceOfType.call(ContextView), handleContextView);
		_injector.map(IModuleConnector).toSingleton(ModuleConnector);
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/
	private function beforeInitializing():Void {
		if (_contextView == null)
			_logger.error("Context has no ContextView, and ModularityExtension doesn't allow this.");
	}

	private function handleContextView(contextView:ContextView):Void {
		_contextView = contextView.view;
		if (_expose)
			configureExistenceWatcher();
		if (_inherit)
			configureExistenceBroadcaster();
	}

	private function configureExistenceWatcher():Void {
		if (_injector.hasDirectMapping(IViewManager)) {
			_logger.debug("Context has a ViewManager. Configuring view manager based context existence watcher...");
			var viewManager = _injector.getInstance(IViewManager);
			new ViewManagerBasedExistenceWatcher(_context, viewManager);
		} else {
			_logger.debug("Context has a ContextView. Configuring context view based context existence watcher...");
			new ContextViewBasedExistenceWatcher(_context, _contextView);
		}
	}

	private function configureExistenceBroadcaster():Void {
		if (_contextView.stage != null) {
			broadcastContextExistence();
		} else {
			_logger.debug("Context view is not yet on stage. Waiting...");
			_contextView.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
	}

	private function onAddedToStage(event:Event):Void {
		_logger.debug("Context view is now on stage. Continuing...");
		_contextView.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		broadcastContextExistence();
	}

	private function broadcastContextExistence():Void {
		_logger.debug("Context configured to inherit. Broadcasting existence event...");
		_contextView.dispatchEvent(new ModularContextEvent(ModularContextEvent.CONTEXT_ADD, _context));
	}
}
