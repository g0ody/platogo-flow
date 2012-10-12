package com.platogo.flow.game{
	import com.platogo.flow.enums.MouseState;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public class InteractionView extends RenderView {
		public var sortEventsNames : * = null;
		public var sortEventsOptions : * = null;
		
		private var _objectsEvents : Array;
		
		//Mouce Handling
		//private var _debug : Bitmap;
		public var mouseTopOnly : Boolean = true;
		
		private var _markMouseX : Number;
		private var _markMouseY : Number;
		private var _deltaX : Number = 0;
		private var _deltaY : Number = 0;
		private var _mouseState: MouseState = MouseState.RELEASED; // 0: not pressed, 1: just pressed, 2:pressed, 3: just released
		private var _mouseEvent: MouseEvent;

		public function InteractionView(width : Number, height : Number, transparent: Boolean = true, fillcolor : uint = 0x000000, autoInit : Boolean = true) {
			super(width, height, transparent, fillcolor,autoInit);
			//_debug = new Bitmap(new BitmapData(width, height, transparent, 0x00000000), "auto", true);
			_objectsEvents = new Array();
			//addChild(_debug);
		}
		
		override internal function onAdded(e:Event = null):void 
		{
			super.onAdded(e);
			
			_markMouseX =  mouseX;
			_markMouseY =  mouseY;
			
			if (hitArea) {
				hitArea.addEventListener(MouseEvent.MOUSE_OUT, onMouseUp);
				hitArea.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				hitArea.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				
			}
			else {
				addEventListener(MouseEvent.MOUSE_OUT, onMouseUp);
				addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				addEventListener(MouseEvent.MOUSE_UP, onMouseUp);	
			}
		}
		
		override internal function onRemoved(e:Event):void 
		{
			if (hitArea) {
				hitArea.removeEventListener(MouseEvent.MOUSE_OUT, onMouseUp);
				hitArea.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				hitArea.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
			else {
				removeEventListener(MouseEvent.MOUSE_OUT, onMouseUp);
				removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);	
			}
			super.onRemoved(e);
		}
		
		private function onMouseDown(e:MouseEvent):void {
			if (_mouseState == MouseState.RELEASED) {
				_mouseEvent = e;
				_mouseState = MouseState.DOWN;
			}
		}
		
		private function onMouseUp(e:MouseEvent):void {
			if (_mouseState == MouseState.PRESSED) {
				_mouseEvent = e;
				_mouseState = MouseState.UP;
			}
		}
		
		override internal function onUpdate(e:Event):void 
		{
			UpdateMouseInteraction();
			Render();
		}

		public function UpdateMouseInteraction():void 
		{
			_deltaX = mouseX - _markMouseX;
			_deltaY = mouseY - _markMouseY;
			_markMouseX = mouseX;
			_markMouseY = mouseY;
			
			if (mouseEnabled && ( _mouseState == MouseState.DOWN || _mouseState == MouseState.UP)) {
				if(sortEventsNames != null)
					_objectsEvents.sortOn(sortEventsNames, sortEventsOptions);
					
			//	_debug.bitmapData.colorTransform(new Rectangle(0, 0, 760, 450), new ColorTransform(0, 0, 0, 0));
			//	var idx : uint =0;
			
				for each(var eventObject : IEventObject in _objectsEvents) {
			//		_debug.bitmapData.fillRect(eventObject.hitarea,((++idx / _objectsEvents.length) * 0xFFFFFFFF) | 0xFF000000);
					
					if (_mouseEvent && eventObject.willTrigger(_mouseEvent.type)) {
						if (_mouseState == MouseState.DOWN && eventObject.hitarea.contains(mouseX, mouseY)) {
							eventObject.dispatchEvent(_mouseEvent.clone());
							if (mouseTopOnly)
								_mouseState = MouseState.PRESSED;
						}
						else if (_mouseState == MouseState.UP )
							eventObject.dispatchEvent(_mouseEvent.clone());
					}
				}
		
		
				if (_mouseState == MouseState.DOWN)
					_mouseState = MouseState.PRESSED;
				else if (_mouseState == MouseState.UP )
					_mouseState = MouseState.RELEASED;
			}
		}
		
		override public function add(element:IGameObject):IGameObject 
		{
			if (element is IEventObject  && _objectsEvents.indexOf(element) == -1)
				_objectsEvents.push(element);
				
			return super.add(element);
		}
		
		override public function remove(element:IGameObject):IGameObject 
		{
			var idx : int = _objectsEvents.indexOf(element) ;
			if (idx != -1)
				_objectsEvents.splice(idx, 1);	
				
			return super.remove(element);
		}
		
		public function get deltaX():Number { return _deltaX; }
		public function get deltaY():Number { return _deltaY; }
		public function get mouseState():MouseState { return _mouseState; }
		public function get objectsEvents():Array { return _objectsEvents.concat(); }
	}

}