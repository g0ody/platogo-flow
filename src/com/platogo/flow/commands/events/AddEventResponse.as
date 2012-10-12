package com.platogo.flow.commands.events {
	import _as.fla.events.EC;
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.commands.core.ResponseCommand;
	import com.platogo.flow.enums.ResponseType;
	import flash.events.Event;
	
	public class AddEventResponse extends ResponseCommand {
		private var _obj:Object;
		private var _type:String;
		public var clusterID:String = "UNCLUSTERED";
		public var responseType:ResponseType = ResponseType.COMPLETED;
		
		public function AddEventResponse(obj:Object, type:String) {
			_obj = obj;
			_type = type;
		}
		
		public function AResponseType(responseType : ResponseType) : AddEventResponse{
			this.responseType = responseType;
			return this;
		}
		
		public function AClusterID(clusterID : String) : AddEventResponse{
			this.clusterID = clusterID;
			return this;
		}
		
		static public function create(obj:Object, type:String): AddEventResponse{
			return new AddEventResponse(obj, type);
		}
		
		override public function clone():Command 
		{
			return new AddEventResponse(_obj, _type).SetAttributes(this);
		}
		
		private function onEvent(e:Event):void {
			if (clusterID == EC.UNCLUSTERED)
				EC.remove(_obj, _type, onEvent);
				
			if (responseType != null) 
				callResponse(responseType, this, null, e);
			else
				callResponse(responseType, this, null, e);
		}
		
		override protected function execute():void {
			EC.add(_obj, _type, onEvent, false, 0, false, clusterID);
		}
		
		override public function toDetailString():String {
			return "obj=" + String(_obj) + ", type=" + String(_type)+ ", responseType=" + String(responseType)+ ", clusterID=" + String(clusterID); 
		}
	}
}