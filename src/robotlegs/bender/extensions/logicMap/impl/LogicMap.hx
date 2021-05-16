package robotlegs.bender.extensions.logicMap.impl;

import org.swiftsuspenders.utils.DescribedType;
import robotlegs.bender.extensions.logicMap.api.ILogic;
import robotlegs.bender.extensions.logicMap.api.ILogicMap;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IInjector;
import haxe.extern.EitherType;

/**
 * ...
 * @author P.J.Shand
 */
class LogicMap implements ILogicMap implements DescribedType {
	@inject public var injector:IInjector;

	public function new(context:IContext) {}

	public function map(type:Class<ILogic>, initialize:EitherType<Bool, EitherType<SignalA, SignalB>> = true):ILogic {
		injector.map(type).asSingleton();

		var instance:ILogic = injector.getInstance(type);

		if (Std.isOfType(initialize, Bool)) {
			if (initialize == true)
				instance.initialize();
		} else {
			var add = Reflect.getProperty(initialize, 'add');
			Reflect.callMethod(initialize, add, [
				()
			-> {
					instance.initialize();
				}
			]);
		}

		return instance;
	}
}

typedef SignalA = {
	function dispatch():Void;
	function add(callback:Void->Void):Void;
}

typedef SignalB = {
	function dispatch():Void;
	function add(callback:Void->Void, ?fireOnce:Bool, ?priority:Int, ?fireOnAdd:Null<Bool>):Void;
}
