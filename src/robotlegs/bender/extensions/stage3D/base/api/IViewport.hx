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
	//function get rect():Rectangle;
	//function set rect(value:Rectangle):Void;
	
	var onChange(get, null):Signal0;
	//function get onChange():Signal;
	
}