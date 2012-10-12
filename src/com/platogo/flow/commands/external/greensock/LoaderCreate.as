package com.platogo.flow.commands.external.greensock 
{
	import com.greensock.loading.core.LoaderCore;
	import com.greensock.loading.core.LoaderItem;
	import com.greensock.loading.LoaderMax;
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.utils.Utils;
	
	/**
	 * Wrapper around greensock loader class
	 * @author Dominik Hurnaus
	 */
	public class LoaderCreate extends Command {
		private var _loader:LoaderCore;
		private var _queue:String;
		
		public var vars:Object = null;
		public var atFront:Boolean = false;
		
		public function LoaderCreate(loader : LoaderCore , queue:String) {
			this._loader = loader;
			this._queue = queue;
		}
		
		public function AParameters(vars : Object) : LoaderCreate {
			this.vars = vars;
			return this;
		}
		
		public function AAtFront(atFront:Boolean) : LoaderCreate {
			this.atFront = atFront;
			return this;
		}
		
		static public function create(loader : LoaderCore , queue:String): LoaderCreate {
			return new LoaderCreate(loader, queue);
		}
		
		override public function clone():Command {
			return new LoaderCreate(_loader, _queue).SetAttributes(this);
		}
		
		override protected function execute():void {
			if (_loader) {
				var buffer : * = Utils.getObjectReferences(vars);
			
				for (var key:String in buffer)
					_loader.vars[key] = buffer[key];
		
				if (_queue != null ) {
					var queueObj : LoaderMax = LoaderMax.getLoader(_queue) as LoaderMax;
					if (queueObj)
						if(atFront)
							queueObj.prepend(_loader);
						else
							queueObj.append(_loader);
					else 
						queueObj = new LoaderMax( { name: _queue, loaders:[_loader] } );
				} 
			}
			complete();
		}
		
		override public function toDetailString():String {
			return "loader=" + String(_loader) + ", vars=" + Utils.convertObjectToString(vars) + ", queue=" + String(_queue) + ", atFront=" + String(atFront); 
		}
	
	}

}