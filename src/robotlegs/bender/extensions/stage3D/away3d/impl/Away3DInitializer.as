package robotlegs.bender.extensions.stage3D.away3d.impl 
{
	import robotlegs.bender.extensions.stage3D.away3d.impl.AwayCollection;
	import robotlegs.bender.extensions.stage3D.base.impl.BaseInitializer;
	/**
	 * ...
	 * @author P.J.Shand
	 */
	public class Away3DInitializer extends BaseInitializer
	{
		
		public function Away3DInitializer() 
		{
			
		}
		
		override public function addLayer(ViewClass:Class, index:int, id:String):void
		{
			if (id == "") id = autoID(ViewClass);
			var awayLayer:AwayLayer = new ViewClass(/*renderer.stage3DProxy, */renderer.profile);
			awayLayer.iRenderer = renderer;
			
			context.configure(new AwayCollection([awayLayer, id]));
			contextView.view.addChild(awayLayer);
			
			if (index == -1) renderer.addLayer(awayLayer);
			else renderer.addLayerAt(awayLayer, index);
		}
	}
}