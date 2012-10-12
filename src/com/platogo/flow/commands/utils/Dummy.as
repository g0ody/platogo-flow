package com.platogo.flow.commands.utils {
	import com.platogo.flow.commands.core.Command;
	
	//this command simply does nothing and completes itself upon execution
	public class Dummy extends Command {
		
		public function Dummy() {
			
		}
		
		static public function create(): Dummy {
			return new Dummy();
		}
		
		override public function clone():Command 
		{
			return new Dummy();
		}
		
		override protected function execute():void {
			complete();
		}
	}
}