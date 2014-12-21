//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl;

import openfl.display.DisplayObject;
import openfl.events.Event;
import flash.utils.getDefinitionByName;
import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;

/**
* @private
*/
class MediatorManager
{

	/*============================================================================*/
	/* Private Static Properties                                                  */
	/*============================================================================*/

	private static var UIComponentClass:Class;

	private static var flexAvailable:Bool = checkFlex();

	private static var CREATION_COMPLETE:String = "creationComplete";

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

	private static function checkFlex():Bool
	{
		try
		{
			UIComponentClass = getDefinitionByName('mx.core::UIComponent') as Class;
		}
		catch (error:Error)
		{
			// Do nothing
		}
		return UIComponentClass != null;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function addMediator(mediator:Dynamic, item:Dynamic, mapping:IMediatorMapping):Void
	{
		var displayObject:DisplayObject = item as DisplayObject;

		// Watch Display Dynamic for removal
		if (displayObject && mapping.autoRemoveEnabled)
			displayObject.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

		// Synchronize with item life-cycle
		if (itemInitialized(item))
		{
			initializeMediator(mediator, item);
		}
		else
		{
			displayObject.addEventListener(CREATION_COMPLETE, function(e:Event):Void
			{
				displayObject.removeEventListener(CREATION_COMPLETE, arguments.callee);
				// Ensure that we haven't been removed in the meantime
				if (_factory.getMediator(item, mapping) == mediator)
					initializeMediator(mediator, item);
			});
		}
	}

	/**
	 * @private
	 */
	public function removeMediator(mediator:Dynamic, item:Dynamic, mapping:IMediatorMapping):Void
	{
		if (item is DisplayObject)
			DisplayObject(item).removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

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
		if (flexAvailable && (item is UIComponentClass) && !item['initialized'])
			return false;
		return true;
	}

	private function initializeMediator(mediator:Dynamic, mediatedItem:Dynamic):Void
	{
		if ('preInitialize' in mediator)
			mediator.preInitialize();

		if ('viewComponent' in mediator)
			mediator.viewComponent = mediatedItem;

		if ('initialize' in mediator)
			mediator.initialize();

		if ('postInitialize' in mediator)
			mediator.postInitialize();
	}

	private function destroyMediator(mediator:Dynamic):Void
	{
		if ('preDestroy' in mediator)
			mediator.preDestroy();

		if ('destroy' in mediator)
			mediator.destroy();

		if ('viewComponent' in mediator)
			mediator.viewComponent = null;

		if ('postDestroy' in mediator)
			mediator.postDestroy();
	}
}