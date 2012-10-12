package com.platogo.flow.core
{
	import com.platogo.flow.container.DisplayContainer;
	import com.platogo.flow.container.IContainer;
	import com.platogo.flow.events.ScreenEvent;
	import com.platogo.flow.screens.Screen;
	import com.platogo.flow.screens.ScreenLayer;
	import flash.utils.Dictionary;
	
	/**
	 * The ScreenManager provides a layer system and a screen registration service to handle screen operations.
	 * 
	 * @author Dominik Hurnaus
	 */
	public final class ScreenManager implements IManager {
		
		/**
		 * The seperator symbol in a key of a unique screen, to split the original screen key from the screen index.
		 */
		public static const INDEX_SEPERATOR : String = "#";
		
		/**
		 * The default manager name
		 */
		public static const DEFAULT_MANAGER_NAME : String = "ScreenManager";
		
		/**
		 * The default container class
		 * @default com.platogo.flow.container.DisplayContainer
		 * @see com.platogo.flow.container.DisplayContainer
		 */
		public static const DEFAULT_CONTAINER: Class = DisplayContainer;
		
		private var cContainer : Class = DEFAULT_CONTAINER;
		private var _classes: Dictionary = new Dictionary();
		private var _root : IContainer;
		private var _layers : Array = new Array();
		private var _name : String = DEFAULT_MANAGER_NAME;

		/**
		 * The ScreenManager functionality includes:
		 * <li>register screens</li>
		 * <li>unregister screens</li>
		 * <li>show screens</li>
		 * <li>hide screens</li>
		 * <li>push screens to layers</li>
		 * <li>pop screens from layers</li>
		 * 
		 * @param	alternativeContainer	A alternative Container Class, that implements IContainer. @see com.platogo.flow.container.IContainer
		 * @param	alternativeName		A alternative name, if more than one ScreenManager is used.
		 * 
		 * @example
		 * There are several ways to initialize the ScreenManager and work with it.
		 * <br>
		 * The Default way is to use the convenience class <code>com.platogo.flow.Flow</code>
		 * 
		 * <listing version="3.0">
		 * Flow.defaultInit();
		 * stage.addChild(Flow.screens.root as DisplayObject);
		 * 
		 * // register a new screen
		 * Flow.screens.register("EXAMPLE_A", new ExampleA());
		 *
		 * // show the screen
		 * screens.show("EXAMPLE_A");
		 * 
		 * // hide the screen
		 * screens.hide("EXAMPLE_A");
		 * </listing>
		 * 
		 * It is possible to use a standalone custom ScreenManager. It is also possible to initialize several different managers with different names.
		 * 
		 * <listing version="3.0">
		 * 
		 * var screens : ScreenMananger = new ScreenManager(DisplayContainer, "MyScreenMananger");
		 * stage.addChild(screens.root as DisplayObject);
		 * 
		 * // register a screen als unique screen, everytime the key is shown a new instance of the screen is created. 
		 * This is very usefull for popup messages.
		 * screens.register("EXAMPLE_B", new ExampleB(), 0, true);
		 * 
		 * // show two instances of the screen
		 * screens.show("EXAMPLE_B");
		 * screens.show("EXAMPLE_B");
		 * 
		 * // close the first screen
		 * screens.hide("EXAMPLE_B#0");
		 * 
		 * //Somewhere else in the code
		 * // access the custom manager and close all EXAMPLE_B screens.
		 * ScreenManager.getInstance("MyScreenMananger").hide("EXAMPLE_B");
		 * </listing>
		 * 
		 * The default ScreenManager can be accessed from everywhere without using <code>com.platogo.flow.Flow</code>
		 * If the default ScreenManager is not initialized, a instance is created automaticly.
		 * <listing version="3.0">
		 * 
		 * // register a screen 
		 * ScreenMananger.defaultInstance.register("EXAMPLE_C", new ExampleC());
		 * 
		 * // show the screen
		 * var screen : Screen = ScreenMananger.defaultInstance.show("EXAMPLE_C");
		 * 
		 * // this and the push function only work for registered screens, it calls the ScreenManager.pop function.
		 * screen.pop();
		 * 
		 * // it is possible to push/pop any screen into a layer (it does not need to be registered)
		 * var specialScreen : Screen = new SpecialScreen();
		 * ScreenMananger.defaultInstance.push(specialScreen);
		 * ScreenMananger.defaultInstance.pop(specialScreen);
		 * </listing>
		 */
		public function ScreenManager(alternativeContainer : Class = null, alternativeName : String = null) {
			if(alternativeContainer != null)
				cContainer = alternativeContainer;
				
			if(alternativeName != null && alternativeName.length > 0)
				_name = alternativeName;
				
			_root = new cContainer();
			if (!(_root is IContainer))
				throw new Error("Container is not of the type com.platogo.flow.container.IContainer")
				
			FlowInternal.register(this);
		}

		/* INTERFACE com.platogo.flow.core.IManager */
		/**
		 * The name of the instance. 
		 */
		public function get name():String { return _name; }
		
		/**
		 * Access to the default ScreenManager.
		 */
		public static function get defaultInstance():ScreenManager {
			var instance : ScreenManager = getInstance(ScreenManager.DEFAULT_MANAGER_NAME);
			if (!instance)
				instance = new ScreenManager();
			return instance;
		}
		
		/**
		 * Resturns a ScreenManager instance with a specific name.
		 * @param	name of a ScreenManager instance
		 * @return <code>null</code> if there is no ScreenManager with the specific name.
		 */
		public static function getInstance(name : String):ScreenManager {
			return FlowInternal.getManager(name) as ScreenManager;
		}

		//=============================================================
		// Instance Functions
		//=============================================================
		/**
		 * Creates new instances of the container class defined.
		 * 
		 * @return a new instance of the defined container class
		 */
		public function createContainer():IContainer {
			return new cContainer();
		}
		
		/**
		 * Access to the root of the layersystem.
		 * This has to be added to the stage.
		 * 
		 * @example
		 * <listing version="3.0">
		 * var screens : ScreenMananger = new ScreenManager(DisplayContainer);
		 * stage.addChild(screens.root as DisplayObject);
		 * </listing>
		 */
		public function get root():* {
			return _root.rawContent;
		}
		
		
		/**
		 * Register screens with the screenmananger to call them from anywhere in the code.
		 * 
		 * <p>WARNING: if the key is already in use </p>
		 * 
		 * @param	key				every key has to be unique
		 * @param	screen			a instance to the screen
		 * @param	defaultLayer	the default layer setting
		 * @param	unique			if set to <code>true</code> every time the define screen is shown a new instance of the screen is created
		 */
		public function register(key : String, screen : Screen, defaultLayer : uint = 0, unique : Boolean = false):void {
			if (hasScreen(key))
				throw new Error("key(" + key + ") is already registered. unregister the key first.");
				
			var data : ScreenDefinition = new ScreenDefinition();
			data.prototype = screen;
			data.unique = unique;
			data.screens = new Array();
			data.dafaultLayer = defaultLayer;
			_classes[key] = data;
			screen.dispatchEvent(new ScreenEvent(ScreenEvent.INIT, this, key, defaultLayer, screen, unique));
		}
		
		/**
		 *  Unregisters a defined screen and removes all the screens(under the given key) from the ScreenManagers layersystem
		 * 
		 * @param	key		key of a registered screen
		 */
		public function unregister(key : String):void {
			var data : ScreenDefinition = getScreenDefinition(key);
			if (data) {
				if (data.unique) {
					for each(var screen : Screen in data.screens)
						hideScreen(screen);
						
				} else {
					data.prototype.hide();
				}
	
				delete _classes[key];
			}
		}
		
		/**
		 * Get the index of a layer
		 * 
		 * @param	layer	A instance of ScreenLayer	
		 * @return Returns <code>-1</code> if the layer is not a layer of the ScreenManager.
		 */
		public function getLayerIdx(layer :ScreenLayer):int {
			return _layers.indexOf(layer);
		}
		
		/**
		 * Get the layer of a screen
		 * 
		 * @param	screen	A screen that has been pushed into a layer of the ScreenManager
		 * @return Returns <code>null</code> if the screen is not in a layer.
		 */
		public function getLayerByScreen(screen :Screen):ScreenLayer {
			for each(var layer : ScreenLayer in _layers)
				if (layer.indexOf(screen) != -1)
					return layer;
	
			return null;
		}
		
		
		/**
		 * Get a layer by Index.
		 * 
		 * @param	index 		Index of the layer to be accessed
		 * @param	autoCreate  If set to <code>true</code> the layer is created if it does not exist
		 * @return	Resturns <code>null</code> if the layer doesn't exist and autoCreate is set to <code>false</code>, otherwise the specified layer is returned
		 */
		public function getLayerByIndex(index :uint, autoCreate : Boolean = false):ScreenLayer {
			if (index < _layers.length)
				return _layers[index];
			else if(autoCreate)
				return getLayer(index);
			else
				return null;
		}
		
		
		/**
		 * Checks if the key is registered with the ScreenManager
		 * 
		 * @param	key a key to check
		 * @return <code>false</code> if the key is not registered
		 */
		public function hasScreen(key : String):Boolean {
			return getScreenDefinition(key.split(INDEX_SEPERATOR)[0]) != null;
		}
		
		/**
		 * Push a screen on a layer
		 * 
		 * @param	screen	a screen instance to push into the layer system
		 * @param	layerIDX if the layerIDX is smaller than 0, the defaultLayerIdx of the screen is used.
		 */
		public function push(screen: Screen, layerIDX:int = -1):void {
			if (layerIDX < 0)
				layerIDX = screen.defaultLayerIdx;
			
			var layer : ScreenLayer = getLayer(layerIDX);
			if (layer) {
				var old : ScreenLayer = getLayerByScreen(screen);
				if (old != layer) {
					layer.add(screen);
					
					if(old == null)
						screen.dispatchEvent(new ScreenEvent(ScreenEvent.LAYER_PUSH, this, screen.key, layerIDX));
					else
						screen.dispatchEvent(new ScreenEvent(ScreenEvent.LAYER_CHANGE, this, screen.key, layerIDX));
				}
			}
		}
		
		/**
		 * Returns the screen registered with this key. If the screen is registered as unique the function creates a new instance of the screen.
		 * 
		 * @param	key a registered key
		 * @return <code>null</code> if the key is not registered.
		 * 
		 * @example
		 * <listing version="3.0">
		 * 
		 * // a not unique screen (only on instance of screen exists under this key)
		 * Flow.screens.register("EXAMPLE_A", new ExampleA(), 0, false);
		 * 
		 * // a not unique screen (every time the screen is called a ne instance is created)
		 * Flow.screens.register("EXAMPLE_B", new ExampleB(), 0, true);
		 * 
		 * // screenA1 == screenA2
		 * var screenA1 : Screen = Flow.screens.getScreen("EXAMPLE_A");
		 * var screenA2 : Screen = Flow.screens.getScreen("EXAMPLE_A");
		 * 
		 * // screenB1 == screenB2, but screenB1 != screenB3
		 * // use the INDEX_SEPERATOR # to access a specific screen
		 * var screenB1 : Screen = Flow.screens.getScreen("EXAMPLE_B");
		 * var screenB2 : Screen = Flow.screens.getScreen("EXAMPLE_B#0");
		 * var screenB3 : Screen = Flow.screens.getScreen("EXAMPLE_B");
		 * </listing>
		 */
		public function getScreen(key : String):Screen {
			var path : Array = key.split(INDEX_SEPERATOR);
			var data : ScreenDefinition = getScreenDefinition(path[0]);
			if (data)
				if (data.unique) 
					if (path.length == 2)
						return data.screens[ parseInt(path[1] as String)] as Screen;
					else 
						return createUniqueScreen(data);
				else
					return data.prototype;
			else
				return null;
		}
		
		/**
		 * Returns all screens registered under the key. Does NOT create a new instance of the screen if the screen is registered as unique.
		 * 
		 * @param	key a registered screen
		 * @return  A array of screens, if the screen is not unique the lenght of the array is always 1. 
		 */
		public function getScreens(key : String):Array {
			var data : ScreenDefinition = getScreenDefinition(key);
			if (data && data.unique)
				return data.screens.filter(function(item:*, index:int, array:Array):Boolean{return item != null});
			else
				return [data.prototype];
		}
		
		/**
		 * Executes the show function of the screen registered with the given key. If the screen is registered as unique, a new instance is created.
		 * 
		 * @param	key a registered key
		 * @return <code>null</code> if the key is not registered
		 */
		public function show(key : String):Screen {
			var screen : Screen = getScreen(key);
			if (screen != null) {
				screen.show();
				screen.dispatchEvent(new ScreenEvent(ScreenEvent.SHOW, this, key, screen.defaultLayerIdx));
			}
			return screen;
		}
		
		/**
		 * Executes the hide function of the screen registered with the given key. 
		 * If the screen is registered as unique and the INDEX_SEPERATOR is not used , all screens with this key are hidden.
		 * 
		 * @param	key a registered key
		 * 
		 * @example
		 * <listing version="3.0">
		 * Flow.screens.register("EXAMPLE", new Example(), 0, true);
		 * 
		 * // show 4 screens
		 * Flow.screens.show("EXAMPLE");
		 * Flow.screens.show("EXAMPLE");
		 * Flow.screens.show("EXAMPLE");
		 * Flow.screens.show("EXAMPLE");
		 * 
		 * // hide the third
		 * Flow.screens.hide("EXAMPLE#2");
		 * 
		 * // hide the rest
		 * Flow.screens.hide("EXAMPLE");
		 * </listing>
		 */
		public function hide(key : String):void {
			var subkeys : Array = key.split(INDEX_SEPERATOR);
			var data : ScreenDefinition = getScreenDefinition(subkeys[0]);
			if (data) {
				if (data.unique) {
					if (subkeys.length == 2) {
						var idx : int = parseInt(subkeys[1] as String);
						if (idx < data.screens.length && data.screens[idx] != null)
							hideScreen(data.screens[idx] as Screen);
						else
							throw new Error("key(" + key + ") does not exist.");
					}
					else {
						for each(var screen : Screen in data.screens)
							hideScreen(screen);
					}
				}
				else {
					hideScreen(data.prototype);
				}
			}
		}
		
		/**
		 * Pop a screen from a layer, if the screen is on a layer of this ScreenManager.
		 * If the screen is registered and unique, the screen instance is destroyed an completly removed from the ScreenManager
		 * 
		 * @param	screen
		 */
		public function pop(screen : Screen):void {
			var layer : ScreenLayer = getLayerByScreen(screen);
			if (layer != null) {
				layer.remove(screen);
				screen.dispatchEvent(new ScreenEvent(ScreenEvent.LAYER_POP, this));
			}
			removeScreen(screen);
		}
		
		//=============================================================
		// Instance Helper Functions
		//=============================================================
		
		private function createUniqueScreen(data : ScreenDefinition):Screen {
			var screen : Screen = data.prototype.clone();
			var idx : int = data.screens.indexOf(null);
			if (idx != -1)
				data.screens[idx] = screen;
			else
				idx = data.screens.push(screen) - 1;

			screen.dispatchEvent(new ScreenEvent(ScreenEvent.INIT, this, data.prototype.key + INDEX_SEPERATOR + idx.toString(), data.dafaultLayer, data.prototype, data.unique));
			return screen;
		}
		
		private function getScreenDefinition(key : String):ScreenDefinition {
			key = key.split(INDEX_SEPERATOR)[0] as String;
			if (_classes[key] != null && _classes[key] != undefined)
				return _classes[key];
			else
				return null;
		}
		
		private function hideScreen(screen : Screen):void {
			if (screen) {
				screen.hide();
				screen.dispatchEvent(new ScreenEvent(ScreenEvent.HIDE, this));
			}
		}
		
		private function removeScreen(screen : Screen):void {
			var def : ScreenDefinition = getScreenDefinition(screen.key);
			if (def && def.unique) {
				var idx : int = def.screens.indexOf(screen);
				if (idx != -1)
					def.screens[idx] = null;
				screen.dispatchEvent(new ScreenEvent(ScreenEvent.KILL, this));
			}
		}
		
		private function getLayer(idx : uint):ScreenLayer {
			if (_layers[idx] == null) {
				_layers[idx] = new ScreenLayer(this);
								
				var idxBefore : int = -1;
				for (var i : int = idx - 1; i >= 0; i--)
					if (_layers[i] != null && _layers[i] != undefined) {
						idxBefore = _root.indexOf(_layers[i].container);
						break;
					}
				
				_root.splice(idxBefore + 1, 0, _layers[idx].container)
			}
			return _layers[idx];
		}
	}
}
import com.platogo.flow.screens.Screen;


internal class ScreenDefinition {
	public var prototype : Screen;
	public var screens : Array;
	public var unique : Boolean;
	public var dafaultLayer : uint;
}