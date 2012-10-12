package com.platogo.flow.commands.data {
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.commands.core.DataCommand;
	import com.platogo.flow.core.DataManager;
	
	//this command unregisters data from the data manager
	public class UnregisterData extends DataCommand {
		
		protected var _key:String;
		
		public function UnregisterData(key:String) {
			_key = key;
		}
		
		static public function create(key:String ): UnregisterData{
			return new UnregisterData(key);
		}
		
		override protected function execute():void {
			var instance : DataManager = GetDataManagerInstance();
			
			if (instance)
				instance.unregister(_key);
				
			complete();
		}
		
		override public function clone():Command
		{
			return new UnregisterData(_key);
		}
		
		override public function toDetailString():String {
			return "key=" + String(_key); 
		}
	}
}