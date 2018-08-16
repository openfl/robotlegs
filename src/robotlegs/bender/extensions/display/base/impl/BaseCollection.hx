package robotlegs.bender.extensions.display.base.impl;

import org.swiftsuspenders.utils.DescribedType;

/**
 * ...
 * @author P.J.Shand
 */
class BaseCollection implements DescribedType
{
	/*============================================================================*/
	/* private Properties
	/*============================================================================*/
	
	/** Collection of all registered views. **/
	//private var _collection = new Map<String, Dynamic>();
	
	/**
	 * Total number of view instances in dictionary (since Dictionary doesn't
	 * keep track of number of items in it, and looping through it is expensive).
	 */		
	private var _length:UInt = 0;
	
	public var items = new Map<String, Dynamic>();
	public var length(get, null):UInt;
	
	/**
	 * Get view instances in collection.
	 * 
	 * @return Returns Starling instances collection. 
	 */		
	/*private function get_items():Map<String, Dynamic>
	{
		return _collection;
	}

	private function set_items(value:Map<String, Dynamic>):Map<String, Dynamic>
	{
		_collection = value;
		return value;
	}*/

	/**
	 * Number of items in collection.
	 */		
	private function get_length():UInt
	{
		return _length;
	}
}