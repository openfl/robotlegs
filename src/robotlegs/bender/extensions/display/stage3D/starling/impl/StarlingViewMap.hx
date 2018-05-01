package robotlegs.bender.extensions.display.stage3D.starling.impl;

import org.swiftsuspenders.utils.DescribedType;
import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
import robotlegs.bender.extensions.display.base.api.IDisplayObject;
import robotlegs.bender.extensions.display.stage3D.starling.api.IStarlingViewMap;
import robotlegs.bender.extensions.display.stage3D.starling.impl.StarlingCollection;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.events.Event;

/**
 * The <code>StarlingViewMap</code> class performs managing Starling stage and 
 * views automatic mediation. When view is added or removed from stage, it will
 * automatically create or destroy its mediator.
 */
class StarlingViewMap implements DescribedType implements IStarlingViewMap
{
	/*============================================================================*/
	/* Public Properties                                                         */
	/*============================================================================*/
	
	/** Collection of Starling views which will receive display objects. **/
	@inject public var starlingCollection:StarlingCollection;
	
	/** Map for mediating views. **/
	@inject public var mediatorMap:IMediatorMap;
	
	/*============================================================================*/
	/* Constructor
	/*============================================================================*/
	public function new() { }
	
	@postConstruct//[PostConstruct]
	/**
	 * Initialize listeners on Starling views.
	 */		
	public function init():Void
	{	
		for (s in starlingCollection.items) 
		{
			if (s == null) continue;
			var starling:Starling = cast s;
			// listen for display object events
			starling.stage.addEventListener( Event.ADDED, onStarlingAdded );
			starling.stage.addEventListener( Event.REMOVED, onStarlingRemoved );
			
			// adds stage as view to allow a Starling Stage Mediator.
			starling.addEventListener( Event.ROOT_CREATED, onRootCreated );
		}
	}
	
	/*============================================================================*/
	/* Public Methods
	/*============================================================================*/
	
	/** @inheritDoc **/		
	public function addStarlingView(view:DisplayObject):Void
	{
		mediateChildren(view);
	}
	
	function mediateChildren(view:DisplayObject) 
	{
		if (Std.is(view, DisplayObjectContainer)) {
			var v:DisplayObjectContainer = untyped view;
			for (i in 0...v.numChildren) 
			{
				mediateChildren(v.getChildAt(i));
			}
		}
		mediatorMap.mediate(view);
	}
	
	/** @inheritDoc **/		
	public function removeStarlingView(view:DisplayObject):Void
	{
		unmediateChildren(view);
	}
	
	function unmediateChildren(view:DisplayObject) 
	{
		if (Std.is(view, DisplayObjectContainer)) {
			var v:DisplayObjectContainer = untyped view;
			for (i in 0...v.numChildren) 
			{
				unmediateChildren(v.getChildAt(i));
			}
		}
		mediatorMap.unmediate(view);
	}
	
	/*============================================================================*/
	/* Private Methods
	/*============================================================================*/
	
	/**
	 * Handle Starling view added on display list.
	 * 
	 * @param event Starling view added on stage.
	 */		
	private function onStarlingAdded(event:Event):Void
	{
		addStarlingView(cast(event.target, DisplayObject));
	}
	
	/**
	 * Handle Starling view removed from display list.
	 * 
	 * @param event Starling view removed from stage.
	 */		
	private function onStarlingRemoved(event:Event):Void
	{
		removeStarlingView(cast(event.target, DisplayObject));
	}
	
	/**
	 * Add Starling stage to mediation.
	 * 
	 * @param event Starling had been initialized.
	 * 
	 */		
	private function onRootCreated(event:Event):Void
	{
		cast(event.target, Starling).removeEventListener(Event.ROOT_CREATED, onRootCreated);
		addStarlingView(cast(event.target, Starling).stage);
	}
}