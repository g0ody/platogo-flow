package com.platogo.flow.responses 
{
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.events.ResponseEvent;
	
	/**
	 * ...
	 * @author Dominik
	 */
	public interface IResponse {
		function response(e: ResponseEvent) :Command;
	}
	
}