package robotlegs.bender.extensions.display.base;

import robotlegs.bender.extensions.display.base.api.ILayers;
import robotlegs.bender.extensions.display.base.api.IRenderer;
import robotlegs.bender.extensions.display.base.api.IStack;
import robotlegs.bender.extensions.display.base.api.IViewport;
import robotlegs.bender.extensions.display.base.impl.Layers;
import robotlegs.bender.extensions.display.base.impl.Renderer;
import robotlegs.bender.extensions.display.base.impl.Stack;
import robotlegs.bender.extensions.display.base.impl.Viewport;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;

/**
 * ...
 * @author P.J.Shand
 */
class DisplayExtension implements IExtension
{

	public function new() 
	{
		
	}
	
	public function extend(context:IContext):Void 
	{
		context.injector.map(IStack).toSingleton(Stack);
		context.injector.map(IRenderer).toSingleton(Renderer);
		//context.injector.map(IRenderContext).toSingleton(Stage3DRenderContext);
		context.injector.map(ILayers).toSingleton(Layers);
		context.injector.map(IViewport).toSingleton(Viewport);
		
		var layers:ILayers = context.injector.getInstance(ILayers);
		layers.init();
	}
	
}