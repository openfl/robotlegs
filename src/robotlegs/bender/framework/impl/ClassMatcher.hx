package robotlegs.bender.framework.impl;

import robotlegs.bender.framework.api.IMatcher;

/**
 * ...
 * @author P.J.Shand
 */
@:keepSub
class ClassMatcher implements IMatcher {
	public function new() {}

	public function matches(item:Dynamic):Bool {
		return Std.isOfType(item, Class);
	}
}
