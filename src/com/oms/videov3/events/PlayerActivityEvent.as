package com.oms.videov3.events
{
	import flash.events.*;
	
	public class PlayerActivityEvent extends Event
	{
		public var value:Object = -1;
		
		public function PlayerActivityEvent(param1:String, param2:* = -1)
		{
			super(param1);
			this.value = param2;
			return;
		}// end function
		
	}
}