//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewProcessorMap.impl;


import robotlegs.bender.extensions.viewProcessorMap.dsl.IViewProcessorMapping;

/**
 * @private
 */
class ViewProcessorViewHandler implements IViewProcessorViewHandler
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _mappings:Array<Dynamic> = [];

	private var _knownMappings = new Map<String,Dynamic>();

	private var _factory:IViewProcessorFactory;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function new(factory:IViewProcessorFactory):Void
	{
		_factory = factory;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @inheritDoc
	 */
	public function addMapping(mapping:IViewProcessorMapping):Void
	{
		var index:Int = _mappings.indexOf(mapping);
		if (index > -1)
			return;
		_mappings.push(mapping);
		flushCache();
	}

	/**
	 * @inheritDoc
	 */
	public function removeMapping(mapping:IViewProcessorMapping):Void
	{
		var index:Int = _mappings.indexOf(mapping);
		if (index == -1)
			return;
		_mappings.splice(index, 1);
		flushCache();
	}

	/**
	 * @inheritDoc
	 */
	public function processItem(item:Dynamic, type:Class<Dynamic>):Void
	{
		var interestedMappings:Array<Dynamic> = getInterestedMappingsFor(item, type);
		if (interestedMappings != null)
			_factory.runProcessors(item, type, interestedMappings);
	}

	/**
	 * @inheritDoc
	 */
	public function unprocessItem(item:Dynamic, type:Class<Dynamic>):Void
	{
		var interestedMappings:Array<Dynamic> = getInterestedMappingsFor(item, type);
		if (interestedMappings != null)
			_factory.runUnprocessors(item, type, interestedMappings);
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	private function flushCache():Void
	{
		_knownMappings = new Map<String,Dynamic>();
	}

	private function getInterestedMappingsFor(view:Dynamic, type:Class<Dynamic>):Array<Dynamic>
	{
		var mapping:IViewProcessorMapping;

		// we've seen this type before and nobody was interested
		if (_knownMappings[UID.create(type)] == false)
			return null;

		// we haven't seen this type before
		// CHECK
		//if (_knownMappings[UID.create(type)] == undefined)
		if (_knownMappings[UID.create(type)] == null)
		{
			_knownMappings[UID.create(type)] = false;
			for (mapping in _mappings)
			{
				if (mapping.matcher.matches(view))
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