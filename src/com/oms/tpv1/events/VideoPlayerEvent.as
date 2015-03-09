package com.oms.tpv1.events
{
	import flash.events.*;
	//播放视频事件
	public class VideoPlayerEvent extends Event
	{
		public var value:Object = -1;
		public static var SETUP_COMPLETE:String = "setup_complete";
		public static var SETUP_ERROR:String = "setup_error";
		public static var PLAY_UNRECOVERY_ERROR:String = "play_unrecovery_error";
		public static var PLAY_NOMAL_ERROR:String = "play_nomal_error";
		public static var PLAY_STATUS_CHANGED:String = "status_changed";
		
		public function VideoPlayerEvent(param1:String, param2:* = -1)
		{
			super(param1);
			this.value = param2;
			return;
		}// end function
		
	}
}