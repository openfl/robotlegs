package robotlegs.bender.extensions.stage3D.base.impl 
{
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author P.J.Shand
	 */
	public class BaseCollection 
	{
		/*============================================================================*/
		/* Protected Properties
		/*============================================================================*/
		
		/** Collection of all registered views. **/
		protected var _collection:Dictionary = new Dictionary(true);
		
		/**
		 * Total number of Starling instances in dictionary (since Dictionary doesn't
		 * keep track of number of items in it, and looping through it is expensive).
		 */		
		protected var _length:uint = 0;
		
		public function BaseCollection() 
		{
			
		}
		
		
		/**
		 * Get Starling instances in collection.
		 * 
		 * @return Returns Starling instances collection. 
		 */		
		public function get items():Dictionary
		{
			return _collection;
		}

		/**
		 * Number of items in collection.
		 */		
		public function get length():uint
		{
			return _length;
		}
	}
}