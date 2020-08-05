package robotlegs.bender.extensions.display.base.api;

import robotlegs.signal.Signal.Signal0;

/**
 * ...
 * @author P.J.Shand
 */
interface IViewport {
	function setTo(x:Float, y:Float, width:Float, height:Float):Void;

	var x(get, set):Float;
	var y(get, set):Float;
	var width(get, set):Float;
	var height(get, set):Float;

	var onChange(get, null):Signal0;
	var colour(get, set):UInt;

	var alpha(get, set):Float;

	var red(get, null):UInt;
	var green(get, null):UInt;
	var blue(get, null):UInt;
}
