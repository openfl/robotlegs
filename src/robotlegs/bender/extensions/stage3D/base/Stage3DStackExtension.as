package robotlegs.bender.extensions.stage3D.base
{
	import robotlegs.bender.extensions.stage3D.base.api.IRenderer;
	import robotlegs.bender.extensions.stage3D.base.api.IStack;
	import robotlegs.bender.extensions.stage3D.base.api.IViewport;
	import robotlegs.bender.extensions.stage3D.base.impl.Renderer;
	import robotlegs.bender.extensions.stage3D.base.impl.Stack;
	import robotlegs.bender.extensions.stage3D.base.impl.Viewport;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;
	import robotlegs.bender.framework.impl.UID;
	/**
	 * ...
	 * @author P.J.Shand
	 * 
	 */
	public class Stage3DStackExtension implements IExtension
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/
		
		private const _uid:String = UID.create(Stage3DStackExtension);
		
		public function Stage3DStackExtension() { }
		
		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function extend(context:IContext):void
		{
			context.injector.map(IStack).toSingleton(Stack);
			context.injector.map(IRenderer).toSingleton(Renderer);
			context.injector.map(IViewport).toSingleton(Viewport);
		}

		public function toString():String
		{
			return _uid;
		}
	}
}