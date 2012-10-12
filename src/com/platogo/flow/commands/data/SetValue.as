package com.platogo.flow.commands.data {
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.commands.core.DataCommand;
	import com.platogo.flow.core.DataManager;
	import com.platogo.flow.utils.Utils;
	
	//this command registers data to the data manager
	public class SetValue extends DataCommand {
		protected var _key:String;
		protected var _data:*;
		
		public function SetValue(key:String, data:*) {
			_key = key;
			_data = data;
		}
	
		static public function create(key:String, data:*): SetValue{
			return new SetValue(key, data);
		}
		
		override public function clone():Command 
		{
			return new SetValue(_key, _data).SetAttributes(this);
		}
		
		override protected function execute():void {
			var instance : DataManager = GetDataManagerInstance();
			if (instance)
				instance.setValue(_key, Utils.getReferenceData(_data));
			
			//TODO: throw error
			
			complete();
		}
		
		override public function toDetailString():String {
			return "key=" + String(_key) + " ,data=" + String(_data); 
		}
	}
}