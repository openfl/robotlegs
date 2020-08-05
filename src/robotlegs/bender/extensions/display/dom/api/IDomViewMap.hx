package robotlegs.bender.extensions.display.dom.api;

import js.html.Element;

interface IDomViewMap {
	function initialize():Void;
	function addView(view:IDomContainer):Void;
	function removeView(view:IDomContainer):Void;
}
