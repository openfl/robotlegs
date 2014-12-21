//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.matching;

import flash.utils.getQualifiedClassName;

/**
 * @private
 */
class TypeFilter implements ITypeFilter
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	private var _allOfTypes:Array<Class>;

	/**
	 * @inheritDoc
	 */
	public function get allOfTypes():Array<Class>
	{
		return _allOfTypes;
	}

	private var _anyOfTypes:Array<Class>;

	/**
	 * @inheritDoc
	 */
	public function get anyOfTypes():Array<Class>
	{
		return _anyOfTypes;
	}

	private var _noneOfTypes:Array<Class>;

	/**
	 * @inheritDoc
	 */
	public function get noneOfTypes():Array<Class>
	{
		return _noneOfTypes;
	}

	private var _descriptor:String;

	/**
	 * @inheritDoc
	 */
	public function get descriptor():String
	{
		return _descriptor ||= createDescriptor();
	}

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function new(allOf:Array<Class>, anyOf:Array<Class>, noneOf:Array<Class>)
	{
		if (allOf == null || anyOf == null || noneOf == null)
			throw ArgumentError('TypeFilter parameters can not be null');
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
		while (i--)
		{
			if (!(item is _allOfTypes[i]))
			{
				return false;
			}
		}

		i = _noneOfTypes.length;
		while (i--)
		{
			if (item is _noneOfTypes[i])
			{
				return false;
			}
		}

		if (_anyOfTypes.length == 0 && (_allOfTypes.length > 0 || _noneOfTypes.length > 0))
		{
			return true;
		}

		i = _anyOfTypes.length;
		while (i--)
		{
			if (item is _anyOfTypes[i])
			{
				return true;
			}
		}

		return false;
	}

	/*============================================================================*/
	/* private Functions                                                        */
	/*============================================================================*/

	private function alphabetiseCaseInsensitiveFCQNs(classVector:Array<Class>):Array<String>
	{
		var fqcn:String;
		var allFCQNs:Array<String> = new <String>[];

		var iLength:UInt = classVector.length;
		for (var i:UInt = 0; i < iLength; i++)
		{
			fqcn = getQualifiedClassName(classVector[i]);
			allFCQNs[allFCQNs.length] = fqcn;
		}

		allFCQNs.sort(stringSort);
		return allFCQNs;
	}

	private function createDescriptor():String
	{
		var allOf_FCQNs:Array<String> = alphabetiseCaseInsensitiveFCQNs(allOfTypes);
		var anyOf_FCQNs:Array<String> = alphabetiseCaseInsensitiveFCQNs(anyOfTypes);
		var noneOf_FQCNs:Array<String> = alphabetiseCaseInsensitiveFCQNs(noneOfTypes);
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