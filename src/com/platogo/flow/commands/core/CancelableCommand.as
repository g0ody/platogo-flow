package com.platogo.flow.commands.core {
	import com.platogo.flow.core.LogFile;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.getQualifiedClassName;
	
	
	public class CancelableCommand extends Command {

		public function CancelableCommand() {}
		
		override public function clone():Command {
			return new CancelableCommand().SetAttributes(this);
		}
		
		/**
		 * Cancels the command.
		 * This method can be used directly as an event listener.
		 */
		public final function cancel(e:Event = null):void {
			if (active) {
				internalCancel();
				LogFile.instance.debug(getQualifiedClassName(this), "Cancel", toDetailString());
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		public final function cancelAll(e:Event = null):void {
			if (active) {
				internalCancel();
				LogFile.instance.debug(getQualifiedClassName(this), "CancelAll", toDetailString());
				dispatchEvent(new Event(Event.CANCEL));
			}
		}
		
		private function internalCancel():void {
			if (_timer && _timer.running) {
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
				_timer = null;
			}
			_active = false;
			canceling();
		}
		
		protected function canceling():void {
			
		}
	}
}