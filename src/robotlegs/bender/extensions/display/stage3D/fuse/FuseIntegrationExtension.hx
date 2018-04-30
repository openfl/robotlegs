//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
// 

//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------
package robotlegs.bender.extensions.display.stage3D.fuse;

import fuse.Fuse;
import fuse.display.DisplayObject;
import org.swiftsuspenders.utils.DescribedType;
import robotlegs.bender.extensions.display.stage3D.fuse.api.IFuseViewMap;
import robotlegs.bender.extensions.display.stage3D.fuse.impl.FuseCollection;
import robotlegs.bender.extensions.display.stage3D.fuse.impl.FuseViewMap;
import robotlegs.bender.extensions.matching.InstanceOfType;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;
import robotlegs.bender.framework.api.ILogger;
import robotlegs.bender.framework.impl.UID;

/**
 * <p>This Extension will map all Fuse view instances and View3D instance in
 * injector as well as create view maps for automatic mediation when instances are
 * added on stage/scene.</p>
 */
class FuseIntegrationExtension extends DescribedType implements IExtension
{
	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	/** Extension UID. **/
	private var _uid:String;

	/** Context being initialized. **/
	private var _context:IContext;

	/** Logger used to log messaged when using this extension. **/
	private var _logger:ILogger;
	
	public function new() { }
	
	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/** @inheritDoc **/
	public function extend(context:IContext):Void
	{
		_uid = UID.create(FuseIntegrationExtension);
		
		_context = context;
		_logger = context.getLogger(this);
		
		
		_context.addConfigHandler(InstanceOfType.call(FuseCollection), handleFuseCollection);
	}

	/**
	 * Returns the string representation of the specified object.
	 */
	public function toString():String
	{
		return _uid;
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	/**
	 * Map all Fuse view instances to injector with their defined name and map
	 * and initialize Fuse view map which will mediate display instances.
	 *
	 * @param collection Collection of Fuse view instances used in context.
	 */
	private function handleFuseCollection(fuseCollection:FuseCollection):Void
	{
		_logger.debug("Mapping provided Fuse instances...");
		_context.injector.map(FuseCollection).toValue(fuseCollection);
		
		var items = fuseCollection.items;
		for (key in items.keys())
		{
			var fuse:Fuse = fuseCollection.getItem(key);
			_context.injector.map(DisplayObject, key).toValue(fuse.stage);
		}
		
		_context.injector.map(IFuseViewMap).toSingleton(FuseViewMap);
		_context.injector.getInstance(IFuseViewMap);
	}
}