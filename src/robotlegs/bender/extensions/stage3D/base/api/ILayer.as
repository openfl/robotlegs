package robotlegs.bender.extensions.stage3D.base.api 
{
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author P.J.Shand
	 */
	public interface ILayer
	{
		function process():void;
		
		function set iRenderer(value:IRenderer):void;
		
		function set rect(value:Rectangle):void;
	}
}