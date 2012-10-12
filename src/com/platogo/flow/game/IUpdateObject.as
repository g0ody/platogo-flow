package com.platogo.flow.game 
{
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public interface IUpdateObject extends IGameObject {
		function update(elapsed : Number, view : GameView):void;
	}
	
}