package robotlegs.bender.extensions.stage3D.base.api
{
	//import away3d.core.managers.Stage3DProxy;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage3D;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author P.J.Shand
	 * 
	 */
	public interface IRenderer
	{
		function init(profile:String, antiAlias:int=4):void;
		function start():void;
		function stop():void;
		function render():void;
		
		function addLayer(layer:ILayer):void;
		function addLayerAt(layer:ILayer, index:int):void;
		function removeLayer(layer:ILayer):void;
		
		function get onReady():Signal;
		//function get stage3DProxy():Stage3DProxy;
		function get stage3D():Stage3D;
		function get profile():String;
	}
}