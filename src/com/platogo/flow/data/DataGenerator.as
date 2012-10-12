package com.platogo.flow.data {
	import com.platogo.flow.core.DataManager;
	/**
	 * A utility class to read and convert data from an instance of DataManager
	 * @author Dominik Hurnaus
	 * @see	com.platogo.flow.core.DataManager#getValue()
	 */
	public class DataGenerator extends DataObject{

		public var generator : Function;

		public function DataGenerator(generator : Function) {
			this.generator = generator;
		}
		
		override public function get value():* {
			return generator();
		}
	}
}