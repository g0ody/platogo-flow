package com.platogo.flow.responses 
{
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.commands.core.ResponseCommand;
	import com.platogo.flow.commands.utils.Dummy;
	import com.platogo.flow.commands.utils.InvokeFunction;
	import com.platogo.flow.events.ResponseEvent;
	import com.platogo.flow.responses.IResponse;
	/**
	 * ...
	 * @author Dominik
	 */
	public class FunctionResponse extends Response 
	{
		public var func:Function;

		public function FunctionResponse(func : Function ) {
			this.func = func;
		}
		
		/* INTERFACE com.platogo.flow.core.IResponse */
		
		override public function response(e : ResponseEvent):Command {
			if(CheckResponseType(e)) 
				return new InvokeFunction(func).AParameters([e]);
			else
				return new Dummy();
		}
	}

}