package com.platogo.flow.game 
{
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public interface IRenderObject extends IGameObject {
		function render(target : BitmapData):void;
		function get visible():Boolean;
	}
	
}