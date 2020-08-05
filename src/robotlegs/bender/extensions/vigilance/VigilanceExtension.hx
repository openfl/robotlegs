//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------
package robotlegs.bender.extensions.vigilance;

import org.swiftsuspenders.errors.InjectorError;
import org.swiftsuspenders.mapping.MappingEvent;
import org.swiftsuspenders.utils.DescribedType;
import robotlegs.bender.extensions.enhancedLogging.impl.LogMessageParser;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;
import robotlegs.bender.framework.api.ILogTarget;
import robotlegs.bender.framework.api.LogLevel;
import robotlegs.bender.extensions.vigilance.VigilantError;

/**
 * The Vigilance Extension throws Errors when warnings are logged.
 */
@:keepSub
class VigilanceExtension implements IExtension implements ILogTarget {
	public function new() {}

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/
	private var _messageParser:LogMessageParser = new LogMessageParser();

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/
	/**
	 * @inheritDoc
	 */
	public function extend(context:IContext):Void {
		context.injector.instantiateUnmapped(MetadataChecker).check();
		context.addLogTarget(this);
		context.injector.addEventListener(MappingEvent.MAPPING_OVERRIDE, mappingOverrideHandler);
	}

	/**
	 * @inheritDoc
	 */
	public function log(source:Dynamic, level:UInt, timestamp:Float, message:String, params:Array<Dynamic> = null):Void {
		if (level <= LogLevel.WARN) {
			/*throw */
			new VigilantError(_messageParser.parseMessage(message, params));
		}
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/
	private function mappingOverrideHandler(event:MappingEvent):Void {
		/*throw */
		new InjectorError("Injector mapping override for type " + event.mappedType + " with name " + event.mappedName);
	}
}
