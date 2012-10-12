package com.platogo.flow.commands.screen 
{
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.commands.core.ScreenCommand;
	import com.platogo.flow.core.ScreenManager;
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public class HideScreen extends ScreenCommand {
		private var _key : String;
		
		public function HideScreen(key:String) {
			_key = key;
		}
		
		static public function create(key:String): HideScreen{
			return new HideScreen(key);
		}
		
		override public function clone():Command {
			return new HideScreen(_key).SetAttributes(this);
		}
		
		override protected function execute():void {
			var screenmanager : ScreenManager =  GetScreenManagerInstance();
			
			if (screenmanager)
				screenmanager.hide(_key);
			//TODO: throw error
			complete();
		}
		
		override public function toDetailString():String {
			return "key=" + String(_key); 
		}
	}

}