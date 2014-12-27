//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewProcessorMap.dsl;

import robotlegs.bender.extensions.matching.ITypeFilter;

/**
 * View Processor Mapping
 */
interface IViewProcessorMapping
{
	/**
	 * The matcher for this mapping
	 */
	public var matcher(get, null):ITypeFilter;
	function get_matcher():ITypeFilter;

	/**
	 * The processor for this mapping
	 */
	public var processor(get, set):Dynamic;
	function get_processor():Dynamic;

	/**
	 * Sets the processor for this mapping
	 */
	function set_processor(value:Dynamic):Dynamic;

	/**
	 * The processor class for this mapping
	 */
	public var processorClass(get, null):Class<Dynamic>;
	function get_processorClass():Class<Dynamic>;

	/**
	 * A list of guards to consult before allowing a view to be processed
	 */
	public var guards(get, null):Array<Dynamic>;
	function get_guards():Array<Dynamic>;

	/**
	 * A list of hooks to run before processing a view
	 */
	public var hooks(get, null):Array<Dynamic>;
	function get_hooks():Array<Dynamic>;
}