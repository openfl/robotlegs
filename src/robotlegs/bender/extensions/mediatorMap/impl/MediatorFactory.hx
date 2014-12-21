//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl;

import openfl.utils.Dictionary;
import robotlegs.bender.extensions.matching.ITypeFilter;
import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;
import robotlegs.bender.framework.api.IInjector;
import robotlegs.bender.framework.impl.ApplyHooks;
import robotlegs.bender.framework.impl.GuardsApprove;

/**
 * @private
 */
class MediatorFactory
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _mediators:Dictionary = new Dictionary();

	private var _injector:IInjector;

	private var _manager:MediatorManager;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function new(injector:IInjector, manager:MediatorManager = null)
	{
		_injector = injector;
		_manager = manager || new MediatorManager(this);
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function getMediator(item:Dynamic, mapping:IMediatorMapping):Dynamic
	{
		return _mediators[item] ? _mediators[item][mapping]:null;
	}

	/**
	 * @private
	 */
	public function createMediators(item:Dynamic, type:Class, mappings:Array<Dynamic>):Array
	{
		var createdMediators:Array<Dynamic> = [];
		var mediator:Dynamic;
		for each (var mapping:IMediatorMapping in mappings)
		{
			mediator = getMediator(item, mapping);

			if (mediator == null)
			{
				mapTypeForFilterBinding(mapping.matcher, type, item);
				mediator = createMediator(item, mapping);
				unmapTypeForFilterBinding(mapping.matcher, type, item)
			}

			if (mediator)
				createdMediators.push(mediator);
		}
		return createdMediators;
	}

	/**
	 * @private
	 */
	public function removeMediators(item:Dynamic):Void
	{
		var mediators:Dictionary = _mediators[item];
		if (mediators == null)
			return;

		for (var mapping:Dynamic in mediators)
		{
			_manager.removeMediator(mediators[mapping], item, mapping as IMediatorMapping);
		}

		delete _mediators[item];
	}

	/**
	 * @private
	 */
	public function removeAllMediators():Void
	{
		for (var item:Dynamic in _mediators)
		{
			removeMediators(item);
		}
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	private function createMediator(item:Dynamic, mapping:IMediatorMapping):Dynamic
	{
		var mediator:Dynamic = getMediator(item, mapping);

		if (mediator)
			return mediator;

		if (mapping.guards.length == 0 || GuardsApprove.call(mapping.guards, _injector))
		{
			var mediatorClass:Class = mapping.mediatorClass;
			mediator = _injector.instantiateUnmapped(mediatorClass);
			if (mapping.hooks.length > 0)
			{
				_injector.map(mediatorClass).toValue(mediator);
				ApplyHooks(mapping.hooks, _injector);
				_injector.unmap(mediatorClass);
			}
			addMediator(mediator, item, mapping);
		}
		return mediator;
	}

	private function addMediator(mediator:Dynamic, item:Dynamic, mapping:IMediatorMapping):Void
	{
		_mediators[item] ||= new Dictionary();
		_mediators[item][mapping] = mediator;
		_manager.addMediator(mediator, item, mapping);
	}

	private function mapTypeForFilterBinding(filter:ITypeFilter, type:Class, item:Dynamic):Void
	{
		for each (var requiredType:Class in requiredTypesFor(filter, type))
		{
			_injector.map(requiredType).toValue(item);
		}
	}

	private function unmapTypeForFilterBinding(filter:ITypeFilter, type:Class, item:Dynamic):Void
	{
		for each (var requiredType:Class in requiredTypesFor(filter, type))
		{
			if (_injector.satisfiesDirectly(requiredType))
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
}