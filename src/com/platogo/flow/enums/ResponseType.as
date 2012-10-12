package com.platogo.flow.enums 
{
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public final class ResponseType {
		
		private static var _enumCreated:Boolean = false;
		{
			_enumCreated = true;
		}
		
		public static const DEFAULT:ResponseType = new ResponseType("NONE");
		public static const ERROR:ResponseType = new ResponseType("ERROR");
		public static const SELECTED:ResponseType = new ResponseType("SELECTED");
		public static const CANCELED:ResponseType = new ResponseType("CANCELED");
		public static const COMPLETED:ResponseType = new ResponseType("COMPLETED");
		public static const FAILED:ResponseType = new ResponseType("FAILED");
		public static const CONFIRMED:ResponseType = new ResponseType("CONFIRMED");
		public static const BLOCKED:ResponseType = new ResponseType("BLOCKED");
		public static const NOLOGIN:ResponseType = new ResponseType("NOLOGIN");
		public static const CHILD_COMPLETED:ResponseType = new ResponseType("CHILD_COMPLETED");
		public static const CHILD_FAILED:ResponseType = new ResponseType("CHILD_FAILED");

		private var _type:String;

		public function ResponseType(type:String) {
			if (_enumCreated) {
				throw new Error("ResponseType must not be instantiated directly.");
			}
			_type = type;
		}
		
		public function toString():String {
			return _type;
		}
	}
}