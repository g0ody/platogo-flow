package com.platogo.flow.commands.display  {
	import com.platogo.flow.commands.core.Command;
	import com.platogo.flow.utils.Utils;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public class GotoAndPlay extends Command{
		protected var _clip : MovieClip;
		protected var _frame : Object;
		public var scene : String ;
		
		public function GotoAndPlay( clip: MovieClip, frame : Object) {
			_clip = clip;
			_frame = frame;
		}
		
		public function AScene(scene : String) : GotoAndPlay {
			this.scene = scene;
			return this;
		}
		
		static public function create( clip: MovieClip, frame : Object): GotoAndPlay{
			return new GotoAndPlay( clip, frame);
		}
		
		override public function clone():Command 
		{
			return new GotoAndPlay( _clip, _frame).SetAttributes(this);
		}
		
		override protected function execute():void {
			if(_clip)
				_clip.gotoAndPlay(Utils.getReferenceData(_frame), scene);
			complete();
		}
		
		override public function toDetailString():String {
			return "clip=" + String((_clip != null)?_clip.name:_clip) + ", frame=" + String(_frame) + ", Scene=" + String(scene);
		}
		
	}

}