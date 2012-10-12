package com.platogo.flow.utils 
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Dominik
	 */
	public class SpreadsheetUtils {
		public static function decode(data : String, mapping : * , autotrim : Boolean = true):Dictionary { 
			// Convert bytes to string to XML.
			var tweakXML:XML = new XML(data);

			// Extract the entries.
			var xmlns:Namespace = new Namespace("xmlns", "http://www.w3.org/2005/Atom");
			tweakXML.addNamespace(xmlns);

			// Parse into a dictionary.
			var cellDictionary:Dictionary = new Dictionary();
			var res:XMLList = tweakXML.xmlns::entry;
			for each(var entryXML:XML in res) {
				var value : String = entryXML.xmlns::content.toString();
				if(!Utils.isNumber(value))
					cellDictionary[entryXML.xmlns::title.toString()] = value;
				else
					cellDictionary[entryXML.xmlns::title.toString()] = parseFloat(value);
			}
				
			if (mapping != null && (mapping is Array || mapping is String)) {
				var result : Dictionary = new Dictionary();
				var map : Array;
				if (mapping is String)
					map = (mapping as String).split(",");
				else
					map = (mapping as Array).concat();
					
				for each(var entry : String in map) {
					var buffer : Array = entry.split("=");
					if (buffer.length == 1)
						Utils.injectData(result, cellDictionary, buffer[0] as String);
					else if (buffer.length == 2) {		
						var size : Point = getCellListSize( buffer[0] as String);
						var keys : * = getCellData(cellDictionary, buffer[0], autotrim);
						
						if (keys == null)
							keys == buffer[0];
							
						var data : String = buffer[1];
						
						var childkeys : Object = null;
						if (buffer[1].indexOf("|") != -1) {
							buffer = buffer[1].split("|");
							data = buffer[0];
							childkeys = getCellData(cellDictionary, buffer[1], autotrim);
							if (childkeys == null)
								childkeys = buffer[1] as String;
						}

						if (keys is String)
							Utils.injectData(result, mapData(getCellData(cellDictionary, data, autotrim), childkeys), keys as String);
						else if (keys is Array)
							for (var i : int = 0; i < keys.length; i++) 
								Utils.injectData(result, mapData(getCellData(cellDictionary, data,autotrim, new Point(i % size.x,Math.floor(i /size.x))), childkeys), keys[i] as String);
					}
				}
				return result;
			}
			else
				return cellDictionary;
		}
		
		public static function getCellData(cells: Dictionary, key:String, clearEmpty : Boolean = false, offset : Object = null):* {
			var keys : Array;
			if (key.indexOf(":")!= -1) { // From To Option
				keys = key.split(":");
				if (keys.length == 2 && isCoordinate(keys[0]) && isCoordinate(keys[1])) {
					var from : Point = addressToCoordinate(keys[0]);
					var to : Point = addressToCoordinate(keys[1]);
					return getCellList(cells,from,to.x - from.x + 1,to.y - from.y + 1, clearEmpty, offset);
				}
				else
					return null;
			}
			else if (key.indexOf("#")!= -1) {
				keys = key.split("#");
				if (keys.length == 2 && isCoordinate(keys[0]) && isCoordinate(keys[1])) {
					from = addressToCoordinate(keys[0]);
					var size : Point = addressToCoordinate(keys[1]);
					return getCellList(cells,from, size.x + 1, size.y + 1, clearEmpty, offset);
				}
				else
					return null;
			}
			else
				if (isCoordinate(key)) {
					var pos : Point = addressToCoordinate(key);
					if (offset) {
						pos.x += offset.x;
						pos.y += offset.y;
					}
					return cells[coordinateToAddress(pos)];
				}
				else
					return null;
		}
		
		public static function getCellListSize(key:String): Point {
			var keys : Array;
			if (key.indexOf(":")!= -1) { // From To Option
				keys = key.split(":");
				if (keys.length == 2 && isCoordinate(keys[0]) && isCoordinate(keys[1]))
					return addressToCoordinate(keys[1]).subtract(addressToCoordinate(keys[0])).add(new Point(1,1));
				else
					return null;
			}
			else if (key.indexOf("#")!= -1) {
				keys = key.split("#");
				if (keys.length == 2 && isCoordinate(keys[0]) && isCoordinate(keys[1]))
					return addressToCoordinate(keys[1]).add(new Point(1,1));
				else
					return null;
			}
			else
				return new Point();
		}

		public static function isCoordinate(cell:String):Boolean {
			return cell.search(/[A-Za-z]+\d+/) != -1;
		}
		
		public static function addressToCoordinate(cell : String):Point {
			var baseX:int = -1;		
			for ( var i : uint = 0; i < cell.length; i++ )
				if (cell.charCodeAt(i) % "0".charCodeAt(0) <= 9)
					break;
				else
					baseX = (baseX + 1) * 26 + cell.charCodeAt(i) - "A".charCodeAt(0);

			var baseY:int = parseInt(cell.substr(i));
			if(baseX >= 0 && !isNaN(baseY) && baseY.toString() == cell.substr(i))
				return new Point(baseX, baseY - 1);
			else
				return null;
		}
		
		public static function coordinateToAddress(coordinate : Point):String {
			var baseX:int = coordinate.x as uint;
			var baseY:int = coordinate.y as uint;
			
			var cellX : String = "";
			do {
				cellX = String.fromCharCode(baseX % 26 + "A".charCodeAt(0)) + cellX;
				baseX = (baseX -(baseX % 26))/26 - 1;
			} while (baseX >= 0)
			
			return cellX + int(baseY + 1).toString();
		}
		
		private static function getCellList(cells:Dictionary, from:Point, dx: int, dy:int, clearEmpty : Boolean = false, offset : Object = null):Array {
			var data : Array = new Array();
			if (offset is Point) 
				from = from.add(offset as Point);
			else if (offset is String && isCoordinate(offset as String))
				from = from.add( addressToCoordinate(offset as String));
					
			for (var x : int = 0; x < dx; x++)
				for (var y : int = 0; y < dy; y++)
					data[x + y * dx] = cells[coordinateToAddress(new Point(from.x + x , from.y + y))];
							
			if (clearEmpty) {
				for (var i : int = data.length - 1; i >= 0; i--)
					if (data[i] == null)
						data.splice(i, 1);
			}
			
			return data;
		}
		
		private static function mapData(data : Object, keys : Object):Object {
			var base: Object = new Object();
			if (data is Array && keys is Array && data.length == keys.length) {
				for (var i : int = 0; i < data.length; i++) 
					Utils.injectData(base, data[i], keys[i]);
				return base;	
			}
			else if (keys is String)
				return Utils.injectData(base, data, keys as String);
			else
				return data;
		}
	}
}