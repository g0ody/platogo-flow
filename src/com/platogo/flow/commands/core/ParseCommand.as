package com.platogo.flow.commands.core 
{
	import com.adobe.serialization.json.JSON;
	import com.platogo.flow.commands.core.ResponseCommand;
	import com.platogo.flow.enums.ResponseType;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.LoaderContext;

	/**
	 * ...
	 * @author Dominik
	 */
	public class ParseCommand extends ResponseCommand 
	{
		public static const PARSE_API:String = "https://api.parse.com/1/classes/";
		public static const PROXY:String = "https://frequency-game-proxy.herokuapp.com/";
		public static const JSON_CONTENT:String = "application/json";
		
		protected var _applicationId : String;
		protected var _restApiKey : String;
		protected var _className : String;
		
		public var context : LoaderContext;
		
		private var _loader:URLLoader = new URLLoader();
		
		public function ParseCommand( applicationId:String, restApiKey:String, className:String) 
		{
			super();
			_applicationId = applicationId;
			_restApiKey = restApiKey;
			_className = className;
		}
		
		public function AContext( context : LoaderContext):ParseCommand {
			this.context = context;
			return this;
		}

		protected function Send( requestMethod:String, data:Object = null, postfix : String = ""):void
		{
			var request:URLRequest;
			if (requestMethod == URLRequestMethod.GET) 
			{
				request = new URLRequest(PROXY + _className + postfix);
				request.method = URLRequestMethod.GET;
				request.data = data;
			}
			else
			{
				request = new URLRequest(PARSE_API + _className + postfix);
				request.data = (data != null) ? data : new URLVariables();
				request.method = URLRequestMethod.POST;
				request.contentType = JSON_CONTENT;

				if(requestMethod != URLRequestMethod.POST)
					request.requestHeaders.push( new URLRequestHeader("X-HTTP-Method-Override", requestMethod));
					
				request.requestHeaders.push( new URLRequestHeader("X-Parse-Application-Id", _applicationId) );
				request.requestHeaders.push( new URLRequestHeader("X-Parse-REST-API-Key", _restApiKey));
			}
			_loader.addEventListener(Event.COMPLETE, onLoadComplete);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadFail);
			_loader.addEventListener(IOErrorEvent.NETWORK_ERROR, onLoadFail);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadFail);
			_loader.load( request);	
		}
		
		override protected function canceling():void {
			super.canceling();
			if (active) {
				_loader.close();
				removeListeners();
			}
		}
		
		protected function DataLoaded(data : * ):* {
			return data;
		}
		
		private function onLoadComplete(e:Event):void {
			removeListeners();
			var data : * = com.adobe.serialization.json.JSON.decode( _loader.data );
			if(data != null && data is Object && (data as Object).hasOwnProperty("error"))
				callResponse(ResponseType.FAILED, this, data, e);
			else
				callResponse(ResponseType.COMPLETED, this, DataLoaded(data), e);
		}
		
		private function onLoadFail(e:Event):void {
			removeListeners();
			callResponse(ResponseType.FAILED, this, e.type, e);
		}
		
		private function removeListeners():void {
			_loader.removeEventListener(Event.COMPLETE, onLoadComplete);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, onLoadFail);
			_loader.removeEventListener(IOErrorEvent.NETWORK_ERROR, onLoadFail);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadFail);
		}
		
		override public function toDetailString():String {
			return "className=" + String(_className); 
		}
	}

}