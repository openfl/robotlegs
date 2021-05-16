package robotlegs.bender.extensions.display.stage3D.fuse.impl;

import fuse.Fuse;
import fuse.display.DisplayObject;
import fuse.display.DisplayObjectContainer;
import fuse.events.FuseEvent;
import polyfill.events.Event;
import org.swiftsuspenders.utils.DescribedType;
import robotlegs.bender.extensions.display.stage3D.fuse.api.IFuseViewMap;
import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;

/**
 * The <code>FuseViewMap</code> class performs managing Fuse stage and
 * views automatic mediation. When view is added or removed from stage, it will
 * automatically create or destroy its mediator.
 */
class FuseViewMap implements DescribedType implements IFuseViewMap {
	/*============================================================================*/
	/* Public Properties                                                         */
	/*============================================================================*/
	/** Collection of Fuse views which will receive display objects. **/
	@inject public var fuseCollection:FuseCollection;

	/** Map for mediating views. **/
	@inject public var mediatorMap:IMediatorMap;

	/*============================================================================*/
	/* Constructor
		/*============================================================================ */
	public function new() {}

	@postConstruct // [PostConstruct]

	/**
	 * Initialize listeners on Fuse views.
	 */
	public function init():Void {
		for (f in fuseCollection.items) {
			if (f == null)
				continue;
			var fuse:Fuse = cast f;
			// listen for display object events

			// adds stage as view to allow a Fuse Stage Mediator.
			fuse.addEventListener(FuseEvent.ROOT_CREATED, onRootCreated);
		}
	}

	/*============================================================================*/
	/* Public Methods
		/*============================================================================ */
	/** @inheritDoc **/
	public function addFuseView(view:DisplayObject):Void {
		mediateChildren(view);
	}

	function mediateChildren(view:DisplayObject) {
		if (Std.isOfType(view, DisplayObjectContainer)) {
			var v:DisplayObjectContainer = untyped view;
			for (i in 0...v.numChildren) {
				mediateChildren(v.getChildAt(i));
			}
		}
		mediatorMap.mediate(view);
	}

	/** @inheritDoc **/
	public function removeFuseView(view:DisplayObject):Void {
		unmediateChildren(view);
	}

	function unmediateChildren(view:DisplayObject) {
		if (Std.isOfType(view, DisplayObjectContainer)) {
			var v:DisplayObjectContainer = untyped view;
			for (i in 0...v.numChildren) {
				unmediateChildren(v.getChildAt(i));
			}
		}
		mediatorMap.unmediate(view);
	}

	/*============================================================================*/
	/* Private Methods
		/*============================================================================ */
	/**
	 * Handle Fuse view added on display list.
	 *
	 * @param event Fuse view added on stage.
	 */
	/*private function onFuseAdded(event:Event):Void
		{
			addFuseView(cast(event.target, DisplayObject));
	}*/
	function OnDisplayAddedToStage(view:DisplayObject) {
		addFuseView(view);
	}

	/**
	 * Handle Fuse view removed from display list.
	 *
	 * @param event Fuse view removed from stage.
	 */
	/*private function onFuseRemoved(event:Event):Void
		{
			removeFuseView(cast(event.target, DisplayObject));
	}*/
	function OnDisplayRemovedFromStage(view:DisplayObject) {
		removeFuseView(view);
	}

	/**
	 * Add Fuse stage to mediation.
	 *
	 * @param event Fuse had been initialized.
	 *
	 */
	private function onRootCreated(event:Event):Void {
		var fuse:Fuse = cast(event.target, Fuse);
		fuse.removeEventListener(FuseEvent.ROOT_CREATED, onRootCreated);
		fuse.stage.onDisplayAdded.add(OnDisplayAddedToStage);
		fuse.stage.onDisplayRemoved.add(OnDisplayRemovedFromStage);
		addFuseView(fuse.stage);
	}
}
