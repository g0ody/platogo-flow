package com.platogo.flow.commands.data {
	import com.hurlant.util.Base64;
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.commands.core.OptionsCommand;
	import com.platogo.flow.commands.core.ResponseCommand;
	import com.platogo.flow.enums.ResponseType;
	import com.platogo.flow.events.ResponseEvent;
	import com.platogo.flow.responses.IResponse;
	import com.platogo.flow.utils.Utils;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	public class Base64Loader extends OptionsCommand {
		private var _loader:URLLoader;
		protected var _url:String;
		
		public var urlVariables:URLVariables;
		
		public function Base64Loader(url: String) {
			_url = url;
		}
		
		public function AUrlVariables(urlVariables : URLVariables) : Base64Loader {
			this.urlVariables = urlVariables;
			return this;
		}
		
		static public function create(url: String): Base64Loader{
			return new Base64Loader(url);
		}
		
		override public function clone():Command {
			return new Base64Loader(_url).SetAttributes(this);
		}
      
		override protected function execute():void {
			// Request the URL via our proxy.
			var vars : URLVariables = urlVariables;
			if (vars == null) {
				vars = new URLVariables();
			}
			
			if (options != null) {
				var buffer : * = GetOptions();
				for (var k:String in buffer)
					vars[k] = buffer[k];
			}
			
			var ur:URLRequest = new URLRequest(_url);
			ur.method = URLRequestMethod.GET;
			ur.data = vars;

			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, onLoadComplete);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadFail);
			_loader.addEventListener(IOErrorEvent.NETWORK_ERROR, onLoadFail);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadFail);
			_loader.load(ur);
		}
		
		override protected function canceling():void {
			super.canceling();
			if (active) {
				_loader.close();
				removeListeners();
			}
		}
		
		private function onLoadComplete(e:Event):void {
			removeListeners();
			callResponse(ResponseType.COMPLETED, this, Base64.decode(_loader.data as String), e);
		}
		
		private function onLoadFail(e:Event):void {
			removeListeners();
			callResponse(ResponseType.FAILED, this, _loader.data, e);
		}
		
		private function removeListeners():void {
			_loader.removeEventListener(Event.COMPLETE, onLoadComplete);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, onLoadFail);
			_loader.removeEventListener(IOErrorEvent.NETWORK_ERROR, onLoadFail);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadFail);
		}
		
		override public function toDetailString():String {
			return "url=" + String(_url) + " vars=" + Utils.convertObjectToString(urlVariables) ;
		}
	}
}
