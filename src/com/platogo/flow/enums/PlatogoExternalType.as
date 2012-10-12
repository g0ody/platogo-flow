package com.platogo.flow.enums 
{
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public final class PlatogoExternalType {
		
		private static var _enumCreated:Boolean = false;

		{
			_enumCreated = true;
		}
		
		public static const LOGIN : PlatogoExternalType = new PlatogoExternalType("CALL_LOGIN");
		public static const SIGNUP : PlatogoExternalType = new PlatogoExternalType("CALL_SIGNUP");
		public static const LOGOUT : PlatogoExternalType = new PlatogoExternalType("CALL_LOGOUT");

		private var _s:String;

		public function PlatogoExternalType(s:String) {
			if (_enumCreated) {
				throw new Error("PlatogoExternalType must not be instantiated directly.");
			}
			_s = s;
		}
		
		public function toString():String {
			return _s;
		}
	}
}