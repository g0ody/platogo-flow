package com.platogo.flow.responses 
{
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.commands.utils.Dummy;
	import com.platogo.flow.enums.ResponseType;
	import com.platogo.flow.events.ResponseEvent;
	import com.platogo.flow.responses.IResponse;
	
	/**
	 * ...
	 * @author Dominik
	 */
	public class Response implements IResponse 
	{
		public var responseType : ResponseType = ResponseType.DEFAULT;
		public var responseKey : String = null;
		
		public function Response() { }
		
		public function AResponseType( responseType : ResponseType) : Response {
			this.responseType = responseType;
			return this;
		}
		
		public function AResponseKey( responseKey : String) : Response {
			this.responseKey = responseKey;
			return this;
		}
		
		
		/* INTERFACE com.platogo.flow.core.IResponse */
		
		public function response(e : ResponseEvent):Command {
			return new Dummy();
		}
		
		protected function CheckResponseType(e : ResponseEvent):Boolean 
		{
			return (responseType == ResponseType.DEFAULT || e.responseType == responseType) && (responseKey ==  null || e.key == responseKey);
		}
		
	}

}