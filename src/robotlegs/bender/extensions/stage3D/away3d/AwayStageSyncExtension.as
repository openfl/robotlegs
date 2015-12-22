//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved.
// 


//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.stage3D.away3d
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import robotlegs.bender.extensions.matching.instanceOfType;
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;
	import robotlegs.bender.framework.api.ILogger;
	import robotlegs.bender.framework.impl.UID;

	/**
	 * <p>This Extension waits for a DisplayObjectContainer to be added as a configuration,
	 * and all Starling view instances defined to be initialized. When all of them are ready,
	 * context is initialized. On the other hand losing reference to stage will destroy
	 * context.</p>
	 *
	 * <p>It should be installed before context initialization.</p>
	 */
	public class AwayStageSyncExtension implements IExtension
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		/** Extension UID. **/
		private const _uid:String = UID.create(AwayStageSyncExtension);

		/** Context being initialized. **/
		private var _context:IContext;

		/** Reference to regular view in Flash display list. **/
		private var _contextView:DisplayObjectContainer;

		/** Logger used to log messaged when using this extension. **/
		private var _logger:ILogger;
		
		public function AwayStageSyncExtension() { }
		
		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/** @inheritDoc **/
		public function extend(context:IContext):void
		{
			trace("AwayStageSyncExtension");
			_context = context;
			_logger = context.getLogger(this);
			
			_context.addConfigHandler(instanceOfType(ContextView), handleContextView);
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
		 * Initialize context view.
		 *
		 * @param contextView View being set as context view.
		 */
		private function handleContextView(contextView:ContextView):void
		{
			if (_contextView)
			{
				_logger.warn('A contextView has already been set, ignoring {0}', [contextView.view]);
				return;
			}
			_contextView = contextView.view;
			if (_contextView.stage)
			{
				initializeContext();
			}
			else
			{
				_logger.debug("Context view is not yet on stage. Waiting...");
				_contextView.addEventListener(flash.events.Event.ADDED_TO_STAGE, onAddedToStage);
			}
		}

		/**
		 * Context view is ready so try to initialize context.
		 *
		 * @param event View has been added to stage.
		 */
		private function onAddedToStage(event:flash.events.Event):void
		{
			_logger.debug("Context view added on stage.");
			_contextView.removeEventListener(flash.events.Event.ADDED_TO_STAGE, onAddedToStage);
			_contextView.addEventListener(flash.events.Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			initializeContext();
		}

		/**
		 * Context view doesn't have reference to stage, so destroy the context.
		 *
		 * @param event View has been removed from stage.
		 */
		private function onRemovedFromStage(event:flash.events.Event):void
		{
			_logger.debug("Context view has left the stage. Destroying context...");
			_contextView.removeEventListener(flash.events.Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			_context.destroy();
		}
		
		//---------------------------------------------------------------
		// Initialization
		//---------------------------------------------------------------

		/**
		 * Initialize context if default context view is ready and if
		 * all Starling view instances have their context prepared.
		 */
		private function initializeContext():void
		{
			_logger.debug("Away3D context views are now on stage. Initializing context...");
			_context.initialize();
		}
	}
}
