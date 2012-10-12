package com.platogo.flow.commands 
{
	import com.platogo.flow.commands.core.Command;
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public interface ICaller 
	{
		function call(cmd_id:String, params: Array = null):Command;
	}
	
}