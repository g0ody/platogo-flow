package com.platogo.flow.commands.utils 
{
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.commands.core.ResponseCommand;
	import com.platogo.flow.enums.ResponseType;
	import com.platogo.flow.events.ResponseEvent;
	import com.platogo.flow.responses.IResponse;
	import flash.external.ExternalInterface;
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public class ExternalCallback extends ResponseCommand {
		private var _call : String;
		
		public var autoRemove:Boolean = true;
		
		public function ExternalCallback(call : String ) {
			_call = call;
		}
		
		public function AAutoRemove( autoRemove : Boolean) : ExternalCallback {
			this.autoRemove = autoRemove;
			return this;
		}
	
		static public function create(call : String): ExternalCallback {
			return new ExternalCallback(call);
		}
		
		override public function clone():Command 
		{
			return new ExternalCallback(_call).SetAttributes(this);
		}
		
		override protected function execute():void {
			if (!ExternalInterface.available)
				throw new Error("ExternalInterface not available");
			else
				ExternalInterface.addCallback(_call, callback);
		}
		
		private function callback( ...params):void {
			if (!ExternalInterface.available)
				throw new Error("ExternalInterface not available");
			else if(autoRemove)
				ExternalInterface.addCallback(_call, null);
				
			if (active) 
				callResponse(ResponseType.COMPLETED, this, params);
		}
		
		override public function toDetailString():String {
			return "call=" + String(_call) + ", autoRemove=" + String(autoRemove); 
		}
	}

}