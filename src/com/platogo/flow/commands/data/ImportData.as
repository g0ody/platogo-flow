package com.platogo.flow.commands.data {
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.commands.core.DataCommand;
	import com.platogo.flow.core.DataManager;
	
	//this command registers data to the data manager
	public class ImportData extends DataCommand {
		protected var _data:Object;
		
		public function ImportData(data:Object) {
			_data = data;
		}
		
		static public function create(data:*): ImportData{
			return new ImportData(data);
		}
		
		override public function clone():Command {
			return new ImportData(_data).SetAttributes(this);
		}
		
		override protected function execute():void {
			var instance : DataManager = GetDataManagerInstance();
			if (instance)
				instance.parse(_data);
			complete();
		}
		
		override public function toDetailString():String {
			return "data=" + String(_data); 
		}
	}
}