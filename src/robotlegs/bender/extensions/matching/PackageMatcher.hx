//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.matching;

import openfl.errors.IllegalOperationError;

/**
 * A Package Matcher matches types in a given package
 */

@:keepSub
class PackageMatcher implements ITypeMatcher
{

	/*============================================================================*/
	/* private Properties                                                       */
	/*============================================================================*/

	private var _anyOfPackages:Array<String> = new Array<String>();

	private var _noneOfPackages:Array<String> = new Array<String>();

	private var _requirePackage:String;

	private var _typeFilter:ITypeFilter;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @inheritDoc
	 */
	public function createTypeFilter():ITypeFilter
	{
		// CHECK
		if (_typeFilter == null) _typeFilter = buildTypeFilter();
		return _typeFilter;
		
		//return _typeFilter ||= buildTypeFilter();
	}

	/**
	 * The full package that is required
	 * @param fullPackage
	 * @return Self
	 */
	public function require(fullPackage:String):PackageMatcher
	{
		if (_typeFilter != null)
			throwSealedMatcherError();

		if (_requirePackage != null)
			throw new IllegalOperationError('You can only set one required package on this PackageMatcher (two non-nested packages cannot both be required, and nested packages are redundant.)');

		_requirePackage = fullPackage;
		return this;
	}

	/**
	 * Any packages that an item might be declared
	 */
	public function anyOf(packages:Array<Dynamic>):PackageMatcher
	{
		pushAddedPackagesTo(packages, _anyOfPackages);
		return this;
	}

	/**
	 * Packages that an item must not live in
	 */
	public function noneOf(packages:Array<Dynamic>):PackageMatcher
	{
		pushAddedPackagesTo(packages, _noneOfPackages);
		return this;
	}

	/**
	 * Locks this matcher
	 */
	public function lock():Void
	{
		createTypeFilter();
	}

	/*============================================================================*/
	/* private Functions                                                        */
	/*============================================================================*/

	private function buildTypeFilter():ITypeFilter
	{
		if (((_requirePackage == null) || _requirePackage.length == 0) && (_anyOfPackages.length == 0) && (_noneOfPackages.length == 0))
		{
			throw new TypeMatcherError(TypeMatcherError.EMPTY_MATCHER);
		}
		return new PackageFilter(_requirePackage, _anyOfPackages, _noneOfPackages);
	}

	private function pushAddedPackagesTo(packages:Array<Dynamic>, targetSet:Array<String>):Void
	{
		_typeFilter && throwSealedMatcherError();
		
		pushValuesToStringVector(packages, targetSet);
	}

	private function throwSealedMatcherError():Void
	{
		throw new IllegalOperationError('This TypeMatcher has been sealed and can no longer be configured');
	}

	private function pushValuesToStringVector(values:Array<Dynamic>, vector:Array<String>):Void
	{
		if (values.length == 1 && (Std.is(values[0], Array)))
		{
			var flieds = Reflect.fields(values[0]);
			for (i in 0...flieds.length) {
				vector.push(flieds[i]);
			}
			/*for (packageName in values[0])
			{
				vector.push(packageName);
			}*/
		}
		else
		{
			var flieds2 = Reflect.fields(values);
			for (j in 0...flieds2.length) {
				vector.push(flieds2[j]);
			}
			/*for (packageName in values)
			{
				vector.push(packageName);
			}*/
		}
	}
}