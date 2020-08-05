package robotlegs.bender.extensions.logicMap.api;

import robotlegs.bender.extensions.logicMap.impl.LogicMap.SignalA;
import robotlegs.bender.extensions.logicMap.impl.LogicMap.SignalB;
import haxe.extern.EitherType;

/**
 * @author P.J.Shand
 */
interface ILogicMap {
	function map(type:Class<ILogic>, initialize:EitherType<Bool, EitherType<SignalA, SignalB>> = true):ILogic;
}
