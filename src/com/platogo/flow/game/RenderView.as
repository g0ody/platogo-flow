package com.platogo.flow.game{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public class RenderView extends BaseView {
		public var sortRenderNames : * = null;
		public var sortRenderOptions : * = null;
		
		private var _objectsRender : Array;
		
		private var _buffer : Bitmap;

		public function RenderView(width : Number, height : Number, transparent: Boolean = true, fillcolor : uint = 0x000000, autoInit : Boolean = true) {
			super(autoInit);
			_buffer = new Bitmap(new BitmapData(width, height, transparent, fillcolor), "auto", true);
			_objectsRender = new Array();
			addChild(_buffer);
		}
		
		override internal function onAdded(e:Event = null):void 
		{
			super.onAdded(e);
			addEventListener(Event.ENTER_FRAME, onUpdate);
		}
		
		override internal function onRemoved(e:Event):void 
		{
			removeEventListener(Event.ENTER_FRAME, onUpdate);
			super.onRemoved(e);
		}
		
		internal function onUpdate(e:Event):void {
			Render();
		}
		
		public function Render():void 
		{
			if (visible) 
			{
				if(sortRenderNames != null)
					_objectsRender.sortOn(sortRenderNames, sortRenderOptions);
					
				for each(var renderObject : IRenderObject in _objectsRender) 
					if(renderObject.visible)
						renderObject.render(_buffer.bitmapData);
			}
		}
		
		override public function add(element:IGameObject):IGameObject 
		{
			if (element is IRenderObject  && _objectsRender.indexOf(element) == -1)
				_objectsRender.push(element);
				
			return super.add(element);
		}
		
		override public function remove(element:IGameObject):IGameObject 
		{
			var idx : int = _objectsRender.indexOf(element) ;
			if (idx != -1)
				_objectsRender.splice(idx, 1);
				
			return super.remove(element);
		}
		
		public function get objectsRender():Array { return _objectsRender.concat(); }
	}

}