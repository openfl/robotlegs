//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewProcessorMap.utils;

import robotlegs.bender.framework.api.IInjector;

/**
 * Avoids view reflection by using a provided map
 * of property names to dependency types
 */
@:keepSub
class FastPropertyInjector
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _propertyTypesByName:Dynamic;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * Creates a Fast Property Injection Processor
	 *
	 * <code>
	 *     new FastPropertyInjector({
	 *         userService: IUserService,
	 *         userPM: UserPM
	 *     })
	 * </code>
	 *
	 * @param propertyTypesByName A map of property names to dependency types
	 */
	public function new(propertyTypesByName:Dynamic)
	{
		_propertyTypesByName = propertyTypesByName;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function process(view:Dynamic, type:Class<Dynamic>, injector:IInjector):Void
	{
		var fields = Reflect.fields(_propertyTypesByName);
		for (propName in fields) {
			Reflect.setProperty(view, propName, injector.getInstance(Reflect.getProperty(_propertyTypesByName, propName)));
		}
		/*for (propName in _propertyTypesByName)
		{
			view[propName] = injector.getInstance(_propertyTypesByName[propName]);
		}*/
	}

	/**
	 * @private
	 */
	public function unprocess(view:Dynamic, type:Class<Dynamic>, injector:IInjector):Void
	{
	}
}