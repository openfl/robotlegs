package robotlegs.bender.extensions.config;

import robotlegs.bender.extensions.logicMap.impl.Logic;
import robotlegs.bender.extensions.config.IConfigModel;
import js.Browser;

/**
 * ...
 * @author P.J.Shand
 */
class QueryStringLogic extends Logic {
	@inject public var configModel:IConfigModel;

	var map = new Map<String, String>();

	override public function initialize() {
		var search:String = Browser.window.location.search;
		if (search == '')
			return;

		var split1:Array<String> = search.split("?");
		var hashes:Array<String> = split1[1].split("&");
		for (i in 0...hashes.length) {
			var item = hashes[i];
			var split:Array<String> = item.split("=");
			map.set(split[0], split[1]);
		}

		for (key in map.keys()) {
			try {
				Reflect.setProperty(configModel, key, map.get(key));
			} catch (e:Dynamic) {}
		}
	}
}
