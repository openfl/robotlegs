//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.matching;
import org.swiftsuspenders.utils.CallProxy;

/**
 * @private
 */

@:keepSub
class TypeFilter implements ITypeFilter
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/
	
	/**
	 * @inheritDoc
	 */
	//private var _allOfTypes:Array<Class<Dynamic>>;
	public var allOfTypes(get, null):Array<Class<Dynamic>>;
	public function get_allOfTypes():Array<Class<Dynamic>>
	{
		return this.allOfTypes;
	}
	
	/**
	 * @inheritDoc
	 */
	//private var _anyOfTypes:Array<Class<Dynamic>>;
	public var anyOfTypes(get, null):Array<Class<Dynamic>>;
	public function get_anyOfTypes():Array<Class<Dynamic>>
	{
		return this.anyOfTypes;
	}

	/**
	 * @inheritDoc
	 */
	//private var _noneOfTypes:Array<Class<Dynamic>>;
	public var noneOfTypes(get, null):Array<Class<Dynamic>>;
	public function get_noneOfTypes():Array<Class<Dynamic>>
	{
		return this.noneOfTypes;
	}

	/**
	 * @inheritDoc
	 */
	//private var _descriptor:String;
	public var descriptor(get, null):String;
	public function get_descriptor():String
	{
		// CHECK
		if (this.descriptor == null) this.descriptor = createDescriptor();
		return this.descriptor;
		
		//return this.descriptor ||= createDescriptor();
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
			throw 'TypeFilter parameters can not be null';
		this.allOfTypes = allOf;
		this.anyOfTypes = anyOf;
		this.noneOfTypes = noneOf;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @inheritDoc
	 */
	public function matches(item:Dynamic):Bool
	{
		var i:UInt = this.allOfTypes.length;
		while (i-- > 0)
		{
			if (!(Std.is(item, this.allOfTypes[i])))
			{
				return false;
			}
		}

		i = this.noneOfTypes.length;
		while (i-- > 0)
		{
			if (Std.is(item, this.noneOfTypes[i]))
			{
				return false;
			}
		}

		if (this.anyOfTypes.length == 0 && (this.allOfTypes.length > 0 || this.noneOfTypes.length > 0))
		{
			return true;
		}

		i = this.anyOfTypes.length;
		while (i-- > 0)
		{
			if (Std.is(item, this.anyOfTypes[i]))
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