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
		var _mediatorsItem:Map<IMediatorMapping,Dynamic>;
		if (_mediators[id] != null) {
			_mediators[id] = new Map<String,Dynamic>();
			
		}
		
		return _mediators[id];
		
		/////////////////////
		
		if (_mediators[id] != null) {
			_mediatorsItem = _mediators[id];
			return _mediatorsItem[mapping];
		}
		/////////////////////
		
		/*if (_mediators[UID.classID(item)] != null) {
			return _mediators[UID.classID(item)][mapping];
		}*/
		return null;
		
		//return _mediators[UID.classID(item)] ? _mediators[UID.classID(item)][mapping]:null;
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
		var mediators:Map<String,Dynamic> = _mediators[UID.classID(item)];
		if (mediators == null)
			return;

		for (mapping in mediators)
		{
			_manager.removeMediator(mediators[mapping], item, cast(mapping, IMediatorMapping));
		}

		_mediators.remove(item);
	}

	/**
	 * @private
	 */
	public function removeAllMediators():Void
	{
		for (item in _mediators)
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
		// CHECK
		/*if (_mediators[UID.classID(item)] == null) _mediators[UID.classID(item)] = new Map<Dynamic,Dynamic>();
		
		//_mediators[UID.classID(item)] ||= new Map<Dynamic,Dynamic>();
		_mediators[UID.classID(item)][mapping] = mediator;
		_manager.addMediator(mediator, item, mapping);*/
		
		var id = UID.instanceID(item);
		var _mediatorsItem:Map<IMediatorMapping,Dynamic>;
		if (_mediators[id] == null) _mediatorsItem = new Map<IMediatorMapping,Dynamic>();
		else _mediatorsItem = _mediators[id];
		_mediatorsItem[mapping] = mediator;
		
		_mediators[id] = _mediatorsItem[mapping];
		
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