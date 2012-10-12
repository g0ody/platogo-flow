package com.platogo.flow.commands.external.facebook {
	import com.facebook.graph.Facebook;
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.commands.core.OptionsCommand;
	import com.platogo.flow.enums.ResponseType;
	import com.platogo.flow.utils.Utils;
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public class FacebookCall extends OptionsCommand {
		private var _method:String;
		
		public var requesMethod:String = "GET";
		
		public function FacebookCall(method:String) {
			_method = method;
		}

		public function ARequesMethod(requesMethod : String ) :  FacebookCall {
			this.requesMethod = requesMethod;
			return this;
		}
		
		static public function create(method:String): FacebookCall{
			return new FacebookCall(method);
		}
		
		override public function clone():Command {
			return new FacebookCall(_method).SetAttributes(this);
		}
		
		override protected function execute():void {
			Facebook.api(_method, onCallback, GetOptions(), requesMethod);
		}

		private function onCallback(result:Object, fail:Object):void {
			if (active) {
				if (result != null && result != false)
					callResponse(ResponseType.COMPLETED, this, result);
				else
					callResponse(ResponseType.FAILED, this, fail);
			}
		}
		
		override public function toDetailString():String {
			return "method=" + String(_method) + ", options=" + Utils.convertObjectToString(options) + ", requesMethod=" + String(requesMethod); 
		}
	}

}