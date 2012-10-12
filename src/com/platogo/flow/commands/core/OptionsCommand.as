package com.platogo.flow.commands.core {
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.commands.core.ResponseCommand;
	import com.platogo.flow.utils.Utils;
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public class OptionsCommand extends ResponseCommand {
		public var options:*= null;
		
		public function OptionsCommand() { }
		
		public function AOptions(options : * ) :  OptionsCommand{
			this.options = options;
			return this;
		}
		
		protected function GetOptions():*{
			return Utils.getObjectReferences(options);
		}
		
		override public function clone():Command {
			return new OptionsCommand().SetAttributes(this);
		}

		
		override public function toDetailString():String {
			return "options=" + Utils.convertObjectToString(options); 
		}
	}

}