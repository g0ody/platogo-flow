package com.platogo.flow.game {
	import com.platogo.flow.game.IUpdateObject;
	import flash.display.IBitmapDrawable;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public class DragableObject extends InteractionObject implements IUpdateObject {
		private var _mouseEnabled : Boolean = false;
		private var _dragging : Boolean = false;
		
		public function DragableObject(asset : IBitmapDrawable, hitarea : Rectangle = null) {
			super(asset, hitarea);
		}
			
		/* INTERFACE com.platogo.flow.game.IUpdateObject */
		
		public function update(elapsed:Number, view : GameView):void 
		{
			if (_dragging) 
			{
				x += view.deltaX;
				y += view.deltaY;
			}
		}
		
		protected function onDragStart():void {
			
		}
		
		protected function onDragEnd():void {
			
		}
		
		private function onMouseUp(e:MouseEvent):void {
			if (_dragging) 
			{
				_dragging = false;
				onDragEnd();
			}
		}
		
		private function onMouseDown(e:MouseEvent):void {
			if (!_dragging) 
			{
				_dragging = true;
				onDragStart();
			}
		}
		
		public function get mouseEnabled():Boolean { return _mouseEnabled; }
		public function set mouseEnabled(value:Boolean):void {
			if (_mouseEnabled != value) {
				_mouseEnabled = value;
				if (_mouseEnabled) {
					addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
					addEventListener(MouseEvent.MOUSE_OUT, onMouseUp);
					addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				}
				else {
					if (_dragging) {
						_dragging = false;
						onDragEnd();
					}
					removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
					removeEventListener(MouseEvent.MOUSE_OUT, onMouseUp);
					removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				}
			}
		}
		
		public function get dragging():Boolean 
		{
			return _dragging;
		}
	}

}