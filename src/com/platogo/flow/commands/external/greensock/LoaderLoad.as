package com.platogo.flow.commands.external.greensock {
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.core.LoaderCore;
	import com.greensock.loading.LoaderMax;
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.commands.core.ResponseCommand;
	import com.platogo.flow.enums.ResponseType;
	import com.platogo.flow.utils.Utils;
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public class LoaderLoad extends ResponseCommand {
		private var _nameOrUrl : String;
		
		public var childEvents:Boolean = false;
		public var flushContent :Boolean = false;
		public var overrideVars:Object = null;

		public function LoaderLoad(nameOrUrl:String) {
			_nameOrUrl = nameOrUrl;
		}
		
		public function AChildEvents(hasChild : Boolean) :  LoaderLoad {
			this.childEvents = hasChild;
			return this;
		}
		
		public function AFlushContent(flushContent : Boolean) :  LoaderLoad {
			this.flushContent = flushContent;
			return this;
		}
		
		public function AOverrideVars(overrideVars : Object) :  LoaderLoad {
			this.overrideVars = overrideVars;
			return this;
		}
		
		static public function create(nameOrUrl:String): LoaderLoad{
			return new LoaderLoad(nameOrUrl);
		}
		
		override public function clone():Command {
			return new LoaderLoad(_nameOrUrl).SetAttributes(this);
		}
		
		override protected function execute():void {
			var loader : LoaderMax =LoaderMax.getLoader(_nameOrUrl);
			if (loader) {
				if (overrideVars) {
					var buffer : * = Utils.getObjectReferences(overrideVars);
					for (var key:String in buffer)
						loader.vars[key] = buffer[key];
				}
						
				loader.addEventListener(LoaderEvent.COMPLETE, onLoaderComplete);
				loader.addEventListener(LoaderEvent.ERROR, onLoaderError);
				loader.addEventListener(LoaderEvent.FAIL, onLoaderFail);
				if (childEvents) {
					loader.addEventListener(LoaderEvent.CHILD_COMPLETE, onChildComplete);
					loader.addEventListener(LoaderEvent.CHILD_FAIL, onChildFailed);
				}
				loader.load(flushContent);	
			}
			else
				callResponse(ResponseType.FAILED, this);
		}
		
		override protected function canceling():void {
			super.canceling();
			if (active) {
				var loader : LoaderCore = LoaderMax.getLoader(_nameOrUrl);
				if (loader) {
					removeEvents(loader);
					loader.cancel();
				}
			}
		}
		
		private function onChildFailed(e:LoaderEvent):void {
			callResponse(ResponseType.CHILD_FAILED, this, e.target.content, e, false);
		}
		
		private function onChildComplete(e:LoaderEvent):void {
			callResponse(ResponseType.CHILD_COMPLETED, this, e.target.content, e, false);
		}

		private function onLoaderFail(e:LoaderEvent):void {
			var loader : LoaderCore = e.target as LoaderCore;
			removeEvents(loader);
			callResponse(ResponseType.FAILED, this, loader.content, e);
		}
		
		private function onLoaderComplete(e:LoaderEvent):void {
			var loader : LoaderCore = e.target as LoaderCore;
			removeEvents(loader);
			callResponse(ResponseType.COMPLETED, this, loader.content, e);
		}
		
		private function onLoaderError(e:LoaderEvent):void {
			var loader : LoaderCore = e.target as LoaderCore;
			removeEvents(loader);
			callResponse(ResponseType.ERROR, this, loader.content, e);
		}
		
		private function removeEvents(loader : LoaderCore ):void {
			if (loader) {
				loader.removeEventListener(LoaderEvent.COMPLETE, onLoaderComplete);
				loader.removeEventListener(LoaderEvent.ERROR, onLoaderError);
				loader.removeEventListener(LoaderEvent.FAIL, onLoaderFail);
				if (childEvents) {
					loader.removeEventListener(LoaderEvent.CHILD_COMPLETE, onChildComplete);
					loader.removeEventListener(LoaderEvent.CHILD_FAIL, onChildFailed);
				}
			}
		}
		
		override public function toDetailString():String {
			return "nameOrUrl=" + String(_nameOrUrl) + ", flushContent=" + String(flushContent)+ ", overrideVars=" + String(overrideVars); 
		}
	}
}