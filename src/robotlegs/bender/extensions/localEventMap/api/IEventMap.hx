//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.localEventMap.api;

import openfl.events.IEventDispatcher;

/**
 * The Event Map keeps track of listeners and provides the ability
 * to unregister all listeners with a single method call.
 */
interface IEventMap
{
	/**
	 * The same as calling <code>addEventListener</code> directly on the <code>IEventDispatcher</code>,
	 * but keeps a list of listeners for easy (usually automatic) removal.
	 *
	 * @param dispatcher The <code>IEventDispatcher</code> to listen to
	 * @param type The <code>Event</code> type to listen for
	 * @param listener The <code>Event</code> handler
	 * @param eventClass Optional Event class for a stronger mapping. Defaults to <code>flash.events.Event</code>.
	 * @param useCapture
	 * @param priority
	 * @param useWeakReference
	 */
	function mapListener(dispatcher:IEventDispatcher, type:String, listener:Void->Void, eventClass:Class<Dynamic> = null, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = true):Void;

	/**
	 * The same as calling <code>removeEventListener</code> directly on the <code>IEventDispatcher</code>,
	 * but updates our local list of listeners.
	 *
	 * @param dispatcher The <code>IEventDispatcher</code>
	 * @param type The <code>Event</code> type
	 * @param listener The <code>Event</code> handler
	 * @param eventClass Optional Event class for a stronger mapping. Defaults to <code>flash.events.Event</code>.
	 * @param useCapture
	 */
	function unmapListener(dispatcher:IEventDispatcher, type:String, listener:Void->Void, eventClass:Class<Dynamic> = null, useCapture:Bool = false):Void;

	/**
	 * Removes all listeners registered through <code>mapListener</code>
	 */
	function unmapListeners():Void;

	/**
	 * Suspends all listeners registered through <code>mapListener</code>
	 */
	function suspend():Void;

	/**
	 * Resumes all listeners registered through <code>mapListener</code>
	 */
	function resume():Void;
}