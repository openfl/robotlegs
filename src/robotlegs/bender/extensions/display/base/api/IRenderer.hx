package robotlegs.bender.extensions.display.base.api;

import robotlegs.signal.Signal.Signal0;
#if openfl
import openfl.display.BitmapData;
#end

/**
 * ...
 * @author P.J.Shand
 *
 */
interface IRenderer {
	var active(get, set):Bool;
	var onActiveChange(get, null):Signal0;

	var frameRate:Null<Int>;
	var prePresent:Signal0;
	var postPresent:Signal0;

	function start():Void;
	function stop():Void;
	function render():Void;
	#if openfl
	function snap(x:Int, y:Int, width:Int, height:Int):BitmapData;
	#end
}
