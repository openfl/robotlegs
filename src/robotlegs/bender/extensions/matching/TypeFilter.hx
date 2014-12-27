//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.matching;
import openfl.errors.ArgumentError;

/**
 * @private
 */
class TypeFilter implements ITypeFilter
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	private var _allOfTypes:Array<Class<Dynamic>>;
	public var allOfTypes(get, null):Array<Class<Dynamic>>;
	/**
	 * @inheritDoc
	 */
	public function get_allOfTypes():Array<Class<Dynamic>>
	{
		return _allOfTypes;
	}

	private var _anyOfTypes:Array<Class<Dynamic>>;
	public var anyOfTypes(get, null):Array<Class<Dynamic>>;
	/**
	 * @inheritDoc
	 */
	public function get_anyOfTypes():Array<Class<Dynamic>>
	{
		return _anyOfTypes;
	}

	private var _noneOfTypes:Array<Class<Dynamic>>;
	public var noneOfTypes(get, null):Array<Class<Dynamic>>;
	/**
	 * @inheritDoc
	 */
	public function get_noneOfTypes():Array<Class<Dynamic>>
	{
		return _noneOfTypes;
	}

	private var _descriptor:String;
	public var descriptor(get, null):String;
	/**
	 * @inheritDoc
	 */
	public function get_descriptor():String
	{
		// CHECK
		if (_descriptor == null) _descriptor = createDescriptor();
		return _descriptor;
		
		//return _descriptor ||= createDescriptor();
	}

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function new(allOf:Array<Class<Dynamic>>, anyOf:Array<Class<Dynamic>>, noneOf:Array<Class<Dynamic>>)
	{
		if (allOf == null || anyOf == null || noneOf == null)
			throw new ArgumentError('TypeFilter parameters can not be null');
		_allOfTypes = allOf;
		_anyOfTypes = anyOf;
		_noneOfTypes = noneOf;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @inheritDoc
	 */
	public function matches(item:Dynamic):Bool
	{
		var i:UInt = _allOfTypes.length;
		while (i-- > 0)
		{
			if (!(Std.is(item, _allOfTypes[i])))
			{
				return false;
			}
		}

		i = _noneOfTypes.length;
		while (i-- > 0)
		{
			if (Std.is(item, _noneOfTypes[i]))
			{
				return false;
			}
		}

		if (_anyOfTypes.length == 0 && (_allOfTypes.length > 0 || _noneOfTypes.length > 0))
		{
			return true;
		}

		i = _anyOfTypes.length;
		while (i-- > 0)
		{
			if (Std.is(item, _anyOfTypes[i]))
			{
				return true;
			}
		}

		return false;
	}

	/*============================================================================*/
	/* private Functions                                                        */
	/*============================================================================*/

	private function alphabetiseCaseInsensitiveFCQNs(classVector:Array<Class<Dynamic>>):Array<String>
	{
		var fqcn:String;
		var allFCQNs = new Array<String>();

		var iLength:UInt = classVector.length;
		for (i in 0...iLength)
		{
			fqcn = Type.getClassName(classVector[i]);
			allFCQNs[allFCQNs.length] = fqcn;
		}

		allFCQNs.sort(stringSort);
		return allFCQNs;
	}

	private function createDescriptor():String
	{
		var allOf_FCQNs = alphabetiseCaseInsensitiveFCQNs(allOfTypes);
		var anyOf_FCQNs = alphabetiseCaseInsensitiveFCQNs(anyOfTypes);
		var noneOf_FQCNs = alphabetiseCaseInsensitiveFCQNs(noneOfTypes);
		return "all of: " + allOf_FCQNs.toString()
			+ ", any of: " + anyOf_FCQNs.toString()
			+ ", none of: " + noneOf_FQCNs.toString();
	}

	private function stringSort(item1:String, item2:String):Int
	{
		if (item1 < item2)
		{
			return 1;
		}
		return -1;
	}
}