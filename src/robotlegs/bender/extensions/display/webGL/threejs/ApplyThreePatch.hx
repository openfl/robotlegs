package robotlegs.bender.extensions.display.webGL.threejs;

import three.scenes.Scene;

class ApplyThreePatch {
	public static function execute(scene:Scene) {
		addDispatchSceneEvent(scene);
		injectExtraAddCode();
		injectExtraRemoveCode();
	}

	static function addDispatchSceneEvent(scene:Scene) {
		untyped THREE.Object3D.prototype.dispatchSceneEvent = function(object:Dynamic, event:Dynamic) {
			if (object == scene) {
				object.dispatchEvent(event);
			} else if (object.parent != null) {
				object.parent.dispatchSceneEvent(object.parent, event);
			}
		};
	}

	static function injectExtraAddCode() {
		untyped js.Syntax.code("
		var add = THREE.Object3D.prototype.add;
		THREE.Object3D.prototype.add = function (object) {
			
			add.apply( this, arguments );
			object.dispatchSceneEvent(object, { type: 'add_child', child:object } );
		}
		");

	}

	static function injectExtraRemoveCode() {
		untyped js.Syntax.code("
		var remove = THREE.Object3D.prototype.remove;
		THREE.Object3D.prototype.remove = function (object) {
			
			remove.apply( this, arguments );
			object.dispatchSceneEvent(object, { type: 'remove_child', child:object } );
		}
		");

	}
}
