package com.oms.tpv1.model
{
	public class PlayerLocalSpeed extends Object
	{
		public var arraySpeed:Array;
		
		public function PlayerLocalSpeed()
		{
			this.arraySpeed = new Array();
			return;
		}// end function
		
		public function copy(param1:Object) : void
		{
			if (!param1)
			{
				return;
			}
			if (param1.arraySpeed != null && param1.arraySpeed != undefined && param1.arraySpeed is Array)
			{
				this.arraySpeed = param1.arraySpeed;
			}
			return;
		}// end function
		
		public function toObject() : Object
		{
			var _loc_1:* = new Object();
			_loc_1.arraySpeed = this.arraySpeed;
			return _loc_1;
		}// end function
		
	}
}