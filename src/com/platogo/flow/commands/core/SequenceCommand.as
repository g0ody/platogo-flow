package com.platogo.flow.commands.core {
	import com.platogo.flow.commands.core.CancelableCommand;
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.commands.utils.Dummy;
	import com.platogo.flow.utils.Utils;
	import flash.events.Event;
	
	public class SequenceCommand extends CancelableCommand {
		protected var _commands:Array = new Array();
		
		public function SequenceCommand(commands : Array = null) {
			if (commands != null)
				_commands = commands.filter(function (item:Command,  index:int = 0, array:Array = null) : Boolean { return !(item is Dummy); } );
		}
		
		public function SetChildAttributes( vars : * ) : SequenceCommand {
			for each(var cmd : Command in _commands)
				cmd.SetAttributes(vars);
			return this;
		}
		
		public function SetChildAttribute( key : String, value : * ) : SequenceCommand {
			for each(var cmd : Command in _commands)
				cmd.SetAttribute(key, value);
			return this;
		}
		
		public function AddCommand( command : Command ) : SequenceCommand {
			_commands.push(command);
			return this;
		}
		
		public function AddCommandAt( command : Command, index : int ) : SequenceCommand {
			_commands.splice(index, 0, command);
			return this;
		}
		
		public function CloneChildCommands():Array {
			var cmds : Array = new Array();
			for each (var command:Command in _commands)
				cmds.push(command.clone());
			return cmds;
		}
		
		override protected function canceling():void {
			for each (var command:Command in _commands) {
				if (command.active) {
					command.removeEventListener(Event.COMPLETE, onSubcommandComplete);
					command.removeEventListener(Event.CANCEL, cancelAll);
					
					if(command is CancelableCommand)
						(command as CancelableCommand).cancel();
				}
			}
		}
		
		protected function CompleteCheck(last : Command) : Boolean {
			return false;
		}
		
		protected function onSubcommandComplete(e:Event):void {
			//stop listening for the complete event
			var command:Command = e.target as Command;
			command.removeEventListener(Event.COMPLETE, onSubcommandComplete);
			command.removeEventListener(Event.CANCEL, cancelAll);
			
			if (CompleteCheck(command)) 
				complete();
		}
		
		protected function onSubcommandCancel(e:Event):void {
			var command:Command = e.target as Command;
			command.removeEventListener(Event.COMPLETE, onSubcommandComplete);
			command.removeEventListener(Event.CANCEL, cancelAll);
			cancelAll();
		}
		
		public function get Count():int { return _commands.length; }
		
		override public function toDetailString():String {
			return "commands=" + Utils.convertArrayToString(_commands);
		}
	}
}