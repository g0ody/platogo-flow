package com.platogo.flow.commands.core 
{
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.core.ScreenManager;
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public class ScreenCommand extends Command {
		public var customScreenManager:String;
		
		public function ScreenCommand() { }
		
		public function ACustomScreenManager(alternativeScreenManager:String) : ScreenCommand {
			this.customScreenManager = alternativeScreenManager;
			return this;
		}
		
		override public function clone():Command {
			return new ScreenCommand().SetAttributes(this);
		}
		
		protected function GetScreenManagerInstance() : ScreenManager {
			if (customScreenManager != null && customScreenManager.length > 0)
				return ScreenManager.getInstance(customScreenManager);
			else
				return ScreenManager.defaultInstance;
		}
	}

}