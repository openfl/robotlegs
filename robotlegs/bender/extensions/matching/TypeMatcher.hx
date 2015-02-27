//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.matching;

/**
 * A Type Matcher matches objects that satisfy type matching rules
 */

@:keepSub
class TypeMatcher implements ITypeMatcher implements ITypeMatcherFactory
{

	/*============================================================================*/
	/* private Properties                                                       */
	/*============================================================================*/

	private var _allOfTypes = new Array<Class<Dynamic>>();

	private var _anyOfTypes = new Array<Class<Dynamic>>();

	private var _noneOfTypes = new Array<Class<Dynamic>>();

	private var _typeFilter:ITypeFilter;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * All types that an item must extend or implement
	 */
	
	public function allOf(types:Array<Dynamic>):TypeMatcher
	{
		pushAddedTypesTo(types, _allOfTypes);
		return this;
	}

	/**
	 * Any types that an item must extend or implement
	 */
	public function anyOf(types:Array<Dynamic>):TypeMatcher
	{
		pushAddedTypesTo(types, _anyOfTypes);
		return this;
	}

	/**
	 * Types that an item must not extend or implement
	 */
	public function noneOf(types:Array<Dynamic>):TypeMatcher
	{
		pushAddedTypesTo(types, _noneOfTypes);
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function createTypeFilter():ITypeFilter
	{
		// calling this seals the matcher
		// CHECK
		if (_typeFilter == null) {
			_typeFilter = buildTypeFilter();
		}
		return _typeFilter;
		
		//return _typeFilter ||= buildTypeFilter();
	}

	/**
	 * Locks this type matcher
	 * @return
	 */
	public function lock():ITypeMatcherFactory
	{
		createTypeFilter();
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function clone():TypeMatcher
	{
		return new TypeMatcher().allOf(_allOfTypes).anyOf(_anyOfTypes).noneOf(_noneOfTypes);
	}

	/*============================================================================*/
	/* private Functions                                                        */
	/*============================================================================*/

	private function buildTypeFilter():ITypeFilter
	{
		if ((_allOfTypes.length == 0) &&
			(_anyOfTypes.length == 0) &&
			(_noneOfTypes.length == 0))
		{
			throw new TypeMatcherError(TypeMatcherError.EMPTY_MATCHER);
		}
		return new TypeFilter(_allOfTypes, _anyOfTypes, _noneOfTypes);
	}

	private function pushAddedTypesTo(types:Array<Dynamic>, targetSet:Array<Class<Dynamic>>):Void
	{
		if (_typeFilter != null) throwSealedMatcherError();

		pushValuesToClassVector(types, targetSet);
	}

	private function throwSealedMatcherError():Void
	{
		throw new TypeMatcherError(TypeMatcherError.SEALED_MATCHER);
	}

	private function pushValuesToClassVector(values:Array<Dynamic>, vector:Array<Class<Dynamic>>):Void
	{
		var isArray = Std.is(values[0], Array);
		
		//var isClass = Std.is(values[0], Array<Class<Dynamic>>);
		if (values.length == 1 && (isArray))
		{
			var array = cast(values[0], Array<Dynamic>);
			for (type in array)
			{
				vector.push(type);
			}
		}
		else
		{
			for (type in values)
			{
				vector.push(type);
			}
		}
	}
}