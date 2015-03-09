package com.oms.tpv1.events
{
	import flash.events.*;
	
	public class FlvPlayModeV3Event extends Event
	{
		public var value:Object = -1;
		public static const STATUS_CHANGE:String = "status_change";
		
		public function FlvPlayModeV3Event(param1:String, param2:* = -1)
		{
			super(param1);
			this.value = param2;
			return;
		}// end function
		
	}
}