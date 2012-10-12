package com.platogo.flow.commands.display 
{
	import com.platogo.flow.commands.core.CancelableCommand;
	import com.platogo.flow.commands.core.Command;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public class PlayFromTo extends CancelableCommand {
		protected var _clip : MovieClip;
		protected var _frameFrom : Object;
		protected var _frameTo : Object;
		
		
		public function PlayFromTo(clip:MovieClip, frameFrom : Object, frameTo : Object) {
			this._clip = clip;
			this._frameFrom = frameFrom;
			this._frameTo = frameTo;
		}
		
		static public function create(clip:MovieClip, frameFrom : Object, frameTo : Object): PlayFromTo{
			return new PlayFromTo(clip, frameFrom, frameTo);
		}
		
		override public function clone():Command 
		{
			return new PlayFromTo(_clip, _frameFrom, _frameTo).SetAttributes(this);
		}
		
		override protected function execute():void {
			if (_clip) {
				_clip.addFrameScript(getFrame(_clip, _frameTo) - 1, finish );
				_clip.gotoAndPlay(_frameFrom);
			}
			super.execute();
		}
		
		override protected function canceling():void {
			if (active) {
				finish();
			}
		}
		
		protected function finish():void {
			if (_clip) {
				_clip.stop();
				_clip.addFrameScript(getFrame(_clip, _frameTo) - 1, null );		
			}
			complete();
		}

		private function getFrame(clip: MovieClip, frame : Object):int {
			if (frame is String) {
				var lbls:Array = clip.currentLabels;
				for (var i:uint = 0; i < lbls.length; i++)
					if (lbls[i].name == (frame as String))
						return lbls[i].frame;
						
				return -1;
			}
			else
				return frame as int;
		}
		
		override public function toDetailString():String {
			return "clip=" + String((_clip != null)?_clip.name:_clip) + ", frameFrom=" + String(_frameFrom) + ", frameTo=" + String(_frameTo);
		}
		
	}

}