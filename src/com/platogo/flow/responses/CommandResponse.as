package com.platogo.flow.responses 
{
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.commands.core.ResponseCommand;
	import com.platogo.flow.commands.utils.Dummy;
	import com.platogo.flow.events.ResponseEvent;
	import com.platogo.flow.responses.IResponse;
	/**
	 * ...
	 * @author Dominik
	 */
	public class CommandResponse extends Response {
		public var command:Command;

		public function CommandResponse( command : Command) {
			this.command = command;
		}
		
		/* INTERFACE com.platogo.flow.core.IResponse */
		
		override public function response(e : ResponseEvent):Command {
			if(CheckResponseType(e)) 
				return command;
			else
				return new Dummy();
		}
		
	}

}