package robotlegs.bender.bundles.stage3D;

import robotlegs.bender.framework.api.IBundle;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.extensions.stage3D.base.Stage3DStackExtension;

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
		context.install([
			//ManualStageObserverExtension, 
			//SignalCommandMapExtension, 
			//ImagSignalExtension,
			//ImagModelExtension,
			//ImagServiceExtension,
			//ImagCommandExtension,
			Stage3DStackExtension
		]);
	}
}