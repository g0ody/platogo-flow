package com.platogo.flow.data {
	import com.platogo.flow.core.DataManager;
	/**
	 * A utility class to read data in an instance of dataManager
	 * @author Dominik Hurnaus
	 * @see	com.platogo.flow.core.DataManager#getValue()
	 */
	public class DataRef extends DataObject{
		/**
		 * The name of an alternative DataManager (if not set the default DataManager is used)
		 */
		public var alternativeDataManager:String;
		
		/**
		 * a register key in the DataManager
		 */
		public var key : String;

		/**
		 * 
		 * @param	key						a register key in the DataManager
		 * @param	alternativeDataManager	The name of an alternative DataManager (if not set the default DataManager is used)
		 */
		public function DataRef(key : String, alternativeDataManager : String = null) {
			this.alternativeDataManager = alternativeDataManager;
			this.key = key;
		}

		/**
		 * Access the specific data in the DataManager
		 */
		override public function get value():* {
			var instance : DataManager = getDataManager();
			if (instance)
				return instance.getValue(this.key);
			else {
				//TODO: Throw error
				return null;
			}
		}
		
		protected function getDataManager():DataManager {
			if (alternativeDataManager != null && alternativeDataManager.length > 0)
				return DataManager.getInstance(alternativeDataManager);
			else
				return DataManager.defaultInstance;
		}
	}
}