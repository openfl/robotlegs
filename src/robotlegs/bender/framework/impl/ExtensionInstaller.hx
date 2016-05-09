//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl;


import org.swiftsuspenders.utils.CallProxy;
import org.swiftsuspenders.utils.UID;
import robotlegs.bender.framework.api.IBundle;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.ILogger;

/**
 * Installs custom extensions into a given context
 *
 * @private
 */
@:keepSub
class ExtensionInstaller
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _classes = new Map<String,Bool>();

	private var _context:IContext;

	private var _logger:ILogger;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function new(context:IContext)
	{
		_context = context;
		_logger = _context.getLogger(this);
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * Installs the supplied extension
	 * @param extension An object or class implementing IExtension
	 */
	public function install(extension:Dynamic):Void
	{
		if (Std.is(extension, Class))
		{
			var extensionInstance = CallProxy.createInstance(extension, []);
			install(extensionInstance);
		}
		else
		{
			var id = UID.instanceID(extension);
			var extensionClass:Class<Dynamic> = Type.getClass(extension);
			if (_classes[id] == true){
				return;
			}
			_logger.debug("Installing extension {0}", [id]);
			_classes[id] = true;
			
			var hasExtendField = CallProxy.hasField(extension, "extend");
			
			if (hasExtendField == true) {
				
				extension.extend(_context);
			}
		}
	}

	/**
	 * Destroy
	 */
	public function destroy():Void
	{
		var fields = Reflect.fields (_classes);
		for (propertyName in fields) {
			_classes.remove(propertyName);
		}
	}
}
