package robotlegs.bender.extensions.display.dom;

import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;
import robotlegs.bender.extensions.display.dom.api.IDomViewMap;
import robotlegs.bender.extensions.display.dom.impl.DomViewMap;

/**
 * ...
 * @author P.J.Shand
 */
@:keepSub
class DomExtension implements IExtension {
	static var INSTALLED:Bool = false;

	public function new() {}

	public function extend(context:IContext):Void {
		if (INSTALLED)
			return;
		context.injector.map(IDomViewMap).toSingleton(DomViewMap);
		var domViewMap:IDomViewMap = context.injector.getInstance(IDomViewMap);
		domViewMap.initialize();

		INSTALLED = true;
	}
}
