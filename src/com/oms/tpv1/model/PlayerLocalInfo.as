package com.oms.tpv1.model
{
	//播放数据信息
	public class PlayerLocalInfo extends Object
	{
		public var volume:uint = 50;
		public var format:String = "auto";
		public var headtail:int = 1;
		public var guid:String = "";
		
		public function PlayerLocalInfo()
		{
			return;
		}// end function
		
		public function copy(param1:Object) : void
		{
			if (!param1)
			{
				return;
			}
			if (param1.volume != null && param1.volume != undefined && !isNaN(param1.volume * 1))
			{
				this.volume = param1.volume;
			}
			if (param1.format && param1.format != undefined)
			{
				this.format = param1.format;
			}
			if (param1.headtail != null && param1.headtail != undefined && !isNaN(param1.headtail * 1))
			{
				this.headtail = param1.headtail;
			}
			if (param1.guid && param1.guid != undefined)
			{
				this.guid = param1.guid;
			}
			return;
		}// end function
		
		public function toObject() : Object
		{
			var _loc_1:* = new Object();
			_loc_1.volume = this.volume;//声音
			_loc_1.format = this.format;//格式
			_loc_1.headtail = this.headtail;//切换信息
			_loc_1.guid = this.guid;//标识ID号
			return _loc_1;
		}// end function
	}
}