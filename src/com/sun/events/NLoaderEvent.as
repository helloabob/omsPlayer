package com.sun.events
{
	import flash.events.*;
	
	public class NLoaderEvent extends Event
	{
		public var value:Object;
		public static const LOAD_COMPLETE:String = "load_complete";
		public static const LOAD_PROGRESS:String = "load_progress";
		public static const LOAD_ERROR:String = "load_error";
		public static const HTTP_ERROR:String = "http_error";
		public static const LOAD_START:String = "load_start";
		
		public function NLoaderEvent(param1:String, param2:* = -1)
		{
			super(param1);
			this.value = param2;
			return;
		}// end function
		
		override public function toString() : String
		{
			return super.toString() + " value=" + this.value;
		}// end function
		
	}
}