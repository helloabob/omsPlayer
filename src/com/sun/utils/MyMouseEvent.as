package com.sun.utils
{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	
	public class MyMouseEvent extends EventDispatcher
	{
		private var _listener:DisplayObject;
		private var myTimeout:uint;
		private var sign:Boolean = false;
		public static const DELAY_TIME:uint = 250;
		public static const CLICK:String = "click";
		public static const DOUBLE_CLICK:String = "doubleClick";
		
		public function MyMouseEvent(param1:DisplayObject)
		{
			this._listener = param1;
			this.init();
			return;
		}// end function
		
		public function get listener() : DisplayObject
		{
			return this._listener;
		}// end function
		
		private function init() : void
		{
			this._listener.addEventListener(MouseEvent.CLICK, this.dbClickHandle);
			return;
		}// end function
		
		private function dbClickHandle(event:MouseEvent) : void
		{
			if (!this.sign)
			{
				this.sign = true;
				this.myTimeout = setTimeout(this.clickHandle, DELAY_TIME);
			}
			else
			{
				clearTimeout(this.myTimeout);
				this.sign = false;
				dispatchEvent(new Event(MyMouseEvent.DOUBLE_CLICK));
			}
			return;
		}// end function
		
		private function clickHandle() : void
		{
			this.sign = false;
			dispatchEvent(new Event(MyMouseEvent.CLICK));
			return;
		}// end function
	}
}