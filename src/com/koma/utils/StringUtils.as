package com.koma.utils
{
	//字符串操作对象
	public class StringUtils extends Object
	{
		
		public function StringUtils()
		{
			return;
		}// end function
		
		public static function isString(param1:*) : Boolean
		{
			return param1 is String;
		}// end function
		
		public static function castString(param1:*) : String
		{
			return param1 as String;
		}// end function
		
		public static function trimLeft(param1:String) : String
		{
			var _loc_2:int = 0;
			var _loc_3:String = "";
			var _loc_4:int = 0;
			while (_loc_4 < param1.length)
			{
				
				_loc_3 = param1.charAt(_loc_4);
				if (_loc_3 != " ")
				{
					_loc_2 = _loc_4;
					break;
				}
				_loc_4++;
			}
			return param1.substr(_loc_2);
		}// end function
		
		public static function trimRight(param1:String) : String
		{
			var _loc_2:* = param1.length - 1;
			var _loc_3:String = "";
			var _loc_4:* = param1.length - 1;
			while (_loc_4 >= 0)
			{
				
				_loc_3 = param1.charAt(_loc_4);
				if (_loc_3 != " ")
				{
					_loc_2 = _loc_4;
					break;
				}
				_loc_4 = _loc_4 - 1;
			}
			return param1.substring(0, (_loc_2 + 1));
		}// end function
		
		public static function trim(param1:String) : String
		{
			return trimLeft(trimRight(param1));
		}// end function
		
		public static function replace(param1:String, param2:String, param3:String) : String
		{
			return param1.split(param2).join(param3);
		}// end function
		
	}
}