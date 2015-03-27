package com.oms.tpv1.media.players
{
	import __AS3__.vec.*;
	
	import com.oms.tpv1.events.*;
	import com.oms.tpv1.managers.*;
	import com.oms.tpv1.media.stream.*;
	import com.oms.tpv1.model.*;
	import com.oms.tpv1.utils.*;
	import com.oms.utils.timer.*;
	import com.oms.videov3.media.*;
	import com.sun.media.video.*;
	import com.sun.utils.*;
	
	import flash.events.*;
	import flash.media.*;
	import flash.net.*;
	import flash.utils.*;
	
	public class FlvPlayModeV3 extends EventDispatcher
	{
		private var _nsPlayStatus:String = "init";
		private var _nsLoadStatus:String = "unload";
		private var _stream:IVideoStream;
		private var _volume:Number = 80;
		protected var outerStartTime:Number = 0;
		protected var outerEndTime:Number = 0;
		protected var splitindex:int = 0;
		private var _startTime:Number = 0;
		private var _endTime:Number = 0;
		private var _fileType:int = 0;
		private var _flvPath:String = "";
		private var _waittime:Number = 0;
		private var _buffersize:Number = 6;
		protected var loadtime:uint;
		protected var readytime:uint;
		protected var startToPlayTime:uint;
		protected var loadovertime:uint;
		public var userWaittime:uint;
		public var userWaitlasttime:uint;
		protected var readyBytes:Number;
		protected var startToPlayBytes:Number;
		protected var videoStarted:Boolean = false;
		protected var p2pReadyBytes:Number = 0;
		protected var p2pPlayBytes:Number = 0;
		protected var cdnReadyBytes:Number = 0;
		protected var cdnPlayBytes:Number = 0;
		private var p2p_lastBytes:Number = 0;
		private var p2p_nowBytes:Number = 0;
		private var cdn_lastBytes:Number = 0;
		private var cdn_nowBytes:Number = 0;
		public var emptyTime:uint;
		protected var fullTime:uint;
		public var emptyCount:int = 0;
		private var _timeoutCount:uint = 0;
		private var _timeoutMax:Number = 30000;
		private var _playTimeoutMax:Number = 30000;
		protected var duration:Number = 0;
		protected var fileSize:Number = 0;
		public var outerBytesTotal:Number = 0;
		private var waitTimeoutCount:uint = 0;
		protected var playMetaData:Object;
		private var playDuration:Number = 0;
		public var minEmptytime:uint = 40;
		public var maxEmptytime:uint = 3000;
		private var emptyTimeout:uint = 0;
		private var _hasClosed:Boolean = false;
		private var _isSeeking:Boolean = false;
		public var ranSeekAbled:Boolean = false;
		private var _timer:TPTimer;
		private var _streamLoadCompleted:Boolean = false;
		public var index:int = 0;
		public var idx:int = 0;
		public var rtype:String = "0";
		private var lowspeedCount:int = 0;
		private var ls_lastbyteLoad:uint = 0;
		private var ls_nowbyteLoad:uint = 0;
		private var timerMaxCount:int = 2;
		private var timercount:int = 0;
		public var byteRate:Number;
		private var _formatName:String = "";
		private var _dlSpeed:Number = 0;
		private var _dllastByte:Number = 0;
		protected var vid:String = "";
		protected var videoFormat:String = "";
		protected var vtype:Number;
		private var maxBuffertime:int = 10;
		private var _seekpoints:Vector.<SeekPoint>;
		private var downloadtime:uint;
		private var callCompleteError:Boolean = false;
		private var callCompleteErrorCount:uint = 0;
		
		public function FlvPlayModeV3()
		{
			return;
		}// end function
		
		public function get netstream() : NetStream
		{
			if (!this._stream)
			{
				return null;
			}
			return this._stream.stream;
		}// end function
		
		public function get volume() : Number
		{
			return this._volume;
		}// end function
		
		public function set volume(param1:Number) : void
		{
			this._volume = param1;
			try
			{
				this._stream.volume = param1;
			}
			catch (e:Error)
			{
			}
			return;
		}// end function
		
		public function getVtype() : Number
		{
			return this.vtype;
		}// end function
		
		public function setVtype(param1:Number) : void
		{
			this.vtype = param1;
			return;
		}// end function
		
		public function get readyToPlay() : Boolean
		{
			if (!this._stream)
			{
				return false;
			}
			return this._stream.readyToPlay;
		}// end function
		
		public function get fileType() : int
		{
			return this._fileType;
		}// end function
		
		public function set fileType(param1:int) : void
		{
			this._fileType = param1;
			if (param1 == PlayerEnum.FT_UNKNOW)
			{
				this.ranSeekAbled = false;
			}
			else
			{
				this.ranSeekAbled = true;
			}
			return;
		}// end function
		
		public function get playTime() : Number
		{
			if (!this._stream)
			{
				return this._startTime + this.outerStartTime;
			}
			if (this._fileType == PlayerEnum.FT_MP4)
			{
				return this.outerStartTime + this._startTime + this._stream.playTime;
			}
			
			return this.outerStartTime + this._stream.playTime; ;
		}// end function
		
		public function get modePlayTime() : Number
		{
			if (!this._stream)
			{
				return this._startTime;
			}
			if (this._fileType == PlayerEnum.FT_MP4)
			{
				return this._startTime + this._stream.playTime;
			}
			return this._stream.playTime;
		}// end function
		
		public function get modeLeftPlayTime() : Number
		{
			if (!this._stream)
			{
				return this.duration;
			}
			return this.duration - this.modePlayTime;
		}// end function
		
		public function get relPlayTime() : Number
		{
			if (!this._stream)
			{
				return 0;
			}
			return this._stream.playTime;
		}// end function
		
		public function get loadPosition() : Number
		{
			if (!this._stream)
			{
				return 0;
			}
			return this._stream.getLoadedPercent();
		}// end function
		
		public function get bytesLoaded() : Number
		{
			if (!this._stream)
			{
				return 0;
			}
			return this._stream.bytesLoaded;
		}// end function
		
		public function get bytesTotal() : Number
		{
			if (!this._stream)
			{
				return 0;
			}
			return this._stream.bytesTotal;
		}// end function
		
		public function get bufferPercent() : Number
		{
			if (!this._stream)
			{
				return 0;
			}
			return this._stream.bufferPercent;
		}// end function
		
		public function get bufferPerToPlay() : Number
		{
			if (!this._stream)
			{
				return 0;
			}
			return this._stream.bufferPerToPlay;
		}// end function
		
		public function get bufferLength() : Number
		{
			if (!this._stream)
			{
				return 0;
			}
			return this._stream.bufferLength;
		}// end function
		
		public function get startTime() : Number
		{
			return this._startTime;
		}// end function
		
		public function set startTime(param1:Number) : void
		{
			this._startTime = param1;
			return;
		}// end function
		
		public function get seekpoints() : Vector.<SeekPoint>
		{
			return this._seekpoints;
		}// end function
		
		public function initStreamFactory() : void
		{
			this._stream = StreamFactory.instance.getStream(0, {vid:this.vid, resolution:this.videoFormat, clipNo:this.idx});//创建流,需要ID,格式,索引三个变量,后面的变量是针对P2P技术
			return;
		}// end function
		
		protected function load(param1:String, param2:uint = 2, param3:uint = 0) : void
		{
			this._hasClosed = false;
			if (this._stream == null)
			{
				this._stream = StreamFactory.instance.getStream(0);
			}
			this._flvPath = param1;
			this._nsPlayStatus = FlvPlayMode_Status.PLAY_STATUS_INIT;
			this._nsLoadStatus = FlvPlayMode_Status.LOAD_STATUS_UNLOAD;
			this.videoStarted = false;
			var _loc_4:int = 0;
			this.emptyCount = 0;
			GlobalVars.clsBufferCount = _loc_4;
			this._waittime = param3;
			this._buffersize = param2;
			this.readytime = 0;
			this.startToPlayTime = 0;
			this.readyBytes = 0;
			this.startToPlayBytes = 0;
			this.p2pReadyBytes = 0;
			this.p2pPlayBytes = 0;
			this.cdnReadyBytes = 0;
			this.cdnPlayBytes = 0;
			this.lowspeedCount = 0;
			this.timercount = 0;
			this.ls_lastbyteLoad = 0;
			this._dllastByte = 0;
			this.loadovertime = 0;
			this.callCompleteError = true;
			//var _loc_4:* = getTimer();
			this.loadtime = getTimer();
//			var _loc_4:* = _loc_4;
			this.userWaittime = getTimer();
			this.userWaitlasttime =getTimer();
			clearTimeout(this._timeoutCount);
			this._timeoutCount = setTimeout(this.timeoutHandler, this._timeoutMax, 1);
//			这里开始载入
			AS3Debugger.Trace("FlvPlayModeV3::load " + param1);
			
			this.addStreamEvents();
			this._stream.load({path:param1, buffer:param2, vid:this.vid, resolution:this.videoFormat, clipNo:this.idx, rtype:this.rtype, vt:this.vtype});
			if (!this._timer)
			{
				this._timer = TPTimer.setInterval(this.timerhandler, 500);
				this._timer.stop();
			}
			this._streamLoadCompleted = false;
			dispatchEvent(new FlvPlayModeV3Event(FlvPlayModeV3Event.STATUS_CHANGE, {code:"startToLoad"}));
			return;
		}// end function
		
		private function timerhandler() : void
		{
			
			var _loc_2:uint = 0;
			var _loc_1:Number = 0;
			if (this.loadPosition == 1 && !this._streamLoadCompleted)
			{
				this._streamLoadCompleted = true;
				this._dlSpeed = 0;
				if (this._timer.isRunning())
				{
					this._timer.stop();
				}
				_loc_2 = getTimer();
				_loc_1 = (this._stream.bytesTotal - this.ls_nowbyteLoad) / 1024 / (_loc_2 - this.downloadtime) * 1000;
				if (this.usingP2P && this._stream.P2PData)
				{
					if (this._stream.P2PData.P2PDownloadBytes)
					{
						this.p2p_nowBytes = this._stream.P2PData.P2PDownloadBytes;
					}
					if (this._stream.P2PData.CDNDownloadBytes)
					{
						this.cdn_nowBytes = this._stream.P2PData.CDNDownloadBytes;
					}
					_loc_1 = Math.floor((this.p2p_nowBytes - this.p2p_lastBytes) / 1024 / (this.timerMaxCount * 0.5) + (this.cdn_nowBytes - this.cdn_lastBytes) / 1024 / (this.timerMaxCount * 0.5));
				}
				if (_loc_1 > 0)
				{
					GlobalVars.clspeed = _loc_1;
					PlayerUtils.pushMaxLenArray(GlobalVars.arrayClspeed, new ClSpeedMode(_loc_1, _loc_2, _loc_2 - this.downloadtime), GlobalVars.arrayClspeedMaxLen);
				}
				this.loadovertime = getTimer();
				if (this.usingP2P && this._stream.P2PData)
				{
					this.p2p_lastBytes = this.p2p_nowBytes;
					this.cdn_lastBytes = this.cdn_nowBytes;
				}
				dispatchEvent(new FlvPlayModeV3Event(FlvPlayModeV3Event.STATUS_CHANGE, {code:"loadComplete"}));
			}
			else
			{
				if (this._dllastByte <= this._stream.bytesLoaded)
				{
					if (this._dllastByte != 0)
					{
						this._dlSpeed = (this._stream.bytesLoaded - this._dllastByte) / 1024 / 0.5;
					}
					this._dllastByte = this._stream.bytesLoaded;
				}
				if (this.loadPosition < 1 && this.loadPosition >= 0)
				{
					
					this.timercount =this.timercount + 1;
					if (this.timercount >= this.timerMaxCount)
					{
						this.timercount = 0;
						this.downloadtime = getTimer();
						this.ls_nowbyteLoad = this._stream.bytesLoaded;
						_loc_1 = Math.floor((this.ls_nowbyteLoad - this.ls_lastbyteLoad) / 1024 / (this.timerMaxCount * 0.5));
						if (this.usingP2P && this._stream.P2PData)
						{
							if (this._stream.P2PData.P2PDownloadBytes)
							{
								this.p2p_nowBytes = this._stream.P2PData.P2PDownloadBytes;
							}
							if (this._stream.P2PData.CDNDownloadBytes)
							{
								this.cdn_nowBytes = this._stream.P2PData.CDNDownloadBytes;
							}
							_loc_1 = Math.floor((this.p2p_nowBytes - this.p2p_lastBytes) / 1024 / (this.timerMaxCount * 0.5) + (this.cdn_nowBytes - this.cdn_lastBytes) / 1024 / (this.timerMaxCount * 0.5));
						}
						if (_loc_1 > 0)
						{
							GlobalVars.clspeed = _loc_1;
							PlayerUtils.pushMaxLenArray(GlobalVars.arrayClspeed, new ClSpeedMode(_loc_1, this.downloadtime, this.timerMaxCount * 0.5 * 1000), GlobalVars.arrayClspeedMaxLen);
						}
						//VideoNetSpeedUtil.saveVideoSpeed2(_loc_1, this.videoFormat, GlobalVars.pid, this.duration, this.vid, this.vtype, GlobalVars.currip);
						this.ls_lastbyteLoad = this.ls_nowbyteLoad;
						if (this.usingP2P && this._stream.P2PData)
						{
							this.p2p_lastBytes = this.p2p_nowBytes;
							this.cdn_lastBytes = this.cdn_nowBytes;
						}
					}
				}
			}
			return;
		}// end function
		
		
		
		private function timeoutHandler(param1:int = 0) : void
		{
			if (this._stream)
			{
				this._timeoutCount = 0;
				this._stream.closeStream();
				this.errorHandler(null, param1);
			}
			return;
		}// end function
		
		
		
		private function addStreamEvents() : void
		{
			this._stream.addEventListener(StreamEvent.STREAM_READY, this.readyHandler);
			this._stream.addEventListener(StreamEvent.STREAM_START_PLAY, this.startToPlayHandler);
			this._stream.addEventListener(StreamEvent.STREAM_MD, this.mdHandler);
			this._stream.addEventListener(StreamEvent.STREAM_NC_ERROR, this.errorHandler);
			this._stream.addEventListener(StreamEvent.STREAM_ERROR, this.errorHandler);
			this._stream.addEventListener(StreamEvent.STREAM_404, this.error404Handler);
			return;
		}// end function
		
		private function removeStreamEvents() : void
		{
			this._stream.removeEventListener(StreamEvent.STREAM_READY, this.readyHandler);
			this._stream.removeEventListener(StreamEvent.STREAM_START_PLAY, this.startToPlayHandler);
			this._stream.removeEventListener(StreamEvent.STREAM_MD, this.mdHandler);
			this._stream.removeEventListener(StreamEvent.STREAM_NC_ERROR, this.errorHandler);
			this._stream.removeEventListener(StreamEvent.STREAM_ERROR, this.errorHandler);
			this._stream.removeEventListener(StreamEvent.STREAM_STOP, this.playComplete);
			this._stream.removeEventListener(StreamEvent.STREAM_EMPTY, this.emptyHandler);
			this._stream.removeEventListener(StreamEvent.STREAM_FULL, this.fullHandler);
			this._stream.removeEventListener(StreamEvent.STREAM_404, this.error404Handler);
			return;
		}// end function
		
		protected function readyHandler(event:StreamEvent) : void
		{
			clearTimeout(this._timeoutCount);
			this._timeoutCount = setTimeout(this.timeoutHandler, this._playTimeoutMax, 2);
			this._stream.removeEventListener(StreamEvent.STREAM_READY, this.readyHandler);
			this._nsLoadStatus = FlvPlayMode_Status.LOAD_STATUS_LOADING;
			this._nsPlayStatus = FlvPlayMode_Status.PLAY_STATUS_PLAYING;
			this.readytime = getTimer();
			var _loc_2:* = this._stream.bytesLoaded;
			this.readyBytes = this._stream.bytesLoaded;
			this.ls_nowbyteLoad = _loc_2;
			if (this.usingP2P && this._stream.P2PData)
			{
				if (this._stream.P2PData.P2PDownloadBytes)
				{
					this.p2pReadyBytes = this._stream.P2PData.P2PDownloadBytes;
				}
				if (this._stream.P2PData.CDNDownloadBytes)
				{
					this.cdnReadyBytes = this._stream.P2PData.CDNDownloadBytes;
				}
			}
			this.fileSize = this._stream.bytesTotal;
			this._stream.volume = this._volume;
			this._stream.addEventListener(StreamEvent.STREAM_STOP, this.playComplete);
			this._stream.seek(0);
			if (this._timer && !this._timer.isRunning())
			{
				this._timer.restart();
			}
			this.downloadtime = getTimer();
			dispatchEvent(new FlvPlayModeV3Event(FlvPlayModeV3Event.STATUS_CHANGE, {code:"ready"}));
			return;
		}// end function
		
		protected function startToPlayHandler(event:StreamEvent) : void
		{
			var time:Number;
			clearTimeout(this._timeoutCount);
			this._stream.removeEventListener(StreamEvent.STREAM_START_PLAY, this.startToPlayHandler);
			if (!this._stream.hasEventListener(StreamEvent.STREAM_EMPTY))
			{
				this._stream.addEventListener(StreamEvent.STREAM_EMPTY, this.emptyHandler);
				this._stream.addEventListener(StreamEvent.STREAM_FULL, this.fullHandler);
			}
			this._nsPlayStatus = FlvPlayMode_Status.PLAY_STATUS_PLAYING;
			clearTimeout(this.waitTimeoutCount);
			this.startToPlayTime = getTimer();
			this.startToPlayBytes = this._stream.bytesLoaded;
			this.videoStarted = true;
			var curspeed:* = Math.floor((this.startToPlayBytes - this.readyBytes) / 1024 / ((this.startToPlayTime - this.readytime) / 1000));
			if (this.usingP2P && this._stream.P2PData)
			{
				if (this._stream.P2PData.P2PDownloadBytes)
				{
					this.p2pPlayBytes = this._stream.P2PData.P2PDownloadBytes;
				}
				if (this._stream.P2PData.CDNDownloadBytes)
				{
					this.cdnPlayBytes = this._stream.P2PData.CDNDownloadBytes;
				}
				curspeed = Math.floor((this.p2pPlayBytes - this.p2pReadyBytes) / 1024 / ((this.startToPlayTime - this.readytime) / 1000)) + Math.floor((this.cdnPlayBytes - this.cdnReadyBytes) / 1024 / ((this.startToPlayTime - this.readytime) / 1000));
			}
			if (curspeed > 0)
			{
				GlobalVars.clspeed = curspeed;
				PlayerUtils.pushMaxLenArray(GlobalVars.arrayClspeed, new ClSpeedMode(GlobalVars.clspeed, this.startToPlayTime, this.startToPlayTime - this.readytime), GlobalVars.arrayClspeedMaxLen);
			}
			var loaddura:* = this.startToPlayTime - this.loadtime;
			if (this.duration < 600)
			{
				this._waittime = 0;
			}
			//VideoNetSpeedUtil.saveVideoSpeed2(GlobalVars.clspeed, this.videoFormat, GlobalVars.pid, this.duration, this.vid, this.vtype, GlobalVars.currip);
			if (this._waittime != 0)
			{
				this._stream.pause();
				time = this._waittime * 1000 - loaddura;
				if (time < 0)
				{
					time;
				}
				this.waitTimeoutCount = setTimeout(function ():void
				{
					_waittime = 0;
					_stream.seek(0);
					_stream.resume();
					dispatchEvent(new FlvPlayModeV3Event(FlvPlayModeV3Event.STATUS_CHANGE, {code:"startToPlay"}));
					return;
				}// end function
					, time);
			}
			else
			{
				dispatchEvent(new FlvPlayModeV3Event(FlvPlayModeV3Event.STATUS_CHANGE, {code:"startToPlay"}));
			}
			AS3Debugger.Trace("FlvPlayMode::startToPlayHandler");
			return;
		}// end function
		
		protected function mdHandler(event:StreamEvent) : void
		{
			
			this.metadataFormat(event.value);
			
			return;
		}// end function
		
		private function metadataFormat(param1:Object) : void
		{
			this._seekpoints = this.getSeekPoints(param1);
			if (!this.playMetaData)
			{
				this.playMetaData = new Object();
			}
			if (isNaN(param1.width * 1) || param1.width * 1 <= 0)
			{
				this.playMetaData.width = 320;
			}
			else
			{
				this.playMetaData.width = param1.width;
			}
			if (isNaN(param1.height * 1) || param1.height * 1 <= 0)
			{
				this.playMetaData.height = 240;
			}
			else
			{
				this.playMetaData.height = param1.height;
			}
			if (isNaN(param1.duration * 1) || param1.duration * 1 <= 0)
			{
				this.playMetaData.duration = 0;
			}
			else
			{
				this.playMetaData.duration = param1.duration;
			}
			this.playDuration = this.playMetaData.duration;
			param1 = null;
			return;
		}// end function
		
		private function getSeekPoints(param1:Object) : Vector.<SeekPoint>
		{
			var _loc_3:uint = 0;
			var _loc_4:SeekPoint = null;
			var _loc_6:Array = null;
			var _loc_7:Array = null;
			var _loc_8:* = undefined;
			var _loc_2:* = new Vector.<SeekPoint>;
			var _loc_5:uint = 0;
			if (param1["keyframes"])
			{
				if (param1["keyframes"]["filepositions"] && param1["keyframes"]["times"])
				{
					_loc_3 = param1["keyframes"]["filepositions"].length;
					_loc_6 = param1["keyframes"]["times"];
					_loc_7 = param1["keyframes"]["filepositions"];
					_loc_5 = 0;
					while (_loc_5 < _loc_3)
					{
						
						_loc_4 = new SeekPoint();
						_loc_4.time = _loc_6[_loc_5];
						_loc_4.offset = _loc_7[_loc_5];
						_loc_2.push(_loc_4);
						_loc_5 = _loc_5 + 1;
					}
				}
			}
			if (param1["seekpoints"])
			{
				_loc_8 = param1["seekpoints"];
				_loc_3 = param1["seekpoints"].length;
				_loc_5 = 0;
				while (_loc_5 < _loc_3)
				{
					
					_loc_4 = new SeekPoint();
					_loc_4.time = _loc_8[_loc_5].time;
					_loc_4.offset = _loc_8[_loc_5].offset;
					_loc_2.push(_loc_4);
					_loc_5 = _loc_5 + 1;
				}
			}
			return _loc_2;
		}// end function
		
		protected function errorHandler(event:StreamEvent, param2:int = 0) : void
		{
			var _loc_3:* = undefined;
			clearTimeout(this._timeoutCount);
			if (event != null)
			{
				_loc_3 = event.value;
			}
			else
			{
				_loc_3 = "requesttimeout";
			}
			AS3Debugger.Trace("FlvPlayMode::errorHandler=" + _loc_3);
			this.removeStreamEvents();
			this._stream.closeStream();
			dispatchEvent(new FlvPlayModeV3Event(FlvPlayModeV3Event.STATUS_CHANGE, {code:"error", type:param2}));
			return;
		}// end function
		
		protected function error404Handler(event:StreamEvent) : void
		{
			clearTimeout(this._timeoutCount);
			AS3Debugger.Trace("FlvPlayMode::error404Handler");
			this.removeStreamEvents();
			this._stream.closeStream();
			dispatchEvent(new FlvPlayModeV3Event(FlvPlayModeV3Event.STATUS_CHANGE, {code:"error", type:0}));
			return;
		}// end function
		
		protected function playComplete(event:StreamEvent) : void
		{
			if (!this._isSeeking)
			{
				if (this._stream.hasEventListener(StreamEvent.STREAM_EMPTY))
				{
					this._stream.removeEventListener(StreamEvent.STREAM_EMPTY, this.emptyHandler);
					this._stream.removeEventListener(StreamEvent.STREAM_FULL, this.fullHandler);
				}
				this.stop();
				if (this.callCompleteError && this.modePlayTime > 0 && this.duration > 0 && this.duration - this.modePlayTime > 10 && this.callCompleteErrorCount < 3)
				{
					this.callCompleteError = false;
					
					this.callCompleteErrorCount = this.callCompleteErrorCount + 1;
					dispatchEvent(new FlvPlayModeV3Event(FlvPlayModeV3Event.STATUS_CHANGE, {code:"playCompleteError"}));
					return;
				}
				dispatchEvent(new FlvPlayModeV3Event(FlvPlayModeV3Event.STATUS_CHANGE, {code:"playComplete"}));
			}
			else
			{
				this._nsPlayStatus = FlvPlayMode_Status.PLAY_SEEK_STOP;
			}
			if (this._timer && this._timer.isRunning())
			{
				this._timer.stop();
			}
			return;
		}// end function
		
		protected function emptyHandler(event:StreamEvent) : void
		{
			this.emptyTime = getTimer();
			
			this.emptyCount = this.emptyCount + 1;
			GlobalVars.clsBufferCount = this.emptyCount;
			dispatchEvent(new FlvPlayModeV3Event(FlvPlayModeV3Event.STATUS_CHANGE, {code:"empty"}));
			AS3Debugger.Trace("FlvPlayMode::emptyHandler");
			return;
		}// end function
		
		protected function fullHandler(event:StreamEvent) : void
		{
			var event:* = event;
			this.fullTime = getTimer();
			var waitEmptyTime:* = this.fullTime - this.emptyTime;
			if (this.emptyCount > 1 && waitEmptyTime > this.minEmptytime && waitEmptyTime < this.maxEmptytime)
			{
				this._stream.pause();
				setTimeout( function () : void
				{
					if (_nsPlayStatus == FlvPlayMode_Status.PLAY_STATUS_PLAYING)
					{
						_stream.resume();
					}
					return;
				}// end function
				,20
				);
					
				/*with ({})
				{
				this.timeout = function () : void
				{
				if (_nsPlayStatus == FlvPlayMode_Status.PLAY_STATUS_PLAYING)
				{
				_stream.resume();
				}
				return;
				}// end function
				;
				}*/
				
				
				if (_nsPlayStatus == FlvPlayMode_Status.PLAY_STATUS_PLAYING)
				{
					_stream.resume();
					return;
				}
				
				
				this.emptyTimeout = setTimeout(function () : void
				{
					if (_nsPlayStatus == FlvPlayMode_Status.PLAY_STATUS_PLAYING)
					{
						_stream.resume();
					}
					return;
				}// end function
					, this.maxEmptytime - waitEmptyTime);
			}
			if (this._buffersize < this.maxBuffertime)
			{
				
				this._stream.bufferTime = this._buffersize;
			}
			dispatchEvent(new FlvPlayModeV3Event(FlvPlayModeV3Event.STATUS_CHANGE, {code:"full", emptyTime:waitEmptyTime}));
			AS3Debugger.Trace("FlvPlayMode::fullHandler");
			return;
		}// end function
		
		public function play() : void
		{
			if (this._nsPlayStatus == FlvPlayMode_Status.PLAY_STATUS_INIT)
			{
				return;
			}
			if (this._stream.readyToPlay)
			{
				if (this._nsPlayStatus == FlvPlayMode_Status.PLAY_STATUS_STOP)
				{
					this._stream.seek(0);
				}
				this._stream.resume();
			}
			this._nsPlayStatus = FlvPlayMode_Status.PLAY_STATUS_PLAYING;
			return;
		}// end function
		
		//这里少了一些代码.去掉一些代码
		public function resume(param1:Number = -1, param2:Function = null, param3:Number = 30, param4:Number = 8, param5:Boolean = false):void
		{
			/*if (!this._stream || !this._stream.readyToPlay)
			{
				return;
			}
			this._stream.resume();
			
			
			this._nsPlayStatus = FlvPlayMode_Status.PLAY_STATUS_PLAYING;*/
			
			
			
			
			/*
			
			
			
			var time:* = param1;
			var closure:* = param2;
			var delay:* = param3;
			var delayCall:* = param4;
			var forceGc:* = param5;
			
			
			AS3Debugger.Trace("FlvPlayMode::resume   time=" + time);
			if (this._stream && this._stream.readyToPlay)
			{
				if (time == -1)
				{
					this._stream.resume();
					this._nsPlayStatus = FlvPlayMode_Status.PLAY_STATUS_PLAYING;
					//测试添加消息通知
					//日你老仙人。。终于找到是这里的原因了。
					if (closure != null){
						setTimeout(function () : void{
							closure.call(forceGc);
							return;
						}// end function
							, delayCall);
					}
				
					return;
				}
				this._stream.startToChange();
				this._nsPlayStatus = FlvPlayMode_Status.PLAY_STATUS_PLAYING;
				
				setTimeout(function () : void
					{
						time = time - outerStartTime;
						if (_fileType == PlayerEnum.FT_MP4)
						{
							time = time - startTime;
						}
						if (time < 0)
						{
							time = 0;
						}
						_stream.seek(time);
						_stream.resume();
						
						return;
					},20);
				
				setTimeout(function () : void
				{
					time = time - outerStartTime;
					if (_fileType == PlayerEnum.FT_MP4)
					{
						time = time - startTime;
					}
					if (time < 0)
					{
						time = 0;
					}
					_stream.seek(time);
					_stream.resume();
					
					return;
				}// end function
					, delay);
				
				
			}
			return;
			
			*/
			
			
			var time:* = param1;
			//var param2:* = param2;
			var delay:* = param3;
			var delayCall:* = param4;
			AS3Debugger.Trace("FlvPlayMode::resume   time=" + time);
			if (this._stream && this._stream.readyToPlay)
			{
				if (time == -1)
				{
					this._stream.resume();
					this._nsPlayStatus = FlvPlayMode_Status.PLAY_STATUS_PLAYING;
					if (param2 != null)
					{
						
						setTimeout(function () : void
						{
							param2.call();
							return;
						}// end function
						, delayCall);
					}
					return;
				}
				this._stream.startToChange();
				this._nsPlayStatus = FlvPlayMode_Status.PLAY_STATUS_PLAYING;
				
				setTimeout(function () : void{
					time = time - outerStartTime;
					if (_fileType == PlayerEnum.FT_MP4){
						time = time - startTime;
					}
					if (time < 0){
						time = 0;
					}
					_stream.seek(time);
					_stream.resume();
					if (param2 != null){
						
						setTimeout(function () : void
						{
							param2.call();
							return;
						}// end function
							, delayCall);
					}
					return;
				}// end function
					, delay);
			}
			
			
			return;
			
			
			
		
		
		}// end function
		
		public function pause() : void
		{
			if (this._nsPlayStatus == FlvPlayMode_Status.PLAY_STATUS_INIT)
			{
				return;
			}
			if (!this._stream || !this._stream.readyToPlay)
			{
				return;
			}
			this._stream.pause();
			this._nsPlayStatus = FlvPlayMode_Status.PLAY_STATUS_PAUSE;
			return;
		}// end function
		
		public function stop() : void
		{
			if (this._nsPlayStatus == FlvPlayMode_Status.PLAY_STATUS_INIT)
			{
				return;
			}
			this._stream.pause();
			this._nsPlayStatus = FlvPlayMode_Status.PLAY_STATUS_STOP;
			return;
		}// end function
		
		public function close(param1:Boolean = false) : void
		{
			var _loc_2:uint = 0;
			var _loc_3:* = undefined;
			if (this._stream)
			{
				if (!this._streamLoadCompleted && this.ls_nowbyteLoad != 0)
				{
					_loc_2 = getTimer();
					_loc_3 = Math.floor((this._stream.bytesLoaded - this.ls_nowbyteLoad) / 1024 / (_loc_2 - this.downloadtime) * 1000);
					if (this.usingP2P && this._stream.P2PData)
					{
						if (this._stream.P2PData.P2PDownloadBytes)
						{
							this.p2p_nowBytes = this._stream.P2PData.P2PDownloadBytes;
						}
						if (this._stream.P2PData.CDNDownloadBytes)
						{
							this.cdn_nowBytes = this._stream.P2PData.CDNDownloadBytes;
						}
						_loc_3 = Math.floor((this.p2p_nowBytes - this.p2p_lastBytes) / 1024 / (_loc_2 - this.downloadtime) * 1000 + (this.cdn_nowBytes - this.cdn_lastBytes) / 1024 / (_loc_2 - this.downloadtime) * 1000);
					}
					if (_loc_3 > 0)
					{
						PlayerUtils.pushMaxLenArray(GlobalVars.arrayClspeed, new ClSpeedMode(_loc_3, _loc_2, _loc_2 - this.downloadtime), GlobalVars.arrayClspeedMaxLen);
					}
				}
				if (this._stream.getLoadedPercent() != 1)
				{
					this._hasClosed = true;
				}
				this._isSeeking = false;
				if (this._nsPlayStatus == FlvPlayMode_Status.PLAY_STATUS_INIT)
				{
					this._stream.closeStream();
					return;
				}
				this._nsPlayStatus = FlvPlayMode_Status.PLAY_STATUS_INIT;
				this._stream.seek(0);
				this._stream.closeStream();
				this.removeStreamEvents();
				clearTimeout(this.emptyTimeout);
				clearTimeout(this._timeoutCount);
				clearTimeout(this.waitTimeoutCount);
			}
			this.destory(param1);
			return;
		}// end function
		
		public function seekStop() : void
		{
			this._isSeeking = false;
			this._nsPlayStatus = FlvPlayMode_Status.PLAY_STATUS_PLAYING;
			return;
		}// end function
		
		public function seeking(param1:Number, param2:Boolean = true) : void
		{
			if (this._stream)
			{
				this._isSeeking = param2;
				param1 = param1 - this.outerStartTime;
				if (this._fileType == PlayerEnum.FT_MP4)
				{
					param1 = param1 - this.startTime;
				}
				this._stream.seek(param1);
			}
			return;
		}// end function
		
		public function seekToStart() : void
		{
			
			if (this._stream)
			{
				this._stream.seek(0);
			}
			return;
		}// end function
		
		public function get hasClosed() : Boolean
		{
			return this._hasClosed;
		}// end function
		
		public function get modeflvPath() : String
		{
			return this._flvPath;
		}// end function
		
		public function get endTime() : Number
		{
			return this._endTime;
		}// end function
		
		public function set endTime(param1:Number) : void
		{
			this._endTime = param1;
			return;
		}// end function
		
		
		
		private function destory(param1:Boolean = false) : void
		{
			if (this._stream)
			{
				this.removeStreamEvents();
				this._stream.closeStream();
				this._stream = null;
			}
			if (this._timer && this._timer.isRunning())
			{
				this._timer.stop();
			}
			this.ls_nowbyteLoad = 0;
			this._timer = null;
			this.playMetaData = null;
			ForceGC.gc();
			return;
		}// end function
		
		public function get waittime() : Number
		{
			return this._waittime;
		}// end function
		
		public function get buffersize() : Number
		{
			return this._buffersize;
		}// end function
		
		public function get dlSpeed() : Number
		{
			return this._dlSpeed;
		}// end function
		
		public function get timeoutMax() : Number
		{
			return this._timeoutMax;
		}// end function
		
		public function set timeoutMax(param1:Number) : void
		{
			this._timeoutMax = param1;
			return;
		}// end function
		
		public function startToChange() : void
		{
			if (this._stream)
			{
				this._stream.startToChange();
			}
			return;
		}// end function
		
		public function getPlaytimeSeekPoint(param1:Number = -1) : Object
		{
			if (param1 == -1)
			{
				param1 = this.relPlayTime;
			}
			var _loc_2:* = this.getSeekPoint(param1);
			var _loc_3:* = new Object();
			_loc_3.playtime = this.modePlayTime;
			if (this._fileType == PlayerEnum.FT_MP4)
			{
				_loc_3.start = this._startTime + _loc_2.start;
				_loc_3.end = this._startTime + _loc_2.end;
			}
			else
			{
				_loc_3.start = _loc_2.start;
				_loc_3.end = _loc_2.end;
			}
			return _loc_3;
		}// end function
		
		private function getSeekPoint(param1:Number) : Object
		{
			var _loc_5:SeekPoint = null;
			if (param1 < 0)
			{
				param1 = 0;
			}
			var _loc_2:* = param1 - 10;
			var _loc_3:* = param1 + 10;
			if (param1 < 10)
			{
				_loc_2 = 0;
			}
			if (param1 > this.duration - 10)
			{
				_loc_3 = this.duration;
			}
			if (!this._seekpoints || this._seekpoints.length < 2)
			{
				return {start:_loc_2, end:_loc_3};
			}
			var _loc_4:* = this._seekpoints.length;
			if (param1 >= this._seekpoints[(_loc_4 - 1)].time)
			{
				_loc_5 = this._seekpoints[(_loc_4 - 1)];
				_loc_2 = this._seekpoints[_loc_4 - 2].time;
				return {start:_loc_2, end:_loc_5.time};
			}
			if (param1 == 0)
			{
				_loc_5 = this._seekpoints[0];
				_loc_3 = this._seekpoints[1].time;
				return {start:_loc_5.time, end:_loc_3};
			}
			var _loc_6:* = this.arraySearchHandle(this._seekpoints, param1);
			_loc_5 = this._seekpoints[_loc_6];
			_loc_2 = _loc_5.time;
			if (_loc_6 == (length - 1))
			{
				_loc_3 = Math.max(this.duration, _loc_2);
			}
			else
			{
				_loc_3 = this._seekpoints[(_loc_6 + 1)].time;
			}
			return {start:_loc_2, end:_loc_3};
		}// end function
		
		private function arraySearchHandle(param1:Vector.<SeekPoint>, param2:Number) : int
		{
			var _loc_3:uint = 0;
			var _loc_4:* = param1.length;
			var _loc_5:* = _loc_3 + Math.round((_loc_4 - _loc_3) / 2);
			while (param1[_loc_5].time != param2)
			{
				
				if (param1[_loc_5].time <= param2)
				{
					_loc_3 = _loc_5;
				}
				else
				{
					_loc_4 = _loc_5;
				}
				if (Math.abs(_loc_4 - _loc_3) < 2)
				{
					_loc_5 = _loc_3;
					break;
				}
				_loc_5 = _loc_3 + Math.round((_loc_4 - _loc_3) / 2);
			}
			return _loc_5;
		}// end function
		
		public function getVideoStarted() : Boolean
		{
			return this.videoStarted;
		}// end function
		
		public function get formatName() : String
		{
			return this._formatName;
		}// end function
		
		public function set formatName(param1:String) : void
		{
			this._formatName = param1;
			return;
		}// end function
		
		public function get streamLoadCompleted() : Boolean
		{
			return this._streamLoadCompleted;
		}// end function
		
		public function get playTimeoutMax() : Number
		{
			return this._playTimeoutMax;
		}// end function
		
		public function set playTimeoutMax(param1:Number) : void
		{
			this._playTimeoutMax = param1;
			return;
		}// end function
		
		public function getLoadtime() : Number
		{
			return this.loadtime;
		}// end function
		
		public function getLoadOvertime() : Number
		{
			return this.loadovertime;
		}// end function
		
		public function setUserWaittime() : void
		{
			this.userWaitlasttime = this.userWaittime;
			this.userWaittime = getTimer();
			return;
		}// end function
		
		public function attachVideo(param1:Video) : void
		{
			if (this._stream)
			{
				this._stream.attachVideo(param1);
			}
			return;
		}// end function
		
		public function attachStageVideo(param1:Object) : void
		{
			if (this._stream)
			{
				this._stream.attachStageVideo(param1);
			}
			return;
		}// end function
		
		public function get currentFPS() : Number
		{
			if (this._stream)
			{
				return this._stream.currentFPS;
			}
			return 0;
		}// end function
		
		public function get usingP2P() : Boolean
		{
			if (this._stream)
			{
				return this._stream.usingP2P();
			}
			return false;
		}// end function
		
		
	
	}
}