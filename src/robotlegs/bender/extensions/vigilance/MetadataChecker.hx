package robotlegs.bender.extensions.vigilance;

import robotlegs.bender.framework.api.IContext;
import org.swiftsuspenders.utils.DescribedType;

class MetadataChecker implements DescribedType
{
	@inject("optional=true") public var context:IContext;

	// @inject("name=myNamedDependency","optional=true") public var context:IContext;
	// [Inject(name="myNamedDependency")]
	// @inject public var context:IContext;
	public function check():Void {
		if (context == null) {
			throw new VigilantError("It looks like custom metadata is being ignored by your compiler. " +
				"If you're compiling with the Flash IDE you need to open your " + '"Publish Settings" and select "Publish SWC". ' +
				"See: https://github.com/robotlegs/robotlegs-framework/wiki/Common-Problems");
		}
	}
}
