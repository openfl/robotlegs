package robotlegs.bender.extensions.display.stage3D.fuse.api;

import fuse.display.DisplayObject;


/**
 * The <code>IFuseViewMap</code> interface defines methods which will enable
 * view instance to be added or removed from mediation.
 */	
interface IFuseViewMap
{
	/**
	 * Add view to mediator map.
	 * 
	 * @param view View instance that needs to be mediated.
	 */	
	function addFuseView(view:DisplayObject):Void;
	
	/**
	 * Remove view from mediator map.
	 * 
	 * @param view View instance that needs to remove mediation.
	 */	
	function removeFuseView(view:DisplayObject):Void;
}