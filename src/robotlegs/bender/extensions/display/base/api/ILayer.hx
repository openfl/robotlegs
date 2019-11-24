package robotlegs.bender.extensions.display.base.api;

/**
 * ...
 * @author P.J.Shand
 */
interface ILayer
{
	var active:Bool;
	function process():Void;
	function snap():Void;
	
	//var iRenderer(get, set):IRenderer;
	var changeAvailable(get, null):Bool;
	var renderContext(get, set):IRenderContext;
	function setTo(x:Float, y:Float, width:Float, height:Float):Void;
}