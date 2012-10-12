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
	public class ParseSearch extends ParseCommand 
	{
		public var where:Object = null;
		public var limit:int = -1;
		public var skip:int = 0;
		
		public function ParseSearch(applicationId:String, restApiKey:String, className:String) 
		{
			super(applicationId, restApiKey, className);
		}
		
		public function AWhere(where : Object):ParseSearch {
			this.where = where;
			return this;
		}		
		
		public function ALimit(limit : int):ParseSearch {
			this.limit = limit;
			return this;
		}
		
		public function ASkip(skip : int):ParseSearch {
			this.skip = skip;
			return this;
		}
		
		static public function create(applicationId:String, restApiKey:String, className:String): ParseSearch{
			return new ParseSearch(applicationId, restApiKey, className);
		}
		
		override public function clone():Command {
			return new ParseSearch(_applicationId, _restApiKey, _className).SetAttributes(this);
		}
		
		override protected function DataLoaded(data:*):* 
		{
			return data.results;
		}
		
		override protected function execute():void {
			var query : URLVariables = new URLVariables();
			if(limit > 0)
				query.limit = limit;
			query.skip = skip;
			if (where != null)
				query.where = com.adobe.serialization.json.JSON.encode( where)
			
			Send("GET", query);
		}
		
		override public function toDetailString():String 
		{
			return super.toDetailString() +  " ,where=" + Utils.convertObjectToString(where)+ " ,limit=" + String(limit) + " ,skip=" + String(skip) ;
		}
	}

}