package com.platogo.flow.commands.core {
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.enums.ResponseType;
	import com.platogo.flow.events.ResponseEvent;
	import com.platogo.flow.responses.IResponse;
	import com.platogo.flow.utils.Utils;
	import flash.events.Event;
	
	public class ResponseCommand extends CancelableCommand {
		public var response : IResponse = null;
		public var responseKey : String = null;
		public var responseParams : Array = null;
		
		public function ResponseCommand() {}
		
		public function AResponse(response : IResponse):ResponseCommand {
			this.response = response;
			return this;
		}
		
		public function AResponseKey(responseKey : String):ResponseCommand {
			this.responseKey = responseKey;
			return this;
		}
	
		public function AResponseParams(responseParams : Array):ResponseCommand {
			this.responseParams = responseParams;
			return this;
		}
		
		public function AResponseParam(responseParam : Object):ResponseCommand {
			this.responseParams = [responseParam];
			return this;
		}
		
		override public function clone():Command {
			return new ResponseCommand().SetAttributes(this);
		}
		
		override protected function canceling():void {
			if (active) 
				callResponse(ResponseType.CANCELED, this);
		}
		
		protected final function callResponse(type : ResponseType, command : ResponseCommand, data : * = null, subEvent : Event = null, isComplete :Boolean = true, alternateComplete :Function = null):void {
			if (isComplete) {
				if (response != null) {
					var cmd : Command = response.response(new ResponseEvent(type, command, data, subEvent, responseKey,  Utils.getArrayReferences(responseParams)));
					cmd.addEventListener(Event.COMPLETE, (alternateComplete != null)?alternateComplete:complete);
					cmd.start();	
				}
				else if (alternateComplete != null)
					alternateComplete();
				else
					complete();
			} 
			else if(response != null)
				response.response(new ResponseEvent(type, command, data, subEvent, responseKey, Utils.getArrayReferences(responseParams))).start();
			else if (alternateComplete != null)
				alternateComplete();
			else
					complete();
		}
	}
}
