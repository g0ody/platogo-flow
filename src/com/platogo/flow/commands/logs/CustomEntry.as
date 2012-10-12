package com.platogo.flow.commands.logs 
{
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.core.LogFile;
	import com.platogo.flow.enums.LogLevel;
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public class CustomEntry extends Command {
		
		private var _id:String;
		private var _key:String;
		private var _level : LogLevel;
		
		public var message : String;
		
		public function CustomEntry( id : String, key :String, level:LogLevel) {
			_id = id;
			_key = key;
			_level = level;
		}
		
		public function AMessage(message : String) : CustomEntry {
			this.message = message;
			return this;
		}
			
		static public function create( id : String, key :String, level:LogLevel): CustomEntry{
			return new CustomEntry(id, key , level);
		}
		
		override public function clone():Command {
			return new CustomEntry(_id, _key , _level).SetAttributes(this);
		}
		
		override protected function execute():void {
			LogFile.instance.customentry(_id, _key, _level, message);
			complete();
		}
		
		override public function toDetailString():String {
			return "id=" + String(_id) + ", key=" + String(_key)+ ", level=" + String(_level) + ", message=" + String(message); 
		}
		
	}

}