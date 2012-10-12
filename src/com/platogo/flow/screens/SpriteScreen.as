package com.platogo.flow.screens
{
	import com.platogo.flow.core.ScreenManager;
	import com.platogo.flow.events.ScreenEvent;
	import com.platogo.flow.screens.CommandScreen;
	
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public class SpriteScreen extends CommandScreen
	{
		private var _asset : MovieClip;
		
		public function SpriteScreen(assets : MovieClip = null) {
			_asset = assets;
			addEventListener(ScreenEvent.INIT, onScreenInit);
		}
		
		private function onScreenInit(e:ScreenEvent):void {
			removeEventListener(ScreenEvent.INIT, onScreenInit);
			if (_asset) {
				container.push(_asset);
			}
		}
		
		public function get asset():MovieClip { return _asset; }
		
		public function set x (value : Number):void { container.x = value; }
		public function get x():Number { return container.x; }
		
		public function set y (value : Number):void { container.y = value; }
		public function get y():Number { return container.y; }
		
	}

}