package robotlegs.bender.extensions.display.stage3D.away3d.impl;

import robotlegs.bender.extensions.display.stage3D.away3d.impl.AwayCollection;
import robotlegs.bender.extensions.display.base.impl.BaseInitializer;
/**
 * ...
 * @author P.J.Shand
 */
class Away3DInitializer extends BaseInitializer
{
	var added:Int = 0;
	
	public function new() 
	{
		
	}
	
	override public function checkLayerType(ViewClass:Class<Dynamic>):Bool 
	{
		return CheckClass(ViewClass, AwayLayer) || CheckClass(ViewClass, AwayStereoLayer);
	}
	
	override public function addLayer(ViewClass:Class<Dynamic>, index:Int, total:Int, id:String):Void
	{
		var stage3DRenderContext:Stage3DRenderContext = cast renderContext;
		if (id == "") id = autoID(ViewClass);
		var awayLayer:IAwayLayer = Type.createInstance(ViewClass, [stage3DRenderContext.profile]);
		awayLayer.renderContext = renderContext;
		
		var awayCollection = new AwayCollection([awayLayer, id]);
		context.configure([awayCollection]);
		contextView.view.addChildAt(cast awayLayer, added);
		added++;
		
		if (index == -1) layers.addLayer(cast awayLayer);
		else layers.addLayerAt(cast awayLayer, index);
	}
}