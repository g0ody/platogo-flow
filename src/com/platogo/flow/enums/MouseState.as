package com.platogo.flow.enums 
{
	/**
	 * ...
	 * @author Dominik
	 */
	public final class MouseState 
	{
		private static var _enumCreated:Boolean = false;
		{
			_enumCreated = true;
		}
				
		public static const RELEASED : MouseState = new MouseState("RELEASED", 0);
		public static const DOWN : MouseState = new MouseState("DOWN", 1);
		public static const PRESSED: MouseState = new MouseState("PRESSED", 2);
		public static const UP : MouseState = new MouseState("UP", 3);
		
		private var _type:String;
		private var _value:int;
		
		public function MouseState(type:String, value : int) {
			if (_enumCreated) {
				throw new Error("MouseState must not be instantiated directly.");
			}
			_type = type;
			_value = value;
		}
		
		public function toString():String {
			return _type;
		}
		
		public function get value():int 
		{
			return _value;
		}
	}
}