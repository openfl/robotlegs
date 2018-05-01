package robotlegs.bender.extensions.logicMap.impl;

import robotlegs.bender.extensions.logicMap.api.ILogic;
import robotlegs.bender.extensions.logicMap.api.ILogicMap;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IInjector;

/**
 * ...
 * @author P.J.Shand
 */
@:rtti
class LogicMap implements ILogicMap
{
	@inject public var injector:IInjector;
	
	public function new(context:IContext) 
	{
		
	}
	
	/* INTERFACE robotlegs.bender.extensions.logicMap.api.ILogicMap */
	
	public function map(type:Class<ILogic>, autoInitialize:Bool=true):Void 
	{
		injector.map(type).asSingleton();
		
		if (autoInitialize){
			var instance:ILogic = injector.getInstance(type);
			instance.initialize();
		}
	}
	
}