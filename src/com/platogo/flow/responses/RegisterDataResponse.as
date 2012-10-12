package com.platogo.flow.responses 
{
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.commands.data.RegisterData;
	import com.platogo.flow.commands.utils.Dummy;
	import com.platogo.flow.events.ResponseEvent;
	
	/**
	 * ...
	 * @author Dominik
	 */
	public class RegisterDataResponse extends Response 
	{
		public var key : String;
		
		public function RegisterDataResponse(key: String) {
			this.key = key;
		}
		
		/* INTERFACE com.platogo.flow.core.IResponse */
		
		override public function response(e : ResponseEvent):Command {
			if(CheckResponseType(e)) 
				return new RegisterData(key, e.data);
			else
				return new Dummy();
		}
		
	}

}