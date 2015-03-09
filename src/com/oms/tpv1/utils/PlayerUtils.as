package com.oms.tpv1.utils
{
	import com.oms.tpv1.managers.*;
	import com.oms.tpv1.model.*;
	
	import flash.display.*;
	import flash.external.*;
	import flash.filters.*;
	
	public class PlayerUtils extends Object
	{
		
		private static var version:String = "";
		public static var versionNo:String = "3.2.11.161";
		private static var coverurls:Array = ["vpic.video.qq.com"];
		
		public function PlayerUtils()
		{
			return;
		}// end function
		
		public static function getPlayerVersion(param1:int = 0) : String
		{
			switch(param1)
			{
				case PlayerEnum.TYPE_OUTSIDE:
				{
					version = "TencentPlayerOut";
					if (isQzoneVideo())
					{
						version = "TencentPlayerOutQz";
					}
					break;
				}
				case PlayerEnum.TYPE_CNTV:
				{
					version = "TencentCntvPlayer";
					break;
				}
				case PlayerEnum.TYPE_QZONE:
				{
					version = "TencentQzonePlayer";
					break;
				}
				case PlayerEnum.TYPE_TVB:
				{
					version = "TencentTvbPlayer";
					break;
				}
				case PlayerEnum.TYPE_MV:
				{
					version = "MusicPlayer";
					break;
				}
				case PlayerEnum.TYPE_SWFOUTSIDE:
				{
					version = "TPoutSwf";
					break;
				}
				case PlayerEnum.TYPE_TPCOMPONENT:
				{
					version = "TPComponent";
					break;
				}
				case PlayerEnum.TYPE_NORMAL:
				{
				}
				default:
				{
					version = "TencentPlayer";
					break;
					break;
				}
			}
			version = version + ("V" + versionNo);
			return version;
		}// end function
		
		public static function getPlayerVersionTail(param1:int = 0) : String
		{
			if (version == "")
			{
				getPlayerVersion(param1);
			}
			var _loc_2:* = /\.""\./g;
			var _loc_3:* = version.replace(_loc_2, "");
			return _loc_3.toLocaleLowerCase();
		}// end function
		
		public static function addUrlTail(param1:String, param2:String) : String
		{
			if (param1.indexOf("?") == -1)
			{
				return param1 + "?" + param2;
			}
			return param1 + "&" + param2;
		}// end function
		
		public static function removeUrlPara(param1:String) : String
		{
			var _loc_2:* = param1.indexOf("?");
			var _loc_3:* = param1;
			if (_loc_2 > 0)
			{
				_loc_3 = _loc_3.substr(0, _loc_2);
			}
			return _loc_3;
		}// end function
		
		public static function getUrlParas(param1:String) : Object
		{
			var _loc_5:Array = null;
			var _loc_6:String = null;
			var _loc_7:Array = null;
			var _loc_8:int = 0;
			var _loc_2:* = param1.indexOf("?");
			var _loc_3:* = new Object();
			var _loc_4:* = param1;
			if (_loc_2 > 0)
			{
				_loc_4 = _loc_4.substr((_loc_2 + 1));
				_loc_5 = _loc_4.split("&");
				_loc_8 = 0;
				while (_loc_8 < _loc_5.length)
				{
					
					_loc_6 = _loc_5[_loc_8];
					_loc_7 = _loc_6.split("=");
					if (_loc_7.length > 1)
					{
						_loc_3[_loc_7[0]] = _loc_7[1];
					}
					else
					{
						_loc_3[_loc_7[0]] = "null";
					}
					_loc_8++;
				}
			}
			return _loc_3;
		}// end function
		
		public static function getVurl(param1:String, param2:Object) : String
		{
			var _loc_4:String = null;
			var _loc_3:* = param1;
			if (!param2)
			{
				return _loc_3;
			}
			for (_loc_4 in param2)
			{
				
				_loc_3 = addUrlTail(_loc_3, _loc_4 + "=" + param2[_loc_4]);
			}
			return _loc_3;
		}// end function
		
		
		//生成分享地址.
		public static function getPlayAdd(param1:String, param2:String = "") : String
		{
			var _loc_3:String = "http://www.kankanews.com/";
			if (param1 == "")
			{
				if (param2 != "")
				{
					_loc_3 = _loc_3 + ("play/" + param2 + ".html");
				}
				return _loc_3;
			}
			_loc_3 = _loc_3 + "cover/" + param1.substr(0, 1) + "/" + param1 + ".html";
			if (param2 != "")
			{
				_loc_3 = _loc_3 + ("?vid=" + param2);
			}
			return _loc_3;
		}// end function
		
		public static function getVideoBufferBySpeed(param1:String) : Object
		{
			var _loc_4:Object = null;
			var _loc_5:Array = null;
			var _loc_6:int = 0;
			var _loc_2:Number = 0;
			var _loc_3:Number = 0;
			if (GlobalVars.playerLocalSpeed && GlobalVars.playerLocalSpeed.arraySpeed && GlobalVars.playerLocalSpeed.arraySpeed.length > 0)
			{
				_loc_5 = GlobalVars.playerLocalSpeed.arraySpeed;
				_loc_6 = 0;
				while (_loc_6 < _loc_5.length)
				{
					
					_loc_4 = _loc_5[_loc_6];
					_loc_3 = _loc_3 + _loc_4.speed;
					_loc_6++;
				}
				_loc_2 = _loc_3 / _loc_5.length;
				switch(param1)
				{
					case PlayerEnum.FORMAT_SD:
					case PlayerEnum.FORMAT_HD:
					case PlayerEnum.FORMAT_SHD:
					case PlayerEnum.FORMAT_FHD:
					{
						if (_loc_2 > 150)
						{
							return {buffer:6, secbuffer:4, wait:0, speed:_loc_2};
						}
						if (_loc_2 < 75)
						{
							return {buffer:8, secbuffer:8, wait:0, speed:_loc_2};
						}
						return {buffer:7, secbuffer:6, wait:0, speed:_loc_2};
					}
					default:
					{
						if (_loc_2 > 150)
						{
							return {buffer:6, secbuffer:4, wait:0, speed:_loc_2};
						}
						if (_loc_2 < 75)
						{
							return {buffer:8, secbuffer:8, wait:0, speed:_loc_2};
						}
						return {buffer:7, secbuffer:6, wait:0, speed:_loc_2};
						break;
					}
				}
			}
			else
			{
			}
			return {buffer:7, secbuffer:6, wait:0, speed:_loc_2};
		}// end function
		
		public static function getDefaultPath(param1:String, param2:String, param3:String = "") : Object
		{
			var _loc_5:String = null;
			var _loc_6:int = 0;
			var _loc_8:Object = null;
			var _loc_4:* = new Object();
			//var _loc_7:* = Number(GlobalVars.cdntype);
			var _loc_7:* = 0;
			/*if (!isNaN(_loc_7) && _loc_7 >> 20 == 15)
			{
				_loc_8 = getOlympicsPath(param1);
				_loc_4.vtype = _loc_8.vtype;
				_loc_5 = _loc_8.path;
			}
			else
			{
				_loc_4.vtype = 0;
				_loc_5 = UrlPathTool.getDefaultFlvUrl(param1);
			}*/
			
			_loc_4.orgurl = _loc_5.substring(0, (_loc_5.lastIndexOf("/") + 1));
			if (param3 != "")
			{
				_loc_6 = _loc_5.lastIndexOf(".");
				_loc_5 = _loc_5.substring(0, _loc_6) + param3;
			}
			//_loc_4.flvPath = _loc_5 + "?sdtfrom=" + SdtFromGetter.getSdtFrom(param2, GlobalVars.p2pStreamType == StreamFactory.STREAMTYPE_NATIVE, GlobalVars.ptag);
			_loc_4.flvPath = _loc_5;
			return _loc_4;
		}// end function
		
		/*
		private static function getDefaultType(param1:String) : uint
		{
			if (param1 == "null")
			{
				return 0;
			}
			if (param1.indexOf("qq.com") > -1 || param1.indexOf("expo2010.cn") > -1 || param1.indexOf("expo2010tv.cn") > -1)
			{
				if (param1.indexOf("qzone.qq.com") > -1 || param1.indexOf("v.qq.com") > -1 || param1.indexOf("video.qq.com") > -1 || param1.indexOf("qbar.qq.com") > -1 || param1.indexOf("boke.qq.com") > -1)
				{
					return 0;
				}
				return 1;
			}
			return 0;
		}// end function
		*/
		
		
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
		
		
		public static function setGray(param1:DisplayObject, param2:Boolean) : void
		{
			var _loc_3:Array = null;
			if (param1 == null)
			{
				return;
			}
			if (!param2)
			{
				_loc_3 = [0.2, 0.2, 0.2, 0, 0, 0.2, 0.2, 0.2, 0, 0, 0.2, 0.2, 0.2, 0, 0, 0, 0, 0, 1, 0];
			}
			else
			{
				param1.alpha = 1;
				_loc_3 = [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0];
			}
			var _loc_4:* = new ColorMatrixFilter(_loc_3);
			param1.filters = [_loc_4];
			return;
		}// end function
		
		public static function getCurrTime(param1:Date = null) : String
		{
			if (!param1)
			{
				param1 = new Date();
			}
			var _loc_2:* = param1.fullYear.toString() + "-";
			var _loc_3:* = param1.month + 1;
			_loc_2 = _loc_2 + (addzero(_loc_3, 2) + "-" + addzero(param1.date, 2) + " " + addzero(param1.hours, 2) + ":" + addzero(param1.minutes, 2) + ":" + addzero(param1.seconds, 2) + " " + addzero(param1.milliseconds, 3));
			return _loc_2;
		}// end function
		
		private static function addzero(param1:int, param2:int) : String
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
		
		public static function getCurrtimeByTime(param1:Number) : String
		{
			var _loc_2:* = new Date();
			_loc_2.setTime(param1);
			param1 = param1 + _loc_2.timezoneOffset * 60000;
			param1 = param1 + 28800000;
			_loc_2.setTime(param1);
			return getCurrTime(_loc_2);
		}// end function
		//跳转到指定页面
		public static function getPlayPage(param1:String, param2:String = "0") : String
		{
			var _loc_3:String = "";
			if (param2 != "0")
			{
				_loc_3 = "_" + param2;
			}
			return 'http://www.baidu.com/';
			//return GlobalVars.homepage + "/page/" + param1.substr(0, 1) + "/" + param1.substr(param1.length - 2, 1) + "/" + param1.substr((param1.length - 1), 1) + "/" + param1 + _loc_3 + ".html";
		}// end function
		
		//这里有机会再测试下..
		public static function getOlympicsPath(param1:String) : Object
		{
			var _loc_2:* = new Object();
			var _loc_3:* = Math.random();
			if (_loc_3 <= 0.15)
			{
				_loc_2.vtype = "107";
				_loc_2.path = getDoubleHashsPath(param1, "http://vogwsh.video.qq.com/");
			}
			else if (_loc_3 <= 0.25)
			{
				_loc_2.vtype = "157";
				_loc_2.path = getDoubleHashsPath(param1, "http://voglxh.video.qq.com/");
			}
			else if (_loc_3 <= 0.3)
			{
				_loc_2.vtype = "117";
				_loc_2.path = getDoubleHashsPath(param1, "http://vogh.dnion.videocdn.qq.com/");
			}
			else
			{
				_loc_2.vtype = "207";
				_loc_2.path = getSingleHashPath(param1, "http://vogh.tc.qq.com/");
			}
			return _loc_2;
		}// end function
		
		private static function getSingleHashPath(param1:String, param2:String) : String
		{
			var _loc_3:* = 4294967295 + 1;
			var _loc_4:* = 10000 * 10000;
			var _loc_5:* = UrlPathTool.getTot(param1, _loc_3) % _loc_4;
			return param2 + _loc_5 + "/" + param1 + ".flv";
		}// end function
		
		private static function getDoubleHashsPath(param1:String, param2:String) : String
		{
			var _loc_3:uint = 0;
			var _loc_4:* = 256 * 256;
			var _loc_5:uint = 0;
			var _loc_6:int = 0;
			while (_loc_6 < param1.length)
			{
				
				_loc_5 = (_loc_5 << 5) + _loc_5 + param1.charCodeAt(_loc_6);
				_loc_6++;
			}
			_loc_3 = _loc_5 % _loc_4;
			var _loc_7:* = _loc_3 / 256;
			var _loc_8:* = _loc_3 % 256;
			return param2 + "flv/" + _loc_7 + "/" + _loc_8 + "/" + param1 + ".flv";
		}// end function
		
		public static function getBrowserType() : int
		{
			var btype:* = PlayerEnum.BROWSER_UNKNOWN;
			try
			{
				//if (ExternalInterface.available && GlobalVars.objIdAllowed)
				if (ExternalInterface.available)
				{
					ExternalInterface.call("(window.$FLASH_GETBTYPE_20120702 = function(){" + "var t,vawk,type, _ua = navigator.userAgent, _nv = navigator.appVersion, vffRE = /(?:Firefox|GranParadiso|Iceweasel|Minefield).(d+.d+)/i, vwebkitRE = /AppleWebKit.(d+.d+)/i, vchromeRE = /Chrome.(d+.d+)/i, vsafariRE = /Version.(d+.d+)/i, vwinRE = /Windows.+?(d+.d+)/," + "type=0;" + "if (window.ActiveXObject){" + "\ttype= 1;" + "}else if (document.getBoxObjectFor || typeof(window.mozInnerScreenX) != \"undefined\") {" + "\ttype=2;" + "}else if (!navigator.taintEnabled) {" + "\tt = _ua.match(vwebkitRE);" + "\tvawk = (t && t.length > 1) ? parseFloat(t[1], 10) : (!!document.evaluate ? (!!document.querySelector ? 525 : 420) : 419);" + "\tif ((t = _nv.match(vchromeRE)) || window.chrome) {" + " \t\ttype= 3;" + "\t}" + "\tif ((t = _nv.match(vsafariRE)) && !window.chrome) {" + "\t\ttype= 5;" + "\t}" + "}" + "return type;" + "})()");
					btype = ExternalInterface.call("$FLASH_GETBTYPE_20120702");
				}
			}
			catch (e:Error)
			{
				btype = PlayerEnum.BROWSER_UNKNOWN;
			}
			return btype;
		}// end function
		
		public static function checkVarsUrl(param1:String) : Boolean
		{
			var _loc_2:* = param1.toLocaleLowerCase();
			var _loc_3:Boolean = false;
			if (_loc_2.indexOf("http://") == 0)
			{
				_loc_2 = _loc_2.substr(7);
			}
			_loc_2 = _loc_2.substring(0, _loc_2.indexOf("/"));
			if (_loc_2.indexOf(".qq.com") != -1)
			{
				_loc_3 = true;
			}
			return _loc_3;
		}// end function
		
		public static function checkVarsSkinPath(param1:String) : Boolean
		{
			var _loc_2:Boolean = false;
			//var _loc_3:String = "http://imgcache.qq.com/minivideo_v1/vd/res/skins/TPcntvSkin.swf";
			//var _loc_4:String = "http://imgcache.qq.com/minivideo_v1/vd/res/skins/mvskins/mv_skin.swf";
			var _loc_3:String = "";
			var _loc_4:String = "";
			var _loc_5:Array = [PlayerEnum.SKINURL_DEFAULT, PlayerEnum.SKINURL_DEFAULT_V4, PlayerEnum.SKINURL_MINI, PlayerEnum.SKINURL_MINI_V4, PlayerEnum.SKINURL_NBA, PlayerEnum.SKINURL_NBA_V4, PlayerEnum.SKINURL_OUT, PlayerEnum.SKINURL_OUT_V4, PlayerEnum.SKINURL_TVB, _loc_3, _loc_4];
			if ([PlayerEnum.SKINURL_DEFAULT, PlayerEnum.SKINURL_DEFAULT_V4, PlayerEnum.SKINURL_MINI, PlayerEnum.SKINURL_MINI_V4, PlayerEnum.SKINURL_NBA, PlayerEnum.SKINURL_NBA_V4, PlayerEnum.SKINURL_OUT, PlayerEnum.SKINURL_OUT_V4, PlayerEnum.SKINURL_TVB, _loc_3, _loc_4].indexOf(param1) == -1)
			{
				_loc_2 = false;
			}
			else
			{
				_loc_2 = true;
			}
			return _loc_2;
		}// end function
		
		public static function checkVarsLoadingPath(param1:String) : Boolean
		{
			var _loc_2:Boolean = false;
			var _loc_3:Array = [PlayerEnum.LOADING_DEFAULT, PlayerEnum.LOADING_MINI, PlayerEnum.LOADING_TVB, PlayerEnum.LOADING_NOLOGO];
			if (_loc_3.indexOf(param1) == -1)
			{
				_loc_2 = false;
			}
			else
			{
				_loc_2 = true;
			}
			return _loc_2;
		}// end function
		
		public static function pushMaxLenArray(param1:Array, param2:Object, param3:int = 0) : void
		{
			if (!param1 || !param2)
			{
				return;
			}
			if (param1.length > param3)
			{
				param1.splice(param3, param1.length - param3);
			}
			if (param1.length == param3)
			{
				param1.shift();
			}
			param1.push(param2);
			return;
		}// end function
		
		public static function indexHomePages(param1:String) : Boolean
		{
			var _loc_2:String = null;
			var _loc_3:String = null;
			if (param1 == null)
			{
				return false;
			}
			param1 = param1.toLocaleLowerCase();
			var _loc_4:int = 0;
			while (_loc_4 < GlobalVars.homepages.length)
			{
				
				_loc_2 = GlobalVars.homepages[_loc_4];
				_loc_3 = _loc_2.substr(7, _loc_2.length);
				if (param1.indexOf(_loc_2) == 0 || param1.indexOf(_loc_3) == 0)
				{
					return true;
				}
				_loc_4++;
			}
			//return false;
			return true;
		}// end function
		
		public static function checkCoverUrl(param1:String) : Boolean
		{
			param1 = param1.toLocaleLowerCase();
			if (param1.indexOf("http://") == 0)
			{
				param1 = param1.substr(7);
			}
			var _loc_2:* = param1.indexOf("/");
			if (_loc_2 != -1)
			{
				param1 = param1.substr(0, _loc_2);
			}
			if (coverurls.indexOf(param1) == -1)
			{
				return false;
			}
			return true;
		}// end function
		
		public static function validateFunction(param1:String) : Boolean
		{
			var _loc_2:RegExp = null;
			if (param1)
			{
				_loc_2 = /^[0-9a-zA-Z_\.]+$""^[0-9a-zA-Z_\.]+$/g;
				if (_loc_2.exec(param1) != null)
				{
					return true;
				}
			}
			return false;
		}// end function
		
		public static function checkObjectID() : Boolean
		{
			var _loc_1:String = null;
			try
			{
				if (ExternalInterface.available)
				{
					_loc_1 = ExternalInterface.objectID;
					if (!_loc_1 || _loc_1 == _loc_1.replace(getDisNormalRegexp(), ""))
					{
						return true;
					}
					else
					{
						return false;
					}
				}
			}
			catch (e:Error)
			{
			}
			return true;
		}// end function
		
		public static function getDisNormalRegexp() : RegExp
		{
			var _loc_1:* = /[^0-9a-zA-Z_]/g;
			return _loc_1;
		}// end function
		
		public static function onPlayerMsg(param1:int) : void
		{
			try
			{
				//if (ExternalInterface.available && GlobalVars.objIdAllowed)
				if (ExternalInterface.available)
				{
					ExternalInterface.call("__tenplay_onMessage", ExternalInterface.objectID, param1);
				}
			}
			catch (e:Error)
			{
			}
			return;
		}// end function
		
		public static function getLocSpeed(param1:Number) : Number
		{
			var _loc_4:ClSpeedMode = null;
			var _loc_5:uint = 0;
			var _loc_6:uint = 0;
			var _loc_7:Number = NaN;
			var _loc_8:int = 0;
			//var _loc_2:* = GlobalVars.arrayClspeed;
			var _loc_2:* = [];
			var _loc_3:Number = 0;
			if (_loc_2)
			{
				_loc_5 = 0;
				_loc_6 = 0;
				_loc_7 = 0;
				_loc_8 = _loc_2.length - 1;
				while (_loc_8 >= 0)
				{
					
					_loc_4 = _loc_2[_loc_8];
					if (_loc_4)
					{
						if (_loc_4.clspeed < 8000)
						{
							_loc_5 = _loc_5 + _loc_4.getTotalBtyes();
							_loc_6 = _loc_6 + _loc_4.duration;
						}
						else
						{
							_loc_7 = _loc_4.clspeed;
							break;
						}
					}
					_loc_8 = _loc_8 - 1;
				}
				if (_loc_5 != 0 && _loc_6 != 0)
				{
					_loc_3 = Math.floor(_loc_5 / _loc_6);
				}
				else if (_loc_7 != 0)
				{
					_loc_3 = Math.floor(_loc_7);
				}
				else
				{
					_loc_3 = 0;
				}
			}
			if (_loc_3 == 0)
			{
				_loc_3 = param1;
			}
			return _loc_3;
		}// end function
		
		public static function getCookie() : String
		{
			var cookies:String;
			try
			{
				//if (ExternalInterface.available && GlobalVars.objIdAllowed)
				if (ExternalInterface.available)
					
				{
					cookies = ExternalInterface.call("eval", "document.cookie");
				}
			}
			catch (e:Error)
			{
				cookies;
			}
			if (cookies == null || cookies == "undefined")
			{
				cookies;
			}
			return cookies;
		}// end function
		
		public static function getSkey(param1:String) : String
		{
			var _loc_2:String = null;
			var _loc_3:Array = null;
			var _loc_4:* = new RegExp("(^| )skey=([^;]*)(;|$)", "gi");
			_loc_3 = _loc_4.test(_loc_2);
			
			if (_loc_3 && _loc_3.length > 2)
			{
				return _loc_3[2];
			}
			return "";
		}// end function
		
		public static function getG_tk(param1:String) : uint
		{
			if (param1 == "" || param1 == null || param1 == "undefined")
			{
				return 0;
			}
			var _loc_2:* = 0;
			var _loc_3:* = param1.length;
			var _loc_4:* = 5381;
			while (_loc_2 < _loc_3)
			{
				
				_loc_4 = _loc_4 + ((_loc_4 << 5) + param1.charAt(_loc_2).charCodeAt());
				_loc_2 = _loc_2 + 1;
			}
			return _loc_4 & 2147483647;
		}// end function
		
		//测试SWF位置
		public static function isQzoneVideo() : Boolean
		{
			var _loc_1:Array = ["b1.edu.qzone.qq.com", "cnc.qzs.qq.com", "b11.cnc.qzone.qq.com", "b11.qzone.qq.com", "sns.qzone.qq.com", "edu.qzs.qq.com", "cn.qzs.qq.com", "user.qzone.qq.com", "cm.qzs.qq.com", "b1.qzone.qq.com", "b1.cnc.qzone.qq.com", "qzs.qq.com", "ctc.qzs.qq.com", "ctc.qzonestyle.gtimg.cn", "cnc.qzonestyle.gtimg.cn", "qzonestyle.gtimg.cn", "imgcache.qq.com", "os.qzs.qq.com", "page.opensns.qq.com", "cm.qzonestyle.gtimg.cn", "qun.qzone.qq.com", "r.qzone.qq.com", "cn.qzonestyle.gtimg.cn", "ic2.s11.qzone.qq.com", "ic2.s21.qzone.qq.com", "ic2.s2.qzone.qq.com", "os.qzonestyle.gtimg.cn", "ic2.s12.qzone.qq.com", "b11.edu.qzone.qq.com", "ic2.s8.qzone.qq.com", "rsh.qzone.qq.com", "edu.qzonestyle.gtimg.cn", "qzs.pengyou.com"];
			//var _loc_2:* = GlobalVars.usingHost.toLocaleLowerCase();
			var _loc_2:* = '';
			var _loc_3:int = 0;
			while (_loc_3 < _loc_1.length)
			{
				
				if (_loc_2.indexOf("http://" + _loc_1[_loc_3]) == 0)
				{
					return true;
				}
				_loc_3++;
			}
			return false;
		}// end function
		
	}
}