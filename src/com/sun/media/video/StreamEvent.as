package com.sun.media.video
{
	import flash.events.*;
	
	public class StreamEvent extends Event
	{
		public var value:Object;
		public static const STREAM_READY:String = "stream_ready";
		public static const STREAM_START_PLAY:String = "stream_start_play";
		public static const STREAM_EMPTY:String = "stream_empty";
		public static const STREAM_FULL:String = "stream_full";
		public static const STREAM_STOP:String = "stream_stop";
		public static const STREAM_ERROR:String = "stream_error";
		public static const STREAM_EMPTY_AFTER_STOP:String = "stream_empty_after_stop";
		public static const STREAM_404:String = "stream_404";
		public static const STREAM_NOTIFY:String = "stream_notify";
		public static const STREAM_INVALIDTIME:String = "stream_invalidTime";
		public static const STREAM_STATUS:String = "stream_status";
		public static const STREAM_MD:String = "stream_metaData";
		public static const STREAM_NC_ERROR:String = "stream_nc_error";
		public static const STREAM_NC_CLOSED:String = "stream_nc_closed";
		public static const STREAM_CORE_INITED:String = "stream_core_inited";
		
		public function StreamEvent(param1:String, param2:* = -1)
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