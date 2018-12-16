package robotlegs.bender.extensions.logicMap.api;

/**
 * @author P.J.Shand
 */
interface ILogicMap 
{
	function map(type:Class<ILogic>, autoInitialize:Bool=true):ILogic;
}