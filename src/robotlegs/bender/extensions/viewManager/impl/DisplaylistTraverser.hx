package robotlegs.bender.extensions.viewManager.impl;

import msignal.Signal.Signal1;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.events.Event;
import openfl.events.EventDispatcher;

/**
 * ...
 * @author P.J.Shand
 */
class DisplaylistTraverser
{
	public var display:DisplayObjectContainer;
	private var numChildrenRegistered(get, null):Int = 0;
	private var childTraversers:Array<DisplaylistTraverser> = [];
	
	public var active:Bool = true;
	public var childAdded = new Signal1(DisplayObject);
	public var childRemoved = new Signal1(DisplayObject);
	
	public function new(display:DisplayObjectContainer) 
	{
		this.display = display;
		this.display.addEventListener(Event.ENTER_FRAME, CheckTree);
		//this.display.addEventListener(Event.EXIT_FRAME, CheckTree);
		this.display.addEventListener(Event.ADDED_TO_STAGE, CheckTree);
	}
	
	private function CheckTree(e:Event):Void 
	{
		if (display.parent != null && numChildrenRegistered != display.numChildren) {
			Update();
		}
	}
	
	public function dispose():Void
	{
		if (display != null) {
			display.removeEventListener(Event.ENTER_FRAME, CheckTree);
		}
	}
	
	function Update() 
	{
		for (k in 0...childTraversers.length) 
		{
			childTraversers[k].active = false;
		}
		
		for (i in 0...display.numChildren) 
		{
			var alreadyAdded:Bool = false;
			for (j in 0...childTraversers.length) 
			{
				if (display.getChildAt(i) == childTraversers[j].display) {
					childTraversers[j].active = true;
					alreadyAdded = true;
					break;
				}
			}
			
			if (!alreadyAdded) {
				var child:DisplayObject = display.getChildAt(i);
				if (!Std.is(child, DisplayObjectContainer)) continue;
				
				var traverser = new DisplaylistTraverser(cast(child));
				traverser.childAdded.add(OnChildrenAdded);
				traverser.childRemoved.add(OnChildrenRemove);
				
				childTraversers.push(traverser);
				childAdded.dispatch(display.getChildAt(i));
			}
		}
		for (l in 0...childTraversers.length) 
		{
			if (!childTraversers[l].active) {
				var traverserToRemove = childTraversers[l];
				traverserToRemove.childAdded.remove(OnChildrenAdded);
				traverserToRemove.childRemoved.remove(OnChildrenRemove);
				childTraversers.splice(l, 1);
				childRemoved.dispatch(traverserToRemove.display);
				traverserToRemove.dispose();
			}
		}
	}
	
	private function get_numChildrenRegistered():Int 
	{
		return childTraversers.length;
	}
	
	private function OnChildrenAdded(display:DisplayObject):Void
	{
		childAdded.dispatch(display);
	}
	
	private function OnChildrenRemove(display:DisplayObject):Void
	{
		childRemoved.dispatch(display);
	}
}