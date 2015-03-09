package com.sun.media.video
{
	import flash.events.*;
	
	public class SkinEvent extends Event
	{
		public var value:Object;
		public static const SKIN_COMPLETE:String = "skin_complete";
		public static const SKIN_ERROR:String = "skin_error";
		
		public function SkinEvent(param1:String, param2:* = -1)
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