package com.platogo.flow.commands.external.greensock {
	import com.greensock.TweenMax;
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.utils.Utils;
	
	//this command encapsulates the TweenMax.from() method
	public class TweenMaxFrom extends Command {
		private var _target:Object;
		private var _duration:Number;
		private var _vars:Object;
		
		public function TweenMaxFrom(target:Object, duration:Number, vars:Object) {
			_target = target;
			_duration = duration;
			_vars = vars;
		}
		
		static public function create(target:Object, duration:Number, vars:Object): TweenMaxFrom{
			return new TweenMaxFrom(target, duration, vars);
		}
		
		override public function clone():Command 
		{
			return new TweenMaxFrom(_target, _duration, _vars).SetAttributes(this);
		}
		
		override protected function execute():void {
			_vars.onComplete = complete;
			TweenMax.from(_target, _duration, _vars);
		}
		
		override public function toDetailString():String {
			return "target=" + String(_target) + ", duration=" + String(_duration)+ ", vars=" + Utils.convertObjectToString(_vars); 
		}
	}
}