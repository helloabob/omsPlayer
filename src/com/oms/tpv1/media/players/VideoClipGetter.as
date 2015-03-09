package com.oms.tpv1.media.players
{
	import com.koma.utils.*;
	import com.sun.events.*;
	import com.sun.net.*;
	import com.sun.utils.*;
	import com.oms.tpv1.events.*;
	import com.oms.tpv1.model.*;
	import com.oms.report.*;
	import com.oms.tpv1.utils.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;

	
	public class VideoClipGetter extends EventDispatcher
	{
		private var _currMode:VideoPlayModeV3;
		private var _fld:FileLoader;
		private var _tryTimes:int = 0;
		private var _charged:String;
		private var _requestInfo:Object;
		private const TRYMAXTIME:int = 0;
		private var _loadtime:uint;
		private var _vClipUrl:String = "";
		private var _reportmode:ReportMode;
		private var _ltime:Number = 0;
		private var _currFmt:String = "";
		private var _speed:Number = 0;
		private var _buffercount:int = 0;
		private var _currUsingP2P:Boolean = false;
		
		public function VideoClipGetter()
		{
			return;
		}// end function
		
		public function getLoadMode() : VideoPlayModeV3
		{
			return this._currMode;
		}// end function
		
		public function closeClip() : void
		{
			if (this._fld)
			{
				this._fld.close();
			}
			if (this._fld && this._fld.hasEventListener(NLoaderEvent.LOAD_COMPLETE))
			{
				this._fld.removeEventListener(NLoaderEvent.LOAD_COMPLETE, this.urlLoadCompleteHandler);
				this._fld.removeEventListener(NLoaderEvent.LOAD_ERROR, this.urlLoadErrorHandler);
			}
			return;
		}// end function
		//VIDEOCLIPGETTER动作,具体分析中
		public function getClip(param1:VideoPlayModeV3, param2:String, param3:int = 0, param4:Array = null, param5:Boolean = true, param6:Number = 0, param7:String = "", param8:Boolean = false) : void
		{
			//下载视频数据
			var _loc_15:ClSpeedMode = null;
			var _loc_16:int = 0;
			if (param1 == null || GlobalVars.enabelGetClip == false || param5 == false || param1.index == 0 || param2 == "")
			{
				AS3Debugger.Trace("getclip enabel:" + GlobalVars.enabelGetClip + ",request:" + param5 + ",idx:" + param1.index + ",fmtsel:" + param2);
				this.clipError();
				return;
			}
			this._currMode = param1;
			this._ltime = Math.floor(param6);
			this._currFmt = param7;
			this._buffercount = param3;
			this._tryTimes = 0;
			if (GlobalVars.isPayedVideo)
			{
				this._charged = "1";
			}
			else
			{
				this._charged = "0";
			}
			this._speed = 0;
			var _loc_9:* = getTimer();
			var _loc_10:uint = 0;
			var _loc_11:uint = 0;
			var _loc_12:Number = 0;
			if (param4)
			{
				_loc_16 = param4.length - 1;
				while (_loc_16 >= 0)
				{
					
					_loc_15 = param4[_loc_16];
					if (_loc_15)
					{
						if (_loc_9 - _loc_15.time < 600000)
						{
							if (_loc_15.clspeed < 8000)
							{
								_loc_10 = _loc_10 + _loc_15.getTotalBtyes();
								_loc_11 = _loc_11 + _loc_15.duration;
							}
							else
							{
								_loc_12 = _loc_15.clspeed;
								break;
							}
						}
						else
						{
							break;
						}
					}
					_loc_16 = _loc_16 - 1;
				}
				if (_loc_10 != 0 && _loc_11 != 0)
				{
					this._speed = Math.floor(_loc_10 / _loc_11);
				}
				else if (_loc_12 != 0)
				{
					this._speed = Math.floor(_loc_12);
				}
				else
				{
					this._speed = 0;
				}
			}
			if (this._speed == 0 || this._speed > 8000)
			{
				AS3Debugger.Trace("Cliperror:speed=" + this._speed);
				this.clipError();
				return;
			}
			var _loc_13:String = "1";
			if (GlobalVars.playerversion == PlayerEnum.TYPE_NORMAL || GlobalVars.playerversion == PlayerEnum.TYPE_MV)
			{
				_loc_13 = "11";
			}
			this._currUsingP2P = param8;
			var _loc_14:* = ReportManager.DLTYPE_HTTP;
			if (param8)
			{
				_loc_14 = ReportManager.DLTYPE_P2P;
			}
			this._requestInfo = {otype:"xml", platform:_loc_13, charge:this._charged, vid:param1.getVid(), idx:param1.idx, buffer:param3, speed:this._speed, fmt:param2, vt:param1.getVtype(), ran:Math.random(), ltime:this._ltime, format:param7, dltype:_loc_14};
			this._loadtime = getTimer();
			this._vClipUrl = PlayerUtils.getVurl(GlobalVars.cgi_get_videoclip, this._requestInfo);
			AS3Debugger.Trace("VideoClipGetter::Load " + this._vClipUrl);
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
			this._fld.load(GlobalVars.cgi_get_videoclip, "URLRequest", URLLoaderDataFormat.TEXT, this._requestInfo, "POST");
			return;
		}// end function
		
		private function urlLoadCompleteHandler(event:NLoaderEvent) : void
		{
			var _loc_2:String = null;
			var _loc_4:int = 0;
			this._fld.removeEventListener(NLoaderEvent.LOAD_COMPLETE, this.urlLoadCompleteHandler);
			this._fld.removeEventListener(NLoaderEvent.LOAD_ERROR, this.urlLoadErrorHandler);
			_loc_2 = event.value.data;
			AS3Debugger.Trace("VideoClipGetter::info=" + _loc_2);
			var _loc_3:* = this.getxmlinfo(_loc_2);
			if (_loc_3 && _loc_3.s == "o")
			{
				this.updateMode(_loc_3);
				this._reportmode = ReportManager.createReportModeByVideoMode(ReportManager.STEP_GETCLIP, getTimer() - this._loadtime, ReportManager.GETCLIP_SUCC, 0, 0, this._currMode);
				this._reportmode.vurl = this._vClipUrl;
				this._reportmode.buffersize = this._ltime;
				this._reportmode.loadwait = Number(this._currFmt);
				this._reportmode.bufferwait = this._speed;
				this._reportmode.bi = this._buffercount;
				if (this._currUsingP2P)
				{
					this._reportmode.dltype = ReportManager.DLTYPE_P2P;
				}
				else
				{
					this._reportmode.dltype = ReportManager.DLTYPE_HTTP;
				}
				ReportManager.addReport(this._reportmode);
			}
			else if (!_loc_3)
			{
				this._reportmode = ReportManager.createReportModeByVideoMode(ReportManager.STEP_GETCLIP, getTimer() - this._loadtime, ReportManager.GETCLIP_UNKNOWN, 0, 0, this._currMode);
				this._reportmode.vurl = this._vClipUrl;
				this._reportmode.buffersize = this._ltime;
				this._reportmode.loadwait = Number(this._currFmt);
				this._reportmode.bufferwait = this._speed;
				this._reportmode.bi = this._buffercount;
				if (this._currUsingP2P)
				{
					this._reportmode.dltype = ReportManager.DLTYPE_P2P;
				}
				else
				{
					this._reportmode.dltype = ReportManager.DLTYPE_HTTP;
				}
				ReportManager.addReport(this._reportmode);
				this.clipError();
				return;
			}
			else
			{
				_loc_4 = 601;
				if (_loc_3.em != null && !isNaN(_loc_3.em * 1))
				{
					_loc_4 = _loc_3.em * 1;
				}
				if (_loc_3.ch != null)
				{
					GlobalVars.payedVideoStatus = _loc_3.ch;
				}
				this._reportmode = ReportManager.createReportModeByVideoMode(ReportManager.STEP_GETCLIP, getTimer() - this._loadtime, ReportManager.GETCLIP_CGIERROR, _loc_4, 0, this._currMode);
				this._reportmode.vurl = this._vClipUrl;
				this._reportmode.buffersize = this._ltime;
				this._reportmode.loadwait = Number(this._currFmt);
				this._reportmode.bufferwait = this._speed;
				this._reportmode.bi = this._buffercount;
				if (this._currUsingP2P)
				{
					this._reportmode.dltype = ReportManager.DLTYPE_P2P;
				}
				else
				{
					this._reportmode.dltype = ReportManager.DLTYPE_HTTP;
				}
				ReportManager.addReport(this._reportmode, true);
				if (_loc_4 == -1 || _loc_4 == -2 || _loc_4 == -3 || _loc_4 == -4 || _loc_4 == -6 || _loc_4 == -7 || _loc_4 == 50 || _loc_4 == 52 || _loc_4 == 64 || _loc_4 == 70)
				{
					
					this._tryTimes =this._tryTimes + 1;
					if (this._tryTimes < this.TRYMAXTIME)
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
						this._loadtime = getTimer();
						this._requestInfo.ran = Math.random();
						this._fld.load(GlobalVars.cgi_get_videoclip, "URLRequest", URLLoaderDataFormat.TEXT, this._requestInfo, "POST");
						return;
					}
					else
					{
						this.clipError();
						return;
					}
				}
				else
				{
					this.clipError();
				}
			}
			return;
		}// end function
		
		private function urlLoadErrorHandler(event:NLoaderEvent) : void
		{
			
			this._tryTimes = this._tryTimes + 1;
			var _loc_2:Number = 0;
			if (event.value.code && !isNaN(event.value.code))
			{
				_loc_2 = event.value.code;
			}
			this._reportmode = ReportManager.createReportModeByVideoMode(ReportManager.STEP_GETCLIP, getTimer() - this._loadtime, ReportManager.GETCLIP_HTTPERROR, _loc_2, 0, this._currMode);
			this._reportmode.vurl = this._vClipUrl;
			this._reportmode.buffersize = this._ltime;
			this._reportmode.loadwait = Number(this._currFmt);
			this._reportmode.bufferwait = this._speed;
			this._reportmode.bi = this._buffercount;
			if (this._currUsingP2P)
			{
				this._reportmode.dltype = ReportManager.DLTYPE_P2P;
			}
			else
			{
				this._reportmode.dltype = ReportManager.DLTYPE_HTTP;
			}
			ReportManager.addReport(this._reportmode, true);
			if (this._tryTimes < this.TRYMAXTIME)
			{
				AS3Debugger.Trace("GetVideoClip::重试请求   trytime=" + this._tryTimes);
				this._loadtime = getTimer();
				this._requestInfo.ran = Math.random();
				this._fld.load(GlobalVars.cgi_get_videoclip, "URLRequest", URLLoaderDataFormat.TEXT, this._requestInfo, "POST");
				return;
			}
			this._fld.removeEventListener(NLoaderEvent.LOAD_COMPLETE, this.urlLoadCompleteHandler);
			this._fld.removeEventListener(NLoaderEvent.LOAD_ERROR, this.urlLoadErrorHandler);
			this._fld = null;
			this.clipError();
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
			var _loc_3:* = XMLUtils.toObject(_loc_2);
			return _loc_3.root;
		}// end function
		
		private function clipError() : void
		{
			AS3Debugger.Trace("VideoClipGetter::clipError");
			dispatchEvent(new VideoClipEvent(VideoClipEvent.VIDEOCLIP_ERROR));
			return;
		}// end function
		
		private function updateMode(param1:Object) : void
		{
			var _loc_4:String = null;
			var _loc_5:ModeUrl = null;
			var _loc_6:int = 0;
			if (param1 == null || param1.vi == null)
			{
				this.clipError();
				return;
			}
			AS3Debugger.Trace("VideoClipGetter::updateMode");
			var _loc_2:* = param1.vi;
			if (_loc_2.br && !isNaN(_loc_2.br * 1))
			{
				this._currMode.byteRate = _loc_2.br * 1;
			}
			if (_loc_2.ctrl == "0")
			{
				GlobalVars.enabelGetClip = false;
			}
			else
			{
				GlobalVars.enabelGetClip = true;
			}
			if (_loc_2.ch)
			{
				GlobalVars.payedVideoStatus = _loc_2.ch;
			}
			var _loc_3:Number = 0;
			if (param1.sp && !isNaN(param1.sp * 1))
			{
				_loc_3 = param1.sp * 1;
			}
			else
			{
				_loc_3 = 0;
			}
			if (_loc_2.fs && !isNaN(_loc_2.fs * 1))
			{
				this._currMode.outerBytesTotal = _loc_2.fs;
			}
			if (_loc_2.key)
			{
				this._currMode.setKeyStr(_loc_2.key, _loc_2.sha, _loc_2.level, _loc_2.levelvalid, _loc_3);
			}
			if (_loc_2.fn && _loc_2.fn != "")
			{
				_loc_4 = "";
				_loc_6 = 0;
				while (_loc_6 < this._currMode.urlArray.length)
				{
					
					_loc_5 = this._currMode.urlArray[_loc_6];
					_loc_4 = _loc_5.url.substring(_loc_5.url.indexOf("?"));
					_loc_5.url = _loc_5.orgurl + _loc_2.fn + _loc_4;
					_loc_6++;
				}
				this._currMode.updateUrlArray(this._currMode.urlArray);
			}
			if (_loc_2.fmt && _loc_2.fmtid)
			{
				this._currMode.formatName = _loc_2.fmt;
				this._currMode.setVideoFormat(_loc_2.fmtid);
			}
			GlobalVars.dicStFormat[_loc_2.fmtid] = _loc_2.sb == "0" ? (0) : (1);
			dispatchEvent(new VideoClipEvent(VideoClipEvent.VIDEOCLIP_SUCC));
			return;
		}// end function
		
		private function changeGetClip() : String
		{
			var _loc_1:* = GlobalVars.cgi_get_videoclip;
			if (GlobalVars.playertype != PlayerEnum.TYPE_QZONE)
			{
				_loc_1 = UrlPathTool.getInfoPath("getclip");
			}
			return _loc_1;
		}// end function
	}
}