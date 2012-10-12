package com.platogo.flow.commands.loading {
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.commands.core.ResponseCommand;
	import com.platogo.flow.enums.ResponseType;
	import com.platogo.flow.utils.Utils;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.FileReference;
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public class FileReferenceBrowse extends ResponseCommand {
		private var _fileReference : FileReference;
		public var typeFilter : Array;
		
		public function FileReferenceBrowse(fileReference : FileReference) {
			_fileReference = fileReference;
		}
		
		public function ATypeFilter( typeFilter : Array) : FileReferenceBrowse {
			this.typeFilter = typeFilter;
			return this;
		}
		
		static public function create(fileReference : FileReference): FileReferenceBrowse{
			return new FileReferenceBrowse(fileReference);
		}
		
		override public function clone():Command {
			return new FileReferenceBrowse(_fileReference).SetAttributes(this);
		}
		
		override protected function execute():void {
			_fileReference.addEventListener( Event.CANCEL, onFileCancel );
			_fileReference.addEventListener( Event.SELECT, onFileSelect );
			_fileReference.addEventListener( Event.COMPLETE, onFileComplete );
			_fileReference.addEventListener( IOErrorEvent.IO_ERROR, onFileFailed );
			_fileReference.browse(typeFilter);
		}
		
		override protected function canceling():void {
			super.canceling();
			if (active) {
				_fileReference.cancel();
				removeFileEvents();
			}
		}
		
		private function removeFileEvents():void {
			_fileReference.removeEventListener( Event.CANCEL, onFileCancel );
			_fileReference.removeEventListener( Event.SELECT, onFileSelect );
			_fileReference.removeEventListener( Event.COMPLETE, onFileComplete );
			_fileReference.removeEventListener( IOErrorEvent.IO_ERROR, onFileFailed );
		}
		
		private function onFileCancel(e:Event):void {
			removeFileEvents();
			callResponse(ResponseType.CANCELED, this, _fileReference.data, e);
		}

		private function loadFile(e:Event = null) :void {
			_fileReference.load();
		}

		private function onFileComplete( e : Event ) : void {
			removeFileEvents();
			callResponse(ResponseType.COMPLETED, this, _fileReference.data, e);
		}
		
		private function onFileSelect( e : Event ) : void {
			callResponse(ResponseType.SELECTED, this, _fileReference.name, e, true, loadFile);
		}
		
		private function onFileFailed(e:Event):void {
			removeFileEvents();
			callResponse(ResponseType.FAILED, this, null, e);
		}
		
		override public function toDetailString():String {
			return "fileReference=" + String(_fileReference) + ", typeFilter=" + Utils.convertArrayToString(typeFilter); 
		}
	}
}