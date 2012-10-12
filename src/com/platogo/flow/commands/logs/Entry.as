package com.platogo.flow.commands.logs 
{
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.core.LogFile;
	import com.platogo.flow.enums.LogLevel;
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public class Entry extends Command {
		
		private var _id:String;
		private var _key:String;
		
		public function Entry( id : String, key :String) {
			_id = id;
			_key = key;
		}
		
		static public function create( id : String, key :String): Entry{
			return new Entry(id, key);
		}
		
		override public function clone():Command {
			return new Entry(_id, _key).SetAttributes(this);
		}
		
		override protected function execute():void {
			LogFile.instance.entry(_id, _key);
			complete();
		}
		
		override public function toDetailString():String {
			return "id=" + String(_id) + ", key=" + String(_key); 
		}
		
	}

}