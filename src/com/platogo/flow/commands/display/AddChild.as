package com.platogo.flow.commands.display {
	import com.platogo.flow.commands.core.Command;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	public class AddChild extends Command {
		protected var _container:DisplayObjectContainer;
		protected var _displayObject:DisplayObject;
		
		public function AddChild(container:DisplayObjectContainer, displayObject:DisplayObject) {
			_container = container;
			_displayObject = displayObject;
		}
		
		static public function create(container:DisplayObjectContainer, displayObject:DisplayObject): AddChild{
			return new AddChild(container, displayObject);
		}
		
		override public function clone():Command 
		{
			return new AddChild(_container, _displayObject).SetAttributes(this);
		}
		
		override protected function execute():void {
			if(_container && _displayObject)
				_container.addChild(_displayObject);
			complete();
		}
		
		override public function toDetailString():String {
			return "container=" + String((_container != null)?_container.name:_container) + ", displayObject=" + String((_displayObject != null)?_displayObject.name:_displayObject); 
		}
	}
}