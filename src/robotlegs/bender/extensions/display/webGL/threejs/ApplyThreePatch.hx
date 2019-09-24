package robotlegs.bender.extensions.display.webGL.threejs;

import js.three.Scene;
import js.three.Object3D;
import js.Lib;

class ApplyThreePatch {
	public static function execute(scene:Scene) {
		addDispatchSceneEvent(scene);
		injectExtraAddCode();
		injectExtraRemoveCode();
	}

	static function addDispatchSceneEvent(scene:Scene) {
		untyped Object3D.prototype.dispatchSceneEvent = function(object:Dynamic, event:Dynamic) {
			if (object == scene) {
				object.dispatchEvent(event);
			} else if (object.parent != null) {
				object.parent.dispatchSceneEvent(object.parent, event);
			}
		};
	}

	static function injectExtraAddCode() {
		var add = untyped Object3D.prototype.add;
		var addStr:String = add.toString();
		var addLines:Array<String> = addStr.split("\n");
		for (i in 0...addLines.length) {
			var index:Int = addLines[i].indexOf("object.dispatchEvent");
			if (index != -1) {
				var newLine:String = "";
				for (i in 0...index)
					newLine += "\t";
				newLine += "object.dispatchSceneEvent(object, { type: 'add_child', child:object } );";
				addLines.insert(i + 1, newLine);
				break;
			}
		}
		addStr = addLines.join("\n");
		add = Lib.eval("var f = function(){ return " + addStr + ";}; f() ;");
		untyped Object3D.prototype.add = add;
	}

	static function injectExtraRemoveCode() {
		var remove = untyped Object3D.prototype.remove;
		var removeStr:String = remove.toString();

		var removeLines:Array<String> = removeStr.split("\n");
		for (i in 0...removeLines.length) {
			var index:Int = removeLines[i].indexOf("object.dispatchEvent");
			if (index != -1) {
				var newLine:String = "";
				for (i in 0...index)
					newLine += "\t";
				newLine += "object.dispatchSceneEvent(object, { type: 'remove_child', child:object } );";
				removeLines.insert(i + 1, newLine);
				break;
			}
		}
		removeStr = removeLines.join("\n");
		remove = Lib.eval("var f = function(){ return " + removeStr + ";}; f() ;");
		untyped Object3D.prototype.remove = remove;
	}
}
