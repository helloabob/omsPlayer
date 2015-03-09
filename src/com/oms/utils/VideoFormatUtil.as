package com.oms.utils
{
	//视频格式定义
	public class VideoFormatUtil extends Object
	{
		public static const NAME_SHD:String = "shd";
		public static const NAME_HD:String = "hd";
		public static const NAME_SD:String = "sd";
		public static const NAME_FLV:String = "flv";
		public static const NAME_MP4:String = "mp4";
		public static var arrayAllName:Array = new Array(NAME_FLV, NAME_MP4, NAME_SD, NAME_HD, NAME_SHD);
		public static var arrayHDName:Array = new Array(NAME_SD, NAME_HD, NAME_SHD);
		
		public function VideoFormatUtil()
		{
			return;
		}// end function
		
		public static function isFormatAllType(param1:String, param2:Boolean = true) : Boolean
		{
			var _loc_3:int = 0;
			while (_loc_3 < arrayAllName.length)
			{
				
				if (arrayAllName[_loc_3] == param1)
				{
					if (param2)
					{
						return true;
					}
					if (param1 == NAME_FLV || param1 == NAME_MP4)
					{
						return false;
					}
					return true;
				}
				_loc_3++;
			}
			return false;
		}// end function
		
		public static function getFileCHName(param1:String) : String
		{
			var _loc_2:String = "";
			switch(param1)
			{
				case NAME_SHD:
				{
					_loc_2 = "超清";
					break;
				}
				case NAME_HD:
				{
					_loc_2 = "高清";
					break;
				}
				case NAME_SD:
				{
					_loc_2 = "流畅";
					break;
				}
				default:
				{
					_loc_2 = "默认";
					break;
					break;
				}
			}
			return _loc_2;
		}// end function
		
		public static function sortFormat(param1:Array) : Array
		{
			var _loc_4:String = null;
			var _loc_5:int = 0;
			var _loc_2:* = new Array();
			var _loc_3:int = 0;
			while (_loc_3 < VideoFormatUtil.arrayHDName.length)
			{
				
				_loc_4 = VideoFormatUtil.arrayHDName[_loc_3];
				_loc_5 = 0;
				while (_loc_5 < param1.length)
				{
					
					if (_loc_4 == param1[_loc_5].name)
					{
						_loc_2.push(param1[_loc_5]);
						break;
					}
					_loc_5++;
				}
				_loc_3++;
			}
			return _loc_2;
		}// end function
		
		public static function getFormatIndex(param1:String) : int
		{
			var _loc_2:int = -1;
			var _loc_3:int = 0;
			while (_loc_3 < VideoFormatUtil.arrayHDName.length)
			{
				
				if (param1 == VideoFormatUtil.arrayHDName[_loc_3])
				{
					_loc_2 = _loc_3;
				}
				_loc_3++;
			}
			return _loc_2;
		}// end function
	}
}