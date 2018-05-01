package robotlegs.bender.extensions.logicMap;
import robotlegs.bender.extensions.logicMap.api.ILogicMap;
import robotlegs.bender.extensions.logicMap.impl.LogicMap;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;
import robotlegs.bender.framework.api.IInjector;

/**
 * ...
 * @author P.J.Shand
 */
class LogicMapExtension implements IExtension
{
	private var _injector:IInjector;
	//private var logicMap:ILogicMap;
	
	public function new() 
	{
		
	}
	
	public function extend(context:IContext):Void
	{
		//context.beforeInitializing(beforeInitializing);
		_injector = context.injector;
		_injector.map(ILogicMap).toSingleton(LogicMap);
	}
	
	//function beforeInitializing() 
	//{
		//logicMap = _injector.getInstance(ILogicMap);
	//}
}