package com.platogo.flow.commands.data 
{
	import com.adobe.serialization.json.JSON;
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.commands.core.ParseCommand;
	import com.platogo.flow.utils.Utils;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	/**
	 * ...
	 * @author Dominik
	 */
	public class ParseCount extends ParseCommand 
	{
		public var where:Object = null;
		public var limit:int = -1;
		public var count:int = 1;
		
		public function ParseCount(applicationId:String, restApiKey:String, className:String) 
		{
			super(applicationId, restApiKey, className);
		}
		
		public function AWhere(where : Object):ParseCount {
			this.where = where;
			return this;
		}		
		
		public function ALimit(limit : int):ParseCount {
			this.limit = limit;
			return this;
		}
		
		public function ACount(count : int):ParseCount {
			this.count = count;
			return this;
		}
		
		static public function create(applicationId:String, restApiKey:String, className:String): ParseCount{
			return new ParseCount(applicationId, restApiKey, className);
		}
		
		override public function clone():Command {
			return new ParseCount(_applicationId, _restApiKey, _className).SetAttributes(this);
		}
		
		override protected function DataLoaded(data:*):* 
		{
			return data.count;
		}
		
		override protected function execute():void {
			var query : URLVariables = new URLVariables();
			if(limit > 0)
				query.limit = limit;
			query.count = count;
			if (where != null)
				query.where = com.adobe.serialization.json.JSON.encode( where)
			
			Send("GET", query);
		}
		
		override public function toDetailString():String 
		{
			return super.toDetailString() +  " ,where=" + Utils.convertObjectToString(where)+ " ,limit=" + String(limit) + " ,count=" + String(count) ;
		}
	}

}