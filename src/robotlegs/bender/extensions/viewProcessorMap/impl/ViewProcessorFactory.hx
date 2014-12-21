//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewProcessorMap.impl;

import openfl.display.DisplayObject;
import openfl.events.Event;
import openfl.utils.Dictionary;
import org.swiftsuspenders.errors.InjectorInterfaceConstructionError;
import robotlegs.bender.extensions.matching.ITypeFilter;
import robotlegs.bender.extensions.viewProcessorMap.api.ViewProcessorMapError;
import robotlegs.bender.extensions.viewProcessorMap.dsl.IViewProcessorMapping;
import robotlegs.bender.framework.api.IInjector;
import robotlegs.bender.framework.impl.ApplyHooks;
import robotlegs.bender.framework.impl.GuardsApprove;

/**
 * @private
 */
class ViewProcessorFactory implements IViewProcessorFactory
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _injector:IInjector;

	private var _listenersByView:Dictionary = new Dictionary(true);

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function new(injector:IInjector)
	{
		_injector = injector;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @inheritDoc
	 */
	public function runProcessors(view:Dynamic, type:Class, processorMappings:Array<Dynamic>):Void
	{
		createRemovedListener(view, type, processorMappings);

		var filter:ITypeFilter;

		for each (var mapping:IViewProcessorMapping in processorMappings)
		{
			filter = mapping.matcher;
			mapTypeForFilterBinding(filter, type, view);
			runProcess(view, type, mapping);
			unmapTypeForFilterBinding(filter, type, view);
		}
	}

	/**
	 * @inheritDoc
	 */
	public function runUnprocessors(view:Dynamic, type:Class, processorMappings:Array<Dynamic>):Void
	{
		for each (var mapping:IViewProcessorMapping in processorMappings)
		{
			// ?? Is this correct - will assume that people are implementing something sensible in their processors.
			mapping.processor ||= createProcessor(mapping.processorClass);
			mapping.processor.unprocess(view, type, _injector);
		}
	}

	/**
	 * @inheritDoc
	 */
	public function runAllUnprocessors():Void
	{
		for each (var removalHandlers:Array<Dynamic> in _listenersByView)
		{
			var iLength:UInt = removalHandlers.length;
			for (var i:UInt = 0; i < iLength; i++)
			{
				removalHandlers[i](null);
			}
		}
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	private function runProcess(view:Dynamic, type:Class, mapping:IViewProcessorMapping):Void
	{
		if (GuardsApprove.call(mapping.guards, _injector))
		{
			mapping.processor ||= createProcessor(mapping.processorClass);
			ApplyHooks(mapping.hooks, _injector);
			mapping.processor.process(view, type, _injector);
		}
	}

	private function createProcessor(processorClass:Class):Dynamic
	{
		if (_injector.hasMapping(processorClass) == null)
		{
			_injector.map(processorClass).asSingleton();
		}

		try
		{
			return _injector.getInstance(processorClass);
		}
		catch (error:InjectorInterfaceConstructionError)
		{
			var errorMsg:String = "The view processor "
				+ processorClass
				+ " has not been mapped in the injector, "
				+ "and it is not possible to instantiate an interface. "
				+ "Please map a concrete type against this interface.";
			throw(new ViewProcessorMapError(errorMsg));
		}
		return null;
	}

	private function mapTypeForFilterBinding(filter:ITypeFilter, type:Class, view:Dynamic):Void
	{
		var requiredType:Class;
		var requiredTypes:Array<Class> = requiredTypesFor(filter, type);

		for each (requiredType in requiredTypes)
		{
			_injector.map(requiredType).toValue(view);
		}
	}

	private function unmapTypeForFilterBinding(filter:ITypeFilter, type:Class, view:Dynamic):Void
	{
		var requiredType:Class;
		var requiredTypes:Array<Class> = requiredTypesFor(filter, type);

		for each (requiredType in requiredTypes)
		{
			if (_injector.hasDirectMapping(requiredType))
				_injector.unmap(requiredType);
		}
	}

	private function requiredTypesFor(filter:ITypeFilter, type:Class):Array<Class>
	{
		var requiredTypes:Array<Class> = filter.allOfTypes.concat(filter.anyOfTypes);

		if (requiredTypes.indexOf(type) == -1)
			requiredTypes.push(type);

		return requiredTypes;
	}

	private function createRemovedListener(view:Dynamic, type:Class, processorMappings:Array<Dynamic>):Void
	{
		if (view is DisplayObject)
		{
			_listenersByView[view] ||= [];

			var handler:Function = function(e:Event):Void {
				runUnprocessors(view, type, processorMappings);
				(view as DisplayObject).removeEventListener(Event.REMOVED_FROM_STAGE, handler);
				removeHandlerFromView(view, handler);
			};

			_listenersByView[view].push(handler);
			(view as DisplayObject).addEventListener(Event.REMOVED_FROM_STAGE, handler, false, 0, true);
		}
	}

	private function removeHandlerFromView(view:Dynamic, handler:Function):Void
	{
		if (_listenersByView[view] && (_listenersByView[view].length > 0))
		{
			var handlerIndex:UInt = _listenersByView[view].indexOf(handler);
			_listenersByView[view].splice(handlerIndex, 1);
			if (_listenersByView[view].length == 0)
			{
				delete _listenersByView[view];
			}
		}
	}
}