package com.oms.tpv1.model
{
	//视频格式信息
	public class VideoFormat extends Object
	{
		public var name:String;
		public var id:String;
		public var br:Number;
		public var sel:int;
		public var index:int = 0;
		public var st:int = 1;
		
		public function VideoFormat(param1:String = "flv", param2:String = "1", param3:Number = 128, param4:int = 1, param5:int = 0, param6:int = 0)
		{
			this.name = param1;
			this.id = param2;
			this.br = param3;
			this.sel = param4;
			this.index = param5;
			this.st = param6;
			return;
		}// end function
	}
}