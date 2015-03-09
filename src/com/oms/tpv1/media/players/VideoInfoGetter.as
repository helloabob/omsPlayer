package com.oms.tpv1.media.players
{
	import com.koma.utils.*;
	import com.oms.report.*;
	import com.oms.tpv1.events.*;
	import com.oms.tpv1.model.*;
	import com.oms.tpv1.utils.*;
	import com.sun.events.*;
	import com.sun.net.*;
	import com.sun.utils.*;
	
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	
	public class VideoInfoGetter extends EventDispatcher
	{
		private var _fld:FileLoader;
		private var _tryTimes:int = 0;
		private var _vids:String = "";
		private var _len:int = 0;
		private var _charged:String = "0";
		private var _requestInfo:Object;
		private var _currentData:VideoPlayData;
		//private var _httploader:HttpLoader;
		private var loadtime:uint;
		private const URL_PATTERN:RegExp = /\r\n/g;
		private var _vInfoUrl:String = "";
		private var _reportmode:ReportMode;
		private var httpheadCoden:Number = 0;
		private var httpheadCasttime:uint = 0;
		private static var _instance:VideoInfoGetter;
		
		public function VideoInfoGetter()
		{
			
			if (_instance)
			{
				throw new Error("单例类，不能用New创建");
			}
			return;
		}// end function
		
		public function getVideoInfo(param1:VideoPlayData) : void
		{
			var _loc_2:Object = null;
			if (!param1)
			{
				return;
			}
			this._vids = param1.arrayVid.join("|");
			this._currentData = param1;
			if (this._fld == null)
			{
				this._fld = new FileLoader();
				this._fld.requestTimeout = 6000;
				this._fld.loadTimeout = 6000;
			}
			else
			{
				this._fld.close();
			}
			if (!this._fld.hasEventListener(NLoaderEvent.LOAD_COMPLETE))
			{
				this._fld.addEventListener(NLoaderEvent.LOAD_COMPLETE, this.urlLoadCompleteHandler);
				this._fld.addEventListener(NLoaderEvent.LOAD_ERROR, this.urlLoadErrorHandler);
			}
			this._tryTimes = 0;
			//是否支付
			if (GlobalVars.isPayedVideo)
			{
				this._charged = "1";
			}
			else
			{
				this._charged = "0";
			}
			var _loc_3:String = "1";
			if (GlobalVars.playerversion == PlayerEnum.TYPE_NORMAL || GlobalVars.playerversion == PlayerEnum.TYPE_MV)
			{
				_loc_3 = "11";
			}
			var _loc_4:* = PlayerUtils.getLocSpeed(param1.historySpeed);
			if (param1.playformat == PlayerEnum.FORMAT_AUTO)
			{
				_loc_2 = {vids:this._vids, otype:"xml", platform:_loc_3, charge:this._charged, ran:Math.random(), speed:_loc_4, pid:GlobalVars.pid, appver:PlayerUtils.versionNo};
			}
			else
			{
				//多了一个码率选择
				_loc_2 = {vids:this._vids, otype:"xml", platform:_loc_3, charge:this._charged, ran:Math.random(), speed:_loc_4, pid:GlobalVars.pid, appver:PlayerUtils.versionNo, defaultfmt:param1.playformat};
			}
			this._requestInfo = _loc_2;
			if (param1.video_forceHttp)
			{
				this._requestInfo.fp2p = 2;
			}
			else
			{
				this._requestInfo.fp2p = 1;
			}
			this.loadtime = getTimer();
			//获取一些信息
			trace('是不是在这里卡了..........');
			this._vInfoUrl = PlayerUtils.getVurl(GlobalVars.cgi_get_videoinfo, this._requestInfo);
			this._fld.load(GlobalVars.cgi_get_videoinfo, "URLRequest", URLLoaderDataFormat.TEXT, this._requestInfo, "POST");
			AS3Debugger.Trace("VideoInfoGetter::Load GetInfo " + this._vInfoUrl);
			return;
		}// end function
		
		
		public function destroy() : void
		{
			if (this._fld)
			{
				if (this._fld.hasEventListener(NLoaderEvent.LOAD_COMPLETE))
				{
					this._fld.removeEventListener(NLoaderEvent.LOAD_COMPLETE, this.urlLoadCompleteHandler);
					this._fld.removeEventListener(NLoaderEvent.LOAD_ERROR, this.urlLoadErrorHandler);
				}
				this._fld.close();
				this._fld = null;
			}
			return;
		}// end function
		
		private function urlLoadErrorHandler(event:NLoaderEvent) : void
		{
			var _loc_3:String = null;
			var _loc_4:Object = null;
			
			this._tryTimes = this._tryTimes + 1;
			var _loc_2:Number = 0;
			if (event.value.code && !isNaN(event.value.code))
			{
				_loc_2 = event.value.code;
			}
			if (this._tryTimes <= 3)
			{
				AS3Debugger.Trace("GetVideoInfo::重试请求   trytime=" + this._tryTimes);
				this._reportmode = ReportManager.createReportMode(ReportManager.STEP_GETINFO, getTimer() - this.loadtime, ReportManager.GETINFO_HTTPERROR, _loc_2, 0, this._vids);
				this._reportmode.vurl = this._vInfoUrl;
				ReportManager.addReport(this._reportmode, true);
				this.loadtime = getTimer();
				this._requestInfo.ran = Math.random();
				_loc_3 = this.changeGetInfo();
				this._vInfoUrl = PlayerUtils.getVurl(_loc_3, this._requestInfo);
				this._fld.load(_loc_3, "URLRequest", URLLoaderDataFormat.TEXT, this._requestInfo, "POST");
				return;
			}
			this._fld.removeEventListener(NLoaderEvent.LOAD_COMPLETE, this.urlLoadCompleteHandler);
			this._fld.removeEventListener(NLoaderEvent.LOAD_ERROR, this.urlLoadErrorHandler);
			this._fld = null;
			//this.testHttpHead(getTimer() - this.loadtime, _loc_2);
			_loc_4 = this.createDefaultInfo();
			dispatchEvent(new VideoInfoGetterEvent(VideoInfoGetterEvent.VIDEOINFO_ERROR, {code:"default", msg:"mediaurl获取XML异常", info:_loc_4}));
			return;
		}// end function
		
		//创建默认数据结构
		public function createDefaultInfo() : Object
		{
			var _loc_5:Object = null;
			var _loc_6:Object = null;
			var _loc_7:Object = null;
			var _loc_8:Object = null;
			var _loc_1:* = new Object();
			_loc_1.br = "128";
			var _loc_2:* = new Object();
			_loc_2.cnt = "2";
			_loc_2.fi = new Array({id:"1", name:"flv", br:"128", sl:"1"}, {id:"2", name:"mp4", br:"128", sl:"0"});
			_loc_1.fl = _loc_2;
			_loc_1.hs = "0";
			_loc_1.ispac = "0";
			_loc_1.s = "o";
			var _loc_3:* = new Object();
			_loc_3.cnt = this._currentData.arrayVid.length.toString();
			var _loc_4:* = new Array();
			var _loc_9:int = 0;
			while (_loc_9 < this._currentData.arrayVid.length)
			{
				
				_loc_5 = new Object();
				_loc_5.vid = this._currentData.arrayVid[_loc_9];
				_loc_6 = PlayerUtils.getDefaultPath(_loc_5.vid, GlobalVars.usingHost);
				_loc_5.ch = "0";
				_loc_5.cl = {fc:"0"};
				_loc_5.fn = _loc_5.vid + ".flv";
				_loc_5.fs = "0";
				_loc_5.fst = "5";
				_loc_5.lnk = _loc_5.vid;
				_loc_5.st = "2";
				_loc_5.td = "0";
				_loc_5.ti = "OMS信息";
				_loc_5.type = "0";
				_loc_7 = new Object();
				_loc_7.ui = {dt:"0", dtc:"0", url:_loc_6.flvPath, vt:_loc_6.vtype.toString()};
				_loc_5.ul = _loc_7;
				_loc_5.vh = "240";
				_loc_5.vw = "320";
				_loc_4.push(_loc_5);
				_loc_9++;
			}
			if (_loc_4.length == 0)
			{
				_loc_3.vi = _loc_4[0];
			}
			else
			{
				_loc_3.vi = _loc_4;
			}
			_loc_1.vl = _loc_3;
			return _loc_1;
		}// end function
		
		private function changeGetInfo() : String
		{
			var _loc_1:* = GlobalVars.cgi_get_videoinfo;
			if (GlobalVars.playertype != PlayerEnum.TYPE_QZONE)
			{
				_loc_1 = UrlPathTool.getInfoPath();
			}
			return _loc_1;
		}// end function

		
		/*private function testHttpHead(param1:uint, param2:Number) : void
		{
			this.httpheadCoden = param2;
			this.httpheadCasttime = param1;
			if (!this._httploader)
			{
				this._httploader = new HttpLoader();
				this._httploader.timeout = 5000;
			}
			if (!this._httploader.hasEventListener(Event.COMPLETE))
			{
				this._httploader.addEventListener(Event.COMPLETE, this.onHttploaderComplete);
				this._httploader.addEventListener(IOErrorEvent.IO_ERROR, this.onHttploaderError);
				this._httploader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onHttploaderError);
			}
			AS3Debugger.Trace("httploader::::starttoload");
			this._httploader.load(new URLRequest(GlobalVars.cgi_get_videoinfo));
			return;
		}// end function
		
		
		
		private function onHttploaderComplete(event:Event):void
		{
			this._httploader.removeEventListener(Event.COMPLETE, this.onHttploaderComplete);
			this._httploader.removeEventListener(IOErrorEvent.IO_ERROR, this.onHttploaderError);
			this._httploader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onHttploaderError);
			var _loc_2:String = "";
			if (this._httploader.response)
			{
				_loc_2 = this._httploader.response.headers;
			}
			_loc_2 = _loc_2.replace(this.URL_PATTERN, "\\r\\n");
			this._httploader = null;
			this._reportmode = ReportManager.createReportMode(ReportManager.STEP_GETINFO, this.httpheadCasttime, ReportManager.GETINFO_HTTPERROR, this.httpheadCoden, 0, this._vids, "", "0", 0, 0, "0", _loc_2);
			this._reportmode.vurl = this._vInfoUrl;
			ReportManager.addReport(this._reportmode, true);
			return;
		}// end function
		
		private function onHttploaderError(event:Event):void
		{
			this._httploader.removeEventListener(Event.COMPLETE, this.onHttploaderComplete);
			this._httploader.removeEventListener(IOErrorEvent.IO_ERROR, this.onHttploaderError);
			this._httploader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onHttploaderError);
			this._httploader = null;
			AS3Debugger.Trace("httploader::::" + event.toString());
			this._reportmode = ReportManager.createReportMode(ReportManager.STEP_GETINFO, this.httpheadCasttime, ReportManager.GETINFO_HTTPERROR, this.httpheadCoden, 0, this._vids);
			this._reportmode.vurl = this._vInfoUrl;
			ReportManager.addReport(this._reportmode, true);
			return;
		}// end function
		*/
		
		//截入完成
		private function urlLoadCompleteHandler(event:NLoaderEvent) : void
		{
			var _loc_4:Object = null;
			var _loc_5:Boolean = false;
			var _loc_6:* = undefined;
			var _loc_7:String = null;
			this._fld.removeEventListener(NLoaderEvent.LOAD_COMPLETE, this.urlLoadCompleteHandler);
			this._fld.removeEventListener(NLoaderEvent.LOAD_ERROR, this.urlLoadErrorHandler);
			var _loc_2:* = event.value.data;
			AS3Debugger.Trace("GetInfo::info=" + _loc_2);
			//var _loc_3:* = this.getxmlinfo(_loc_2);
			var  _loc_3:* = this.getxmlinfo(_loc_2);
			
			//有些地址不允许观看
			if (_loc_3)
			{
				GlobalVars.flvtitle = _loc_3.vl.vi.ti;
				
				
				_loc_5 = this.checkStatus(_loc_3.vl);
				if (_loc_5)
				{
					this.dispatchEvent(new VideoInfoGetterEvent(VideoInfoGetterEvent.VIDEOINFO_SUCC, {code:"succ", msg:"请求成功", info:_loc_3}));//报告请求成功,会检测返回的内容
					this._reportmode = ReportManager.createReportMode(ReportManager.STEP_GETINFO, getTimer() - this.loadtime, ReportManager.GETINFO_SUCC, 0, 0, this._vids);
					this._reportmode.vurl = this._vInfoUrl;//状态报告
					ReportManager.addReport(this._reportmode);
				}
				else
				{
					this.dispatchEvent(new VideoInfoGetterEvent(VideoInfoGetterEvent.VIDEOINFO_ERROR, {code:"error", msg:"不允许观看", codenum:0}));
				}
				
			}
			else
			{
				_loc_6 = this.checkValueable(_loc_2);
				if (!_loc_6)
				{
					this._reportmode = ReportManager.createReportMode(ReportManager.STEP_GETINFO, getTimer() - this.loadtime, ReportManager.GETINFO_UNKNOWN, 0, 0, this._vids);
					this._reportmode.vurl = this._vInfoUrl;
					ReportManager.addReport(this._reportmode);
					_loc_4 = this.createDefaultInfo();
					dispatchEvent(new VideoInfoGetterEvent(VideoInfoGetterEvent.VIDEOINFO_SUCC, {code:"default", msg:"mediaurl获取XML异常", codenum:601, info:_loc_4}));
				}
				else
				{
					this._reportmode = ReportManager.createReportMode(ReportManager.STEP_GETINFO, getTimer() - this.loadtime, ReportManager.GETINFO_CGIERROR, _loc_6.em, 0, this._vids);
					this._reportmode.vurl = this._vInfoUrl;
					ReportManager.addReport(this._reportmode, true);
					var value_arr:Array = [ -1 ,  -2 ,  -3 ,  -4 ,  -6 ,  -7 ,  50 ,  52 ,  64];
					if(value_arr.indexOf(_loc_6.em) != -1)
					{
						
						this._tryTimes = this._tryTimes + 1;
						if (this._tryTimes <= 3)
						{
							if (!this._fld)
							{
								this._fld = new FileLoader();
								this._fld.requestTimeout = 5000;
								this._fld.loadTimeout = 5000;
							}
							if (!this._fld.hasEventListener(NLoaderEvent.LOAD_COMPLETE))
							{
								this._fld.addEventListener(NLoaderEvent.LOAD_COMPLETE, this.urlLoadCompleteHandler);
								this._fld.addEventListener(NLoaderEvent.LOAD_ERROR, this.urlLoadErrorHandler);
							}
							this.loadtime = getTimer();
							this._requestInfo.ran = Math.random();
							_loc_7 = this.changeGetInfo();
							this._vInfoUrl = PlayerUtils.getVurl(_loc_7, this._requestInfo);
							this._fld.load(_loc_7, "URLRequest", URLLoaderDataFormat.TEXT, this._requestInfo, "POST");
							return;
						}
						else if (_loc_6.em == 64)
						{
							dispatchEvent(new VideoInfoGetterEvent(VideoInfoGetterEvent.VIDEOINFO_ERROR, {code:"error", msg:"不允许观看", codenum:Math.abs(_loc_6.em)}));
						}
						else
						{
							_loc_4 = this.createDefaultInfo();
							dispatchEvent(new VideoInfoGetterEvent(VideoInfoGetterEvent.VIDEOINFO_ERROR, {code:"default", msg:"mediaurl获取XML异常", codenum:Math.abs(_loc_6.em), info:_loc_4}));
						}
					}
					else
					{
						dispatchEvent(new VideoInfoGetterEvent(VideoInfoGetterEvent.VIDEOINFO_ERROR, {code:"error", msg:"不允许观看", codenum:Math.abs(_loc_6.em)}));
					}
				}
			}
			return;
		}// end function
		
		private function getxmlinfo(param1:String) : Object
		{
			var _loc_2:XML = null;
			try
			{
				_loc_2 = XML(param1);
			}
			catch (e:Error)
			{
			}
			if (_loc_2 == null)
			{
				return null;
			}
			_loc_2.ignoreWhitespace = true;
			if (String(_loc_2.s) != "o")
			{
				return null;
			}
			var _loc_3:* = XMLUtils.toObject(_loc_2);
			return _loc_3.root;
		}// end function
		
		private function checkStatus(param1:Object) : Boolean
		{
			var _loc_2:int = 0;
			if (param1.cnt == null || param1.vi == null)
			{
				return false;
			}
			if (param1.vi is Array)
			{
				if (param1.vi.length != param1.cnt * 1)
				{
					return false;
				}
				_loc_2 = 0;
				while (_loc_2 < param1.vi.length)
				{
					
					if (param1.vi[_loc_2].st != "2" && param1.vi[_loc_2].st != "8")
					{
						return false;
					}
					if (param1.vi[_loc_2].st == "8")
					{
						GlobalVars.isPreviewVideo = true;
					}
					_loc_2++;
				}
			}
			else
			{
				//这里好像可以不用..不过再看看
				if (param1.cnt != "1")
				{
					return false;
				}
				if (param1.vi.st != "2" && param1.vi.st != "8")
				{
					return false;
				}
				if (param1.vi.st == "8")
				{
					GlobalVars.isPreviewVideo = true;
				}
			}
			return true;
		}// end function
		
		
		private function checkValueable(param1:String) : Object
		{
			var _loc_2:XML = null;
			var _loc_3:Object = null;
			var _loc_4:String = null;
			try
			{
				_loc_2 = XML(param1);
			}
			catch (e:Error)
			{
			}
			if (_loc_2 == null)
			{
				return null;
			}
			_loc_2.ignoreWhitespace = true;
			if (String(_loc_2.s) == "f" && _loc_2.em != null)
			{
				_loc_3 = new Object();
				_loc_3.s = "f";
				_loc_4 = String(_loc_2.em);
				if (isNaN(Number(_loc_4)))
				{
					return null;
				}
				_loc_3.em = Number(_loc_4);
				return _loc_3;
			}
			return null;
		}// end function
		
		public static function get instance() : VideoInfoGetter
		{
			if (!_instance)
			{
				_instance = new VideoInfoGetter;
			}
			return _instance;
		}// end function
	}
}