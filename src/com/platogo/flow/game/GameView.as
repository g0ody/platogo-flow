package com.platogo.flow.game{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public class GameView extends LiveView {
		public var sortUpdateNames : * = null;
		public var sortUpdateOptions : * = null;
		
		private var _objectsUpdate : Array;

		public function GameView(width : Number, height : Number, transparent: Boolean = true, fillcolor : uint = 0x000000, autoInit : Boolean = true) {
			super(width, height, transparent, fillcolor, autoInit);
			_objectsUpdate = new Array();
		}
		
		public function PreUpdate():void {
			
		}
		
		public function PostUpdate():void {
			
		}
		
		override internal function onUpdate(e:Event):void 
		{
			UpdateMouseInteraction();
			UpdateGameTime();
			
			if (active) {
				PreUpdate();
				
				// Update Minions
				if(sortUpdateNames != null)
					_objectsUpdate.sortOn(sortUpdateNames, sortUpdateOptions);
				
				Update(elapsed);
				for each(var updateObject : IUpdateObject in _objectsUpdate) 
					updateObject.update(elapsed, this);
					
				PostUpdate();
			}
			Render();
		}
		
		override public function add(element:IGameObject):IGameObject 
		{
			if (element is IUpdateObject  && _objectsUpdate.indexOf(element) == -1)
				_objectsUpdate.push(element);
				
			return super.add(element);
		}
		
		override public function remove(element:IGameObject):IGameObject 
		{
			var idx : int = _objectsUpdate.indexOf(element) ;
			if (idx != -1)
				_objectsUpdate.splice(idx, 1);
			return super.remove(element);
		}

		public function get objectsUpdate():Array { return _objectsUpdate.concat(); }
		
	}

}