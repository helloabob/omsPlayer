package com.oms.tpv1.media.players
{
	import __AS3__.vec.*;
	
	import com.greensock.*;
	
	
	import com.oms.report.*;
	import com.oms.tpv1.events.*;
	import com.oms.tpv1.managers.*;
	import com.oms.tpv1.media.*;
	import com.oms.tpv1.media.players.*;
	import com.oms.tpv1.model.*;
	import com.oms.tpv1.utils.*;
	import com.sun.utils.*;
	
	import flash.events.*;
	import flash.external.ExternalInterface;
	import flash.geom.*;
	import flash.media.*;
	import flash.net.*;
	import flash.utils.*;
	
	
	
	
	
	public class HttpVideoPlayer extends BaseVideoPlayer
	{
		protected var stageVideo:Object;
		protected var video:Video;
		protected var currentMode:VideoPlayModeV3;
		protected var seekingMode:VideoPlayModeV3;
		protected var lastPlayMode:VideoPlayModeV3;
		protected var dlMode:VideoPlayModeV3;
		private var requestNewMode:VideoPlayModeV3;
		private var the1stRequest:Boolean = false;
		private var the1stGetMetadata:Boolean = false;
		private var startId:int = 0;
		private var modeIndex:int = 0;
		private var currIndex:int = 0;
		private var currLoadIndex:int = 0;
		private var nextVideoDownError:Boolean = false;
		private var part2edStreamStarted:Boolean = false;
		//private var autoplay:Boolean = true;
		private var arrayModes:Vector.<VideoPlayModeV3>;
		private var arrayUpdateModes:Vector.<VideoPlayModeV3>;
		private var jumpVideoTimeout:uint = 0;
		private var videoRenderStatus:String;
		private const ERROR_MAX_TRYTIME:int = 5;
		private var errorRequestCount:int = 0;
		private const ERROR_NEXT_TRYTIME:int = 5;
		private var errorReqeustNextCount:int = 0;
		private var rpt_starttoload:uint = 0;
		private var rpt_starttoplay:uint = 0;
		private var rpt_empty:uint = 0;
		private var rpt_emptylast:uint = 0;
		private var rpt_full:uint = 0;
		private var rpt_complete:uint = 0;
		private var rpt_error:uint = 0;
		private var rpt_nextload:uint = 0;
		private var rpt_nexterror:uint = 0;
		private var reportPlayStatus:int;
		private var statusBeforeSeek:int;
		private var previewIndex:int = 0;
		private var testedVideoContent:Boolean = false;
		private var lastGcTime:uint = 0;
		private var getinfoObj:Object;
		private var streamInitTime:uint;
		//private var _httploader:HttpLoader;
		private var _testMode:Object;
		private var _testCount:int = 0;
		private var _testUrl:String;
		private const URL_PATTERN:RegExp = /\r\n/g;
		private static const StageVideoEvent:Object = getDefinitionByName("flash.events.StageVideoEvent");
		private static const StageVideoAvailabilityEvent:Object = getDefinitionByName("flash.events.StageVideoAvailabilityEvent");
		private static const StageVideo:Object = getDefinitionByName("flash.media.StageVideo");
		private static const StageVideoAvailability:Object = getDefinitionByName("flash.media.StageVideoAvailability");
		private static const STAGE_VIDEO_SUPPORTED:Boolean = StageVideo && StageVideoEvent && StageVideoAvailabilityEvent;
		
		
		
	
		
		
		public function HttpVideoPlayer()
		{
			
			this.arrayModes = new Vector.<VideoPlayModeV3>;
			return;
		}// end function
		
		override public function setVideoData(param1:VideoPlayData) : void
		{
			super.setVideoData(param1);
			this.stop();
			this.destroy();
			this.reInit();
			this.getUrlInfo();//获取地址信息，包括相关的截图信息，这里后面再作验证
			return;
		}// end function
		
		private function getUrlInfo() : void 
		{
			if (!videodata || !videodata.arrayVid)
			{
				this.playErrorHandler(PlayerEnum.ST_ERROR_ARGS);
				return;
			}
			this.arrayModes.splice(0, this.arrayModes.length);
			
			//GlobalVars.p2pStreamType = StreamFactory.STREAMTYPE_NATIVE;
			if (!VideoInfoGetter.instance.hasEventListener(VideoInfoGetterEvent.VIDEOINFO_SUCC))
			{
				VideoInfoGetter.instance.addEventListener(VideoInfoGetterEvent.VIDEOINFO_ERROR, this.videoinfoGetError);
				VideoInfoGetter.instance.addEventListener(VideoInfoGetterEvent.VIDEOINFO_SUCC, this.videoinfoGetSucc);
			}
			
			
			VideoInfoGetter.instance.getVideoInfo(videodata);
			
			return;
		}// end function
		
		//视频初始化.
		/*
		 *难不成是在这里加吗?测试一下看看 
		*/
		
		
		
		private function reInit() : void
		{
			this.the1stRequest = true;
			this.the1stGetMetadata = true;
			this.startId = 0;
			setPlayerState(PlayerEnum.STATE_STOP);
			this.modeIndex = 0;
			this.currIndex = 0;
			this.currLoadIndex = 0;
			this.errorRequestCount = 0;
			this.errorReqeustNextCount = 0;
			this.nextVideoDownError = false;
			this.part2edStreamStarted = false;
			isBufferring = false;
			rangePlay = false;
			if (!this.video)
			{
				//这里创建一个视频,播放状态在哪里在呢?
				this.video = new Video();
				this.video.width = 600;
				this.video.height = 450;
				
				
				
				if (STAGE_VIDEO_SUPPORTED)
				{
					this.video.addEventListener(StageVideoEvent.RENDER_STATE, this.onVideoEvent);
				}
				
			
				
			}
			
			
			/*if (StreamFactory.instance.hasEventListener(Event.COMPLETE))
			{
				StreamFactory.instance.removeEventListener(Event.COMPLETE, this.startToCreateMode);
			}*/
			return;
		}// end function
		
		
		//跳转到这里了。。。这个地方需要注意一下了
		private function onVideoEvent(event:Event) : void
		{
			//这里会被调用一次。
			
			trace('状态是否多次改变位置一');
			this.videoRenderStatus = Object(event).status;
			AS3Debugger.Trace("httpvideoplayer:video rendering by .这里是要测试的效果:" + this.videoRenderStatus);
			this.attachNetstream();
			return;
		}// end function
		
		private function onStageVideoEvent(event:Event) : void
		{
			trace('状态是否多次改变位置二');
			this.videoRenderStatus = Object(event).status;
			AS3Debugger.Trace("httpvideoplayer:stagevideo rendering by " + this.videoRenderStatus);
			this.attachNetstream();
			return;
		}// end function
		//这里是因为有了全屏状态下的视频画面而进行特定的调整
		private function attachNetstream() : void
		{
			if (!this.currentMode)
			{
				return;
			}
			if (STAGE_VIDEO_SUPPORTED && this.arrayModes.length == 1 && stage.stageVideos.length > 0 && (GlobalVars.forceHardware || PlayerUtils.indexHomePages(GlobalVars.usingHost)))
			{
				trace('attachNetstream11111111111111');
				usingStageVideo = true;
				if (this.contains(this.video))
				{
					this.removeChild(this.video);
				}
				if (!this.stageVideo)
				{
					this.stageVideo = stage.stageVideos[0];
					this.stageVideo.addEventListener(StageVideoEvent.RENDER_STATE, this.onStageVideoEvent);
				}
				if (this.stageVideo)
				{
					trace('---------------0000000000------------------------');
					this.currentMode.attachStageVideo(this.stageVideo);
					
				}
				else
				{
					trace('---------------1111111111------------------------');
					this.currentMode.attachVideo(this.video);
					
					if (this.video.parent != this)
					{
						trace('xxxxxxxxxxxxxxxxx');
						
						this.addChildAt(this.video, 1);
					}else{
						
						trace('yyyyyyyyyyyyyyyyyyyyyyyy');
					}
				}
			}
			else
			{
				trace('attachNetstream2222222222');
				usingStageVideo = false;
				if (this.stageVideo)
				{
					this.stageVideo.removeEventListener(StageVideoEvent.RENDER_STATE, this.onStageVideoEvent);
					this.stageVideo = null;
				}
				this.currentMode.attachVideo(this.video);
				if (this.video.parent != this)
				{
					this.addChildAt(this.video, 0);
				}
			}
			this.videoRenderStatus = null;
			this.resizeVideo();
			return;
			
		}// end function
		
		private function resizeVideo() : void
		{
			var _loc_3:Point = null;
			if (!videodata)
			{
				return;
			}
			var _loc_1:* = videodata.video_width;
			var _loc_2:* = videodata.video_height;
			if (_loc_1 < 1)
			{
				_loc_1 = 1;
			}
			if (_loc_2 < 1)
			{
				_loc_2 = 1;
			}
			if (this.stageVideo)
			{
				_loc_3 = localToGlobal(new Point(0, 0));
				this.stageVideo.viewPort = new Rectangle(0, 0, _loc_1, _loc_2);
			}
			else
			{
				if (!currResizeEffect)
				{
					try
					{
						TweenLite.killTweensOf(this.video);
					}
					catch (e:Error)
					{
					}
					this.video.width = _loc_1;
					this.video.height = _loc_2;
				}
				else
				{
					TweenLite.to(this.video, 0.4, {width:_loc_1, height:_loc_2});
				}
				this.video.smoothing = this.video.width != this.video.videoWidth || this.video.height != this.video.videoWidth;
			}
			return;
		}// end function
		
		override public function resize(param1:Number, param2:Number, param3:int = 0, param4:Boolean = false) : void
		{
			super.resize(param1, param2, param3, param4);
			this.resizeVideo();
			return;
		}// end function
		//视频错误提示
		private function videoinfoGetError(event:VideoInfoGetterEvent) : void
		{
			var _loc_2:Object = null;
			var _loc_3:String = null;
			var _loc_4:Number = NaN;
			VideoInfoGetter.instance.removeEventListener(VideoInfoGetterEvent.VIDEOINFO_ERROR, this.videoinfoGetError);
			VideoInfoGetter.instance.removeEventListener(VideoInfoGetterEvent.VIDEOINFO_SUCC, this.videoinfoGetSucc);
			_loc_2 = event.value;
			switch(_loc_2.code)
			{
				case "default":
				{
					_loc_3 = this.createModes(event.value.info);
					if (_loc_3 == "succ")
					{
						AS3Debugger.Trace("HttpVideoPlayer::videoinfoGetError default");
						
						if (!GlobalVars.autoPlay)
						{
							dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.SETUP_COMPLETE));
						}
						else
						{
							this.play();
						}
					}
					else
					{
						dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAY_NOMAL_ERROR));
					}
					break;
				}
				case "error":
				{
					AS3Debugger.Trace("HttpVideoPlayer::videoinfoGetError error");
					_loc_4 = _loc_2.codenum;
					if (_loc_2.msg == "不允许观看")
					{
						this.playErrorHandler(PlayerEnum.ST_ERROR_UNALLOW, _loc_4);
					}
					else
					{
						this.playErrorHandler(PlayerEnum.ST_ERROR_GETURL, _loc_4);
					}
					break;
				}
				default:
				{
					break;
				}
			}
			return;
		}// end function
		//信息获取成功后,这里进行播放
		private function videoinfoGetSucc(event:VideoInfoGetterEvent) : void
		{
			VideoInfoGetter.instance.removeEventListener(VideoInfoGetterEvent.VIDEOINFO_ERROR, this.videoinfoGetError);
			VideoInfoGetter.instance.removeEventListener(VideoInfoGetterEvent.VIDEOINFO_SUCC, this.videoinfoGetSucc);
			this.getinfoObj = event.value.info;
			//这里拿到相当多的内容
			
			//P2P技术,这里直接拿掉好了
			
			//GlobalVars.p2pStreamType = StreamFactory.STREAMTYPE_NATIVE;
			
			/*GlobalVars.p2pStreamType = StreamFactory.STREAMTYPE_NATIVE;
			if (this.getinfoObj && this.getinfoObj.fp2p && this.getinfoObj.fp2p == "1" && GlobalVars.playerversion != PlayerEnum.TYPE_SWFOUTSIDE)
			{
				GlobalVars.p2pStreamType = StreamFactory.STREAMTYPE_CLOUDACC;
			}
			if (GlobalVars.forceStreamType != -1)
			{
				GlobalVars.p2pStreamType = GlobalVars.forceStreamType;
			}
			
			AS3Debugger.Trace("HttpVideoPlayer::videoinfoGetSucc:p2pStreamType=" + GlobalVars.p2pStreamType);
			*/
			this.streamInitTime = getTimer();
			if (!StreamFactory.instance.hasEventListener(Event.COMPLETE))
			{
				StreamFactory.instance.addEventListener(Event.COMPLETE, this.startToCreateMode);
			}
			StreamFactory.instance.init(0);
			
			return;
		}// end function
		//正常模式会跳转到这里 from line 349
		private function startToCreateMode(event:Event) : void
		{
			if (StreamFactory.instance.hasEventListener(Event.COMPLETE))
			{
				StreamFactory.instance.removeEventListener(Event.COMPLETE, this.startToCreateMode);
			}
			
			//GlobalVars.p2pVersion = StreamFactory.instance.streamVersion;
			
			var _loc_2:int = 0;
			var _loc_3:String = "";
			var _loc_4:int = 0;
			if (0 == StreamFactory.STREAMTYPE_NATIVE)
			{
				_loc_2 = 1;
				_loc_4 = ReportManager.DLTYPE_HTTP;
			}
			else
			{
				_loc_4 = ReportManager.DLTYPE_P2P;
				/*if ("" != null && GlobalVars.p2pVersion != "" && "" != "undefined")
				{
					_loc_2 = 1;
				}
				else
				{
					_loc_2 = 2;
				}*/
				_loc_2 = 2;
			}
			if (videodata && videodata.arrayVid && videodata.arrayVid.length > 0)
			{
				_loc_3 = videodata.arrayVid[0];
			}
			var _loc_5:* = ReportManager.createReportMode(ReportManager.STEP_P2PPLUGIN, getTimer() - this.streamInitTime, _loc_2, 0, 0, _loc_3);
			ReportManager.createReportMode(ReportManager.STEP_P2PPLUGIN, getTimer() - this.streamInitTime, _loc_2, 0, 0, _loc_3).bi = _loc_4;
			ReportManager.addReport(_loc_5);
			var _loc_6:* = this.createModes(this.getinfoObj);//开始创建模式.看名而定义的.这里拿到标准的视频组合地址
			if (_loc_6 == "succ")
			{
				//自动播放事件要确认
				
				/*
				vodMetaInfo=new VodMetaInfo();
				vodMetaInfo.videoDuration=videodata.video_duration;
				vodMetaInfo.bitrateKbps=450;
				this.vodPlay.endLoading(true,vodMetaInfo);
				*/
				
				//vodPlay.endLoading(true,vodMetaInfo);
				//这里没有监听事件。所以不能播放
				/*if (!GlobalVars.autoPlay)
				{
					dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.SETUP_COMPLETE));
				}
				else
				{*/
					this.play();
				//}
			}
			else
			{
				dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAY_NOMAL_ERROR));
			}
			return;
		}// end function
		
		private function createModes(param1:Object) : String
		{
			var _loc_5:Object = null;
			var _loc_6:VideoPlayModeV3 = null;
			if (!param1)
			{
				return "error";
			}
			var _loc_2:* = this.getFormat(param1.fl);
			trace('------------');
			trace(_loc_2);
			//[object VideoFormat],[object VideoFormat],[object VideoFormat],[object VideoFormat]
			trace('------------');
			if (_loc_2 == null)
			{
				param1 = VideoInfoGetter.instance.createDefaultInfo();
				videodata.video_fmtlist = new Vector.<VideoFormat>;
				videodata.video_fmtlist.push(new VideoFormat());
				videodata.video_fmtlist.push(new VideoFormat("mp4", "2", 128, 0, 1));
				videodata.video_curfmt = videodata.video_fmtlist[0];
				videodata.playformat = videodata.video_curfmt.name;
			}
			else
			{
				videodata.video_fmtlist = FormatUtil.sortFormat(_loc_2);
			}
			videodata.video_br = videodata.video_curfmt.br;
			//videodata.video_stlist = this.getSubtitle(param1.sfl);
			//以下是地址配置信息
			if (param1.vl && param1.vl.vi) 
			{
				if (param1.vl.vi is Array && param1.vl.vi.length > 0)
				{
					_loc_5 = param1.vl.vi[0];
				}
				else
				{
					_loc_5 = param1.vl.vi;
				}
				
				if (_loc_5)
				{
					if (_loc_5.br && !isNaN(_loc_5.br * 1))
					{
						videodata.video_br = _loc_5.br * 1;
					}
					if (_loc_5.share == "0")
					{
						videodata.share_support = false;
					}
					else
					{
						videodata.share_support = true;
					}
					if (this.getTipFormatInfo(_loc_5.pl))
					{
						GlobalVars.useTipPanel = true;
					}
					else
					{
						GlobalVars.useTipPanel = false;
					}
					/*if (_loc_5.logo == "0")
					{
						GlobalVars.useVideoLogo = true;
					}
					else
					{
						GlobalVars.useVideoLogo = false;
					}*/
				}
			}
			var _loc_3:* = new Date();
			GlobalVars.report_infotime = param1.tm && !isNaN(param1.tm * 1) ? (param1.tm * 1000 + _loc_3.milliseconds) : (_loc_3.time);
			GlobalVars.report_timer = getTimer();
			
			var _loc_4:* = this.analyzeInfoNode(param1.vl.vi);//地址信息的解析,并生成某些特定的流连接,这个地方很重要,如果这里解析出错,那页面就无法播放,初始化流及格式化拿到视频地址之类的
			
			if (!_loc_4)//应该是上次地址检测..等观望
			{
				return "error";
			}
			if (this.arrayModes && this.arrayModes.length > 1)//_loc_4执行的时候,压入了arrayModes数组
			{
				this.videodata.video_vtype = this.arrayModes[0].getVtype();
			}
			if (GlobalVars.isPreviewVideo)//看情况好像是前置信息之类
			{
				if (param1.preview != undefined && param1.preview != null && !isNaN(Number(param1.preview)))
				{
					GlobalVars.previewDuration = param1.preview;
				}
				_loc_6 = this.getModeByTime(GlobalVars.previewDuration);
				if (_loc_6)
				{
					this.previewIndex = _loc_6.index;
				}
				else
				{
					this.previewIndex = 0;
				}
			}
			else
			{
				GlobalVars.previewDuration = 0;
			}
			return "succ";
		}// end function
		
		private function getFormat(param1:Object, param2:Boolean = false) : Vector.<VideoFormat>
		{
			var _loc_3:VideoFormat = null;
			var _loc_5:Object = null;
			var _loc_8:int = 0;
			var _loc_9:int = 0;
			var _loc_10:int = 0;
			var _loc_4:int = 0;
			var _loc_6:* = new Vector.<VideoFormat>;
			var _loc_7:Boolean = false;
			if (param1 == null || param1.cnt == null || param1.fi == null)
			{
				return null;
			}
			_loc_8 = PlayerUtils.getXmlObjLength(param1.fi);
			if (_loc_8 != param1.cnt * 1 || _loc_8 == 0)
			{
				return null;
			}
			_loc_9 = 1;
			_loc_10 = 0;
			while (_loc_10 < _loc_8)
			{
				
				_loc_5 = PlayerUtils.getXmlObj(param1.fi, _loc_10);
				if (!_loc_5.br || !_loc_5.id || !_loc_5.name || !_loc_5.sl)
				{
					return null;
				}
				_loc_9 = _loc_5.sb == "0" ? (0) : (1);
				_loc_3 = new VideoFormat(_loc_5.name, _loc_5.id, _loc_5.br * 1, 0, 0, _loc_9);
				GlobalVars.dicStFormat[_loc_5.id] = _loc_9;
				if (_loc_7 == false && _loc_5.sl == "1")
				{
					_loc_3.sel = 1;
					_loc_4 = _loc_10;
					_loc_7 = true;
				}
				_loc_6.push(_loc_3);
				_loc_10++;
			}
			if (!_loc_7)
			{
				_loc_3.sel = 1;
				_loc_4 = _loc_6.length - 1;
			}
			if (param2 && videodata.playformat == _loc_6[_loc_4].name)
			{
				return null;
			}
			videodata.video_curfmt = _loc_6[_loc_4];
			videodata.playformat = videodata.video_curfmt.name;
			return _loc_6;
		}// end function
		
		/*private function getSubtitle(param1:Object) : Vector.<SubtitleMode>
		{
			var _loc_2:SubtitleMode = null;
			var _loc_4:Object = null;
			if (param1 == null || param1.fi == null || param1.cnt == null)
			{
				return null;
			}
			var _loc_3:* = PlayerUtils.getXmlObjLength(param1.fi);
			var _loc_5:* = new Vector.<SubtitleMode>;
			if (_loc_3 != param1.cnt * 1 || _loc_3 == 0)
			{
				return null;
			}
			var _loc_6:int = 0;
			while (_loc_6 < _loc_3)
			{
				
				_loc_4 = PlayerUtils.getXmlObj(param1.fi, _loc_6);
				if (!_loc_4.id || !_loc_4.name)
				{
					return null;
				}
				_loc_2 = new SubtitleMode(_loc_4.id, _loc_4.name);
				_loc_5.push(_loc_2);
				_loc_6++;
			}
			return _loc_5;
		}// end function*/
		
		//格式化,重写代码
		private function analyzeInfoNode(param1:Object, param2:Vector.<VideoPlayModeV3> = null) : Boolean
		{
			var _loc_3:VideoPlayModeV3 = null;
			var _loc_5:Object = null;
			var _loc_6:Object = null;
			var _loc_11:int = 0;
			var _loc_12:int = 0;
			var _loc_13:int = 0;
			var _loc_4:* = PlayerUtils.getXmlObjLength(param1);
			var _loc_7:Number = 0;
			var _loc_8:int = 0;
			var _loc_9:String = "";
			if (!GlobalVars.arraySplitTime)
			{
				GlobalVars.arraySplitTime = [];
			}
			if (GlobalVars.arraySplitTime.length > 0)
			{
				GlobalVars.arraySplitTime.splice(0, GlobalVars.arraySplitTime.length);
			}
			var _loc_10:int = 0;
			
			while (_loc_10 < _loc_4)
			{
				
				_loc_5 = PlayerUtils.getXmlObj(param1, _loc_10);
				if (_loc_5 && _loc_5.ch)
				{
					GlobalVars.payedVideoStatus = _loc_5.ch;//支付状态
				}
				//这里好像出错,一会儿再来看下//好像是PLAYLIST功能.具体再看
				if (_loc_5.cl && _loc_5.cl.ci && _loc_5.cl.fc && !isNaN(Number(_loc_5.cl.fc)) && Number(_loc_5.cl.fc) > 0)
				{
					_loc_11 = Number(_loc_5.cl.fc);
					if (_loc_11 != PlayerUtils.getXmlObjLength(_loc_5.cl.ci))
					{
						return false;
					}
					_loc_12 = 0;
					while (_loc_12 < _loc_11)
					{
						
						_loc_13 = 0;
						while (_loc_13 < _loc_11)
						{
							
							_loc_6 = PlayerUtils.getXmlObj(_loc_5.cl.ci, _loc_13);
							if ((_loc_12 + 1) == _loc_6.idx * 1)
							{
								_loc_3 = new VideoPlayModeV3(videodata.video_curfmt.id, _loc_5.lnk, Number(_loc_6.cd));
								_loc_3.setOuterStartTime(_loc_7);
								_loc_7 = _loc_7 + Number(_loc_6.cd);
								_loc_3.setOuterEndTime(_loc_7);
								GlobalVars.arraySplitTime.push(_loc_7);
								_loc_3.index = _loc_8;
								_loc_3.idx = _loc_12 + 1;
								_loc_3.width = Number(_loc_5.vw);
								_loc_3.height = Number(_loc_5.vh);
								_loc_3.filesize = Number(_loc_6.cs);
								_loc_3.outerBytesTotal = Number(_loc_6.cs);;
								_loc_3.outerDuration = Number(_loc_6.cd);
								_loc_3.splitIndex = _loc_12 + 1;
								if (_loc_5.ch)
								{
									_loc_3.payed = _loc_5.ch;
								}
								if (_loc_5.type != null)
								{
									_loc_3.rtype = _loc_5.type;
								}
								/*if(_loc_6.start){
									
									_loc_6.start = _loc_6.start;
								}*/
								_loc_3.byteRate = videodata.video_br;
								_loc_3.formatName = videodata.video_curfmt.name;
								_loc_3.filename = _loc_5.fn;
								//这里是根据分段计算是视频的播放地址
								//_loc_9 = this.getSplitFilename(_loc_5.fn, (_loc_12 + 1));
								_loc_9 = _loc_6.keyid;
								
								//_loc_9 = this.getSplitFilename(_loc_5.fn, 0);
								_loc_3.filenameSuffix = this.getSplitFileSuffixname(_loc_9);
								_loc_3.urlArray = this.getInfoPath(_loc_5.ul, _loc_5.lnk, _loc_9, _loc_3.filenameSuffix);
								_loc_3.initStreamFactory();
								_loc_8++;
								if (param2 != null)
								{
									if (_loc_3.index == this.currentMode.index)
									{
										param2.push(this.currentMode);
									}
									else
									{
										param2.push(_loc_3);
									}
								}
								else
								{
									this.arrayModes.push(_loc_3);
								}
								break;
							}
							_loc_13++;
						}
						_loc_12++;
					}
				}
				else
				{
					_loc_3 = new VideoPlayModeV3(videodata.video_curfmt.id, _loc_5.lnk, Number(_loc_5.td));
					_loc_3.setOuterStartTime(_loc_7);//视频开始时间
					_loc_7 = _loc_7 + Number(_loc_5.td); //总时长
					_loc_3.setOuterEndTime(_loc_7);//结束时长
					GlobalVars.arraySplitTime.push(_loc_7);
					_loc_3.index = _loc_8;
					_loc_3.outerDuration = Number(_loc_5.td);//总时长(单条时长)
					_loc_3.byteRate = videodata.video_br;//音频码率?
					_loc_3.formatName = videodata.video_curfmt.name;//播放类型
					_loc_3.filename = _loc_5.fn;//视频文件名
					_loc_3.width = Number(_loc_5.vw);//视频宽度
					_loc_3.height = Number(_loc_5.vh);//视频高度
					_loc_3.filesize = Number(_loc_5.fs);//文件大小
					_loc_3.outerBytesTotal = Number(_loc_5.fs);//跟上面一样?
					_loc_3.filenameSuffix = this.getSplitFileSuffixname(_loc_5.fn);//根据文件名获取文件后缀
					_loc_3.urlArray = this.getInfoPath(_loc_5.ul, _loc_5.lnk, _loc_5.fn, _loc_3.filenameSuffix);
					if (_loc_5.ch)
					{
						_loc_3.payed = _loc_5.ch;
					}
					if (_loc_5.type != null)
					{
						_loc_3.rtype = _loc_5.type;//播放类型
					}
					_loc_3.initStreamFactory();//流初始化成功
					_loc_8++;
					if (param2 != null)
					{
						if (_loc_3.index == this.currentMode.index)
						{
							param2.push(this.currentMode);
						}
						else
						{
							param2.push(_loc_3);
						}
					}
					else
					{
						this.arrayModes.push(_loc_3);//压入标题FLVMODE
					}
				}
				if (_loc_3.urlArray == null || _loc_3.urlArray.length == 0)
				{
					return false;
				}
				_loc_10++;
			}
			this.videodata.video_duration = _loc_7;
			if (this.arrayModes.length > 0)
			{
				videodata.video_orgWidth = this.arrayModes[0].width;
				videodata.video_orgHeight = this.arrayModes[0].height;
			}
			return true;
		}// end function
		
		//获取缩略图
		private function getTipFormatInfo(param1:Object) : Boolean
		{
			var _loc_2:int = 0;
			var _loc_3:Object = null;
			//var _loc_4:TipBmLevelInfo = null;
			var _loc_5:int = 0;
			if (param1 == null || param1.cnt == null || param1.cnt == "0" || param1.pd == null)
			{
				return false;
			}
			_loc_2 = PlayerUtils.getXmlObjLength(param1.pd);
			if (_loc_2 != param1.cnt * 1 || _loc_2 == 0)
			{
				return false;
			}
			/*if (!GlobalVars.arrayTipLevelInfo)
			{
				GlobalVars.arrayTipLevelInfo = new Vector.<TipBmLevelInfo>;
			}
			else if (GlobalVars.arrayTipLevelInfo.length > 0)
			{
				GlobalVars.arrayTipLevelInfo.splice(0, GlobalVars.arrayTipLevelInfo.length);
			}*/
			_loc_5 = 0;
			/*while (_loc_5 < _loc_2)
			{
				
				_loc_3 = PlayerUtils.getXmlObj(param1.pd, _loc_5);
				_loc_4 = new TipBmLevelInfo();
				if (_loc_3.cd && !isNaN(Number(_loc_3.cd)))
				{
					_loc_4.clipDura = Number(_loc_3.cd);
				}
				if (_loc_3.url)
				{
					_loc_4.url = _loc_3.url;
				}
				if (_loc_3.fmt)
				{
					_loc_4.format = _loc_3.fmt;
				}
				if (_loc_3.fn)
				{
					_loc_4.filename = _loc_3.fn;
				}
				if (_loc_3.c && !isNaN(Number(_loc_3.c)))
				{
					_loc_4.columnCount = Number(_loc_3.c);
				}
				if (_loc_3.r && !isNaN(Number(_loc_3.r)))
				{
					_loc_4.rowCount = Number(_loc_3.r);
				}
				if (_loc_3.w && !isNaN(Number(_loc_3.w)))
				{
					_loc_4.imgWidth = Number(_loc_3.w);
				}
				if (_loc_3.h && !isNaN(Number(_loc_3.h)))
				{
					_loc_4.imgHeight = Number(_loc_3.h);
				}
				GlobalVars.arrayTipLevelInfo.push(_loc_4);
				_loc_5++;
			}
			if (GlobalVars.arrayTipLevelInfo.length > 0)
			{
				return true;
			}*/
			return false;
		}// end function
		//计算视频播放地址
		private function getInfoPath(param1:Object, param2:String, param3:String, param4:String) : Vector.<ModeUrl>
		{
			var urlArray:Vector.<ModeUrl>;
			var ui:Object;
			var modeurl:ModeUrl;
			var uilength:int;
			var i:int;
			var defaultObj:Object;
			var ul:* = param1;
			var vid:* = param2;
			var fn:* = param3;
			var filenameSuffix:* = param4;
			urlArray = new Vector.<ModeUrl>;
			var uis:* = ul.ui;
			try
			{
				uilength = PlayerUtils.getXmlObjLength(uis);
				i;
				while (i < uilength)
				{
					
					ui = PlayerUtils.getXmlObj(uis, i);
					modeurl = new ModeUrl();
					if (ui.url == null || ui.url == "")
					{
					}
					else
					{
						//这里进行标准模拟测试
						if (ui.url && ui.url.indexOf(vid + ".flv") == -1 && ui.url.indexOf(vid + ".mp4") == -1)
						{
							modeurl.url = ui.url + fn;
							/*if((start == 0) && (end == 0)){
								modeurl.url = ui.url + fn;
							}else{
								
								modeurl.url = ui.url + fn + "?start="+start+"&end="+end;
							
							}*/
							//modeurl.url = ui.url+'?start=20&end=40';
						}
						else
						{
							modeurl.url = ui.url;
						}
						modeurl.orgurl = ui.url;
						if (ui.vt)
						{
							modeurl.vt = Number(ui.vt);
						}
						//这里好像是P2P技术的东西..先不测试了
						/*if (modeurl.url.indexOf("sdtfrom") == -1)
						{
							if (modeurl.url.indexOf("?") > -1)
							{
								modeurl.url = modeurl.url + ("&sdtfrom=" + SdtFromGetter.getSdtFrom(GlobalVars.usingHost, GlobalVars.p2pStreamType == StreamFactory.STREAMTYPE_NATIVE, GlobalVars.ptag));
							}
							else
							{
								modeurl.url = modeurl.url + ("?sdtfrom=" + SdtFromGetter.getSdtFrom(GlobalVars.usingHost, GlobalVars.p2pStreamType == StreamFactory.STREAMTYPE_NATIVE, GlobalVars.ptag));
							}
						}*/
						if (ui.dt == "1")
						{
							modeurl.filetype = PlayerEnum.FT_FLV;
						}
						else if (ui.dt == "2")
						{
							modeurl.filetype = PlayerEnum.FT_MP4;
						}
						else
						{
							modeurl.filetype = PlayerEnum.FT_UNKNOW;
						}
						if (ui.dtc && !isNaN(ui.dtc * 1))
						{
							modeurl.dtc = ui.dtc * 1;
						}
						urlArray.push(modeurl);
					}
					i = (i + 1);
				}
			}
			catch (e:Error)
			{
				urlArray.splice(0, urlArray.length);
			}
			if (urlArray.length == 0)
			{
				modeurl = new ModeUrl();
				defaultObj = PlayerUtils.getDefaultPath(vid, GlobalVars.usingHost, filenameSuffix);
				modeurl.url = defaultObj.flvPath;
				modeurl.orgurl = defaultObj.orgurl;
				if (GlobalVars.outvt == -1)
				{
					modeurl.vt = defaultObj.vtype;
				}
				else
				{
					modeurl.vt = GlobalVars.outvt;
				}
				modeurl.filetype = PlayerEnum.FT_UNKNOW;
				urlArray.push(modeurl);
			}
			return urlArray;
		}// end function
		
		private function getSplitFilename(param1:String, param2:int) : String
		{
			if (param2 == 0)
			{
				return param1;
			}
			var _loc_3:* = param1.lastIndexOf(".");
			var _loc_4:* = param1.substr(0, _loc_3) + "." + param2 + param1.substring(_loc_3);
			return param1.substr(0, _loc_3) + "." + param2 + param1.substring(_loc_3);
			//return param1+"?start="+start+"&end="+end;
		}// end function
		
		private function getSplitFileSuffixname(param1:String) : String
		{
			var _loc_2:* = param1.indexOf(".");
			var _loc_3:* = param1.substr(_loc_2);
			return _loc_3;
		}// end function
		
		private function playErrorHandler(param1:int, param2:Number = 0) : void
		{
			dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAY_NOMAL_ERROR, {code:param1, em:param2}));
			return;
		}// end function
		
		override public function destroy() : void
		{
			super.destroy();
			if (VideoInfoGetter.instance.hasEventListener(VideoInfoGetterEvent.VIDEOINFO_SUCC))
			{
				VideoInfoGetter.instance.removeEventListener(VideoInfoGetterEvent.VIDEOINFO_ERROR, this.videoinfoGetError);
				VideoInfoGetter.instance.removeEventListener(VideoInfoGetterEvent.VIDEOINFO_SUCC, this.videoinfoGetSucc);
			}
			VideoInfoGetter.instance.destroy();
			this.stop();
			return;
		}// end function
		
		override public function setRange(param1:PlayTime) : void
		{
			if (param1.starttime < param1.endtime && param1.starttime >= 0)
			{
				rangePlay = true;
			}
			else
			{
				rangePlay = false;
				var _loc_2:int = 0;
				videodata.playtimeInfo.endtime = 0;
				videodata.playtimeInfo.starttime = _loc_2;

				param1.starttype = PlayTime.TYPE_NONE;
				param1.endtype = PlayTime.TYPE_NONE;
			}
			this.the1stRequest = true;
			this.the1stGetMetadata = true;
			this.videodata.playtimeInfo = param1;
			return;
		}// end function
		//进入播放步骤...注意安全
		override public function play(param1:VideoPlayData = null) : void
		{
			trace('这里是需要播放的。。');
			var _loc_2:PlayTime = null;
			this.errorRequestCount = 0;
			this.errorReqeustNextCount = 0;
			super.play(param1);//设置播放状态
			
			if (param1)//可以指定播放内容,否则播放数组内的东西
			{
				this.setVideoData(param1);
				return;
			}
			
			
			if (this.arrayModes && this.arrayModes.length > 0 && this.videodata)//最后的一个变量后面再跟踪下
			{
				if (this.videodata.playtimeInfo)
				{
					_loc_2 = this.videodata.playtimeInfo;
					if (_loc_2.endtime < _loc_2.starttime && _loc_2.endtime == 0)
					{
						_loc_2.endtime = this.videodata.video_duration;
					}
					if (_loc_2.endtime > this.videodata.video_duration)
					{
						_loc_2.endtime = this.videodata.video_duration;
					}
					if (_loc_2.starttype == PlayTime.TYPE_HISTORY && _loc_2.endtime == 0 && _loc_2.starttime > 0 && _loc_2.starttime < this.videodata.video_duration)//这个应该是播放历史记录的.这里先用不上
					{
						_loc_2.endtime = this.videodata.video_duration;
						_loc_2.endtype = PlayTime.TYPE_HISTORY;
					}
					if (_loc_2.starttime < _loc_2.endtime && _loc_2.starttime >= 0)//重新播放
					{
						rangePlay = true;
					}
					else
					{
						rangePlay = false;

						_loc_2.endtime = 0;
						_loc_2.starttime = 0;
					
						_loc_2.starttype = PlayTime.TYPE_NONE;
						_loc_2.endtype = PlayTime.TYPE_NONE;
					}
					this.currentMode = this.getModeByTime(_loc_2.starttime);//播放时间检测
					if (!this.currentMode)
					{
						this.playErrorHandler(PlayerEnum.PLAYERROR_PLAYINIT);
						return;
					}
					
					
					
					
					
					
					//var _loc_3:* = this.currentMode.index;
					//三个索引变量好像有些用处
					this.modeIndex = this.currentMode.index;
					this.currIndex = this.currentMode.index;
					this.currLoadIndex = this.currentMode.index;//载入索引?
					if (param1 == null || param1.video_changeformat == false)
					{
						this.startId = this.currIndex;
					}
					this.currentMode.urlCount = 0;//统计?
					this.the1stRequest = true;
					this.the1stGetMetadata = true;
					this.reportPlayStatus = PlayerEnum.STATE_REQUESTING;
					setPlayerState(PlayerEnum.STATE_REQUESTING);
					AS3Debugger.Trace("HttpVideoPlayr::play video " + _loc_2.starttime);
					if (!this.currentMode.hasEventListener(FlvPlayModeV3Event.STATUS_CHANGE))
					{
						this.currentMode.addEventListener(FlvPlayModeV3Event.STATUS_CHANGE, this.playModeStatusChange);
					}
					
					//this.currentMode.loadVideo(_loc_2.starttime, this.videodata.buffertime, this.videodata.waittime);
					this.currentMode.loadVideo(_loc_2.starttime, this.videodata.buffertime, 0);//测试修改加载时间
					
				}
			}
			else
			{
				this.playErrorHandler(PlayerEnum.ST_ERROR_ARGS);
			}
			return;
		}// end function
		//仅作状态报告及相关的处理..这里并不是视频监听的主要地方
		private function playModeStatusChange(event:FlvPlayModeV3Event) : void
		{
			
			
			var changeurl:int;
			var valcu:Number;
			var time:Number;
			var lastime:Number;
			var starttime:Number;
			var i:int;
			var newmode:VideoPlayModeV3;
			var event:* = event;
			var info:* = event.value;
			/*
			trace('---------------状态报告----------------');
			trace(info.code);
			ExternalInterface.call("sayHello", info.code); 
			trace('---------------状态报告----------------');
			*/
			
			/*trace('---------------状态报告----------------');
			trace(info.code);
			trace('---------------状态报告----------------');
			*/
			switch(info.code)
			{
				case "startToLoad":
				{
					//this.vodPlay.onStateChanged(GSVideoState.BUFFERING);
					
					this.dlMode = this.currentMode;
					this.rpt_complete = 0;
					this.rpt_starttoload = getTimer();
					AS3Debugger.Trace("HttpVideoPlayer::startToLoad");
					this.part2edStreamStarted = false;
					dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAY_STATUS_CHANGED, {code:"starttoload", first:this.the1stRequest}));
					break;
				}
				case "ready":
				{
					AS3Debugger.Trace("HttpVideoPlayer::ready");
					if (this.the1stRequest)
					{
						this.currentMode.play();
					}
					this.attachNetstream();
					this.modeIndex = this.currentMode.index;
					dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAY_STATUS_CHANGED, {code:"ready", first:this.the1stRequest}));
					break;
				}
				case "startToPlay":
				{
					AS3Debugger.Trace("HttpVideoPlayer:startToPlay");
					this.errorRequestCount = 0;
					isBufferring = false;
					this.rpt_starttoplay = getTimer();
					changeurl = this.currentMode.changedUrl ? (ReportManager.REQUEST_CHANGEDURL_SUCC) : (ReportManager.REQUEST_FIRST_SUCC);
					if (this.rpt_complete != 0)
					{
						this.reportRequestVal(this.currentMode, this.rpt_starttoplay - this.rpt_complete, changeurl);
						this.currentMode.setUserWaittime();
						this.reportUserWaitVal(this.currentMode, this.rpt_starttoplay - this.rpt_complete, -1);
						this.rpt_complete = 0;
						this.rpt_starttoload = 0;
					}
					else if (this.rpt_starttoload != 0)
					{
						this.reportRequestVal(this.currentMode, this.rpt_starttoplay - this.rpt_starttoload, changeurl);
						this.rpt_starttoload = 0;
					}
					setPlayerState(PlayerEnum.STATE_PLAYING);
					this.lastGcTime = getTimer();
					if (progressTimer && !progressTimer.isRunning())
					{
						progressTimer.restart();
					}
					dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAY_STATUS_CHANGED, {code:"starttoplay", first:this.the1stRequest}));
					this.the1stRequest = false;
					break;
				}
				case "getmetadata":
				{
					AS3Debugger.Trace("HttpVideoPlayer::getmetadata");
					if (this.videodata.video_duration == 0 || this.arrayModes.length == 1)
					{
						this.videodata.video_duration = this.currentMode.outerDuration;
					}
					if (info.starttime != null && info.starttime != 0)
					{
						ReportManager.addReport(ReportManager.createReportModeByVideoMode(ReportManager.STEP_RESPONSE_SEEK, this.currentMode.responseTimeCount, info.starttime, 0, this.getPlayTime(), this.currentMode));
					}
					if (this.the1stGetMetadata)
					{
						this.videodata.video_orgWidth = this.currentMode.width;
						this.videodata.video_orgHeight = this.currentMode.height;
						this.the1stGetMetadata = false;
					}
					dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAY_STATUS_CHANGED, {code:"getmetadata"}));
					break;
				}
				case "error404":
				case "error":
				{
					
					
					//this.vodPlay.onStateChanged(GSVideoState.BUFFERING);
					//GlobalVars._vodPlay.onStateChanged("CONNECTION_ERROR");
					
					this.errorRequestCount =this.errorRequestCount + 1;
					changeurl = this.currentMode.changedUrl ? (ReportManager.REQUEST_CHANGEDURL_FAILED) : (ReportManager.REQUEST_FIRST_FAILED);
					this.rpt_error = getTimer();
					valcu = this.rpt_complete != 0 ? (this.rpt_error - this.rpt_complete) : (this.rpt_error - this.rpt_starttoload);
					this.reportChangeUrlError(this.currentMode, valcu, changeurl);
					if (this.rpt_complete != 0)
					{
						if (this.currentMode.getVideoStarted())
						{
							this.reportRequestErrorVal(this.currentMode, 0, ReportManager.REQUESTERROR_PLAY_CODE);
						}
						else if (info && info.type == 2)
						{
							this.reportLDERVal(this.currentMode, this.rpt_error - this.rpt_complete, changeurl);
						}
						else
						{
							this.reportRequestVal(this.currentMode, this.rpt_error - this.rpt_complete, changeurl);
						}
						this.rpt_complete = 0;
						this.rpt_starttoload = 0;
					}
					else if (this.rpt_starttoload != 0)
					{
						if (this.currentMode.getVideoStarted())
						{
							this.reportRequestErrorVal(this.currentMode, 0, ReportManager.REQUESTERROR_PLAY_CODE);
						}
						else if (info && info.type == 2)
						{
							this.reportLDERVal(this.currentMode, this.rpt_error - this.rpt_complete, changeurl);
						}
						else
						{
							this.reportRequestVal(this.currentMode, this.rpt_error - this.rpt_starttoload, changeurl);
						}
						this.rpt_starttoload = 0;
					}
					AS3Debugger.Trace("HttpVideoPlayer::error " + this.errorRequestCount);
					//setTimeout(this.testVideoContent, 3000, this.currentMode.clone());
					if (this.errorRequestCount <= this.ERROR_MAX_TRYTIME)
					{
						starttime = this.currentMode.playStarttime;
						if (this.currentMode.getVideoStarted())
						{
							starttime = this.getPlayTime();
						}
						this.currentMode.changeUrl();
						if (this.arrayModes && this.arrayModes.length > 1)
						{
							i;
							while (i < this.arrayModes.length)
							{
								
								if (!this.arrayModes[i].modeLoaded && this.currentMode.index != this.arrayModes[i].index)
								{
									this.arrayModes[i].changeUrl(false);
								}
								i = (i + 1);
							}
						}
						if (!this.currentMode.hasEventListener(FlvPlayModeV3Event.STATUS_CHANGE))
						{
							trace('1111111111111111111111');
							this.currentMode.addEventListener(FlvPlayModeV3Event.STATUS_CHANGE, this.playModeStatusChange);
						}
						this.currentMode.loadVideo(starttime, videodata.buffertime, videodata.waittime);
					}
					else
					{
						this.currentMode.close();
						this.currentMode.resetMode();
						trace('0000000000000');
						this.currentMode.removeEventListener(FlvPlayModeV3Event.STATUS_CHANGE, this.playModeStatusChange);
						setPlayerState(PlayerEnum.STATE_STOP);
						dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAY_STATUS_CHANGED, {code:"error"}));
					}
					break;
				}
				case "playComplete":
				{
					
					
					//播放完成发送另一个消息
					
					
					
					
					
					
					this.part2edStreamStarted = false;
					videodata.video_changeformat = false;
					this.rpt_complete = 0;
					GlobalVars.preformat = this.getCurrFormat();
					GlobalVars.preformatName = this.getCurrFormatName();
					if (this.currIndex < (this.arrayModes.length - 1))
					{
						if (this.currentMode.hasEventListener(FlvPlayModeV3Event.STATUS_CHANGE))
						{
							trace('aaaaaaaaaaaaaaaaaaaa');
							this.currentMode.removeEventListener(FlvPlayModeV3Event.STATUS_CHANGE, this.playModeStatusChange);
						}
						this.currentMode.setUserWaittime();
						newmode = this.getModeByIndex((this.currIndex + 1));
						if (newmode.hasEventListener(FlvPlayModeV3Event.STATUS_CHANGE))
						{
							newmode.removeEventListener(FlvPlayModeV3Event.STATUS_CHANGE, this.playModeBeforeStatusChange);
						}
						newmode.volume = volume;
						this.currentMode = newmode;
						if (!this.currentMode.hasEventListener(FlvPlayModeV3Event.STATUS_CHANGE))
						{
							trace('xxxxxxxxxxxxxxxxxxxxxxxx');
							this.currentMode.addEventListener(FlvPlayModeV3Event.STATUS_CHANGE, this.playModeStatusChange);
						}
						this.attachNetstream();
						this.modeIndex = this.currentMode.index;
						
						this.currIndex = this.currIndex + 1;
						this.jumpVideoTimeout = setTimeout(function ():void
						{
							var _loc_1:* = undefined;
							if (currentMode.readyToPlay)
							{
								currentMode.seekToStart();
								currentMode.play();
								AS3Debugger.Trace("HttpVideoPlayer::playComplete " + currIndex);
								_loc_1 = 0;
								if (currentMode.getLoadOvertime() != 0)
								{
									_loc_1 = currentMode.getLoadOvertime() - currentMode.getLoadtime();
								}
								else
								{
									_loc_1 = getTimer() - currentMode.getLoadtime();
								}
								currentMode.setUserWaittime();
								reportUserWaitVal(currentMode, 0, _loc_1);
								AS3Debugger.Trace("HttpVideoPlayer::playComplete changesplit ready");
								dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAY_STATUS_CHANGED, {code:"changesplit", msg:"ready"}));
							}
							else
							{
								rpt_complete = getTimer();
								currentMode.close();
								currentMode.resetMode();
								
								/*if (currentMode.changedUrl && GlobalVars.p2pStreamType == StreamFactory.STREAMTYPE_CLOUDACC)
								{
									AS3Debugger.Trace("HttpVideoPlayer::playComplete change p2p");
									dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAY_STATUS_CHANGED, {code:"changp2p"}));
									return;
								}*/
								startToLoadNextMode(currentMode, false);
								AS3Debugger.Trace("HttpVideoPlayer::playComplete changesplit not ready");
								dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAY_STATUS_CHANGED, {code:"changesplit", msg:"unready"}));
							}
							if (progressTimer && !progressTimer.isRunning())
							{
								progressTimer.restart();
							}
							return;
						}// end function
							, 15);
					}
					else
					{
						AS3Debugger.Trace("HttpVideoPlayer::playComplete");
						this.playCompleteHandler();
					}
					break;
				}
				case "empty":
				{
					//GlobalVars._vodPlay.onStateChanged("BUFFERING");//缓冲中
					
					if (this.currentMode.loadPosition == 1)
					{
						return;
					}
					isBufferring = true;
					this.rpt_emptylast = this.rpt_empty;
					this.rpt_empty = getTimer();
					dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAY_STATUS_CHANGED, {code:"empty"}));
					break;
				}
				case "full":
				{
					isBufferring = false;
					this.rpt_full = getTimer();
					time = this.rpt_full - this.rpt_empty;
					lastime;
					if (this.rpt_emptylast != 0 && this.rpt_empty != 0)
					{
						lastime = this.rpt_empty - this.rpt_emptylast;
					}
					if (this.rpt_empty != 0 && time > 0)
					{
						this.reportBufferTimeVal(this.currentMode, time);
					}
					dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAY_STATUS_CHANGED, {code:"full"}));
					break;
				}
				case "key":
				{
					AS3Debugger.Trace("HttpVideoPlayer::key");
					this.currentMode.close();
					this.currentMode.resetMode();
					trace('xxxxxxxxxxxcccccccccccccc');
					this.currentMode.removeEventListener(FlvPlayModeV3Event.STATUS_CHANGE, this.playModeStatusChange);
					setPlayerState(PlayerEnum.STATE_STOP);
					if (info.msg == "refesh")
					{
						dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAY_STATUS_CHANGED, {code:"refesh", em:info.codenum}));
					}
					else
					{
						dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAY_STATUS_CHANGED, {code:"couldnowatch", em:info.codenum}));
					}
					break;
				}
				case "loadComplete":
				{
					dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAY_STATUS_CHANGED, {code:"loadComplete"}));
					if (this.currentMode.filesize - this.currentMode.bytesLoaded > 600000)
					{
						this.reportRequestErrorVal(this.currentMode, 0, ReportManager.REQUESTERROR_DOWMLOAD_CODE);
					}
					else
					{
						this.reportBufferCountVal(this.currentMode);
					}
					break;
				}
				case "lowspeed":
				{
					break;
				}
				case "playCompleteError":
				{
					//GlobalVars._vodPlay.onStateChanged("CONNECTION_ERROR");//缓冲中
					
					if (progressTimer && progressTimer.isRunning())
					{
						progressTimer.stop();
					}
					
					setPlayerState(PlayerEnum.STATE_SEEKED);
					trace('暂停位置1');
					this.reportPlayStatus = PlayerEnum.STATE_SEEKED;
					videodata.video_changeformat = false;
					this.closeUsingMode();
					this.currentMode.loadVideo(this.getPlayTime(), videodata.secBuffertime, videodata.waittime, false, 0, true);
					this.reportRequestErrorVal(this.currentMode, 1, ReportManager.REQUESTERROR_PLAY_CODE);
					break;
				}
				default:
				{
					break;
				}
			}
			return;
		}// end function
		//播放前状态检测
		private function playModeBeforeStatusChange(event:FlvPlayModeV3Event) : void
		{
			var _loc_4:int = 0;
			var _loc_5:Number = NaN;
			var _loc_6:int = 0;
			var _loc_2:* = event.currentTarget as VideoPlayModeV3;
			var _loc_3:* = event.value;
			trace('---------playModeBeforeStatusChange-------------');
			trace(_loc_3.code);
			trace('---------playModeBeforeStatusChange-------------');
			switch(_loc_3.code)
			{
				case "startToLoad":
				{
					this.dlMode = _loc_2;
					AS3Debugger.Trace("HttpVideoPlayer::startToLoad next");
					this.nextVideoDownError = false;
					this.rpt_nextload = getTimer();
					break;
				}
				case "ready":
				{
					AS3Debugger.Trace("HttpVideoPlayer::ready next");
					this.nextVideoDownError = false;
					_loc_2.volume = 0;
					break;
				}
				case "startToPlay":
				{
					_loc_2.pause();
					this.nextVideoDownError = false;
					if (progressTimer && !progressTimer.isRunning())
					{
						progressTimer.restart();
					}
					_loc_4 = _loc_2.changedUrl ? (ReportManager.REQUEST_CHANGEDURL_SUCC) : (ReportManager.REQUEST_FIRST_SUCC);
					this.reportRequestVal(_loc_2, getTimer() - this.rpt_nextload, _loc_4);
					break;
				}
				case "error404":
				case "error":
				{
					
					this.errorReqeustNextCount = this.errorReqeustNextCount + 1;
					_loc_4 = _loc_2.changedUrl ? (ReportManager.REQUEST_CHANGEDURL_FAILED) : (ReportManager.REQUEST_FIRST_FAILED);
					AS3Debugger.Trace("HttpVideoPlayer::error next");
					this.rpt_nexterror = getTimer();
					this.reportChangeUrlError(_loc_2, this.rpt_nexterror - this.rpt_nextload, _loc_4);
					if (_loc_3 && _loc_3.type == 2)
					{
						this.reportLDERVal(_loc_2, this.rpt_nexterror - this.rpt_nextload, _loc_4);
					}
					else
					{
						this.reportRequestVal(_loc_2, this.rpt_nexterror - this.rpt_nextload, _loc_4);
					}
					//setTimeout(this.testVideoContent, 3000, _loc_2.clone());
					if (this.errorReqeustNextCount <= this.ERROR_NEXT_TRYTIME)
					{
						_loc_5 = _loc_2.playStarttime;
						_loc_2.changeUrl();
						if (this.arrayModes && this.arrayModes.length > 1)
						{
							_loc_6 = 0;
							while (_loc_6 < this.arrayModes.length)
							{
								
								if (!this.arrayModes[_loc_6].modeLoaded && _loc_2.index != this.arrayModes[_loc_6].index && this.currentMode && this.currentMode.index != this.arrayModes[_loc_6].index)
								{
									this.arrayModes[_loc_6].changeUrl(false);
								}
								_loc_6++;
							}
						}
						if (!_loc_2.hasEventListener(FlvPlayModeV3Event.STATUS_CHANGE))
						{
							_loc_2.addEventListener(FlvPlayModeV3Event.STATUS_CHANGE, this.playModeBeforeStatusChange);
						}
						_loc_2.loadVideo(_loc_5, videodata.buffertime, videodata.waittime);
					}
					else
					{
						_loc_2.removeEventListener(FlvPlayModeV3Event.STATUS_CHANGE, this.playModeBeforeStatusChange);
						this.nextVideoDownError = true;
					}
					break;
				}
				case "key":
				{
					this.nextVideoDownError = true;
					break;
				}
				case "loadComplete":
				{
					dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAY_STATUS_CHANGED, {code:"loadComplete"}));
					if (_loc_2.filesize - _loc_2.bytesLoaded > 600000)
					{
						this.reportRequestErrorVal(_loc_2, 0, ReportManager.REQUESTERROR_DOWMLOAD_CODE);
					}
					else
					{
						this.reportBufferCountVal(_loc_2);
					}
					break;
				}
				case "lowspeed":
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
		
		private function getModeByTime(param1:Number) : VideoPlayModeV3
		{
			var _loc_2:VideoPlayModeV3 = null;
			if (param1 < 0)
			{
				param1 = 0;
			}
			else if (param1 > videodata.video_duration)
			{
				param1 = videodata.video_duration;
			}
			var _loc_3:int = 0;
			while (_loc_3 < this.arrayModes.length)
			{
				
				_loc_2 = this.arrayModes[_loc_3];
				if (_loc_2.getOuterStartTime() <= param1 && _loc_2.getOuterEndTime() > param1)
				{
					break;
				}
				_loc_3++;
			}
			return _loc_2;
		}// end function
		
		private function getModeByIndex(param1:uint) : VideoPlayModeV3
		{
			if (param1 > (this.arrayModes.length - 1))
			{
				param1 = this.arrayModes.length - 1;
			}
			return this.arrayModes[param1];
		}// end function
		
		private function getModeByPosition(param1:Number) : VideoPlayModeV3
		{
			var _loc_2:VideoPlayModeV3 = null;
			if (param1 < 0)
			{
				param1 = 0;
			}
			else if (param1 > 1)
			{
				param1 = 1;
			}
			var _loc_3:* = param1 * videodata.video_duration;
			var _loc_4:int = 0;
			while (_loc_4 < this.arrayModes.length)
			{
				
				_loc_2 = this.arrayModes[_loc_4];
				if (_loc_2.getOuterStartTime() <= _loc_3 && _loc_2.getOuterEndTime() > _loc_3)
				{
					break;
				}
				_loc_4++;
			}
			return _loc_2;
		}// end function
		
		override protected function onProgress(event:Event = null) : void
		{
			super.onProgress(event);
			if (!this.currentMode)
			{
				return;
			}
			if (this.currentMode && rangePlay && this.getPlayTime() > videodata.playtimeInfo.endtime && getPlayerState() != PlayerEnum.STATE_SEEKING)
			{
				AS3Debugger.Trace("HttpVideoPlayer::rangestop");
				rangePlay = false;
				dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAY_STATUS_CHANGED, {code:"rangestop"}));
			}
			if (getPlayerState() != PlayerEnum.STATE_SEEKING && !this.part2edStreamStarted && this.currentMode.streamLoadCompleted && this.currIndex < (this.arrayModes.length - 1) && this.checkTimeDisdenc() > 0.05 && (!GlobalVars.isPreviewVideo || this.currIndex < this.previewIndex))
			{
				this.requestNewMode = this.getModeByIndex((this.currIndex + 1));
				if (this.requestNewMode.startTime == 0 && this.requestNewMode.loadPosition > 0)
				{
				}
				else
				{
					this.startToLoadNextMode(this.requestNewMode);
				}
			}
			if (getTimer() - this.lastGcTime > 1200000)
			{
				this.lastGcTime = getTimer();
				this.closeUsingMode(false);
			}
			return;
		}// end function
		
		override public function getDlSpeed() : Number
		{
			if (this.dlMode)
			{
				return this.dlMode.dlSpeed;
			}
			return 0;
		}// end function
		
		private function checkTimeDisdenc() : Number
		{
			var _loc_1:* = this.currentMode.playTime - this.currentMode.getOuterStartTime();
			return _loc_1 / this.currentMode.outerDuration;
		}// end function
		
		private function startToLoadNextMode(param1:VideoPlayModeV3, param2:Boolean = true) : void
		{
			var newMode:* = param1;
			var addBeforeStatus:* = param2;
			this.part2edStreamStarted = true;
			var start:* = newMode.getOuterStartTime();
			this.errorReqeustNextCount = 0;
			setTimeout(function ():void
			{
				reportPlayStatus = PlayerEnum.STATE_REQUESTING;
				return;
			}// end function
				, 1000);
			if (!newMode.hasEventListener(FlvPlayModeV3Event.STATUS_CHANGE) && addBeforeStatus)
			{
				newMode.addEventListener(FlvPlayModeV3Event.STATUS_CHANGE, this.playModeBeforeStatusChange);
			}
			var usingp2p:Boolean;
			if (this.currentMode)
			{
				usingp2p = this.currentMode.usingP2P;
			}
			newMode.loadVideo(start, this.videodata.secBuffertime, this.videodata.waittime, addBeforeStatus, this.currentMode.modeLeftPlayTime, false, usingp2p);
			return;
		}// end function
		
		private function playCompleteHandler(param1:Boolean = true, param2:Boolean = false) : void
		{
			if (progressTimer && progressTimer.isRunning())
			{
				progressTimer.stop();
			}
			clearTimeout(this.jumpVideoTimeout);
			setPlayerState(PlayerEnum.STATE_STOP);
			if (this.currentMode)
			{
				this.currentMode.pause();
				this.currentMode.seekToStart();
				if (this.currentMode.hasEventListener(FlvPlayModeV3Event.STATUS_CHANGE))
				{
					trace('001121212');
					this.currentMode.removeEventListener(FlvPlayModeV3Event.STATUS_CHANGE, this.playModeStatusChange);
				}
			}
			this.removeModeListener();
			this.reInit();
			this.close(true, param2);
			if (param1)
			{
				dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAY_STATUS_CHANGED, {code:"playComplete"}));
			}
			return;
		}// end function
		
		private function removeModeListener() : void
		{
			var _loc_1:VideoPlayModeV3 = null;
			if (!this.arrayModes)
			{
				return;
			}
			var _loc_2:int = 0;
			while (_loc_2 < this.arrayModes.length)
			{
				
				_loc_1 = this.arrayModes[_loc_2];
				if (_loc_1.hasEventListener(FlvPlayModeV3Event.STATUS_CHANGE))
				{
					removeEventListener(FlvPlayModeV3Event.STATUS_CHANGE, this.playModeStatusChange);
					removeEventListener(FlvPlayModeV3Event.STATUS_CHANGE, this.playModeBeforeStatusChange);
				}
				_loc_2++;
			}
			return;
		}// end function
		
		public function close(param1:Boolean = true, param2:Boolean = false) : void
		{
			var _loc_3:VideoPlayModeV3 = null;
			if (!this.arrayModes)
			{
				return;
			}
			var _loc_4:int = 0;
			while (_loc_4 < this.arrayModes.length)
			{
				
				_loc_3 = this.arrayModes[_loc_4];
				if (param1 || _loc_3.loadPosition != 1)
				{
					try
					{
						_loc_3.close(param2);
						_loc_3.resetMode();
					}
					catch (e:Error)
					{
					}
				}
				_loc_4++;
			}
			return;
		}// end function
		
		public function closeUsingMode(param1:Boolean = true, param2:Boolean = false) : void
		{
			var _loc_4:VideoPlayModeV3 = null;
			if (!this.currentMode || !this.arrayModes)
			{
				return;
			}
			var _loc_3:* = this.currentMode.index;
			var _loc_5:int = 0;
			while (_loc_5 < this.arrayModes.length)
			{
				
				_loc_4 = this.arrayModes[_loc_5];
				if (Math.abs(_loc_4.index - _loc_3) > 2)
				{
					_loc_4.close(true);
					_loc_4.resetMode();
				}
				else if (param1 && _loc_4.loadPosition < 1 && _loc_4.loadPosition > 0)
				{
					_loc_4.close(param2);
					_loc_4.resetMode();
				}
				_loc_5++;
			}
			return;
		}// end function
		
		public function closeAllSeekMode() : void
		{
			var _loc_1:VideoPlayModeV3 = null;
			if (!this.arrayModes)
			{
				return;
			}
			var _loc_2:int = 0;
			while (_loc_2 < this.arrayModes.length)
			{
				
				_loc_1 = this.arrayModes[_loc_2];
				if (_loc_1.loadPosition != 1 && _loc_1.startTime != 0)
				{
					_loc_1.close();
					_loc_1.resetMode();
				}
				_loc_2++;
			}
			return;
		}// end function
		
		override public function pause() : void
		{
			super.pause();
			setPlayerState(PlayerEnum.STATE_PAUSE);
			if (this.currentMode)
			{
				this.currentMode.pause();
			}
			return;
		}// end function
		
		override public function resume() : void
		{
			super.resume();
			setPlayerState(PlayerEnum.STATE_PLAYING);
			if (this.currentMode)
			{
				this.currentMode.resume(-1, this.resumefun, 0);
			}
			return;
		}// end function
		
		private function resumefun() : void
		{
			return;
		}// end function
		
		override public function stop() : void
		{
			super.stop();
			this.playCompleteHandler(false, true);
			return;
		}// end function
		
		override public function getLoadedPercent() : Number
		{
			
			
			
			
			var _loc_1:VideoPlayModeV3 = null;
			var _loc_4:int = 0;
			var _loc_5:int = 0;
			if (!this.currentMode)
			{
				return 0;
			}
			var _loc_2:* = this.getDuration();
			var _loc_3:* = (this.currentMode.getOuterStartTime() + this.currentMode.startTime) / _loc_2 + (this.currentMode.getOuterEndTime() - this.currentMode.getOuterStartTime() - this.currentMode.startTime) * this.currentMode.loadPosition / _loc_2;
			if (this.currentMode.loadPosition == 1 && this.currIndex < (this.arrayModes.length - 1))
			{
				_loc_4 = this.currIndex + 1;
				_loc_5 = this.currIndex;
				do
				{
					
					_loc_1 = this.getModeByIndex(_loc_5);
					if (_loc_1 && _loc_1.startTime == 0 && _loc_1.loadPosition > 0)
					{
						_loc_3 = (_loc_1.getOuterStartTime() + _loc_1.startTime) / _loc_2 + (_loc_1.getOuterEndTime() - _loc_1.getOuterStartTime() - _loc_1.startTime) * _loc_1.loadPosition / _loc_2;
					}
					if (_loc_1.loadPosition != 1)
					{
						break;
					}
					_loc_5++;
				}while (_loc_5 < this.arrayModes.length)
			}
			if (_loc_3 > 0.99)
			{
				_loc_3 = 1;
			}
			
			
			
			
			
			return _loc_3;
		}// end function
		
		override public function getDuration() : Number
		{
			if (!videodata)
			{
				return 0;
			}
			return videodata.video_duration;
		}// end function
		
		override public function get ranSeekAbled() : Boolean
		{
			if (this.currentMode)
			{
				return this.currentMode.ranSeekAbled;
			}
			return false;
		}// end function
		
		override public function getFPS() : Number
		{
			if (this.currentMode)
			{
				return this.currentMode.currentFPS;
			}
			return 0;
		}// end function
		
		override public function getBufferPercent() : Number
		{
			if (this.currentMode)
			{
				return this.currentMode.bufferPercent;
			}
			return 0;
		}// end function
		
		override public function getBufferLengthPercent() : Number
		{
			if (this.currentMode)
			{
				return this.currentMode.bufferPerToPlay;
			}
			return 0;
		}// end function
		
		override public function getBufferLength() : Number
		{
			if (this.currentMode)
			{
				return this.currentMode.bufferLength;
			}
			return 0;
		}// end function
		
		override public function setVolume(param1:Number) : void
		{
			super.setVolume(param1);
			if (this.currentMode)
			{
				this.currentMode.volume = volume;
			}
			return;
		}// end function
		
		override public function getPlayTime() : Number
		{
			if (this.currentMode)
			{
				return this.currentMode.playTime;
			}
			return 0;
		}// end function
		
		override public function getPlayPercent() : Number
		{
			if (this.getDuration() != 0 && this.currentMode)
			{
				return this.currentMode.playTime / this.getDuration();
			}
			return 0;
		}// end function
		
		override public function seekToStart() : void
		{
			if (this.currentMode)
			{
				this.currentMode.seekToStart();
			}
			return;
		}// end function
		
		private function seekOtherToStart(param1:VideoPlayModeV3) : void
		{
			var _loc_3:VideoPlayModeV3 = null;
			var _loc_2:int = 0;
			while (_loc_2 < this.arrayModes.length)
			{
				
				_loc_3 = this.arrayModes[_loc_2];
				if (param1 && _loc_3 && _loc_3.loadPosition > 0 && param1.index != _loc_3.index)
				{
					_loc_3.seekToStart();
				}
				_loc_2++;
			}
			return;
		}// end function
		
		override public function seeking(param1:Number, param2:Boolean = true) : void
		{
			if (this.currentMode == null)
			{
				return;
			}
			if (progressTimer && progressTimer.isRunning())
			{
				progressTimer.stop();
			}
			if (param1 < 0)
			{
				param1 = 0;
			}
			var _loc_3:* = this.getLoadedPercent();//分段的百分比
			if (!this.currentMode.ranSeekAbled && param1 > _loc_3)
			{
				param1 = _loc_3;
			}
			var _loc_4:* = this.getModeByPosition(param1);
			var _loc_5:* = Math.floor(param1 * videodata.video_duration * 100) / 100; //快进到的秒数
			this.statusBeforeSeek = getPlayerState();//获取播放状态，这里很有可能是那个跳转后不执行效果的地方，播放前的状态
			setPlayerState(PlayerEnum.STATE_SEEKING);//设置状态为5，设置状态为跳转中
			if (_loc_5 >= _loc_4.startTime + _loc_4.getOuterStartTime() && _loc_5 < _loc_4.getOuterEndTime())
			{
				_loc_4.seeking(_loc_5, param2);
				_loc_4.pause();
				if (_loc_4 && _loc_4.index != this.currentMode.index)
				{
					if (this.seekingMode)
					{
						this.seekingMode.seekStop();
						this.seekingMode.pause();
					}
					this.seekingMode = _loc_4;
				}
			}
			return;
		}// end function
		//真正快进跟踪到的位置
		override public function seekstop(param1:Number) : void
		{
			trace('seekstop0011');  //跟踪下这个效果看看...这里是那个要关闭什么的东西来头
			var seekTime:Number;
			var usingp2p:Boolean;
			var seekPosition:* = param1;
			
			if (progressTimer && progressTimer.isRunning())
			{
			//	trace('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');.这里好像没执行。难道真的是这句造成的？
				progressTimer.stop();//好像跟上一个，下一个有关，这里等观望
			}
			
			setPlayerState(PlayerEnum.STATE_PLAYING);
			//好像带有分段跳的效果
			var seekstopMode:* = this.getModeByPosition(seekPosition);
			seekTime = Math.floor(seekPosition * videodata.video_duration * 100) / 100;
			var loadedPosition:* = this.getSingleModeLoadedPosition(seekstopMode);//计算出来的一个变量.已载入的的视频长度
			var loadStart:* = (seekstopMode.startTime + seekstopMode.getOuterStartTime()) / videodata.video_duration;//开始时间
			
			if (!this.currentMode.ranSeekAbled)//某种快进模式，好像有些类似禁止快进类的。这还是一个比较重要的地方
			{
				this.seeking(seekPosition, false);
				this.currentMode.resume(-1, this.seekStopResumeClosure, 0);
				seekstopMode.seekStop();
				return;
			}
			
			if (seekstopMode.index == this.currentMode.index)
			{
				this.lastPlayMode = null;
				if (loadStart <= seekPosition && seekPosition <= loadedPosition) //难道是这个里面少了某句不成？
				{
					if (this.currentMode.index == this.modeIndex)
					{
						this.seeking(seekPosition, false);
						
						this.currentMode.resume(-1, this.seekStopResumeClosure, 0);//这里是个可疑的地方
						
					}
					else
					{
						this.currentMode.volume = 0;
						this.attachNetstream();
						this.modeIndex = this.currentMode.index;
						setTimeout(function ():void
						{
							currentMode.resume(Math.floor(seekPosition * videodata.video_duration * 100) / 100, seekStopResumeClosure, 10);
							return;
						}// end function
							, 15);
					}
				}
				else
				{
					if (progressTimer && progressTimer.isRunning())
					{
						progressTimer.stop();
					}
					setPlayerState(PlayerEnum.STATE_SEEKED);
					trace('暂停位置二');
					this.reportPlayStatus = PlayerEnum.STATE_SEEKED;
					videodata.video_changeformat = false;
					GlobalVars.preformat = this.getCurrFormat();
					GlobalVars.preformatName = this.getCurrFormatName();
					this.currentMode.close();
					this.currentMode.loadVideo(seekTime, videodata.secBuffertime, videodata.waittime);
					dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAY_STATUS_CHANGED, {code:"seekstop", msg:"load", seektime:seekTime}));
				}
			}
			else
			{
				//跨段跳
				videodata.video_changeformat = false;
				if (this.currentMode.hasEventListener(FlvPlayModeV3Event.STATUS_CHANGE))
				{
					this.currentMode.removeEventListener(FlvPlayModeV3Event.STATUS_CHANGE, this.playModeStatusChange);
					this.currentMode.removeEventListener(FlvPlayModeV3Event.STATUS_CHANGE, this.playModeBeforeStatusChange);
				}
				this.currentMode.seekStop();
				GlobalVars.preformat = this.getCurrFormat();
				GlobalVars.preformatName = this.getCurrFormatName();
				this.seekOtherToStart(this.currentMode);
				this.lastPlayMode = this.currentMode;
				this.lastPlayMode.setUserWaittime();
				this.currentMode.pause();
				seekstopMode.volume = volume;
				this.currentMode = seekstopMode;
				this.currIndex = this.currentMode.index;
				if (this.currentMode.hasEventListener(FlvPlayModeV3Event.STATUS_CHANGE))
				{
					this.currentMode.removeEventListener(FlvPlayModeV3Event.STATUS_CHANGE, this.playModeBeforeStatusChange);
				}
				if (!this.currentMode.hasEventListener(FlvPlayModeV3Event.STATUS_CHANGE))
				{
					trace('cccccccccceeeeeeeeeeeeeeeeee');
					this.currentMode.addEventListener(FlvPlayModeV3Event.STATUS_CHANGE, this.playModeStatusChange);
				}
				if (seekPosition < loadedPosition && seekPosition >= loadStart && this.currentMode.loadPosition > 0 && !this.currentMode.hasClosed)
				{
					this.closeAllSeekMode();
					this.part2edStreamStarted = false;
					this.currentMode.volume = 0;
					this.attachNetstream();
					this.modeIndex = this.currentMode.index;
					setTimeout(function ():void
					{
						currentMode.resume(seekTime, seekStopResumeClosure, GlobalVars.resumetime);
						var _loc_1:Number = 0;
						currentMode.setUserWaittime();
						if (currentMode.getLoadOvertime() != 0)
						{
							_loc_1 = Math.max(0, Math.min(currentMode.userWaittime, currentMode.getLoadOvertime()) - currentMode.userWaitlasttime);
						}
						else
						{
							_loc_1 = Math.max(0, currentMode.userWaittime - currentMode.userWaitlasttime);
						}
						reportUserWaitVal(currentMode, 0, _loc_1);
						return;
					}// end function
						, GlobalVars.jumptime);
				}
				else
				{
					if (progressTimer && progressTimer.isRunning())
					{
						progressTimer.stop();
					}
					this.closeUsingMode();
					setPlayerState(PlayerEnum.STATE_SEEKED);
					trace('暂停位置三');
					this.reportPlayStatus = PlayerEnum.STATE_SEEKED;
					this.currLoadIndex = this.currentMode.index;
					usingp2p;
					if (this.currentMode)
					{
						usingp2p = this.currentMode.usingP2P;
					}
					this.currentMode.loadVideo(seekTime, videodata.secBuffertime, videodata.waittime, true, 0, false, usingp2p);
					dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAY_STATUS_CHANGED, {code:"seekstop", msg:"load", seektime:seekTime}));
				}
			}
			seekstopMode.seekStop();
			return;
		}// end function
		
		private function getSingleModeLoadedPosition(param1:VideoPlayModeV3) : Number
		{
			if (!param1)
			{
				return 0;
			}
			var _loc_2:* = (param1.startTime + param1.getOuterStartTime()) / videodata.video_duration + (param1.getOuterEndTime() - param1.getOuterStartTime() - param1.startTime) * param1.loadPosition / videodata.video_duration;
			return _loc_2;
		}// end function
		//视频跳完后，会转到这里。。这个东西，需要小跟一下下了。
		private function seekStopResumeClosure() : void
		{
			trace('这个是跳转后要执行的位置');
			
			if (!this.currentMode)
			{
				return;
			}
			setPlayerState(PlayerEnum.STATE_PLAYING);
			if (!progressTimer.isRunning())
			{
				progressTimer.restart();
			}
			this.currentMode.volume = volume;
			this.attachNetstream();
			try
			{
				if (this.lastPlayMode && this.lastPlayMode.loadPosition > 0)
				{
					this.lastPlayMode.seekToStart();
				}
			}
			catch (e:Error)
			{
			}
			var _loc_1:* = this.getPlayTime();
			dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAY_STATUS_CHANGED, {code:"seekstop", msg:"seeked", seektime:Math.floor(_loc_1)}));
			return;
		}// end function
		
		override public function getCurrVid() : String
		{
			if (this.currentMode)
			{
				return this.currentMode.getVid();
			}
			return "";
		}// end function
		
		override public function getCurrFormat() : String
		{
			if (this.currentMode)
			{
				return this.currentMode.getVideoFormat();
			}
			return "";
		}// end function
		
		override public function getCurrFormatName() : String
		{
			if (this.currentMode)
			{
				return this.currentMode.formatName;
			}
			return "";
		}// end function
		
		override public function getCurrVt() : Number
		{
			if (this.currentMode)
			{
				return this.currentMode.getVtype();
			}
			return 0;
		}// end function
		
		override public function getVideoCount() : int
		{
			if (this.arrayModes && this.arrayModes.length > 0)
			{
				return this.arrayModes.length;
			}
			return 1;
		}// end function
		
		override public function getModetype() : String
		{
			if (this.arrayModes && this.arrayModes.length > 0)
			{
				return this.arrayModes[0].rtype;
			}
			return "0";
		}// end function
		
		override public function getModeRequestTimeCount() : Number
		{
			if (this.currentMode)
			{
				return this.currentMode.requestTimeCount;
			}
			return 0;
		}// end function
		
		override public function getModeRid() : String
		{
			if (this.currentMode)
			{
				return this.currentMode.rid;
			}
			return "";
		}// end function
		
		override public function getCurrVurl() : String
		{
			if (this.currentMode)
			{
				return this.currentMode.requestPath;
			}
			return "";
		}// end function
		
		override public function useDefaultUrl() : Boolean
		{
			if (this.currentMode && this.currentMode.urlArray && this.currentMode.urlCount < (this.currentMode.urlArray.length - 1))
			{
				return false;
			}
			return true;
		}// end function
		
		override public function getCurrLevel() : String
		{
			if (this.currentMode)
			{
				return this.currentMode.level;
			}
			return "0";
		}// end function
		
		override public function getPlaytimeSeekPoint(param1:Number = -1) : Object
		{
			if (this.currentMode)
			{
				return this.currentMode.getPlaytimeSeekPoint(param1);
			}
			return null;
		}// end function
		
		override public function getModeLoadoverTime() : Number
		{
			if (this.currentMode)
			{
				return this.currentMode.getLoadOvertime();
			}
			return 0;
		}// end function
		
		override public function getUsingP2P() : Boolean
		{
			if (this.currentMode)
			{
				return this.currentMode.usingP2P;
			}
			return false;
		}// end function
		
		private function reportRequestVal(param1:VideoPlayModeV3, param2:Number, param3:Number) : void
		{
			trace('reportRequestVal');
			var _loc_4:ReportMode = null;
			var _loc_5:int = 0;
			if (param1)
			{
				_loc_5 = 0;
				if (param1.startTime != 0)
				{
					_loc_5 = 1;
				}
				
				trace('中断点三');
				
				if (getPlayerState() != PlayerEnum.STATE_SEEKED)
				{
					if (videodata.video_changeformat)
					{
						_loc_4 = ReportManager.createReportModeByVideoMode(ReportManager.STEP_REQUEST_CHANGEFMT, param2, param3, _loc_5, this.getPlayTime(), param1);
					}
					else if (param1.index == this.startId)
					{
						_loc_4 = ReportManager.createReportModeByVideoMode(ReportManager.STEP_REQUEST_FIRST, param2, param3, _loc_5, this.getPlayTime(), param1);
					}
					else
					{
						_loc_4 = ReportManager.createReportModeByVideoMode(ReportManager.STEP_REQUEST_NOFIRST, param2, param3, _loc_5, this.getPlayTime(), param1);
					}
				}
				else
				{
					if (videodata.video_autoseek)
					{
						if (param3 == 1 || param3 == 3 || param3 == 5)
						{
							param3 = 7;
						}
						else
						{
							param3 = 6;
						}
					}
					_loc_4 = ReportManager.createReportModeByVideoMode(ReportManager.STEP_REQUEST_SEEK, param2, param3, _loc_5, this.getPlayTime(), param1);
				}
				if (_loc_4)
				{
					if (param1.usingP2P)
					{
						_loc_4.val2 = 4;
					}
					ReportManager.addReport(_loc_4, true);
				}
			}
			return;
		}// end function
		
		private function reportChangeUrlError(param1:VideoPlayModeV3, param2:Number, param3:Number) : void
		{
			trace('reportChangeUrlError');
			var _loc_4:ReportMode = null;
			var _loc_5:int = 0;
			if (param1)
			{
				_loc_5 = 0;
				if (param1.startTime != 0)
				{
					_loc_5 = 1;
				}
				trace('中断点四');
				if (getPlayerState() != PlayerEnum.STATE_SEEKED)
				{
					if (videodata.video_changeformat)
					{
						_loc_4 = ReportManager.createReportModeByVideoMode(ReportManager.STEP_CHANGEURL_ERROR_CNGFMT, param2, param3, _loc_5, this.getPlayTime(), param1);
					}
					else if (param1.index == this.startId)
					{
						_loc_4 = ReportManager.createReportModeByVideoMode(ReportManager.STEP_CHANGEURL_ERROR_FIRST, param2, param3, _loc_5, this.getPlayTime(), param1);
					}
					else
					{
						_loc_4 = ReportManager.createReportModeByVideoMode(ReportManager.STEP_CHANGEURL_ERROR_NOFIRST, param2, param3, _loc_5, this.getPlayTime(), param1);
					}
				}
				else
				{
					_loc_4 = ReportManager.createReportModeByVideoMode(ReportManager.STEP_CHANGEURL_ERROR_SEEK, param2, param3, _loc_5, this.getPlayTime(), param1);
				}
				if (_loc_4)
				{
					if (param1.usingP2P)
					{
						_loc_4.val2 = 4;
					}
					ReportManager.addReport(_loc_4, true);
				}
			}
			return;
		}// end function
		
		private function reportLDERVal(param1:VideoPlayModeV3, param2:Number, param3:Number) : void
		{
			trace('reportLDERVal');
			var _loc_5:ReportMode = null;
			var _loc_6:int = 0;
			var _loc_4:Boolean = true;
			if (param1)
			{
				_loc_6 = 0;
				if (param1.startTime != 0)
				{
					_loc_6 = 1;
				}
				trace('中断点五');
				if (getPlayerState() != PlayerEnum.STATE_SEEKED)
				{
					if (videodata.video_changeformat)
					{
						_loc_5 = ReportManager.createReportModeByVideoMode(ReportManager.STEP_LDER_CHANGEFMT, param2, param3, _loc_6, this.getPlayTime(), param1);
					}
					else if (param1.index == this.startId)
					{
						_loc_5 = ReportManager.createReportModeByVideoMode(ReportManager.STEP_LDER_FIRST, param2, param3, _loc_6, this.getPlayTime(), param1);
					}
					else
					{
						_loc_5 = ReportManager.createReportModeByVideoMode(ReportManager.STEP_LDER_NOFIRST, param2, param3, _loc_6, this.getPlayTime(), param1);
					}
				}
				else
				{
					_loc_5 = ReportManager.createReportModeByVideoMode(ReportManager.STEP_LDER_SEEK, param2, param3, _loc_6, this.getPlayTime(), param1);
				}
				if (_loc_5)
				{
					if (param1.usingP2P)
					{
						_loc_5.val2 = 4;
					}
					ReportManager.addReport(_loc_5, true);
				}
			}
			return;
		}// end function
		
		private function reportRequestErrorVal(param1:VideoPlayModeV3, param2:Number, param3:Number) : void
		{
			trace('reportRequestErrorVal');
			var _loc_4:ReportMode = null;
			var _loc_5:int = 0;
			if (param1)
			{
				_loc_5 = 0;
				if (param1.startTime != 0)
				{
					_loc_5 = 1;
				}
				trace('中断点六');
				if (getPlayerState() != PlayerEnum.STATE_SEEKED)
				{
					if (videodata.video_changeformat)
					{
						_loc_4 = ReportManager.createReportModeByVideoMode(ReportManager.STEP_REQUESTERROR_CHANGEFMT, param2, param3, _loc_5, this.getPlayTime(), param1);
					}
					else if (param1.index == this.startId)
					{
						_loc_4 = ReportManager.createReportModeByVideoMode(ReportManager.STEP_REQUESTERROR_FIRST, param2, param3, _loc_5, this.getPlayTime(), param1);
					}
					else
					{
						_loc_4 = ReportManager.createReportModeByVideoMode(ReportManager.STEP_REQUESTERROR_NOFIRST, param2, param3, _loc_5, this.getPlayTime(), param1);
					}
				}
				else
				{
					_loc_4 = ReportManager.createReportModeByVideoMode(ReportManager.STEP_REQUESTERROR_SEEK, param2, param3, _loc_5, this.getPlayTime(), param1);
				}
				if (_loc_4)
				{
					_loc_4.val = param1.filesize;
					_loc_4.bi = param1.outerBytesTotal;
					if (param1.usingP2P)
					{
						_loc_4.val2 = 4;
					}
					ReportManager.addReport(_loc_4, true);
				}
			}
			return;
		}// end function
		
		private function reportBufferTimeVal(param1:VideoPlayModeV3, param2:Number) : void
		{
			trace('reportBufferTimeVal');
			var _loc_4:ReportMode = null;
			var _loc_5:int = 0;
			var _loc_3:* = param2 > 10000 ? (1) : (0);
			if (param2 > 10000)
			{
				param2 = 10000;
			}
			if (param1)
			{
				_loc_5 = 0;
				if (param1.startTime != 0)
				{
					_loc_5 = 1;
				}
				if (videodata.video_changeformat)
				{
					_loc_4 = ReportManager.createReportModeByVideoMode(ReportManager.STEP_BUFFERTIME_CHANGEFMT, param2, _loc_3, _loc_5, this.getPlayTime(), param1);
				}
				else if (this.reportPlayStatus != PlayerEnum.STATE_SEEKED)
				{
					trace('中断点七');
					if (param1.index == this.startId)
					{
						_loc_4 = ReportManager.createReportModeByVideoMode(ReportManager.STEP_BUFFERTIME_FIRST, param2, _loc_3, _loc_5, this.getPlayTime(), param1);
					}
					else
					{
						_loc_4 = ReportManager.createReportModeByVideoMode(ReportManager.STEP_BUFFERTIME_NOFIRST, param2, _loc_3, _loc_5, this.getPlayTime(), param1);
					}
				}
				else
				{
					_loc_4 = ReportManager.createReportModeByVideoMode(ReportManager.STEP_BUFFERTIME_SEEK, param2, _loc_3, _loc_5, this.getPlayTime(), param1);
				}
				if (_loc_4)
				{
					if (param1.usingP2P)
					{
						_loc_4.val2 = 4;
					}
					ReportManager.addReport(_loc_4);
				}
			}
			return;
		}// end function
		
		//报告缓存次数
		private function reportBufferCountVal(param1:VideoPlayModeV3) : void
		{
			//trace('reportBufferCountVal');
			
			var _loc_2:ReportMode = null;
			var _loc_3:int = 0;
			if (param1)
			{
				_loc_3 = 0;
				if (param1.startTime != 0)
				{
					_loc_3 = 1;
				}
				if (videodata.video_changeformat)
				{
					_loc_2 = ReportManager.createReportModeByVideoMode(ReportManager.STEP_BUFFERCOUNT_CHANGEFMT, param1.emptyCount, 0, _loc_3, this.getPlayTime(), param1);
				}
				else if (this.reportPlayStatus != PlayerEnum.STATE_SEEKED)//全部载入完成后调用的一个报告信息
				{
					trace('全部载入完成');
					
					if (param1.index == this.startId)
					{
						
						_loc_2 = ReportManager.createReportModeByVideoMode(ReportManager.STEP_BUFFERCOUNT_FIRST, param1.emptyCount, 0, _loc_3, this.getPlayTime(), param1);
					}
					else
					{
						_loc_2 = ReportManager.createReportModeByVideoMode(ReportManager.STEP_BUFFERCOUNT_NOFIRST, param1.emptyCount, 0, _loc_3, this.getPlayTime(), param1);
					}
				}
				else
				{
					_loc_2 = ReportManager.createReportModeByVideoMode(ReportManager.STEP_BUFFERCOUNT_SEEK, param1.emptyCount, 0, _loc_3, this.getPlayTime(), param1);
				}
				if (_loc_2)
				{
					if (param1.usingP2P)
					{
						_loc_2.val2 = 4;
					}
					ReportManager.addReport(_loc_2);
				}
			}
			return;
		}// end function
		
		private function reportUserWaitVal(param1:VideoPlayModeV3, param2:Number, param3:Number) : void
		{
			trace('reportUserWaitVal');
			var _loc_4:int = 0;
			var _loc_5:ReportMode = null;
			var _loc_6:VideoPlayModeV3 = null;
			if (param1)
			{
				trace('中断点九');
				if (!videodata.video_changeformat && this.reportPlayStatus != PlayerEnum.STATE_SEEKED)
				{
					_loc_4 = 0;
					if (param1.index > 0)
					{
						_loc_6 = this.getModeByIndex((param1.index - 1));
						if (_loc_6)
						{
							_loc_4 = _loc_6.outerDuration;
						}
					}
					if (param1.index == this.startId)
					{
						_loc_5 = ReportManager.createReportModeByVideoMode(ReportManager.STEP_USER_FIRST, param2, param3, _loc_4, this.getPlayTime(), param1);
					}
					else
					{
						_loc_5 = ReportManager.createReportModeByVideoMode(ReportManager.STEP_USER_NOFIRST, param2, param3, _loc_4, this.getPlayTime(), param1);
					}
					ReportManager.addReport(_loc_5);
				}
			}
			return;
		}// end function
		
		
		
		private function getTestConentReport(param1:int, param2:int, param3:int, param4:String, param5:String = "") : ReportMode
		{
			var _loc_6:* = ReportManager.createReportMode(ReportManager.STEP_CDN_TEST, param1, param2, param3, this.getPlayTime(), this._testMode.vid, this._testMode.format, this._testMode.type, this._testMode.vt, this._testMode.idx, this._testMode.level);
			ReportManager.createReportMode(ReportManager.STEP_CDN_TEST, param1, param2, param3, this.getPlayTime(), this._testMode.vid, this._testMode.format, this._testMode.type, this._testMode.vt, this._testMode.idx, this._testMode.level).rid = this._testMode.rid;
			_loc_6.buffersize = this._testMode.buffersize;
			_loc_6.clspeed = this._testMode.clspeed;
			_loc_6.vurl = param4;
			_loc_6.emsg = param5;
			return _loc_6;
		}// end function
	}
}