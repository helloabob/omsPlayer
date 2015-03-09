package com.oms.tpv1.events
{
	import flash.events.*;
	
	public class LoadingSwfEvent extends Event
	{
		public var value:Object = -1;
		public static const LOADING_COMPLETE:String = "loading_complete";
		public static const LOADING_ERROR:String = "loading_error";
		
		public function LoadingSwfEvent(param1:String, param2:* = -1)
		{
			super(param1);
			this.value = param2;
			return;
		}// end function
		
	}
}