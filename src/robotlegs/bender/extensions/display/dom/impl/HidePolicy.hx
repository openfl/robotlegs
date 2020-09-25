package robotlegs.bender.extensions.display.dom.impl;

@:enum abstract HidePolicy(String) from String to String {
	var REMOVE = "REMOVE";
	var DISPLAY = "DISPLAY";
	var VISIBILITY = "VISIBILITY";
}
