package com.platogo.flow.commands.utils
{
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.commands.core.ParametersCommand;
	import com.platogo.flow.utils.Utils;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public class InvokeCommand extends ParametersCommand {
		
		private var _commandType : Class;
		
		public var optionalAttributes : Object;
		
		public function InvokeCommand(commandType:Class) {
			_commandType = commandType;
		}
		
				
		public function AOptionalAttributes( optionalAttributes:Object) : InvokeCommand{
			this.optionalAttributes = optionalAttributes;
			return this;
		}

		static public function create(commandType:Class): InvokeCommand {
			return new InvokeCommand(commandType);
		}
		
		override public function clone():Command 
		{
			return new InvokeCommand(_commandType).SetAttributes(this);
		}
		
		override protected function execute():void {
			var buffer : Array = Utils.getArrayReferences(params);
			var cmd : Command = _commandType.create.apply(null, buffer) as Command;
			cmd.SetAttributes(optionalAttributes);
			cmd.addEventListener(Event.COMPLETE, complete);
			cmd.start();
		}
		
		override public function toDetailString():String {
			return "commandType=" + String(_commandType.prototype) + ", params=" + Utils.convertArrayToString(params); 
		}
	}
}