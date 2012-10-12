package com.platogo.flow.enums 
{
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public final class LogLevel {
		
		private static var _enumCreated:Boolean = false;

		{
			_enumCreated = true;
		}
		
		public static const DEBUG:LogLevel = new LogLevel(0,"Debug");
		public static const MESSAGE:LogLevel = new LogLevel(1,"Message");
		public static const WARNING:LogLevel = new LogLevel(2,"Warning");
		public static const ERROR:LogLevel = new LogLevel(3,"Error");
		public static const CRITICAL:LogLevel = new LogLevel(4,"Critical");

		private var _type:String;
		private var _level:uint;

		public function LogLevel(level:uint, type:String) {
			if (_enumCreated) {
				throw new Error("LogLevel must not be instantiated directly.");
			}
			_level = level;
			_type = type;
		}
		
		public function get value():uint {
			return _level;
		}

		public function toString():String {
			return _type;
		}
		
		public static function parse(value : String):LogLevel {
			value = value.toLowerCase();
			switch(value) {
				case "critical": return CRITICAL;
				case "error": return ERROR;
				case "warning": return WARNING;
				case "message": return MESSAGE;
				case "debug": return DEBUG;
				default : return null;
			}
		}
	}
}