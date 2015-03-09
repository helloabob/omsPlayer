package com.oms.tpv1.model
{
	//播放时间
	public class PlayTime extends Object
	{
		public var starttime:Number = 0;
		public var endtime:Number = 0;
		public var starttype:int = 0;
		public var endtype:int = 0;
		public var headstarttime:Number = 0;
		public var attstarttime:Number = 0;
		public static const TYPE_HISTORY:int = 1;
		public static const TYPE_SHARE_START:int = 2;
		public static const TYPE_SHARE_END:int = 3;
		public static const TYPE_ATTRACTION_START:int = 4;
		public static const TYPE_ATTRACTION_END:int = 5;
		public static const TYPE_HEAD:int = 6;
		public static const TYPE_TAIL:int = 7;
		public static const TYPE_NONE:int = 0;
		
		public function PlayTime()
		{
			return;
		}// end function
	}
}