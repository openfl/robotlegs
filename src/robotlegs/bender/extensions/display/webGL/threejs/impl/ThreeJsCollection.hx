package robotlegs.bender.extensions.display.webGL.threejs.impl;

import robotlegs.bender.extensions.display.base.impl.BaseCollection;
/**
 * ...
 * @author P.J.Shand
 */
class ThreeJsCollection extends BaseCollection
{
	
	public function new(threeJsCollectionData:Array<Dynamic>) 
	{
		if (threeJsCollectionData != null) {
			var threeJsLayer:ThreeJsLayer = threeJsCollectionData[0];
			var viewID:String = threeJsCollectionData[1];
			addItem(threeJsLayer, viewID);
		}
	}
	
	/*============================================================================*/
	/* Public Methods
	/*============================================================================*/
	
	/**
	 * Add ThreeJsLayer instance to collection.
	 * 
	 * <p>Instance will be added to dictionary with key as name provided. When 
	 * using this collection with SARS, ThreeJsLayer views will be mapped to injector
	 * and differentiated by named injection. Name will be exact same as one
	 * provieded when adding instance to this collection.</p>
	 * 
	 * @param threeJsLayer ThreeJsLayer instace to add to collection.
	 * 
	 * @param name Name by which ThreeJsLayer instance will be remembered.
	 * 
	 * @return Return number of instances in collection.
	 */
	
	public var view3Ds:Array<ThreeJsLayer> = new Array<ThreeJsLayer>();
	
	public function addItem(threeJsLayer:ThreeJsLayer, name:String):UInt
	{
		view3Ds.push(threeJsLayer);
		// CHECK
		if (items[name] == null) {
			items[name] = threeJsLayer;
			_length++;
		}
		return _length;
	}
	
	/**
	 * Remove ThreeJsLayer item from collection by its name.
	 * 
	 * @param name Name by which ThreeJsLayer instance was added to collection.
	 * 
	 * @return Returns ThreeJsLayer instance which was removed if it is found, or if 
	 * not found by that name, returns <code>null</code>. 
	 */		
	public function removeItem(name:String):ThreeJsLayer
	{
		var result:ThreeJsLayer = getItem(name);
		
		for (i in 0...view3Ds.length) 
		{
			if (view3Ds[i] == result) view3Ds.splice(i, 1);
		}
		//If ThreeJsLayer instance is found in collection, remove entry
		if (result != null) {
			items.remove(name);
			_length--;
		}
		return result;
	}
	
	/**
	 * Get ThreeJsLayer instance by name.
	 * 
	 * @param name Name provided when ThreeJsLayer instance was added to collection.
	 * 
	 * @return Returns ThreeJsLayer instance it it was found, or <code>null</code> 
	 * otherwise.
	 */		
	public function getItem(name:String):ThreeJsLayer
	{
		// CHECK
		if (items[name] == null) return null;
		var threeJsLayer:ThreeJsLayer = items[name];
		return threeJsLayer;
	}
}