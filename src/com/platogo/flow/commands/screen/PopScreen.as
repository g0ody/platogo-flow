package com.platogo.flow.commands.screen 
{
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.screens.Screen;
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public class PopScreen extends Command {
		private var _screen : Screen;
		
		public function PopScreen(screen:Screen) {
			_screen = screen;
		}
		
		static public function create(screen:Screen): PopScreen{
			return new PopScreen(screen);
		}
		
		override public function clone():Command 
		{
			return new PopScreen(_screen).SetAttributes(this);
		}
		
		override protected function execute():void {
			if (_screen != null) {
				_screen.pop();
			}
			complete();
		}
		
		override public function toDetailString():String {
			return "screen=" + String((_screen!=null)?_screen.key:_screen); 
		}
	}

}