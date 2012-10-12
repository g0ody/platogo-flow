package com.platogo.flow.commands.external.platogo 
{
	import com.platogo.api.enums.PlatogoStatus;
	import com.platogo.api.PlatogoAPI;
	import com.platogo.api.vo.PlatogoResponse;
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.commands.core.ResponseCommand;
	import com.platogo.flow.enums.ResponseType;
	import com.platogo.flow.utils.Utils;
	import flash.display.Stage;
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public class PlatogoConnect extends ResponseCommand {
		private var _gameid: uint;
		private var _stage : Stage;
		public var blocked : Array;
		
		public function PlatogoConnect(gameid:uint, stage:Stage) {
			_gameid = gameid;
			_stage = stage;
		}
		
		public function ABlocked( blocked : Array) : PlatogoConnect {
			this.blocked = blocked;
			return this;
		}
		
		static public function create(gameid:uint, stage:Stage): PlatogoConnect{
			return new PlatogoConnect(gameid, stage);
		}
		
		override public function clone():Command 
		{
			return new PlatogoConnect(_gameid, _stage).SetAttributes(this);
		}
		
		override protected function execute():void {
			PlatogoAPI.connect(_gameid, _stage, onConnection);
		}
		
		private function onConnection(e:PlatogoResponse):void {
			if (active) {
				switch (e.status){
					case PlatogoStatus.OK:
						if(PlatogoAPI.currentUser.loggedIn)
							if (blocked && blocked.indexOf(PlatogoAPI.integration) != -1)
								callResponse(ResponseType.BLOCKED, this, e.data);
							else
								callResponse(ResponseType.COMPLETED, this, e.data);
						else
							callResponse(ResponseType.NOLOGIN, this, e.data);
						break;
					case PlatogoStatus.ERROR:
					default:
						callResponse(ResponseType.FAILED, this, e.data);
						break;
				}
			}
		}
		
		override public function toDetailString():String {
			return "gameid=" + String(_gameid) + ", stage=" + String((_stage != null)?_stage.name:_stage)+ ", blocked=" + Utils.convertArrayToString(blocked); 
		}
	}

}