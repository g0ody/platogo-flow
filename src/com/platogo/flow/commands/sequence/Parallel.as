package com.platogo.flow.commands.sequence {
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.commands.core.SequenceCommand;
	import com.platogo.flow.utils.Utils;
	import flash.events.Event;
	
	public class Parallel extends SequenceCommand {
		
		private var _started : Array = new Array();
		
		public function Parallel( ...commands) {
			super(Utils.flattenArray(commands));
		}
		
		static public function create( ...commands): Parallel{
			return new Parallel(commands);
		}
		
		override final protected function execute():void {
			//set the complete command count to zero
			if (_commands.length > 0) {
				_started = _commands.concat();
				for each (var command:Command in _commands) {
					//listen for the complete event of a subcommand...
					command.addEventListener(Event.COMPLETE, onSubcommandComplete);
					command.addEventListener(Event.CANCEL, onSubcommandCancel);
					
					//...and start the subcommand
					command.start();
				}
			}
			else
				complete();
		}
		
		override protected function canceling():void 
		{
			super.canceling();
			_started = new Array();
		}
		
		override public function clone():Command {
			return new Parallel(CloneChildCommands()).SetAttributes(this);
		}
		
		override protected function CompleteCheck(last:Command):Boolean 
		{
			var idx : int = _started.indexOf(last);
			if (idx != -1)
				_started.splice(idx, 1);
				
			return _started.length == 0;
		}
	}
}