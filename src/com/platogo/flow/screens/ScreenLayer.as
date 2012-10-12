package com.platogo.flow.screens
{
	import com.platogo.flow.container.IContainer;
	import com.platogo.flow.core.ScreenManager;
	import com.platogo.flow.screens.Screen;
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public class ScreenLayer {
		private var _screens : Array = new Array();
		private var _container : IContainer;
		private var _manager:ScreenManager;
		
		public function ScreenLayer(manager : ScreenManager) {
			_manager = manager;
			_container = manager.createContainer();
		}
		
		public function get container():IContainer {
			return _container;
		}
		
		public function get screens():Array {
			return _screens.concat();
		}
		
		public function get index():int {
			return _manager.getLayerIdx(this);
		}
		
		public function indexOf(screen : Screen):int {
			
			return _screens.indexOf(screen);
		}
		
		public function add(screen : Screen):Screen {
			var old : ScreenLayer = _manager.getLayerByScreen(screen);
			if (old != null && old != this) {
				old.remove(screen);
			}
			
			if (old != this) {
				_screens.push(screen);
				_container.push(screen.container);
			}
			return screen;
		}
		
		public function remove(screen : Screen):Screen {
			var idx : int = _container.indexOf(screen.container);
			if (idx != -1)
				_container.splice(idx, 1);
				
			idx = _screens.indexOf(screen);
			if (idx != -1)
				_screens.splice(idx, 1);
			
			return screen;
		}
		
	}

}