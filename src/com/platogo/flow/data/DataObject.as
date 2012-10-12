package com.platogo.flow.data {
	
	public class DataObject {
		
		public function get value():* {
			return null;
		}
		
		public function get asBoolean():Boolean {
			return value as Boolean;
		}

		public function get asInteger():int {
			return value as int;
		}
		
		public function get asString():String {
			return value as String;
		}
		
		public function get asNumber():Number {
			return value as Number;
		}
		
		public function get asUInt():uint {
			return value as uint;
		}
		
		public function get asXML():XML {
			return value as XML;
		}
		
		public function get asXMLList():XMLList {
			return value as XMLList;
		}
		
		public function get asArray():Array {
			return value as Array;
		}
	}
}