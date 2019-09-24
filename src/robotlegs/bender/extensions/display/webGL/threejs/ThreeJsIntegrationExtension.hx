//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------
package robotlegs.bender.extensions.display.webGL.threejs;

import org.swiftsuspenders.utils.DescribedType;
import robotlegs.bender.extensions.matching.InstanceOfType;
import robotlegs.bender.extensions.display.webGL.threejs.api.IThreeJsViewMap;
import robotlegs.bender.extensions.display.webGL.threejs.impl.ThreeJsCollection;
import robotlegs.bender.extensions.display.webGL.threejs.impl.ThreeJsInitializer;
import robotlegs.bender.extensions.display.webGL.threejs.impl.ThreeJsViewMap;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;
import robotlegs.bender.framework.api.ILogger;
import robotlegs.bender.framework.impl.UID;

/**
 * <p>This Extension will map all Starling view instances and View3D instance in
 * injector as well as create view maps for automatic mediation when instances are
 * added on stage/scene.</p>
 */
class ThreeJsIntegrationExtension implements DescribedType implements IExtension {
	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/
	/** Extension UID. **/
	private var _uid:String;

	/** Context being initialized. **/
	private var _context:IContext;

	/** Logger used to log messaged when using this extension. **/
	private var _logger:ILogger;

	public function new() {}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/
	/** @inheritDoc **/
	public function extend(context:IContext):Void {
		_uid = UID.create(ThreeJsIntegrationExtension);

		_context = context;
		_logger = context.getLogger(this);

		_context.addConfigHandler(InstanceOfType.call(ThreeJsCollection), handleThreeJsCollection);
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
	 * Map all ThreeJs view instances to injector with their defined name and map
	 * and initialize ThreeJs view map which will mediate display instances.
	 *
	 * @param collection Collection of ThreeJs view instances used in context.
	 */
	private function handleThreeJsCollection(threeJsCollection:ThreeJsCollection):Void {
		_logger.debug("Mapping provided ThreeJs instances...");
		_context.injector.map(ThreeJsCollection).toValue(threeJsCollection);

		for (view in threeJsCollection.view3Ds) {
			ApplyThreePatch.execute(view.scene);
		}

		/*var items = threeJsCollection.items;
			for (key in items.keys())
			{
				var starling:Starling = threeJsCollection.getItem(key);
				_context.injector.map(DisplayObjectContainer, key).toValue(starling.stage);
			}
		 */
		_context.injector.map(IThreeJsViewMap).toSingleton(ThreeJsViewMap);
		_context.injector.getInstance(IThreeJsViewMap);
	}
}
