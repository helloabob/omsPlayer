package com.sun.utils
{
	import flash.events.*;
	import flash.net.*;

	public class AS3Debugger extends Object
	{
		private static var conn:LocalConnection;
		public static var identity:String = "^-^无名氏^-^";
		public static var OmitTrace:Boolean = true;
		
		
		
		
		public function AS3Debugger()
		{
			throw new Error("AS3Debugger 为静态类，不允许实例化");
			
			
		}// end function
		
		
		public static function Trace(param1:*, param2:String = "") : void
		{
			if (!AS3Debugger.OmitTrace)
			{
				return;
			}
			if (param2 == "")
			{
				param2 = AS3Debugger.identity;
			}
			if (conn == null)
			{
				conn = new LocalConnection();
				conn.addEventListener(StatusEvent.STATUS, onStatus);
			}
			if (param1.toString() == "[object Object]")
			{
				param1 = objectToString(param1);
			}
			else if (param1 is Array)
			{
				param1 = arrayToString(param1);
			}
			else if (param1 is XML)
			{
				param1 = param1.toXMLString();
			}
			else
			{
				param1 = param1.toString();
			}
			param1 = htmlFormat(param1);
			param1 = "[" + getTime() + "]:" + param1;
			try
			{
				conn.send("_debugConnection", "transMsg", param1, param2);
			}
			catch (e:Error)
			{
			}
			return;
		}// end function
		
		private static function htmlFormat(param1:String) : String
		{
			param1 = param1.replace(/\&""\&/g, "&amp;");
			param1 = param1.replace(/\<""\</g, "&lt;");
			param1 = param1.replace(/\>""\>/g, "&gt;");
			param1 = param1.replace(/\\""""\"/g, "&quot;");
			param1 = param1.replace(/\\''""\'/g, "&apos;");
			return param1;
		}// end function
		
		private static function getTime() : String
		{
			var _loc_1:* = new Date();
			return getFormatTime(_loc_1.getHours()) + ":" + getFormatTime(_loc_1.getMinutes()) + ":" + getFormatTime(_loc_1.getSeconds()) + "." + _loc_1.getMilliseconds();
		}// end function
		
		private static function getFormatTime(param1:uint) : String
		{
			return param1 < 10 ? ("0" + param1) : ("" + param1);
		}// end function
		
		private static function onStatus(event:StatusEvent) : void
		{
			switch(event.level)
			{
				case "status":
				{
					break;
				}
				case "error":
				{
					break;
				}
				default:
				{
					break;
				}
			}
			return;
		}// end function
		
		private static function objectToString(param1:Object) : String
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
		
		private static function arrayToString(param1:Array) : String
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

	}
}