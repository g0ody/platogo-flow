package com.platogo.flow.game{
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.events.EventDispatcher;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public class InteractionObject extends EventDispatcher implements IEventObject, IRenderObject{
		private var _asset: IBitmapDrawable;
		private var _transform : Matrix;
		private var _color : ColorTransform;
		private var _hitarea : Rectangle;
		
		private var _zIndex : uint = 0;
		private var _visible : Boolean = true;

		public function InteractionObject(asset : IBitmapDrawable, hitarea : Rectangle = null) {
			_asset = asset;
			_transform = new Matrix();
			_color = new ColorTransform();
			if (hitarea)
				_hitarea = hitarea;
			else if( asset["height"]!= null &&  asset["width"]!= null)
				_hitarea = new Rectangle(asset["x"], asset["y"], asset["width"], asset["height"]);
			else
				_hitarea = new Rectangle();
		}
		
		public function render(target : BitmapData):void {
			target.draw(_asset, _transform, _color , null, null, true);
		}

		public function get hitarea():Rectangle { return new Rectangle(_hitarea.x + x, _hitarea.y + y, _hitarea.width, _hitarea.height); }
		public function get x():Number { return _transform.tx; }
		public function set x(value:Number):void { _transform.tx = value; }
		
		public function get y():Number { return _transform.ty; }
		public function set y(value:Number):void { _transform.ty = value; }
		
		public function get scaleX():Number { return _transform.a; }
		public function set scaleX(value:Number):void { _transform.a = value; }	
		
		public function get scaleY():Number { return _transform.d; }
		public function set scaleY(value:Number):void { _transform.d = value; }
		
		public function get asset():IBitmapDrawable { return _asset; }
		public function set asset(value:IBitmapDrawable) :void { _asset = value; }
		
		public function get zIndex():uint { return _zIndex; }
		public function set zIndex(value:uint):void { _zIndex = value; }
		
		public function get alpha():Number { return _color.alphaMultiplier; }
		public function set alpha(value:Number):void {_color.alphaMultiplier = value;}
		
		public function get visible():Boolean { return _visible; }
		public function set visible(value:Boolean):void {_visible = value;}
	}

}