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
	public class ParseUpdate extends ParseCommand 
	{
		private var _data : Object;
		private var _objectId : String;
		
		public function ParseUpdate(applicationId:String, restApiKey:String, className:String, objectId : String ,  data : Object) 
		{
			super(applicationId, restApiKey, className);
			_data = data;
			_objectId  = objectId;
		}
		
		static public function create(applicationId:String, restApiKey:String, className:String, objectId : String , data : Object): ParseUpdate{
			return new ParseUpdate(applicationId, restApiKey, className, objectId, data);
		}
		
		override public function clone():Command {
			return new ParseUpdate(_applicationId, _restApiKey, _className, _objectId, _data).SetAttributes(this);
		}
		
		override protected function execute():void {
			Send("PUT", com.adobe.serialization.json.JSON.encode( _data ), "/" + _objectId);
		}
		
		override public function toDetailString():String 
		{
			return super.toDetailString() + " ,objectId=" + _objectId + " ,data=" + Utils.convertObjectToString(_data);
		}
	}

}