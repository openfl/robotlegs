//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.mxml;

import openfl.display.DisplayObjectContainer;
import flash.utils.setTimeout;
import mx.core.IMXMLObject;
import org.swiftsuspenders.reflection.DescribeTypeRTTIReflector;
import org.swiftsuspenders.reflection.Reflector;
import robotlegs.bender.extensions.contextView.ContextView;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;
import robotlegs.bender.framework.impl.Context;

class ContextBuilderTag implements IMXMLObject
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	private var _configs:Array<Dynamic> = [];
	public var configs(get, set):Array<Dynamic>;
	/**
	 * Configs, extensions or bundles
	 */
	public function get_configs():Array<Dynamic>;
	{
		return _configs;
	}

	/**
	 * Configs, extensions or bundles
	 */
	
	public function set_configs(value:Array<Dynamic>):Array<Dynamic>
	{
		_configs = value;
		return _configs;
	}

	private var _contextView:DisplayObjectContainer;
	public var contextView(null, set):Array<Dynamic>;
	/**
	 * The context view
	 * @param value
	 */
	public function set_contextView(value:DisplayObjectContainer):DisplayObjectContainer
	{
		_contextView = value;
		return _contextView;
	}

	private var _context:IContext = new Context();
	public var context(get, null):Array<Dynamic>;
	/**
	 * The context associated with this builder
	 */
	public function get_context():IContext
	{
		return _context;
	}

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _reflector:Reflector = new DescribeTypeRTTIReflector();

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @inheritDoc
	 */
	public function initialized(document:Dynamic, id:String):Void
	{
		// CHECK
		if (_contextView == null) _contextView = cast(document, DisplayObjectContainer);
		
		//_contextView ||= cast(document, DisplayObjectContainer);
		// if the contextView is bound it will only be set a frame later
		setTimeout(configureBuilder, 1);
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	private function configureBuilder():Void
	{
		for each (var config:Dynamic in _configs)
		{
			isExtension(config)
				? _context.install(config)
				: _context.configure(config);
		}

		_contextView && _context.configure(new ContextView(_contextView));
		_configs.length = 0;
	}

	private function isExtension(object:Dynamic):Bool
	{
		var isIExtension = Std.is(object, IExtension);
		var isClass = Std.is(object, Class);
		var implementsIExtension = _reflector.typeImplements(cast(object, Class), IExtension);
		
		if (!isIExtension) {
			if (isClass) {
				return implementsIExtension;
			}
			else {
				return isClass;
			}
		}
		else {
			return isIExtension;
		}
		//return (Std.is(object, IExtension)) || (Std.is(object, Class) && _reflector.typeImplements(cast(object, Class), IExtension));
	}
}
