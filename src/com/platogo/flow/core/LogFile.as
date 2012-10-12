package com.platogo.flow.core 
{
	import com.platogo.flow.enums.LogLevel;
	import flash.utils.Dictionary;
	/**
	 * The LogFile provides a entry type registration service and can generate a log entry history.
	 * 
	 * @author Dominik Hurnaus
	 */
	public class LogFile{
		private static var _instance : LogFile;
		
		private var _log : Array = new Array();
		private var _entries : Dictionary = new Dictionary();
		
		/**
		 * If enabled getLog() is used to get a complete log history 
		 * @default true
		 */
		public var logEnabled : Boolean = true;
		
		/**
		 * This function is used for the output. If set to <code>null</code> this functionality is disabled.
		 * @default trace
		 */
		public var consol : Function = trace;
		
		/**
		 * This and higher levels are forwarded to the consol function
		 * @default DEBUG
		 */
		public var consolLevel : LogLevel = LogLevel.DEBUG;
		
		
		/**
		 * Use LogFile.instance to access the class
		 */
		public function LogFile(pvt:SingletonEnforcer) {
		}
		
		//=============================================================
		// Static Functions
		//=============================================================
	
		/**
		 * Access to the single instance of LogFile
		 */
		public static function get instance():LogFile {
			if (!_instance)
				_instance = new LogFile( new SingletonEnforcer());
			return _instance;
		}
		
		
		
		//=============================================================
		// Instance Functions
		//=============================================================
		
		/**
		 * Register a entry Type
		 * 
		 * @param	key		key to access the entry type
		 * @param	level	level of the entry type
		 * @param	message	description of the entry type
		 */
		public function register(key :String, level : LogLevel, message : String = ""):void {
			if(level != null)
				_entries[key] = new EntryDescription(level, message);
		}
		
		/**
		 * Unregister a entry type
		 * @param	key	key of a regiostered entry type
		 */
		public function unregister(key:String):void {
			delete _entries[key];
		}
		
		/**
		 * Register several entry types at once. The data object has to be structures in a certain way. 
		 * This makes it possible to define keys in anexternal file and later inport it into the system.
		 * 
		 * Option 1: A key is registered with a certain message. All entry types use the defaultLevel parameter as level
			 * {
			 * 		key : message,
			 * 		key : message,
			 * 		key : message,
			 * 		.....
			 * }
		 * 
		 * Option 2: A key is registered with a certain message. The message is in an object uder the parameter messageKey. All entry types use the defaultLevel parameter as level,
			 * {
			 * 		key : { $messageKey : message },
			 * 		key : { $messageKey : message },
			 * 		key : { $messageKey : message },
			 * 		.....
			 * }
		 * 
		 * Option 3: A key is registered with a certain message and level. the messageKey parameter is used to access the message and the levelKey parameter to access the level.
			 * {
			 * 		key : { $messageKey : message, $levelKey : level },
			 * 		key : { $messageKey : message, $levelKey : level },
			 * 		key : { $messageKey : message, $levelKey : level },
			 * 		.....
			 * }
		 * 
		 * 
		 * @param	data the data object in one of the three options
		 * @param	defaultLevel	is only used for option 1 and 2
		 * @param	messageKey		is only used for option 2 and 3
		 * @param	levelKey		is only used for option 3
		 * 
		 * @see #register()
		 */
		public function parse(data:Object, defaultLevel : LogLevel, messageKey : String = "message", levelKey : String = "level"):void {
			for (var key:String in data) {
				if (data[key] is String)
					register(key, defaultLevel, data[key] as String);
				else if (data[key][messageKey] is String)
					if (data[key][levelKey] is String)
						register(key, LogLevel.parse(data[key][levelKey] as String), data[key][messageKey] as String);
					else 
						register(key, defaultLevel, data[key][messageKey] as String);
			}
		}
		
		/**
		 * Get the message to a key
		 * @param	key		key of a registered entry type
		 * @return the description of a entry type
		 */
		public function getMessage(key :String):String {
			if(_entries[key] is EntryDescription)
				return (_entries[key] as EntryDescription).message;
			else
				return null;
		}
		
		/**
		 * Get the log level to a key
		 * @param	key		key of a registered entry type
		 * @return the description of a entry type
		 */
		public function getLogLevel(key :String):LogLevel {
			if(_entries[key] is EntryDescription)
				return (_entries[key] as EntryDescription).level;
			else
				return null;
		}
		
		/**
		 * Put a specific entry type into the log
		 * 
		 * @param	id	id for the object, which called the entry
		 * @param	key	key of a registered entry type
		 */
		public function entry( id : String, key :String):void {
			var descr: EntryDescription = _entries[key];
			if (descr != null)
				customentry(id, key, descr.level, descr.message);
		}
		
		/**
		 * A custom entry that is not registered in the LogFile
		 * 
		 * @param	id		id for the object, which called the entry
		 * @param	key		entry key
		 * @param	level	level of entry
		 * @param	message	entry message
		 */
		public function customentry( id : String, key :String, level:LogLevel, message : String = ""):void {
			var logentry : LogEntry = new LogEntry(id, level, new Date(), key, message);
			if (logEnabled)
				_log.push(logentry);
			
			if (consol != null && level.value >= consolLevel.value)
				consol.call(null, logentry.toString());
		}
		
		/**
		 * A debug entry that is not registered in the LogFile
		 * 
		 * @param	id		id for the object, which called the entry
		 * @param	key		entry key
		 * @param	message	entry message
		 */
		public function debug( id : String, key :String, message : String = ""):void {
			customentry(id, key, LogLevel.DEBUG, message);
		}
		
		/**
		 * A message entry that is not registered in the LogFile
		 * 
		 * @param	id		id for the object, which called the entry
		 * @param	key		entry key
		 * @param	message	entry message
		 */
		public function message( id : String, key :String, message : String = ""):void {
			customentry(id, key, LogLevel.MESSAGE, message);
		}
		
		/**
		 * A warning entry that is not registered in the LogFile
		 * 
		 * @param	id		id for the object, which called the entry
		 * @param	key		entry key
		 * @param	message	entry message
		 */
		public function warning( id : String, key :String, message : String = ""):void {
			customentry(id, key, LogLevel.WARNING, message);
		}
		
		/**
		 * A error entry that is not registered in the LogFile
		 * 
		 * @param	id		id for the object, which called the entry
		 * @param	key		entry key
		 * @param	message	entry message
		 */
		public function error( id : String, key :String, message : String = ""):void {
			customentry(id, key, LogLevel.ERROR, message);
		}
		
		/**
		 * A critical entry that is not registered in the LogFile
		 * 
		 * @param	id		id for the object, which called the entry
		 * @param	key		entry key
		 * @param	message	entry message
		 */
		public function critical( id : String, key :String, message : String = ""):void {
			customentry(id, key, LogLevel.CRITICAL, message);
		}
		
		/**
		 * Get a complete log history
		 * @param	logLevel	This and higher levels are put into the history
		 * @return	A history of log entries
		 */
		public function getLog(logLevel : LogLevel):String {
			var file : String = "";
			for each(var logentry : LogEntry in _log) {
				if(logentry.level.value >= logLevel.value)
					file += logentry.toString();
			}
			return file;
		}
	}
}

	import com.platogo.flow.enums.LogLevel;
	/**
	 * @private
	 * @author Dominik
	 */
	internal class LogEntry {
		public var id : String;
		public var time : Date ;
		public var level : LogLevel;
		public var key : String;
		public var message : String;
		
		public function LogEntry(id : String, level:LogLevel, time:Date, key : String, message : String) {
			this.key = key;
			this.level = level;
			this.time = time;
			this.message = message;
			this.id = id;
		}
		
		public function toString():String {
			return time.toString() + " : " + formatString(id,20) + " : " +  formatString(level.toString(), 8) + " : " + formatString(key,20) + " : " + String(message);
		}
		
		private function formatString(str : String , minlength : uint = 0): String {
			if (str.length >= minlength)
				return str;
			else {
				for ( var i : int = minlength - str.length; i > 0; i --) {
					str += " ";
				}
				return str;
			}
		}
		
	}
	
	import com.platogo.flow.enums.LogLevel;
	/**
	 * @private
	 * @author Dominik
	 */
	internal class EntryDescription 
	{
		public var level : LogLevel;
		public var message : String;

		public function EntryDescription(level:LogLevel, message : String) {
			this.level = level;
			this.message = message;
		}
	}
	
	internal class SingletonEnforcer{}