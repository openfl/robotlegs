package robotlegs.bender.extensions.modelMap.api;

import org.swiftsuspenders.mapping.InjectionMapping;

/**
 * @author P.J.Shand
 */
interface IModelMap {
	function map(type:Class<Dynamic>, key:String = null):InjectionMapping;
}
