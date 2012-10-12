package com.platogo.flow.utils
{
	import com.platogo.flow.data.DataObject;
	import flash.external.ExternalInterface;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public class Utils {
		public static function getClass(name:String):Class {
			var obj : * = getDefinitionByName(name);
			if (!obj)
				throw new Error("Class " + name + "could not be found. Please use Flow.activate to reference the class");
			return obj as Class;
		}
		
		public static function getURLParams():Object {
			var params:Object = {};
			if (ExternalInterface.available) {
				try {
					var urlStr:String = ExternalInterface.call("window.location.href.toString");
					var ps:Array = urlStr.split("?")[1].split("&");
					for (var i:int=0; i<ps.length; i++) {
						var kv:Array = ps[i].split("=");
						params[decodeURI(kv[0])] = decodeURI(kv[1]); 
					}
				} catch (e:Error) {
					params = {};
				}
			}
			return params;
		}
		
		public static function injectData(target:Object, data: Object, key:String) :Object {
			if (key != null && data != null) {
				var arr : Array = key.split(".");
				var target_obj : * = target;
				for (var i : uint = 0; i < arr.length - 1; i++) {
					var child : * = getChild(target_obj, arr[i]);
					if (child == null) 
						break;
					else
						target_obj = child;
				}
				
				for (var j : int = arr.length - 1; j > i ; j--)
					data = Utils.createParent(data, arr[j])
					
				setChild(target_obj, arr[i], data);
			}
			return target;
		}
		
		public static function mergeObjects(target : Object , data : Object ):Object {
			for (var key : String in data)
				setChild(target, key, data[key]);
			
			return target;
		}
		
		public static function mergeArrays(target : Array , data : Array, ignoreEmpty : Boolean = true ):Array {
			if (target == null || data == null) return [];
			for (var i : int = 0; i < data.length; i++) 
				if (data[i] == null && ignoreEmpty)
					continue;
				else	
					target.push(data[i]);
					
			return target;
		}

		public static function getArrayReferences( params : Array):Array {
			if (params == null) return [];

			var buffer : Array = params.concat();
			for ( var i : int = 0; i < params.length; i++) {
				if ( buffer[i] is DataObject) 
					buffer[i] = (buffer[i] as DataObject).value;
					
				if (buffer[i] is Array)
					buffer[i] = getArrayReferences(buffer[i]);
			}
			return buffer;
		}
		
		public static function getObjectReferences( object : Object):* {
			if (object == null) return null;
			if (object is Array) return getArrayReferences(object as Array);
			if ( object is DataObject) return (object as DataObject).value;
			
			var buffer : Object = new Object();
			for ( var key : * in object)
			{
				if (object[key] is DataObject) 
					buffer[key] = getReferenceData(object[key]);
				else if (object[key] is DataObject)
					buffer[key] = getArrayReferences(object[key]);
				else
					buffer[key] = object[key];
			}
			return buffer;
		}

		public static function getReferenceData( param : *):* {
			var value : * ;
			if ( param is DataObject) 
				value = (param as DataObject).value;
			else
				value = param;
			return value;
		}
		
		public static function getChild(target : * , key : String):* {
			try {
				if (target is Function)
					return (target as Function).call(null, key);
				else if(target != null){
					var idx : Number = parseInt(key);
					if (isNaN(idx))
						return target[key];
					else
						return target[idx];
				}
				else
					return null;
			}
			catch (e:Error) {
				return null;
			}
		}
		
		public static function traversPath(target : * , path : String):* {
			if (path != null && path != "" ) {
				var arr : Array = path.split(".");
				for (var i : uint = 0; i < arr.length; i++)
					if (target != null && arr[i] != "") 
						target = getChild(target, arr[i]);
					else
						break;
			}	
			return target;
		}	
		
		public static function setChild(target : * , key : String, data : *):Boolean {
			try {
				if (target is Function)
					return false;
				else if(target != null){
					var idx : Number = parseInt(key);
					if (isNaN(idx))
						if (target[key] is Function)
							target[key](data);
						else
							target[key] = data;
					else 
						if (target[idx] is Function)
							target[idx](data);
						else
							target[idx] = data;
					return true;
				}
				else
					return false;
			}
			catch (e:Error) { }
			return false;
		}	
		
		public static function createParent(data : * , key : String):* {
			try {
				if(data != null){
					var idx : Number = parseInt(key);
					if (isNaN(idx)) {
						var parent_obj : Object = new Object();
						parent_obj[key] = data;
						return parent_obj;
					}
					else {
						var parent_arr : Array = new Array();
						parent_arr[idx] = data;
						return parent_arr;
					}
				}
				else
					return null;
			}
			catch ( e: Error) {
				//trace("Data Child not available");
				return null;
			}
		}
		
		public static function parseDate(raw : String):Date {
			var parts : Array = raw.split(" ");
			var dateRaw : Array = parts[0].split("-");
			var timeRaw : Array = parts[1].split(":");
			return new Date(parseInt(dateRaw[0]), parseInt(dateRaw[1]), parseInt(dateRaw[2]), parseInt(timeRaw[0]), parseInt(timeRaw[1]));
		}
		
		public static function isNumber(s:String):Boolean {
			return Boolean(s.match(/^[0-9]+.?[0-9]+$/));
		}
		
		public static function isMail(mail:String):Boolean{
			var at:Number = mail.indexOf("@");
			if (at < 1 || mail.indexOf("@", at+1) != -1)
				return false;
			else if (mail.indexOf(".", at+2) == -1) 
				return false;
			else
				return true;
		}
		
		public static function isPhoneNumber(phone:String):Boolean {
			var expression:RegExp = /^((+d{1,3}(-| )’(‘d)’(-| )’d{1,3})|((’d{2,3})’))(-| )’(d{3,4})(-| )’(d{4})(( x| ext)d{1,5}){0,1}$/i;
			return ! expression.test(phone);
		}
		
		public static function flattenArray(arr : Array): Array {
			var buffer :Array = new Array();
			for (var i : uint = 0; i < arr.length; i++)
				if (arr[i] is Array)
					buffer = buffer.concat(flattenArray(arr[i]));
				else
					buffer.push(arr[i]);
					
			return buffer;
		}
		
		public static function convertArrayToString(arr: Array, split: String = ","):String {
			if (arr != null) {
				var result : String = "[";
				for (var i : uint = 0; i < arr.length; i++) {
					result += String(arr[i]);
					if (i < arr.length - 1) {
						result += split;	
					}
				}
				
				return result + "]";
			} else 
				return "[ ]";
		}
		
		public static function convertObjectToString(obj: Object):String {
			if (obj == null)
				return String(obj);
			else if (obj is Array) {
				return convertArrayToString(obj as Array);
			}else{
				var str : String = "{";
				for( var key : * in obj) {
					str += String(key);
					str += ":";
					str += String(obj[key]);
					str += ",";
				}
				return str.substring(0, str.length-1) + "}";
			}
		}
	}

}