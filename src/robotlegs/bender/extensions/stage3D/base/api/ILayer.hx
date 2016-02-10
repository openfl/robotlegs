package robotlegs.bender.extensions.stage3D.base.api;

import flash.geom.Rectangle;
/**
 * ...
 * @author P.J.Shand
 */
interface ILayer
{
	function process():Void;
	
	var iRenderer(get, set):IRenderer;
	function setTo(x:Float, y:Float, width:Float, height:Float):Void;
}