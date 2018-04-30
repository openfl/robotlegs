package robotlegs.bender.extensions.display.stage3D.starling.impl;

import openfl.Vector;
import robotlegs.bender.extensions.display.base.impl.BaseCollection;
import starling.core.Starling;

/**
 * The <code>StarlingCollection</code> class represents collection of Starling
 * instances which will be used in SARS extension.
 * 
 * <p>This class will adds support to have multiple instances of Starling available
 * in Robotlegs application. All Starling instances when added to collection must
 * have defined name which will actually be used as named injection of Starling
 * view.</p>
 */	
class StarlingCollection extends BaseCollection
{
	
	public function new(starlingCollectionData:Array<Dynamic>) 
	{
		if (starlingCollectionData != null){
			var starling:Starling = starlingCollectionData[0];
			var viewID:String = starlingCollectionData[1];
			addItem(starling, viewID);
		}
	}
	
	/*============================================================================*/
	/* Public Methods
	/*============================================================================*/
	
	/**
	 * Add Starling instance to collection.
	 * 
	 * <p>Instance will be added to dictionary with key as name provided. When 
	 * using this collection with SARS, Starling views will be mapped to injector
	 * and differentiated by named injection. Name will be exact same as one
	 * provieded when adding instance to this collection.</p>
	 * 
	 * @param starling Starling instace to add to collection.
	 * 
	 * @param name Name by which Starling instance will be remembered.
	 * 
	 * @return Return number of instances in collection.
	 */
	public var starlings = new Vector<Starling>();
	
	public function addItem(starling:Starling, name:String):UInt
	{
		starlings.push(starling);
		if (items.exists(name) == false) {
			items.set(name, starling);
			_length++;
		}
		return _length;
	}
	
	/**
	 * Remove Starling item from collection by its name.
	 * 
	 * @param name Name by which Starling instance was added to collection.
	 * 
	 * @return Returns Starling instance which was removed if it is found, or if 
	 * not found by that name, returns <code>null</code>. 
	 */		
	public function removeItem(name:String):Starling
	{
		var result:Starling = getItem(name);
		
		for (i in 0...starlings.length) 
		{
			if (starlings[i] == result) starlings.splice(i, 1);
		}
		//If Starling instance is found in collection, remove entry
		if (result != null) {
			items.remove(name);
			_length--;
		}
		return result;
	}
	
	/**
	 * Get Starling instance by name.
	 * 
	 * @param name Name provided when Starling instance was added to collection.
	 * 
	 * @return Returns Starling instance it it was found, or <code>null</code> 
	 * otherwise.
	 */		
	public function getItem(name:String):Starling
	{
		if (items.exists(name) == false) return null;
		var starling:Starling = items.get(name);
		return starling;
	}
}