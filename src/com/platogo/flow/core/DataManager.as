package com.platogo.flow.core
{
	import com.platogo.flow.utils.Utils;
	import flash.utils.Dictionary;
	
	/**
	 * The DataManager provides a data and data source registration service to access data from everywhere in the programm.
	 * 
	 * @author Dominik Hurnaus
	 */
	public class DataManager implements IManager {
		/**
		 * The default manager name
		 */
		public static const DEFAULT_MANAGER_NAME : String = "DataManager";
		
		private var _data:Dictionary = new Dictionary();
		private var _sources:Dictionary = new Dictionary();
		private var _name:String = DEFAULT_MANAGER_NAME;
		
		/**
		 * The DataManager functionality includes:
		 * <li>register data</li>
		 * <li>unregister data</li>
		 * <li>add sources</li>
		 * <li>remove sources</li>
		 * <li>access data</li>
		 * 
		 * @param	alternativeName A alternative name, if more than one DataManager is used.
		 * 
		 * @see com.platogo.flow.data.DataRef
		 * 
		 * @example
		 * There are several ways to initialize the DataManager and work with it.
		 * <br>
		 * The Default way is to use the convenience class com.platogo.flow.Flow
		 * 
		 * <listing version="3.0">
		 * Flow.defaultInit();
		 * 
		 * // register a new command, this can be one simple command or a complex series of commands using sequence commands (com.platogo.flow.commands.sequence)
		 * Flow.data.register("user", {id:12, profilpic:pic.jpg, pictures : [pic1.jpg, pic2.jpg, pic3.jpg], admin: true});
		 * 
		 * // somewhere else in the programm
		 * // access the complete user object
		 * var user : Object = Flow.data.getValue("user");
		 * 
		 * // get a property
		 * var userid: int = Flow.data.getValue("user.id");
		 * 
		 * // get a element of a property array 
		 * var picture_path: String = Flow.data.getValue("user.pictures.0");
		 * 
		 * </listing>
		 * 
		 * Use a custom DataManager
		 * 
		 * <listing version="3.0">
		 * var commands : CommandManager = new CommandManager("MyData");
		 * // register a command
		 * commands.register("user", {id:12, profilpic:pic.jpg, pictures : [pic1.jpg, pic2.jpg, pic3.jpg], admin: true});
		 * 
		 * // somewhere lese in the programm
		 * // check if the user object is available
		 * DataManager.getInstance("MyData").has("user");
		 * </listing>
		 * 
		 * The default DataManager Standalone and adding a data source (com.greensock.loading.LoaderMax)
		 * 
		 * <listing version="3.0">
		 * DataManager.defaultInstance.register("user", {id:12, profilpic:pic.jpg, pictures : [pic1.jpg, pic2.jpg, pic3.jpg], admin: true});
		 * 
		 * // access loader content of all loader max classes
		 * DataManager.defaultInstance.addSource("LOADER", LoaderMax, "getContent");
		 * 
		 * // access the current users data
		 * DataManager.defaultInstance.addSource("PlatogoUser", PlatogoAPI, "currentUser.getData");
		 * 
		 * // there is a ImageLoader named "myimage"
		 * DataManager.defaultInstance.getValue("myimage");
		 * 
		 * // there is a property level in the PlatogoAPI.currentUser
		 * DataManager.defaultInstance.getValue("level");
		 * 
		 * var dynamicData : DataRef = new DataRef("user");
		 * var id : int = dynamicData.value.id;
		 * </listing>
		 */
		public function DataManager(alternativeName : String = null ) {
			if (alternativeName != null && alternativeName.length > 0)
				_name = alternativeName
				
			FlowInternal.register(this);
		}
		
				
		/* INTERFACE com.platogo.flow.core.IManager */
		
		/**
		 * The name of the instance.
		 */
		public function get name():String { return _name; }
		
		/**
		 * Access to the default DataManager Instance.
		 */
		public static function get defaultInstance():DataManager {
			var instance : DataManager = getInstance(DataManager.DEFAULT_MANAGER_NAME);
			if (!instance)
				instance = new DataManager();
			return instance;
		}
		
		/**
		 * Resturns a specific DataManager instance.
		 * @param	name of a DataManager instance
		 * @return <code>null</code> if there is no DataManager with the specific name.
		 */
		public static function getInstance(name : String):DataManager {
			return FlowInternal.getManager(name) as DataManager;
		}
		
		//=============================================================
		// Instance Functions
		//=============================================================
		
		/**
		 * Read data registered in the DataManager or in a connected source
		 * 
		 * @param	key the key to the data
		 * @param	converter a function, that takes the data for the key as parameter and return some value
		 * @return	data defined by the key
		 * 
		 * @example
		 * How to read data
		 * 
		 * <listing version="3.0">
		 * //get the complete user object
		 * var user : Object = Flow.data.getValue("user");
		 * 
		 * // get the id parameter of the user object
		 * var id : int = Flow.data.getValue("user.id") as int;
		 * 
		 * // access the third element of the pitures array
		 * var pic : String = Flow.data.getValue("user.pictures.2") as String;
		 * 
		 * // access the user object and convert it into a jason String
		 * var user_str : String = Flow.data.getValue("user", JSON.encode) as String; 
		 * 
		 * // use the DataRef class a better access
		 * var userEncoded : DataRef = new DataRef("user", JSON.encode);
		 * trace(userEncoded.value);
		 * </listing>
		 * 
		 * @see com.platogo.flow.data.DataRef
		 */
		public function getValue(key:String, converter : * = null):* {
			var base : String = extractBaseKey(key);
			var obj : * = null;
			if (_data[base] != null) 
				obj = extractData(_data[base], key)
			else if (_sources[base] != null) 
				obj = extractData(getDataRef(_sources[base] as SourceData), key);
		
			if (converter != null)
				return converter(obj);
			else
				return obj;
		}
		
		/**
		 * Write data in a registered datafield of the DataManager or in a connected source(if writeable)
		 * It does not work like register(). There has to be a value there before setValue can be used
		 * 
		 * 
		 * @param	key		the key to the value, to be changed
		 * @param	data	the new data
		 * @return	<code>true</code> if the data was set.
		 * 
		 * @example
		 * How to write data
		 * <listing version="3.0">
		 * 
		 * 
		 * // set the id parameter of the user object
		 * Flow.data.setValue("user.id", 200);
		 * 
		 * // set the 6 element of the pitures array
		 * Flow.data.getValue("user.pictures.6", "pic7.jpg");
		 * 
		 * // use the DataRef class a better access
		 * var userIDRef : DataRef = new DataRef("user.id");
		 * 
		 * userIDRef.value = 30;
		 * </listing>
		 */
		public function setValue(key:String, data : *):Boolean {
			var base : String = extractBaseKey(key);
			if (_data[base] != null) {
				if (extractRestKey(key) != "")
					return setData(_data[base],extractTopKey(key),extractPath(key), data);
				else {
					_data[base] = data;
					return true;
				}
			}
			else if (_sources[base] != null && (_sources[base] as SourceData).isWriteable && extractRestKey(key) != "")
				return setData(getDataRef(_sources[base] as SourceData),extractTopKey(key),extractPath(key), data);
			else 
				return false;
		}
		
		/**
		 * Add a data source, the description is use to access data
		 * 
		 * The function has to be of the type: function(key : String):*
		 * 
		 * @param	key a key to reference the source
		 * @param	source the source object
		 * @param	description	a description the access the source object (if part of the source to be accessed is dynamic)
		 * @param	isWriteable defines if the setValue() can be used on the source
		 * 
		 * @example
		 * <listing version="3.0">
		 * // register the content of the LoaderMax class
		 * DataManager.defaultInstance.addSource("Loader", LoaderMax, "getContent");
		 * 
		 * // access content in the loader
		 * var pic : Bitmap = DataManager.defaultInstance.getValue("Loader.pic1") as Bitmap;
		 * 
		 * //register the data the of the cureent user
		 * DataManager.defaultInstance.addSource("Me", PlatogoAPI, "currentUser.getData");
		 * 
		 * // access the level value of the currentUser
		 * var level : int = DataManager.defaultInstance.getValue("Me.level", parseInt) as int;
		 * 
		 * // Use the DataRef Class to get a even better access
		 * var levelRef : DataRef = new DataRef("Me.level", parseInt);
		 * trace(levelRef.value);
		 * </listing>
		 */
		public function addSource(key : String, source : * , description : String = null, isWriteable : Boolean = false):void {
			var data : SourceData = new SourceData();
			data.isWriteable = isWriteable;
			data.source = source;
			data.description = description;
			_sources[key] = data;
		}
		
		/**
		 * Remove a data source
		 * @param	key	 key to the source
		 */
		public function removeSource(key : String):void {
			delete _sources[key];
		}
		
		/**
		 * Register data
		 * 
		 * @param	key key to register data
		 * @param	data	data object
		 */
		public function register(key:String, data:*):void {
			if (key != null && data != null) {
				var arr : Array = key.split(".");
				
				var target_obj : * = _data;
				for (var i : uint = 0; i < arr.length - 1; i++) {
					var child : * = Utils.getChild(target_obj, arr[i]);
					if (child == null) 
						break;
					else
						target_obj = child;
				}
				
				for (var j : int = arr.length - 1; j > i ; j--)
					data = Utils.createParent(data, arr[j])
					
				if (target_obj[arr[i]] != null) {
					//TODO: throw error
				}
					
				Utils.setChild(target_obj, arr[i], data);
			}
		}
		
		/**
		 * Unregister data, only for base keys, not for subkeys(like BaseKey.SubKey)
		 * @param	key key to data
		 */
		public function unregister(key:String):void {
			delete _data[extractBaseKey(key)];
		}
		
		
		/**
		 * Uses a data object to register several keys
		 * 
		 * @param	data
		 */
		public function parse(data:Object):void {
			for (var key:String in data)
				register(key, data[key]);
		}
		
		/**
		 * Check if the data already exist under the key. This function does not check the sources for data
		 * 
		 * @param	key
		 * @return <code>true</code> if there is data in the DataManager
		 */
		public function has(key:String):Boolean {
			return Utils.traversPath(_data, key) != null;
		}
		
		/**
		 * Clears all data and all sources from the DataManager
		 */
		public function clear():void {
			for (var key:String in _data)
				delete _data[key];
				
			for (key in _sources)
				delete _sources[key];
		}
		
		//=============================================================
		// Instance Helper Functions
		//=============================================================
		
		private function extractData(source : *, key:String):* {
			//Check complete key
			if (source != null) {
				key = extractRestKey(key);
			
				var obj : * = Utils.getChild(source, key);
				
				if (obj == null)
					obj = Utils.traversPath(source, key);
			}
			return obj;
		}
		
		private function setData(source:*, key:String, path : String, data : *):Boolean {
			return Utils.setChild(Utils.traversPath(source, path), key, data);
		}
		
		private function extractBaseKey(key : String ): String {
			var idx : int = key.indexOf(".");
			if ( idx >= 0 )
				return key.substring(0, idx);
			else
				return key;
		}
		
		private function extractTopKey(key : String ): String {
			var idx : int = key.lastIndexOf(".");
			if ( idx >= 0 )
				return key.substring(idx + 1, key.length);
			else
				return key;
		}
		
		private function extractRestKey(key : String ): String {
			var idx : int = key.indexOf(".");
			if ( idx >= 0 )
				return key.substring(idx + 1, key.length);
			else 
				return "";
		}
		
		private function extractPath(key : String ): String {
			var beginn : int = key.indexOf(".");
			var end : int = key.lastIndexOf(".");
			if ( beginn >= 0 &&  end >= 0  && beginn != end )
				return key.substring(beginn + 1, end);
			else 
				return "";
		}

		private function getDataRef(data : SourceData): Object {
			try{
				if (data && data.source != null)
					return Utils.traversPath( data.source, data.description);
				else
					return null;
			}
			catch ( e: Error) {}
			return null;
		}
	}
}

internal class SourceData {
	public var source : * ;
	public var isWriteable : Boolean ;
	public var description : String;
}