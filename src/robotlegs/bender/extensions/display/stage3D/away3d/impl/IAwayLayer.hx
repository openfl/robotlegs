package robotlegs.bender.extensions.display.stage3D.away3d.impl;

import robotlegs.bender.extensions.display.base.api.IRenderContext;

/**
 * ...
 * @author P.J.Shand
 */
interface IAwayLayer {
	var renderContext(get, set):IRenderContext;
	var antiAlias(get, set):UInt;
}
