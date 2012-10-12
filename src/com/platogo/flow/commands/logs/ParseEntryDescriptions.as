package com.platogo.flow.commands.logs 
{
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.core.LogFile;
	import com.platogo.flow.enums.LogLevel;
	import com.platogo.flow.utils.Utils;
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public class ParseEntryDescriptions extends Command {
		private var _defaultLevel:LogLevel;
		private var _data:Object;
		
		public var levelKey:String= "level";
		public var messageKey:String = "message";
		
		public function ParseEntryDescriptions(data:Object, defaultLevel : LogLevel) {
			_defaultLevel = defaultLevel;
			_data = data;
		}
		
		public function ALevelKey( levelKey : String ) : ParseEntryDescriptions {
			this.levelKey = levelKey;
			return this;
		}
		
		public function AMessageKey( messageKey : String ) : ParseEntryDescriptions {
			this.messageKey = messageKey;
			return this;
		}
		
		static public function create(data:Object, defaultLevel : LogLevel): ParseEntryDescriptions{
			return new ParseEntryDescriptions(data, defaultLevel);
		}
		
		override public function clone():Command {
			return new ParseEntryDescriptions(_data, _defaultLevel).SetAttributes(this);
		}
		
		override protected function execute():void {
			LogFile.instance.parse(Utils.getReferenceData(_data), _defaultLevel, messageKey, levelKey);
			complete();
		}
		
		override public function toDetailString():String {
			return "data=" + String(_data) + ", defaultLevel=" + String(_defaultLevel)+ ", messageKey=" + String(messageKey) + ", levelKey=" + String(levelKey); 
		}
		
	}

}