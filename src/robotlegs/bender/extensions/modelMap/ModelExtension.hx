package robotlegs.bender.extensions.modelMap;

import robotlegs.bender.extensions.modelMap.api.IModelMap;
import robotlegs.bender.extensions.modelMap.impl.ModelMap;
import robotlegs.bender.extensions.matching.InstanceOfType;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;
import robotlegs.bender.framework.api.IInjector;
import org.swiftsuspenders.InjectionEvent;

/**
 * ...
 * @author P.J.Shand
 */
class ModelExtension implements IExtension {
	private var _injector:IInjector;

	public function new() {}

	public function extend(context:IContext):Void {
		_injector = context.injector;
		_injector.map(IModelMap).toSingleton(ModelMap);
	}
}
