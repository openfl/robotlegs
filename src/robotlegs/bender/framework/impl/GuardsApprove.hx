//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------
package robotlegs.bender.framework.impl;

import org.swiftsuspenders.utils.CallProxy;
import robotlegs.bender.framework.api.IInjector;
import robotlegs.bender.framework.impl.Guard;
import robotlegs.bender.framework.impl.Guard.GuardFunction;
import robotlegs.bender.framework.impl.Guard.GuardObject;
import robotlegs.bender.framework.impl.Guard.GuardClass;

@:keepSub
class GuardsApprove {
	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/
	/**
	 * <p>A guard can be a function, object or class.</p>
	 *
	 * <p>When a function is provided it is expected to return a Bool when called.</p>
	 *
	 * <p>When an object is provided it is expected to expose an "approve" method
	 * that returns a Bool.</p>
	 *
	 * <p>When a class is provided, an instance of that class will be instantiated and tested.
	 * If an injector is provided the instance will be created using that injector,
	 * otherwise the instance will be created manually.</p>
	 *
	 * @param guards An array of guards
	 * @param injector An optional Injector
	 *
	 * @return A Bool value of false if any guard returns false
	 */
	public static function call(guards:Array<Guard>, injector:IInjector = null):Bool {
		for (guard in guards) {
			if (Reflect.isFunction(guard)) {
				var guardFunction:GuardFunction = guard;
				if (guardFunction() == false)
					return false;
			} else {
				var guardObject:GuardObject = null;
				if (Std.is(guard, Class)) {
					var _GuardClass:GuardClass = guard;
					if (injector != null) {
						guardObject = injector.instantiateUnmapped(_GuardClass);
					} else {
						guardObject = Type.createInstance(guard, []);
					}
				} else {
					guardObject = guard;
				}
				if (guardObject != null) {
					if (guardObject.approve() == false)
						return false;
				}
			}
		}
		return true;
	}
}
