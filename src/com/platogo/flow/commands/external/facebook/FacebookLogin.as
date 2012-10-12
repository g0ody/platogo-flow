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
	public class FacebookLogin extends OptionsCommand {
		
		public function FacebookLogin() {
		}
		
		static public function create(): FacebookLogin{
			return new FacebookLogin();
		}
		
		override protected function execute():void {
			Facebook.login(onCallback, GetOptions());
		}
		
		override public function clone():Command {
			return new FacebookLogin().SetAttributes(this);
		}

		private function onCallback(result:Object, fail:Object):void {	
			if (active) {
				if (result != null)
					callResponse(ResponseType.COMPLETED, this, result);
				else
					callResponse(ResponseType.FAILED, this, fail);
			}
		}
		
		override public function toDetailString():String {
			return "options=" + Utils.convertObjectToString(options); 
		}
		
	}

}