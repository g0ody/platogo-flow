package com.platogo.flow.data {
	import com.platogo.flow.core.DataManager;
	/**
	 * A utility class to write/read data in an instance of DataManager
	 * @author Dominik Hurnaus
	 * @see	com.platogo.flow.core.DataManager#setValue()
	 * @see	com.platogo.flow.core.DataManager#getValue()
	 */
	public class DataProp extends DataRef {

		/**
		 * 
		 * @param	key						a register key in the DataManager
		 * @param	alternativeDataManager	The name of an alternative DataManager (if not set the default DataManager is used)
		 */
		public function DataProp(key : String, alternativeDataManager : String = null) {
			super(key, alternativeDataManager);
		}

		/**
		 * Set the specific data in the DataManager if possible
		 */
		public function set value(v : *):void {
			var instance : DataManager = getDataManager();
			if (instance)
				instance.setValue(key, v);
			else {
				//TODO: Throw error
			}
		}

		public function set asInteger(v:int):void {
			value = v;
		}
		
		public function set asString(v:String):void {
			value = v;
		}
		
		public function set asNumber(v:Number):void {
			value = v;
		}
		
		public function set asUInt(v:uint):void {
			value = v;
		}
		
		public function set asXML(v:XML):void {
			value = v;
		}
		
		public function set asXMLList(v:XMLList):void {
			value = v;
		}
		
		public function set asArray(v:Array):void {
			value = v;
		}
	}
}