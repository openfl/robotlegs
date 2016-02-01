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
	var rect(null, set):Rectangle;
}