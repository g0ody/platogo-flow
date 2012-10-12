package com.platogo.flow.commands.utils {
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.commands.core.ResponseCommand;
	import com.platogo.flow.enums.ResponseType;
	import com.platogo.flow.utils.Utils;
	
	//this command invokes a function
	public class InvokeFunction extends ResponseCommand{
		private var _func:Function;
		
		public var params:Array;
		
		public function InvokeFunction(func:Function) {
			_func = func;
		}
		
		public function AParameters(params : Array): InvokeFunction {
			this.params = params;
			return this;
		}
		
		static public function create(func:Function): InvokeFunction {
			return new InvokeFunction(func);
		}
		
		override public function clone():Command {
			return new InvokeFunction(_func).SetAttributes(this);
		}
		
		override protected function execute():void {
			callResponse(ResponseType.COMPLETED, this, _func.apply(null, Utils.getArrayReferences(params)));
		}
		
		override public function toDetailString():String {
			return "func=" + String(_func.prototype) + ", params=" + Utils.convertArrayToString(params); 
		}
	}
}