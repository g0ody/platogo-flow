package com.platogo.flow.commands.sequence 
{
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.utils.Utils;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Dominik
	 */
	public class Choice extends Command 
	{
		private var _choose : * ;
		private var _choices : Dictionary = new Dictionary();
		private var _defaultChoice : Command;
		
		public function Choice(choose:*) {
			_choose = choose;
		}
		
		static public function create(choose:*): Choice{
			return new Choice(choose);
		}
		
		override public function clone():Command 
		{
			var cmd : Choice = new Choice(_choose).SetAttributes(this) as Choice;
			for (var key:* in _choices)
				cmd.AddChoice(key, _choices[key] as Command);
			return cmd;
		}
		
		override protected function execute():void {
			var chooseBuffer : * = Utils.getReferenceData(_choose);
			var parallel : Parallel = new Parallel();
			for (var key:* in _choices) 
			{
				if (chooseBuffer == Utils.getReferenceData(key)) 
					parallel.AddCommand(_choices[key]);
			}
			
			if (parallel.Count > 0)
			{
				parallel.addEventListener(Event.COMPLETE, complete);
				parallel.start();
			}
			else if (_defaultChoice != null)
			{
				_defaultChoice.addEventListener(Event.COMPLETE, complete);
				_defaultChoice.start();
			}
			else
				complete();
		}
		
		public function AddDefaultChoice( cmd : Command):Choice {
			_defaultChoice = cmd;
			return this;
		}
		
		public function AddChoice(key : * , cmd : Command):Choice {
			_choices[key] = cmd;
			return this;
		}
		
		override public function toDetailString():String {
			return "choose=" + String(_choose); 
		}
	}
}