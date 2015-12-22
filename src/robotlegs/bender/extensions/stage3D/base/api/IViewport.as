package robotlegs.bender.extensions.stage3D.base.api 
{
	import flash.geom.Rectangle;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author P.J.Shand
	 */
	public interface IViewport 
	{
		function init():void;
		
		function get rect():Rectangle;
		function set rect(value:Rectangle):void;
		
		function get onChange():Signal;
	}	
}