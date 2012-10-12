package com.platogo.flow.core
{
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.commands.ICaller;
	import com.platogo.flow.commands.utils.Dummy;
	import com.platogo.flow.utils.Utils;
	import flash.utils.Dictionary;
	
	/**
	 * The CommandManager provides a command caller and a command registration service to handle command execution.
	 * 
	 * @author Dominik Hurnaus
	 */
	public class CommandManager implements IManager {
		/**
		 * The default manager name
		 */
		public static const DEFAULT_MANAGER_NAME : String = "CommandManager";
		
		private var _caller: Dictionary = new Dictionary();
		private var _commands: Dictionary = new Dictionary();
		private var _name : String = DEFAULT_MANAGER_NAME;
		
		/**
		 * The CommandManager functionality includes:
		 * <li>register commands</li>
		 * <li>unregister commands</li>
		 * <li>execute commands</li>
		 * <li>add caller</li>
		 * <li>remove caller</li>
		 * <li>call caller</li>
		 * 
		 * @param	alternativeName A alternative name, if more than one CommandManager is used.
		 * 
		 * @example
		 * There are several ways to initialize the CommandManager and work with it.
		 * <br>
		 * The Default way is to use the convenience class com.platogo.flow.Flow
		 * 
		 * <listing version="3.0">
		 * Flow.defaultInit();
		 * 
		 * // register a new command, this can be one simple command or a complex series of commands using sequence commands (com.platogo.flow.commands.sequence)
		 * Flow.commands.register("SHOW_EXAMPLE", new ShowScreen("EXAMPLE"));
		 * 
		 * // Add a custom caller, a caller implements the com.platogo.flow.commands.ICaller interface. Providing the possibility to covert every Object into a caller class.
		 * // A caller has only one function call() which returns a custom command. It provides more options in the command creation. 
		 * 
		 * Flow.commands.addCaller("CUSTOM", new CustomCaller());
		 * 
		 * // execute the command
		 * Flow.commands.execute("SHOW_EXAMPLE", false, true);
		 * 
		 * // call a command of caller
		 * var command : Command = Flow.commands.call("CUSTOM", "CUSTOM_COMMAND");
		 * 
		 * // start/execute the command
		 * command.start();
		 * </listing>
		 * 
		 * Use a custom CommandManager
		 * 
		 * <listing version="3.0">
		 * 
		 * var commands : CommandManager = new CommandManager("MyCommands");
		 * // register a command
		 * commands.register("SHOW_EXAMPLE", new ShowScreen("EXAMPLE"));
		 * 
		 * // execute a command
		 * commands.execute("SHOW_EXAMPLE").start();
		 * 
		 * // unregister a command
		 * commands.unregister("SHOW_EXAMPLE");
		 * </listing>
		 */
		public function CommandManager(alternativeName : String = null) {
			if (alternativeName != null && alternativeName.length > 0)
				_name = alternativeName;
				
			FlowInternal.register(this);
		}
		
		/* INTERFACE com.platogo.flow.core.IManager */
		/**
		 * The name of the instance.
		 */
		public function get name():String {
			return _name;
		}
		
		/**
		 * Access to the default CommandManager Instance.
		 */
		public static function get defaultInstance():CommandManager {
			var instance : CommandManager = getInstance(CommandManager.DEFAULT_MANAGER_NAME);
			if (!instance)
				instance = new CommandManager();
			return instance;
		}
		
		/**
		 * Resturns a specific CommandManager instance.
		 * @param	name of a CommandManager instance
		 * @return <code>null</code> if there is no CommandManager with the specific name.
		 */
		public static function getInstance(name : String):CommandManager {
			return FlowInternal.getManager(name) as CommandManager;
		}
		
		//=============================================================
		// Instance Functions
		//=============================================================
		
		/**
		 * Add a command caller to the CommandManager
		 * 
		 * @param	key		the key to call the caller
		 * @param	caller	a instance of a command caller
		 */
		public function addCaller( key : String,  caller : ICaller ) :void {
			_caller[key] = caller;
		}

		/**
		 * Remove a command caller from the CommandManager
		 * 
		 * @param	key		the key of the caller
		 */
		public function removeCaller(key : String):void {
			delete _caller[key];
		}
		
		/**
		 * Register a command
		 * 
		 * @param	key	key to execute the Command
		 * @param	command	a instance of the command
		 */
		public function register(key : String, command : Command):void {
			_commands[key] = command;
		}
		
		/**
		 * Unregister a command
		 * @param	key key of a registered command
		 */
		public function unregister(key : String):void {
			delete _commands[key];
		}

		/**
		 * Get a specific caller
		 * @param	key the key of the caller
		 */
		public function getCaller(key : String):ICaller {
			return _caller[key];
		}

		/**
		 * Call a specific caller for a custome command
		 * 
		 * @param	caller	the caller key
		 * @param	cmd_id	the command key
		 * @param	params	a array of parameters (if necessary for the command)
		 * @param	autoStart	if set to <code>true</code> the command ist executed immediately (other wiese call the start() function of the command)
		 * @return	returns an instance of the custom command
		 */
		public function call(caller: String, cmd_id:String, params : Array = null, autoStart : Boolean = false):Command {
			var caller_obj : ICaller = _caller[caller as String] as ICaller;
			
			if (caller_obj) {
				var command : Command = caller_obj.call(cmd_id, Utils.getArrayReferences(params));
				if (command) {
					if (autoStart)
						command.start();
					return command;
				} else {
					//LogManager.instance.error("CommandManager", "Execute", "Command " + String(cmd_id) + " not available on " + String(caller)); 
					return new Dummy();
				}
			} else  {
				//LogManager.instance.error("CommandManager", "Execute", "Caller " + String(caller) + " not available"); 
				return new Dummy();
			}
		}
		
		/**
		 * 
		 * @param	key			the key of the registered command
		 * @param	unique		if set to <code>true</code> a new instance of the command is created (works also for sequences of commands)
		 * @param	autoStart	if set to <code>true</code> the command ist executed immediately (other wiese call the start() function of the command)
		 * @return	the instance of the command
		 */
		public function execute(key :String, unique : Boolean = false, autoStart : Boolean = false):Command {
			var command : Command = _commands[key]  as Command;
			if (command) {
				if (unique) 
					command = command.clone();
				
				if (autoStart) 
					command.start();

				return command;
			} else {
				//LogManager.instance.error("CommandManager", "Execute", "Command " + String(key) + " not available"); 
				return null;
			}
		}
	}
}