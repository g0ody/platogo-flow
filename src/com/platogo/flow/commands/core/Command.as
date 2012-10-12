package com.platogo.flow.commands.core {
	import com.platogo.flow.core.CommandManager;
	import com.platogo.flow.core.LogFile;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.getQualifiedClassName;
	import flash.utils.Timer;
	
	public class Command extends EventDispatcher {
		internal var _timer:Timer;
		internal var _active : Boolean = false;
		
		public var delay : Number = 0;
		public var customCommandManager:String;
		
		public function Command() { }
		
		public function ADelay(value : Number) : Command {
			this.delay = value;
			return this;
		}
		
		public function SetAttributes( vars : Object) : Command {
			for (var k:String in vars)
					this[k] = vars[k];
			return this;
		}
		
		public function SetAttribute(key : String, value : *) : Command {
			this[key] = value;
			return this;
		}
		
		public function ACustomCommandManager(customCommandManager:String) : Command {
			this.customCommandManager = customCommandManager;
			return this;
		}
	
		protected function GetCommandManagerInstance() : CommandManager
		{
			if (customCommandManager != null && customCommandManager.length > 0)
				return CommandManager.getInstance(customCommandManager);
			else
				return CommandManager.defaultInstance;
		}
		
			
		/**
		 * Starts the command. 
		 * Waits for the timer to complete and calls the execute() method.
		 * This method can be used directly as an event listener.
		 */
		public final function start(e:Event = null):void {
			if (delay !=  0) {
				if (delay < 0)
					delay = 0;
				_timer = new Timer(int(1000 * delay), 1);
				_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
				_timer.start();
			}
			else
				internalStart();
		}
		
		public function clone():Command {
			return new Command().SetAttributes(this);
		}
		
		private function internalStart ():void {
			_active = true;
			LogFile.instance.debug(getQualifiedClassName(this).split("::").pop() as String, "Execute", toDetailString());
			execute();
		}
		
		/**
		 * The abstract method for you to override to create your own command.
		 */
		protected function execute():void {
			
		}
		
		internal function onTimerComplete(e:TimerEvent):void {
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			_timer = null;
			internalStart();
		}

		/**
		 * Completes the command. 
		 * Dispatches a complete event.
		 * This method can be used directly as an event listener.
		 */
		protected final function complete(e:Event = null):void {
			_active = false;
			LogFile.instance.debug(getQualifiedClassName(this).split("::").pop() as String, "Completed", toDetailString());
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function toDetailString():String {
			return "";
		}
		
		public function get active():Boolean { return _active; }
	}
}