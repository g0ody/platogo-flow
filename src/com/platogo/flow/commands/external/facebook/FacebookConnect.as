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
	public class FacebookConnect extends OptionsCommand {
		private var _applicationID:String;
		
		public var accessToken:String = null;
		
		public function FacebookConnect(applicationID:String) {
			_applicationID = applicationID;
		}
		
		public function AAccessToken(accessToken : String) : FacebookConnect {
			this.accessToken = accessToken;
			return this;
		}
		
		static public function create(applicationID:String): FacebookConnect{
			return new FacebookConnect(applicationID);
		}
		
		override public function clone():Command {
			return new FacebookConnect(_applicationID).SetAttributes(this);
		}
		
		override protected function execute():void {
			Facebook.init(_applicationID, onCallback, GetOptions(), accessToken);
		}
		
		private function onCallback(result:Object, fail:Object):void {
			if (active) {
				if (result!= null && result != false)
					callResponse(ResponseType.COMPLETED, this, result);
				else
					callResponse(ResponseType.FAILED, this, fail);
			}
		}
		
		override public function toDetailString():String {
			return "applicationID=" + String(_applicationID) + ", options=" + Utils.convertObjectToString(options) + ", accessToken=" + String(accessToken); 
		}
	}
}