package robotlegs.bender.extensions.modelMap.impl;

import robotlegs.bender.extensions.modelMap.api.IModelMap;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IInjector;
import org.swiftsuspenders.utils.DescribedType;
import org.swiftsuspenders.mapping.InjectionMapping;
import haxe.Timer;
#if notifier
import notifier.Notifier;
#end
#if html5
import js.Browser;
#end

/**
 * ...
 * @author P.J.Shand
 */
class ModelMap implements IModelMap implements DescribedType {
	@inject public var injector:IInjector;

	var types:Array<ModelDef> = [];
	var keys:Array<NotifierDef> = [];
	var timerActive:Bool = false;
	var initialized:Bool = false;

	public function new(context:IContext) {
		#if js
		if (initialized)
			return;
		initialized = true;
		untyped Object.defineProperties(Window.prototype, {
			"notifiers": {
				get: listModels
			},
		});
		#end
	}

	function listModels() {
		#if js
		keys.sort((f1, f2) -> {
			if (f1.parent > f2.parent)
				return 1;
			else if (f1.parent < f2.parent)
				return -1;
			if (f1.name > f2.name)
				return 1;
			else if (f1.name < f2.name)
				return -1;
			else
				return 0;
		});
		Browser.console.table(keys);
		#end
	}

	public function map(type:Class<Dynamic>, key:String = null):InjectionMapping {
		#if js
		if (timerActive == false) {
			timerActive = true;
			Timer.delay(addToWindow, 100);
		}
		types.push({
			type: type,
			key: key
		});
		#end

		return injector.map(type);
	}

	#if js
	function addToWindow() {
		for (modelDef in types) {
			var type = modelDef.type;

			var instance = injector.getInstance(type);
			var name:String = modelDef.key;
			if (name == null) {
				var fullName:String = Reflect.getProperty(type, "__name__");
				var split:Array<String> = fullName.split(".");
				name = split[split.length - 1];
				if (name != null && name != "") {
					var a = name.split("");
					name = a.join("");
				}
			}

			addProp(name, instance);

			#if notifier
			for (field in Reflect.fields(instance)) {
				var prop = Reflect.getProperty(instance, field);
				if (Std.is(prop, Notifier)) {
					addProp(field, prop, 0, name);
				}
			}
			#end
		}
		timerActive = false;
		types = [];
	}

	function addProp(key:String, value:Dynamic, suffix:Int = 0, parentName:String = null) {
		var key1:String = key;
		if (suffix > 0)
			key1 = key + suffix;

		var currentValue = Reflect.getProperty(js.Browser.window, key1);
		if (currentValue == null) {
			Reflect.setProperty(js.Browser.window, key1, value);
			if (parentName != null) {
				keys.push({
					parent: parentName,
					name: key1
				});
			}
		} else {
			// trace("prop " + key + " already exists");
			addProp(key, value, ++suffix);
			if (parentName != null) {
				keys.push({
					parent: parentName,
					name: key
				});
			}
		}
	}
	#end
}

typedef ModelDef = {
	type:Class<Dynamic>,
	?key:String
}

typedef NotifierDef = {
	parent:String,
	name:String
}
