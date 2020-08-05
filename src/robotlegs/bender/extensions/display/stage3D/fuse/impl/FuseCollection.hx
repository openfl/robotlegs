package robotlegs.bender.extensions.display.stage3D.fuse.impl;

import fuse.Fuse;
import openfl.Vector;
import robotlegs.bender.extensions.display.base.impl.BaseCollection;

/**
 * The <code>FuseCollection</code> class represents collection of Fuse
 * instances which will be used in SARS extension.
 *
 * <p>This class will adds support to have multiple instances of Fuse available
 * in Robotlegs application. All Fuse instances when added to collection must
 * have defined name which will actually be used as named injection of Fuse
 * view.</p>
 */
class FuseCollection extends BaseCollection {
	public function new(fuseCollectionData:Array<Dynamic>) {
		if (fuseCollectionData != null) {
			var fuse:Fuse = fuseCollectionData[0];
			var viewID:String = fuseCollectionData[1];
			addItem(fuse, viewID);
		}
	}

	/*============================================================================*/
	/* Public Methods
		/*============================================================================ */
	/**
	 * Add Fuse instance to collection.
	 *
	 * <p>Instance will be added to dictionary with key as name provided. When
	 * using this collection with SARS, Fuse views will be mapped to injector
	 * and differentiated by named injection. Name will be exact same as one
	 * provieded when adding instance to this collection.</p>
	 *
	 * @param fuse Fuse instace to add to collection.
	 *
	 * @param name Name by which Fuse instance will be remembered.
	 *
	 * @return Return number of instances in collection.
	 */
	public var fuses = new Vector<Fuse>();

	public function addItem(fuse:Fuse, name:String):UInt {
		fuses.push(fuse);
		if (items.exists(name) == false) {
			items.set(name, fuse);
			_length++;
		}
		return _length;
	}

	/**
	 * Remove Fuse item from collection by its name.
	 *
	 * @param name Name by which Fuse instance was added to collection.
	 *
	 * @return Returns Fuse instance which was removed if it is found, or if
	 * not found by that name, returns <code>null</code>.
	 */
	public function removeItem(name:String):Fuse {
		var result:Fuse = getItem(name);

		for (i in 0...fuses.length) {
			if (fuses[i] == result)
				fuses.splice(i, 1);
		}
		// If Fuse instance is found in collection, remove entry
		if (result != null) {
			items.remove(name);
			_length--;
		}
		return result;
	}

	/**
	 * Get Fuse instance by name.
	 *
	 * @param name Name provided when Fuse instance was added to collection.
	 *
	 * @return Returns Fuse instance it it was found, or <code>null</code>
	 * otherwise.
	 */
	public function getItem(name:String):Fuse {
		if (items.exists(name) == false)
			return null;
		var fuse:Fuse = items.get(name);
		return fuse;
	}
}
