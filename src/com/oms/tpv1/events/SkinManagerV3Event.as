package com.oms.tpv1.events
{
	import flash.events.*;
	
	public class SkinManagerV3Event extends Event
	{
		public var value:Object = -1;
		public static const SKIN_LOAD_COMPLETE:String = "skin_load_complete";
		public static const SKIN_LOAD_ERROR:String = "skin_load_error";
		public static const TIP_LINK_CLICK:String = "tip_link_click";
		public static const TIP_LINK_OVER:String = "tip_link_over";
		public static const TIP_LINK_OUT:String = "tip_link_out";
		
		public function SkinManagerV3Event(param1:String, param2:* = -1)
		{
			super(param1);
			this.value = param2;
			return;
		}// end function
		
	}
}