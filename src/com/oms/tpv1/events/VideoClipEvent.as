package com.oms.tpv1.events
{
	import flash.events.*;
	
	public class VideoClipEvent extends Event
	{
		public static const VIDEOCLIP_SUCC:String = "videoclip_succ";
		public static const VIDEOCLIP_ERROR:String = "videoclip_error";
		
		public function VideoClipEvent(param1:String, param2:* = -1)
		{
			super(param1);
			return;
		}// end function
	}
}