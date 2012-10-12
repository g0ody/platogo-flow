package com.platogo.flow.commands.utils {
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.commands.core.ResponseCommand;
	import com.platogo.flow.enums.ResponseType;
	import com.platogo.flow.events.ResponseEvent;
	import com.platogo.flow.responses.IResponse;
	import com.platogo.flow.utils.Utils;
	
	//this command invokes a function
	public class ParseFunction extends ResponseCommand {
		private var _parse:Function;
		private var _input:Object;
		
		public var check:Function;
		
		public function ParseFunction(input : Object, parse:Function) {
			_parse = parse;
			_input = input;
		}
		
		public function ACheck( check : Function ) : ParseFunction {
			this.check = check;
			return this;
		}
		
		static public function create(input : Object, parse:Function): ParseFunction {
			return new ParseFunction(input, parse);
		}
		
		override public function clone():Command {
			return new ParseFunction(_input, _parse).SetAttributes(this);
		}
		
		override protected function execute():void {
			var data : *  = _parse.call(null, Utils.getReferenceData(_input));

			if (check != null)
				if (check.call(null, data))
					callResponse(ResponseType.COMPLETED, this, data);
				else
					callResponse(ResponseType.FAILED, this, data);
			else
				callResponse(ResponseType.CONFIRMED, this, data);
		}
		
		override public function toDetailString():String {
			return "input=" + String(_input) + ", parse=" + String(_parse.prototype) + ", check=" + String((check != null)?check.prototype:check); 
		}
	}
}