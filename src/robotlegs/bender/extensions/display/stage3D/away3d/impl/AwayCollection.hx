package robotlegs.bender.extensions.display.stage3D.away3d.impl;

import away3d.containers.View3D;
import robotlegs.bender.extensions.display.base.impl.BaseCollection;

/**
 * ...
 * @author P.J.Shand
 */
class AwayCollection extends BaseCollection {
	public function new(awayCollectionData:Array<Dynamic>) {
		if (awayCollectionData != null) {
			var view3D:View3D = awayCollectionData[0];
			var viewID:String = awayCollectionData[1];
			addItem(view3D, viewID);
		}
	}

	/*============================================================================*/
	/* Public Methods
		/*============================================================================ */
	/**
	 * Add View3D instance to collection.
	 *
	 * <p>Instance will be added to dictionary with key as name provided. When
	 * using this collection with SARS, View3D views will be mapped to injector
	 * and differentiated by named injection. Name will be exact same as one
	 * provieded when adding instance to this collection.</p>
	 *
	 * @param view3D View3D instace to add to collection.
	 *
	 * @param name Name by which View3D instance will be remembered.
	 *
	 * @return Return number of instances in collection.
	 */
	public var view3Ds:Array<View3D> = new Array<View3D>();

	public function addItem(view3D:View3D, name:String):UInt {
		view3Ds.push(view3D);
		// CHECK
		if (items[name] == null) {
			items[name] = view3D;
			_length++;
		}
		return _length;
	}

	/**
	 * Remove View3D item from collection by its name.
	 *
	 * @param name Name by which View3D instance was added to collection.
	 *
	 * @return Returns View3D instance which was removed if it is found, or if
	 * not found by that name, returns <code>null</code>.
	 */
	public function removeItem(name:String):View3D {
		var result:View3D = getItem(name);

		for (i in 0...view3Ds.length) {
			if (view3Ds[i] == result)
				view3Ds.splice(i, 1);
		}
		// If View3D instance is found in collection, remove entry
		if (result != null) {
			items.remove(name);
			_length--;
		}
		return result;
	}

	/**
	 * Get View3D instance by name.
	 *
	 * @param name Name provided when View3D instance was added to collection.
	 *
	 * @return Returns View3D instance it it was found, or <code>null</code>
	 * otherwise.
	 */
	public function getItem(name:String):View3D {
		// CHECK
		if (items[name] == null)
			return null;
		var view3D:View3D = items[name];
		return view3D;
	}
}
