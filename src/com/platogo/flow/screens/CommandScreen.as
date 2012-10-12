package com.platogo.flow.screens
{
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.commands.ICaller;
	import com.platogo.flow.commands.screen.PopScreen;
	import com.platogo.flow.commands.screen.PushScreen;
	import com.platogo.flow.commands.sequence.Parallel;
	import com.platogo.flow.commands.utils.Call;
	import com.platogo.flow.commands.utils.Dummy;
	import com.platogo.flow.core.CommandManager;
	import com.platogo.flow.core.ScreenManager;
	import com.platogo.flow.events.ScreenEvent;
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public class CommandScreen extends Screen implements ICaller{
		public static var CMD_SHOW: String = "CMD_SHOW";
		public static var CMD_HIDE: String = "CMD_HIDE";
		public static var CMD_SWITCH: String = "CMD_SWITCH";
		
		private var _commandmanager : CommandManager;
		private var _unique: Boolean;
		
		public function CommandScreen(alternativeCommandManager : String = null) {
			if (alternativeCommandManager != null && alternativeCommandManager.length > 0)
				_commandmanager = CommandManager.getInstance(alternativeCommandManager);
			else
				_commandmanager = CommandManager.defaultInstance;
				
			//TODO: throw error if no command mananger
			
			addEventListener(ScreenEvent.INIT, onScreenInit);
		}
		
		private function onScreenInit(e:ScreenEvent):void {
			removeEventListener(ScreenEvent.INIT, onScreenInit);
			_commandmanager.addCaller(key, this);
			_unique = e.unique;
			addEventListener(ScreenEvent.KILL, onScreenKill);
		}
		
		private function onScreenKill(e:ScreenEvent):void {
			removeEventListener(ScreenEvent.KILL, onScreenKill);
			_commandmanager.removeCaller(key);
			addEventListener(ScreenEvent.INIT, onScreenInit);
		}
		
		public function callScreen(cmd_id:String, params : Array = null):Command {
			switch(cmd_id) {
				case CMD_SHOW: return new PushScreen(this).ALayerIdx(defaultLayerIdx);
				case CMD_HIDE: return new PopScreen(this);
				case CMD_SWITCH: 
								var target : * = params.shift();
								return new Parallel(
											new Call(target, CMD_SHOW).AParameters(params),
											new Call(this, CMD_HIDE).AParameters(params));
				default: return new Dummy();
			}	
		}
		
		final public function call(cmd_id:String, params : Array = null):Command {
			if (this == prototype && _unique) {
				var screen : CommandScreen = ScreenManager.defaultInstance.getScreen(key) as CommandScreen;
				if(screen)
					return screen.callScreen(cmd_id, params);
				else
					return new Dummy();
			}
			else 
				return callScreen(cmd_id, params);
		}
	}

}