//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------
package robotlegs.bender.extensions.mediatorMap.impl;

import polyfill.events.Event;
import polyfill.events.EventDispatcher;
import org.swiftsuspenders.utils.CallProxy;
import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;

/**
 * @private
 */
@:keepSub
class MediatorManager {
	/*============================================================================*/
	/* Private Static Properties                                                  */
	/*============================================================================*/
	private static var UIComponentClass:Class<Dynamic>;

	private static var flexAvailable:Bool = false; // checkFlex();

	public static var CREATION_COMPLETE:String = "creationComplete";

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/
	private var _factory:MediatorFactory;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/
	/**
	 * @private
	 */
	public function new(factory:MediatorFactory) {
		_factory = factory;
	}

	/*============================================================================*/
	/* Private Static Functions                                                   */
	/*============================================================================*/
	/*private static function checkFlex():Bool
		{
			try
			{
				UIComponentClass = cast(getDefinitionByName('mx.core::UIComponent'), Class<Dynamic>);
			}
			catch (error:Error)
			{
				// Do nothing
			}
			return UIComponentClass != null;
	}*/
	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/
	/**
	 * @private
	 */
	public function addMediator(mediator:Dynamic, item:Dynamic, mapping:IMediatorMapping):Void {
		var eventDispatcher:EventDispatcher = null;
		if (Std.isOfType(item, EventDispatcher)) {
			eventDispatcher = cast(item, EventDispatcher);
		}

		// Watch Display Dynamic for removal
		if (eventDispatcher != null && mapping.autoRemoveEnabled)
			eventDispatcher.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

		// Synchronize with item life-cycle
		if (itemInitialized(item)) {
			initializeMediator(mediator, item);
		} else {
			var mediatorManagerAddMediator:MediatorManagerAddMediator = new MediatorManagerAddMediator(initializeMediator, _factory, eventDispatcher,
				mediator, item, mapping);
			eventDispatcher.addEventListener(MediatorManager.CREATION_COMPLETE, mediatorManagerAddMediator.creationComplete);
		}
	}

	/**
	 * @private
	 */
	public function removeMediator(mediator:Dynamic, item:Dynamic, mapping:IMediatorMapping):Void {
		if (Std.isOfType(item, EventDispatcher))
			cast(item, EventDispatcher).removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

		if (itemInitialized(item))
			destroyMediator(mediator);
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/
	private function onRemovedFromStage(event:Event):Void {
		_factory.removeMediators(event.target);
	}

	private function itemInitialized(item:Dynamic):Bool {
		if (flexAvailable && (Std.isOfType(item, UIComponentClass)) && !CallProxy.hasField(item, 'initialized'))
			return false;
		return true;
	}

	private function initializeMediator(mediator:Dynamic, mediatedItem:Dynamic):Void {
		if (CallProxy.hasField(mediator, 'preInitialize'))
			mediator.preInitialize();

		if (CallProxy.hasField(mediator, 'viewComponent'))
			mediator.viewComponent = mediatedItem;

		if (CallProxy.hasField(mediator, 'initialize'))
			mediator.initialize();

		if (CallProxy.hasField(mediator, 'postInitialize'))
			mediator.postInitialize();
	}

	private function destroyMediator(mediator:Dynamic):Void {
		if (CallProxy.hasField(mediator, 'preDestroy'))
			mediator.preDestroy();

		if (CallProxy.hasField(mediator, 'destroy'))
			mediator.destroy();

		if (CallProxy.hasField(mediator, 'viewComponent'))
			mediator.viewComponent = null;

		if (CallProxy.hasField(mediator, 'postDestroy'))
			mediator.postDestroy();
	}
}

@:keepSub
class MediatorManagerAddMediator {
	var eventDispatcher:EventDispatcher;
	var mediator:Dynamic;
	var item:Dynamic;
	var mapping:IMediatorMapping;
	var _factory:MediatorFactory;
	var initializeMediator:Dynamic;

	public function new(initializeMediator:Dynamic->Dynamic->Void, _factory:MediatorFactory, eventDispatcher:EventDispatcher, mediator:Dynamic, item:Dynamic,
			mapping:IMediatorMapping) {
		this.initializeMediator = initializeMediator;
		this._factory = _factory;
		this.mapping = mapping;
		this.item = item;
		this.mediator = mediator;
		this.eventDispatcher = eventDispatcher;
	}

	public function creationComplete(e:Event):Void {
		eventDispatcher.removeEventListener(MediatorManager.CREATION_COMPLETE, creationComplete);
		// Ensure that we haven't been removed in the meantime
		if (_factory.getMediator(item, mapping) == mediator) {
			initializeMediator(mediator, item);
		}
	}
}
