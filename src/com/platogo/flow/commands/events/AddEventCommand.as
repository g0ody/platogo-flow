package com.platogo.flow.commands.events {
	import _as.fla.events.EC;
	import com.platogo.flow.commands.core.CancelableCommand;
	import com.platogo.flow.commands.core.Command;
	import flash.events.Event;
	
	public class AddEventCommand extends CancelableCommand {
		private var _command:Command;
		private var _obj:Object;
		private var _type:String;
		
		public var onlyOneTime:Boolean = false;
		public var clusterID:String= "UNCLUSTERED";
		
		public function AddEventCommand(obj:Object, type:String, command:Command) {
			_command = command;
			_obj = obj;
			_type = type;
		}
		
		public function AClusterID(clusterID : String) : AddEventCommand{
			this.clusterID = clusterID;
			return this;
		}
		
		public function AOnlyOnce(onlyOneTime : Boolean) : AddEventCommand{
			this.onlyOneTime = onlyOneTime;
			return this;
		}
		
		static public function create(obj:Object, type:String, command:Command): AddEventCommand{
			return new AddEventCommand(obj, type, command);
		}
		
		override public function clone():Command 
		{
			return new AddEventCommand(_obj, _type, _command).SetAttributes(this);
		}
		
		private function onEvent(e:Event):void {
			if (clusterID == EC.UNCLUSTERED || onlyOneTime)
				EC.remove(_obj, _type, onEvent);
				
			_command.addEventListener(Event.COMPLETE, onSubcommandComplete);
			_command.addEventListener(Event.CANCEL, cancelAll);
			_command.start();
		}
		
		private function onSubcommandComplete(e:Event):void {
			removeEventListeners();
			complete();
		}
		
		private function removeEventListeners():void {
			_command.removeEventListener(Event.COMPLETE, onSubcommandComplete);
			_command.removeEventListener(Event.CANCEL, cancelAll);
		}
		
		override protected function canceling():void {
			if (active) {
				removeEventListeners();
				if(_command is CancelableCommand) {
					(_command as CancelableCommand).cancel();
				}
			}
		}
		
		override protected function execute():void {
			EC.add(_obj, _type, onEvent, false, 0, false, clusterID);
		}
		
		override public function toDetailString():String {
			return "obj=" + String(_obj) + ", type=" + String(_type)+ ", clusterID=" + String(clusterID); 
		}
	}
}