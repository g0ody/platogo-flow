package com.platogo.flow.commands.data 
{
	import com.adobe.serialization.json.JSON;
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.commands.core.ParseCommand;
	import com.platogo.flow.utils.Utils;
	import flash.net.URLRequestMethod;
	
	/**
	 * ...
	 * @author Dominik
	 */
	public class ParseCreate extends ParseCommand 
	{
		private var _data : Object;
		
		public function ParseCreate(applicationId:String, restApiKey:String, className:String, data : Object) 
		{
			super(applicationId, restApiKey, className);
			_data = data;
		}
		
		static public function create(applicationId:String, restApiKey:String, className:String, data : Object): ParseCreate{
			return new ParseCreate(applicationId, restApiKey, className, data);
		}
		
		override public function clone():Command {
			return new ParseCreate(_applicationId, _restApiKey, _className, _data).SetAttributes(this);
		}
		
		override protected function execute():void {
			Send(URLRequestMethod.POST, com.adobe.serialization.json.JSON.encode( _data ));
		}
		
		override public function toDetailString():String 
		{
			return super.toDetailString() + " ,data=" + Utils.convertObjectToString(_data);
		}
	}

}