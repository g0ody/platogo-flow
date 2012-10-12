package com.platogo.flow.commands.sequence
{
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.commands.core.SequenceCommand;
	import com.platogo.flow.utils.Utils;
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public class Split extends SequenceCommand{
		public function Split( ...commands) {
			super(Utils.flattenArray(commands));
		}

		static public function create(...commands): Split{
			return new Split(commands);
		}
		
		override public function clone():Command {
			return new Split(CloneChildCommands()).SetAttributes(this);
		}
		
		override final protected function execute():void {
			for each (var command:Command in _commands)
				command.start();
				
			complete();
		}
		
	}

}