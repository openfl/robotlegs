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
class LogicMap implements ILogicMap implements DescribedType
{
	@inject public var injector:IInjector;
	
	public function new(context:IContext) 
	{
		
	}
	
	public function map(type:Class<ILogic>, initialize:EitherType<Bool, Signal>=true):ILogic 
	{
		injector.map(type).asSingleton();
		
		var instance:ILogic = injector.getInstance(type);
		
		if (Std.is(initialize, Bool)){
			if (initialize == true) instance.initialize();
		} else {
			var initSignal:Signal = initialize;
			if (initSignal != null){
				initSignal.add(() -> {
					instance.initialize();
				});
			}
		}
		
		return instance;
	}
}

typedef Signal =
{
	function dispatch():Void;
	function add(callback:Void -> Void):Void;
}