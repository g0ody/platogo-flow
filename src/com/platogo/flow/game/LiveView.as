package com.platogo.flow.game{
	import flash.events.Event;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public class LiveView extends InteractionView {
		public var active : Boolean = false;
		
		//Time Handling
		private var _markTime : int;
		private var _elapsed : Number = 0;
		private var _gametime : Number = 0;

		public function LiveView(width : Number, height : Number, transparent: Boolean = true, fillcolor : uint = 0x000000, autoInit : Boolean = true) {
			super(width, height, transparent, fillcolor, autoInit);
		}
		
		override internal function onAdded(e:Event = null):void 
		{
			super.onAdded(e);
			Reset();
		}

		public function Update(dt : Number):void {
			
		}
		
		public function Reset():void {
			_markTime = getTimer();
			_gametime = 0;
			_elapsed = 0;
		}
		
		override internal function onUpdate(e:Event):void 
		{
			UpdateMouseInteraction();
			UpdateGameTime();
			if (active) 
				Update(_elapsed);
			Render();
		}
		
		internal function UpdateGameTime():void 
		{
			var currentTime : int = getTimer();
			if (active) {
				_elapsed = (currentTime - _markTime) * 0.001;
				_gametime += _elapsed;
			}
			_markTime = currentTime;
		}
		
		public function get elapsed():Number { return _elapsed; }
		public function get gametime():Number { return _gametime; }
		
	}

}