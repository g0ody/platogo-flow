package com.platogo.flow.commands.display  {
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.utils.Utils;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public class GotoAndStop extends GotoAndPlay{
		public function GotoAndStop(clip: MovieClip, frame : Object) {
			super(clip, frame);
		}
		
		static public function create(clip: MovieClip, frame : Object): GotoAndStop{
			return new GotoAndStop(clip, frame);
		}
		
		override public function clone():Command 
		{
			return new GotoAndStop(_clip, _frame).SetAttributes(this);
		}
		
		override protected function execute():void {
			if(_clip)
				_clip.gotoAndStop(Utils.getReferenceData(_frame), scene);
			complete();
		}
		
		override public function toDetailString():String {
			return "clip=" + String((_clip != null)?_clip.name:_clip) + ", frame=" + String(_frame) + ", Scene=" + String(scene);
		}
		
	}

}