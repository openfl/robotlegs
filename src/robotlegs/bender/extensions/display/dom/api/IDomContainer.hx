package robotlegs.bender.extensions.display.dom.api;

import signals.Signal1;
import js.html.Element;
import robotlegs.bender.extensions.display.dom.impl.DomContainer;

interface IDomContainer {
	var parent(default, null):DomContainer;
	var view:Element;
	var children:Array<DomContainer>;
	var removeOnTransition:Bool;
	var onAddChild:Signal1<IDomContainer>;
	var onRemoveChild:Signal1<IDomContainer>;
	function initialize():Void;
}
