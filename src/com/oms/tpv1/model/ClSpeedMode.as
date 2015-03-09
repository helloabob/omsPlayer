package com.oms.tpv1.model
{
	//速度模块
	public class ClSpeedMode extends Object
	{
		public var clspeed:Number = 0;
		public var time:uint = 0;
		public var duration:Number = 0;
		
		public function ClSpeedMode(param1:Number = 0, param2:uint = 0, param3:Number = 0)
		{
			this.clspeed = param1;
			this.time = param2;
			this.duration = param3;
			return;
		}// end function
		
		public function getTotalBtyes() : Number
		{
			return this.clspeed * this.duration;
		}// end function

	}
}