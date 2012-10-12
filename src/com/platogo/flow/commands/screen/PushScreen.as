package com.platogo.flow.commands.screen 
{
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.screens.Screen;
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public class PushScreen extends Command {
		private var _screen : Screen;
		
		public var layerIDX :int = -1;
		
		public function PushScreen(screen:Screen) {
			_screen = screen;
		}
		
		public function ALayerIdx( layerIDX : int ) : PushScreen {
			this.layerIDX = layerIDX;
			return this;
		}
		
		static public function create(screen:Screen): PushScreen{
			return new PushScreen(screen);
		}
		
		override public function clone():Command 
		{
			return new PushScreen(_screen).SetAttributes(this);
		}
		
		override protected function execute():void {
			if (_screen) {
				_screen.push(layerIDX);	
			}
			complete();
		}
		
		override public function toDetailString():String {
			return "screen=" + String((_screen!=null)?_screen.key:_screen)+ ", layerIDX=" + String(layerIDX); ; 
		}	
	}

}