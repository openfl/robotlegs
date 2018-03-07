//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved.
// 


//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------
package robotlegs.bender.extensions.display.stage3D.fuse;

import flash.display.DisplayObjectContainer;
import fuse.Fuse;
import openfl.events.Event;
import robotlegs.bender.extensions.contextView.ContextView;
import robotlegs.bender.extensions.matching.InstanceOfType;
import robotlegs.bender.extensions.display.stage3D.fuse.impl.FuseCollection;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;
import robotlegs.bender.framework.api.ILogger;
import robotlegs.bender.framework.impl.UID;

/**
 * <p>This Extension waits for a DisplayObjectContainer to be added as a configuration,
 * and all Fuse view instances defined to be initialized. When all of them are ready,
 * context is initialized. On the other hand losing reference to stage will destroy
 * context.</p>
 *
 * <p>It should be installed before context initialization.</p>
 */
@:rtti
@:keepSub
class FuseStageSyncExtension implements IExtension
{

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

	/** Collection of Fuse view instances. **/
	private var _fuseCollection:FuseCollection;

	/** Number of Fuse instances which are not initialized. **/
	private var _numFusesInQueue:Int = 0;
	
	public function new() { }
	
	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/** @inheritDoc **/
	public function extend(context:IContext):Void
	{
		_uid = UID.create(FuseStageSyncExtension);
		
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

	//---------------------------------------------------------------
	// Handling Fuse
	//---------------------------------------------------------------

	/**
	 * Initialize all Fuse view instances in collection.
	 *
	 * @param collection Collection of Fuse view instances used in context.
	 */
	private function handleFuseCollection(collection:FuseCollection):Void
	{
		/*if (_fuseCollection != null)
		{
			_logger.warn('A Fuse collection has already been set, ignoring {0}', [collection]);
		}*/
		_fuseCollection = collection;
		_numFusesInQueue = collection.length;
		
		for (s in _fuseCollection.items)
		{
			var fuse:Fuse = s;
			handleFuseContextView(fuse);
		}
	}

	/**
	 * Initialize Fuse context view.
	 *
	 * @param currentFuse Fuse view that needs to be initialized.
	 *
	 */
	private function handleFuseContextView(currentFuse:Fuse):Void
	{
		//trace("FIX");
		/*if (currentFuse.stage.numChildren > 0)
		{
			initializeContext();
		}
		else
		{
			_logger.debug("Fuse context view is not yet on stage. Waiting...");
			currentFuse.addEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
		}*/
	}

	/**
	 * Context view is ready so try to initialize context.
	 *
	 * @param event Context created for Fuse view.
	 *
	 */
	private function onContextCreated(event:Event):Void
	{
		_logger.debug("Fuse context view added on stage.");
		_numFusesInQueue--;

		initializeContext();
	}

	//---------------------------------------------------------------
	// Initialization
	//---------------------------------------------------------------

	/**
	 * Initialize context if default context view is ready and if
	 * all Fuse view instances have their context prepared.
	 */
	private function initializeContext():Void
	{
		// if all views are not on stage, postpone initialization
		if (_numFusesInQueue > 0)
			return;

		_logger.debug("Default and Fuse context views are now on stage. Initializing context...");
		_context.initialize();
	}
}