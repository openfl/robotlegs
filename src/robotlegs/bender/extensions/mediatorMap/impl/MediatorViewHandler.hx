//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl;

import org.swiftsuspenders.utils.UID;

import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;
import robotlegs.bender.extensions.viewManager.api.IViewHandler;

/**
 * @private
 */

@:keepSub
class MediatorViewHandler implements IViewHandler
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _mappings:Array<Dynamic> = [];

	private var _knownMappings = new Map<String,Array<IMediatorMapping>>();

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
	public function handleView(view:Dynamic, type:Class<Dynamic>):Void
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
		_knownMappings = new Map<String,Array<IMediatorMapping>>();
	}

	private function getInterestedMappingsFor(item:Dynamic, type:Class<Dynamic>):Array<IMediatorMapping>
	{
		var mapping:IMediatorMapping;
		var typeID = UID.classID(type);
		
		// we've seen this type before and nobody was interested
		if (_knownMappings.exists(typeID) && _knownMappings.get(typeID).length == 0)
			return null;

		// we haven't seen this type before
		if (!_knownMappings.exists(typeID))
		{
			_knownMappings.set(typeID, []);
			for (i in 0..._mappings.length)
			{
				mapping = _mappings[i];
				if (mapping.matcher.matches(item))
				{
					_knownMappings.get(typeID).push(mapping);
				}
			}
			// nobody cares, let's get out of here
			if (_knownMappings.get(typeID).length == 0)
				return null;
		}

		// these mappings really do care
		return _knownMappings.get(typeID);
	}
}