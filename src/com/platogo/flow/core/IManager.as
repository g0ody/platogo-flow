package com.platogo.flow.core 
{
	
	/**
	 * The interface is used to identify managers for FlowInternal
	 * @see com.platogo.flow.core.FlowInternal
	 * @author Dominik
	 */
	public interface IManager 
	{
		/**
		 * Name of the manager. Used to register the manager in FlowInternal
		 */
		function get name():String;
	}
	
}