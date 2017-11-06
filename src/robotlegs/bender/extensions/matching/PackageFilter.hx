//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.matching;
import org.swiftsuspenders.utils.CallProxy;

/**
 * A filter that describes a package matcher
 */

@:keepSub
class PackageFilter implements ITypeFilter
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	private var _descriptor:String;
	public var descriptor(get_descriptor, null):String;
	/**
	 * @inheritDoc
	 */
	function get_descriptor():String
	{
		// CHECK
		if (_descriptor == null) _descriptor = createDescriptor();
		return _descriptor;
		//return _descriptor ||= createDescriptor();
	}

	/**
	 * @inheritDoc
	 */
	public var allOfTypes(get_allOfTypes, null):Array<Class<Dynamic>>;
	function get_allOfTypes():Array<Class<Dynamic>>
	{
		return emptyVector;
	}

	/**
	 * @inheritDoc
	 */
	public var anyOfTypes(get_anyOfTypes, null):Array<Class<Dynamic>>;
	function get_anyOfTypes():Array<Class<Dynamic>>
	{
		return emptyVector;
	}

	/**
	 * @inheritDoc
	 */
	public var noneOfTypes(get_noneOfTypes, null):Array<Class<Dynamic>>;
	function get_noneOfTypes():Array<Class<Dynamic>>
	{
		return emptyVector;
	}

	/*============================================================================*/
	/* private Properties                                                       */
	/*============================================================================*/

	private var emptyVector:Array<Class<Dynamic>> = new Array<Class<Dynamic>>();

	private var _requirePackage:String;

	private var _anyOfPackages:Array<String>;

	private var _noneOfPackages:Array<String>;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * Creates a new Package Filter
	 * @param requiredPackage
	 * @param anyOfPackages
	 * @param noneOfPackages
	 */
	public function new(requiredPackage:String, anyOfPackages:Array<String>, noneOfPackages:Array<String>)
	{
		_requirePackage = requiredPackage;
		_anyOfPackages = anyOfPackages;
		_noneOfPackages = noneOfPackages;
		_anyOfPackages.sort(stringSort);
		_noneOfPackages.sort(stringSort);
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @inheritDoc
	 */
	public function matches(item:Dynamic):Bool
	{
		var fqcn:String = Type.getClassName(item);
		var packageName:String;

		if (_requirePackage != null && (!matchPackageInFQCN(_requirePackage, fqcn)))
			return false;

		for (packageName in _noneOfPackages)
		{
			if (matchPackageInFQCN(packageName, fqcn))
				return false;
		}

		for (packageName in _anyOfPackages)
		{
			if (matchPackageInFQCN(packageName, fqcn))
				return true;
		}
		if (_anyOfPackages.length > 0)
			return false;

		if (_requirePackage != null)
			return true;

		if (_noneOfPackages.length > 0)
			return true;

		return false;
	}

	/*============================================================================*/
	/* private Functions                                                        */
	/*============================================================================*/

	private function stringSort(item1:String, item2:String):Int
	{
		if (item1 > item2)
		{
			return 1;
		}
		return -1;
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	private function createDescriptor():String
	{
		return "require: " + _requirePackage
			+ ", any of: " + _anyOfPackages.toString()
			+ ", none of: " + _noneOfPackages.toString();
	}

	private function matchPackageInFQCN(packageName:String, fqcn:String):Bool
	{
		return (fqcn.indexOf(packageName) == 0);
	}
}