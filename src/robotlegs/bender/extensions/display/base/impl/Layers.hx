package robotlegs.bender.extensions.display.base.impl;

import org.swiftsuspenders.utils.DescribedType;
import robotlegs.bender.extensions.display.base.api.ILayer;
import robotlegs.bender.extensions.display.base.api.ILayers;
import robotlegs.bender.extensions.display.base.api.IRenderContext;
import robotlegs.bender.extensions.display.base.api.IViewport;

/**
 * ...
 * @author P.J.Shand
 */
class Layers extends DescribedType implements ILayers
{
	@inject public var viewport:IViewport;
	
	public var renderContext:IRenderContext;
	public var layers = new Array<ILayer>();
	
	@:isVar 
	public var addedLayers(get, null):Iterator<ILayer>;
	public var numLayers(get, null):Int;
	
	public function new() 
	{
		
	}
	
	public function init():Void
	{
		viewport.onChange.add(OnViewportChange);
	}
	
	function OnViewportChange() 
	{
		for (i in 0...layers.length)
		{
			if (layers[i].active){
				layers[i].setTo(viewport.x, viewport.y, viewport.width, viewport.height);
			}
		}
	}
	
	public function removeLayerAt(index:Int):Void
	{
		if (index >= layers.length) return;
		layers.splice(index, 1);
	}
	
	public function addLayer(layer:ILayer):Void
	{
		layer.renderContext = renderContext;
		layer.setTo(viewport.x, viewport.y, viewport.width, viewport.height);
		layers.push(layer);
		renderContext.checkVisability();
	}
	
	public function addLayerAt(layer:ILayer, index:Int):Void
	{
		layer.renderContext = renderContext;
		if (layers.length <= index) {
			if (layers.length < index) trace("[Renderer, addLayerAt], index outside bounds, reverting to addLayer");
			addLayer(layer);
			return;
		}
		
		var copyLayers = layers.copy();
		layers = new Array<ILayer>();
		for (i in 0...copyLayers.length) 
		{
			if (i == index) {
				layers.push(layer);
			}
			layers.push(copyLayers[i]);
		}
		renderContext.checkVisability();
	}
	
	public function removeLayer(layer:ILayer):Void
	{
		layer.renderContext = null;
		for (i in 0...layers.length) 
		{
			if (layers[i] == layer) {
				layers.splice(i, 1);
			}
		}
		renderContext.checkVisability();
	}
	
	public function getLayerIndex(layer:ILayer):Int
	{
		for (i in 0...layers.length) 
		{
			if (layers[i] == layer) {
				return i;
			}
		}
		return -1;
	}
	
	public function get_numLayers():Int 
	{
		return layers.length;
	}
	
	private function get_addedLayers():Iterator<ILayer> 
	{
		return layers.iterator();
	}
}