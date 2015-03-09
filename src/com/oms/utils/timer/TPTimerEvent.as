package com.oms.utils.timer
{
	import flash.events.*;
	//定时器事件
	public class TPTimerEvent extends Event
	{
		public var elapsed:Number;
		public static const END:String = "END";
		public static const TICK:String = "TICK";
		
		public function TPTimerEvent(param1:String, param2:* = -1):void
		{
			super(param1);
			this.elapsed = param2;
			return;
		}// end function
	}
}