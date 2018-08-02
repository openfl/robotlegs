package robotlegs.bender.extensions.display.base.api;

/**
 * @author Thomas Byrne
 */
interface ILayerInitializer 
{
	function checkLayerType(ViewClass:Class<Dynamic>):Bool;
	function addLayer(ViewClass:Class<Dynamic>, index:Int, total:Int, id:String):Void;
}