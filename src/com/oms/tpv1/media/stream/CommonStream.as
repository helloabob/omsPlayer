package com.oms.tpv1.media.stream
{
	import com.gridsum.VideoTracker.GSVideoState;
	import com.gridsum.VideoTracker.VideoInfo;
	import com.gridsum.VideoTracker.VideoTracker;
	import com.gridsum.VideoTracker.VodMetaInfo;
	import com.gridsum.VideoTracker.VodPlay;
	import com.oms.tpv1.model.GlobalVars;
	import com.sun.media.video.*;
	
	import flash.events.*;
	import flash.external.ExternalInterface;
	import flash.media.*;
	import flash.net.*;
	
	
	public class CommonStream extends EventDispatcher implements IVideoStream
	{
		private var _bufferTime:int = 2;
		private var _flvPath:String = "";
		private var _server:String = "";
		private var _stream:GSNetStream;
		private var _connection:NetConnection;
		private var _readyToPlay:Boolean = false;
		private var _fullForTheFirstTime:Boolean;
		private var empty:Boolean;
		
		
		//private var _vodPlay:VodPlay = null;
		
		
		public function CommonStream()
		{
			return;
		}// end function
		
		public function get readyToPlay() : Boolean
		{
			return this._readyToPlay;
		}// end function
		
		public function load(param1:Object) : void
		{
			var _loc_2:* = param1["path"] != undefined ? (param1["path"]) : ("");
			var _loc_3:* = param1["buffer"] != undefined ? (param1["buffer"]) : (2);
			if (_loc_2 == "")
			{
				throw new Error("不能提供空的路径！");
			}
			this._bufferTime = _loc_3;
			this._flvPath = _loc_2;
			this._server = null;
			this._readyToPlay = false;
			this.netObjDestroy();
			this.connectionInit();
			return;
		}// end function
		
		private function netObjDestroy() : void
		{
			if (this._stream)
			{
				this._stream.close();
				this._stream.removeEventListener(NetStatusEvent.NET_STATUS, this.nsStatusHandler);
				this._stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, this.asyncErrorHandler);
				this._stream.removeEventListener(IOErrorEvent.IO_ERROR, this.ioError);
				this._stream = null;
			}
			if (this._connection != null)
			{
				this._connection.close();
				this._connection.removeEventListener(NetStatusEvent.NET_STATUS, this.ncStatusHandler);
				this._connection.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, this.asyncErrorHandler);
				this._connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
				this._connection = null;
			}
			return;
		}// end function
		
		private function asyncErrorHandler(event:AsyncErrorEvent) : void
		{
			return;
		}// end function
		
		private function securityErrorHandler(event:SecurityErrorEvent) : void
		{
			dispatchEvent(new StreamEvent(StreamEvent.STREAM_ERROR, "securityError"));
			return;
		}// end function
		
		private function ioError(event:IOErrorEvent) : void
		{
			return;
		}// end function
		
		private function connectionInit() : void
		{
			var _loc_1:Object = null;
			this._connection = new NetConnection();
			this._connection.addEventListener(NetStatusEvent.NET_STATUS, this.ncStatusHandler);
			this._connection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.asyncErrorHandler);
			this._connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
			if (this._flvPath.indexOf("rtmp://") >= 0)
			{
				_loc_1 = this.splitRMPTURL(this._flvPath);
				this._server = _loc_1.server;
				this._flvPath = _loc_1.flvname;
			}
			this._connection.connect(this._server);
			return;
		}// end function
		//流播放,这些先干掉好了...后面再考虑直播的事情了.
		private function splitRMPTURL(param1:String) : Object
		{
			var _loc_8:String = null;
			var _loc_2:* = new Object();
			var _loc_3:* = param1.split("/");
			var _loc_4:* = _loc_3.length;
			var _loc_5:String = "";
			var _loc_6:String = "";
			var _loc_7:uint = 0;
			while (_loc_7 < _loc_4)
			{
				
				if (_loc_7 < 4)
				{
					_loc_5 = _loc_5 + (_loc_3[_loc_7] + "/");
				}
				else if (_loc_7 == (_loc_4 - 1))
				{
					_loc_8 = _loc_3[_loc_7];
					if (_loc_8.lastIndexOf(".mp4") >= 0)
					{
						if (_loc_8.indexOf("mp4:") != 0)
						{
							_loc_8 = "mp4:" + _loc_8;
						}
					}
					_loc_6 = _loc_6 + _loc_8;
				}
				else
				{
					_loc_6 = _loc_6 + (_loc_3[_loc_7] + "/");
				}
				_loc_7 = _loc_7 + 1;
			}
			_loc_6 = _loc_6.substr(0, _loc_6.length - 4);
			_loc_2.server = _loc_5;
			_loc_2.flvname = _loc_6;
			return _loc_2;
		}// end function
		
		private function ncStatusHandler(event:NetStatusEvent) : void
		{
			switch(event.info.code)
			{
				case "NetConnection.Connect.Success":
				{
					this.streamInit();
					break;
				}
				case "NetConnection.Connect.Closed":
				{
					dispatchEvent(new StreamEvent(StreamEvent.STREAM_NC_CLOSED, "NetConnection.Connect.Closed"));
					break;
				}
				case "NetConnection.Connect.Failed":
				{
					dispatchEvent(new StreamEvent(StreamEvent.STREAM_NC_ERROR, "NetConnection.Connect.Failed"));
					break;
				}
				case "NetConnection.Connect.Rejected":
				{
					dispatchEvent(new StreamEvent(StreamEvent.STREAM_NC_ERROR, "NetConnection.Connect.Rejected"));
					break;
				}
				case "NetConnection.Connect.AppShutdown":
				{
					dispatchEvent(new StreamEvent(StreamEvent.STREAM_NC_ERROR, "NetConnection.Connect.AppShutdown"));
					break;
				}
				case "NetConnection.Connect.InvalidApp":
				{
					dispatchEvent(new StreamEvent(StreamEvent.STREAM_NC_ERROR, "NetConnection.Connect.InvalidApp"));
				}
				default:
				{
					dispatchEvent(new StreamEvent(StreamEvent.STREAM_NC_ERROR, "other error"));
					break;
				}
			}
			return;
		}// end function
		
		private function streamInit() : void
		{
			this._stream = new GSNetStream(this._connection);
			this._stream.addGSNetStreamEventListener(GSVideoStateEvent.STATE_CHANGE, onStateChanged);
			
			
			
			
			
			
			var tracker:VideoTracker=VideoTracker.getInstance("GVD-200015","GSD-200015");
			//传入视频ID。视频ID是系统标识视频的标准。
			//draw panel
			var videoInfo:VideoInfo=new VideoInfo(GlobalVars.omsid.toString());
			videoInfo.videoOriginalName=GlobalVars.flvtitle;//传入视频的原始名称。
			videoInfo.videoName=GlobalVars.flvtitle;//传入视频的别称。参数里的n的值
	
			var tmp:Array = this._flvPath.split('?');
			videoInfo.videoUrl=tmp[0];//传入视频的URL。
			
			videoInfo.cdn="ChinaCache"; //本视频所使用的加速渠道名称
			
			
			
			videoInfo.videoWebChannel=GlobalVars.videoWebChannel;//频道
			videoInfo.videoTag=GlobalVars.keyword;//关键字
			
			
			
			
			//创建新播放统计
			var vodInfoProvider:NetStreamVodInfoProvider = new NetStreamVodInfoProvider(this._stream);
			if(GlobalVars._vodPlay===null){
				
				GlobalVars._vodPlay=tracker.newVodPlay(videoInfo, vodInfoProvider);
				//-------------------------------------------------------
				//这里开始载入资源，这里是beginLoading的恰当时机
				GlobalVars._vodPlay.beginLoading();
				
				
			}
			
			
			this._stream.addEventListener(NetStatusEvent.NET_STATUS, this.nsStatusHandler);
			this._stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.asyncErrorHandler);
			this._stream.addEventListener(IOErrorEvent.IO_ERROR, this.ioError);
			this._stream.client = this;
			this._stream.bufferTime = this._bufferTime;
			this._fullForTheFirstTime = false;
			
			
			
			var xxx:Array = this._flvPath.split('start=');
			
			if(xxx.length<2){
				
				this._flvPath = this._flvPath + "&start=0";
				
			}
			
			
			this._stream.play(this._flvPath);
			
			return;
		}// end function
		
		
		private function onStateChanged(evt:Event):void
		{
			//干掉烦人的跳转看下效果
			
			if( this._stream.state!='seeking' 
			    // this._stream.state!='loading' && 
				// this._stream.state!='disconnected' 
				 ){
				
				GlobalVars._vodPlay.onStateChanged(this._stream.state);
				
			}
			return;
			

		}
		
		private function nsStatusHandler(event:NetStatusEvent) : void
		{
			
			//GlobalVars._vodPlay.onStateChanged(this._stream.state);
			
			
			switch(event.info.code)
			{
				case "NetStream.Play.Start":
				{
					
					
					//GlobalVars._vodPlay.onStateChanged("PLAYING");
					if (!this._readyToPlay)
					{
						this._readyToPlay = true;
						this.empty = false;
						if (this._server != null)
						{
							this._stream.pause();
						}
						this._fullForTheFirstTime = false;
						dispatchEvent(new StreamEvent(StreamEvent.STREAM_READY));
					}
					break;
				}
				case "NetStream.Play.StreamNotFound":
				{
					//GlobalVars._vodPlay.onStateChanged("CONNECTION_ERROR");
					dispatchEvent(new StreamEvent(StreamEvent.STREAM_404, "StreamNotFound"));
					break;
				}
				case "NetStream.Buffer.Empty":
				{
					
					//GlobalVars._vodPlay.onStateChanged("BUFFERING");
					
					if (this._stream.bytesLoaded > 0 && this._stream.bytesLoaded == this._stream.bytesTotal)
					{
						return;
					}
					if (this._fullForTheFirstTime)
					{
						this.empty = true;
						dispatchEvent(new StreamEvent(StreamEvent.STREAM_EMPTY));
					}
					break;
				}
				case "NetStream.Buffer.Full":
				{
					if (!this._fullForTheFirstTime)
					{
						this._fullForTheFirstTime = true;
						this._stream.bufferTime = this._bufferTime;
						dispatchEvent(new StreamEvent(StreamEvent.STREAM_START_PLAY));
					}
					else if (this.empty)
					{
						this.empty = false;
						dispatchEvent(new StreamEvent(StreamEvent.STREAM_FULL));
					}
					break;
				}
				case "NetStream.Buffer.Flush":
				{
					break;
				}
				case "NetStream.Seek.Notify": //流状态。。这里具体还不知道。。
				{
					break;
				}
				case "NetStream.Seek.InvalidTime":
				{
					if (event.info.details != 0)
					{
						this._stream.seek(event.info.details);
						dispatchEvent(new StreamEvent(StreamEvent.STREAM_INVALIDTIME, event.info.details));
					}
					break;
				}
				case "NetStream.Play.Stop":
				{
					if (this._server == null && this._stream.bytesLoaded > 0 && this._stream.bytesLoaded == this._stream.bytesTotal)
					{
						dispatchEvent(new StreamEvent(StreamEvent.STREAM_STOP));
					}
					break;
				}
				default:
				{
					break;
				}
			}
			dispatchEvent(new StreamEvent(StreamEvent.STREAM_STATUS, event.info));
			return;
		}// end function
		
		public function onMetaData(param1:Object) : void
		{
			
			var meta:VodMetaInfo = new VodMetaInfo();
			if(GlobalVars._playertime==0){
				
				GlobalVars._playertime=param1.duration;
			}
			meta.videoDuration = GlobalVars._playertime;
			
			
			//ExternalInterface.call("nextplayb", meta.videoDuration);
			
			meta.framesPerSecond = 25;
			meta.isBitrateChangeable = false;
			meta.bitrateKbps = 200;
			//if(GlobalVars._playertime>0){
			GlobalVars._vodPlay.endLoading(true, meta);
				
			//}
			
			
			
			
			dispatchEvent(new StreamEvent(StreamEvent.STREAM_MD, param1));
			
			return;
		}// end function
		
		public function onPlayStatus(param1:Object) : void
		{
			dispatchEvent(new StreamEvent(StreamEvent.STREAM_STOP));
			return;
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
		
		public function getLoadedPercent() : Number
		{
			if (!this._stream)
			{
				return 0;
			}
			if (this._stream.bytesTotal == 0)
			{
				return 0;
			}
			return this._stream.bytesLoaded / this._stream.bytesTotal;
		}// end function
		
		public function get playTime() : Number
		{
			if (!this._stream)
			{
				return 0;
			}
			return this._stream.time;
		}// end function
		
		public function get bufferPercent() : Number
		{
			if (!this._stream)
			{
				return 0;
			}
			if (this.empty)
			{
				return this._stream.bufferLength / this._stream.bufferTime;
			}
			return 1;
		}// end function
		
		public function get bufferPerToPlay() : Number
		{
			if (!this._stream)
			{
				return 0;
			}
			return this._stream.bufferLength / this._stream.bufferTime;
		}// end function
		
		public function get bufferLength() : Number
		{
			if (!this._stream)
			{
				return 0;
			}
			return this._stream.bufferLength;
		}// end function
		
		public function closeStream() : void
		{
			this.netObjDestroy();
			return;
		}// end function
		
		public function get volume() : Number
		{
			var _loc_1:SoundTransform = null;
			if (this._stream)
			{
				_loc_1 = this._stream.soundTransform;
				return _loc_1.volume * 100;
			}
			return 0;
		}// end function
		
		public function set volume(param1:Number) : void
		{
			var _loc_2:SoundTransform = null;
			if (this._stream)
			{
				if (param1 > 500)
				{
					param1 = 500;
				}
				else if (param1 < 0)
				{
					param1 = 0;
				}
				_loc_2 = this._stream.soundTransform;
				_loc_2.volume = param1 / 100;
				this._stream.soundTransform = _loc_2;
			}
			return;
		}// end function
		
		public function set bufferTime(param1:int) : void
		{
			this._bufferTime = param1;
			if (param1 > 10)
			{
				param1 = 10;
			}
			else if (param1 < 2)
			{
				param1 = 2;
			}
			if (this._fullForTheFirstTime && this._stream)
			{
				this._stream.bufferTime = param1;
			}
			return;
		}// end function
		
		public function get bufferTime() : int
		{
			return this._bufferTime;
		}// end function
		
		public function get isLive() : Boolean
		{
			if (this._server == null)
			{
				return false;
			}
			return true;
		}// end function
		
		public function pause() : Boolean
		{
			if (this._stream)
			{
				this._stream.pause();
				return true;
			}
			return false;
		}// end function
		
		public function resume() : Boolean
		{
			if (this._stream)
			{
				this._stream.resume();
				return true;
			}
			return false;
		}// end function
		
		public function seek(param1:Number) : Boolean
		{
			if (this._stream)
			{
				param1 = Math.floor(param1 * 100) / 100;
				if (param1 < -1)
				{
				}
				this._stream.seek(param1);
				return true;
			}
			else
			{
				return false;
			}
		}// end function
		
		public function attachVideo(param1:Video) : void
		{
			if (param1 && this._stream)
			{
				param1.attachNetStream(this._stream);
			}
			return;
		}// end function
		
		public function attachStageVideo(param1:Object) : void
		{
			if (param1 && this._stream)
			{
				try
				{
					param1.attachNetStream(this._stream);
				}
				catch (e:Error)
				{
				}
			}
			return;
		}// end function
		
		public function startToChange() : void
		{
			if (this._stream)
			{
				this._stream.pause();
				this._stream.resume();
				this._stream.seek(0);
			}
			return;
		}// end function
		
		public function usingP2P() : Boolean
		{
			return false;
		}// end function
		
		public function get P2PData() : Object
		{
			return {CDNDownloadBytes:this.bytesLoaded, P2PDownloadBytes:0, P2PUploadBytes:0};
		}// end function
		
		public function get stream() : GSNetStream
		{
			return this._stream;
		}// end function
		
		public function get currentFPS() : Number
		{
			if (this._stream)
			{
				return this._stream.currentFPS;
			}
			return 0;
		}// end function
	}
}