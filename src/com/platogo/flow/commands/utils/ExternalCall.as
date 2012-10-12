package com.platogo.flow.commands.utils 
{
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.commands.core.ParametersCommand;
	import com.platogo.flow.utils.Utils;
	import flash.external.ExternalInterface;
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public class ExternalCall extends ParametersCommand {
		private var _call : String;
		
		public function ExternalCall(call : String) {
			_call = call;
		}
		
		static public function create(call : String): ExternalCall {
			return new ExternalCall(call);
		}
		
		override public function clone():Command 
		{
			return new ExternalCall(_call).SetAttributes(this);
		}
		
		override protected function execute():void {
			if (!ExternalInterface.available)
				throw new Error("ExternalInterface not available");
			else {
				var buffer : Array = Utils.getArrayReferences(params);
				buffer.unshift(_call);
				ExternalInterface.call.apply(null, buffer);
			}
			complete();
		}
		
		override public function toDetailString():String {
			return "call=" + String(_call) + ", params=" + Utils.convertArrayToString(params); 
		}
	}

}