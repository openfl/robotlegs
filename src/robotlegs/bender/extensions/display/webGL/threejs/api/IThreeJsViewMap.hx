// ------------------------------------------------------------------------------
// Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
// NOTICE: You are permitted to use, modify, and distribute this file
// in accordance with the terms of the license agreement accompanying it.
// ------------------------------------------------------------------------------
package robotlegs.bender.extensions.display.webGL.threejs.api;

/**
 * The <code>IThreeJsViewMap</code> interface defines methods which will enable
 * view instance to be added or removed from mediation.
 */	
interface IThreeJsViewMap
{
	/**
	 * Add view to mediator map.
	 * 
	 * @param view View instance that needs to be mediated.
	 */		
	function addView(view:Dynamic):Void;
	
	/**
	 * Remove view from mediator map.
	 * 
	 * @param view View instance that needs to remove mediation.
	 */		
	function removeView(view:Dynamic):Void;
}