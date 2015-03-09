package com.oms.tpv1.utils
{
	import com.koma.utils.*;
	
	//地址格式化工具
	public class UrlPathTool extends Object
	{
		public static var isQQWeb:String = "<urls><item>http://[^/]+.qq.com\S*</item></urls>";
		private static var arrayInfoPath:Array = ["v.kankanews.com"];
		private static var index:int = arrayInfoPath.length * Math.random();
		
		public function UrlPathTool()
		{
			return;
		}// end function
		
		public static function getImgUrl(param1:String, param2:String = ".jpg") : String
		{
			var _loc_4:Number = NaN;
			var _loc_8:Number = NaN;
			var _loc_10:Number = NaN;
			var _loc_3:* = 4294967295 + 1;
			var _loc_5:* = 10000 * 10000;
			var _loc_6:* = param1;
			var _loc_7:String = "";
			var _loc_9:Number = 0;
			_loc_8 = 0;
			while (_loc_8 < _loc_6.length)
			{
				
				_loc_10 = _loc_6.charCodeAt(_loc_8);
				_loc_9 = _loc_9 * 32 + _loc_9 + _loc_10;
				if (_loc_9 >= _loc_3)
				{
					_loc_9 = _loc_9 % _loc_3;
				}
				_loc_8 = _loc_8 + 1;
			}
			_loc_4 = _loc_9 % _loc_5;
			_loc_7 = "http://vpic.video.qq.com/" + _loc_4 + "/" + param1 + param2;
			return _loc_7;
		}// end function
		
		//返回默认视频
		public static function getDefaultFlvUrl(param1:String) : String
		{
			//var _loc_2:* = 4294967295 + 1;
			//var _loc_3:* = 10000 * 10000;
			//var _loc_4:* = getTot(param1, _loc_2) % _loc_3;
			//return "http://domhttp.kksmg.com/2014/07/21/h264_450k_mp4_CBN1500000201407218356759091_aac.mp4?";
			
			return "http://domhttp.kksmg.com/2014/07/22/h264_450k_mp4_CBN1500000201407228376893091_aac.mp4?"; 
			//return "http://video.dispatch.tc.qq.com/" + _loc_4 + "/" + param1 + ".flv";
		}// end function
		
		public static function getTot(param1:String, param2:Number) : Number
		{
			var _loc_4:Number = NaN;
			var _loc_6:Number = NaN;
			var _loc_3:* = param1;
			var _loc_5:Number = 0;
			_loc_4 = 0;
			while (_loc_4 < _loc_3.length)
			{
				
				_loc_6 = _loc_3.charCodeAt(_loc_4);
				_loc_5 = _loc_5 * 32 + _loc_5 + _loc_6;
				if (_loc_5 >= param2)
				{
					_loc_5 = _loc_5 % param2;
				}
				_loc_4 = _loc_4 + 1;
			}
			return _loc_5;
		}// end function
		
		public static function checkUrl(param1:String, param2:XML) : Boolean
		{
			var _loc_7:RegExp = null;
			var _loc_8:String = null;
			if (param2 == null)
			{
				return false;
			}
			param1 = param1.toLocaleLowerCase();
			if (param1.indexOf("http://") == 0)
			{
				param1 = param1.substr(7);
			}
			var _loc_3:* = param1.indexOf("/");
			if (_loc_3 != -1)
			{
				param1 = param1.substring(0, _loc_3);
			}
			param1 = "http://" + param1;
			var _loc_4:* = XMLUtils.toObject(param2);
			if (XMLUtils.toObject(param2) == null || _loc_4.urls == null || _loc_4.urls.item == null)
			{
				return false;
			}
			var _loc_5:* = _loc_4.urls.item;
			var _loc_6:* = XMLUtils.getXmlObjLength(_loc_5);
			var _loc_9:int = 0;
			while (_loc_9 < _loc_6)
			{
				
				_loc_8 = String(XMLUtils.getXmlObj(_loc_5, _loc_9));
				_loc_7 = RegExp(_loc_8);
				if (_loc_7.test(param1))
				{
					return true;
				}
				_loc_9++;
			}
			return false;
		}// end function
		
		public static function getInfoPath(param1:String = "getinfo") : String
		{
			var _loc_3:* = index + 1;
			index = _loc_3;
			if (index < 0 || index >= arrayInfoPath.length)
			{
				index = 0;
			}
			return "http://" + arrayInfoPath[index] + "/" + param1;
		}// end function
		
	}
}