package com.oms.tpv1.model
{
	//跳转点用到的东西
	public class SeekPoint extends Object
	{
		private var _offset:uint = 0;
		private var _time:Number = 0;
		private var _id:uint = 0;
		
		public function SeekPoint()
		{
			return;
		}// end function
		
		public function get offset() : uint
		{
			return this._offset;
		}// end function
		
		public function set offset(param1:uint) : void
		{
			this._offset = param1;
			return;
		}// end function
		
		public function get time() : Number
		{
			return this._time;
		}// end function
		
		public function set time(param1:Number) : void
		{
			this._time = param1;
			return;
		}// end function
		
		public function get id() : uint
		{
			return this._id;
		}// end function
		
		public function set id(param1:uint) : void
		{
			this._id = param1;
			return;
		}// end function

	}
}