//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.api;

/**
 * Robotlegs object lifecycle state
 */
@:keepSub
class LifecycleState
{

	/*============================================================================*/
	/* Public Static Properties                                                   */
	/*============================================================================*/

	public static var UNINITIALIZED:String = "uninitialized";

	public static var INITIALIZING:String = "initializing";

	public static var ACTIVE:String = "active";

	public static var SUSPENDING:String = "suspending";

	public static var SUSPENDED:String = "suspended";

	public static var RESUMING:String = "resuming";

	public static var DESTROYING:String = "destroying";

	public static var DESTROYED:String = "destroyed";
}
