package com.platogo.flow.container 
{
	
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public interface IContainer {
		function push(...elements):uint;
		function pop():*;
		function shift():*;
		function unshift(...elements):uint;
		function indexOf(elements:*, from : uint = 0):int;
		function splice(startIndex : uint = 0, deleteCount:uint = 0, ...elements):IContainer;
		function get length():uint;
		function get rawContent():*;
		function set x (value : Number):void;
		function get x():Number;
		function set y (value : Number):void;
		function get y():Number;
	}
	
}