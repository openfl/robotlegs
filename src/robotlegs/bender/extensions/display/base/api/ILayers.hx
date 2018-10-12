package robotlegs.bender.extensions.display.base.api;

/**
 * @author P.J.Shand
 */
@:keepSub
interface ILayers 
{
	var renderContext:IRenderContext;
	var layers:Array<ILayer>;
	
	var addedLayers(get, null):Iterator<ILayer>;
	var numLayers(get, null):Int;
	
	function removeLayerAt(index:Int):Void;
	function addLayer(layer:ILayer):Void;
	function addLayerAt(layer:ILayer, index:Int):Void;
	function removeLayer(layer:ILayer):Void;
	function getLayerIndex(layer:ILayer):Int;
	function init():Void;
	
}