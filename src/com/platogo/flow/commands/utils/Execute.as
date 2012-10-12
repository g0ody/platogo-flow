package com.platogo.flow.commands.utils 
{
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.core.CommandManager;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public class Execute extends Command {
		private var _key:String;
		
		public var unique:Boolean;

		public function Execute(key :String) {
			_key = key;
		}
		
		public function Unique( unique : Boolean) : Execute {
			this.unique = unique;
			return this;
		}
		
		static public function create(key :String): Execute{
			return new Execute(key);
		}
		
		override public function clone():Command {
			return new Execute(_key).SetAttributes(this);
		}
		
		override protected function execute():void {
			var commandmanager : CommandManager = GetCommandManagerInstance();
				
			if (commandmanager) {
				var command : Command =  commandmanager.execute(_key, unique);
				if (command) {
					command.addEventListener(Event.COMPLETE, complete);
					command.start();	
				}
				else {
					//TODO: throw Errro
					complete();
				}
				
			}
			else {
				//TODO: throw Errro
				complete();
			}
		}
		
		override public function toDetailString():String {
			return "key=" + String(_key) + ", unique=" + String(unique)+ ", alternativeCommandManager=" + String(customCommandManager); 
		}	
	}

}