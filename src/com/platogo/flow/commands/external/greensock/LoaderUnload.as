package com.platogo.flow.commands.external.greensock {
	import com.greensock.loading.core.LoaderCore;
	import com.greensock.loading.LoaderMax;
	import com.platogo.flow.commands.core.Command;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public class LoaderUnload extends Command {
		private var _nameOrUrl : String;
		public var disposeChildren : Boolean = true;
		public var unloadAllContent : Boolean= false;
		
		public function LoaderUnload(nameOrUrl:String) {
			this._nameOrUrl = nameOrUrl;
		}	

		public function ADisposeChildren( disposeChildren:Boolean) : LoaderUnload {
			this.disposeChildren = disposeChildren;
			return this;
		}
		
		public function AUnloadAllContent( unloadAllContent:Boolean) : LoaderUnload {
			this.unloadAllContent = unloadAllContent;
			return this;
		}
		
		static public function create(nameOrUrl:String): LoaderUnload{
			return new LoaderUnload(nameOrUrl);
		}
		
		override public function clone():Command {
			return new LoaderUnload(_nameOrUrl).SetAttributes(this);
		}
		
		override protected function execute():void {
			var loader : LoaderMax = LoaderMax.getLoader(_nameOrUrl) as LoaderMax;
			if (loader)
				loader.empty(disposeChildren, unloadAllContent);
		
			complete();
		}
		
		override public function toDetailString():String {
			return "nameOrUrl=" + String(_nameOrUrl) + ", disposeChildren=" + String(disposeChildren)+ ", unloadAllContent=" + String(unloadAllContent); 
		}
	}

}