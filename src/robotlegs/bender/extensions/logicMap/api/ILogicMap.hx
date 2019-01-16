package robotlegs.bender.extensions.logicMap.api;

import robotlegs.bender.extensions.logicMap.impl.LogicMap.Signal;

/**
 * @author P.J.Shand
 */
interface ILogicMap 
{
	function map(type:Class<ILogic>, initialize:EitherType<Bool, Signal>=true):ILogic;
}