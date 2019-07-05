package robotlegs.bender.bundles.stage3D;

import robotlegs.bender.framework.api.IBundle;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.extensions.display.stage3D.Stage3DStackExtension;

/**
 * ...
 * @author P.J.Shand
 */
@:keepSub
class Stage3DBundle implements IBundle
{
	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/** @inheritDoc **/
	public function extend(context:IContext):Void
	{
		context.install(
			Stage3DStackExtension
		);
	}
}