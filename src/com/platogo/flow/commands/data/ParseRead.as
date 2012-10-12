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
	public class ParseRead extends ParseCommand 
	{
		public var _objectId : String;
		
		public function ParseRead(applicationId:String, restApiKey:String, className:String, objectId : String ) 
		{
			super(applicationId, restApiKey, className);
			_objectId  = objectId;
		}
		
		static public function create(applicationId:String, restApiKey:String, className:String, objectId : String): ParseRead{
			return new ParseRead(applicationId, restApiKey, className, objectId);
		}
		
		override public function clone():Command {
			return new ParseRead(_applicationId, _restApiKey, _className, _objectId).SetAttributes(this);
		}
		
		override protected function execute():void {
			Send( URLRequestMethod.GET, null, "/" + _objectId);
		}
		
		override protected function DataLoaded(data:*):* 
		{
			data["objectId"] = _objectId;
			return data;
		}
		
		override public function toDetailString():String 
		{
			return super.toDetailString() + " ,objectId=" + _objectId;
		}
	}

}