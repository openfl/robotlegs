package robotlegs.bender.extensions.display.base.api;

/**
* ...
* @author P.J.Shand
* 
*/
@:keepSub
interface IStack
{
	function addLayer(layerClass:Class<Dynamic>, id:String = ""):Void;
	function addLayerAt(layerClass:Class<Dynamic>, index:Int, id:String = ""):Void;
	
	function removeLayerAt(index:Int):Void;
}