package com.platogo.flow.commands.utils {
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.data.DataObject;
	import com.platogo.flow.utils.Utils;
	
	public class SetProperties extends Command {
		
		private var _target:Object;
		private var _properties:Object;
		
		public function SetProperties(target:Object, properties:Object) {
			_target = target;
			_properties = properties;
		}
		
		static public function create(target:Object, properties:Object): SetProperties{
			return new SetProperties(target, properties);
		}
		
		override public function clone():Command 
		{
			return new SetProperties(_target, _properties).SetAttributes(this);
		}
		
		override protected function execute():void {
			var target_obj: Object = Utils.getReferenceData(_target);
			
			if (target_obj != null) {
				if (_properties is Array) {
					for each( var prop : Object in _properties) 
						if (prop.key != null && prop.value != null) {
							if (prop.value is DataObject)
								parseKey(target_obj, prop.key, (prop.value as DataObject).value)
							else
								parseKey(target_obj, prop.key, prop.value);
						}		
				}
				else {
					for (var key:String in _properties) {
						if (_properties[key] is DataObject)
							parseKey(target_obj, key, (_properties[key] as DataObject).value)
						else
							parseKey(target_obj, key, _properties[key]);
					}
				}
			}
			complete();
		}
		
		private function parseKey(target: Object, key : Object, value : * ):void {
			if (target == null) return;
			if (key is String) {
				var arr : Array = key.split(".");			
				for ( var i : uint = 0; i < arr.length - 1 ; i++)
					target = target[arr[i]];
							
				target[arr[arr.length - 1]] = value;
			}
			else
				target[key] = value;
		}
		
		override public function toDetailString():String {
			return "target=" + String(_target) + ", properties=" + Utils.convertObjectToString(_properties); 
		}
	}
}