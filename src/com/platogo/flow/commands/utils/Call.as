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
	public class Call extends ParametersCommand {
		private var _caller : Object;
		private var _cmd : String;
		
		public function Call(caller:Object, cmd : String) {
			_caller = caller;
			_cmd = cmd;
		}
		
		static public function create(caller:Object, cmd : String): Call{
			return new Call(caller, cmd);
		}
		
		override public function clone():Command {
			return new Call(_caller, _cmd).SetAttributes(this);
		}
		
		override protected function execute():void {
			var command: Command;
			var callerBuffer : * = Utils.getReferenceData(_caller);
			
			
			if (callerBuffer is String) {
				var commandmanager : CommandManager = GetCommandManagerInstance();
				
				if (commandmanager) 
					command =  commandmanager.call(callerBuffer as String, _cmd, Utils.getArrayReferences(params));
					
				//TODO: throw Errro
			}
			else if(callerBuffer is ICaller)
				command = (callerBuffer as ICaller).call(_cmd, Utils.getArrayReferences(params));
			
			if (command) {
				command.addEventListener(Event.COMPLETE, complete);
				command.start();	
			}
			else
				complete();
		}
		
		override public function toDetailString():String {
			return "caller=" + String(_caller) + ", cmd=" + String(_cmd) + ", params=" + Utils.convertArrayToString(params)+ ", alternativeCommandManager=" + String(customCommandManager); 
		}	
	}

}