package com.platogo.flow.commands.core 
{
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.utils.Utils;
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public class ParametersCommand extends Command {
		public var params : Array = null;
		
		public function ParametersCommand() { }
		
		public function AParameters( params:Array) : ParametersCommand{
			this.params = params;
			return this;
		}
		
		public function AParameter( param : Object) : ParametersCommand{
			this.params = [ param ];
			return this;
		}
		
		override public function clone():Command 
		{
			return new ParametersCommand().SetAttributes(this);
		}
		
		override public function toDetailString():String {
			return ", params=" + Utils.convertArrayToString(params); 
		}
	}

}