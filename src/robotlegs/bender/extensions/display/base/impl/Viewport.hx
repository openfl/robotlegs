package robotlegs.bender.extensions.display.base.impl;

import msignal.Signal.Signal0;
import robotlegs.bender.extensions.display.base.api.IViewport;
/**
 * ...
 * @author P.J.Shand
 */
@:rtti
@:keepSub
class Viewport implements IViewport
{
	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/
	private var _x:Float = 0;
	private var _y:Float = 0;
	private var _width:Float = 0;
	private var _height:Float = 0;
	private var _onChange = new Signal0();
	private var _colour:UInt = 0x0;
	private var _red:UInt = 0x0;
	private var _green:UInt = 0x0;
	private var _blue:UInt = 0x0;
	
	/*============================================================================*/
	/* Public Properties                                                         */
	/*============================================================================*/
	public var x(get, set):Float;
	public var y(get, set):Float;
	public var width(get, set):Float;
	public var height(get, set):Float;
	public var onChange(get, null):Signal0;
	public var colour(get, set):UInt;
	
	public var red(get, null):UInt;
	public var green(get, null):UInt;
	public var blue(get, null):UInt;
	
	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/
	private var count:Int = 0;
	
	public function new()
	{
		
	}
	
	public function setTo(x:Float, y:Float, width:Float, height:Float):Void
	{
		_x = x;
		_y = y;
		_width = width;
		_height = height;
		if (_width < 64) _width = 64;
		if (_height < 64) _height = 64;
		count++;
		onChange.dispatch();
	}
	
	private function get_x():Float { return _x; }
	private function set_x(value:Float):Float 
	{
		_x = value;
		onChange.dispatch();
		return _x;
	}
	
	private function get_y():Float { return _y; }
	private function set_y(value:Float):Float 
	{
		_y = value;
		onChange.dispatch();
		return _y;
	}
	
	private function get_width():Float { return _width; }
	private function set_width(value:Float):Float 
	{
		_width = value;
		if (_width < 64) _width = 64;
		onChange.dispatch();
		return _width;
	}
	
	private function get_height():Float { return _height; }
	private function set_height(value:Float):Float 
	{
		_height = value;
		if (_height < 64) _height = 64;
		onChange.dispatch();
		return _height;
	}
	
	private function get_onChange():Signal0 
	{
		return _onChange;
	}
	
	private function get_colour():UInt
	{
		return _colour;
	}
	
	private function set_colour(value:UInt):UInt
	{
		if (_colour == value) return value;
		_colour = value;
		_red = (( _colour >> 16 ) & 0xFF);
		_green = ( (_colour >> 8) & 0xFF );
		_blue = ( _colour & 0xFF );
		return value;
	}
	
	private function get_red():UInt
	{
		return _red;
	}
	
	private function get_green():UInt
	{
		return _green;
	}
	
	private function get_blue():UInt
	{
		return _blue;
	}
}