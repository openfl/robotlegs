package robotlegs.bender.extensions.display.base.api;

import msignal.Signal.Signal0;
/**
 * ...
 * @author P.J.Shand
 * 
 */
@:rtti
@:keepSub
interface IRenderer
{
	var active(get, set):Bool;
	var onActiveChange(get, null):Signal0;
	
	var frameRate:Null<Int>;
	var prePresent:Signal0;
	var postPresent:Signal0;
	
	function start():Void;
	function stop():Void;
	function render():Void;
}