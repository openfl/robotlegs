package robotlegs.bender.extensions.stage3D.base.impl
{
	import flash.net.getClassByAlias;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.extensions.stage3D.alternativa3d.impl.Alternativa3DInitializerAvailable;
	import robotlegs.bender.extensions.stage3D.away3d.impl.Away3DInitializerAvailable;
	import robotlegs.bender.extensions.stage3D.base.api.IRenderer;
	import robotlegs.bender.extensions.stage3D.base.api.IStack;
	import robotlegs.bender.extensions.stage3D.flare3d.impl.Flare3DInitializerAvailable;
	import robotlegs.bender.extensions.stage3D.genome.impl.GenomeInitializerAvailable;
	import robotlegs.bender.extensions.stage3D.starling.impl.StarlingInitializerAvailable;
	import robotlegs.bender.extensions.stage3D.zest3d.impl.Zest3DInitializerAvailable;
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.ILogger;
	
	/**
	 * ...
	 * @author P.J.Shand
	 * 
	 */
	public class Stack implements IStack
	{
		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/
		private var _injector:IInjector;
		private var _logger:ILogger;
		private var context:IContext;
		private var _debug:Boolean = false;
		private var classIDs:Vector.<Vector.<String>>;
		private var initialized:Boolean = false;
		
		[Inject] public var contextView:ContextView;
		[Inject] public var renderer:IRenderer;
		
		[Inject(optional = true)] public var alternativa3DInitializerAvailable:Alternativa3DInitializerAvailable;
		[Inject(optional = true)] public var away3DInitializerAvailable:Away3DInitializerAvailable;
		[Inject(optional = true)] public var fare3DInitializerAvailable:Flare3DInitializerAvailable;
		[Inject(optional = true)] public var genomeInitializerAvailable:GenomeInitializerAvailable;
		[Inject(optional = true)] public var starlingInitializerAvailable:StarlingInitializerAvailable;
		[Inject(optional = true)] public var zest3DInitializerAvailable:Zest3DInitializerAvailable;
		
		public var alternativa3DInitializer:BaseInitializer;
		public var away3DInitializer:BaseInitializer;
		public var flare3DInitializer:BaseInitializer;
		public var genomeInitializer:BaseInitializer;
		public var starlingInitializer:BaseInitializer;
		public var zest3DInitializer:BaseInitializer;
		
		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/
		public function Stack(context:IContext)
		{
			this.context = context;
			_injector = context.injector;
			_logger = context.getLogger(this);
			
			classIDs = new <Vector.<String>>
			[
				new <String>["robotlegs.bender.extensions.stage3D.alternativa3d.impl","AlternativaLayer"],
				new <String>["robotlegs.bender.extensions.stage3D.away3d.impl","AwayLayer"],
				new <String>["robotlegs.bender.extensions.stage3D.flare3d.impl","FlareLayer"],
				new <String>["robotlegs.bender.extensions.stage3D.genome.impl","GenomeLayer"],
				new <String>["robotlegs.bender.extensions.stage3D.starling.impl","StarlingLayer"],
				new <String>["robotlegs.bender.extensions.stage3D.zest3d.impl","ZestLayer"]
			]
		}
		
		private function initialize():void 
		{
			if (initialized) return;
			initialized = true;
			
			alternativa3DInitializer = createInitializer("Alternativa3DInitializer");
			away3DInitializer = createInitializer("Away3DInitializer");
			flare3DInitializer = createInitializer("Flare3DInitializer");
			genomeInitializer = createInitializer("GenomeInitializer");
			starlingInitializer = createInitializer("StarlingInitializer");
			zest3DInitializer = createInitializer("Zest3DInitializer");
		}
		
		private function createInitializer(classAlias:String):BaseInitializer 
		{
			var initializer:BaseInitializer;
			try {
				var InitializerClass:Class = getClassByAlias(classAlias) as Class;
				if (InitializerClass) {
					initializer = new InitializerClass();
					initializer.init(renderer, contextView, context);
				}
			}
			catch (e:Error) {
				
			}
			return initializer;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/
		
		public function addLayer(LayerClass:Class, id:String=""):void
		{
			addLayerAt(LayerClass, -1, id);
		}
		
		public function addLayerAt(LayerClass:Class, index:int, id:String=""):void
		{
			initialize();
			
			     if (isOfType(LayerClass, classIDs[0][0] + "::" + classIDs[0][1])) addAlternativa3DAt(LayerClass, index, id);
			else if (isOfType(LayerClass, classIDs[1][0] + "::" + classIDs[1][1])) addAway3DAt(LayerClass, index, id);
			else if (isOfType(LayerClass, classIDs[2][0] + "::" + classIDs[2][1])) addFlare3DAt(LayerClass, index, id);
			else if (isOfType(LayerClass, classIDs[3][0] + "::" + classIDs[3][1])) addGenomeAt(LayerClass, index, id);
			else if (isOfType(LayerClass, classIDs[4][0] + "::" + classIDs[4][1])) addStarlingAt(LayerClass, index, id);
			else if (isOfType(LayerClass, classIDs[5][0] + "::" + classIDs[5][1])) addZest3DAt(LayerClass, index, id);
		}
		
		private function isOfType(LayerClass:Class, ClassName:String):Boolean 
		{
			var layerTypeXML:XML = describeType(LayerClass);
			var len:int = layerTypeXML.factory.extendsClass.length();
			for (var i:int = 0; i < len; i++) 
			{
				if (layerTypeXML.factory.extendsClass[i].@type == ClassName) return true;
			}
			return false;
		}
		
		/*============================================================================*/
		/* Private Functions                                                           */
		/*============================================================================*/
		
		private function addAlternativa3DAt(AlternativaClass:Class, index:int, id:String=""):void
		{
			if (starlingInitializerAvailable == null) {
				throw new Error(errorMsg(0));
				return;
			}
		}
		
		private function addAway3DAt(AwayClass:Class, index:int, id:String=""):void
		{
			if (away3DInitializerAvailable == null) {
				throw new Error(errorMsg(1));
				return;
			}
			away3DInitializer.addLayer(AwayClass, index, id);
		}
		
		private function addFlare3DAt(FlareClass:Class, index:int, id:String=""):void
		{
			if (starlingInitializerAvailable == null) {
				throw new Error(errorMsg(2));
				return;
			}
		}
		
		private function addGenomeAt(GenomeClass:Class, index:int, id:String=""):void
		{
			if (genomeInitializerAvailable == null) {
				throw new Error(errorMsg(3));
				return;
			}
			genomeInitializer.addLayer(GenomeClass, index, id);
		}
		
		private function addStarlingAt(StarlingLayerClass:Class, index:int, id:String=""):void
		{
			if (starlingInitializerAvailable == null) {
				throw new Error(errorMsg(4));
				return;
			}
			starlingInitializer.addLayer(StarlingLayerClass, index, id);
		}
		
		private function addZest3DAt(ZestClass:Class, index:int, id:String=""):void
		{
			if (starlingInitializerAvailable == null) {
				throw new Error(errorMsg(5));
				return;
			}
			zest3DInitializer.addLayer(ZestClass, index, id);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function get debug():Boolean 
		{
			return _debug;
		}
		
		public function set debug(value:Boolean):void 
		{
			_debug = value;
			if (away3DInitializer) away3DInitializer.debug = value;
			if (starlingInitializer) starlingInitializer.debug = value;
			if (genomeInitializer) genomeInitializer.debug = value;
		}
		
		private function errorMsg(index:int):String 
		{
			return "[" + classIDs[index][0] + "] needs to be installed before this method can be called, eg: context.install(" + classIDs[index][1] + ");"
		}
		
	}
}
