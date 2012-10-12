package com.platogo.flow.core 
{
	import flash.utils.Dictionary;
	/**
	 * FlowInternal registers instanciated managers and provides access for classes that use multiple managers.
	 * E.g.: The CommandScreen Class is a Screen and needs access to the Screenmanager , but also to the Commandmanager (but not to the DataManager and the LogManager).
	 * 
	 * @see com.platogo.flow.screen.CommandScreen
	 * @author Dominik
	 */
	final public class FlowInternal 
	{
		private static var _instance : FlowInternal;
		private var _managers : Dictionary = new Dictionary();
		
		/**
		 * @private
		 */
		public function FlowInternal(pvt:SingletonEnforcer) {
			
		}

		/**
		 * @private
		 */
		private static function get instance():FlowInternal {
			if (!_instance)
				_instance = new FlowInternal(new SingletonEnforcer());
			return _instance;
		}

		/**
		 * Register a manager. the default managers (ScreenManager, CommandManager, DataManager to this automatically)
		 */
		public static function register( manager : IManager):void {
			instance.register(manager);
		}
		
		/**
		 * Unegister a manager.
		 */
		public static function unregister( name : String):void {
			instance.unregister(name);
		}
		
		/**
		 *  Check availability of a manager
		 */
		public static function has( name : String):Boolean {
			return instance.has(name);
		}
		
		/**
		 * Get a registered manager
		 */
		public static function getManager( name : String):IManager {
			return instance.getManager(name);
		}

		internal function register( manager : IManager):void {
			_managers[manager.name] = manager;
		}
		
		internal function unregister( name : String):void {
			delete _managers[name];
		}
		
		internal function has(name : String):Boolean {
			return _managers[name] != null;
		}
		
		internal function getManager(name : String):IManager {
			return _managers[name];
		}
		
	}

}

internal class SingletonEnforcer{}