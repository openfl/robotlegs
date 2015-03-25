//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewProcessorMap.utils;


import org.swiftsuspenders.utils.CallProxy;
import org.swiftsuspenders.utils.UID;
import robotlegs.bender.framework.api.IInjector;

/**
 * Simple Mediator creation processor
 */
@:keepSub
class MediatorCreator
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _mediatorClass:Class<Dynamic>;

	private var _createdMediatorsByView = new Map<String,Dynamic>();

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * Mediator Creator Processor
	 * @param mediatorClass The mediator class to create
	 */
	public function new(mediatorClass:Class<Dynamic>)
	{
		_mediatorClass = mediatorClass;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function process(view:Dynamic, type:Class<Dynamic>, injector:IInjector):Void
	{
		trace("view = " + view);
		if (_createdMediatorsByView[UID.classID(view)])
		{
			return;
		}
		var mediator:Dynamic = injector.instantiateUnmapped(_mediatorClass);
		_createdMediatorsByView[UID.classID(view)] = mediator;
		initializeMediator(view, mediator);
	}

	/**
	 * @private
	 */
	public function unprocess(view:Dynamic, type:Class<Dynamic>, injector:IInjector):Void
	{
		if (_createdMediatorsByView[UID.classID(view)])
		{
			destroyMediator(_createdMediatorsByView[UID.classID(view)]);
			_createdMediatorsByView.remove(UID.classID(view));
		}
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	private function initializeMediator(view:Dynamic, mediator:Dynamic):Void
	{
		//if ('preInitialize' in mediator)
		if (CallProxy.hasField(mediator, 'preInitialize')) {
			//mediator.preInitialize();
			var preInitialize = Reflect.getProperty(mediator, 'preInitialize');
			if (preInitialize != null) preInitialize();
		}
			
		//if ('viewComponent' in mediator)
		if (CallProxy.hasField(mediator, 'viewComponent'))
			mediator.viewComponent = view;

		//if ('initialize' in mediator)
		if (CallProxy.hasField(mediator, 'initialize'))
			mediator.initialize();

		//if ('postInitialize' in mediator)
		if (CallProxy.hasField(mediator, 'postInitialize'))
			mediator.postInitialize();
	}

	private function destroyMediator(mediator:Dynamic):Void
	{
		//if ('preDestroy' in mediator)
		if (CallProxy.hasField(mediator, 'preDestroy'))
			mediator.preDestroy();

		//if ('destroy' in mediator)
		if (CallProxy.hasField(mediator, 'destroy'))
			mediator.destroy();
		
		//if ('viewComponent' in mediator)
		if (CallProxy.hasField(mediator, 'viewComponent'))
			mediator.viewComponent = null;

		//if ('postDestroy' in mediator)
		if (CallProxy.hasField(mediator, 'postDestroy'))
			mediator.postDestroy();
	}
}