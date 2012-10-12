package com.platogo.flow.container {
	import com.platogo.flow.container.IContainer;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public class DisplayContainer implements IContainer {
		private var _content: Sprite;
	
		public function DisplayContainer() {
			_content = new Sprite();
			_content.mouseEnabled = false;
		}
		
		/* INTERFACE com.platogo.flow.container.IContainer */
		
		public function push(...elements):uint {
			for each(var element : * in elements)
				if (element is DisplayObject)
					_content.addChild(element as DisplayObject);
				else if ( element is IContainer && (element as IContainer).rawContent is DisplayObject)
					_content.addChild((element as IContainer).rawContent as DisplayObject);
				else
					throw new Error("Element is not of the type DisplayObject");
					
			return _content.numChildren;
		}
		
		public function pop():*{
			if(length > 0)
				return _content.removeChildAt(length -1)
			else
				return null;
		}
		
		public function shift():*{
			if(length > 0)
				return _content.removeChildAt(0);
			else
				return null;
		}
		
		public function unshift(...elements):uint{
			for each(var element : * in elements)
				if (element is DisplayObject)
					_content.addChildAt(element as DisplayObject, 0);
				else if ( element is IContainer && (element as IContainer).rawContent is DisplayObject)
					_content.addChildAt((element as IContainer).rawContent as DisplayObject, 0);
				else
					throw new Error("Element is not of the type DisplayObject");
					
			return _content.numChildren;
		}
		
		public function indexOf(element:*, from:uint = 0):int{
			if (element is DisplayObject && _content.contains(element))
				return _content.getChildIndex(element as DisplayObject);
			else if ( element is IContainer && (element as IContainer).rawContent is DisplayObject && _content.contains((element as IContainer).rawContent as DisplayObject))
				return _content.getChildIndex((element as IContainer).rawContent as DisplayObject);
			else
				return -1;
		}
		
		public function splice(startIndex : uint = 0, deleteCount:uint = 0, ...elements):IContainer {
			var removed : DisplayContainer = new DisplayContainer();
			for ( var i : int = deleteCount; i > 0; i--)
				if(startIndex < length)
					removed.push(_content.removeChildAt(startIndex))
			
			elements.reverse();
			for each(var element : * in elements)
				if (element is DisplayObject)
					_content.addChildAt(element as DisplayObject, startIndex);
				else if ( element is IContainer && (element as IContainer).rawContent is DisplayObject)
					_content.addChildAt((element as IContainer).rawContent as DisplayObject, startIndex);
				else
					throw new Error("Element is not of the type DisplayObject");
					
			return removed;
		}
		
		public function get length():uint{
			return _content.numChildren;
		}
		
		public function get rawContent():*{
			return _content;
		}
		
		public function set x (value : Number):void {
			_content.x = value;
		}
		
		public function get x():Number {
			return _content.x;
		}
		
		public function set y (value : Number):void {
			_content.y = value;
		}
		
		public function get y():Number {
			return _content.y;
		}
		
		
	}

}