package com.platogo.flow.commands.loading 
{
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.commands.core.ResponseCommand;
	import com.platogo.flow.enums.ResponseType;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public class LoaderLoadBytes extends ResponseCommand {
		private var _loader : Loader;
		private var _bytes : ByteArray;
		
		public var context : LoaderContext = null;
		
		public function LoaderLoadBytes(loader : Loader, bytes : ByteArray) {
			_loader = loader;
			_bytes = bytes;
		}
		
		public function AContext( context : LoaderContext) : LoaderLoadBytes {
			this.context = context;
			return this;
		}
		
		static public function create(loader : Loader, bytes : ByteArray): LoaderLoadBytes{
			return new LoaderLoadBytes(loader, bytes);
		}
		
		override public function clone():Command {
			return new LoaderLoadBytes(_loader, _bytes).SetAttributes(this);
		}
		
		override protected function execute():void {
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCallback)
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onCallback)
			_loader.loadBytes(_bytes, context);
		}
		
		private function onCallback(e:Event):void {
			_loader.removeEventListener(Event.COMPLETE, onCallback)
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, onCallback)
			if (e.type == Event.COMPLETE)
				callResponse(ResponseType.COMPLETED, this, _loader.content, e);
			else
				callResponse(ResponseType.FAILED, this, _loader.content, e);
		}
		
		override public function toDetailString():String {
			return "loader=" + String(_loader) + ", context=" + String(context); 
		}
		
	}

}