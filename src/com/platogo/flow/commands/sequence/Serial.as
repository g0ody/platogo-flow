package com.platogo.flow.commands.sequence {
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.commands.core.SequenceCommand;
	import com.platogo.flow.utils.Utils;
	import flash.events.Event;
	
	public class Serial extends SequenceCommand {
		public function Serial(...commands) {
			super(Utils.flattenArray(commands));
		}
		
		static public function create(...commands): Serial{
			return new Serial(commands);
		}
		
		override final protected function execute():void {
			//set the complete command count to zero
			if (_commands.length > 0) {
				_commands[0].addEventListener(Event.COMPLETE, onSubcommandComplete);
				_commands[0].addEventListener(Event.CANCEL, onSubcommandCancel);
				_commands[0].start();
			}
			else
				complete();
		}
		
		override public function clone():Command {
			return new Serial(CloneChildCommands()).SetAttributes(this);
		}
		
		override protected function CompleteCheck(last:Command):Boolean 
		{
			var next : int = _commands.indexOf(last) + 1;
			if (next == _commands.length)
				return true;
			else {
				//...otherwise listen for the complete event of the next subcommand...
				_commands[next].addEventListener(Event.COMPLETE, onSubcommandComplete);
				_commands[next].addEventListener(Event.CANCEL, onSubcommandCancel);
				//...and start the subcommand
				_commands[next].start();
				return false;
			}
		}
	}
}