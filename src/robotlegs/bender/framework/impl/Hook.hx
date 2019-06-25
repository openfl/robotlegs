package robotlegs.bender.framework.impl;

import haxe.extern.EitherType;

typedef Hook = EitherType<HookFunction, Hook1>;
typedef Hook1 = EitherType<HookObject, HookClass>;
typedef HookFunction = Void->Void;

typedef HookObject = {
	function hook():Void;
}

typedef HookClass = Class<HookObject>;
