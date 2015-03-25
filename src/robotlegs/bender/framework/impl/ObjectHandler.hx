package robotlegs.bender.framework.impl;

import robotlegs.bender.framework.api.IMatcher;

/**
 * ...
 * @author P.J.Shand
 */
@:keepSub
class ObjectHandler
{
	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _matcher:IMatcher;
	private var _handler:Dynamic;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function new(matcher:IMatcher, handler:Dynamic)
	{
		_matcher = matcher;
		_handler = handler;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function handle(object:Dynamic):Void
	{
		if (_matcher.matches(object)) {
			_handler(object);
		}
	}
}