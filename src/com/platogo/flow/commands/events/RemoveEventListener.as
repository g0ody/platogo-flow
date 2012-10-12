package com.platogo.flow.commands.events {
	import com.platogo.flow.commands.core.Command;
	import flash.events.IEventDispatcher;
	
	public class RemoveEventListener extends Command {
		
		private var _dispatcher:IEventDispatcher;
		private var _type:String;
		private var _listener:Function;
		
		public function RemoveEventListener(dispatcher:IEventDispatcher, type:String, listener:Function) {
			_dispatcher = dispatcher;
			_type = type;
			_listener = listener;
		}
		
		static public function create(dispatcher:IEventDispatcher, type:String, listener:Function): RemoveEventListener{
			return new RemoveEventListener(dispatcher, type, listener);
		}
		
		override public function clone():Command 
		{
			return new RemoveEventListener(_dispatcher, _type, _listener).SetAttributes(this);
		}
		
		override protected function execute():void {
			_dispatcher.addEventListener(_type, _listener);
			complete();
		}
		
		override public function toDetailString():String {
			return "dispatcher=" + String(_dispatcher) + ", type=" + String(_type)+ ", listener=" + String(_listener); 
		}
	}
}