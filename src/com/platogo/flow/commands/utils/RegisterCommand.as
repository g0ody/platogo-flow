package com.platogo.flow.commands.utils {
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.core.CommandManager;
	
	//this command registers data to the data manager
	public class RegisterCommand extends Command {
		private var _key:String;
		private var _command:Command;
		
		public function RegisterCommand(key:String, command:Command) {
			_key = key;
			_command = command;
		}
		
		static public function create(key:String, command:Command): RegisterCommand{
			return new RegisterCommand(key, command);
		}
		
		override public function clone():Command{
			return new RegisterCommand(_key, _command).SetAttributes(this);
		}
		
		override protected function execute():void {
			var instance : CommandManager = GetCommandManagerInstance();
			
			if (instance)
				instance.register(_key, _command);
			
			//TODO: throw error
			
			complete();
		}
		
		override public function toDetailString():String {
			return "key=" + String(_key) + " ,command=" + String(_command); 
		}
	}
}