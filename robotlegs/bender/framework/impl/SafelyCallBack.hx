//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl;
import openfl.errors.Error;

class SafelyCallBack 
{
	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * <p>Helper function to call any of the 3 forms of eventual callback:</p>
	 *
	 * <code>(), (error) and (error, message)</code>
	 *
	 * <p>NOTE: This helper will not handle null callbacks. You should check
	 * if the callback is null from the calling location:</p>
	 *
	 * <code>callback &amp;&amp; SafelyCallBack(callback, error, message);</code>
	 *
	 * <p>This prevents the overhead of calling SafelyCallBack()
	 * when there is no callback to call. Likewise it reduces the overhead
	 * of a null check in SafelyCallBack().</p>
	 *
	 * <p>QUESTION: Is this too harsh? Should we protect from null?</p>
	 *
	 * @param callback The actual callback
	 * @param error An optional error
	 * @param message An optional message
	 */

	public static function call(callback:Dynamic, errorMsg:Dynamic = null, message:Dynamic = null)
	{
		//callback(errorMsg, message);
		
		if (message != null) {
			try {
				callback(errorMsg, message);
			}
			catch( error : Error ) {
				try {
					callback(errorMsg);
				}
				catch( error2 : Error ) {
					try {
						callback();
					}
					catch( error3 : Error ) {
						trace("Error calling CallBack : " + error3 );
					}
				}
			}
		}
		else if (errorMsg != null) {
			try {
				callback(errorMsg);
			}
			catch( error2 : Error ) {
				try {
					callback();
				}
				catch( error3 : Error ) {
					trace("Error calling CallBack : " + error3 );
				}
			}
		}
		
		try {
			callback(errorMsg, message);
		}
		catch( error : Error ) {
			try {
				callback(errorMsg);
			}
			catch( error2 : Error ) {
				try {
					callback();
				}
				catch( error3 : Error ) {
					trace("Error calling CallBack : " + error3 );
				}
			}
		}
	}
}
