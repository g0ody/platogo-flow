package com.platogo.flow.game{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public class BaseView extends Sprite {

		private var _objects : Array;
		private var _autoInit : Boolean = true;
		public function BaseView(autoInit : Boolean = true) {
			_objects = new Array();
			_autoInit = autoInit;
			if (stage == null) 
				addEventListener(Event.ADDED_TO_STAGE, onAdded);
			else
				onAdded();
		}
		
		public function init():void {
			
		}
		
		internal function onAdded(e:Event = null):void {
			if(e != null)
				removeEventListener(Event.ADDED_TO_STAGE, onAdded);
				
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			
			if(_autoInit)
				init();
		}
		
		internal function onRemoved(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}

		public function add(element : IGameObject):IGameObject {
			if ( _objects.indexOf(element) == -1)
				_objects.push(element);	
			
			return element;
		}
		
		public function remove(element : IGameObject):IGameObject {
			var idx : int = _objects.indexOf(element) ;
			if (idx != -1)
				_objects.splice(idx, 1);
	
			return element;
		}

		public function get objects():Array { return _objects.concat(); }
	}

}