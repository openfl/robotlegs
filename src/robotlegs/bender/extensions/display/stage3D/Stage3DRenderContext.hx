package robotlegs.bender.extensions.display.stage3D;

import flash.display3D.Context3DProfile;
import flash.display3D.Context3DRenderMode;
import msignal.Signal.Signal0;
import openfl.display.BitmapData;
import openfl.display.Stage3D;
import openfl.display3D.Context3D;
import openfl.display3D.Context3DCompareMode;
import openfl.display3D.Context3DStencilAction;
import openfl.display3D.Context3DTriangleFace;
import openfl.errors.Error;
import openfl.events.ErrorEvent;
import openfl.events.Event;
import openfl.geom.Rectangle;
import org.swiftsuspenders.utils.DescribedType;
import robotlegs.bender.extensions.contextView.ContextView;
import robotlegs.bender.extensions.display.base.api.ILayers;
import robotlegs.bender.extensions.display.base.api.IRenderContext;
import robotlegs.bender.extensions.display.base.api.IViewport;

/**
 * ...
 * @author P.J.Shand
 */
class Stage3DRenderContext extends DescribedType implements IRenderContext
{
	@inject public var contextView:ContextView;
	@inject public var viewport:IViewport;
	@inject public var layers:ILayers;
	
	public var contextDisposeChange = new Signal0();
	@:isVar public var contextDisposed(default, set):Null<Bool>;
	
	@:isVar public var onReady(default, null):Signal0 = new Signal0();
	@:isVar public var stage3D(default, null):Stage3D;
	@:isVar public var context3D(default, null):Context3D;
	@:isVar public var profile(default, null):Context3DProfile;
	public var available(get, null):Bool;
	
	public var antiAlias:Int;
	private var freeFreeStage3DIndex:Int = 0;
	var currentDimensions = new Rectangle();
	var scissorRectangle = new Rectangle();
	
	public function new() { }
	
	public function setup(options:Dynamic):Void
	{
		layers.renderContext = this;
		
		contextDisposeChange.add(OnContextDisposedChange);
		
		var initOptions:Stage3DInitOptions = cast options;
		this.antiAlias = initOptions.antiAlias;
		profile = initOptions.profile;
		
		if (initOptions.stage3DIndex != null) {
			stage3D = contextView.view.stage.stage3Ds[initOptions.stage3DIndex];
		}
		else {
			stage3D = contextView.view.stage.stage3Ds[freeFreeStage3DIndex];
		}
		
		stage3D.addEventListener(Event.CONTEXT3D_CREATE, contextCreatedHandler);
		stage3D.addEventListener(ErrorEvent.ERROR, contextCreatedErrorHandler);
		
		#if flash
			stage3D.requestContext3D(Context3DRenderMode.AUTO, profile);
		#else
			stage3D.requestContext3D(Std.string(Context3DRenderMode.AUTO));
		#end
		freeFreeStage3DIndex++;
		checkVisability();
	}
	
	function OnContextDisposedChange() 
	{
		
	}
	
	function set_contextDisposed(value:Null<Bool>):Null<Bool> 
	{
		if (contextDisposed == value) return value;
		contextDisposed = value;
		contextDisposeChange.dispatch();
		return contextDisposed;
	}
	
	private function contextCreatedHandler(e:Event):Void 
	{
		context3D = stage3D.context3D;
		
		context3D.configureBackBuffer(contextView.view.stage.stageWidth, contextView.view.stage.stageHeight, antiAlias, true);
		trace("DriverInfo: " + context3D.driverInfo + " AntiAlias: " + antiAlias);
		
		context3D.setStencilActions(
			cast Context3DTriangleFace.FRONT_AND_BACK,
			cast Context3DCompareMode.EQUAL, 
			cast Context3DStencilAction.DECREMENT_SATURATE
		);
		
		viewport.onChange.add(OnViewportChange);
		viewport.setTo(0, 0, contextView.view.stage.stageWidth, contextView.view.stage.stageHeight);
		
		contextDisposed = false;
		onReady.dispatch();
	}
	
	private function contextCreatedErrorHandler(e:ErrorEvent):Void 
	{
		trace("Can't Create Context3D: " + e.toString());
		#if html5
		trace('make sure <haxedef if="html5" name="dom"/> is set');
		#end
	}
	
	private function OnViewportChange():Void 
	{
		if (currentDimensions.x == viewport.x &&
		currentDimensions.y == viewport.y &&
		currentDimensions.width == viewport.width &&
		currentDimensions.height == viewport.height) {
			return;
		}
		
		stage3D.x = viewport.x;
		stage3D.y = viewport.y;
		
		if (context3D != null) {
			if (context3D.driverInfo == "Disposed") return;
			var width:Int = cast viewport.width;
			if (width < 64) width = 64;
			var height:Int = cast viewport.height;
			if (height < 64) height = 64;
			try {
				//trace(["RESIZE", width, height, antiAlias]);
				context3D.configureBackBuffer(width, height, antiAlias, true);
			}
			catch (e:Error) {
				trace("e = " + e);
				return;
			}
			
			scissorRectangle.setTo(0, 0, width, height);
			context3D.setScissorRectangle(scissorRectangle);
		}
		currentDimensions.setTo(viewport.x, viewport.y, viewport.width, viewport.height);
	}
	
	public function get_available():Bool
	{
		if (stage3D == null) return false;
		if (context3D == null) return false;
		if (context3D.driverInfo == "Disposed") {
			contextDisposed = true;
			return false;
		}
		return true;
	}
	
	public function begin():Void
	{
		context3D.clear(viewport.red / 255, viewport.green / 255, viewport.blue / 255);
	}
	
	public function end():Void
	{
		context3D.present();
	}
	
	public function snap(width:Int, height:Int):BitmapData
	{
		var bmd:BitmapData = new BitmapData(width, height, false, 0xFF0000);
		context3D.drawToBitmapData(bmd);
		return bmd;
	}
	
	public function checkVisability():Void
	{
		if (stage3D == null) return;
		#if flash
			// only apply for flash, as openfl does this in Stage3D.hx
			if (layers.numLayers == 0) stage3D.visible = false;
			else stage3D.visible = true;
		#end
	}
	
	public function killContext():Void
	{
		context3D.dispose();
	}
}