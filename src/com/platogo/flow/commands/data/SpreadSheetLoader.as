package com.platogo.flow.commands.data {
	import com.hurlant.util.Base64;
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.commands.core.ResponseCommand;
	import com.platogo.flow.enums.ResponseType;
	import com.platogo.flow.events.ResponseEvent;
	import com.platogo.flow.responses.IResponse;
	import com.platogo.flow.utils.SpreadsheetUtils;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.Dictionary;
	
	/**
	 * https://spreadsheets.google.com/feeds/worksheets/[key]/public/basic --> to finde the sheet keys
	 * @author Dominik Hurnaus
	 */
	public class SpreadSheetLoader extends ResponseCommand {
		private var _loader:URLLoader;
		
		protected var _file:String = "";
		protected var _sheet:String = "";
		protected var _url:String = "";
		protected var _mapping:*;
		
		public var autotrim:Boolean = true;
		
		public function SpreadSheetLoader(url: String, file:String, sheet:String, mapping:*) {
			_url = url;
			_file = file;
			_sheet = sheet;
			_mapping = mapping;
		}
		
		public function AAutoTrim(autotrim : Boolean):SpreadSheetLoader {
			this.autotrim = autotrim;
			return this;
		}
		
		static public function create(url: String, file:String, sheet:String, mapping:*): SpreadSheetLoader{
			return new SpreadSheetLoader(url, file, sheet, mapping);
		}
		
		override public function clone():Command{
			return new SpreadSheetLoader(_url, _file, _sheet, _mapping).SetAttributes(this);
		}
      
		override protected function execute():void {
			// Request the URL via our proxy.
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, onLoadComplete);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadFail);
			_loader.addEventListener(IOErrorEvent.NETWORK_ERROR, onLoadFail);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadFail);
			_loader.load(request);
		}
		
		override protected function canceling():void {
			super.canceling();
			if (active) {
				_loader.close();
				removeListeners();
			}
		}
		
		protected function get request():URLRequest {
			var ur:URLRequest = new URLRequest(_url);
			ur.method = URLRequestMethod.GET;
			ur.data = new URLVariables();
			ur.data["file"] = _file;
			ur.data["sheet"] = _sheet;
			return ur;
		}

		private function onLoadComplete(e:Event):void {
			removeListeners();
			callResponse(ResponseType.COMPLETED, this, SpreadsheetUtils.decode(Base64.decode(_loader.data as String), _mapping, autotrim), e);
		}
		
		private function removeListeners():void {
			_loader.removeEventListener(Event.COMPLETE, onLoadComplete);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, onLoadFail);
			_loader.removeEventListener(IOErrorEvent.NETWORK_ERROR, onLoadFail);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadFail);
		}
		
		private function onLoadFail(e:Event):void {
			removeListeners();
			callResponse(ResponseType.FAILED, this, null , e);
		}
		
		override public function toDetailString():String {
			return "url=" + String(_url) + ", file=" + String(_file) + ", sheet=" + String(_sheet) + ", mapping=" + String(_mapping) + ", autotrim=" + String(autotrim); 
		}
	}
}
