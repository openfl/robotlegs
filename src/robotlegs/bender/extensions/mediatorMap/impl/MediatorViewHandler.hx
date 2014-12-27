//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl;

import openfl.display.DisplayObject;

import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;
import robotlegs.bender.extensions.viewManager.api.IViewHandler;

/**
 * @private
 */
class MediatorViewHandler implements IViewHandler
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _mappings:Array<Dynamic> = [];

	private var _knownMappings = new Map<String,Dynamic>();

	private var _factory:MediatorFactory;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function new(factory:MediatorFactory):Void
	{
		_factory = factory;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function addMapping(mapping:IMediatorMapping):Void
	{
		var index:Int = _mappings.indexOf(mapping);
		if (index > -1)
			return;
		_mappings.push(mapping);
		flushCache();
	}

	/**
	 * @private
	 */
	public function removeMapping(mapping:IMediatorMapping):Void
	{
		var index:Int = _mappings.indexOf(mapping);
		if (index == -1)
			return;
		_mappings.splice(index, 1);
		flushCache();
	}

	/**
	 * @private
	 */
	public function handleView(view:DisplayObject, type:Class<Dynamic>):Void
	{
		var interestedMappings:Array<Dynamic> = getInterestedMappingsFor(view, type);
		if (interestedMappings != null)
			_factory.createMediators(view, type, interestedMappings);
	}

	/**
	 * @private
	 */
	public function handleItem(item:Dynamic, type:Class<Dynamic>):Void
	{
		var interestedMappings:Array<Dynamic> = getInterestedMappingsFor(item, type);
		if (interestedMappings != null)
			_factory.createMediators(item, type, interestedMappings);
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	private function flushCache():Void
	{
		_knownMappings = new Map<String,Dynamic>();
	}

	private function getInterestedMappingsFor(item:Dynamic, type:Class<Dynamic>):Array<Dynamic>
	{
		var mapping:IMediatorMapping;

		// we've seen this type before and nobody was interested
		if (_knownMappings[UID.create(type)] == false)
			return null;

		// we haven't seen this type before
		// CHECK null
		//if (_knownMappings[UID.create(type)] == undefined)
		if (_knownMappings[UID.create(type)] == null)
		{
			_knownMappings[UID.create(type)] = false;
			for (mapping in _mappings)
			{
				if (mapping.matcher.matches(item))
				{
					// CHECK
					if (_knownMappings[UID.create(type)] == null) _knownMappings[UID.create(type)] = [];
					
					//_knownMappings[UID.create(type)] ||= [];
					_knownMappings[UID.create(type)].push(mapping);
				}
			}
			// nobody cares, let's get out of here
			if (_knownMappings[UID.create(type)] == false)
				return null;
		}

		// these mappings really do care
		return cast(_knownMappings[UID.create(type)], Array<Dynamic>);
	}
}