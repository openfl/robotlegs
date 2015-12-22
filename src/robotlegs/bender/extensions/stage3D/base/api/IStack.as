package robotlegs.bender.extensions.stage3D.base.api
{
	/**
	 * ...
	 * @author P.J.Shand
	 * 
	 */
	public interface IStack
	{
		function addLayer(layerClass:Class, id:String = ""):void;
		function addLayerAt(layerClass:Class, index:int, id:String = ""):void;
		
		function set debug(value:Boolean):void;
		function get debug():Boolean;
	}
}