//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------
package robotlegs.bender.extensions.viewProcessorMap.impl;

import robotlegs.bender.extensions.matching.ITypeFilter;
import robotlegs.bender.extensions.viewProcessorMap.dsl.IViewProcessorMapping;
import robotlegs.bender.extensions.viewProcessorMap.dsl.IViewProcessorMappingConfig;
import robotlegs.bender.framework.impl.Guard;

/**
 * @private
 */
@:keepSub
class ViewProcessorMapping implements IViewProcessorMapping implements IViewProcessorMappingConfig {
	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/
	private var _matcher:ITypeFilter;

	public var matcher(get, null):ITypeFilter;

	/**
	 * @inheritDoc
	 */
	public function get_matcher():ITypeFilter {
		return _matcher;
	}

	private var _processor:Dynamic;

	public var processor(get, set):Dynamic;

	/**
	 * @inheritDoc
	 */
	public function get_processor():Dynamic {
		return _processor;
	}

	/**
	 * @inheritDoc
	 */
	public function set_processor(value:Dynamic):Dynamic {
		_processor = value;
		return _processor;
	}

	private var _processorClass:Class<Dynamic>;

	public var processorClass(get, null):Class<Dynamic>;

	/**
	 * @inheritDoc
	 */
	public function get_processorClass():Class<Dynamic> {
		return _processorClass;
	}

	private var _guards:Array<Guard> = [];

	public var guards(get, null):Array<Guard>;

	/**
	 * @inheritDoc
	 */
	public function get_guards():Array<Guard> {
		return _guards;
	}

	private var _hooks:Array<Dynamic> = [];

	public var hooks(get, null):Array<Dynamic>;

	/**
	 * @inheritDoc
	 */
	public function get_hooks():Array<Dynamic> {
		return _hooks;
	}

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/
	/**
	 * @private
	 */
	public function new(matcher:ITypeFilter, processor:Dynamic) {
		_matcher = matcher;

		setProcessor(processor);
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/
	/**
	 * @inheritDoc
	 */
	public function withGuards(guards:Array<Dynamic>):IViewProcessorMappingConfig {
		// CHECK
		for (i in 0...guards.length) {
			_guards.push(guards[i]);
		}
		// _guards = _guards.concat.apply(null, guards);
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function withHooks(hooks:Array<Dynamic>):IViewProcessorMappingConfig {
		// CHECK
		for (i in 0...hooks.length) {
			_hooks.push(hooks[i]);
		}
		// _hooks = _hooks.concat.apply(null, hooks);
		return this;
	}

	public function toString():String {
		return 'Processor ' + _processor;
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/
	private function setProcessor(processor:Dynamic):Void {
		if (Std.is(processor, Class)) {
			_processorClass = cast(processor, Class<Dynamic>);
		} else {
			_processor = processor;
			_processorClass = Type.getClass(_processor);
		}
	}
}
