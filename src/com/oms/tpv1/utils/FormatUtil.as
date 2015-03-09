package com.oms.tpv1.utils
{
	import __AS3__.vec.*;
	import com.oms.tpv1.model.*;
	import com.oms.tpv1.resource.*;
	
	//格式化数据
	public class FormatUtil extends Object
	{
		public static const NAME_FHD:String = "fhd";
		public static const NAME_SHD:String = "shd";
		public static const NAME_HD:String = "hd";
		public static const NAME_SD:String = "sd";
		public static const NAME_FLV:String = "flv";
		public static const NAME_MP4:String = "mp4";
		public static const NAME_AUTO:String = "sel_auto";
		public static var arrayAllName:Array = [NAME_FLV, NAME_MP4, NAME_SD, NAME_HD, NAME_SHD, NAME_FHD];
		public static var arrayHDName:Array = [NAME_AUTO, NAME_FHD, NAME_SHD, NAME_HD, NAME_SD];
		
		public function FormatUtil()
		{
			return;
		}// end function
		
		public static function sortFormat(param1:Vector.<VideoFormat>) : Vector.<VideoFormat>
		{
			var _loc_4:String = null;
			var _loc_5:int = 0;
			var _loc_2:* = new Vector.<VideoFormat>;
			var _loc_3:int = 0;
			while (_loc_3 < FormatUtil.arrayAllName.length)
			{
				
				_loc_4 = FormatUtil.arrayAllName[_loc_3];
				_loc_5 = 0;
				while (_loc_5 < param1.length)
				{
					
					if (_loc_4 == param1[_loc_5].name)
					{
						param1[_loc_5].index = _loc_2.length;
						_loc_2.push(param1[_loc_5]);
						break;
					}
					_loc_5++;
				}
				_loc_3++;
			}
			return _loc_2;
		}// end function
		
		public static function hasMutiFormat(param1:VideoPlayData) : Boolean
		{
			if (!param1 || !param1.video_fmtlist || !param1.video_curfmt)
			{
				return false;
			}
			if (param1.video_curfmt.name == NAME_FLV || param1.video_curfmt.name == NAME_MP4)
			{
				return false;
			}
			return true;
		}// end function
		
		public static function checkMoreDefinitionFormat(param1:int, param2:Vector.<VideoFormat>) : Boolean
		{
			var _loc_3:* = getEnableArray(param2);
			if (param1 >= (param2.length - 1))
			{
				return false;
			}
			var _loc_4:* = param1 + 1;
			while (_loc_4 < _loc_3.length)
			{
				
				if (_loc_3[_loc_4])
				{
					return true;
				}
				_loc_4++;
			}
			return false;
		}// end function
		
		public static function checkMoreDefinitionByFormat(param1:Vector.<VideoFormat>, param2:VideoFormat) : Boolean
		{
			var _loc_3:VideoFormat = null;
			if (!param1 || param1.length < 2 || !param2 || param2.index == (param1.length - 1))
			{
				return false;
			}
			var _loc_4:* = param2.index + 1;
			while (_loc_4 < param1.length)
			{
				
				_loc_3 = param1[_loc_4];
				if (_loc_3 && (_loc_3.name == NAME_HD || _loc_3.name == NAME_SHD || _loc_3.name == NAME_FHD))
				{
					return true;
				}
				_loc_4++;
			}
			return false;
		}// end function
		
		public static function checkLessDefinitionFormat(param1:int, param2:Vector.<VideoFormat>) : Boolean
		{
			var _loc_3:* = getEnableArray(param2);
			if (param1 == 0)
			{
				return false;
			}
			var _loc_4:* = param1 - 1;
			while (_loc_4 >= 0)
			{
				
				if (_loc_3[_loc_4])
				{
					return true;
				}
				_loc_4 = _loc_4 - 1;
			}
			return false;
		}// end function
		
		public static function checkLessDefinitionByFormat(param1:Vector.<VideoFormat>, param2:VideoFormat) : Boolean
		{
			var _loc_3:VideoFormat = null;
			if (!param1 || param1.length < 2 || !param2 || param2.index == 0)
			{
				return false;
			}
			var _loc_4:* = param2.index - 1;
			while (_loc_4 > 0)
			{
				
				_loc_3 = param1[_loc_4];
				if (_loc_3 && (_loc_3.name == NAME_HD || _loc_3.name == NAME_SD || _loc_3.name == NAME_SHD))
				{
					return true;
				}
				_loc_4 = _loc_4 - 1;
			}
			return false;
		}// end function
		
		public static function getLessDefinitionByFormat(param1:Vector.<VideoFormat>, param2:VideoFormat) : VideoFormat
		{
			var _loc_3:VideoFormat = null;
			if (!param1 || param1.length < 2 || !param2 || param2.index == 0)
			{
				return null;
			}
			var _loc_4:* = param2.index - 1;
			while (_loc_4 > 0)
			{
				
				_loc_3 = param1[_loc_4];
				if (_loc_3 && (_loc_3.name == NAME_HD || _loc_3.name == NAME_SD || _loc_3.name == NAME_SHD))
				{
					return _loc_3;
				}
				_loc_4 = _loc_4 - 1;
			}
			return null;
		}// end function
		
		public static function getVideoFormatByName(param1:Vector.<VideoFormat>, param2:String = "", param3:String = "", param4:int = -1) : VideoFormat
		{
			var _loc_5:VideoFormat = null;
			if (!param1 || param1.length < 2)
			{
				return null;
			}
			var _loc_6:* = param1.length - 1;
			while (_loc_6 > 0)
			{
				
				_loc_5 = param1[_loc_6];
				if (_loc_5 && (_loc_5.name == param2 || _loc_5.id == param3 || _loc_5.index == param4))
				{
					return _loc_5;
				}
				_loc_6 = _loc_6 - 1;
			}
			return null;
		}// end function
		
		public static function getEnableArray(param1:Vector.<VideoFormat>) : Array
		{
			var _loc_3:String = null;
			var _loc_6:int = 0;
			var _loc_2:Array = [];
			var _loc_4:Boolean = false;
			var _loc_5:int = 0;
			while (_loc_5 < arrayHDName.length)
			{
				
				_loc_3 = arrayHDName[_loc_5];
				if (_loc_3 == NAME_AUTO)
				{
				}
				else
				{
					_loc_4 = false;
					_loc_6 = 0;
					while (_loc_6 < param1.length)
					{
						
						if (_loc_3 == param1[_loc_6].name)
						{
							_loc_4 = true;
							break;
						}
						_loc_6++;
					}
					_loc_2.push(_loc_4);
				}
				_loc_5++;
			}
			return _loc_2;
		}// end function
		
		public static function getDefinitionPanelArray(param1:Vector.<VideoFormat>) : Array
		{
			var _loc_2:String = null;
			var _loc_7:int = 0;
			var _loc_3:* = getFileCHName("");
			var _loc_4:* = getBtnCHName("");
			var _loc_5:Array = [{text:_loc_3, name:NAME_AUTO, idx:-1, btnname:_loc_4}];
			var _loc_6:int = 0;
			while (_loc_6 < arrayHDName.length)
			{
				
				_loc_2 = arrayHDName[_loc_6];
				if (_loc_2 == NAME_AUTO)
				{
				}
				else
				{
					_loc_7 = 0;
					while (_loc_7 < param1.length)
					{
						
						if (_loc_2 == param1[_loc_7].name)
						{
							_loc_3 = getFileCHName(_loc_2);
							_loc_4 = getBtnCHName(_loc_2);
							_loc_5.push({text:_loc_3, name:_loc_2, idx:_loc_6, btnname:_loc_4});
							break;
						}
						_loc_7++;
					}
				}
				_loc_6++;
			}
			return _loc_5;
		}// end function
		
		public static function getAutoDefinitionInfo(param1:String = "") : Object
		{
			var _loc_2:* = getFileCHName("");
			if (param1 != "")
			{
				_loc_2 = _loc_2 + (" " + getFilePName(param1));
			}
			return {idx:-1, text:_loc_2};
		}// end function
		
		public static function getAutoFormatIndx(param1:Number) : Object
		{
			var _loc_2:* = new Object();
			if (param1 < 150 && param1 > 0)
			{
				_loc_2.format = PlayerEnum.FORMAT_SD;
				_loc_2.index = 0;
			}
			else if (param1 > 500)
			{
				_loc_2.format = PlayerEnum.FORMAT_SHD;
				_loc_2.index = 2;
			}
			else
			{
				_loc_2.format = PlayerEnum.FORMAT_HD;
				_loc_2.index = 1;
			}
			return _loc_2;
		}// end function
		
		public static function getAutoFormatIndex(param1:Number, param2:Vector.<VideoFormat>) : VideoFormat
		{
			var _loc_3:VideoFormat = null;
			var _loc_4:int = 0;
			while (_loc_4 < param2.length)
			{
				
				_loc_3 = param2[_loc_4];
				if (_loc_3.name != "mp4" && _loc_3.name != "flv")
				{
					if (param1 > _loc_3.br)
					{
						if (_loc_4 == (param2.length - 1))
						{
							return _loc_3;
						}
					}
					else
					{
						return _loc_3;
					}
				}
				_loc_4++;
			}
			return null;
		}// end function
		
		public static function getFileCHName(param1:String) : String
		{
			var _loc_2:String = "";
			switch(param1)
			{
				case PlayerEnum.FORMAT_SHD:
				{
					_loc_2 = "超清 720P";
					break;
				}
				case PlayerEnum.FORMAT_HD:
				{
					_loc_2 = "高清 360P";
					break;
				}
				case PlayerEnum.FORMAT_SD:
				{
					_loc_2 = "标清 270P";
					break;
				}
				case PlayerEnum.FORMAT_FHD:
				{
					_loc_2 = "超清 1080P";
					break;
				}
				default:
				{
					_loc_2 = "自适应";
					break;
				}
			}
			return _loc_2;
		}// end function
		
		public static function getFilePName(param1:String) : String
		{
			var _loc_2:String = "";
			switch(param1)
			{
				case PlayerEnum.FORMAT_SHD:
				{
					_loc_2 = "720P";
					break;
				}
				case PlayerEnum.FORMAT_HD:
				{
					_loc_2 = "360P";
					break;
				}
				case PlayerEnum.FORMAT_SD:
				{
					_loc_2 = "270P";
					break;
				}
				case PlayerEnum.FORMAT_FHD:
				{
					_loc_2 = "1080P";
					break;
				}
				default:
				{
					_loc_2 = "";
					break;
				}
			}
			return _loc_2;
		}// end function
		
		public static function getBtnCHName(param1:String) : String
		{
			var _loc_2:String = "";
			switch(param1)
			{
				case PlayerEnum.FORMAT_SHD:
				{
					_loc_2 = "超清";
					break;
				}
				case PlayerEnum.FORMAT_HD:
				{
					_loc_2 = "高清";
					break;
				}
				case PlayerEnum.FORMAT_SD:
				{
					_loc_2 = "标清";
					break;
				}
				case PlayerEnum.FORMAT_FHD:
				{
					_loc_2 = "超清";
					break;
				}
				default:
				{
					_loc_2 = ResourceManager.instance.getContent("definition_btn");
					break;
					break;
				}
			}
			return _loc_2;
		}// end function

	}
}