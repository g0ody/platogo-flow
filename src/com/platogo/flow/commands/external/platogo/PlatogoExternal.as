package com.platogo.flow.commands.external.platogo 
{
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.commands.core.ResponseCommand;
	import com.platogo.flow.enums.PlatogoExternalType;
	import com.platogo.flow.enums.ResponseType;
	import flash.external.ExternalInterface;
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public class PlatogoExternal extends ResponseCommand {
		private static const JS_LOGIN_RESPONSE:String = "userLoggedIn";
	    private static const JS_SHOW_LOGIN:String = "platogo_showLogin";
	    private static const JS_SHOW_SIGN_UP:String = "platogo_showSignUp";
	    private static const JS_LOGOUT:String = "platogo_logOut";
	    private static const JS_LOGOUT_RESPONSE:String = "userLoggedOut";
		
		private var _type: PlatogoExternalType;
		private var _gameid : uint;
		
		public function PlatogoExternal(call : PlatogoExternalType, gameid : uint) {
			_type = call;
			_gameid = gameid;
		}
		
		static public function create(call : PlatogoExternalType, gameid : uint):PlatogoExternal {
			return new PlatogoExternal(call, gameid);
		}
		
		override public function clone():Command 
		{
			return new PlatogoExternal(_type, _gameid).SetAttributes(this);
		}
		
		override protected function execute():void {
			if (!ExternalInterface.available)
				throw new Error("ExternalInterface not available");
			else {
				var callcmd : String;
				var callback : String;
				switch(_type) {
					case PlatogoExternalType.LOGIN:
						ExternalInterface.addCallback(JS_LOGIN_RESPONSE, externalCallback);
						ExternalInterface.call(JS_SHOW_LOGIN, _gameid);
						break;					
					case PlatogoExternalType.SIGNUP:
						ExternalInterface.addCallback(JS_LOGIN_RESPONSE, externalCallback);		
						ExternalInterface.call(JS_SHOW_SIGN_UP, _gameid);	
						break;				
					case PlatogoExternalType.LOGOUT:
						ExternalInterface.addCallback(JS_LOGOUT_RESPONSE, externalCallback);	
						ExternalInterface.call(JS_LOGOUT);
						break;
					default:
						throw new Error("Unknown PlatogoExternalCall");
				}
			}
		}
		
		private function externalCallback(login :Boolean = true):void {
			switch(_type) {
				case PlatogoExternalType.LOGIN:
					ExternalInterface.addCallback(JS_LOGIN_RESPONSE, null);
					break;					
				case PlatogoExternalType.SIGNUP:
					ExternalInterface.addCallback(JS_LOGIN_RESPONSE, null);		
					break;				
				case PlatogoExternalType.LOGOUT:
					ExternalInterface.addCallback(JS_LOGOUT_RESPONSE, null);	
					break;
				default:
					throw new Error("Unknown PlatogoExternalCall");
			}
			
			if (active) {
				if (login)
					callResponse(ResponseType.COMPLETED, this);
				else
					callResponse(ResponseType.FAILED, this);
			}
		}
		
		override public function toDetailString():String {
			return "call=" + String(_type) + ", gameid=" + String(_gameid); 
		}
		
	}

}