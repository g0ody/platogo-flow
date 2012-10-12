package com.platogo.flow.commands.events {
	import _as.fla.events.EC;
	import com.platogo.flow.commands.core.Command;
	import flash.events.IEventDispatcher;
	
	//this command encapsulates the AddEvent Function of the event controller
	public class AddEvent extends Command {
		
		private var _obj:Object;
		private var _type:String;
		private var _listener:Function;
		
		public var clusterID:String = "UNCLUSTERED";
		
		public function AddEvent(obj:Object, type:String, listener:Function) {
			_obj = obj;
			_type = type;
			_listener = listener;
		}
		
		public function AClusterID(clusterID : String) : AddEvent{
			this.clusterID = clusterID;
			return this;
		}
		
		static public function create(obj:Object, type:String, listener:Function): AddEvent{
			return new AddEvent(obj, type, listener);
		}
		
		override public function clone():Command 
		{
			return new AddEvent(_obj, _type, _listener).SetAttributes(this);
		}
		
		override protected function execute():void {
			EC.add(_obj, _type, _listener, false, 0, false, clusterID);
			complete();
		}
		
		override public function toDetailString():String {
			return "obj=" + String(_obj) + ", type=" + String(_type)+ ", listener=" + String(_listener)+ ", clusterID=" + String(clusterID); 
		}
	}
}