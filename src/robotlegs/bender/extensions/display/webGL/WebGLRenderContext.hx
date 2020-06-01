package robotlegs.bender.extensions.display.webGL;

import robotlegs.signal.Signal.Signal0;
import openfl.display.BitmapData;
import openfl.events.ErrorEvent;
import openfl.events.Event;
import org.swiftsuspenders.utils.DescribedType;
import robotlegs.bender.extensions.contextView.ContextView;
import robotlegs.bender.extensions.display.base.api.ILayers;
import robotlegs.bender.extensions.display.base.api.IRenderContext;
import robotlegs.bender.extensions.display.base.api.IViewport;
import robotlegs.bender.extensions.display.webGL.WebGLInitOptions;

/**
 * ...
 * @author P.J.Shand
 */
class WebGLRenderContext implements DescribedType implements IRenderContext {
	@inject public var contextView:ContextView;
	@inject public var viewport:IViewport;
	@inject public var layers:ILayers;

	public var contextDisposeChange = new Signal0();
	@:isVar public var contextDisposed(default, set):Null<Bool>;

	@:isVar public var onReady(default, null):Signal0 = new Signal0();
	public var available(get, null):Bool;

	public var antiAlias:Int = 1;

	public function new() {}

	public function setup(options:Dynamic):Void {
		layers.renderContext = this;

		// contextDisposeChange.add(OnContextDisposedChange);

		var initOptions:WebGLInitOptions = cast options;
		this.antiAlias = initOptions.antiAlias;

		viewport.onChange.add(OnViewportChange);
		viewport.setTo(0, 0, contextView.view.stage.stageWidth, contextView.view.stage.stageHeight);

		contextDisposed = false;
		onReady.dispatch();
	}

	function set_contextDisposed(value:Null<Bool>):Null<Bool> {
		if (contextDisposed == value)
			return value;
		contextDisposed = value;
		contextDisposeChange.dispatch();
		return contextDisposed;
	}

	private function contextCreatedErrorHandler(e:ErrorEvent):Void {
		/*trace("Can't Create Context3D");
			#if html5
			trace('make sure <haxedef if="html5" name="dom"/> is set');
			#end */
	}

	private function OnViewportChange():Void {
		/*stage3D.x = viewport.x;
			stage3D.y = viewport.y;

			if (context3D != null) {
				if (context3D.driverInfo == "Disposed") return;
				var width:Int = cast viewport.width;
				if (width < 64) width = 64;
				var height:Int = cast viewport.height;
				if (height < 64) height = 64;
				try {
					context3D.configureBackBuffer(width, height, antiAlias, true);
				}
				catch (e:Error) {
					trace("e = " + e);
					return;
				}
		}*/
	}

	public function get_available():Bool {
		/*if (_stage3D == null) return false;
			if (context3D == null) return false;
			if (context3D.driverInfo == "Disposed") {
				contextDisposed = true;
				return false;
		}*/
		return true;
	}

	public function begin():Void {}

	public function end():Void {}

	public function checkVisability():Void {}

	public function snap(x:Int, y:Int, width:Int, height:Int):BitmapData {
		trace("not implemented on in html5");
		return null;
	}
}
