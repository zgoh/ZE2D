package ze.util;
import openfl.display.DisplayObject;
import openfl.display.Graphics;
import openfl.display.Sprite;
import openfl.display.Stage;
import ze.object.Scene;

/**
 * ...
 * @author Goh Zi He
 */
class Screen
{
	public var top(get, null):Float;
	public var bottom(get, null):Float;
	public var left(get, null):Float;
	public var right(get, null):Float;
	public var midX(get, null):Float;
	public var midY(get, null):Float;
	public var width(get, null):Int;
	public var height(get, null):Int;
	
	private var _x:Float;
	private var _y:Float;
	
	private var _scene:Scene;
	private var _sprite:Sprite;
	private var _graphics:Graphics;
	private var _tileSheetLayers:Array<TileSheetLayer>;
	
	public function new(scene:Scene)
	{
		_x = 0;
		_y = 0;
		_scene = scene;
		_sprite = new Sprite();
		_graphics = _sprite.graphics;
		scene.engine.addChild(_sprite);
		
		var stage:Stage = scene.engine.stage;
		midX = stage.stageWidth >> 1;
		midY = stage.stageHeight >> 1;
		
		_tileSheetLayers = [];
	}
	
	public function draw():Void 
	{
		_graphics.clear();
		for (layer in _tileSheetLayers)
		{
			layer.draw();
		}
	}
	
	public function addLayer(layer:TileSheetLayer):Void
	{
		_tileSheetLayers.push(layer);
		layer.graphics = _graphics;
	}
	
	public function getLayer(name:String):TileSheetLayer
	{
		for (layer in _tileSheetLayers)
		{
			if (layer.spriteExist(name))
			{
				return layer;
			}
		}
		
		return null;
	}
	
	public function addChild(child:DisplayObject):DisplayObject
	{
		return _sprite.addChild(child);
	}
	
	public function removeChild(child:DisplayObject):DisplayObject
	{
		return _sprite.removeChild(child);
	}
	
	public function removed():Void 
	{
		_scene.engine.removeChild(_sprite);
		_scene = null;
		_graphics = null;
		_sprite = null;
		_tileSheetLayers = null;
	}
	
	private function get_top():Float
	{
		return _y;
	}
	
	private function get_bottom():Float
	{
		return (_y + _scene.engine.stage.stageHeight);
	}
	
	private function get_left():Float
	{
		return _x;
	}
	
	private function get_right():Float
	{
		return (_x + _scene.engine.stage.stageWidth);
	}
	
	private function get_midX():Float
	{
		return (right * 0.5);
	}
	
	private function get_midY():Float
	{
		return (bottom * 0.5);
	}
	
	private function get_width():Int
	{
		return _scene.engine.stage.stageWidth;
	}
	
	private function get_height():Int
	{
		return _scene.engine.stage.stageHeight;
	}
	
	public function shift(x:Float = 0, y:Float = 0):Void
	{
		_sprite.y -= y;
		_sprite.x -= x;
		_x = _sprite.x;
		_y = -_sprite.y;
	}
	
	public function setX(x:Float):Void
	{
		_x = x;
		_sprite.x = x;
	}
	
	public function setY(y:Float):Void
	{
		_y = y;
		_sprite.y = -y;
	}
	
	public function setXY(x:Float, y:Float):Void
	{
		setX(x);
		setY(y);
	}
}