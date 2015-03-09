package com.oms.tpv1.events
{
	import flash.events.*;
	//播放器事件
	public class OmsPlayerEvent extends Event
	{
		public var value:Object = -1;
		public static const INIT_COMPLETE:String = "init_complete";
		
		public static const OMSID_OK:String = "ok";
		
		public static const INIT_ERROR:String = "init_error";
		public static const PLAY_STARTPLAY:String = "play_startplay";
		public static const PLAY_STARTLOAD:String = "play_startload";
		public static const PLAY_STARTREADY:String = "play_startready";
		public static const PLAY_STOP:String = "play_stop";
		public static const PLAY_CHANGE:String = "play_change";
		public static const PLAY_ATTSTOP:String = "play_attstop";
		public static const PLAY_PAUSE:String = "play_pause";
		public static const PLAY_SEEKSTOP:String = "play_seek";
		
		public static const PLAY_SEEKSTART:String = "play_seekstart";
		
		
		public static const PLAY_ERROR:String = "play_error";
		public static const CREATE_EV:String = "create_ev";
		public static const NEXT_CLICK:String = "nextbtn_click";
		
		public function OmsPlayerEvent(param1:String, param2:* = -1)
		{
			super(param1);
			this.value = param2;
			return;
		}// end function
		
	}	
}