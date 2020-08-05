//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------
package robotlegs.bender.extensions.display.stage3D.away3d;

import away3d.containers.View3D;
import robotlegs.bender.extensions.contextView.ContextView;
import robotlegs.bender.extensions.matching.InstanceOfType;
import robotlegs.bender.extensions.display.stage3D.away3d.impl.AwayCollection;
import robotlegs.bender.extensions.display.stage3D.away3d.api.IAway3DViewMap;
import robotlegs.bender.extensions.display.stage3D.away3d.impl.Away3DInitializer;
import robotlegs.bender.extensions.display.stage3D.away3d.impl.Away3DViewMap;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;
import robotlegs.bender.framework.api.ILogger;
import robotlegs.bender.framework.impl.UID;

/**
 * <p>This Extension will map all Starling view instances and View3D instance in
 * injector as well as create view maps for automatic mediation when instances are
 * added on stage/scene.</p>
 */
@:keepSub
class AwayIntegrationExtension implements IExtension {
	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/
	/** Extension UID. **/
	private var _uid:String;

	/** Context being initialized. **/
	private var _context:IContext;

	/** Logger used to log messaged when using this extension. **/
	private var _logger:ILogger;

	public function AwayIntegrationExtension() {}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/
	/** @inheritDoc **/
	public function extend(context:IContext):Void {
		_uid = UID.create(AwayIntegrationExtension);

		_context = context;
		_logger = context.getLogger(this);

		_context.addConfigHandler(InstanceOfType.call(AwayCollection), handleAwayCollection);
	}

	/**
	 * Returns the string representation of the specified object.
	 */
	public function toString():String {
		return _uid;
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/
	/**
	 * Map View3D instance to injector and map and initialize Away3D view map
	 * which will mediate display instances.
	 *
	 * @param view3D View3D instance which will be used in context.
	 */
	private function handleAwayCollection(awayCollection:AwayCollection):Void {
		_logger.debug("Mapping provided View3D as Away3D contextView...");
		_context.injector.map(AwayCollection).toValue(awayCollection);

		var key:String;
		for (key in awayCollection.items) {
			var view3D = awayCollection.items[key];
			_context.injector.map(View3D, key).toValue(view3D);
		}

		_context.injector.map(IAway3DViewMap).toSingleton(Away3DViewMap);
		_context.injector.getInstance(IAway3DViewMap);
	}
}
