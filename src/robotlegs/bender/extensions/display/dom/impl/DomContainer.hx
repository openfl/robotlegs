package robotlegs.bender.extensions.display.dom.impl;

#if macro
class DomContainer {}
#else
import signals.Signal1;
import js.html.*;
import robotlegs.bender.extensions.display.dom.api.IDomContainer;
import js.Browser;
import js.Browser.document;
import js.Browser.window;

class DomContainer implements IDomContainer {
	public var view:Element;
	public var id(get, set):String;
	public var className(get, set):String;
	public var style(get, null):CSSStyleDeclaration;
	public var innerText(get, set):String;
	public var innerHTML(get, set):String;
	public var outerHTML(get, set):String;
	public var numChildren(get, null):Int;

	var _onPress:Signal1<MouseEvent>;
	var _onRelease:Signal1<MouseEvent>;
	var _onOver:Signal1<MouseEvent>;
	var _onOut:Signal1<MouseEvent>;

	public var onPress(get, null):Signal1<MouseEvent>;
	public var onRelease(get, null):Signal1<MouseEvent>;
	public var onOver(get, null):Signal1<MouseEvent>;
	public var onOut(get, null):Signal1<MouseEvent>;
	public var onAddChild = new Signal1<IDomContainer>();
	public var onRemoveChild = new Signal1<IDomContainer>();
	public var children:Array<DomContainer> = [];
	public var removeOnTransition(get, set):Bool;
	public var hidePolicy:HidePolicy = HidePolicy.REMOVE;

	var parentElement:Element;
	var added:Bool = false;

	// var document(get, null):HTMLDocument;
	// var window(get, null):Window;
	// var parentElements = new Map<Element, Element>();
	@:isVar public var parent(default, null):DomContainer;
	@:isVar public var alpha(default, set):Float = 1;
	@:isVar public var visible(default, set):Null<Bool> = true;

	public function new(?className:String, ?view:Element = null) {
		if (view == null) {
			view = Browser.document.createDivElement();
		}

		this.view = view;
		if (this.view != null) {
			untyped this.view.container = this;
		}
		if (className != null) {
			this.className = className;
		}
	}

	public function initialize():Void {
		//
	}

	public function addChild(child:DomContainer):Void {
		children.remove(child);
		children.push(child);

		child.parent = this;
		child.parentElement = view;
		if (child.visible) {
			child.added = true;
			view.appendChild(child.view);
		}
		onAddChild.dispatch(child);
	}

	public function removeChild(child:DomContainer):Void {
		children.remove(child);
		try {
			child.parentElement = null;
			child.added = false;
			child.view.remove();
		} catch (e:Dynamic) {
			trace(e);
		}
		onRemoveChild.dispatch(child);
	}

	public function dispose():Void {
		for (child in children) {
			child.dispose();
		}
	}

	public function addElement(element:js.html.Element):Void {
		// element.parentElement = view;
		view.appendChild(element);
	}

	public function removeElement(element:js.html.Element):Void {
		try {
			// element.parentElement = null;
			element.remove();
		} catch (e:Dynamic) {
			trace(e);
		}
	}

	function get_id():String {
		return view.id;
	}

	function set_id(value:String):String {
		if (value == null) {
			view.removeAttribute("id");
		} else {
			view.id = value;
		}
		return value;
	}

	function get_className():String {
		return view.className;
	}

	function set_className(value:String):String {
		if (value == null) {
			view.removeAttribute("class");
		} else {
			view.className = value;
		}
		return value;
	}

	@:keep function get_style():CSSStyleDeclaration {
		return view.style;
	}

	@:keep function set_alpha(value:Float):Float {
		this.alpha = value;
		this.style.opacity = Std.string(alpha);
		return this.alpha;
	}

	@:keep function set_visible(value:Bool):Bool {
		if (this.visible == value)
			return value;
		this.visible = value;

		if (hidePolicy == HidePolicy.REMOVE) {
			if (parentElement != null) {
				if (visible) {
					if (!added) {
						added = true;
						dispatch(view, 'DOMNodeInserted');
						parentElement.appendChild(view);
					}
				} else {
					if (added) {
						added = false;
						parentElement.removeChild(view);
					}
				}
			}
		} else if (hidePolicy == HidePolicy.VISIBILITY) {
			if (visible) {
				view.style.visibility = 'inherit';
			} else {
				view.style.visibility = 'hidden';
			}
		} else if (hidePolicy == HidePolicy.DISPLAY) {
			if (visible) {
				view.style.display = 'inherit';
			} else {
				view.style.display = 'none';
			}
		}

		return value;
	}

	function dispatch(element:Element, eventStr:String) {
		var event:Event = null;

		try {
			event = new Event(eventStr);
		} catch (e:Dynamic) {
			try {
				event = js.Browser.document.createEvent('Event');
				event.initEvent('eventStr', true, true);
			} catch (e:Dynamic) {
				//
			}
		}

		if (event != null) {
			element.dispatchEvent(event);
		}

		for (child in element.children) {
			dispatch(child, eventStr);
		}
	}

	function get_innerText():String {
		return view.innerText;
	}

	function set_innerText(value:String):String {
		return view.innerText = value;
	}

	function get_innerHTML():String {
		return view.innerHTML;
	}

	function set_innerHTML(value:String):String {
		if (value != null) {
			value = value.split("\n").join("<br/>");
		}
		return view.innerHTML = value;
	}

	function get_outerHTML():String {
		return view.outerHTML;
	}

	function set_outerHTML(value:String):String {
		return view.outerHTML = value;
	}

	public function addEventListener(type:String, listener:haxe.Constraints.Function, ?options:haxe.extern.EitherType<AddEventListenerOptions, Bool>,
			?wantsUntrusted:Bool):Void {
		view.addEventListener(type, listener, options, wantsUntrusted);
	}

	public function removeEventListener(type:String, listener:haxe.Constraints.Function, ?options:haxe.extern.EitherType<AddEventListenerOptions, Bool>):Void {
		view.removeEventListener(type, listener, options);
	}

	public function dispatchEvent(event:Event):Void {
		view.dispatchEvent(event);
	}

	function get_numChildren():Int {
		return children.length;
	}

	function getChildByIndex(index:Int):DomContainer {
		return children[index];
	}

	@:keep function get_onPress() {
		if (_onPress == null) {
			_onPress = new Signal1<MouseEvent>();
			view.addEventListener("mousedown", _onPress.dispatch);
		}
		return _onPress;
	}

	@:keep function get_onRelease() {
		if (_onRelease == null) {
			_onRelease = new Signal1<MouseEvent>();
			view.addEventListener("mouseup", _onRelease.dispatch);
		}
		return _onRelease;
	}

	@:keep function get_onOver() {
		if (_onOver == null) {
			_onOver = new Signal1<MouseEvent>();
			view.addEventListener("mouseover", _onOver.dispatch);
		}
		return _onOver;
	}

	@:keep function get_onOut() {
		if (_onOut == null) {
			_onOut = new Signal1<MouseEvent>();
			view.addEventListener("mouseout", _onOut.dispatch);
		}
		return _onOut;
	}

	function get_document():HTMLDocument {
		return document;
	}

	function get_window():Window {
		return window;
	}

	function get_removeOnTransition():Bool {
		return hidePolicy == HidePolicy.REMOVE;
	}

	function set_removeOnTransition(value:Bool):Bool {
		if (value) {
			hidePolicy = HidePolicy.REMOVE;
		} else {
			hidePolicy = HidePolicy.VISIBILITY;
		}
		return removeOnTransition;
	}
}
#end
