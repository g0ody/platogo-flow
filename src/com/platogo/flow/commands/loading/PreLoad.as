package com.platogo.flow.commands.loading 
{
	import com.platogo.flow.commands.core.CancelableCommand;
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.utils.Utils;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public class PreLoad extends CancelableCommand
	{
		private var _root : DisplayObject;
		
		public var classname : String = null;
		public var stageIdx : int = -1; 

		public function PreLoad(root: DisplayObject) {
			_root = root;
		}
		
		public function AClassName( classname : String ) : PreLoad {
			this.classname = classname;
			return this;
		}
		
		public function AStageIdx( stageIdx : int ) : PreLoad {
			this.stageIdx = stageIdx;
			return this;
		}
		
		static public function create(root: DisplayObject): PreLoad{
			return new PreLoad(root);
		}
		
		override public function clone():Command 
		{
			return new PreLoad(_root).SetAttributes(this);
		}
		
		override protected function execute():void {
			_root.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			_root.loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorListener);
		}
		
		override protected function canceling():void {
			if (active) {
				_root.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		private function onEnterFrame(e:Event):void {
			var percent : Number = _root.loaderInfo.bytesLoaded / _root.loaderInfo.bytesTotal;
			if (percent == 1.0) {
				_root.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				_root.loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorListener);
				if (classname) {
					var mainClass:Class = Utils.getClass(classname);
					if(mainClass){
						var app:DisplayObject = new mainClass() as DisplayObject;
						if( stageIdx <= -1)
							_root.stage.addChild(app as DisplayObject);
						else
							_root.stage.addChildAt(app as DisplayObject, stageIdx);
					} else {
						cancel();
						return
					}
				}
				complete();
			}
		}
		
		private function ioErrorListener(event : IOErrorEvent) : void {
			_root.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			_root.loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorListener);	
			complete();
		}
		
		override public function toDetailString():String {
			return "root=" + String((_root != null)?_root.name:_root) + ", classname=" + String(classname)+ ", stageIdx=" + String(stageIdx); 
		}
		
	}

}