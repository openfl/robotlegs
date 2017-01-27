package robotlegs.bender.extensions.display.base.api;

import flash.geom.Rectangle;
/**
 * ...
 * @author P.J.Shand
 */
interface ILayer
{
	function process():Void;
	
	//var iRenderer(get, set):IRenderer;
	var renderContext(get, set):IRenderContext;
	function setTo(x:Float, y:Float, width:Float, height:Float):Void;
}