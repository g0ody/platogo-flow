package com.platogo.flow.commands.external.greensock  {
	import com.greensock.TweenMax;
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.utils.Utils;
	
	//this command encapsulates the TweenMax.to() method
	public class TweenMaxTo extends Command {
		private var _target:Object;
		private var _duration:Number;
		private var _vars:Object;
		
		public function TweenMaxTo(target:Object, duration:Number, vars:Object) {
			_target = target;
			_duration = duration;
			_vars = vars;
		}
		
		static public function create(target:Object, duration:Number, vars:Object): TweenMaxTo{
			return new TweenMaxTo(target, duration, vars);
		}
		
		override public function clone():Command 
		{
			return new TweenMaxTo(_target, _duration, _vars).SetAttributes(this);
		}
		
		override protected function execute():void {
			_vars.onComplete = complete;
			TweenMax.to(_target, _duration, _vars);
		}
		
		override public function toDetailString():String {
			return "target=" + String(_target) + ", duration=" + String(_duration)+ ", vars=" + Utils.convertObjectToString(_vars); 
		}
	}
}