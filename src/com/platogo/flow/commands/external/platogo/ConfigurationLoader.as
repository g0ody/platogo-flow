package com.platogo.flow.commands.external.platogo 
{
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.commands.data.SpreadSheetLoader;
	import com.platogo.flow.responses.IResponse;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	/**
	 * https://spreadsheets.google.com/feeds/worksheets/[key]/public/basic --> to finde the sheet keys
	 * @author Dominik Hurnaus
	 */
	public class ConfigurationLoader extends SpreadSheetLoader{
		public function ConfigurationLoader(file:String, sheet:String, mapping:*) {
			super("http://spreadsheetproxy.platogo.com", file, sheet, mapping);
		}
		
		static public function create(file:String, sheet:String, mapping:*): ConfigurationLoader{
			return new ConfigurationLoader(file, sheet, mapping);
		}
		
		override public function clone():Command 
		{
			return new ConfigurationLoader(_file, _sheet, _mapping).SetAttributes(this);
		}
		
		override protected function get request():URLRequest {
			var ur:URLRequest = new URLRequest(_url + "/" + _file + "/" + _sheet);
			ur.method = URLRequestMethod.GET;
			return ur;
		}

	}

}