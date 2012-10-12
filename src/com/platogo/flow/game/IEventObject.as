package com.platogo.flow.game 
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public interface IEventObject extends IGameObject {
		function get hitarea():Rectangle;
		function willTrigger (type:String) : Boolean;
		function dispatchEvent(e:Event):Boolean;
	}
	
}