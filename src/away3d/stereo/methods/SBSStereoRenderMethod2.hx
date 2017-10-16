/**
 * SBSStereoRenderMethod.as
 * 
 * Written by Bibek Sahu, 22-Jan-2013
 * Based on "InterleavedStereoRenderMethod.as", from Away3D-4.1Alpha
 * License is the same as "InterleavedStereoRenderMethod.as", which is Apache-2.0 as of this writing
 * @see http://www.apache.org/licenses/LICENSE-2.0.html
 * @see http://away3d.com/
 */
package away3d.stereo.methods;

import away3d.core.managers.RTTBufferManager;
import away3d.core.managers.Stage3DProxy;
import away3d.debug.Debug;
import away3d.stereo.methods.StereoRenderMethodBase;
import openfl.Vector;

import flash.display3D.Context3DProgramType;

class SBSStereoRenderMethod2 extends StereoRenderMethodBase
{
	private var _shaderData : Vector<Float>;
	private var rttManager:RTTBufferManager;
	
	public var lensCenterX:Float;
	public var lensCenterY:Float;
	
	public var scaleInX:Float;
	public var scaleInY:Float;
	
	public var scaleX:Float;
	public var scaleY:Float;
	
	public var hmdWarpParamX:Float;
	public var hmdWarpParamY:Float;
	public var hmdWarpParamZ:Float;
	public var hmdWarpParamW:Float;
	public var enableBarrelDistortion:Bool = true;
	
