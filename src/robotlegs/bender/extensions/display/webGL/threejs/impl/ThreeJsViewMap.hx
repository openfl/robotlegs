// ------------------------------------------------------------------------------
// Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
// NOTICE: You are permitted to use, modify, and distribute this file
// in accordance with the terms of the license agreement accompanying it.
// ------------------------------------------------------------------------------
package robotlegs.bender.extensions.display.webGL.threejs.impl;

import three.scenes.Scene;
import org.swiftsuspenders.utils.DescribedType;
import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
import robotlegs.bender.extensions.display.base.api.IDisplayObject;
import robotlegs.bender.extensions.display.webGL.threejs.api.IThreeJsViewMap;
import robotlegs.bender.extensions.display.webGL.threejs.impl.ThreeJsCollection;
import robotlegs.bender.extensions.display.webGL.threejs.impl.ThreeJsLayer;
import three.core.Object3D;
import js.html.Event;

/**
 * The <code>ViewMap</code> class performs managing  scene and
 * views automatic mediation. When view is added or removed from scene, it will
 * automatically create or destroy its mediator.
 */
class ThreeJsViewMap implements DescribedType implements IThreeJsViewMap {
	/*============================================================================*/
	/* Public Properties                                                         */
	/*============================================================================*/
	// @inject
	/** Instance of View3D which contains scene receiving display objects. **/
	// public var view3D:View3D;

	/** Collection of Starling views which will receive display objects. **/
	@inject public var threeJsCollection:ThreeJsCollection;

	/** Map for mediating views. **/
	@inject public var mediatorMap:IMediatorMap;

	/*============================================================================*/
	/* Constructor
		/*============================================================================ */
	public function new() {}

	// FIX / CHECK
	@postConstruct
	// [PostConstruct]

	/**
	 * Initialize listeners on  scene.
	 */
	public function init():Void {
		for (v in threeJsCollection.items) {
			// listen for ObjectContainer3D events
			if (v == null)
				continue;
			var threeJsLayer:ThreeJsLayer = v;
			threeJsLayer.scene.addEventListener("add_child", onSceneAdded);
			threeJsLayer.scene.addEventListener("remove_child", onSceneRemoved);
			// add scene as view to allow a  Scene Mediator
			// Note:we don't support swapping scenes now - one scene will do.
			addView(threeJsLayer.scene);
		}
	}

	/*============================================================================*/
	/* Public Methods
		/*============================================================================ */
	/** @inheritDoc **/
	public function addView(view:Dynamic):Void {
		if (validateView(view)) {
			/*if (Std.is(view, IDisplayObject)) {

				var displayObject:IDisplayObject = view;
				displayObject.init();
			}*/

			mediatorMap.mediate(view);
		} else
			throw "Not sure what to do with this view type..";
	}

	/** @inheritDoc **/
	public function removeView(view:Dynamic):Void {
		/*if (Std.is(view, IDisplayObject)) {
			var displayObject:IDisplayObject = view;
			displayObject.destroy();
		}*/
		mediatorMap.unmediate(view);
	}

	/*============================================================================*/
	/* Private Methods
		/*============================================================================ */
	/**
	 * Validate if view added on scene is of type either <code>Scene3D</code> or
	 * <code>ObjectContainer3D</code>, and this is required since <code>Scene3D</code>
	 * doesn't extend <code>ObjectContainer3D</code>.
	 *
	 * @param view View that needs to be validated.
	 *
	 * @return Returns <code>true</code> if view is of valid type, or <code>false</code>
	 * otherwise.
	 */
	private function validateView(view:Dynamic):Bool {
		if (Std.is(view, Scene) || Std.is(view, Object3D)) {
			return true;
		} else
			return false;
	}

	/**
	 * Handle view added to scene.
	 *
	 * @param event View added to scene.
	 */
	private function onSceneAdded(event:Event):Void {
		var sceneEvent:SceneEvent = untyped event;
		addView(sceneEvent.child);
	}

	/**
	 * Handle view removed from scene.
	 *
	 * @param event View removed from scene.
	 */
	private function onSceneRemoved(event:Event):Void {
		var sceneEvent:SceneEvent = untyped event;
		removeView(sceneEvent.child);
	}
}

typedef SceneEvent = {
	type:String,
	child:Object3D,
}
