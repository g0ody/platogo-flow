package com.platogo.flow 
{
	import com.platogo.flow.core.CommandManager;
	import com.platogo.flow.core.DataManager;
	import com.platogo.flow.core.LogFile;
	import com.platogo.flow.core.ScreenManager;
	
	/**
	 * This is a convenience class to access the different managers supplied by the framework.
	 * 
	 * @author Dominik Hurnaus
	 */
	public class Flow{
		static private var _screens : ScreenManager;
		static private var _commands : CommandManager;
		static private var _data : DataManager;
		
		/**
		 * Initialize the default Managers (ScreenManager, CommandManager, DataManager)
		 * @see com.platogo.flow.core.ScreenManager
		 * @see com.platogo.flow.core.CommandManager
		 * @see com.platogo.flow.core.DataManager
		 * @see com.platogo.flow.core.LogFile
		 */
		static public function defaultInit():void {
			_screens = ScreenManager.defaultInstance;
			_commands = CommandManager.defaultInstance;
			_data = DataManager.defaultInstance;
		}
		
		/**
		 * Reference to the ScreenManager.
		 * 
		 * <p>WARNING: this property must only be accessed after defaultInit has been executed.</p>
		 * 
		 * @example
		 * The ScreenManager is use to register a ExampleScreen with the key Example
		 * <listing version="3.0">
		 * Flow.screens.register("Example", new ExampleScreen());
		 * </listing>
		 */
		static public function get screens():ScreenManager {
			return _screens;
		}
		
		/**
		 * Reference to the CommandManager.
		 * 
		 * <p>WARNING: this property must only be accessed after defaultInit has been executed.</p>
		 * 
		 * @example
		 * The CommandManager is use to get a command "INTRO" and start it. 
		 * <listing version="3.0">
		 * Flow.commands.execute("INTRO").start();
		 * </listing>
		 */
		static public function get commands():CommandManager {
			return _commands;
		}
		
		/**
		 * Reference to the DataManager.
		 * 
		 * <p>WARNING: this property must only be accessed after defaultInit has been executed.</p>
		 * 
		 * @example
		 * The DataManager is use to register a user object and get name of this user afterwards. 
		 * <listing version="3.0">
		 * Flow.data.register("user", {"name":"Example", "position": 5});
		 * var name : String = Flow.data.getValue("user.name") as String;
		 * </listing>
		 */
		static public function get data():DataManager {
			return _data;
		}
		
		/**
		 * Reference to the LogFile.
		 * 
		 * @example
		 * A error is logged in the LogFile
		 * <listing version="3.0">
		 * Flow.logs.error("ExampleClass", "execute", "The value could not be found");
		 * </listing>
		 */
		static public function get logs():LogFile {
			return LogFile.instance;
		}
	}
}