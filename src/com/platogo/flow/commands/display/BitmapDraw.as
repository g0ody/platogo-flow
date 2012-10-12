package com.platogo.flow.commands.display 
{
	import com.platogo.flow.commands.core.Command;
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public class BitmapDraw extends Command {
		protected var _target : BitmapData;
		protected var _source : IBitmapDrawable;
		
		public var matrix : Matrix = null;
		public var colorTransform : ColorTransform = null;
		public var blendMode : String = null;
		public var clipRect : Rectangle = null;
		public var smoothing : Boolean = false;
		
		public function BitmapDraw(target:BitmapData, source:IBitmapDrawable) {
			_target = target;
			_source = source;
		}
		
		public function ATransform( matrix:Matrix) : BitmapDraw {
			this.matrix = matrix;
			return this;
		}
		
		public function AColor( colorTransform:ColorTransform) : BitmapDraw {
			this.colorTransform = colorTransform;
			return this;
		}
		
		public function ABlendMode(  blendMode: String) : BitmapDraw {
			this.blendMode = blendMode;
			return this;
		}
		
		public function AClipRect(  clipRect : Rectangle ) : BitmapDraw {
			this.clipRect = clipRect;
			return this;
		}
		
		public function ASmoothing(  smoothing : Boolean ) : BitmapDraw {
			this.smoothing = smoothing;
			return this;
		}
		
		static public function create(target:BitmapData, source:IBitmapDrawable): BitmapDraw{
			return new BitmapDraw(target, source);
		}
		
		override protected function execute():void {
			if (_target && _source)
				_target.draw(_source, matrix, colorTransform, blendMode, clipRect, smoothing);
			complete();
		}
		
		override public function clone():Command 
		{
			return new BitmapDraw(_target, _source).SetAttributes(this);
		}
		
		override public function toDetailString():String {
			return "target=" + String(_target) + ", source=" + String(_source) + ", matrix=" + String(matrix) + ", colorTransform=" + String(colorTransform) + ", blendMode=" + String(blendMode)+ ", clipRect=" + String(clipRect)+ ", smoothing=" + String(smoothing); 
		}
		
	}

}