//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl;


import org.swiftsuspenders.utils.UID;
import robotlegs.bender.extensions.matching.ITypeFilter;
import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;
import robotlegs.bender.framework.api.IInjector;
import robotlegs.bender.framework.impl.ApplyHooks;
import robotlegs.bender.framework.impl.GuardsApprove;

/**
 * @private
 */

@:keepSub
class MediatorFactory
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _mediators = new Map<String,Dynamic>();

	private var _items = new Map<String,Dynamic>();

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
		if (manager != null) _manager = manager;
		else _manager = new MediatorManager(this);
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function getMediator(item:Dynamic, mapping:IMediatorMapping):Dynamic
	{
		var id = UID.instanceID(item);
		if (_mediators[id] != null) {
			var _mediatorsItem:Map<IMediatorMapping,Dynamic> = _mediators[id];
			return _mediatorsItem[mapping];
		}
		return null;
	}

	/**
	 * @private
	 */
	public function createMediators(item:Dynamic, type:Class<Dynamic>, mappings:Array<Dynamic>):Array<Dynamic>
	{
		var createdMediators:Array<Dynamic> = [];
		var mediator:Dynamic;
		for (mapping in mappings)
		{
			mediator = getMediator(item, mapping);
			if (mediator == null)
			{
				mapTypeForFilterBinding(mapping.matcher, type, item);
				mediator = createMediator(item, mapping);
				unmapTypeForFilterBinding(mapping.matcher, type, item);
			}

			if (mediator) {
				createdMediators.push(mediator);
			}
		}
		return createdMediators;
	}

	/**
	 * @private
	 */
	public function removeMediators(item:Dynamic):Void
	{
		var id = UID.clearInstanceID(item);
		_removeMediators(id);
	}

	private function _removeMediators(id:String):Void
	{
		var _mediatorsItem:Map<IMediatorMapping,Dynamic> = _mediators[id];
		if (_mediatorsItem == null)
			return;

		for (mapping in _mediatorsItem.keys())
		{
			_manager.removeMediator(_mediatorsItem[mapping], _items[id], cast(mapping, IMediatorMapping));
		}

		_mediators.remove(id);
		_items.remove(id);
	}

	/**
	 * @private
	 */
	public function removeAllMediators():Void
	{
		for (id in _mediators.keys())
		{
			_removeMediators(id);
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
			var mediatorClass:Class<Dynamic> = mapping.mediatorClass;
			mediator = _injector.instantiateUnmapped(mediatorClass);
			if (mapping.hooks.length > 0)
			{
				_injector.map(mediatorClass).toValue(mediator);
				ApplyHooks.call(mapping.hooks, _injector);
				_injector.unmap(mediatorClass);
			}
			addMediator(mediator, item, mapping);
		}
		return mediator;
	}

	private function addMediator(mediator:Dynamic, item:Dynamic, mapping:IMediatorMapping):Void
	{
		var id = UID.instanceID(item);
		if (_mediators[id] == null) {
			_mediators[id] = new Map<IMediatorMapping,Dynamic>();
			_items[id] = item;
		}
		var _mediatorsItem:Map<IMediatorMapping,Dynamic> = _mediators[id];
		_mediatorsItem[mapping] = mediator;
		
		_manager.addMediator(mediator, item, mapping);
	}

	private function mapTypeForFilterBinding(filter:ITypeFilter, type:Class<Dynamic>, item:Dynamic):Void
	{
		for (requiredType in requiredTypesFor(filter, type))
		{
			_injector.map(requiredType).toValue(item);
		}
	}

	private function unmapTypeForFilterBinding(filter:ITypeFilter, type:Class<Dynamic>, item:Dynamic):Void
	{
		for (requiredType in requiredTypesFor(filter, type))
		{
			if (_injector.satisfiesDirectly(requiredType))
				_injector.unmap(requiredType);
		}
	}

	private function requiredTypesFor(filter:ITypeFilter, type:Class<Dynamic>):Array<Class<Dynamic>>
	{
		var requiredTypes:Array<Class<Dynamic>> = filter.allOfTypes.concat(filter.anyOfTypes);

		if (requiredTypes.indexOf(type) == -1)
			requiredTypes.push(type);

		return requiredTypes;
	}
}