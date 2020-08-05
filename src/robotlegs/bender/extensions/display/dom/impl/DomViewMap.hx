package robotlegs.bender.extensions.display.dom.impl;

import js.Browser;
import js.html.MutationEvent;
import js.html.Element;
import org.swiftsuspenders.utils.DescribedType;
import robotlegs.bender.extensions.display.dom.api.*;
import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;

class DomViewMap implements DescribedType implements IDomViewMap {
	@inject public var mediatorMap:IMediatorMap;

	public function new() {}

	public function initialize():Void {
		/*document.body.addEventListener("DOMNodeInserted", function(event:MutationEvent) {
				addView(untyped event.target);
			}, false);

			document.body.addEventListener("DOMNodeRemoved", function(event:MutationEvent) {
				removeView(untyped event.target);
		}, false);*/
	}

	/*public function addView(view:Element):Void {
			mediateChildren(view);
		}

		function mediateChildren(view:Element) {
			for (i in 0...view.childElementCount) {
				mediateChildren(view.children.item(i));
			}
			var container:IDomContainer = untyped view.container;
			if (container != null) {
				mediatorMap.mediate(container);
			}
		}

		public function removeView(view:Element):Void {
			unmediateChildren(view);
		}

		function unmediateChildren(view:Element) {
			for (i in 0...view.childElementCount) {
				unmediateChildren(view.children.item(i));
			}
			var container:IDomContainer = untyped view.container;
			if (container != null) {
				mediatorMap.unmediate(container);
			}
	}*/
	public function addView(view:IDomContainer):Void {
		if (view != null) {
			view.onAddChild.add(addView);
			view.onRemoveChild.add(removeView);
			for (child in view.children) {
				addView(child);
			}

			mediatorMap.mediate(view);
		}
	}

	public function removeView(view:IDomContainer):Void {
		if (view != null) {
			view.onAddChild.remove(addView);
			view.onRemoveChild.remove(removeView);
			for (child in view.children) {
				removeView(child);
			}

			mediatorMap.unmediate(view);
		}
	}
}
