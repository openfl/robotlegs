//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------
package robotlegs.bender.extensions.viewProcessorMap.impl;

import openfl.display.DisplayObject;
import polyfill.events.Event;
import org.swiftsuspenders.errors.InjectorInterfaceConstructionError;
import org.swiftsuspenders.utils.UID;
// import org.swiftsuspenders.errors.InjectorInterfaceConstructionError;
import robotlegs.bender.extensions.matching.ITypeFilter;
import robotlegs.bender.extensions.viewProcessorMap.api.ViewProcessorMapError;
import robotlegs.bender.extensions.viewProcessorMap.dsl.IViewProcessorMapping;
import robotlegs.bender.framework.api.IInjector;
import robotlegs.bender.framework.impl.ApplyHooks;
import robotlegs.bender.framework.impl.GuardsApprove;

/**
 * @private
 */
@:keepSub
class ViewProcessorFactory implements IViewProcessorFactory {
	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/
	private var _injector:IInjector;

	private var _listenersByView = new Map<String, Dynamic>();

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/
	/**
	 * @private
	 */
	public function new(injector:IInjector) {
		_injector = injector;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/
	/**
	 * @inheritDoc
	 */
	public function runProcessors(view:Dynamic, type:Class<Dynamic>, processorMappings:Array<Dynamic>):Void {
		createRemovedListener(view, type, processorMappings);

		var filter:ITypeFilter;

		for (mapping in processorMappings) {
			filter = mapping.matcher;
			mapTypeForFilterBinding(filter, type, view);
			runProcess(view, type, mapping);
			unmapTypeForFilterBinding(filter, type, view);
		}
	}

	/**
	 * @inheritDoc
	 */
	public function runUnprocessors(view:Dynamic, type:Class<Dynamic>, processorMappings:Array<Dynamic>):Void {
		for (mapping in processorMappings) {
			// ?? Is this correct - will assume that people are implementing something sensible in their processors.
			// CHECK
			if (mapping.processor == null) {
				mapping.processor = createProcessor(mapping.processorClass);
			}
			// mapping.processor ||= createProcessor(mapping.processorClass);
			mapping.processor.unprocess(view, type, _injector);
		}
	}

	/**
	 * @inheritDoc
	 */
	public function runAllUnprocessors():Void {
		for (removalHandlers in _listenersByView) {
			var removalHandlers2 = cast(removalHandlers, Array<Dynamic>);
			var iLength:UInt = removalHandlers2.length;
			for (i in 0...iLength) {
				if (Reflect.isFunction(removalHandlers2[i])) {
					var removalHandler = removalHandlers2[i];
					removalHandler(null);
				}
			}
		}
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/
	private function runProcess(view:Dynamic, type:Class<Dynamic>, mapping:IViewProcessorMapping):Void {
		if (GuardsApprove.call(mapping.guards, _injector)) {
			// CHECK
			if (mapping.processor == null) {
				mapping.processor = createProcessor(mapping.processorClass);
			}
			// mapping.processor ||= createProcessor(mapping.processorClass);
			ApplyHooks.call(mapping.hooks, _injector);
			mapping.processor.process(view, type, _injector);
		}
	}

	private function createProcessor(processorClass:Class<Dynamic>):Dynamic {
		if (_injector.hasMapping(processorClass) == false) {
			_injector.map(processorClass).asSingleton();
		}

		try {
			return _injector.getInstance(processorClass);
		} catch (error:InjectorInterfaceConstructionError) {
			var errorMsg:String = "The view processor " + processorClass + " has not been mapped in the injector, "
				+ "and it is not possible to instantiate an interface. " + "Please map a concrete type against this interface.";
			throw(new ViewProcessorMapError(errorMsg));
		}
		return null;
	}

	private function mapTypeForFilterBinding(filter:ITypeFilter, type:Class<Dynamic>, view:Dynamic):Void {
		var requiredType:Class<Dynamic>;
		var requiredTypes:Array<Class<Dynamic>> = requiredTypesFor(filter, type);

		for (requiredType in requiredTypes) {
			_injector.map(requiredType).toValue(view);
		}
	}

	private function unmapTypeForFilterBinding(filter:ITypeFilter, type:Class<Dynamic>, view:Dynamic):Void {
		var requiredType:Class<Dynamic>;
		var requiredTypes:Array<Class<Dynamic>> = requiredTypesFor(filter, type);

		for (requiredType in requiredTypes) {
			if (_injector.hasDirectMapping(requiredType))
				_injector.unmap(requiredType);
		}
	}

	private function requiredTypesFor(filter:ITypeFilter, type:Class<Dynamic>):Array<Class<Dynamic>> {
		var requiredTypes:Array<Class<Dynamic>> = filter.allOfTypes.concat(filter.anyOfTypes);

		if (requiredTypes.indexOf(type) == -1)
			requiredTypes.push(type);

		return requiredTypes;
	}

	private function createRemovedListener(view:Dynamic, type:Class<Dynamic>, processorMappings:Array<Dynamic>):Void {
		var viewProcessorFactoryCreateRemovedListener:ViewProcessorFactoryCreateRemovedListener = new ViewProcessorFactoryCreateRemovedListener();
		viewProcessorFactoryCreateRemovedListener.init(_listenersByView, runUnprocessors, removeHandlerFromView, view, type, processorMappings);
	}

	private function removeHandlerFromView(view:Dynamic, handler:Void->Void):Void {
		if (_listenersByView[UID.instanceID(view)] && (_listenersByView[UID.instanceID(view)].length > 0)) {
			var handlerIndex:UInt = _listenersByView[UID.instanceID(view)].indexOf(handler);
			_listenersByView[UID.instanceID(view)].splice(handlerIndex, 1);
			if (_listenersByView[UID.instanceID(view)].length == 0) {
				_listenersByView.remove(UID.instanceID(view));
			}
		}
	}
}

@:keepSub
class ViewProcessorFactoryCreateRemovedListener {
	var _listenersByView:Map<String, Dynamic>;
	var view:Dynamic;
	var type:Class<Dynamic>;
	var processorMappings:Array<Dynamic>;
	var runUnprocessors:Dynamic->Class<Dynamic>->Array<Dynamic>->Void;
	var removeHandlerFromView:Dynamic->Dynamic->Void;

	public function new() {}

	public function init(_listenersByView:Map<String, Dynamic>, runUnprocessors:Dynamic->Class<Dynamic>->Array<Dynamic>->Void,
			removeHandlerFromView:Dynamic->Dynamic->Void, view:Dynamic, type:Class<Dynamic>, processorMappings:Array<Dynamic>) {
		this.removeHandlerFromView = removeHandlerFromView;
		this.runUnprocessors = runUnprocessors;
		this.processorMappings = processorMappings;
		this.type = type;
		this.view = view;
		this._listenersByView = _listenersByView;

		if (Std.isOfType(view, DisplayObject)) {
			// CHECK
			if (_listenersByView[UID.instanceID(view)] == null)
				_listenersByView[UID.instanceID(view)] = [];
			// _listenersByView[view] ||= [];

			_listenersByView[UID.instanceID(view)].push(handler);
			cast(view, DisplayObject).addEventListener(Event.REMOVED_FROM_STAGE, handler, false, 0, true);
		}
	}

	private function handler(e:Event):Void {
		runUnprocessors(view, type, processorMappings);
		cast(view, DisplayObject).removeEventListener(Event.REMOVED_FROM_STAGE, handler);
		removeHandlerFromView(view, handler);
	}
}
