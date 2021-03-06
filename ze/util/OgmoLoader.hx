package ze.util;
import openfl.Assets;
import ze.component.graphic.displaylist.TileMap;
import ze.component.graphic.tilesheet.TileTiledMap;
import ze.object.GameObject;
import ze.object.Scene;

/**
 * ...
 * @author Goh Zi He
 */
class OgmoLoader
{
	private var _current:Int;
	private var _scene:Scene;
	private var _levelXML:Xml;
	private var _levelDirectory:String;
	private var _layers:Array<String>;
	private var _entities:Array<Array<EntityProperties>>;
	
	public function new(scene:Scene)
	{
		_scene = scene;
		_layers = [];
		_entities = [];
	}
	
	public function setOEL(levelName:String):Void
	{
		var xmlText:String = Assets.getText(levelName);
		if (xmlText == null)
		{
			return;
		}
		
		var xml:Xml = Xml.parse(xmlText);
		_levelXML = xml.firstChild();
	}
	
	public function setLayer(layer:String):Void
	{
		for (i in 0 ... _layers.length)
		{
			if (_layers[i] == layer)
			{
				_current = i;
				return;
			}
		}
		
		_current = _layers.length;
		_layers.push(layer);
	}
	
	public function setEntity(entityName:String, cls:Class<GameObject>):Void
	{
		if (_entities[_current] == null)
		{
			_entities[_current] = [];
		}
		else
		{
			for (e in _entities[_current])
			{
				if (e.name == entityName)
				{
					return;
				}
			}
		}
		_entities[_current].push(new EntityProperties(entityName, cls));
	}
	
	public function loadTileMap(tileImage:String, tileWidth:Int, tileHeight:Int, tileRow:Int, tileColumn:Int, gridFn:Int->Int->Void = null):Void
	{
		var mapWidth:Int = Std.parseInt(_levelXML.get("width"));
		var mapHeight:Int = Std.parseInt(_levelXML.get("height"));
		
		var tileMap:TileMap = new TileMap(tileImage, tileWidth, tileHeight, mapWidth, mapHeight, tileRow, tileColumn);
		_scene.createGameObject("tiles", tileMap);
		
		for (element in _levelXML.elementsNamed("Tiles"))
		{
			for (tiles in element.elements())
			{
				var x:Int = Std.parseInt(tiles.get("x"));
				var y:Int = Std.parseInt(tiles.get("y"));
				var tx:Int = Std.parseInt(tiles.get("tx"));
				var ty:Int = Std.parseInt(tiles.get("ty"));
				
				tileMap.setTile(x, y, tx, ty);
				if (gridFn != null)
				{
					gridFn(x, y);
				}
			}
		}
	}
	
	public function loadTiledSprite(atlas:String, tileImage:String, tileWidth:Int, tileHeight:Int, tileRow:Int, tileColumn:Int, gridFn:Int->Int->Void = null):Void
	{
		var mapWidth:Int = Std.parseInt(_levelXML.get("width"));
		var mapHeight:Int = Std.parseInt(_levelXML.get("height"));
		
		var tileSprite:TileTiledMap = new TileTiledMap(atlas, 8);
		_scene.createGameObject("tiles", tileSprite);
		
		for (element in _levelXML.elementsNamed("Tiles"))
		{
			for (tiles in element.elements())
			{
				var x:Int = Std.parseInt(tiles.get("x"));
				var y:Int = Std.parseInt(tiles.get("y"));
				var tx:Int = Std.parseInt(tiles.get("tx"));
				var ty:Int = Std.parseInt(tiles.get("ty"));
				
				tileSprite.setTile(x * tileWidth, y * tileHeight, tx, ty);
				if (gridFn != null)
				{
					gridFn(x, y);
				}
			}
		}
	}
	
	public function loadAll():Void
	{
		if (_levelXML == null)
		{
			trace("Run setOEL() first.");
			return;
		}
		
		_current = 0;
		for (layer in _layers)
		{
			for (x in _levelXML.elementsNamed(layer))
			{
				for (element in x.elements())
				{
					var nodeName:String = element.nodeName;
					for (entity in _entities[_current])
					{
						if (entity.name == nodeName)
						{
							var cls:Class<GameObject> = entity.cls;
							var params:Dynamic<Int> = cast {};
							for (attribute in element.attributes())
							{
								Reflect.setProperty(params, attribute, Std.parseInt(element.get(attribute)));
							}
							_scene.addGameObject(Type.createInstance(cls, [params]));
						}
					}
				}
			}
			
			++_current;
		}
	}
}

class EntityProperties
{
	public var name:String;
	public var cls:Class<GameObject>;
	
	public function new(name:String, cls:Class<GameObject>)
	{
		this.name = name;
		this.cls = cls;
	}
}