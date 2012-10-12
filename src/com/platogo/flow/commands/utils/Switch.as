package com.platogo.flow.commands.utils 
{
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.commands.core.ParametersCommand;
	import com.platogo.flow.commands.ICaller;
	import com.platogo.flow.core.CommandManager;
	import com.platogo.flow.utils.Utils;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public class Switch extends ParametersCommand {
		private var _from : Object;
		private var _to : Object;
		
		public function Switch(from:Object, to:Object) {
			_from = from;
			_to = to;
		}
		
		static public function create(from:Object, to:Object): Switch{
			return new Switch(from, to);
		}
		
		override public function clone():Command {
			return new Switch(_from, _to).SetAttributes(this);
		}
		
		override protected function execute():void {
			var buffer : Array;
			var toBuffer : * = Utils.getReferenceData(_to);
			var fromBuffer : * = Utils.getReferenceData(_from);
			
			if (params != null) {
				buffer = Utils.getArrayReferences(params);
				buffer.unshift(toBuffer);
			}
			else 
				buffer = [toBuffer];
				
			var command: Command;
			
			if (fromBuffer is String) {
				var commandmanager : CommandManager = GetCommandManagerInstance();
				command =  commandmanager.call(fromBuffer as String, "CMD_SWITCH", buffer);
			}
			else if(fromBuffer is ICaller)
				command = (fromBuffer as ICaller).call("CMD_SWITCH", buffer);
			
			if (command) {
				command.addEventListener(Event.COMPLETE, complete);
				command.start();	
			}
			else
				complete();
		}
		
		override public function toDetailString():String {
			return "from=" + String(_from) + ", to=" + String(_to) + ", params=" + Utils.convertArrayToString(params)+ ", alternativeCommandManager=" + String(customCommandManager); 
		}	
	}

}