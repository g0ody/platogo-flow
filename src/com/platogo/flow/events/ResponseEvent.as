package com.platogo.flow.events 
{
	import com.platogo.flow.commands.core.ResponseCommand;
	import com.platogo.flow.enums.ResponseType;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Dominik
	 */
	public class ResponseEvent extends Event {

		private var _data : * ;
		private var _params : Array;
		private var _subEvent : Event;
		private var _command:ResponseCommand;
		private var _key : String;
		private var _responseType : ResponseType = ResponseType.DEFAULT;
		
		public function ResponseEvent(type : ResponseType, command : ResponseCommand, data : * = null, subEvent : Event = null, key : String = "", params :Array = null, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type.toString(), bubbles, cancelable);
			_command = command;
			_data = data;
			_subEvent = subEvent;
			_key = key;
			_responseType = type;
			_params = params;
		}
		
		override public function clone():Event {
			return new ResponseEvent(responseType ,command, data, subEvent, key, params, bubbles, cancelable);
		}
		
		public function get data():* {
			return _data;
		}
		
		public function get params():Array {
			return _params;
		}
		
		public function get subEvent():Event {
			return _subEvent;
		}
		
		public function get command():ResponseCommand {
			return _command;
		}
		
		public function get key():String 
		{
			return _key;
		}
		
		public function get responseType():ResponseType 
		{
			return _responseType;
		}
		
	}

}