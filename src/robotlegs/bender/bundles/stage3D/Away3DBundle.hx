package robotlegs.bender.bundles.stage3D;

import robotlegs.bender.extensions.display.stage3D.away3d.AwayIntegrationExtension;
import robotlegs.bender.extensions.display.stage3D.away3d.AwayStageSyncExtension;
import robotlegs.bender.framework.api.IBundle;
import robotlegs.bender.framework.api.IContext;

@:keepSub
class Away3DBundle implements IBundle
{
	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/** @inheritDoc **/
	public function extend(context:IContext):Void
	{
		context.install([
			AwayIntegrationExtension,
			AwayStageSyncExtension
		]);
	}
}
