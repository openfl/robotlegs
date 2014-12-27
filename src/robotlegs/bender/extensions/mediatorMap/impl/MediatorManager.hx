//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl;

import openfl.display.DisplayObject;
import openfl.events.Event;
//import flash.utils.getDefinitionByName;
import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;

/**
* @private
*/
class MediatorManager
{

	/*============================================================================*/
	/* Private Static Properties                                                  */
	/*============================================================================*/

	private static var UIComponentClass:Class<Dynamic>;

	private static var flexAvailable:Bool = false;// checkFlex();

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
	public function new(factory:MediatorFactory)
	{
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
	public function addMediator(mediator:Dynamic, item:Dynamic, mapping:IMediatorMapping):Void
	{
		var displayObject:DisplayObject = cast(item, DisplayObject);

		// Watch Display Dynamic for removal
		if (displayObject != null && mapping.autoRemoveEnabled)
			displayObject.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

		// Synchronize with item life-cycle
		if (itemInitialized(item))
		{
			initializeMediator(mediator, item);
		}
		else
		{
			var mediatorManagerAddMediator:MediatorManagerAddMediator = new MediatorManagerAddMediator(initializeMediator, _factory, displayObject, mediator, item, mapping);
			displayObject.addEventListener(MediatorManager.CREATION_COMPLETE, mediatorManagerAddMediator.creationComplete);
		}
	}
	
	/**
	 * @private
	 */
	public function removeMediator(mediator:Dynamic, item:Dynamic, mapping:IMediatorMapping):Void
	{
		if (Std.is(item, DisplayObject))
			cast(item, DisplayObject).removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

		if (itemInitialized(item))
			destroyMediator(mediator);
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	private function onRemovedFromStage(event:Event):Void
	{
		_factory.removeMediators(event.target);
	}

	private function itemInitialized(item:Dynamic):Bool
	{
		if (flexAvailable && (Std.is(item, UIComponentClass)) && !Reflect.hasField(item, 'initialized'))
			return false;
		return true;
	}

	private function initializeMediator(mediator:Dynamic, mediatedItem:Dynamic):Void
	{
		if (Reflect.hasField(mediator, 'preInitialize'))
			mediator.preInitialize();

		if (Reflect.hasField(mediator, 'viewComponent'))
			mediator.viewComponent = mediatedItem;

		if (Reflect.hasField(mediator, 'initialize'))
			mediator.initialize();

		if (Reflect.hasField(mediator, 'postInitialize'))
			mediator.postInitialize();
	}

	private function destroyMediator(mediator:Dynamic):Void
	{
		if (Reflect.hasField(mediator, 'preDestroy'))
			mediator.preDestroy();

		if (Reflect.hasField(mediator, 'destroy'))
			mediator.destroy();

		if (Reflect.hasField(mediator, 'viewComponent'))
			mediator.viewComponent = null;

		if (Reflect.hasField(mediator, 'postDestroy'))
			mediator.postDestroy();
	}
}

class MediatorManagerAddMediator
{
	var displayObject:DisplayObject;
	var mediator:Dynamic;
	var item:Dynamic;
	var mapping:IMediatorMapping;
	var _factory:MediatorFactory;
	var initializeMediator:Dynamic;
	
	public function new(initializeMediator:Dynamic -> Dynamic -> Void, _factory:MediatorFactory, displayObject:DisplayObject, mediator:Dynamic, item:Dynamic, mapping:IMediatorMapping)
	{
		this.initializeMediator = initializeMediator;
		this._factory = _factory;
		this.mapping = mapping;
		this.item = item;
		this.mediator = mediator;
		this.displayObject = displayObject;
	}
	
	public function creationComplete(e:Event):Void 
	{
		displayObject.removeEventListener(MediatorManager.CREATION_COMPLETE, creationComplete);
		// Ensure that we haven't been removed in the meantime
		if (_factory.getMediator(item, mapping) == mediator) {
			initializeMediator(mediator, item);
		}
	}
}