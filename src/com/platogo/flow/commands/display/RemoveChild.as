package com.platogo.flow.commands.display {
	import com.platogo.flow.commands.core.Command;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	//This command encapsulates the removeChild() method
	public class RemoveChild extends AddChild {
		
		public function RemoveChild(container:DisplayObjectContainer, displayObject:DisplayObject) {
			super(container, displayObject);
		}
		
		static public function create(container:DisplayObjectContainer, displayObject:DisplayObject): RemoveChild{
			return new RemoveChild(container, displayObject);
		}
		
		override public function clone():Command 
		{
			return new RemoveChild(_container, _displayObject).SetAttributes(this);
		}
		
		override protected function execute():void {
			if(_container && _displayObject)
				_container.removeChild(_displayObject);
				
			complete();
		}
		
		override public function toDetailString():String {
			return "container=" + String((_container != null)?_container.name:_container) + ", displayObject=" + String((_displayObject != null)?_displayObject.name:_displayObject); 
		}
	}
}