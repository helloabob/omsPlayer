package com.koma.utils
{
	public class XMLUtils extends Object
	{
		
		public function XMLUtils()
		{
			return;
		}// end function
		
		public static function toObject(param1:XML, param2:Boolean = true) : Object
		{
			var _loc_3:* = undefined;
			if (param1)
			{
				_loc_3 = {};
				param1.ignoreWhitespace = true;
				pNode(param1, _loc_3, param2);
				return _loc_3;
			}
			return null;
		}// end function
		
		private static function pNode(param1:XML, param2:Object, param3:Boolean) : void
		{
			var _loc_6:int = 0;
			if (param3)
			{
				param1.setNamespace("");
			}
			if (!param1.name())
			{
				param2 = null;
				return;
			}
			var _loc_4:* = param1.name().toString();
			var _loc_5:Object = {};
			if (param1.attributes().length() > 0)
			{
				_loc_6 = 0;
				while (_loc_6 < param1.attributes().length())
				{
					
					_loc_5[param1.attributes()[_loc_6].name.toString()] = param1.attributes()[_loc_6];
					_loc_6++;
				}
				if (param1.children().length() <= 1 && _loc_5["value"] == undefined)
				{
					_loc_5["value"] = param1.toString();
				}
			}
			else if (param1.children().length() <= 1 && !param1.hasComplexContent())
			{
				_loc_5 = param1.toString();
			}
			if (param2[_loc_4] == undefined)
			{
				param2[_loc_4] = _loc_5;
			}
			else if (param2[_loc_4] is Array)
			{
				param2[_loc_4].push(_loc_5);
			}
			else
			{
				param2[_loc_4] = [param2[_loc_4], _loc_5];
			}
			try
			{
				toObj(param1, param2[_loc_4], param3);
			}
			catch (e:Error)
			{
			}
			return;
		}// end function
		
		private static function toObj(param1:XML, param2:Object, param3:Boolean) : void
		{
			var _loc_4:int = 0;
			var _loc_5:int = 0;
			var _loc_6:* = undefined;
			_loc_5 = param1.children().length();
			_loc_4 = 0;
			while (_loc_4 < _loc_5)
			{
				
				_loc_6 = param1.children()[_loc_4];
				if (param2 is Array)
				{
					pNode(_loc_6, param2[(param2.length - 1)], param3);
				}
				else
				{
					pNode(_loc_6, param2, param3);
				}
				_loc_4++;
			}
			return;
		}// end function
		
		public static function getXmlObj(param1:Object, param2:int) : Object
		{
			if (param1 is Array)
			{
				if (param2 > (param1.length - 1))
				{
					param2 = param1.length - 1;
				}
				return param1[param2];
			}
			else
			{
				return param1;
			}
		}// end function
		
		public static function getXmlObjLength(param1:Object) : int
		{
			if (param1 is Array)
			{
				return param1.length;
			}
			return 1;
		}// end function
		
	}
}