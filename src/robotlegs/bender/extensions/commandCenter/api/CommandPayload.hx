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

	private var _values:Array<Dynamic>;
	public var values(default, null):Array<Dynamic>;
	/**
	 * Ordered list of values
	 */
	/*public function get_values():Array
	{
		return _values;
	}*/

	private var _classes:Array<Dynamic>;
	public var classes(default, null):Array<Dynamic>;
	/**
	 * Ordered list of value classes
	 */
	/*public function get_classes():Array
	{
		return _classes;
	}*/

	public var length(get_length, null):UInt;
	/**
	 * The number of payload items
	 */
	public function get_length():UInt
	{
		if (_classes != null) return _classes.length;
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
		_values = values;
		_classes = classes;
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
		if (_values != null)
		{
			_values.push(payloadValue);
		}
		else
		{
			_values = [payloadValue];
		}
		if (_classes != null)
		{
			_classes.push(payloadClass);
		}
		else
		{
			_classes = [payloadClass];
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
		if (_values != null && _classes != null) {
			if (_values.length > 0 && _classes.length == _values.length) {
				return true;
			}
			else {
				return false;
			}
		}
		else {
			return false;
		}
		//return _values && _values.length > 0 && _classes && _classes.length == _values.length;
	}
}