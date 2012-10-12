package com.platogo.flow.commands.core {
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.core.DataManager;
	
	//this command registers data to the data manager
	public class DataCommand extends Command {
		public var customDataManager:String;
		
		public function DataCommand() {
		}
		
		public function ACustomDataManager(alternativeDataManager:String) : DataCommand {
			this.customDataManager = alternativeDataManager;
			return this;
		}

		override public function clone():Command {
			return new DataCommand().SetAttributes(this);
		}
		
		protected function GetDataManagerInstance() : DataManager
		{
			if (customDataManager != null && customDataManager.length > 0)
				return DataManager.getInstance(customDataManager);
			else
				return DataManager.defaultInstance;
		}
	}
}