package com.platogo.flow.data {
	import com.platogo.flow.core.DataManager;
	/**
	 * A utility class to read and convert data from an instance of DataManager
	 * @author Dominik Hurnaus
	 * @see	com.platogo.flow.core.DataManager#getValue()
	 */
	public class DataConverter extends DataRef{

		/**
		 * a function, that takes the data for the key as parameter and returns some value
		 */
		public var converter : Object;

		/**
		 * 
		 * @param	key						a registered key in the DataManager
		 * @param	converter				a function, that takes the data for the key as parameter and return some value
		 * @param	alternativeDataManager	The name of an alternative DataManager (if not set the default DataManager is used)
		 */
		public function DataConverter(key : String, converter : Object, alternativeDataManager : String = null) {
			super(key, alternativeDataManager);
			this.converter = converter;
		}
		
		override public function get value():* {
			var instance : DataManager = getDataManager();
			if (instance)
				return instance.getValue(this.key, converter);
			else {
				//TODO: Throw error
				return null;
			}
		}


	}
}