	public function new(lensCenterX:Float, lensCenterY:Float, scaleInX:Float, scaleInY:Float, scaleX:Float, scaleY:Float, hmdWarpParamX:Float, hmdWarpParamY:Float, hmdWarpParamZ:Float, hmdWarpParamW:Float)
	{
		super();
		
		this.lensCenterX = lensCenterX * 100;
		this.lensCenterY = lensCenterY * 100;
		this.scaleInX = scaleInX * 100;
		this.scaleInY = scaleInY * 100;
		this.scaleX = scaleX * 100;
		this.scaleY = scaleY * 100;
		this.hmdWarpParamX = hmdWarpParamX * 100;
		this.hmdWarpParamY = hmdWarpParamY * 100;
		this.hmdWarpParamZ = hmdWarpParamZ * 100;
		this.hmdWarpParamW = hmdWarpParamW * 100;
		
		_shaderData = Vector.ofArray([1.0,1,1,1, 1,1,1,1]);
	}
	
	
	override public function activate(stage3DProxy:Stage3DProxy):Void
	{
		//fc0
		_shaderData[0] = 2.0;	// scale constant, to stretch / shrink x-axis by 2
		_shaderData[1] = 1.0;
		_shaderData[2] = 1.0;
		_shaderData[3] = 1.0;
		
		//fc1 x y
		_shaderData[4] = -.5;	// scale constant, to stretch / shrink x-axis by -0.5
		_shaderData[5] = 0;
		//_shaderData[6] = 0;
		//_shaderData[7] = 0;
		
		if (_textureSizeInvalid) {
			rttManager = RTTBufferManager.getInstance(stage3DProxy);
			_textureSizeInvalid = false;
			
			trace(rttManager.viewWidth, rttManager.textureWidth);
			
			//fc1 z w
			_shaderData[6] = ((rttManager.viewWidth / rttManager.textureWidth) - 1) / 2;
			//_shaderData[7] = ((rttManager.viewWidth / rttManager.textureWidth) - 1) / -2;
			
			trace(_shaderData[6]);
		}
		
		// Barrel Distortion ///////////////////////////////////////
		
		
		
		//fc2
		_shaderData[8] = lensCenterX / 100;
		_shaderData[9] = lensCenterY / 100;
		_shaderData[10] = scaleInX / 100;
		_shaderData[11] = scaleInY / 100;
		
		//fc3
		_shaderData[12] = hmdWarpParamX / 100;
		_shaderData[13] = hmdWarpParamY / 100;
		_shaderData[14] = hmdWarpParamZ / 100;
		_shaderData[15] = hmdWarpParamW / 100;
		
		//fc4
		_shaderData[16] = scaleX / 100;
		_shaderData[17] = scaleY / 100;
		_shaderData[18] = 0;
		_shaderData[19] = 0;
		
		stage3DProxy.context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, _shaderData);
	}
	
	
	override public function deactivate(stage3DProxy:Stage3DProxy):Void
	{
		stage3DProxy.context3D.setTextureAt(2, null);
	}
	
	
	override public function getFragmentCode():String
	{
		var code:String = "";
		
		code +=	"";
		
		code +=	"mov ft0, v1\n";							// scale: ft0.x = v1.x * 2; ft0.yzw = v1.yzw;
		code +=	"mul ft0, ft0, fc0\n";						// scale: ft0.x = v1.x * 2; ft0.yzw = v1.yzw;
		code +=	"add ft0.x, ft0.x, fc1.z\n"; 
		if (enableBarrelDistortion) code +=	barrelDistortionFragmentCode("ft0");
		//if (enableBarrelDistortion) code +=	barrelDistortionFragmentCode2("ft0");
		code +=	"tex ft0, ft0, fs0 <2d,linear,nomip>\n";	// ft0 = getColorAt(texture=fs0, position=ft0)
		
		/*code +=	"add ft1, v1, fc1\n";						// translate: ft1.x = v1.x + -.5; ft1.yzw = v1.yzw;
		code +=	"mul ft1, ft1, fc0\n";						// scale: ft1.x = ft1.x * 2; ft1.yzw = ft1.yzw;
		code +=	"add ft1.x, ft1.x, fc1.w\n";
		//if (enableBarrelDistortion) code +=	barrelDistortionFragmentCode("ft1");
		if (enableBarrelDistortion) code +=	barrelDistortionFragmentCode2("ft1");
		code +=	"tex ft1, ft1, fs1 <2d,linear,nomip>\n";	// ft1 = getColorAt(texture=fs1, position=ft1)
		
		code +=	"add oc, ft0, ft1";	*/
		
		code +=	"mov oc, ft0";
		
		//code +=	"mov oc, ft1";
		//trace("code = " + code);
		return code;
	}
	
	private function barrelDistortionFragmentCode2(ftReg:String) : String
	{
		var code:String = "";
		//code += "sub " + ftReg + ".y, " + ftReg + ".y, fc3.y 	\n";
		//code += "sin " + ftReg + ".x, " + ftReg + ".x 	\n";
		//code += "add " + ftReg + ".y, " + ftReg + ".y, fc3.y 	\n";
		
		
		return 	code;
	}
	
	private function barrelDistortionFragmentCode(ftReg:String) : String
	{
		return 	"sub " + ftReg + ".xy, " + ftReg + ".xy, fc2.xy 	\n" +
			"mul " + ftReg + ".xy, " + ftReg + ".xy, fc2.zw 	\n" +
			"mul ft2.x, " + ftReg + ".x, " + ftReg + ".x 		\n" +
			"mul ft2.y, " + ftReg + ".y, " + ftReg + ".y 		\n" +
			"add ft3.x, ft2.x, ft2.y 		\n" +
			"mul ft3.y, ft3.x, ft3.x 		\n" +
			"mul ft3.z, ft3.y, ft3.x 		\n" +
			"mul ft4.x, fc3.y, ft3.x 		\n" +
			"mul ft4.y, fc3.z, ft3.y 		\n" +
			"mul ft4.z, fc3.w, ft3.z 		\n" +
			"add ft4.w, fc3.x, ft4.x 		\n" +
			"add ft5.x, ft4.w, ft4.y 		\n" +
			"add ft5.y, ft5.x, ft4.z 		\n" +
			"mul " + ftReg + ".xy, " + ftReg + ".xy, ft5.yy 	\n" +
			"mul " + ftReg + ".xy, " + ftReg + ".xy, fc4.xy 	\n" +
			"add " + ftReg + ".xy, fc2.xy, " + ftReg + ".xy 	\n";// +
			
			//"tex ft1, ft0.xy, fs0 <2d,linear,clamp>	\n" +
			
			//"mov oc, ft1";
	}
}