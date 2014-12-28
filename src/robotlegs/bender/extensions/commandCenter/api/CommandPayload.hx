//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.api;

/**
 * @private
 */
class CommandPayload
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	//private var _values:Array<Dynamic>;
	public var values(get, null):Array<Dynamic>;
	/**
	 * Ordered list of values
	 */
	function get_values():Array<Dynamic>
	{
		return this.values;
	}

	//private var _classes:Array<Dynamic>;
	public var classes(get, null):Array<Dynamic>;
	/**
	 * Ordered list of value classes
	 */
	function get_classes():Array<Dynamic>
	{
		return this.classes;
	}

	public var length(get, null):UInt;
	/**
	 * The number of payload items
	 */
	function get_length():UInt
	{
		if (this.classes != null) return this.classes.length;
		else return 0;
	}

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * Creates a command payload
	 * @param values Optional values
	 * @param classes Optional classes
	 */
	public function new(values:Array<Dynamic> = null, classes:Array<Dynamic> = null)
	{
		this.values = values;
		this.classes = classes;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * Adds an item to this payload
	 * @param payloadValue The value
	 * @param payloadClass The class of the value
	 * @return Self
	 */
	public function addPayload(payloadValue:Dynamic, payloadClass:Class<Dynamic>):CommandPayload
	{
		if (this.values != null)
		{
			this.values.push(payloadValue);
		}
		else
		{
			this.values = [payloadValue];
		}
		if (this.classes != null)
		{
			this.classes.push(payloadClass);
		}
		else
		{
			this.classes = [payloadClass];
		}

		return this;
	}

	/**
	 * Does this payload have any items?
	 * @return Bool
	 */
	public function hasPayload():Bool
	{
		// todo: the final clause will make this fail silently
		// todo: rethink
		// CHECK
		if (this.values != null && this.classes != null) {
			if (this.values.length > 0 && this.classes.length == this.values.length) {
				return true;
			}
			else {
				return false;
			}
		}
		else {
			return false;
		}
		//return this.values && this.values.length > 0 && this.classes && this.classes.length == this.values.length;
	}
}