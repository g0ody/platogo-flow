package com.platogo.flow.screens{
	import com.platogo.flow.container.IContainer;
	import com.platogo.flow.core.ScreenManager;
	import com.platogo.flow.events.ScreenEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public class Screen implements IEventDispatcher {
		private var _key : String;
		private var _container : IContainer;
		private var _manager : ScreenManager;
		private var _prototype : Screen;
		private var _defaultLayerIdx: uint;
		private var _eventDispatcher : EventDispatcher;
		
		
		public function Screen() {
			_eventDispatcher = new EventDispatcher(this);
			this.addEventListener(ScreenEvent.INIT, onScreenInit);
		}
		
		private function onScreenInit(e:ScreenEvent):void {
			this.removeEventListener(ScreenEvent.INIT, onScreenInit);
			_manager = e.manager;
			_container = manager.createContainer();
			_defaultLayerIdx = e.defaultLayerIdx;
			_prototype =  e.prototype;
			_key = e.key;
		}

		public function get container():IContainer {
			if (_container == null) {
				throw new Error("Register the Screen first with a Screenmanager");
			}
			return _container;
		}
		
		public function show():void {
			push(defaultLayerIdx);
		}
		
		public function hide():void {
			pop();
		}
		
		public function get key():String {
			return _key;
		}
		
		public function push(layerIDX : int = -1):void {
			manager.push(this, layerIDX);
		}
		
		public function pop():void {
			manager.pop(this);
		}
		
		public function clone():Screen {
			return new Screen();
		}
		
		/* INTERFACE flash.events.IEventDispatcher */
		
		public function dispatchEvent(event:Event):Boolean 
		{
			return _eventDispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean 
		{
			return _eventDispatcher.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean 
		{
			return _eventDispatcher.willTrigger(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void 
		{
			return _eventDispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{
			return _eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function get manager():ScreenManager {
			if (_manager == null) {
				throw new Error("Register the Screen first with a Screenmanager");
			}
			return _manager;
		}
		
		public function get defaultLayerIdx():uint { return _defaultLayerIdx; }
		
		public function get prototype():Screen { 
			if (_prototype == null) {
				throw new Error("Register the Screen first with a Screenmanager");
			}
			return _prototype;
		}
	}
}