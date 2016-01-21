package robotlegs.bender.extensions.stage3D.base.api;

/**
* ...
* @author P.J.Shand
* 
*/
interface IStack
{
	function addLayer(layerClass:Class<Dynamic>, id:String = ""):Void;
	function addLayerAt(layerClass:Class<Dynamic>, index:Int, id:String = ""):Void;

	var debug(get, set):Bool;

	//function set debug(value:Bool):Void;
	//function get debug():Bool;
}