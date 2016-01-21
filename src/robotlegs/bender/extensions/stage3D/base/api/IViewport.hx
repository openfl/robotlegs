package robotlegs.bender.extensions.stage3D.base.api; 

import flash.geom.Rectangle;
import msignal.Signal.Signal0;

/**
 * ...
 * @author P.J.Shand
 */
interface IViewport 
{
	function init():Void;
	
	
	
	var rect(get, set):Rectangle;
	var onChange(get, null):Signal0;
	var colour(get, set):UInt;
	
	var red(get, null):UInt;
	var green(get, null):UInt;
	var blue(get, null):UInt;
}