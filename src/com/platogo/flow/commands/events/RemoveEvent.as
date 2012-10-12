package com.platogo.flow.commands.events {
	import _as.fla.events.EC;
	import com.platogo.flow.commands.core.Command;
	import flash.events.IEventDispatcher;
	
	//this command encapsulates the addEventListener() method
	public class RemoveEvent extends Command {
		
		private var _obj:*;
		
		public var type:String = null;
		public var listener:Function= null;
		
		public function RemoveEvent(obj:*) {
			_obj = obj;
		}
		
		public function AType( type:String) : RemoveEvent {
			this.type = type;
			return this;
		}
		
		public function AListener( listener:Function) : RemoveEvent {
			this.listener = listener;
			return this;
		}
		
		static public function create(obj:*): RemoveEvent{
			return new RemoveEvent(obj);
		}
		
		override public function clone():Command 
		{
			return new RemoveEvent(_obj).SetAttributes(this);
		}
		
		override protected function execute():void {
			EC.remove(_obj, type, listener, false);
			complete();
		}
		
		override public function toDetailString():String {
			return "obj=" + String(_obj) + ", type=" + String(type)+ ", listener=" + String(listener); 
		}
	}
}