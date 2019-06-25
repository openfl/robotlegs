package robotlegs.bender.framework.impl;

import haxe.extern.EitherType;

typedef Guard = EitherType<GuardFunction, Guard1>;
typedef Guard1 = EitherType<GuardObject, GuardClass>;
typedef GuardFunction = Void->Bool;

typedef GuardObject = {
	function approve():Bool;
}

typedef GuardClass = Class<GuardObject>;
