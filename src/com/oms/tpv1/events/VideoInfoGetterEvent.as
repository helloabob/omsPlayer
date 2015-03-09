package com.oms.tpv1.events
{
	import flash.events.*;
	//获取视频信息
	public class VideoInfoGetterEvent extends Event
	{
		public var value:Object = -1;
		public static const VIDEOINFO_SUCC:String = "videoinfo_succ";
		public static const VIDEOINFO_ERROR:String = "videoinfo_error";
		
		public function VideoInfoGetterEvent(param1:String, param2:* = -1)
		{
			super(param1);
			this.value = param2;
			return;
		}// end function
		
	}
}