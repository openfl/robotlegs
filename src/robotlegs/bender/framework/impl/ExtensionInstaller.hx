//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------
package robotlegs.bender.framework.impl;

import org.swiftsuspenders.InjectorMacro;
import org.swiftsuspenders.utils.CallProxy;
import robotlegs.bender.framework.api.IBundle;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.ILogger;
import robotlegs.bender.framework.api.IExtension;
import robotlegs.bender.framework.api.IExtension.IExtension_Or_Class;
import haxe.ds.ObjectMap;

/**
 * Installs custom extensions into a given context
 *
 * @private
 */
@:keepSub
class ExtensionInstaller {
	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/
	private var _classes = new ObjectMap<Dynamic, Bool>();

	private var _context:IContext;

	private var _logger:ILogger;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/
	/**
	 * @private
	 */
	public function new(context:IContext) {
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
	public function install(extension:IExtension_Or_Class):Void {
		if (extension == null)
			return;
		if (Std.isOfType(extension, Class))
			installClass(extension);
		else {
			var iextension:IExtension = extension;
			installInstance(iextension);
		}
	}

	inline function installClass(extension:Class<IExtension>) {
		if (_classes.get(extension) == true)
			return;

		var extensionInstance = Type.createInstance(extension, []);
		installInstance(extensionInstance);
		InjectorMacro.keep(extensionInstance); // check if this line is still needed
	}

	inline function installInstance(extension:IExtension) {
		var extensionClass:Class<IExtension> = Type.getClass(extension);
		if (_classes.get(extensionClass) == true)
			return;
		_classes.set(extensionClass, true);

		_logger.debug("Installing extension {0}", [Type.getClassName(extensionClass)]);

		if (extension.extend != null) {
			extension.extend(_context);
		}
	}

	/**
	 * Destroy
	 */
	public function destroy():Void {
		for (_class in _classes.keys()) {
			_classes.remove(_class);
		}
	}
}
