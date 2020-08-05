//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------
package robotlegs.bender.extensions.display.stage3D.starling;

import flash.display.DisplayObjectContainer;
import org.swiftsuspenders.utils.DescribedType;
import robotlegs.bender.extensions.contextView.ContextView;
import robotlegs.bender.extensions.matching.InstanceOfType;
import robotlegs.bender.extensions.display.stage3D.starling.impl.StarlingCollection;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;
import robotlegs.bender.framework.api.ILogger;
import robotlegs.bender.framework.impl.UID;
import starling.core.Starling;
import starling.events.Event;

/**
 * <p>This Extension waits for a DisplayObjectContainer to be added as a configuration,
 * and all Starling view instances defined to be initialized. When all of them are ready,
 * context is initialized. On the other hand losing reference to stage will destroy
 * context.</p>
 *
 * <p>It should be installed before context initialization.</p>
 */
class StarlingStageSyncExtension implements DescribedType implements IExtension {
	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/
	/** Extension UID. **/
	private var _uid:String;

	/** Context being initialized. **/
	private var _context:IContext;

	/** Reference to regular view in Flash display list. **/
	private var _contextView:DisplayObjectContainer;

	/** Logger used to log messaged when using this extension. **/
	private var _logger:ILogger;

	/** Boolean indicating if context view is on stage. **/
	private var _contextReady:Bool;

	/** Collection of Starling view instances. **/
	private var _starlingCollection:StarlingCollection;

	/** Number of Starling instances which are not initialized. **/
	private var _numStarlingsInQueue:Int = 0;

	public function new() {}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/
	/** @inheritDoc **/
	public function extend(context:IContext):Void {
		_uid = UID.create(StarlingStageSyncExtension);

		_context = context;
		_logger = context.getLogger(this);

		_context.addConfigHandler(InstanceOfType.call(StarlingCollection), handleStarlingCollection);
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
	//---------------------------------------------------------------
	// Handling Starling
	//---------------------------------------------------------------

	/**
	 * Initialize all Starling view instances in collection.
	 *
	 * @param collection Collection of Starling view instances used in context.
	 */
	private function handleStarlingCollection(collection:StarlingCollection):Void {
		/*if (_starlingCollection != null)
			{
				_logger.warn('A Starling collection has already been set, ignoring {0}', [collection]);
		}*/
		_starlingCollection = collection;
		_numStarlingsInQueue = collection.length;

		for (s in _starlingCollection.items) {
			var starling:Starling = s;
			handleStarlingContextView(starling);
		}
	}

	/**
	 * Initialize Starling context view.
	 *
	 * @param currentStarling Starling view that needs to be initialized.
	 *
	 */
	private function handleStarlingContextView(currentStarling:Starling):Void {
		if (currentStarling.stage.numChildren > 0) {
			initializeContext();
		} else {
			_logger.debug("Starling context view is not yet on stage. Waiting...");
			currentStarling.addEventListener(starling.events.Event.CONTEXT3D_CREATE, onContextCreated);
		}
	}

	/**
	 * Context view is ready so try to initialize context.
	 *
	 * @param event Context created for Starling view.
	 *
	 */
	private function onContextCreated(event:starling.events.Event):Void {
		_logger.debug("Starling context view added on stage.");
		_numStarlingsInQueue--;

		initializeContext();
	}

	//---------------------------------------------------------------
	// Initialization
	//---------------------------------------------------------------

	/**
	 * Initialize context if default context view is ready and if
	 * all Starling view instances have their context prepared.
	 */
	private function initializeContext():Void {
		// if all views are not on stage, postpone initialization
		if (_numStarlingsInQueue > 0)
			return;

		_logger.debug("Default and Starling context views are now on stage. Initializing context...");
		_context.initialize();
	}
}
