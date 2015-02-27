//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewProcessorMap.utils;


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

	private var _mediatorClass:Class;

	private var _createdMediatorsByView:Map<Dynamic,Dynamic> = new Map<Dynamic,Dynamic>(true);

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * Mediator Creator Processor
	 * @param mediatorClass The mediator class to create
	 */
	public function new(mediatorClass:Class)
	{
		_mediatorClass = mediatorClass;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function process(view:Dynamic, type:Class, injector:IInjector):Void
	{
		if (_createdMediatorsByView[view])
		{
			return;
		}
		var mediator:Dynamic = injector.instantiateUnmapped(_mediatorClass);
		_createdMediatorsByView[view] = mediator;
		initializeMediator(view, mediator);
	}

	/**
	 * @private
	 */
	public function unprocess(view:Dynamic, type:Class, injector:IInjector):Void
	{
		if (_createdMediatorsByView[view])
		{
			destroyMediator(_createdMediatorsByView[view]);
			_createdMediatorsByView.remove(view);
		}
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	private function initializeMediator(view:Dynamic, mediator:Dynamic):Void
	{
		if ('preInitialize' in mediator)
			mediator.preInitialize();

		if ('viewComponent' in mediator)
			mediator.viewComponent = view;

		if ('initialize' in mediator)
			mediator.initialize();

		if ('postInitialize' in mediator)
			mediator.postInitialize();
	}

	private function destroyMediator(mediator:Dynamic):Void
	{
		if ('preDestroy' in mediator)
			mediator.preDestroy();

		if ('destroy' in mediator)
			mediator.destroy();

		if ('viewComponent' in mediator)
			mediator.viewComponent = null;

		if ('postDestroy' in mediator)
			mediator.postDestroy();
	}
}