package com.sun.utils
{
	import flash.text.*;
	
	public class Tool extends Object
	{
		public function Tool()
		{
			return;
		}// end function
		//格式化尺寸的操作函数
		public static function getViewSize(param1:uint, param2:uint, param3:uint, param4:uint, param5:int) : Object
		{
			var _loc_6:Number = NaN;
			var _loc_7:Number = NaN;
			var _loc_10:Number = NaN;
			var _loc_8:* = param3;
			var _loc_9:* = param4;
			if (param5 == 2 && (param3 > param1 || param4 > param2))
			{
				param5 = 0;
			}
			if (param5 == 5 && (param3 * 2 > param1 || param4 * 2 > param2))
			{
				param5 = 0;
			}
			var _loc_11:* = param1 / param2;
			switch(param5)
			{
				case 0:
				{
					_loc_10 = _loc_8 / _loc_9;
					break;
				}
				case 1:
				{
					_loc_6 = param1;
					_loc_7 = param2;
					break;
				}
				case 2:
				{
					_loc_6 = _loc_8;
					_loc_7 = _loc_9;
					break;
				}
				case 3:
				{
					_loc_10 = 16 / 9;
					break;
				}
				case 4:
				{
					_loc_10 = 4 / 3;
					break;
				}
				case 5:
				{
					_loc_6 = _loc_8 * 2;
					_loc_7 = _loc_9 * 2;
					break;
				}
				default:
				{
					break;
				}
			}
			if (param5 == 1 || param5 == 2 || param5 == 5)
			{
				return {width:_loc_6, height:_loc_7};
			}
			if (_loc_10 > _loc_11)
			{
				_loc_6 = param1;
				_loc_7 = param1 / _loc_10;
			}
			else
			{
				_loc_7 = param2;
				_loc_6 = param2 * _loc_10;
			}
			return {width:_loc_6, height:_loc_7};
		}// end function
		
		public static function timeFormat(param1:uint = 0, param2:String = "00:00:00") : String
		{
			var _loc_3:* = Math.floor(param1 / (60 * 1000));
			var _loc_4:* = Math.round((param1 - _loc_3 * 60 * 1000) / 1000);
			if (Math.round((param1 - _loc_3 * 60 * 1000) / 1000) == 60)
			{
				_loc_4 = 0;
				_loc_3 = _loc_3 + 1;
			}
			if (param2 == "00:00")
			{
				return (_loc_3 < 10 ? ("0" + String(_loc_3) + ":") : (String(_loc_3) + ":")) + (_loc_4 < 10 ? ("0" + String(_loc_4)) : (String(_loc_4)));
			}
			var _loc_5:* = Math.floor(_loc_3 / 60);
			_loc_3 = _loc_3 - _loc_5 * 60;
			if (_loc_3 == 60)
			{
				_loc_3 = 0;
				_loc_5 = _loc_5 + 1;
			}
			return (_loc_5 < 10 ? ("0" + String(_loc_5) + ":") : (String(_loc_5) + ":")) + (_loc_3 < 10 ? ("0" + String(_loc_3) + ":") : (String(_loc_3) + ":")) + (_loc_4 < 10 ? ("0" + String(_loc_4)) : (String(_loc_4)));
		}// end function
		
		public static function fullTimeToDate(param1:String) : Date
		{
			var _loc_3:Date = null;
			var _loc_4:Array = null;
			var _loc_5:Array = null;
			var _loc_2:* = param1.split(" ");
			if (_loc_2.length == 2)
			{
				_loc_3 = new Date();
				_loc_4 = _loc_2[0].split("-");
				_loc_5 = _loc_2[1].split(":");
				if (_loc_4.length == 3 && _loc_5.length == 3)
				{
					_loc_3.setFullYear(_loc_4[0], (_loc_4[1] - 1), _loc_4[2]);
					_loc_3.setHours(_loc_5[0], _loc_5[1], _loc_5[2]);
					return _loc_3;
				}
			}
			return null;
		}// end function
		
		public static function entityReplace(param1:String) : String
		{
			var str:* = param1;
			try
			{
				return str.replace("/&#38;?/g", "&amp;").replace("&amp;/g", "&").replace("&#(\d+);?/g"," ").replace("&lt;/g", "<").replace("/&gt;", ">").replace("&quot;/g", "\"").replace("&nbsp;/g", " ").replace("&#13;/g", "\n").replace("/(&#10;)|(&#x\w*;)/g", "").replace("/&amp;/g", "&");
			}
			catch (e:Error)
			{
			}
			return str;
		}// end function
		
		public static function getHostFromURL(param1:String) : String
		{
			return param1.split("/")[2];
		}// end function
		
		public static function getStrUnicode(param1:String) : String
		{
			var _loc_5:String = null;
			var _loc_2:String = "";
			var _loc_3:* = param1.length;
			var _loc_4:uint = 0;
			while (_loc_4 < _loc_3)
			{
				
				_loc_5 = param1.charCodeAt(_loc_4).toString(16);
				_loc_2 = _loc_2 + _loc_5;
				_loc_4 = _loc_4 + 1;
			}
			return _loc_2.toUpperCase();
		}// end function
		
		public static function cutSinglelineTextFieldsingleLineTextCut(param1:TextField, param2:int = -1, param3:int = -1, param4:String = "...") : void
		{
			TextTool.singleLineTextCut(param1, param2, param3, param4);
			return;
		}// end function
		
		public static function cutMultiLineTextField(param1:TextField, param2:int = -1, param3:int = -1, param4:String = "...") : void
		{
			TextTool.multilineTextCut(param1, param2, param3, param4);
			return;
		}// end function
		
		public static function getNodeAttributes(param1:XML) : Object
		{
			var _loc_4:uint = 0;
			var _loc_6:String = null;
			var _loc_2:Object = {};
			var _loc_3:* = param1.attributes();
			var _loc_5:* = _loc_3.length();
			_loc_4 = 0;
			while (_loc_4 < _loc_5)
			{
				
				_loc_6 = _loc_3[_loc_4].name.toString();
				_loc_2[_loc_6] = _loc_3[_loc_4];
				_loc_4 = _loc_4 + 1;
			}
			return _loc_2;
		}// end function
		
		public static function arrayInsert(param1:Array, param2:uint, param3:Array) : void
		{
			if (param3.length == 0)
			{
				return;
			}
			if (param2 > param1.length)
			{
				param2 = param1.length;
			}
			var _loc_4:* = param3.length;
			var _loc_5:uint = 0;
			while (_loc_5 < _loc_4)
			{
				
				param3[_loc_5].type = "user";
				param1.splice(param2 + _loc_5, 0, param3[_loc_5]);
				_loc_5 = _loc_5 + 1;
			}
			return;
		}// end function
		
		public static function objectToString(param1:Object) : String
		{
			var _loc_3:String = null;
			var _loc_2:String = "{";
			for (_loc_3 in param1)
			{
				
				if (param1[_loc_3].toString() == "[object Object]")
				{
					_loc_2 = _loc_2 + (_loc_3 + ":" + objectToString(param1[_loc_3]) + ",");
					continue;
				}
				if (param1[_loc_3] is Array)
				{
					_loc_2 = _loc_2 + (_loc_3 + ":" + arrayToString(param1[_loc_3]) + ",");
					continue;
				}
				_loc_2 = _loc_2 + (_loc_3 + ":" + param1[_loc_3] + ",");
			}
			_loc_2 = _loc_2.substr(0, (_loc_2.length - 1));
			_loc_2 = _loc_2 + "}";
			return _loc_2;
		}// end function
		
		public static function arrayToString(param1:Array) : String
		{
			var _loc_2:* = param1.length;
			var _loc_3:String = "[";
			var _loc_4:uint = 0;
			while (_loc_4 < _loc_2)
			{
				
				if (param1[_loc_4].toString() == "[object Object]")
				{
					_loc_3 = _loc_3 + (objectToString(param1[_loc_4]) + ",");
				}
				else if (param1[_loc_4] is Array)
				{
					_loc_3 = _loc_3 + (arrayToString(param1[_loc_4]) + ",");
				}
				else
				{
					_loc_3 = _loc_3 + (param1[_loc_4] + ",");
				}
				_loc_4 = _loc_4 + 1;
			}
			_loc_3 = _loc_3.substr(0, (_loc_3.length - 1));
			_loc_3 = _loc_3 + "]";
			return _loc_3;
		}// end function
		
		public static function rgbToColor(param1:uint, param2:uint, param3:uint) : uint
		{
			if (param1 > 255)
			{
				param1 = 255;
			}
			if (param2 > 255)
			{
				param2 = 255;
			}
			if (param3 > 255)
			{
				param3 = 255;
			}
			return param1 << 16 | param2 << 8 | param3;
		}// end function
		
		public static function argbToColor(param1:uint, param2:uint, param3:uint, param4:uint) : uint
		{
			if (param1 > 255)
			{
				param1 = 255;
			}
			if (param2 > 255)
			{
				param2 = 255;
			}
			if (param3 > 255)
			{
				param3 = 255;
			}
			if (param4 > 255)
			{
				param4 = 255;
			}
			return param1 << 24 | param2 << 16 | param3 << 8 | param4;
		}// end function
		
		public static function addzero(param1:int, param2:int) : String
		{
			var _loc_3:* = param1.toString();
			var _loc_4:* = param2 - _loc_3.length;
			var _loc_5:String = "";
			var _loc_6:int = 0;
			if (_loc_4 <= 0)
			{
				return _loc_3;
			}
			while (_loc_6 < _loc_4)
			{
				
				_loc_5 = _loc_5 + "0";
				_loc_6++;
			}
			return _loc_5 + _loc_3;
		}// end function
	}
}