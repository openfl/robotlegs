package robotlegs.bender.extensions.display.stage3D.away3d.impl; 

import away3d.cameras.Camera3D;
import away3d.containers.View3D;
import away3d.core.managers.Stage3DManager;
import away3d.core.managers.Stage3DProxy;
import away3d.events.Stage3DEvent;
import away3d.stereo.HmdInfo;
import away3d.stereo.methods.SBSStereoRenderMethod;
import away3d.stereo.StereoCamera3D;
import away3d.stereo.StereoView3D;
import com.imagination.texturePacker.impl.math.PowerOf2;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.geom.Vector3D;
import openfl.Vector;
import robotlegs.bender.extensions.display.base.api.ILayer;
import robotlegs.bender.extensions.display.base.api.IRenderContext;
import robotlegs.bender.extensions.display.base.api.IRenderer;

/**
 * ...
 * @author P.J.Shand
 */
class AwayStereoLayer extends StereoView3D implements ILayer implements IAwayLayer
{
	@:isVar public var renderContext(get, set):IRenderContext;
	
	private var stage3DManager:Stage3DManager;
	private var profile:String;
	private var sbsStereoRenderMethod:SBSStereoRenderMethod;
	private var stereoCamera3D:StereoCamera3D;
	private var currentRect:Rectangle;
	
	private var _lensCenterOffsetX:Float = 0;
	private var _lensCenterOffsetY:Float = 0;
	
	private var rect = new Rectangle();
	
	public function new(profile:String, contextIndex:Int=0) 
	{
		super(null, null, null, null, false, profile, contextIndex);
		this.profile = profile;
		
		stereoCamera3D = new StereoCamera3D();
		stereoCamera3D.stereoOffset = 10;
		stereoCamera3D.position = new Vector3D();
		
		this.shareContext = true;
		
		this.antiAlias = 0;
		this.camera = stereoCamera3D;
		
		this.stereoEnabled = true;
		
		addEventListener(Event.ADDED_TO_STAGE, OnAdd);
	}
	
	private function OnAdd(e:Event):Void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, OnAdd);
		
		var hmdInfo:HmdInfo = new HmdInfo();
		hmdInfo.hScreenSize = stage.stageWidth;
		hmdInfo.vScreenSize = stage.stageHeight;
		hmdInfo.vScreenCenter = 0.046799998730421066; 
		hmdInfo.eyeToScreenDistance = 0.04100000113248825;
		hmdInfo.lensSeparationDistance = 0.06350000202655792;
		hmdInfo.interPupillaryDistance = 0.06400000303983688;
		hmdInfo.hResolution = 1280;
		hmdInfo.vResolution = 800;
		hmdInfo.distortionK = new Vector<Float>();
		hmdInfo.distortionK.push(1);
		hmdInfo.distortionK.push(0.2199999988079071);
		hmdInfo.distortionK.push(0.23999999463558197);
		hmdInfo.distortionK.push(0);

		hmdInfo.chromaAbCorrection = new Vector<Float>();
		hmdInfo.chromaAbCorrection.push(0.9959999918937683);
		hmdInfo.chromaAbCorrection.push(-0.004000000189989805);
		hmdInfo.chromaAbCorrection.push(1.0140000581741333);
		hmdInfo.chromaAbCorrection.push(0);
		
		var dk:Vector<Float> = hmdInfo.distortionK;
		
		//sbsStereoRenderMethod = new SBSStereoRenderMethod(0.5 + (_lensCenterOffsetX/2), 0.5, 3.12, 0.25, dk[0], dk[1], dk[2], dk[3]);
		
		var lensCenterX:Float = 0.5 - (_lensCenterOffsetX / 2);
		var lensCenterY:Float = 0.5;
		var scaleInX:Float = 1.79;// 2.41;
		var scaleInY:Float = 3.15;
		var scaleX:Float = 0.50;// 0.25;
		var scaleY:Float = 0.25;
		var hmdWarpParamX:Float = dk[0];
		var hmdWarpParamY:Float = dk[1];
		var hmdWarpParamZ:Float = dk[2];
		var hmdWarpParamW:Float = dk[3];
		
		sbsStereoRenderMethod = new SBSStereoRenderMethod();
		//sbsStereoRenderMethod = new SBSStereoRenderMethod(lensCenterX, lensCenterY, scaleInX, scaleInY, scaleX, scaleY, hmdWarpParamX, hmdWarpParamY, hmdWarpParamZ, hmdWarpParamW);
		//sbsStereoRenderMethod.enableBarrelDistortion = false;
		
		this.stereoRenderMethod = sbsStereoRenderMethod;
		
		//#if flash
		//this.rightClickMenuEnabled = false;
		//#end
		
		//stage3DManager = Stage3DManager.getInstance(this.stage);
		//_stage3DProxy = stage3DManager.getStage3DProxy(0, false, profile);
		//_stage3DProxy.enableDepthAndStencil = true;
		//_stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_CREATED, onContextCreated);
		//_stage3DProxy.antiAlias = antiAlias;
	}
	
	public function process():Void
	{
		this.render();
		_mouse3DManager.fireMouseEvents();
		_touch3DManager.fireTouchEvents();
	}
	
	override private function set_stereoEnabled(val:Bool):Bool {
        _stereoEnabled = val;
		if (stage3DProxy != null) {
			setTo(rect.x, rect.y, rect.width, rect.height);
		}
		return val;
    }
	
	public function setTo(x:Float, y:Float, width:Float, height:Float):Void
	{
		rect.setTo(x, y, width, height);
		
		if (stereoEnabled == true){
			width = PowerOf2.next(cast width);
			height = PowerOf2.next(cast height);
		}
		if (width > 1024) width = 1024;
		if (height > 1024) height = 1024;
		
		this.x = stage3DProxy.x = x;
		this.y = stage3DProxy.y = y;
		this.width = width;
		this.height = height;
		stage3DProxy.width = cast width;
		stage3DProxy.height = cast height;
	}
	
	private function onContextCreated(e:Event):Void 
	{
		
	}
	
	private function set_renderContext(value:IRenderContext):IRenderContext 
	{
		renderContext = value;
		if (stage3DProxy != null) stage3DProxy.antiAlias = value.antiAlias;
		return value;
	}
	
	private function get_renderContext():IRenderContext 
	{
		return renderContext;
	}
	override private function set_stage3DProxy(stage3DProxy:Stage3DProxy) : Stage3DProxy
    {
		if (renderContext != null) stage3DProxy.antiAlias = renderContext.antiAlias;
		return super.set_stage3DProxy(stage3DProxy);
	}
}