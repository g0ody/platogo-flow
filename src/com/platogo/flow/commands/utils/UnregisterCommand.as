package com.platogo.flow.commands.utils {
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.core.CommandManager;
	
	//this command registers data to the data manager
	public class UnregisterCommand extends Command {
		private var _key:String;
		
		public function UnregisterCommand(key:String) {
			_key = key;
		}
		
		static public function create(key:String): UnregisterCommand{
			return new UnregisterCommand(key);
		}
		
		override public function clone():Command{
			return new UnregisterCommand(_key).SetAttributes(this);
		}
		
		override protected function execute():void {
			var instance : CommandManager = GetCommandManagerInstance();
			
			if (instance)
				instance.unregister(_key);
			
			//TODO: throw error
			
			complete();
		}
		
		override public function toDetailString():String {
			return "key=" + String(_key); 
		}
	}
}