package com.oms.tpv1.media.players
{
	import __AS3__.vec.*;
	
	import com.koma.utils.*;
	import com.oms.tpv1.events.*;
	import com.oms.tpv1.model.*;
	import com.oms.report.*;
	import com.oms.tpv1.utils.*;
	import com.sun.events.*;
	import com.sun.media.video.*;
	import com.sun.net.*;
	import com.sun.utils.*;
	
	import flash.net.*;
	import flash.utils.*;
	
	public class VideoPlayModeV3 extends FlvPlayModeV3
	{
		private var keyLoader:FileLoader;
		private var keyTryTimes:int = 0;
		private var keyfname:String = "";
		private var _width:Number;
		private var _height:Number;
		private var _urlPath:String = "";
		private var _requestPath:String = "";
		private var _urlArray:Vector.<ModeUrl>;
		private var _urlCount:int = 0;
		private var _filename:String = "";
		private var _keystr:String = "";
		private var _filenameSuffix:String = ".mp4";
		private var _hasKey:Boolean = false;
		public var hasCliped:Boolean = false;
		private var _buffertime:Number = 0;
		private var _waitTime:Number = 0;
		private var _playStarttime:Number = 0;
		private var _playEndtime:Number = 0;
		private var _speedtestTimecount:uint = 0;
		//private var _metadata:Metadata;
		private var _setStartTimeAfterLoad:Boolean = false;
		public var rid:String = "";
		public var requestTimeCount:Number = 0;
		public var responseTimeCount:Number = 0;
		public var payed:String = "0";
		private var _charged:String = "0";
		private var rpt_keyload:uint;
		private var _changedUrl:Boolean = false;
		private var reportObj:ReportMode;
		private var _level:String = "0";
		private var _dtc:Number = 0;
		private var clipgetter:VideoClipGetter;
		private var _vkeyUrl:String = "";
		private var _addRandom:Boolean = false;
		private var _modeLoaded:Boolean = false;
		private var _sp:int = 0;
		private var _currUsingP2P:Boolean = false;
		
		public function VideoPlayModeV3(param1:String, param2:String, param3:Number = 0)
		{
			this.vid = param2;
			this.duration = param3;
			//var _loc_4:* = param1;
			this.videoFormat = param1;//格式
			GlobalVars.currformat = param1;
			this.init();
			return;
		}// end function
		
		private function init() : void
		{
			this._buffertime = 0;
			this._waitTime = 0;
			ranSeekAbled = false;
			return;
		}// end function
		
		public function resetMode() : void
		{
			this.init();
			this._hasKey = false;
			this.hasCliped = false;
			ForceGC.gc();
			return;
		}// end function
		
		//读取视频???
		public function loadVideo(param1:Number = 0, param2:uint = 5, param3:uint = 0, param4:Boolean = false, param5:Number = 0, param6:Boolean = false, param7:Boolean = false) : void
		{
			//AS3Debugger.Trace("看看是不是每次跳动都调用了。。");
			//好像不是每次快进都调用的。。
			//不知道是从哪里调用过来的,,这里后面再跟一次看下,先去掉不用的代码先
			
			this.init();
			AS3Debugger.Trace("VideoPlayModeV3::loadVideo starttime=" + param1);
			if (GlobalVars.isPayedVideo)
			{
				this._charged = "1";
			}
			else
			{
				this._charged = "0";
			}
			this._level = "0";
			this._modeLoaded = true;
			this._addRandom = param6;
			this.rid = Guid.create();
			if (param1 < 0)
			{
				param1 = 0;
			}
			this._buffertime = param2;
			this._waitTime = param3;
			this._playStarttime = Math.floor(param1 * 100) / 100;
			this.requestTimeCount = this.getOuterEndTime() - this._playStarttime;
			if (this.requestTimeCount < 0)
			{
				this.requestTimeCount = 0;
			}
			this._currUsingP2P = param7;
			if (!this.clipgetter)
			{
				this.clipgetter = new VideoClipGetter();
			}
			if (!this.clipgetter.hasEventListener(VideoClipEvent.VIDEOCLIP_ERROR))
			{
				this.clipgetter.addEventListener(VideoClipEvent.VIDEOCLIP_ERROR, this.onClipGet);
				this.clipgetter.addEventListener(VideoClipEvent.VIDEOCLIP_SUCC, this.onClipGet);
			}
			//就是中断这里后没有了视频播放的东西，，有一个地方在调用。
			this.clipgetter.getClip(this, GlobalVars.FormatSel as String, GlobalVars.clsBufferCount, GlobalVars.arrayClspeed, param4, param5, GlobalVars.currformat as String, param7);
			return;
		}// end function
		
		private function onClipGet(event:VideoClipEvent) : void
		{
			var _loc_2:String = null;
			var _loc_3:Object = null;
			this.clipgetter.removeEventListener(VideoClipEvent.VIDEOCLIP_ERROR, this.onClipGet);
			this.clipgetter.removeEventListener(VideoClipEvent.VIDEOCLIP_SUCC, this.onClipGet);
			this.keyfname = this.getFilename();
			if (!this._hasKey)
			{
				this.keyTryTimes = 0;
				this.rpt_keyload = getTimer();
				if (!this.keyLoader)
				{
					this.keyLoader = new FileLoader();
					this.keyLoader.loadTimeout = 6000;
					this.keyLoader.requestTimeout = 6000;
				}
				if (!this.keyLoader.hasEventListener(NLoaderEvent.LOAD_COMPLETE))
				{
					this.keyLoader.addEventListener(NLoaderEvent.LOAD_COMPLETE, this.keyLoadCompleteHandler);
					this.keyLoader.addEventListener(NLoaderEvent.LOAD_ERROR, this.keyLoadErrorHandler);
				}
				_loc_2 = "1";
				if (GlobalVars.playerversion == PlayerEnum.TYPE_NORMAL || GlobalVars.playerversion == PlayerEnum.TYPE_MV)
				{
					_loc_2 = "11";
				}
				_loc_3 = {vid:this.vid, otype:"xml", platform:_loc_2, format:this.videoFormat, charge:this._charged, ran:Math.random(), filename:this.keyfname, vt:vtype};
				this._vkeyUrl = PlayerUtils.getVurl(GlobalVars.cgi_get_key, _loc_3);
				AS3Debugger.Trace("VideoPlayerModeV3::Load GetKey " + this._vkeyUrl);
				this.keyLoader.load(GlobalVars.cgi_get_key, "URLRequest", URLLoaderDataFormat.TEXT, _loc_3, "POST");
			}
			else
			{
				this.startToLoadVideo();
			}
			return;
		}// end function
		
		private function keyLoadCompleteHandler(event:NLoaderEvent) : void
		{
			var _loc_3:XML = null;
			var _loc_4:Object = null;
			var _loc_5:Number = NaN;
			var _loc_6:String = null;
			var _loc_7:String = null;
			var _loc_8:Object = null;
			this.keyLoader.removeEventListener(NLoaderEvent.LOAD_COMPLETE, this.keyLoadCompleteHandler);
			this.keyLoader.removeEventListener(NLoaderEvent.LOAD_ERROR, this.keyLoadErrorHandler);
			this.keyLoader = null;
			var _loc_2:* = event.value.data as String;
			AS3Debugger.Trace("VideoPlayModeV3::Get Key Complete=" + _loc_2);
			this._keystr = "";
			try
			{
				_loc_3 = XML(_loc_2);
				_loc_4 = XMLUtils.toObject(_loc_3).root;
				if (_loc_4 && _loc_4.s == "o" && _loc_4.key)
				{
					this._keystr = "&vkey=" + _loc_4.key;
					if (_loc_4.levelvalid == "1" && _loc_4.level != null)
					{
						this._keystr = this._keystr + ("&level=" + _loc_4.level);
						this._level = _loc_4.level;
					}
					if (_loc_4.sha != null)
					{
						this._keystr = this._keystr + ("&sha=" + _loc_4.sha);
					}
					if (_loc_4.ch != null)
					{
						GlobalVars.payedVideoStatus = _loc_4.ch;
					}
					if (_loc_4.sp && !isNaN(_loc_4.sp * 1))
					{
						this._sp = _loc_4.sp * 1;
					}
					else
					{
						this._sp = 0;
					}
					this.reportObj = ReportManager.createReportMode(ReportManager.STEP_GETKEY, getTimer() - this.rpt_keyload, ReportManager.GETKEY_SUCC, 0, 0, vid, videoFormat, this.rtype, vtype, idx, this.level, "", formatName);
					this.reportObj.rid = this.rid;
					this.reportObj.vurl = this._vkeyUrl;
					if (this._currUsingP2P)
					{
						this.reportObj.dltype = ReportManager.DLTYPE_P2P;
					}
					else
					{
						this.reportObj.dltype = ReportManager.DLTYPE_HTTP;
					}
					ReportManager.addReport(this.reportObj);
				}
				else if (_loc_4 && _loc_4.s == "f" || _loc_4 == null)
				{
					
					this.keyTryTimes = this.keyTryTimes + 1;
					_loc_5 = 0;
					if (_loc_4 != null)
					{
						_loc_5 = _loc_4.em * 1;
					}
					if (_loc_4.ch != null)
					{
						GlobalVars.payedVideoStatus = _loc_4.ch;
					}
					this.reportObj = ReportManager.createReportMode(ReportManager.STEP_GETKEY, getTimer() - this.rpt_keyload, ReportManager.GETKEY_CGIERROR, _loc_5, 0, vid, videoFormat, this.rtype, vtype, idx, this.level, "", formatName);
					this.reportObj.rid = this.rid;
					this.reportObj.vurl = this._vkeyUrl;
					if (this._currUsingP2P)
					{
						this.reportObj.dltype = ReportManager.DLTYPE_P2P;
					}
					else
					{
						this.reportObj.dltype = ReportManager.DLTYPE_HTTP;
					}
					ReportManager.addReport(this.reportObj, true);
					if (_loc_5 == -1 || _loc_5 == -2 || _loc_5 == -3 || _loc_5 == -4 || _loc_5 == -6 || _loc_5 == -7 || _loc_5 == 50 || _loc_5 == 52 || _loc_5 == 64 || _loc_5 == 70)
					{
						if (this.keyTryTimes <= 3)
						{
							if (!this.keyLoader)
							{
								this.keyLoader = new FileLoader();
							}
							if (!this.keyLoader.hasEventListener(NLoaderEvent.LOAD_COMPLETE))
							{
								this.keyLoader.addEventListener(NLoaderEvent.LOAD_COMPLETE, this.keyLoadCompleteHandler);
								this.keyLoader.addEventListener(NLoaderEvent.LOAD_ERROR, this.keyLoadErrorHandler);
							}
							this.rpt_keyload = getTimer();
							_loc_6 = "1";
							if (GlobalVars.playerversion == PlayerEnum.TYPE_NORMAL || GlobalVars.playerversion == PlayerEnum.TYPE_MV)
							{
								_loc_6 = "11";
							}
							_loc_7 = this.changeGetKey();
							_loc_8 = {vid:this.vid, otype:"xml", platform:_loc_6, format:this.videoFormat, charge:this._charged, ran:Math.random(), filename:this.keyfname, vt:vtype};
							this._vkeyUrl = PlayerUtils.getVurl(_loc_7, _loc_8);
							this.keyLoader.load(_loc_7, "URLRequest", URLLoaderDataFormat.TEXT, _loc_8, "POST");
							return;
						}
						else
						{
							this._keystr = "";
							if (_loc_5 == 64)
							{
								dispatchEvent(new FlvPlayModeV3Event(FlvPlayModeV3Event.STATUS_CHANGE, {code:"key", msg:"refesh", codenum:Math.abs(_loc_5)}));
								return;
							}
						}
					}
					else
					{
						dispatchEvent(new FlvPlayModeV3Event(FlvPlayModeV3Event.STATUS_CHANGE, {code:"key", msg:"couldnotwatch", codenum:Math.abs(_loc_5)}));
						return;
					}
				}
			}
			catch (e:Error)
			{
			}
			_loc_3 = null;
			_loc_4 = null;
			this._hasKey = true;
			this.startToLoadVideo();
			return;
		}// end function
		
		private function keyLoadErrorHandler(event:NLoaderEvent) : void
		{
			var _loc_3:String = null;
			var _loc_4:String = null;
			var _loc_5:Object = null;
			
			this.keyTryTimes = this.keyTryTimes + 1;
			var _loc_2:Number = 0;
			if (event.value.code && !isNaN(event.value.code))
			{
				_loc_2 = event.value.code;
			}
			this.reportObj = ReportManager.createReportMode(ReportManager.STEP_GETKEY, getTimer() - this.rpt_keyload, ReportManager.GETKEY_HTTPERROR, _loc_2, 0, vid, videoFormat, this.rtype, vtype, idx, this.level, "", formatName);
			this.reportObj.rid = this.rid;
			this.reportObj.vurl = this._vkeyUrl;
			if (this._currUsingP2P)
			{
				this.reportObj.dltype = ReportManager.DLTYPE_P2P;
			}
			else
			{
				this.reportObj.dltype = ReportManager.DLTYPE_HTTP;
			}
			ReportManager.addReport(this.reportObj, true);
			if (this.keyTryTimes <= 3)
			{
				AS3Debugger.Trace("VideoPlayModeV3::Get Key Error,try again..." + this.keyTryTimes);
				this.rpt_keyload = getTimer();
				_loc_3 = "1";
				if (GlobalVars.playerversion == PlayerEnum.TYPE_NORMAL || GlobalVars.playerversion == PlayerEnum.TYPE_MV)
				{
					_loc_3 = "11";
				}
				_loc_4 = this.changeGetKey();
				_loc_5 = {vid:this.vid, otype:"xml", platform:_loc_3, format:this.videoFormat, charge:this._charged, ran:Math.random(), filename:this.keyfname, vt:vtype};
				this._vkeyUrl = PlayerUtils.getVurl(_loc_4, _loc_5);
				this.keyLoader.load(_loc_4, "URLRequest", URLLoaderDataFormat.TEXT, _loc_5, "POST");
			}
			else
			{
				this.keyLoader.removeEventListener(NLoaderEvent.LOAD_COMPLETE, this.keyLoadCompleteHandler);
				this.keyLoader.removeEventListener(NLoaderEvent.LOAD_ERROR, this.keyLoadErrorHandler);
				this.keyLoader = null;
				AS3Debugger.Trace("VideoPlayModeV3::Get Key Error,try nokey playing...");
				this._keystr = "";
				this._hasKey = false;
				if (GlobalVars.isPayedVideo)
				{
					dispatchEvent(new FlvPlayModeV3Event(FlvPlayModeV3Event.STATUS_CHANGE, {code:"key", msg:"refesh", codenum:ReportManager.GETKEY_NOKEY_PAYED}));
				}
				else
				{
					this.startToLoadVideo();
				}
			}
			return;
		}// end function
		
		private function getFilename() : String
		{
			if (this._urlPath == "" || this._urlPath.indexOf("/") == -1)
			{
				return ".flv";
			}
			var _loc_1:* = this._urlPath;
			var _loc_2:* = this._urlPath.indexOf("?");
			if (_loc_2 != -1)
			{
				_loc_1 = this._urlPath.substring(0, _loc_2);
			}
			_loc_2 = _loc_1.lastIndexOf("/");
			_loc_1 = _loc_1.substring((_loc_2 + 1));
			return _loc_1;
		}// end function
		
		private function startToLoadVideo() : void
		{
			if (duration == 0 && this._playStarttime > outerStartTime)
			{
				this.unloadMetadata();
				this.startloadMetadata(this._urlPath);
			}
			else
			{
				this.startLoad();
			}
			return;
		}// end function
		
		private function unloadMetadata() : void
		{
			/*if (this._metadata)
			{
				this._metadata.unload();
			}
			if (this._metadata && this._metadata.hasEventListener(NVideoEvent.STREAM_MD))
			{
				this._metadata.removeEventListener(NVideoEvent.STREAM_MD, this.mdOkHandle);
			}
			if (this._metadata && this._metadata.hasEventListener(NVideoEvent.STREAM_ERROR))
			{
				this._metadata.removeEventListener(NVideoEvent.STREAM_ERROR, this.mdErrorHandle);
			}
			this._metadata = new Metadata();*/
			return;
		}// end function
		
		private function startloadMetadata(param1:String) : void
		{
			trace('测试第一次读取数据');
			/*if (this._metadata && !this._metadata.hasEventListener(NVideoEvent.STREAM_MD))
			{
				this._metadata.addEventListener(NVideoEvent.STREAM_MD, this.mdOkHandle);
			}
			if (this._metadata && !this._metadata.hasEventListener(NVideoEvent.STREAM_ERROR))
			{
				this._metadata.addEventListener(NVideoEvent.STREAM_ERROR, this.mdErrorHandle);
			}
			this._metadata.load(param1);*/
			return;
		}// end function
		
		private function mdOkHandle(event:NVideoEvent) : void
		{
			/*this._metadata.removeEventListener(NVideoEvent.STREAM_MD, this.mdOkHandle);
			this._metadata.removeEventListener(NVideoEvent.STREAM_ERROR, this.mdErrorHandle);*/
			this.mdGetHandler(true);
			return;
		}// end function
		
		private function mdErrorHandle(event:NVideoEvent) : void
		{
			//this._metadata.removeEventListener(NVideoEvent.STREAM_MD, this.mdOkHandle);
			//this._metadata.removeEventListener(NVideoEvent.STREAM_ERROR, this.mdErrorHandle);
			this.mdGetHandler(false);
			return;
		}// end function
		
		private function mdGetHandler(param1:Boolean) : void
		{
			//duration = this._metadata.getMetaData().duration;
			if (!param1)
			{
				this._playStarttime = outerStartTime;
			}
			this.startLoad();
			return;
		}// end function
		
		private function startLoad() : void
		{
			var _loc_3:int = 0;
			var _loc_4:int = 0;
			var _loc_1:String = "";
			if (fileType == PlayerEnum.FT_FLV)
			{
				_loc_1 = "type=tflv";
				ranSeekAbled = true;
			}
			else if (fileType == PlayerEnum.FT_MP4)
			{
				_loc_1 = "type=mp4";
				ranSeekAbled = true;
			}
			if (this._playStarttime != 0 && (fileType == PlayerEnum.FT_MP4 || fileType == PlayerEnum.FT_FLV))
			{
				startTime = this._playStarttime - outerStartTime;
				if (startTime <= 0)
				{
					startTime = 0;
				}
				if (startTime != 0)
				{
					_loc_3 = startTime;
					_loc_1 = _loc_1 + ("&start=" + _loc_3);
				}
			}
			if (this._playEndtime != 0 && this._playEndtime > this._playStarttime && (fileType == PlayerEnum.FT_MP4 || fileType == PlayerEnum.FT_FLV))
			{
				endTime = this._playEndtime - outerStartTime;
				if (startTime != 0 && endTime > startTime && endTime < this.outerDuration)
				{
					_loc_4 = endTime;
					_loc_1 = _loc_1 + ("&end=" + _loc_4);
				}
			}
			_loc_1 = _loc_1 + (this._keystr + "&platform=1&br=" + byteRate + "&fmt=" + formatName + "&sp=" + this._sp);
			if (this._addRandom)
			{
				_loc_1 = _loc_1 + ("&r=" + Math.random());
			}
			var _loc_2:String = "";
			_loc_2 = this._urlPath;
			if (_loc_1 != "")
			{
				if (this._urlPath.indexOf("?") > -1)
				{
					_loc_2 = _loc_2 + "&";
				}
				else
				{
					_loc_2 = _loc_2 + "?";
				}
				if (_loc_1.charAt(0) == "&")
				{
					_loc_1 = _loc_1.substr(1);
				}
				_loc_2 = _loc_2 + _loc_1;
			}
			this._requestPath = _loc_2;
			this._setStartTimeAfterLoad = true;
			super.load(_loc_2, this._buffertime, this._waitTime);
			return;
		}// end function
		
		override protected function mdHandler(event:StreamEvent) : void
		{
			super.mdHandler(event);
			this._width = playMetaData.width;
			this._height = playMetaData.height;
			if (this._setStartTimeAfterLoad)
			{
				startTime = Math.floor((this.outerDuration - playMetaData.duration) * 10) / 10;
				this.responseTimeCount = playMetaData.duration;
				if (startTime < 0)
				{
					startTime = 0;
				}
				this._setStartTimeAfterLoad = false;
			}
			if (playMetaData && startTime == 0)
			{
				duration = playMetaData.duration;
				playMetaData = null;
				AS3Debugger.Trace("VideoPlayMode::mdHandler " + duration);
			}
			dispatchEvent(new FlvPlayModeV3Event(FlvPlayModeV3Event.STATUS_CHANGE, {code:"getmetadata", starttime:startTime}));
			return;
		}// end function
		
		override protected function fullHandler(event:StreamEvent) : void
		{
			super.fullHandler(event);
			return;
		}// end function
		
		public function getOuterStartTime() : Number
		{
			return outerStartTime;
		}// end function
		
		public function setOuterStartTime(param1:Number) : void
		{
			this.outerStartTime = param1;
			return;
		}// end function
		
		public function getOuterEndTime() : Number
		{
			return outerEndTime;
		}// end function
		
		public function setOuterEndTime(param1:Number) : void
		{
			this.outerEndTime = param1;
			return;
		}// end function
		
		public function get width() : Number
		{
			return this._width;
		}// end function
		
		public function set width(param1:Number) : void
		{
			this._width = param1;
			return;
		}// end function
		
		public function get height() : Number
		{
			return this._height;
		}// end function
		
		public function set height(param1:Number) : void
		{
			this._height = param1;
			return;
		}// end function
		
		public function get splitIndex() : int
		{
			return splitindex;
		}// end function
		
		
		
		/*
		
		public function getItemName():String
		{
			//TODO: implement function
			return this.filename;
		}
		
		public function getBitrate():Number
		{
			//TODO: implement function
			return this.byteRate;
		}
		
		public function set itemName(val:String):void{
			//this._itemName=val;
			return;
		}
		
		public function getPosition():Number{
			//return _position;
			//return _player.modePlayTime;
			//return this.playTime;
			return 10;
		}
		
		public function getFramesPerSecond():Number{
			return 60;
		}
		
		*/
		
		
		
		
		
		public function set splitIndex(param1:int) : void
		{
			splitindex = param1;
			return;
		}// end function
		
		public function get filesize() : Number
		{
			return fileSize;
		}// end function
		
		public function set filesize(param1:Number) : void
		{
			fileSize = param1;
			return;
		}// end function
		
		public function get urlPath() : String
		{
			return this._urlPath;
		}// end function
		
		public function set urlPath(param1:String) : void
		{
			this._urlPath = param1;
			this._requestPath = param1;
			return;
		}// end function
		
		public function get filename() : String
		{
			return this._filename;
		}// end function
		
		public function set filename(param1:String) : void
		{
			this._filename = param1;
			return;
		}// end function
		
		public function getVid() : String
		{
			return vid;
		}// end function
		
		public function getVideoFormat() : String
		{
			return videoFormat;
		}// end function
		
		public function setVideoFormat(param1:String) : void
		{
			var _loc_2:* = param1;
			this.videoFormat = param1;
			GlobalVars.currformat = _loc_2;
			return;
		}// end function
		
		public function get outerDuration() : Number
		{
			return duration;
		}// end function
		
		public function set outerDuration(param1:Number) : void
		{
			duration = param1;
			return;
		}// end function
		
		public function get playStarttime() : Number
		{
			return this._playStarttime;
		}// end function
		
		public function get filenameSuffix() : String
		{
			return this._filenameSuffix;
		}// end function
		
		public function set filenameSuffix(param1:String) : void
		{
			this._filenameSuffix = param1;
			return;
		}// end function
		
		public function get playEndtime() : Number
		{
			return this._playEndtime;
		}// end function
		
		public function set playEndtime(param1:Number) : void
		{
			this._playEndtime = param1;
			return;
		}// end function
		
		public function set urlArray(param1:Vector.<ModeUrl>) : void
		{
			this._urlArray = param1;
			if (this._urlArray && this._urlArray.length > 0)
			{
				this.urlPath = this._urlArray[0].url;
				setVtype(this._urlArray[0].vt);
				fileType = this._urlArray[0].filetype;
				this._dtc = this._urlArray[0].dtc;
			}
			this._urlCount = 0;
			this.changedUrl = false;
			return;
		}// end function
		
		public function updateUrlArray(param1:Vector.<ModeUrl>) : void
		{
			this._urlArray = param1;
			if (this._urlArray && this._urlArray.length > 0)
			{
				this.urlPath = this._urlArray[this._urlCount].url;
				setVtype(this._urlArray[this._urlCount].vt);
				fileType = this._urlArray[this._urlCount].filetype;
				this._dtc = this._urlArray[this._urlCount].dtc;
			}
			return;
		}// end function
		
		public function get urlArray() : Vector.<ModeUrl>
		{
			return this._urlArray;
		}// end function
		
		public function set urlCount(param1:int) : void
		{
			this._urlCount = param1;
			return;
		}// end function
		
		public function get urlCount() : int
		{
			return this._urlCount;
		}// end function
		
		public function changeUrl(param1:Boolean = true) : void
		{
			if (param1)
			{
				this.changedUrl = true;
			}
			
			this._urlCount = this._urlCount + 1;
			if (this._urlCount > (this._urlArray.length - 1))
			{
				this._urlCount = 0;
			}
			this.urlPath = this._urlArray[this._urlCount].url;
			setVtype(this._urlArray[this._urlCount].vt);
			fileType = this._urlArray[this._urlCount].filetype;
			this._dtc = this._urlArray[this._urlCount].dtc;
			this.resetMode();
			return;
		}// end function
		
		public function copy(param1:VideoPlayModeV3) : void
		{
			if (param1)
			{
				this.setOuterStartTime(param1.getOuterStartTime());
				this.setOuterEndTime(param1.getOuterEndTime());
				this.width = param1.width;
				this.height = param1.height;
				this.filesize = param1.filesize;
				vid = param1.getVid();
				var _loc_2:* = param1.getVideoFormat();
				videoFormat = param1.getVideoFormat();
				GlobalVars.currformat = _loc_2;
				this.outerDuration = param1.outerDuration;
				fileType = param1.fileType;
				this.urlPath = param1.urlPath;
				this.filename = param1.filename;
				this.filenameSuffix = param1.filenameSuffix;
			}
			return;
		}// end function
		
		public function get changedUrl() : Boolean
		{
			return this._changedUrl;
		}// end function
		
		public function set changedUrl(param1:Boolean) : void
		{
			this._changedUrl = param1;
			return;
		}// end function
		
		override public function close(param1:Boolean = false) : void
		{
			if (this.clipgetter)
			{
				if (this.clipgetter.hasEventListener(VideoClipEvent.VIDEOCLIP_ERROR))
				{
					this.clipgetter.removeEventListener(VideoClipEvent.VIDEOCLIP_ERROR, this.onClipGet);
					this.clipgetter.removeEventListener(VideoClipEvent.VIDEOCLIP_SUCC, this.onClipGet);
				}
				this.clipgetter.closeClip();
			}
			if (this.keyLoader)
			{
				if (this.keyLoader.hasEventListener(NLoaderEvent.LOAD_COMPLETE))
				{
					this.keyLoader.removeEventListener(NLoaderEvent.LOAD_COMPLETE, this.keyLoadCompleteHandler);
					this.keyLoader.removeEventListener(NLoaderEvent.LOAD_ERROR, this.keyLoadErrorHandler);
				}
				this.keyLoader.close();
				this.keyLoader = null;
			}
			super.close(param1);
			return;
		}// end function
		
		public function get level() : String
		{
			return this._level;
		}// end function
		
		public function get requestPath() : String
		{
			if (this._requestPath == "")
			{
				return this._urlPath;
			}
			return this._requestPath;
		}// end function
		
		public function get dtc() : Number
		{
			return this._dtc;
		}// end function
		
		public function clone() : Object
		{
			var _loc_1:* = new Object();
			_loc_1.clspeed = dlSpeed;
			_loc_1.vid = this.getVid();
			_loc_1.vt = getVtype();
			_loc_1.format = this.getVideoFormat();
			_loc_1.idx = idx;
			_loc_1.type = rtype;
			_loc_1.vurl = this.requestPath;
			_loc_1.buffersize = buffersize;
			_loc_1.rid = this.rid;
			_loc_1.bi = this.requestTimeCount;
			_loc_1.level = this.level;
			_loc_1.urlPath = this.urlPath;
			_loc_1.dtc = this.dtc;
			return _loc_1;
		}// end function
		
		public function setKeyStr(param1:String, param2:String = "", param3:String = "", param4:String = "1", param5:Number = 0) : void
		{
			if (param1 == "" || param1 == null)
			{
				return;
			}
			this._hasKey = true;
			this._keystr = "&vkey=" + param1;
			if (param2 != "" && param2 != null)
			{
				this._keystr = this._keystr + ("&sha=" + param2);
			}
			if (param3 != "" && param3 != null && param4 == "1")
			{
				this._keystr = this._keystr + ("&level=" + param3);
				this._level = param3;
			}
			if (!isNaN(param5))
			{
				this._sp = param5;
			}
			else
			{
				this._sp = 0;
			}
			return;
		}// end function
		
		private function changeGetKey() : String
		{
			var _loc_1:* = GlobalVars.cgi_get_key;
			if (GlobalVars.playertype != PlayerEnum.TYPE_QZONE)
			{
				_loc_1 = UrlPathTool.getInfoPath("getkey");
			}
			return _loc_1;
		}// end function
		
		public function get modeLoaded() : Boolean
		{
			return this._modeLoaded;
		}// end function
		
	}
}