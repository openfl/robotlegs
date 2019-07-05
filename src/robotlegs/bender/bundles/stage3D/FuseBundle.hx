package robotlegs.bender.bundles.stage3D;

import robotlegs.bender.extensions.display.stage3D.fuse.FuseIntegrationExtension;
import robotlegs.bender.extensions.display.stage3D.fuse.FuseStageSyncExtension;
import robotlegs.bender.framework.api.IBundle;
import robotlegs.bender.framework.api.IContext;
import fuse.Fuse;

class FuseBundle implements IBundle
{
	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/** @inheritDoc **/
	public function extend(context:IContext):Void
	{
		context.install(
			FuseIntegrationExtension,
			FuseStageSyncExtension
		);
		
	}
}