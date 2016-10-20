package robotlegs.bender.extensions.display.stage3D.starling.api;

import starling.display.DisplayObject;

/**
 * The <code>IStarlingViewMap</code> interface defines methods which will enable
 * view instance to be added or removed from mediation.
 */	
interface IStarlingViewMap
{
	/**
	 * Add view to mediator map.
	 * 
	 * @param view View instance that needs to be mediated.
	 */	
	function addStarlingView(view:DisplayObject):Void;
	
	/**
	 * Remove view from mediator map.
	 * 
	 * @param view View instance that needs to remove mediation.
	 */	
	function removeStarlingView(view:DisplayObject):Void;
}