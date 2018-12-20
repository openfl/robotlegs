package robotlegs.bender.extensions.logicMap.impl;

import org.swiftsuspenders.utils.DescribedType;
import robotlegs.bender.extensions.logicMap.api.ILogic;
import robotlegs.bender.extensions.logicMap.api.ILogicMap;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IInjector;

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
	
	/* INTERFACE robotlegs.bender.extensions.logicMap.api.ILogicMap */
	
	public function map(type:Class<ILogic>, autoInitialize:Bool=true):ILogic 
	{
		injector.map(type).asSingleton();
		
		var instance:ILogic = injector.getInstance(type);
		if (autoInitialize) instance.initialize();
		return instance;
	}
}