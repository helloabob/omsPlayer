package com.sun.utils
{
	import flash.text.*;
	
	public class TextTool extends Object
	{
		public function TextTool()
		{
			throw new Error("TextTool是静态类，不允许创建TextTool的实例");
		}// end function
		
		public static function singleLineTextCut(param1:TextField, param2:int = -1, param3:int = -1, param4:String = "…") : void
		{
			if (param1.wordWrap || param1.multiline)
			{
				var _loc_8:Boolean = false;
				param1.multiline = false;
				param1.wordWrap = _loc_8;
			}
			if (param1.maxScrollH == 0)
			{
				return;
			}
			var _loc_5:* = param1.getTextFormat(param2, param3);
			var _loc_6:Number = 0;
			var _loc_7:Number = -1;
			do
			{
				
				_loc_7 = param1.getCharIndexAtPoint(param1.width - _loc_6, param1.height / 2);
				_loc_6 = _loc_6 + 5;
			}while (_loc_7 == -1 && _loc_6 <= 20)
			if (_loc_7 != -1)
			{
				param1.text = param1.text.substr(0, (_loc_7 - 1)) + param4;
			}
			param1.setTextFormat(_loc_5, param2, param3);
			return;
		}// end function
		
		public static function multilineTextCut(param1:TextField, param2:int = -1, param3:int = -1, param4:String = "…") : void
		{
			if (!param1.multiline)
			{
				param1.multiline = true;
			}
			if (param1.maxScrollV < 2)
			{
				return;
			}
			var _loc_5:* = param1.getTextFormat(param2, param3);
			var _loc_6:* = param1.text;
			var _loc_7:* = param1.numLines - param1.maxScrollV;
			var _loc_8:String = "";
			var _loc_9:* = param1.getLineText(_loc_7);
			var _loc_10:uint = 0;
			while (_loc_10 < _loc_7)
			{
				
				_loc_8 = _loc_8 + (param1.getLineText(_loc_10) + "\n");
				_loc_10 = _loc_10 + 1;
			}
			var _loc_11:* = new TextField();
			new TextField().width = Math.floor(param1.width) - 5;
			_loc_11.text = _loc_9 + param4;
			_loc_11.setTextFormat(_loc_5);
			singleLineTextCut(_loc_11, -1, -1, param4);
			_loc_9 = _loc_11.text;
			param1.text = _loc_8 + _loc_9;
			param1.setTextFormat(_loc_5, param2, param3);
			return;
		}// end function
		
		public static function lTrim(param1:String) : String
		{
			while (param1.length > 0)
			{
				
				if (param1.charAt(0) == " ")
				{
					param1 = param1.substr(1);
					continue;
				}
				return param1;
			}
			return param1;
		}// end function
		
		public static function rTrim(param1:String) : String
		{
			while (param1.length > 0)
			{
				
				if (param1.charAt((param1.length - 1)) == " ")
				{
					param1 = param1.substr(0, (param1.length - 1));
					continue;
				}
				return param1;
			}
			return param1;
		}// end function
		
		public static function getRealLen(param1:String, param2:Boolean = false) : uint
		{
			var _loc_4:String = null;
			if (param1.length == 0)
			{
				return 0;
			}
			var _loc_3:* = "1111";
			if (!param2)
			{
				return param1.replace(_loc_3, "**").length;
			}
			//var _loc_3:* = "1111";
			_loc_4 = param1.replace(_loc_3, "");
			return param1.length - _loc_4.length + encodeURI(_loc_4).length / 3;
		}// end function
		
		public static function charsCut(param1:String, param2:uint) : String
		{
			if (param2 < 2)
			{
				return param1;
			}
			var _loc_3:* = getRealLen(param1);
			while (_loc_3 > param2)
			{
				
				param1 = param1.substr(0, (param1.length - 1));
				_loc_3 = getRealLen(param1);
			}
			return param1;
		}// end function
	}
}