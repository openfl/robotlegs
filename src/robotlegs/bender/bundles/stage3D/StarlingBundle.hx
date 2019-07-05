package robotlegs.bender.bundles.stage3D;

import robotlegs.bender.extensions.display.stage3D.starling.StarlingIntegrationExtension;
import robotlegs.bender.extensions.display.stage3D.starling.StarlingStageSyncExtension;
import robotlegs.bender.framework.api.IBundle;
import robotlegs.bender.framework.api.IContext;

class StarlingBundle implements IBundle
{
	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/** @inheritDoc **/
	public function extend(context:IContext):Void
	{
		context.install(
			StarlingIntegrationExtension,
			StarlingStageSyncExtension
		);
		
	}
}