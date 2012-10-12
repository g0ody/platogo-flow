package com.platogo.flow.events 
{
	import com.platogo.flow.core.ScreenManager;
	import com.platogo.flow.screens.Screen;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Dominik
	 */
	public class ScreenEvent extends Event 
	{
		public static const SHOW : String = "onScreenShow";
		public static const HIDE : String = "onScreenHide";
		public static const INIT : String = "onScreenInit";
		public static const KILL : String = "onScreenKill";
		public static const LAYER_CHANGE : String = "onScreenLayerChange";
		public static const LAYER_PUSH : String = "onScreenLayerPush";
		public static const LAYER_POP : String = "onScreenLayerPop";
		
		private var _manager : ScreenManager;
		private var _key : String;
		private var _prototype : Screen;
		private var _defaultLayerIdx : uint;
		private var _unique : Boolean;
		
		public function ScreenEvent(type:String, manager : ScreenManager, key : String = "", defaultLayerIndex : uint =  0, prototype : Screen = null, unique : Boolean = false, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			_manager = manager;
			_key = key;
			_prototype = prototype;
			_defaultLayerIdx = defaultLayerIndex;
			_unique = unique;
		}
		
		public function get manager():ScreenManager { return _manager; }
		public function get key():String { return _key; }
		public function get prototype():Screen { return _prototype; }
		public function get defaultLayerIdx():uint { return _defaultLayerIdx; }
		
		public function get unique():Boolean {return _unique; }
		
		override public function clone():Event {
			return new ScreenEvent(type, manager, key, defaultLayerIdx, prototype, unique, bubbles, cancelable);
		}
	}

}