package com.platogo.flow.commands.screen 
{
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.commands.core.ScreenCommand;
	import com.platogo.flow.core.ScreenManager;
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public class ShowScreen extends ScreenCommand {
		private var _key : String;
		
		public function ShowScreen(key:String) {
			_key = key;
		}
		
		static public function create(key:String): ShowScreen{
			return new ShowScreen(key);
		}
		
		override public function clone():Command {
			return new ShowScreen(_key).SetAttributes(this);
		}
		
		override protected function execute():void {
			var screenmanager : ScreenManager = GetScreenManagerInstance();
			
			if (screenmanager)
				screenmanager.show(_key);
				
			complete();
		}
		
		override public function toDetailString():String {
			return "key=" + String(_key); 
		}
	}

}