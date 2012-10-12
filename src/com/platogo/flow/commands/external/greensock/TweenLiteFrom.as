package com.platogo.flow.commands.external.greensock {
	import com.greensock.TweenLite;
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.utils.Utils;
	
	//this command encapsulates the TweenMax.from() method
	public class TweenLiteFrom extends Command {
		private var _target:Object;
		private var _duration:Number;
		private var _vars:Object;
		
		public function TweenLiteFrom(target:Object, duration:Number, vars:Object) {
			_target = target;
			_duration = duration;
			_vars = vars;
		}
		
		static public function create(target:Object, duration:Number, vars:Object): TweenLiteFrom{
			return new TweenLiteFrom(target, duration, vars);
		}
		
		override public function clone():Command 
		{
			return new TweenLiteFrom(_target, _duration, _vars).SetAttributes(this);
		}
		
		override protected function execute():void {
			_vars.onComplete = complete;
			TweenLite.from(_target, _duration, _vars);
		}
		
		override public function toDetailString():String {
			return "target=" + String(_target) + ", duration=" + String(_duration)+ ", vars=" + Utils.convertObjectToString(_vars); 
		}
	}
}