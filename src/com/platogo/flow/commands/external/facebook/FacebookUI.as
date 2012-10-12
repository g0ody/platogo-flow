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
	public class FacebookUI extends OptionsCommand {
		private var _method:String;
		
		public var display:String;

		public function FacebookUI(method:String) {
			_method = method;
		}
		
		public function ADisplay( display : String ): FacebookUI {
			this.display = display;
			return this;
		}
		
		static public function create(method:String): FacebookUI{
			return new FacebookUI(method);
		}
		
		override protected function execute():void {
			
			
			Facebook.ui(_method, GetOptions(), onCallback, display);
		}
		
		override public function clone():Command 
		{
			return new FacebookUI(_method).SetAttributes(this);
		}
		
		private function onCallback(response:Object):void {	
			if (active) {
				if (response && response.error == null)
					callResponse(ResponseType.COMPLETED, this, response);
				else
					callResponse(ResponseType.FAILED, this, response);
			}
		}
		
		override public function toDetailString():String {
			return "method=" + String(_method) + ", options=" + Utils.convertObjectToString(options) + ", display=" + String(display); 
		}
	}

}