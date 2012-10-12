package com.platogo.flow.commands.external.platogo 
{
	import com.platogo.api.enums.PlatogoStatus;
	import com.platogo.api.PlatogoAPI;
	import com.platogo.api.vo.PlatogoResponse;
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.commands.core.ResponseCommand;
	import com.platogo.flow.enums.ResponseType;
	import com.platogo.flow.utils.Utils;
	
	/**
	 * This Command can execute any of the platogo API commands
	 * @author Dominik Hurnaus
	 */
	public class PlatogoCall extends ResponseCommand {
		private var _description:String;
		public var params:Array;

		public function PlatogoCall(description:String) {
			_description = description;
		}
		
		public function AParameters( params:Array = null) : PlatogoCall{
			this.params = params;
			return this;
		}
		
		static public function create(description:String): PlatogoCall{
			return new PlatogoCall(description);
		}
		
		override public function clone():Command {
			return new PlatogoCall(_description).SetAttributes(this);
		}
		
		override protected function execute():void {
			var buffer : Array = Utils.getArrayReferences(params);
			var arr : Array = _description.split(".");
			var obj :Object = PlatogoAPI;
				
			if ( arr[0] == "socialService" && arr[1] == "execute") {
				var c : Class = buffer.shift() as Class;
				var name : String = String(c);
				name = name.substring(7,name.length -1);
				switch(name) {
					case "GetFriends":
						PlatogoAPI.socialService.execute(new c(onCallback));
						break;
					
					case "IsFan": 
						if ( buffer && buffer.length == 1) {
							PlatogoAPI.socialService.execute(new c(buffer[0], onCallback));
						}
						break;

					case "InviteFriends":  
						PlatogoAPI.socialService.execute(new c()); 
						complete();
						break;
						
					case "PublishContent":
						if (buffer && buffer.length == 6) {
							PlatogoAPI.socialService.execute(new c(buffer[0], buffer[1], buffer[2], buffer[3], buffer[4], buffer[5]));
							complete();
						}
						break;
					case "PublishLevel":
						if (buffer && buffer.length >= 1) {
							while (buffer.length < 5)
								buffer.push("");
		
							PlatogoAPI.socialService.execute(new c(buffer[0], buffer[1], buffer[2], buffer[3], buffer[4]));
							complete();
						}
						break;
				}
				return;
			} else {
				for ( var i : uint = 0; i < arr.length - 1 ; i++)
					obj = obj[arr[i]];
					
				var func : Function = obj[arr[arr.length -1]];
				
				if (func.length > 0 && buffer.length < func.length) {
					buffer[func.length - 1] = onCallback;
					func.apply(null, buffer);
				}
				else {
					func.apply(null, buffer);
					complete();
				}
			}
		}
		
		private function onCallback(e:PlatogoResponse):void {
			if (active) {
				if (e.status == PlatogoStatus.OK)
					callResponse(ResponseType.COMPLETED, this, e.data);
				else if(e.status == PlatogoStatus.NOT_LOGGED_IN)
					callResponse(ResponseType.NOLOGIN, this, e.data);
				else
					callResponse(ResponseType.NOLOGIN, this, e.data);
			}
		}
		
		override public function toDetailString():String {
			return "description=" + String(_description) + ", params=" + Utils.convertArrayToString(params); 
		}
		
		public function get description():String 
		{
			return _description;
		}
		
	}

}