package com.oms.tpv1.media
{
	
	
	import com.greensock.*;
	import com.koma.utils.*;
	import com.oms.report.*;
	import com.oms.tpv1.events.*;
	import com.oms.tpv1.managers.*;
	import com.oms.tpv1.media.players.*;
	import com.oms.tpv1.media.players.BaseVideoPlayer;
	import com.oms.tpv1.model.*;
	import com.oms.tpv1.resource.*;
	import com.oms.tpv1.ui.*;
	import com.oms.tpv1.utils.*;
	import com.oms.utils.timer.*;
	import com.oms.videov3.common.*;
	import com.oms.videov3.events.*;
	import com.oms.videov3.ui.*;
	import com.sun.events.*;
	import com.sun.net.*;
	import com.sun.utils.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.external.*;
	import flash.external.ExternalInterface;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
	
	
	
	public class BasePlayer extends Sprite
	{
		
		
		protected var playerWidth:Number = 400;
		protected var playerHeight:Number = 300;
		protected var videoWidth:Number = 400;
		protected var videoHeight:Number = 300;
		
		private var emptyCount:int = 0;
		private var evcreated:Boolean = false;
		
		protected var loadingswf:LoadingSwf;
		//前置页面
		
		
		private var videoClick:MyMouseEvent;
		private var playerClick:MyMouseEvent;
		protected var skinManager:SkinManagerV3;

		protected var showTipTimeout:uint;
		protected var hideTipTimeout:uint;

		private var rightCfgTimeoutCount:uint;
		private var sharepicSeekTimecount:uint;
		
		private var videosizeFactor:Number = 100;
		private var currSizeFactor:Number = 100;
		
		private var sizefactor:int = 0;
		
		//右下角
		//private var tipad:TipAd;
		
		
		
		private var moStart:Number = 0;
		private var moEnd:Number = 0;
		
	
		protected var videoContainer:VideoContainer;//自定义的一个图层
		
		protected var endViewShowing:Boolean = false;
		
		protected var attractionStop:Boolean = false;
		private var mouseLeave:Boolean = false;
		
		
		private var seekstoptipTimeoutCount:uint;
		//皮肤组件
		
		private var timeFormatType:String;
		
		private var playerActivity:PlayerActivity;
		
		private var showctrlTimeout:uint;
		private var showctrlTime:uint = 5000;
		
		private var showContrlbar:Boolean = true;
		
		private var jumptime:int = 15;
		
		
		protected var rightCfgShowing:Boolean = false;
		protected var ignoreSpace:Boolean = false;
		
		
		private var playStatus:int;
		
		protected var videoPlayer:BaseVideoPlayer;
		protected var playerstatus:int = 0;
		protected var isFullScreen:Boolean = false;
		private var startPoint:Number = 0;
		private var endPoint:Number = 1;
		
		protected var timer:TPTimer;
		
		
		private var toppanelTimeoutCount:uint;
		
		
		private var usableScaleFactor:int = 0;
		
		protected var currentVideoData:VideoPlayData;
		protected var currentScaleFactor:int = 0;
		
		private var useMovieHeadTail:Boolean = true;
		protected var showTailMsg:Boolean = false;
		private var playtimeObj:PlayTime;
		private var shareSeekplay:Boolean = false;
		
		protected var orgWidth:Number = 400;
		protected var orgHeight:Number = 300;
		private var shareInsideShowing:Boolean = false;
		private var panelMovetime:Number = 0.5;
		private var soundTipCount:uint = 0;
		
		private var filmstipTimeCount:uint = 0;
		private var filmstipStartCount:uint = 0;
		protected var showPlayTip:Boolean = false;
		private var bufferingCount:int = 0;
		private var lastBufferPer:Number = 0;
		
		private var hideDefincount:uint;
		private var hideCfgcount:uint;
		private var hidetimeout:int = 100;
		
		private var seekstopTimeoutCount:uint;
		
		
		
		
		private var minibarTimeoutCount:uint;
		private var searchbarTimeoutCount:uint;
		
		
		
		
		protected var adReadyToPlay:Object = false;
		protected var mousecheck:Boolean = false;
		
		private var rpt_emptytime:uint = 0;
		private var rpt_playerinit:uint;
		private var rpt_playerloading:uint;
		private var rpt_playercover:uint;
		protected var rpt_playerad:uint = 0;
		protected var rpt_playerev:uint = 0;
		protected var rpt_adLoaded:int = 1;
		private var rpt_loadtime:uint;
		private var rpt_outLoadtime:uint;
		private var rpt_starttime:uint;
		private var rpt_speedLoad:uint = 0;
		protected var rpt_addownload:uint = 0;
		protected var rpt_adplayend:uint = 0;
		
		protected var tipHisShowing:Boolean = false;
		
		
		
		private var shareTimer:TPTimer;
		
		
		private var copySwf:String = "";
		private var copyHtml:String = "";
		private var copyPage:String = "";
		
		//广告..这里先暂时不用
		
		
		
		protected var ignoreSeekboard:Boolean = false;
		protected var ignoreUpDown:Boolean = false;
		protected var ignoreMousewheel:Boolean = false;
		protected var adstart:Boolean = false;
		
		private var speedObj:Object;
		
		
		
		protected var muteVolume:Number = 50;
		
		
		
		
		
		
		
		public function BasePlayer()
		{
			
			this.init();
			return;	
			
		}//end function 
		
		
		
		private function init():void
		{
			
			this.getLocalInfo();
			this.timer = TPTimer.setInterval(this.timerhandler, 300);
			this.timer.stop();
			try
			{
				GlobalVars.Capabilities = Capabilities.version.split(" ")[1];
				GlobalVars.majorVersion = GlobalVars.Capabilities.split(",")[0];
				GlobalVars.minorVersion = GlobalVars.Capabilities.split(",")[1];
			}
			catch (e:Error)
			{
			}
			if (GlobalVars.majorVersion == "10" && (GlobalVars.minorVersion == "0" || GlobalVars.minorVersion == "1"))
			{
				GlobalVars.resumetime = 100;
				GlobalVars.jumptime = 200;
			}
			else if (GlobalVars.majorVersion == "11" && Number(GlobalVars.minorVersion) >= 5)
			{
				GlobalVars.resumetime = 8;
				GlobalVars.jumptime = 10;
			}
			else
			{
				GlobalVars.resumetime = 10;
				GlobalVars.jumptime = 15;
			}
			//设置快进跟跳转时间
			ReportManager.getReporttime();//播放器载入统计
			return;

			
		}
		
		
		
		
		protected function loadSkin() : void{
			
			
			this.rpt_playerinit = getTimer();
			if (!this.skinManager)
			{
				this.skinManager = new SkinManagerV3();
				this.skinManager.addEventListener(SkinManagerV3Event.SKIN_LOAD_COMPLETE, this.skinloadCompleteHandler);
				this.skinManager.addEventListener(SkinManagerV3Event.SKIN_LOAD_ERROR, this.skinloadErrorHandler);
			}
			this.skinManager.loadSkin();
			
			
		}
		
		
		
		
		/*
		 *界面相关的配置信息，这里可以引入外部数据跟自定义数据。
		*具体根据情况定
		*/
		//skin载入完成后,完成一期的相关配置后,发送消息到这个事件上.
		protected function skinloadCompleteHandler(event:SkinManagerV3Event) : void
		{
			
			this.skinManager.removeEventListener(SkinManagerV3Event.SKIN_LOAD_COMPLETE, this.skinloadCompleteHandler);
			this.skinManager.removeEventListener(SkinManagerV3Event.SKIN_LOAD_ERROR, this.skinloadErrorHandler);
			
			//报告皮肤载入完成,统计播放器载入时间,这个可以反馈给用户下载速度
			ReportManager.addReport(ReportManager.createReportMode(ReportManager.STEP_LOAD_SKIN, getTimer() - this.rpt_playerinit, 1, 0));
			
			
			//这里测试生成VIDEOPLAYER，如果生成失败则提示无法加载播放器之类的
			/*
			 *皮肤转入完成后,正式进入video的生成效果 
			*/
			this.videoPlayer = PlayerManager.getVideoPlayer(GlobalVars.playerversion);
			if (!this.videoPlayer)
			{
				dispatchEvent(new OmsPlayerEvent(OmsPlayerEvent.INIT_ERROR));
				return;
			}
			
			//进度条
			this.addContrlEvents();
			//容器
			
			
			this.videoContainer = new VideoContainer();
			this.addChildAt(this.videoContainer, 0);
			this.addChild(this.videoPlayer);
			
			
			
			
			
			
			
			
			this.videoClick = new MyMouseEvent(this.videoContainer);
			this.playerClick = new MyMouseEvent(this.videoPlayer);
			
			
			this.adjustVideoPlayer(this.videoWidth, this.videoHeight);
			
			
			this.skinConifg();
			
			
			
			
			
			
			
			this.controlEnabled(false, false, false, false, false, false, false, false);

			//定义按键
			this.skinManager.setDefinitionBtnEnable(false);
			
			//MouseEvent
			this.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveCheck);
			stage.addEventListener(Event.MOUSE_LEAVE, this.mouseLeaveHandler);
			
			
			
			this.videoClick.addEventListener(MyMouseEvent.CLICK, this.videoClickHandler);
			this.videoClick.addEventListener(MyMouseEvent.DOUBLE_CLICK, this.videoCbClickHandler);
			this.playerClick.addEventListener(MyMouseEvent.CLICK, this.videoClickHandler);
			this.playerClick.addEventListener(MyMouseEvent.DOUBLE_CLICK, this.videoCbClickHandler);
			
			
		
			
			
			//右侧分享之类的东西
			if (GlobalVars.showRightPanel && this.skinManager.rightCfgMsg)
			{
				if (!GlobalVars.showCfg)
				{
					return;
				}
				addChild(this.skinManager.rightCfgMsg  as DisplayObject);
				
				//可以让右侧批量的数据去掉一部分，这个功能还是很不错的。
				this.skinManager.rightCfgMsg.btnFavorite.visible = false;
				
				this.showRightCfg(false);
				this.skinManager.rightCfgMsg.addEventListener("item_click", this.rightcfgItemClick);
			}
			if (this.skinManager.bigPlayBtn)
			{
				this.addChild(this.skinManager.bigPlayBtn as DisplayObject);
				this.adjustBigPlayBtn(false);
			}
			
			//this.skinManager.contrlBar.logo.width = 0;
			
			
			if (this.skinManager.contrlBar)
			{
				if (this.skinManager.btnReplay)
				{
					this.skinManager.btnReplay.visible = false;
					this.skinManager.btnReplay.addEventListener(MouseEvent.CLICK, this.onReplayClick);
				}
				this.addChild(this.skinManager.contrlBar as DisplayObject);
				this.adjustCtrlbar();
			}
			
			//多码率相关配置，是否打开多码率设置
			/*
			 *多码率选择相关
			*/
			
			if (this.skinManager.definitionPanel)
			{
				this.skinManager.definitionPanel.addEventListener("item_click", this.definictionPanelClick);
				this.skinManager.definitionPanel.addEventListener("select_change", this.definictionPanelChange);
				this.skinManager.definitionPanel.addEventListener(MouseEvent.MOUSE_OUT, this.onPanelMouseout);
				this.skinManager.definitionPanel.addEventListener(MouseEvent.MOUSE_OVER, this.onPanelMouseover);
			}
			
			
			
			//其它界面的相关配置
			if (this.skinManager.cfgPanel)
			{
				this.skinManager.cfgPanel.addEventListener("item_click", this.configChangedHandler);
				this.skinManager.cfgPanel.addEventListener(MouseEvent.MOUSE_OUT, this.onPanelMouseout);
				this.skinManager.cfgPanel.addEventListener(MouseEvent.MOUSE_OVER, this.onPanelMouseover);
			}
			
			if (this.skinManager.topPanel)
			{
				this.skinManager.topPanel.cacheAsBitmap = true;
				this.skinManager.topPanel.addEventListener("scale_click", this.topScaleClick);
				this.skinManager.topPanel.addEventListener("share_click", this.topItemClick);
				this.skinManager.topPanel.addEventListener("favorite_click", this.topItemClick);
				this.skinManager.topPanel.addEventListener("book_click", this.topItemClick);
			}
			if (GlobalVars.showShare && this.skinManager.sharePanel)
			{
				this.skinManager.sharePanel.addEventListener("icon_click", this.shareIconclick);
				this.skinManager.sharePanel.addEventListener("share_close", this.shareClose);
				this.skinManager.sharePanel.addEventListener("copy_click", this.sharecopy);
			}
			
			if (GlobalVars.showNext && this.skinManager.btnNext)//带列表功能的选项.下一个视频的按键
			{
				this.skinManager.btnNext.addEventListener(MouseEvent.CLICK, this.nextClick);
				this.skinManager.setNextbtnEnable(false);
			}
			if (this.skinManager.msgPanel)
			{
				this.skinManager.msgPanel.addEventListener("item_click", this.onMsgPanelClick);
			}
			if (this.skinManager.msgTip && this.skinManager.msgTip.btnclose)
			{
				this.skinManager.msgTip.btnclose.addEventListener(MouseEvent.CLICK, this.onMsgTipClose);
			}
			
			//载入动画
			
			/*if (!this.loadingswf)
			{
				this.loadingswf = new LoadingSwf();
			}
			
			if (!this.loadingswf.hasEventListener(LoadingSwfEvent.LOADING_COMPLETE))
			{
				this.loadingswf.addEventListener(LoadingSwfEvent.LOADING_COMPLETE, this.loadingswfCompleteHandler);
				this.loadingswf.addEventListener(LoadingSwfEvent.LOADING_ERROR, this.loadingswfCompleteHandler);
			}
			
			this.rpt_playerloading = getTimer();
			
				
			this.loadingswf.load(GlobalVars.loadingUrl);
			*/
			
			dispatchEvent(new OmsPlayerEvent(OmsPlayerEvent.INIT_COMPLETE))
			
			//这里太二了。
			
			
			
			return;
		}// end function
		
		
		//视频显示比例切换
		private function configChangedHandler(param1:Object) : void
		{
			
			var _loc_2:int = 0;
			var _loc_3:int = 0;
			switch(param1.value.name)
			{
				case "light"://关灯操作
				{
					
					return;
				}
				case "popup"://弹窗操作
				{
					
					return;
				}
				case "head":
				{
					_loc_2 = this.skinManager.cfgPanel.getHeadStatus() ? (1) : (0);
					this.headtailConfirmClickHandler(_loc_2);
					GlobalVars.playerLocalInfo.headtail = this.useMovieHeadTail ? (1) : (0);
					break;
				}
				case "scale": //显示模式
				{
					_loc_3 = param1.value.index;
					if (_loc_3 == 1)
					{
						this.currentScaleFactor = 3;
					}
					else if (_loc_3 == 2)
					{
						this.currentScaleFactor = 4;
					}
					else if (_loc_3 == 3)
					{
						this.currentScaleFactor = 1;
					}
					else
					{
						this.currentScaleFactor = 0;
					}
					
					
					
					this.usableScaleFactor = this.currentScaleFactor;
					this.adjustVideoPlayer(this.videoWidth, this.videoHeight);
					break;
				}
				default:
				{
					break;
				}
			}
			//SOManager.soObj = GlobalVars.playerLocalInfo.toObject();
			//SOManager.saveCookie(SOManager.PLAYER_INFO);*/
			
			trace('configChangedHandler');
			return;
		}// end function
		
		
		private function shareIconclick(param1:Object) : void
		{
			
			trace('shareIconclick');
			return;
		}// end function
		
		private function nextClick(event:MouseEvent) : void
		{
			dispatchEvent(new OmsPlayerEvent(OmsPlayerEvent.NEXT_CLICK));
			//WebReportMananger.addReport({itype:WebReportPlayerClick.ITYPE_BTNNEXT}, true);
			return;
		}// end function
		
		
		//错误提示窗口
		private function onMsgPanelClick(param1:Object) : void
		{
			switch(param1.value.name)
			{
				case "error":
				{
					if (param1.value.code == "refresh")//刷新页面
					{
						if (ExternalInterface.available && GlobalVars.objIdAllowed)
						{
							ExternalInterface.call("eval", "window.location.reload()");
						}
					}
					else if (param1.value.code == "report")
					{
						this.naviToUrl(new URLRequest(GlobalVars.feedbackurl));//播放器出现问题的地方
					}
					break;
				}
				case "ip":
				{
					this.naviToUrl(new URLRequest(GlobalVars.helpurl));//关于IP地址受限导致无法播放的提示 
					break;
				}
				case "close":
				{
					this.removePanel(this.skinManager.msgPanel);//关闭错误窗口
					break;
				}
				default:
				{
					break;
				}
			}
			return;
		}// end function
		
		
		private function shareClose(param1:Object) : void
		{
			this.removePanel(this.skinManager.sharePanel);
			return;
		}// end function
		
		//顶部的最大小，最小化操作。显示视频效果用的。
		private function topScaleClick(param1:Object) : void
		{
			
			if (param1.value && param1.value.index != null)
			{
				switch(param1.value.index)
				{
					case 0:
					{
						this.videosizeFactor = 50;
						break;
					}
					case 1:
					{
						this.videosizeFactor = 75;
						break;
					}
					case 2:
					{
						this.videosizeFactor = 100;
						break;
					}
					default:
					{
						break;
					}
				}
				
				this.adjustVideoPlayer(this.videoWidth, this.videoHeight, true); //这里是调整尺寸的具体动作，后面需要调整
				
				
				
			}
			
			
			//trace('topScaleClick');
			return;
		}// end function
		
		
		private function topItemClick(param1:Object) : void
		{
			
			trace('topItemClick');
			return;
		}// end function
		
		
		
		//码率选择处理代码，这里需要多作些判断。
		private function definictionPanelClick(param1:Object = null) : void 
		{
			trace('弹出码率选择窗口，这里下个断点儿');
			var _loc_5:String = null;
			var _loc_2:* = this.skinManager.definitionPanel.lastSelect;
			var _loc_3:* = this.skinManager.definitionPanel.select;
			if (_loc_2 == _loc_3 || param1.value == null || param1.value.idx == null)
			{
				return;
			}
			var _loc_4:* = param1.value.idx;
			var _loc_6:* = this.speedObj == null || this.speedObj.speed == null ? (200) : (this.speedObj.speed);
			GlobalVars.isAutoFormat = false;
			GlobalVars.autoFormatType = ReportManager.FORMAT_SEL;
			GlobalVars.preformat = this.videoPlayer.getCurrFormat();
			GlobalVars.preformatName = this.videoPlayer.getCurrFormatName();
			if (_loc_3 == 0 || _loc_4 == -1)
			{
				GlobalVars.isAutoFormat = true;
				GlobalVars.autoFormatType = ReportManager.FORMAT_AUTO;
				_loc_5 = PlayerEnum.FORMAT_AUTO;
				GlobalVars.FormatSel = PlayerEnum.FORMAT_AUTO;
			}
			else
			{
				_loc_5 = FormatUtil.arrayHDName[_loc_4];
				this.skinManager.definitionPanel.updateItemByIdx(FormatUtil.getAutoDefinitionInfo());
			}
			GlobalVars.FormatSel = _loc_5;
			var _loc_10:* = _loc_5;
			GlobalVars.playerLocalInfo.format = _loc_5;
			
			this.currentVideoData.format = _loc_5;
			this.currentVideoData.playformat = _loc_5;
			var _loc_7:* = ResourceManager.instance.getContent("tipinfo_change3") + FormatUtil.getFileCHName(_loc_5) + ResourceManager.instance.getContent("tipinfo_change4");
			if (GlobalVars.playerversion == PlayerEnum.TYPE_NORMAL)
			{
				this.showMsgTip(_loc_7);
				
			}
			var _loc_8:* = this.videoPlayer.getPlayTime();
			this.playtimeObj = PlayTimeUtil.changeFormatPlaytime(this.playtimeObj, _loc_8);
			this.currentVideoData.playtimeInfo = this.playtimeObj;
			this.currentVideoData.video_changeformat = true;
			this.startToLoad();
			AS3Debugger.Trace("BasePlayerV3::definictionPanelClick time=" + _loc_8);
			//SOManager.soObj = GlobalVars.playerLocalInfo.toObject();
			//SOManager.saveCookie(SOManager.PLAYER_INFO);
			var _loc_9:* = _loc_4;
			if (_loc_4 == -1)
			{
				_loc_9 = 0;
			}
			//WebReportMananger.addReport({itype:WebReportPlayerClick.ITYPE_BTNDEFINITION, ctype:_loc_9});
			return;
		}// end function
		
		private function definictionPanelChange(param1:Object = null) : void
		{
			if (!this.skinManager.btnDefinition || !this.skinManager.definitionPanel || !param1.value || !param1.value.btnname)
			{
				return;
			}
			this.updateBtnDefinitionTxt(param1.value.btnname);
			return;
		}// end function
		
		private function onPanelMouseout(event:MouseEvent) : void
		{
			this.btnOutHandler(event);
			return;
		}// end function
		

		private function onPanelMouseover(event:MouseEvent) : void
		{
			switch(event.currentTarget)
			{
				case this.skinManager.definitionPanel:
				{
					clearTimeout(this.hideDefincount);
					break;
				}
				case this.skinManager.cfgPanel:
				{
					clearTimeout(this.hideCfgcount);
					break;
				}
				default:
				{
					break;
				}
			}
			return;
		}// end function
		
		
		
		private function updateBtnDefinitionTxt(param1:String) : void
		{
			if (this.skinManager.btnDefinition)
			{
				try
				{
					
					this.skinManager.btnDefinition.overstatus.txtCaption.text = param1;
					this.skinManager.btnDefinition.outstatus.txtCaption.text = param1;
				}
				catch (e:Error)
				{
				}
			}
			return;
		}// end function

		private function btnClick(event:MouseEvent):void{
			
			trace('test some thing');
		}
		private function btnOutHandler(event:MouseEvent) : void
		{
			var event:* = event;
			switch(event.currentTarget)
			{
				case this.skinManager.btnDefinition:
				case this.skinManager.definitionPanel:
				{
					this.hideDefincount = setTimeout(function ():void
					{
						if (skinManager.definitionPanel as DisplayObject && contains(skinManager.definitionPanel as DisplayObject))
						{
							removeChild(skinManager.definitionPanel as DisplayObject);
						}
						return;
					}// end function
						, this.hidetimeout);
					break;
				}
				case this.skinManager.btnConfig:
				case this.skinManager.cfgPanel:
				{
					this.hideCfgcount = setTimeout(function ():void
					{
						if (skinManager.cfgPanel as DisplayObject && contains(skinManager.cfgPanel as DisplayObject))
						{
							removeChild(skinManager.cfgPanel as DisplayObject);
						}
						return;
					}// end function
						, this.hidetimeout);
					break;
				}
				default:
				{
					break;
				}
			}
			return;
		}// end function

		
		
		
		
		private function onReplayClick(event:MouseEvent) : void
		{
			this.btnPlay();
			return;
		}// end function
		
		
		public function playVideo(param1:Array, param2:int, param3:Number = -1, param4:Number = -1, param5:Number = -1, param6:Number = -1, param7:Number = -1,xmlid:String='') : void
		{
			var arrayvid:* = param1;
			var status:* = param2;
			var start:* = param3;
			var end:* = param4;
			var history:* = param5;
			var movieStart:* = param6;
			var movieEnd:* = param7;
			if (!arrayvid && arrayvid.length == 0)
			{
				this.playerErrorHandler(PlayerEnum.ERROR_DEFAULT);
				return;
			}
			this.playStatus = status;
			this.playInit();
			
		
			
			
			this.playtimeObj = PlayTimeUtil.getPlayTimeInfo(start, end, history, movieStart, movieEnd, this.useMovieHeadTail);
			this.moStart = movieStart;
			this.moEnd = movieEnd;
			//var _loc_9:* = PlayerUtils.getVideoBufferBySpeed(GlobalVars.playerLocalInfo.format);
			this.speedObj = PlayerUtils.getVideoBufferBySpeed(GlobalVars.playerLocalInfo.format);
			GlobalVars.speedObj = PlayerUtils.getVideoBufferBySpeed(GlobalVars.playerLocalInfo.format);
			var playdata:* = new VideoPlayData();
			playdata.arrayVid = arrayvid;
			playdata.buffertime = this.speedObj.buffer;
			playdata.secBuffertime = this.speedObj.secbuffer;
			playdata.historySpeed = this.speedObj.speed;
			playdata.format = GlobalVars.playerLocalInfo.format;
			playdata.playformat = GlobalVars.playerLocalInfo.format;
			GlobalVars.FormatSel =GlobalVars.playerLocalInfo.format;
			playdata.playtimeInfo = this.playtimeObj;
			this.currentVideoData = playdata;
			this.menuConfig();
			this.enableMenu(false);
			try
			{
				if (arrayvid.length > 1)
				{
					GlobalVars.showShare = false;
				}
				else if (GlobalVars.playerversion == PlayerEnum.TYPE_NORMAL && !PlayerUtils.indexHomePages(GlobalVars.usingHost))
				{
					GlobalVars.showShare = false;
				}
			}
			catch (e:Error)
			{
				GlobalVars.showShare = false;
			}
			this.rpt_speedLoad = getTimer();
			//var adspeed:* = this.adPlayer ? (this.adPlayer.adspeed) : (0);
			var adspeed:* = 0;
			NetSpeedGetter.instance.addEventListener("nsg_getok", this.checkIp);
			NetSpeedGetter.instance.getSpeedTest(GlobalVars.playerLocalSpeed, adspeed);
			//MyVideoAction.instance.checkMyState(arrayvid[0], GlobalVars.exid);
			
			
			
			
			return;
		}// end function
		
		
		//这里获取XML里的omsID跟一些基本信息
		public function playVideoXml(param1:String, param2:int, param3:Number = -1, param4:Number = -1, param5:Number = -1, param6:Number = -1, param7:Number = -1,xmlid:String='') : void
		{
			
			//NetSpeedGetter.instance.addEventListener("nsg_getok", this.checkIp);
			//NetSpeedGetter.instance.getSpeedTest(GlobalVars.playerLocalSpeed, adspeed);
			//MyVideoAction.instance.checkMyState(arrayvid[0], GlobalVars.exid);
			
			
			
			
			return;
		}// end function
		
		
		
		
		
		private function checkIp(event:Event) : void
		{
			var _loc_2:* = getTimer() - this.rpt_speedLoad;
			GlobalVars.currip = NetSpeedGetter.instance.currIp;
			this.currentVideoData.historySpeed = NetSpeedGetter.instance.currSpeed;
			this.startToLoad();
			var _loc_3:String = "";
			if (this.currentVideoData.arrayVid && this.currentVideoData.arrayVid.length > 1)
			{
				_loc_3 = this.currentVideoData.arrayVid[0];
			}
			
			var _loc_4:* = ReportManager.createReportMode(ReportManager.STEP_GETSPEED, _loc_2, NetSpeedGetter.instance.isSucc ? (ReportManager.GETSPEED_SUCC) : (ReportManager.GETSPEED_HTTPERROR), NetSpeedGetter.instance.codenem, 0, _loc_3);
			_loc_4.bi = this.currentVideoData.historySpeed;
			_loc_4.vurl = NetSpeedGetter.instance.currPath;
			
			/*if (this.adPlayer)
			{
				_loc_4.level = this.adPlayer.adspeed.toString();
			}*/
			_loc_4.level = 1;
			ReportManager.addReport(_loc_4);
			return;
		}// end function
		
		
		private function menuConfig() : void
		{
			var _loc_1:ContextMenuItem = null;
			
			try
			{
				this.destoryMenu();
				contextMenu.customItems = [];
				if (this.skinManager && this.skinManager.infoPanel && GlobalVars.playerversion == PlayerEnum.TYPE_NORMAL)
				{
					_loc_1 = new ContextMenuItem(ResourceManager.instance.getContent("menu_info"), false, false);
					_loc_1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, this.onItemClick);
					contextMenu.customItems.push(_loc_1);
				}
				if (GlobalVars.playerversion == PlayerEnum.TYPE_NORMAL)
				{
					_loc_1 = new ContextMenuItem(ResourceManager.instance.getContent("menu_feedback"), false, false);
					_loc_1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, this.onItemClick);
					contextMenu.customItems.push(_loc_1);
				}
				if (GlobalVars.playerversion == PlayerEnum.TYPE_NORMAL)
				{
					_loc_1 = new ContextMenuItem(ResourceManager.instance.getContent("menu_help"), false, false);
					_loc_1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, this.onItemClick);
					contextMenu.customItems.push(_loc_1);
				}
				if (GlobalVars.usingHost != null && this.playtimeObj && this.playtimeObj.starttype != PlayTime.TYPE_ATTRACTION_START)
				{
					if (PlayerUtils.indexHomePages(GlobalVars.usingHost) && !GlobalVars.isPopUp && GlobalVars.playerversion == PlayerEnum.TYPE_NORMAL)
					{
						_loc_1 = new ContextMenuItem(ResourceManager.instance.getContent("menu_copyurl"), true, false);
						_loc_1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, this.onItemClick);
						contextMenu.customItems.push(_loc_1);
						_loc_1 = new ContextMenuItem(ResourceManager.instance.getContent("menu_copyurltime"), false, false);
						_loc_1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, this.onItemClick);
						contextMenu.customItems.push(_loc_1);
					}
				}
				_loc_1 = new ContextMenuItem(GlobalVars.version, true, false);
				contextMenu.customItems.push(_loc_1);
				_loc_1 = new ContextMenuItem("Flash " + GlobalVars.Capabilities, false, false);
				contextMenu.customItems.push(_loc_1);
			}
			catch (e:Error)
			{
			}
			return;
		}// end function
		
		private function destoryMenu() : void
		{
			var _loc_1:ContextMenuItem = null;
			var _loc_2:int = 0;
			if (contextMenu && contextMenu.customItems)
			{
				_loc_2 = 0;
				while (_loc_2 < contextMenu.customItems.length)
				{
					
					_loc_1 = contextMenu.customItems[_loc_2];
					if (_loc_1 && _loc_1.hasEventListener(ContextMenuEvent.MENU_ITEM_SELECT))
					{
						_loc_1.removeEventListener(ContextMenuEvent.MENU_ITEM_SELECT, this.onItemClick);
					}
					_loc_2++;
				}
				contextMenu.customItems.splice(0, contextMenu.customItems.length);
			}
			return;
		}// end function
		
		private function onItemClick(event:ContextMenuEvent) : void
		{
			var _loc_4:int = 0;
			var _loc_2:* = event.currentTarget as ContextMenuItem;
			if (!_loc_2 || !this.currentVideoData)
			{
				return;
			}
			var _loc_3:* = PlayerUtils.getPlayAdd(GlobalVars.coverid, this.currentVideoData.arrayVid.length == 1 ? (this.currentVideoData.arrayVid[0]) : (""));
			switch(_loc_2.caption)
			{
				case ResourceManager.instance.getContent("menu_info"):
				{
					if (!this.skinManager.infoPanel)
					{
						return;
					}
					if (this.skinManager.infoPanel.parent != this)
					{
						this.closePopupBut(this.skinManager.infoPanel);
					}
					else
					{
						this.removePanel(this.skinManager.infoPanel);
					}
					break;
				}
				case ResourceManager.instance.getContent("menu_feedback"):
				{
					if (this.playerstatus == PlayerEnum.STATE_PLAYING)
					{
						this.btnPause(null);
					}
					if (this.isFullScreen)
					{
						this.btnNormal();
					}
					try
					{
						navigateToURL(new URLRequest(GlobalVars.feedbackurl), "_blank");
					}
					catch (e:Error)
					{
					}
					break;
				}
				case ResourceManager.instance.getContent("menu_copyurl"):
				{
					System.setClipboard(_loc_3);
					break;
				}
				case ResourceManager.instance.getContent("menu_copyurltime"):
				{
					if (this.videoPlayer)
					{
						_loc_4 = Math.floor(this.videoPlayer.getPlayTime());
						if (_loc_4 != 0)
						{
							_loc_3 = PlayerUtils.addUrlTail(_loc_3, "start=" + _loc_4);
						}
						System.setClipboard(_loc_3);
					}
					break;
				}
				case ResourceManager.instance.getContent("menu_help"):
				{
					if (this.playerstatus == PlayerEnum.STATE_PLAYING)
					{
						this.btnPause(null);
					}
					if (this.isFullScreen)
					{
						this.btnNormal();
					}
					try
					{
						navigateToURL(new URLRequest(GlobalVars.helpurl), "_blank");
					}
					catch (e:Error)
					{
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
		
		
		private function enableMenu(param1:Boolean) : void
		{
			var _loc_3:ContextMenuItem = null;
			if (!contextMenu || !contextMenu.customItems)
			{
				return;
			}
			var _loc_2:* = contextMenu.customItems.length;
			var _loc_4:int = 0;
			while (_loc_4 < _loc_2)
			{
				
				_loc_3 = contextMenu.customItems[_loc_4];
				if (_loc_3 && _loc_3.caption == ResourceManager.instance.getContent("menu_info") || _loc_3.caption == ResourceManager.instance.getContent("menu_feedback") || _loc_3.caption == ResourceManager.instance.getContent("menu_copyurl") || _loc_3.caption == ResourceManager.instance.getContent("menu_copyurltime") || _loc_3.caption == ResourceManager.instance.getContent("menu_help"))
				{
					_loc_3.enabled = param1;
				}
				_loc_4++;
			}
			return;
		}// end function
		
		
		private function playInit() : void
		{
			this.playerstatus = PlayerEnum.STATE_STOP;
			GlobalVars.isPreviewVideo = false;
			GlobalVars.payedVideoStatus = "";
			this.evcreated = false;
			this.ignoreSpace = true;
			GlobalVars.showformat = true;
			GlobalVars.enabelGetClip = true;
			if (this.skinManager.btnReplay)
			{
				this.skinManager.btnReplay.visible = false;
			}
			if (GlobalVars.isAutoFormat)
			{
				GlobalVars.autoFormatType = ReportManager.FORMAT_AUTO;
			}
			else
			{
				GlobalVars.autoFormatType = ReportManager.FORMAT_SEL;
			}
			this.startPoint = 0;
			this.rpt_outLoadtime = 0;
			this.endPoint = 1;
			this.getSpeedInfo();
			ReportManager.reportStaticPara = new ReportMode();
			
			if (this.playStatus != PlayerEnum.START_PLAY)
			{
				this.adReadyToPlay = false;
			}
			try
			{
				this.skinManager.playerSkin.skin.controlBar_mc.seekBar.loadingWidth = 0;
				this.skinManager.playerSkin.skin.controlBar_mc.seekBar.position = 0;
				if (this.skinManager.miniSeekbar)
				{
					this.skinManager.miniSeekbar.loadingWidth = 0;
				}
				if (this.skinManager.miniSeekbar)
				{
					this.skinManager.miniSeekbar.position = 0;
				}
				this.skinManager.setShowTime("00:00", "00:00");
			}
			catch (e:Error)
			{
				
				this.skinManager.playerSkin.skin.controlBar_mc.play_btn.visible = true;
				this.skinManager.playerSkin.skin.controlBar_mc.play_btn.state = "pause";
			}
			catch (e:Error)
			{
				
				if (this.skinManager.vipTxt)
				{
					this.skinManager.vipTxt.visible = false;
				}
			}
			catch (e:Error)
			{
			}
			this.removePanel(this.skinManager.msgPanel);
			if (this.loadingswf)
			{
				this.loadingswf.setLoadingText(ResourceManager.instance.getContent("tipinfo_buffer"));
			}
			if (this.skinManager && this.skinManager.topPanel && this.skinManager.topPanel.parent != null)
			{
				
				//this.skinManager.topPanel.title = GlobalVars.flvtitle;
				this.skinManager.topPanel.title = '00000000000000000000000000000000';
				
			}
			GlobalVars.useVideoLogo = false;
			
			GlobalVars.dicStFormat = new Object();
			return;
		}// end function
		
		//好像是获取本地速度
		private function getSpeedInfo() : void
		{
			//SOManager.userspeedData = SOManager.getCookie(SOManager.LOCAL_SPEED);
			var _loc_1:* = new PlayerLocalSpeed();
			//_loc_1.copy(SOManager.userspeedData);
			GlobalVars.playerLocalSpeed = _loc_1;
			return;
		}// end function
		
		
		
		private function loadingswfCompleteHandler(event:LoadingSwfEvent) : void
		{
			this.loadingswf.removeEventListener(LoadingSwfEvent.LOADING_COMPLETE, this.loadingswfCompleteHandler);
			this.loadingswf.removeEventListener(LoadingSwfEvent.LOADING_ERROR, this.loadingswfCompleteHandler);
			this.loadingswf.resize(this.videoContainer.width, this.videoContainer.height);
			this.loadingswf.setLoadingText(ResourceManager.instance.getContent("tipinfo_buffer"));
			
			//报告载入发了多长时间
			ReportManager.addReport(ReportManager.createReportMode(ReportManager.STEP_LOAD_LOADING, getTimer() - this.rpt_playerloading, this.loadingswf && this.loadingswf.getLoader() ? (1) : (2), 0));
			
			
			if (this.loadingswf.parent != this)
			{
				this.addChildAt(this.loadingswf as DisplayObject, getChildIndex(this.skinManager.bigPlayBtn as DisplayObject));
			}
			dispatchEvent(new OmsPlayerEvent(OmsPlayerEvent.INIT_COMPLETE));//包括LOADSWF完成后，这里开始调用初始化工作代码
			
			
			
			GlobalVars.browserType = PlayerUtils.getBrowserType();
			AS3Debugger.Trace("GetBrowserType::" + GlobalVars.browserType);
			return;
		}// end function

		/*
		private function ispacSuccHandler(event:IspAcEvent) : void
		{
			GlobalVars.ispAc = "1";
			return;
		}// end function
		*/
		
		
		private function rightcfgItemClick(param1:Object) : void
		{
			if (param1.value != null && param1.value.name)
			{
				switch(param1.value.name)
				{
					case "favorite":
					{
						//this.onFavoriteClick(param1.value.code);
						trace('favorite');
						break;
					}
					case "share":
					{
						this.shareClick();
						break;
					}
					case "book":
					{
						//this.onBookClick(param1.value.code);
						trace('book');
						break;
					}
					default:
					{
						break;
					}
				}
			}
			return;
		}// end function
		
		
		
		//分享面板
		protected function shareClick(event:MouseEvent = null) : void
		{
			if (GlobalVars.playerversion == PlayerEnum.TYPE_NORMAL)
			{
				
				if (!this.skinManager.shareInside)
				{
					return;
				}
				if (this.skinManager.shareInside.parent != this)
				{
					this.closePopupBut(this.skinManager.shareInside);
					//WebReportMananger.addReport({itype:WebReportPlayerClick.ITYPE_BTNSHARE, ctype:WebReportPlayerClick.CTYPE_SHARE_CLICK});
				}
			}
			else
			{
				if (!this.skinManager.sharePanel)
				{
					return;
				}
				if (this.skinManager.sharePanel.parent != this)
				{
					this.closePopupBut(this.skinManager.sharePanel);
					//WebReportMananger.addReport({itype:WebReportPlayerClick.ITYPE_BTNSHARE, ctype:WebReportPlayerClick.CTYPE_SHARE_CLICK});
				}
				else
				{
					this.removePanel(this.skinManager.sharePanel);
				}
			}
			return;
		}// end function
		
		
		
		//隐藏mouse
		private function mouseLeaveHandler(event:Event) : void
		{
			this.mouseLeave = true;
			if (!this.mousecheck)
			{
				return;
			}
			this.hideRightCfg();
			this.showTopPanel(false);
			this.showCtrlBar(false);
			this.showSearchBar(false);
			return;
		}// end function

		
		
		
		private function skinConifg() : void
		{
			var _loc_1:Boolean = false;
			/*
			try
			{
				this.skinManager.contrlBar.seekBar.position = 0;
				this.skinManager.contrlBar.sound.setVolume(GlobalVars.playerLocalInfo.volume / 100, false);
			}
			catch (e:Error)
			{
				
			}
			*/
			if (this.skinManager.contrlBar)
			{
				this.videoWidth = this.playerWidth;
				this.videoHeight = this.playerHeight - this.skinManager.contrlBar.bg_mc.height;
				this.videoContainer.setSize(this.videoWidth, this.videoHeight);
				if (this.skinManager.payTxt)
				{
					this.skinManager.payTxt.visible = false;
				}
			}
			else
			{
				this.videoContainer.setSize(this.playerWidth, this.playerHeight);
			}
			
			if (this.skinManager.cfgPanel)
			{
				_loc_1 = GlobalVars.playerLocalInfo.headtail == 1 ? (true) : (false);
				try{
					this.skinManager.cfgPanel.setHeadStatus(_loc_1);
					this.useMovieHeadTail = _loc_1;
					this.headtailConfirmClickHandler(GlobalVars.playerLocalInfo.headtail);
				}catch (e:Error){
					
				
				}
			}
			
			if (this.skinManager.definitionPanel)
			{
				GlobalVars.userSelFormat = FormatUtil.NAME_AUTO;
				if (GlobalVars.playerLocalInfo.format == PlayerEnum.FORMAT_SD)
				{
					GlobalVars.userSelFormat = FormatUtil.NAME_SD;
				}
				else if (GlobalVars.playerLocalInfo.format == PlayerEnum.FORMAT_HD)
				{
					GlobalVars.userSelFormat = FormatUtil.NAME_HD;
				}
				else if (GlobalVars.playerLocalInfo.format == PlayerEnum.FORMAT_SHD)
				{
					GlobalVars.userSelFormat = FormatUtil.NAME_SHD;
				}
				else if (GlobalVars.playerLocalInfo.format == PlayerEnum.FORMAT_FHD)
				{
					GlobalVars.userSelFormat = FormatUtil.NAME_FHD;
				}
				if (GlobalVars.userSelFormat != FormatUtil.NAME_AUTO)
				{
					GlobalVars.isAutoFormat = false;
				}
				else
				{
					GlobalVars.isAutoFormat = true;
				}
			}
			
			try
			{
				if (!this.skinManager.sharePanel && !this.skinManager.shareInside)
				{
					GlobalVars.showShare = false;
				}
			}
			catch (e:Error)
			{
				
				this.skinManager.playerSkin.skin.showCfg = GlobalVars.showCfg;
			}
			catch (e:Error)
			{
				
				this.skinManager.playerSkin.skin.showNext = GlobalVars.showNext;
			}
			/*catch (e:Error)
			{
				this.skinManager.playerSkin.skin.showLogo = false;
				//this.skinManager.playerSkin.skin.showLogo = GlobalVars.showlogo;
			}*/
			catch (e:Error)
			{
				
				this.skinManager.playerSkin.skin.controlBar_mc.seekBar.loadingWidth = 0;
				this.skinManager.playerSkin.skin.controlBar_mc.seekBar.position = 0;
				if (this.skinManager.miniSeekbar)
				{
					this.skinManager.miniSeekbar.loadingWidth = 0;
				}
				if (this.skinManager.miniSeekbar)
				{
					this.skinManager.miniSeekbar.position = 0;
				}
				this.skinManager.setShowTime("00:00", "00:00");
			}
			catch (e:Error)
			{
			}
			
			if (this.skinManager.headtailTip)
			{
				this.skinManager.headtailTip.playerwidth = this.playerWidth;
			}
			if (this.skinManager.timeTip)
			{
				this.skinManager.timeTip.playerwidth = this.playerWidth;
			}
			if (this.skinManager.soundTip)
			{
				this.skinManager.soundTip.playerwidth = this.playerWidth;
			}
			/*if (this.tipTimePanel)
			{
				this.tipTimePanel.playerWidth = this.playerWidth;
			}
			*/
			
			
			return;
		}// end function
		
		//给相关的按键增加监听事件.部分功能现在先去掉,主要是针对界面上的一些控制控制
		protected function addContrlEvents() : void
		{
			this.skinManager.contrlBar.play_btn.addEventListener("play", this.btnPlay);
			this.skinManager.contrlBar.play_btn.addEventListener("pause", this.btnPause);
			
			
			this.skinManager.contrlBar.full_btn.addEventListener("full", this.btnFull);
			this.skinManager.contrlBar.full_btn.addEventListener("normal", this.btnNormal);

			this.skinManager.contrlBar.seekBar.addEventListener("seek_start", this.seekStart);
			this.skinManager.contrlBar.seekBar.addEventListener("seek_stop", this.seekStop);
			this.skinManager.contrlBar.seekBar.addEventListener("seeking", this.seeking);
			this.skinManager.contrlBar.seekBar.addEventListener("show_tip", this.showHeadtailTip);
			this.skinManager.contrlBar.seekBar.addEventListener("hide_tip", this.hideHeadtailTip);
				
				//this.skinManager.contrlBar.stop_btn.addEventListener(MouseEvent.MOUSE_UP, this.btnStop);
				
				
			
			this.skinManager.contrlBar.sound.addEventListener("volume_change_start", this.soundChangeStart);
			this.skinManager.contrlBar.sound.addEventListener("volume_change", this.soundChange);
			this.skinManager.contrlBar.sound.addEventListener("volume_change_stop", this.soundChangeStop);
			this.skinManager.contrlBar.sound.addEventListener("volume_mute", this.mute);
			this.skinManager.contrlBar.sound.addEventListener("volume_unmute", this.unmute);
			this.skinManager.contrlBar.sound.addEventListener("volume_outset", this.soundTipChange);
			
			
		
			
			
			if (this.skinManager.btnDefinition)
			{
				this.skinManager.btnDefinition.addEventListener(MouseEvent.MOUSE_OVER, this.btnOverHandler);
				this.skinManager.btnDefinition.addEventListener(MouseEvent.MOUSE_OUT, this.btnOutHandler);
				this.skinManager.btnDefinition.addEventListener(MouseEvent.CLICK,this.btnClick);
			}
			if (this.skinManager.btnConfig)
			{
				//trace('000000000000000000000000000000000000000');
				
				this.skinManager.btnConfig.addEventListener(MouseEvent.MOUSE_OVER, this.btnOverHandler);
				this.skinManager.btnConfig.addEventListener(MouseEvent.MOUSE_OUT, this.btnOutHandler);
			}
			
			
			return;
		}// end function
		
		
		
		protected function soundChangeStart(event:Event = null, param2:Boolean = true) : void
		{
			var tipx:Number;
			var event:* = event;
			var showVolumeInfo:* = param2;
			try
			{
				tipx = this.skinManager.contrlBar.sound.tipx + this.skinManager.contrlBar.sound.x;
			}
			catch (e:Error)
			{
				tipx;
			}
			this.showSoundTip(tipx, showVolumeInfo);
			//WebReportMananger.addReport({itype:WebReportPlayerClick.ITYPE_BTNSOUND});
			//trace('soundChangeStart');
			return;
		}// end function
		
		protected function soundChange(event:Event = null) : void
		{
			var tipx:Number;
			var event:* = event;
			try
			{
				GlobalVars.playerLocalInfo.volume = Math.round(this.skinManager.contrlBar.sound.volume * 100);
				this.videoPlayer.setVolume(GlobalVars.playerLocalInfo.volume);
			}
			catch (e:Error)
			{
				
				tipx = this.skinManager.contrlBar.sound.tipx + this.skinManager.contrlBar.sound.x;
			}
			catch (e:Error)
			{
				tipx;
			}
			this.showSoundTip(tipx);
			//trace('soundChange');
			return;
		}// end function
		
		private function soundTipChange(param1:Object = null) : void
		{
			var _loc_2:Boolean = false;
			if (param1 && param1.value && param1.value.hasOwnProperty('type') && param1.value.type == "up")
			{
				_loc_2 = true;
			}
			this.soundChangeStart(null, _loc_2);
			//trace('soundTipChange');
			return;
		}// end function

		
		protected function showSoundTip(param1:Number = -100, param2:Boolean = true) : void
		{
			var x:* = param1;
			var showVolumeInfo:* = param2;
			if (GlobalVars.playerSkinUrl != PlayerEnum.SKINURL_DEFAULT_V4 && GlobalVars.playerSkinUrl != PlayerEnum.SKINURL_OUT_V4)
			{
				return;
			}
			clearTimeout(this.soundTipCount);
			if (this.skinManager.soundTip==null || !contains(this.skinManager.soundTip))
			{
				addChild(this.skinManager.soundTip as DisplayObject);
			}
			var soundvalue:* = GlobalVars.playerLocalInfo.volume;
			if (showVolumeInfo && soundvalue == 100 && PlayerUtils.indexHomePages(GlobalVars.usingHost))
			{
				this.skinManager.soundTip.tiptext = soundvalue.toString() + "(" + ResourceManager.instance.getContent("volume_info") + ")";
				this.skinManager.soundTip.autosize = true;
			}
			else
			{
				this.skinManager.soundTip.tiptext = soundvalue.toString();
				this.skinManager.soundTip.autosize = false;
			}
			this.skinManager.soundTip.y = this.playerHeight - 58;
			this.skinManager.soundTip.x = x;
			this.soundTipCount = setTimeout(function ():void
			{
				if (contains(skinManager.soundTip))
				{
					removeChild(skinManager.soundTip);
				}
				return;
			}// end function
				, 1200);
			return;
		}// end function
		
		protected function soundChangeStop(event:Event = null) : void
		{
			var tipx:Number;
			var event:* = event;
			if (GlobalVars.playerLocalInfo.volume == 100)
			{
				clearTimeout(this.hideTipTimeout);
				this.hideTipTimeout = setTimeout(function ():void
				{
					showMsgTip("增加声音");
					return;
				}// end function
					, 3000);
			}
			this.muteVolume = this.videoPlayer.getVolume();
			//SOManager.soObj = GlobalVars.playerLocalInfo.toObject();
			//SOManager.saveCookie(SOManager.PLAYER_INFO);
			try
			{
				tipx = this.skinManager.contrlBar.sound.tipx + this.skinManager.contrlBar.sound.x;
			}
			catch (e:Error)
			{
				tipx;
			}
			this.showSoundTip(tipx);
			//trace('soundChangeStop');
			return;
		}// end function
		
		
		protected function mute(event:Event = null) : void
		{
			if (this.videoPlayer)
			{
				this.muteVolume = this.videoPlayer.getVolume();
				GlobalVars.playerLocalInfo.volume = 0;
				this.videoPlayer.setVolume(0);
			}
			//trace('mute');
			return;
		}// end function
		
		protected function unmute(event:Event = null) : void
		{
			if (this.videoPlayer)
			{
				GlobalVars.playerLocalInfo.volume = this.muteVolume;
				this.videoPlayer.setVolume(this.muteVolume);
				AS3Debugger.Trace("unmute" + this.muteVolume);
			}
			//trace('unmute');
			return;
		}// end function
		
		
		
		//开始跳转前的一些设置,包括显示跳转信息,报告及暂时当前计时器等信息
		protected function seekStart(event:Event = null) : void
		{
			var event:* = event;
			AS3Debugger.Trace("BasePlayerV3::seekstart");
			if (this.videoPlayer == null)
			{
				return;
			}
			if (this.playerstatus == PlayerEnum.STATE_PLAYING)
			{
				this.videoPlayer.pause();
			}
			this.showPlayTip = false;
			this.playerstatus = PlayerEnum.STATE_SEEKING;
			if (this.timer && this.timer.isRunning())
			{
				this.timer.stop();
			}
			return;
			
			
			return;
		}// end function

		
		//跳转过程中的时间设置
		protected function seeking(event:Event = null) : void
		{
			//更新显示时间。
			trace('正在跳');
			var event:* = event;
			if (this.videoPlayer == null)
			{
				return;
			}
			var p:Number;
			var progress:Number;
			var duration:* = this.videoPlayer.getDuration();//总时长
			try
			{
				p = this.skinManager.contrlBar.seekBar.position; //当前位置
				progress = p;
				if (this.startPoint >= 0 && this.endPoint > this.startPoint && this.endPoint <= 1)
				{
					duration = (this.endPoint - this.startPoint) * duration;
					progress = progress * (this.endPoint - this.startPoint) + this.startPoint;
				}
			}
			catch (e:Error)
			{
			}
			if (progress > 1)
			{
				progress;
			}
			var pTime:* = Math.floor(p * duration * 100) / 100;
			
			
			//这里设置了一次时间
			this.skinManager.setShowTime(Tool.timeFormat(pTime * 1000, this.timeFormatType), Tool.timeFormat(duration * 1000, this.timeFormatType));
			
			try
			{
				//trace('-------------------------------00000----------');
				this.showTimeTip(Tool.timeFormat(pTime * 1000, this.timeFormatType));//这里是显示时间用的，现在没有这个功能。
			}
			catch (e:Error)
			{
			}
			return;
		}// end function
		
		
		//跳转完成后,相关报告及恢复计时器,后面的一个功能是我加的,这里先加上,具体效果还需要全部分析完成后再看了.
		protected function seekStop(event:Event = null) : void
		{
			
		
			var seekPosition:Number;
			var event:* = event;
			this.playerstatus = PlayerEnum.STATE_SEEKED;
			clearTimeout(this.filmstipTimeCount);
			
			
			seekPosition = this.skinManager.contrlBar.seekBar.position;
			var total:* = this.videoPlayer.getDuration();
			if (seekPosition > 0.999 || total != 0 && total - seekPosition * total <= 5)
			{
				this.stopByRanSeek();
				return;
			}
			if (this.startPoint >= 0 && this.endPoint > this.startPoint)
			{
				seekPosition = (this.endPoint - this.startPoint) * seekPosition + this.startPoint;
			}
			if (this.videoPlayer)
			{
				this.videoPlayer.pause();
				
			}
			
			if (this.timer && this.timer.isRunning())
			{
				this.timer.stop();
			}
			
			clearTimeout(this.seekstopTimeoutCount);
			this.seekstopTimeoutCount = setTimeout(function ():void
			{
				seekStopHandler(seekPosition);
				AS3Debugger.Trace("BasePlayerV3::seekstop " + seekPosition);
				return;
			}// end function
			, 200);
			return;
			
		}// end function
		
		
		
		
		//隐藏多码流的相关操作
		private function hideHeadtailTip(param1:Object) : void
		{
			//trace('******************************');
			this.skinManager.timeTip.visible = true;
			if (this.skinManager.headtailTip.parent == this)
			{
				removeChild(this.skinManager.headtailTip);
			}
			/*if (this.tipTimePanel)
			{
				this.tipTimePanel.visible = true;
			}*/
			return;
		}// end function

		
		
		//显示多码流的信息,这里先不用...等后面再看
		private function showHeadtailTip(param1:Object) : void
		{
			trace('showHeadtailTip');
			//trace('00000000000000000000000000000000000');
			if (!param1.value || !param1.value.type || !param1.value.poi)
			{
				return;
			}
			if (param1.value.type == "start")
			{
				this.skinManager.headtailTip.tiptext = ResourceManager.instance.getContent("tiptxt_head");
			}
			else if (param1.value.type == "end")
			{
				this.skinManager.headtailTip.tiptext = ResourceManager.instance.getContent("tiptxt_tail");
			}
			this.skinManager.headtailTip.y = this.skinManager.playerSkin.skin.controlBar_mc.y + this.skinManager.playerSkin.skin.controlBar_mc.seekBar.y - this.skinManager.headtailTip.height - 2;
			this.skinManager.headtailTip.x = mouseX;
			this.skinManager.timeTip.visible = false;
			if (this.skinManager.headtailTip.parent != this)
			{
				addChild(this.skinManager.headtailTip);
			}
			/*if (this.tipTimePanel)
			{
				this.tipTimePanel.visible = false;
			}*/
			return;
		}// end function
		
		
		
		//这里也是跳转,这个是否有用,后面再看
		private function stopByRanSeek() : void
		{
			var _loc_1:Number = NaN;
			var _loc_2:* = this.videoPlayer.getDuration();
			if (this.endPoint > this.startPoint && this.startPoint >= 0 && this.endPoint <= 1)
			{
				_loc_2 = (this.endPoint - this.startPoint) * this.videoPlayer.getDuration();
			}
			if (_loc_2 > 5)
			{
				_loc_1 = _loc_2 - 5;
				if (this.endPoint > this.startPoint && this.startPoint >= 0 && this.endPoint <= 1)
				{
					_loc_1 = _loc_1 + this.startPoint * this.videoPlayer.getDuration();
				}
			}
			else
			{
				_loc_1 = 0;
			}
			this.seekStopHandler(_loc_1 / this.videoPlayer.getDuration());
			return;
		}// end function
		
		
		//全屏操作
		protected function btnFull(event:Event = null) : void
		{
			trace('测试某个按键');
			this.screenfull = true;
			if (event)
			{
				//WebReportMananger.addReport({itype:WebReportPlayerClick.ITYPE_BTNFULL});
			}
			return;
		}// end function
		
		//视频暂停或是停止动作
		protected function btnStop(event:Event = null, param2:Boolean = true) : void
		{
			if (!this.videoPlayer)
			{
				return;
			}
			this.videoPlayer.destroy();
			this.playCompleteHandler();
			if (param2)
			{
				if (this.videoPlayer.getLoadedPercent() == 1)
				{
					dispatchEvent(new OmsPlayerEvent(OmsPlayerEvent.PLAY_STOP, {code:"loaded"}));
				}
				else
				{
					dispatchEvent(new OmsPlayerEvent(OmsPlayerEvent.PLAY_STOP, {code:"loading"}));
				}
			}
			return;
		}// end function
		
		
		
		//功能待定,,,后面再看效果
		private function headtailConfirmClickHandler(param1:int) : void
		{
			if (param1 == 0)
			{
				this.useMovieHeadTail = false;
				if (this.skinManager.contrlBar.seekBar)
				{
					this.skinManager.contrlBar.seekBar.hideAttrationPoint();
				}
			}
			else
			{
				this.useMovieHeadTail = true;
				if (this.skinManager.contrlBar.seekBar && this.playtimeObj && this.playtimeObj.headstarttime >= 0 && this.playtimeObj.headstarttime < this.playtimeObj.endtime)
				{
					if (this.moStart >= 0 && this.moEnd > this.moStart && this.moEnd - this.moStart < this.currentVideoData.video_duration - 2)
					{
						this.skinManager.contrlBar.seekBar.showAttractionPoint(this.playtimeObj.headstarttime / this.videoPlayer.getDuration(), this.playtimeObj.endtime / this.videoPlayer.getDuration());
					}
				}
			}
			if (this.useMovieHeadTail)
			{
				this.showTailMsg = true;
			}
			return;
		}// end function
		
		
		
		
		
		
		//皮肤载入错误时的处理动作
		private function skinloadErrorHandler(event:SkinManagerV3Event) : void
		{
			this.skinManager.removeEventListener(SkinManagerV3Event.SKIN_LOAD_COMPLETE, this.skinloadCompleteHandler);
			this.skinManager.removeEventListener(SkinManagerV3Event.SKIN_LOAD_ERROR, this.skinloadErrorHandler);
			ReportManager.addReport(ReportManager.createReportMode(ReportManager.STEP_LOAD_SKIN, getTimer() - this.rpt_playerinit, 2, 0), true);
			dispatchEvent(new OmsPlayerEvent(OmsPlayerEvent.INIT_ERROR));
			return;
		}// end function
		
		
		//获取配置
		private function getLocalInfo():void
		{
			
			var _loc_1:* = new PlayerLocalInfo();
			_loc_1.guid = Guid.create();
			GlobalVars.playerLocalInfo = _loc_1;  //某个配置信息
			return;
	
		}
		//定时执行的某个东西,这个代码有些多,后面再看了.
		/*
		 *要绑定到这里来..日他仙人的. 
		*/
		
		private function timerhandler() : void
		{
			
			
			
			
			
			
			//找个进度条显示的问题
			var _loc_6:Number = NaN;
			var _loc_7:String = null;
			var _loc_8:Number = NaN;
			var _loc_9:String = null;
			//ReportPlaytime.updatePlayingTime(this.playerstatus);
			
			var _loc_1:* = this.videoPlayer.getLoadedPercent()>0.99?1:this.videoPlayer.getLoadedPercent();
			var _loc_2:* = this.videoPlayer.getPlayPercent();
			var _loc_3:* = this.videoPlayer.getPlayTime();
			var _loc_4:* = this.videoPlayer.getDuration();
			
			var _loc_5:* = Math.round(this.videoPlayer.getBufferLengthPercent() * 100)>=100?100:Math.round(this.videoPlayer.getBufferLengthPercent() * 100);
			
			
			
			try
			{
				if (!this.videoPlayer.getIsBufferring())
				{
					this.lastBufferPer = 0;
					this.bufferingCount = 0;
					if (this.endPoint > this.startPoint && this.startPoint >= 0)
					{
						if (_loc_1 > this.endPoint)
						{
							_loc_1 = this.endPoint;
						}
						_loc_1 = (_loc_1 - this.startPoint) / (this.endPoint - this.startPoint);
					}
					//暂入的进度.
					//this.skinManager.playerSkin.skin.controlBar_mc.seekBar.loadingWidth = _loc_3;
					this.skinManager.playerSkin.skin.controlBar_mc.seekBar.loadingWidth = _loc_1;
					
					if (this.skinManager.miniSeekbar)
					{
						this.skinManager.miniSeekbar.loadingWidth = _loc_1;
					}
				}
			}
			catch (e:Error)
			{
			}
			
			
			//把时间显示的动作在这里操作一下..暂时不知道代码在哪里?
			this.infoPanelTimecout();
			//如果在播放状态
			if (this.playerstatus == PlayerEnum.STATE_PLAYING)
			{
				
				
				_loc_6 = _loc_3;
				if (this.endPoint > this.startPoint && this.startPoint >= 0)
				{
					_loc_3 = _loc_3 - this.startPoint * _loc_4;
					_loc_4 = (this.endPoint - this.startPoint) * _loc_4;
					if (_loc_3 < 0)
					{
						_loc_3 = 0;
					}
				}
				
				
				this.skinManager.contrlBar.seekBar.position = _loc_2;
				//显示时间
				if (!this.videoPlayer.ranSeekAbled)
				{
					try
					{
						this.skinManager.contrlBar.seekBar.position = _loc_2;
						if (_loc_3 > _loc_4 && _loc_4 > 0)
						{
							_loc_6 = _loc_4;
						}
						GlobalVars._Nowtime = _loc_6;
						trace('更新时间1');
						this.skinManager.setShowTime(Tool.timeFormat(_loc_6 * 1000, this.timeFormatType), Tool.timeFormat(_loc_4 * 1000, this.timeFormatType));
					}
					catch (e:Error)
					{
					}
				}
				else
				{
					
					
					if (_loc_3 > _loc_4)
					{
						this.videoPlayer.stop();
						this.playCompleteHandler();
						dispatchEvent(new OmsPlayerEvent(OmsPlayerEvent.PLAY_STOP));
						return;
					}
					//创建一个新的下载连接.好像是这样的.
					if (_loc_4 - 10 < _loc_3 || this.videoPlayer.getRangePlay() && this.videoPlayer.getVideoData().playtimeInfo.endtime > 0 && this.videoPlayer.getVideoData().playtimeInfo.endtime - 10 < _loc_3)
					{
						this.createevEvent();
					}
					
					if (_loc_3 > _loc_4 && _loc_4 > 0)
					{
						_loc_3 = _loc_4;
					}
					//trace('更新时间二');
					GlobalVars._Nowtime = _loc_3;
					//trace(GlobalVars._Nowtime);
					this.skinManager.setShowTime(Tool.timeFormat(_loc_3 * 1000, this.timeFormatType), Tool.timeFormat(_loc_4 * 1000, this.timeFormatType));
					
				}
				
				
				
				if (GlobalVars.isPayedVideo && GlobalVars.isPreviewVideo && _loc_3 > GlobalVars.previewDuration)
				{
					this.videoPlayer.stop();
					this.playCompleteHandler();
					this.unpayHandler();
					return;
				}
				
				
				if (GlobalVars.showCfg && this.skinManager.cfgPanel && this.useMovieHeadTail && this.showTailMsg && this.playtimeObj && this.playtimeObj.starttime >= 0 && this.playtimeObj.starttime < this.playtimeObj.endtime && this.playtimeObj.endtime - _loc_3 < 10 && _loc_3 < this.playtimeObj.endtime && this.playtimeObj.endtime < _loc_4 - 3)
				{
					this.showTailMsg = false;
					AS3Debugger.Trace("BasePlayerV3::tipinfo_tail");
					//这里是显示一部分信息
					this.showCheckPlay(ResourceManager.instance.getContent("tipinfo_tail"), ResourceManager.instance.getContent("tiptxt_cfg"), {key:PlayerEnum.TIPLINK_HEADTAIL});
				}
				
				
			}else if (this.playerstatus == PlayerEnum.STATE_SEEKED){
				//trace('测试是否中断');
				//视频跳的时候,显示的提示
				if (_loc_5 >= 100){
				
					this.skinManager.showMsgTip();
				
				}else{
					
					_loc_7 = isNaN(_loc_5) ? (ResourceManager.instance.getContent("tipinfo_buffer")) : (ResourceManager.instance.getContent("tipinfo_buffer") + _loc_5 + "%");
					this.skinManager.showMsgTip(_loc_7);
					
				}
				
			}
			
			
			
			if (this.videoPlayer.getIsBufferring())
			{
				_loc_8 = Math.round(this.videoPlayer.getBufferLengthPercent() * 100000) / 1000;
				if (_loc_8 >= 100)
				{
					_loc_8 = 100;
					this.skinManager.showMsgTip();
				}
				else
				{
					if (_loc_8 == this.lastBufferPer)
					{
						
						var _loc_11:* = this.bufferingCount + 1;
						this.bufferingCount = _loc_11;
						
					}else{
						
						this.lastBufferPer = _loc_8;
						this.bufferingCount = 0;
						
					}
					
					//缓冲次数太多的话,会显示下面的信息
					if (this.bufferingCount >= 15)
					{
						this.bufferingCount = 0;
						this.skinManager.showMsgTip(ResourceManager.instance.getContent("tipinfo_buffer") + "...");
						this.playtimeObj = PlayTimeUtil.changeFormatPlaytime(this.playtimeObj, this.videoPlayer.getPlayTime());
						this.currentVideoData.playtimeInfo = this.playtimeObj;
						this.currentVideoData.video_autoseek = true;
						this.startToLoad();
						AS3Debugger.Trace("BasePlayerV3::timerhandler seek");
						ReportManager.addReport(ReportManager.createReportMode(ReportManager.STEP_BUFFERSTOP, getTimer() - this.rpt_emptytime, 0, 0, this.videoPlayer.getPlayTime(), this.videoPlayer.getCurrVid(), this.videoPlayer.getCurrFormat(), this.videoPlayer.getModetype(), this.videoPlayer.getCurrVt(), 0, this.videoPlayer.getCurrLevel(), "", this.videoPlayer.getCurrFormatName(), {usingP2P:this.videoPlayer.getUsingP2P()}), false);
						return;
						
					}
					
					
					_loc_8 = Math.round(_loc_8);
					if (this.emptyCount > 0 && (this.emptyCount + 1) % 3 == 0 && this.skinManager.definitionPanel && this.skinManager.definitionPanel.select != 0 && FormatUtil.hasMutiFormat(this.currentVideoData) && FormatUtil.checkLessDefinitionByFormat(this.currentVideoData.video_fmtlist, this.currentVideoData.video_curfmt))
					{
						this.showCheckPlay(ResourceManager.instance.getContent("tipinfo_buffered") + _loc_8 + "%..." + ResourceManager.instance.getContent("tipinfo_change"), ResourceManager.instance.getContent("tiptxt_change"), {key:PlayerEnum.TIPLINK_FORMAT}, 0, 0);
					}
					else
					{
						_loc_9 = ResourceManager.instance.getContent("tipinfo_buffered") + _loc_8 + "%...";
						if (this.playerWidth >= 600)
						{
							_loc_9 = _loc_9 + ResourceManager.instance.getContent("tipinfo_pause");
						}
						this.skinManager.showMsgTip(_loc_9);
						
					}
				}
			}
			
			if (this.loadingswf && this.loadingswf.parent == this)
			{
				if (_loc_5 < 10)
				{
					_loc_5 = 10;
				}
				this.loadingswf.setLoadingText(ResourceManager.instance.getContent("tipinfo_buffer") + " " + _loc_5 + "%");
			}
			

			//这里好像是跟进度相关的,这个是报告状态的..还是需要打开的.
			if (this.videoPlayer)
			{
				ReportManager.heartReportOnTime(this.videoPlayer.getCurrFormat(), this.videoPlayer.getModetype(), this.videoPlayer.getCurrVt());
			}
			
			
			return;
		}// end function
		
		/*
		 *
		 * 可以考试在这个地方加入统计,测试下效果
		 *
		*/

		//开始载入视频
		private function startToLoad() : void
		{
			
			
			
			
			this.adjustPayPanel(false);//显示支持,暂时不提供
			this.playerstatus = PlayerEnum.STATE_REQUESTING;
			if (!this.videoPlayer.hasEventListener(VideoPlayerEvent.PLAY_NOMAL_ERROR))
			{
				this.videoPlayer.addEventListener(VideoPlayerEvent.PLAY_NOMAL_ERROR, this.playerError);
			}
			if (!this.videoPlayer.hasEventListener(VideoPlayerEvent.PLAY_STATUS_CHANGED))
			{
				this.videoPlayer.addEventListener(VideoPlayerEvent.PLAY_STATUS_CHANGED, this.statusChangedHandler); //这里是监听状态的.
			}
			
			this.videoPlayer.play(this.currentVideoData);//开始播放某些类信息
			
			return;
		}// end function
		
		//初始化播放器
		private function playerInitTime() : void
		{
			var _loc_1:* = this.videoPlayer.getDuration();
			if (this.playtimeObj && this.playtimeObj.starttype == PlayTime.TYPE_ATTRACTION_START && this.playtimeObj.endtype == PlayTime.TYPE_ATTRACTION_END && this.playtimeObj.endtime > this.playtimeObj.starttime)
			{
				_loc_1 = this.playtimeObj.endtime - this.playtimeObj.starttime;
			}
			if (_loc_1 >= 3600)
			{
				this.timeFormatType = "00:00:00";
			}
			else
			{
				this.timeFormatType = "00:00";
			}
			GlobalVars._Videotime = _loc_1;
			this.skinManager.setShowTime(Tool.timeFormat(0, this.timeFormatType), Tool.timeFormat(_loc_1 * 1000, this.timeFormatType), this.timeFormatType);
			return;
		}// end function
		
		
		//检测支付状态,这里可以不需要
		private function checkPayStatus() : void
		{
			var _loc_1:Number = NaN;
			var _loc_2:Object = null;
			var _loc_3:String = null;
			var _loc_4:String = null;
			var _loc_5:int = 0;
			var _loc_6:Number = NaN;
			var _loc_7:String = null;
			var _loc_8:String = null;
			var _loc_9:String = null;
			var _loc_10:String = null;
			var _loc_11:String = null;
			var _loc_12:String = null;
			var _loc_13:String = null;
			var _loc_14:Number = NaN;
			var _loc_15:Number = NaN;
			if (GlobalVars.isPayedVideo)
			{
				_loc_1 = GlobalVars.pay == 2 ? (600) : (630);
				try
				{
					if (ExternalInterface.available && GlobalVars.objIdAllowed)
					{
						_loc_2 = ExternalInterface.call("__tenplay_getpayinfo");
					}
				}
				catch (e:Error)
				{
				}
				_loc_3 = "0";
				_loc_4 = "0";
				_loc_5 = 0;
				if (_loc_2)
				{
					if (_loc_2.uinfo != undefined && _loc_2.uinfo != null)
					{
						_loc_3 = "" + _loc_2.uinfo;
					}
					if (_loc_2.vinfo != undefined && _loc_2.vinfo != null)
					{
						_loc_4 = "" + _loc_2.vinfo;
					}
					if (_loc_2.ticketnum != undefined && _loc_2.ticketnum != null && !isNaN(Number(_loc_2.ticketnum * 1)))
					{
						_loc_5 = Number(_loc_2.ticketnum * 1);
					}
				}
				if (GlobalVars.isPreviewVideo)
				{
					_loc_7 = "";
					_loc_8 = GlobalVars.pay == 2 ? ("tiptxt_buy_nba") : ("tiptxt_buy");
					_loc_9 = GlobalVars.pay == 2 ? ("tipinfo_buyhead_nba") : ("tipinfo_buyhead");
					_loc_10 = GlobalVars.pay == 2 ? ("tipinfo_buytail_nba") : ("tipinfo_buytail");
					if (GlobalVars.previewDuration % 60 == 0)
					{
						_loc_7 = "" + GlobalVars.previewDuration / 60 + ResourceManager.instance.getContent("tipinfo_buy_minute");
					}
					else
					{
						_loc_7 = "" + GlobalVars.previewDuration + ResourceManager.instance.getContent("tipinfo_buy_second");
					}
					if (this.playerWidth > 10 && this.playerWidth < _loc_1 || this.skinManager.payTxt == null)
					{
						if (GlobalVars.playerversion == PlayerEnum.TYPE_NORMAL)
						{
							_loc_11 = ResourceManager.instance.getContent(_loc_8);
							this.showCheckPlay(ResourceManager.instance.getContent(_loc_9) + _loc_7 + ResourceManager.instance.getContent(_loc_10), _loc_11, {key:PlayerEnum.TIPLINK_PAY}, 1000, 0, false);
						}
					}
					else if (this.skinManager.payTxt && this.skinManager.payTxt.txtPayHead)
					{
						if (GlobalVars.pay == 1 && (_loc_4 == "4" || _loc_4 == "5" || _loc_4 == "6") && (_loc_3 == "1" || _loc_3 == "3"))
						{
							this.skinManager.payTxt.txtPayHead.text = ResourceManager.instance.getContent("tipinfo_viphead");
							if (this.skinManager.payTxt.txtPayTail)
							{
								_loc_12 = "tipinfo_buytail";
								_loc_13 = "paybtn_pay";
								_loc_14 = 54;
								_loc_15 = 131;
								if (GlobalVars.typeid != "100")
								{
									if (_loc_3 == "3" && _loc_4 == "4")
									{
										if (_loc_5 != 0)
										{
											_loc_13 = "paybtn_ticket";
										}
										else
										{
											_loc_13 = "paybtn_vip2";
											_loc_12 = "tipinfo_vipticket2";
											_loc_14 = 88;
											_loc_15 = 165;
										}
									}
									else if (_loc_5 != 0)
									{
										_loc_13 = "paybtn_ticket";
									}
									else
									{
										_loc_13 = "paybtn_vip";
										if (_loc_4 == "4")
										{
											_loc_12 = "tipinfo_vipticket2";
										}
										else
										{
											_loc_12 = "tipinfo_viptail2";
										}
										_loc_14 = 88;
										_loc_15 = 165;
									}
								}
								this.skinManager.payTxt.txtPayTail.text = ResourceManager.instance.getContent(_loc_12);
								this.skinManager.payTxt.txtPayTail.x = _loc_15;
								try
								{
									if (this.skinManager.payTxt.btnbuy && this.skinManager.payTxt.btnbuy.txtContent)
									{
										var _loc_16:* = _loc_14;
										this.skinManager.payTxt.btnbuy.btnbg.width = _loc_14;
										this.skinManager.payTxt.btnbuy.txtContent.width = _loc_16;
										this.skinManager.payTxt.btnbuy.txtContent.text = ResourceManager.instance.getContent(_loc_13);
									}
								}
								catch (e:Error)
								{
								}
							}
						}
						else
						{
							this.skinManager.payTxt.txtPayHead.text = ResourceManager.instance.getContent(_loc_9) + _loc_7;
							if (this.skinManager.payTxt.txtPayTail)
							{
								this.skinManager.payTxt.txtPayTail.text = ResourceManager.instance.getContent(_loc_10);
							}
						}
						if (this.skinManager.payTxt.btnlogin && this.skinManager.payTxt.btnbuy)
						{
							if (GlobalVars.pay == 1 && _loc_3 == "0")
							{
								this.skinManager.payTxt.btnlogin.visible = true;
								this.skinManager.payTxt.btnbuy.visible = false;
							}
							else
							{
								this.skinManager.payTxt.btnlogin.visible = false;
								this.skinManager.payTxt.btnbuy.visible = true;
							}
						}
						if (!this.skinManager.payTxt.visible)
						{
							if (GlobalVars.pay == 1)
							{
								TweenLite.from(this.skinManager.payTxt, 3, {alpha:0});
							}
							this.skinManager.payTxt.visible = true;
						}
					}
					if (this.skinManager.vipTxt)
					{
						this.skinManager.vipTxt.visible = false;
					}
				}
				else
				{
					if (this.skinManager.vipTxt && (this.playerWidth >= _loc_1 || this.playerWidth <= 10))
					{
						if (GlobalVars.pay == 1)
						{
							if (_loc_3 == "3" && (_loc_4 == "6" || _loc_4 == "5"))
							{
								this.skinManager.vipTxt.txtInfo.text = ResourceManager.instance.getContent("uinfo_vip");
								if (!this.skinManager.vipTxt.visible)
								{
									TweenLite.from(this.skinManager.vipTxt, 3, {alpha:0});
									this.skinManager.vipTxt.visible = true;
								}
							}
							else
							{
								this.skinManager.vipTxt.visible = false;
							}
						}
						else
						{
							this.skinManager.vipTxt.visible = true;
						}
					}
					if (this.skinManager.payTxt)
					{
						this.skinManager.payTxt.visible = false;
					}
				}
			}
			return;
		}// end function

		//显示大图标
		protected function adjustBigPlayBtn(param1:Boolean = false) : void
		{
			if (this.videoContainer == null)
			{
				return;
			}
			//根据是否全屏设置大播放按键的位置
			if (!this.isFullScreen)
			{
				this.skinManager.adjustBigPlayBtn(this.videoContainer.width, this.videoContainer.height, param1, false);
			}
			else
			{
				this.skinManager.adjustBigPlayBtn(this.videoContainer.width, this.videoContainer.height - this.skinManager.contrlBar.bg_mc.height, param1, false);
			}
			return;
		}// end function
		
		
		
		//状态改变里的一些处理，包括像一些最大化后的一些跳转动作后的画布调整
		protected function statusChangedHandler(event:VideoPlayerEvent) : void
		{
			
			//
			
			//trace()
			//trace(data.code);
			var usedefault:int;
			var reportmodePlay:ReportMode;
			var reportmode:ReportMode;
			var val1:Number;
			var vformat:VideoFormat;
			var format:VideoFormat;
			var str:String;
			var playtime:Number;
			var event:* = event;
			var data:* = event.value;
			//trace(data.code);
			//状态事件，好像也没什么用
			
			trace('****************');
			trace(data.code);
			trace('****************');
			
			switch(data.code)
			{
				case "starttoload":
				{
					
					if (data.first)
					{
						this.rpt_loadtime = getTimer();
						if (this.rpt_outLoadtime == 0)
						{
							this.rpt_outLoadtime = this.rpt_loadtime;
						}
						if (this.videoPlayer.hasEventListener(VideoPlayerEvent.PLAY_NOMAL_ERROR))
						{
							this.videoPlayer.removeEventListener(VideoPlayerEvent.PLAY_NOMAL_ERROR, this.playerError);
						}
						this.playerInitTime();
						this.emptyCount = 0;
						if (this.timer && !this.timer.isRunning())
						{
							this.timer.restart();
						}
						ReportManager.reportStaticPara.bt = this.videoPlayer.getDuration();
						this.createCopystr(this.currentVideoData.arrayVid);
						if (!this.currentVideoData.video_changeformat)
						{
							this.checkPayStatus();
						}
						//ZCadView.instance.checkZcTime();
						
						
						////GlobalVars._vodPlay.onStateChanged("LOADING");
							
						
						dispatchEvent(new OmsPlayerEvent(OmsPlayerEvent.PLAY_STARTLOAD));
						
						
					}
					
					
					
					this.adReadyToPlay = false;
					break;
				}
				case "ready":
				{
					if (data && data.first)
					{
						this.videoPlayer.setVolume(0);
						dispatchEvent(new OmsPlayerEvent(OmsPlayerEvent.PLAY_STARTREADY));
					}
					/*if (this.subtitleView)
					{
						this.subtitleView.stop();
					}*/
					
					////GlobalVars._vodPlay.onStateChanged("NO_PLAYING_BUFFERING");
					
					
					break;
				}
				case "starttoplay":
				{
					
					
					////GlobalVars._vodPlay.onStateChanged('PLAYING');
					
					this.usableScaleFactor = this.currentScaleFactor;
					this.adReadyToPlay = true;
					this.rightCfgShowing = true;
					this.currentVideoData.video_autoseek = false;
					this.currentVideoData.video_forceHttp = false;
					this.skinManager.showMsgTip();
					if (this.timer && !this.timer.isRunning())
					{
						this.timer.restart();
					}
					clearTimeout(this.seekstoptipTimeoutCount);
					this.metadataHandle();
					if (this.shareSeekplay)
					{
						this.showTailMsg = false;
						return;
					}
					if (this.playStatus == PlayerEnum.START_PAUSE && !data.first)
					{
						this.videoPlayer.pause();
						this.playerstatus = PlayerEnum.STATE_PAUSE;
					}
					else
					{
						
						
						this.adjustBigPlayBtn(false);
						this.skinManager.contrlBar.play_btn.state = "play";
						this.playerstatus = PlayerEnum.STATE_PLAYING;
						
						
						
					}
					if (this.videoPlayer.getDuration() == 0)
					{
						this.controlEnabled(true, true, true, false, true, true, true, true);
					}
					else
					{
						this.controlEnabled(true, true, true, true, true, true, true, true);
					}
					//this.removeCoverPage();
					if (this.videoPlayer && this.videoPlayer.getUsingStageVideo())
					{
						this.videoContainer.alpha = 0;
					}
					else
					{
						this.videoContainer.alpha = 1;
					}
					this.showTailMsg = false;
					
					if (data.first)
					{
						this.rpt_starttime = getTimer();
						this.initFormatAndHeadTail();
						if (!this.currentVideoData.video_changeformat)
						{
							//this.startLogoView();
							usedefault = this.videoPlayer.useDefaultUrl() == true ? (2) : (1);
							reportmodePlay = ReportManager.createReportMode(ReportManager.STEP_PLAYCOUNT, this.videoPlayer.getVideoCount(), usedefault, 0, 0, this.videoPlayer.getCurrVid(), this.videoPlayer.getCurrFormat(), this.videoPlayer.getModetype(), this.videoPlayer.getCurrVt(), 0, this.videoPlayer.getCurrLevel(), "", this.videoPlayer.getCurrFormatName(), {usingP2P:this.videoPlayer.getUsingP2P()});
							//reportmodePlay.bi = GlobalVars.adplay ? (2) : (1);
							reportmodePlay.bi = 1; //是否存在广告
							ReportManager.addReport(reportmodePlay, true);
							//每分钟上报一次数据,这里先关掉
							/*
							setTimeout(function ():void
							{
								ReportComscore.comScoreBeancon("", GlobalVars.playerversion.toString(), "", "", "", GlobalVars.playerLocalInfo.guid);
								return;
							}// end function
								, 1000);
							*/
							
							GlobalVars.preformat = this.videoPlayer.getCurrFormat();
							GlobalVars.preformatName = this.videoPlayer.getCurrFormatName();
							ReportManager.heartReportStart(this.videoPlayer.getCurrFormat(), this.videoPlayer.getModetype(), this.videoPlayer.getCurrVt(), GlobalVars.pid);
							
						}
						
						if (!this.currentVideoData.video_changeformat)
						{
							this.checkPlayTimeObj();
							this.initTipTimePanel();
							this.adjustTopPanel();
							//这里好像可以加上监控...先加个注释
							this.startPlayerActivity();
							
							
							reportmode = ReportManager.createReportMode(ReportManager.STEP_PLAYLOADING, this.rpt_starttime - this.rpt_loadtime, this.rpt_adLoaded, 0, 0, this.videoPlayer.getCurrVid(), this.videoPlayer.getCurrFormat(), this.videoPlayer.getModetype(), this.videoPlayer.getCurrVt(), 0, this.videoPlayer.getCurrLevel(), "", this.videoPlayer.getCurrFormatName(), {usingP2P:this.videoPlayer.getUsingP2P()});
							reportmode.bi = this.rpt_adplayend - this.rpt_addownload;
							ReportManager.addReport(reportmode, false);
							val1;
							if (this.rpt_adplayend > 0)
							{
								if (this.videoPlayer.getModeLoadoverTime() > 0)
								{
									val1 = Math.min(this.rpt_adplayend, this.videoPlayer.getModeLoadoverTime()) - this.rpt_outLoadtime;
								}
								else
								{
									val1 = this.rpt_adplayend - this.rpt_outLoadtime;
								}
								if (val1 < 0)
								{
									val1;
								}
							}
							//reportmode = ReportManager.createReportMode(ReportManager.STEP_USER_FIRST, this.rpt_adplayend == 0 ? (this.rpt_starttime - this.rpt_loadtime) : (this.rpt_starttime - this.rpt_adplayend), val1, this.adPlayer ? (this.adPlayer.adDura) : (0), 0, this.videoPlayer.getCurrVid(), this.videoPlayer.getCurrFormat(), this.videoPlayer.getModetype(), this.videoPlayer.getCurrVt(), 1, this.videoPlayer.getCurrLevel(), "", this.videoPlayer.getCurrFormatName(), {usingP2P:this.videoPlayer.getUsingP2P()});
							reportmode = ReportManager.createReportMode(ReportManager.STEP_USER_FIRST, this.rpt_adplayend == 0 ? (this.rpt_starttime - this.rpt_loadtime) : (this.rpt_starttime - this.rpt_adplayend), val1, (0), 0, this.videoPlayer.getCurrVid(), this.videoPlayer.getCurrFormat(), this.videoPlayer.getModetype(), this.videoPlayer.getCurrVt(), 1, this.videoPlayer.getCurrLevel(), "", this.videoPlayer.getCurrFormatName(), {usingP2P:this.videoPlayer.getUsingP2P()});
							reportmode.bi = this.videoPlayer.getModeRequestTimeCount();
							reportmode.bt = this.videoPlayer.getDuration();
							reportmode.rid = this.videoPlayer.getModeRid();
							reportmode.vurl = this.videoPlayer.getCurrVurl();
							ReportManager.addReport(reportmode, true);
						}
						this.skinManager.contrlBar.play_btn.state = "play";
						this.showCtrlBar();
						this.showNormalSeekBar(true);
						this.enableMenu(true);
						this.ignoreSpace = false;
						this.videoPlayer.setVolume(GlobalVars.playerLocalInfo.volume);
						this.playStatus = PlayerEnum.START_PLAY;
					}
					this.mousecheck = true;
					if (data.first)
					{
						this.mouseMoveCheck(null);
					}
					
					dispatchEvent(new OmsPlayerEvent(OmsPlayerEvent.PLAY_STARTPLAY, {code:"startToPlay", first:data.first, changeformat:this.currentVideoData.video_changeformat}));
					break;
				}
				case "getmetadata":
				{
					////GlobalVars._vodPlay.onStateChanged("NO_PLAYING_BUFFERING");
					this.metadataHandle();
					break;
				}
				case "error":
				case "refesh":
				{
					////GlobalVars._vodPlay.onStateChanged('CONNECTION_ERROR');
					
					if (this.timer && this.timer.isRunning())
					{
						this.timer.stop();
					}
					this.showRightCfg(false);
					clearTimeout(this.seekstoptipTimeoutCount);
					this.closePopupBut(null);
					this.showErrorTip();
					this.enableMenu(false);
					this.showNormalSeekBar(true, false);
					this.skinManager.contrlBar.play_btn.state = "pause";
					this.controlEnabled(false, false, true, false, true, false, false, false);
					this.skinManager.setDefinitionBtnEnable(false);
					AS3Debugger.Trace("BasePlayerV3::error");
					if (GlobalVars.isPayedVideo && data.em && (data.em == 63 || data.em == 65 || data.em == 83))
					{
						this.playCompleteHandler();
						this.unpayHandler();
					}
					dispatchEvent(new OmsPlayerEvent(OmsPlayerEvent.PLAY_ERROR));
					break;
				}
				case "playComplete":
				{
					////GlobalVars._vodPlay.onStateChanged("NO_PLAYING_BUFFERING");
					this.playCompleteHandler();
					if (GlobalVars.isPreviewVideo)
					{
						this.unpayHandler();
						return;
					}
					dispatchEvent(new OmsPlayerEvent(OmsPlayerEvent.PLAY_STOP));
				}
				case "empty":
				{
					
					//播放缓冲。需要发个消息
					//GlobalVars._vodPlay.onStateChanged('BUFFERING');
					
					this.bufferingCount = 0;
					this.lastBufferPer = 0;
					this.rpt_emptytime = getTimer();
					if (this.emptyCount == 1 && GlobalVars.playerLocalInfo.format == PlayerEnum.FORMAT_AUTO)
					{
						if (FormatUtil.hasMutiFormat(this.currentVideoData))
						{
							vformat = FormatUtil.getVideoFormatByName(this.currentVideoData.video_fmtlist, this.videoPlayer.getCurrFormatName());
							if (vformat && FormatUtil.checkLessDefinitionByFormat(this.currentVideoData.video_fmtlist, vformat))
							{
								format = FormatUtil.getLessDefinitionByFormat(this.currentVideoData.video_fmtlist, vformat);
								GlobalVars.preformat = this.videoPlayer.getCurrFormat();
								GlobalVars.preformatName = this.videoPlayer.getCurrFormatName();
								this.currentVideoData.playformat = format.name;
								str = ResourceManager.instance.getContent("tipinfo_buffer");
								this.showMsgTip(str);
								
								playtime = this.videoPlayer.getPlayTime();
								this.playtimeObj = PlayTimeUtil.changeFormatPlaytime(this.playtimeObj, playtime);
								this.currentVideoData.playtimeInfo = this.playtimeObj;
								this.currentVideoData.video_changeformat = true;
								this.startToLoad();
								AS3Debugger.Trace("切换清晰度：time=" + playtime);
							}
						}
					}
					break;
				}
				case "full":
				{
					////GlobalVars._vodPlay.onStateChanged("NO_PLAYING_BUFFERING");
					this.bufferingCount = 0;
					this.lastBufferPer = 0;
					
					this.emptyCount = this.emptyCount + 1;
					this.skinManager.showMsgTip();
					break;
				}
				case "changesplit":
				{
					if (data.msg == "ready")
					{
						this.skinManager.showMsgTip();
					}
					else
					{
						this.skinManager.showMsgTip(ResourceManager.instance.getContent("tipinfo_buffer"));
						trace('xxxxxxxx');
						this.playerstatus = PlayerEnum.STATE_REQUESTING;
					}
					
					break;
				}
				case "changp2p":
				{
					var _loc_3:* = PlayTimeUtil.changeFormatPlaytime(this.playtimeObj, this.videoPlayer.getPlayTime());
					this.playtimeObj = PlayTimeUtil.changeFormatPlaytime(this.playtimeObj, this.videoPlayer.getPlayTime());
					this.currentVideoData.playtimeInfo = _loc_3;
					this.currentVideoData.video_forceHttp = true;
					this.startToLoad();
					break;
				}
				case "seekstop":
				{
					trace('***************');
					////GlobalVars._vodPlay.onStateChanged("NO_PLAYING_BUFFERING");
					/*if (this.shareInsideShowing)
					{
						if (!this.shareSeekplay)
						{
							if (data.msg == "seeked")
							{
								clearTimeout(this.sharepicSeekTimecount);
								this.sharepicSeekTimecount = setTimeout(function ():void
								{
									videoPlayer.pause();
									return;
								}// end function
									, 50);
							}
						}
						return;
					}*/
					if (data.msg == "seeked")
					{
						this.playerstatus = PlayerEnum.STATE_PLAYING;
						this.skinManager.showMsgTip();
						if (this.timer && !this.timer.isRunning())
						{
							this.timer.restart();
						}
					}
					else if (data.msg == "load")
					{
						clearTimeout(this.seekstoptipTimeoutCount);
						this.seekstoptipTimeoutCount = setTimeout(function ():void
						{
							skinManager.showMsgTip(ResourceManager.instance.getContent("tipinfo_buffer"));
							return;
						}// end function
							, 500);
						this.playerstatus = PlayerEnum.STATE_SEEKED;
						trace('中断点2');//跳到还未加载的地方，同时视频会暂停
					}
					this.playStatus = PlayerEnum.START_PLAY;
					
					this.adjustBigPlayBtn(false);
					if (this.playerActivity)
					{
						this.playerActivity.resumeTimer();
					}
					try
					{
						this.skinManager.contrlBar.play_btn.state = "play";
					}
					catch (e:Error)
					{
					}
					dispatchEvent(new OmsPlayerEvent(OmsPlayerEvent.PLAY_SEEKSTOP, {msg:data.msg}));
					break;
				}
				case "couldnowatch":
				{
					if (this.timer && this.timer.isRunning())
					{
						this.timer.stop();
					}
					this.showRightCfg(false);
					clearTimeout(this.seekstoptipTimeoutCount);
					this.closePopupBut(null);
					this.enableMenu(false);
					this.showNormalSeekBar(true, false);
					this.skinManager.contrlBar.play_btn.state = "pause";
					this.controlEnabled(false, false, true, false, true, false, false, false);
					this.skinManager.setDefinitionBtnEnable(false);
					this.playerstatus = PlayerEnum.STATE_STOP;
					if (GlobalVars.isPayedVideo && data.em && (data.em == 63 || data.em == 65 || data.em == 83))
					{
						this.playCompleteHandler();
						this.unpayHandler();
						return;
					}
					if (data.em && data.em == 64)
					{
						this.showErrorTip();
					}
					else
					{
						this.skinManager.showMsgTip(ResourceManager.instance.getContent("tipinfo_forbid"));
					}
					dispatchEvent(new OmsPlayerEvent(OmsPlayerEvent.PLAY_ERROR));
					break;
				}
				case "rangestop":
				{
					if (this.shareInsideShowing)
					{
						return;
					}
					if (this.playtimeObj)
					{
						if (this.playtimeObj.endtype == PlayTime.TYPE_ATTRACTION_END)
						{
							this.attractionStop = false;
							this.videoPlayer.stop();
							this.playCompleteHandler();
							dispatchEvent(new OmsPlayerEvent(OmsPlayerEvent.PLAY_ATTSTOP));
						}
						else if (this.playtimeObj.endtype == PlayTime.TYPE_TAIL && this.useMovieHeadTail)
						{
							this.videoPlayer.stop();
							this.playCompleteHandler();
							dispatchEvent(new OmsPlayerEvent(OmsPlayerEvent.PLAY_STOP));
						}
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
		
		
		//移除某些 面板
		protected function removePanel(param1:*) : void
		{
			if (!param1 || !contains(param1))
			{
				return;
			}
			removeChild(param1);
			return;
		}// end function

		
		//显示消息
		protected function showMsgTip(param1:String) : void
		{
			this.skinManager.showMsgTip(param1);
			return;
		}// end function
		
		//称除播放器内部的分享
		private function removeShareinside() : void
		{
			this.videoPlayer.visible = true;
			this.shareInsideShowing = false;
			clearTimeout(this.sharepicSeekTimecount);
			this.setChildIndex(this.videoPlayer, (this.getChildIndex(this.videoContainer) + 1));
			
			this.videoPlayer.mouseEnabled = true;
			this.adjustPlayer(this.videoWidth, this.videoHeight);
			return;
		}// end function
		
		//关闭弹出的窗口
		protected function closePopupBut(param1:*) : void
		{
			if (param1 == this.skinManager.infoPanel)
			{
				this.removePanel(this.skinManager.sharePanel);
				this.addPanel(this.skinManager.infoPanel);
				this.removeShareinside();
			}
			else if (param1 == this.skinManager.sharePanel)
			{
				this.removePanel(this.skinManager.infoPanel);
				this.addPanel(this.skinManager.sharePanel);
				this.removeShareinside();
			}
			else if (param1 == this.skinManager.shareInside)
			{
				this.removePanel(this.skinManager.infoPanel);
				this.removePanel(this.skinManager.sharePanel);
				this.addShareinside();
			}
			else
			{
				this.removePanel(this.skinManager.infoPanel);
				this.removePanel(this.skinManager.sharePanel);
				this.removeShareinside();
			}
			return;
		}// end function
		
		//mouse在窗口里的时候，有些东西都显示出来
		protected function mouseMoveCheck(event:MouseEvent) : void
		{
			
			if (this.mouseLeave)
			{
				this.mouseLeave = false;
			}
			Mouse.show();
			if (!this.mousecheck)
			{
				return;
			}
			this.showCtrlBar(true);
			if (this.rightCfgShowing)
			{
				this.showRightCfg(true);
			}
			
			this.showTopPanel(true);
			this.showNormalSeekBar(true);
			this.showSearchBar();
			
			return;
		}// end function
		
		
		//显示搜索窗口.这里我们暂时不需要,可以考虑改成某类提示信息
		protected function showSearchBar(param1:Boolean = true, param2:Boolean = false):void
		{
			if (!this.skinManager.searchBar || this.skinManager.searchBar.parent != this || this.isFullScreen || !GlobalVars.showSearchPanel)
			{
				return;
			}
			if (!this.skinManager.searchBar.visible)
			{
				this.skinManager.searchBar.visible = true;
			}
			if (param1 || param2)
			{
				TweenLite.to(this.skinManager.searchBar, 0.2, {y:0});
			}
			else
			{
				TweenLite.to(this.skinManager.searchBar, 0.2, {y:-this.skinManager.searchBar.height});
			}
			return;
		}// end function
		
		
		//显示顶部面板
		protected function showTopPanel(param1:Boolean) : void
		{
			var show:* = param1;
			if (!this.skinManager.topPanel || this.skinManager.topPanel.parent != this)
			{
				return;
			}
			if (show)
			{
				clearTimeout(this.toppanelTimeoutCount);
				TweenLite.to(this.skinManager.topPanel, this.panelMovetime, {y:0});
				this.toppanelTimeoutCount = setTimeout(function ():void
				{
					TweenLite.to(skinManager.topPanel, panelMovetime, {y:-skinManager.topPanel.height});
					return;
				}// end function
					, 5000);
			}
			else
			{
				clearTimeout(this.toppanelTimeoutCount);
				TweenLite.to(this.skinManager.topPanel, this.panelMovetime, {y:-this.skinManager.topPanel.height});
			}
			return;
		}// end function
		
		
		
		//显示正常进度条
		protected function showNormalSeekBar(param1:Boolean, param2:Boolean = true) : void
		{
			var show:* = param1;
			var timout:* = param2;
			if (!this.skinManager.miniSeekbar)
			{
				return;
			}
			clearTimeout(this.minibarTimeoutCount);
			if (show)
			{
				this.skinManager.gotoNormalSeekbarMode();
				if (timout)
				{
					this.minibarTimeoutCount = setTimeout(function ():void
					{
						skinManager.gotoMiniSeekbarMode();
						return;
					}// end function
						, 5000);
				}
			}
			else
			{
				this.skinManager.gotoMiniSeekbarMode();
			}
			return;
		}// end function
		
		//显示ctrl控制条,具体还不知道.
		protected function showCtrlBar(param1:Boolean = true, param2:Boolean = true) : void
		{
			clearTimeout(this.showctrlTimeout);
			if (!this.skinManager.contrlBar)
			{
				return;
			}
			if (!this.isFullScreen)
			{
				this.skinManager.contrlBar.y = this.playerHeight - this.skinManager.contrlBar.bg_mc.height;
				this.skinManager.contrlBar.alpha = 1;
				return;
			}
			var _loc_3:* = GlobalVars.showbarFullscreen ? (this.playerHeight - 2) : (this.playerHeight);
			if (param1)
			{
				if (param2)
				{
					if (!this.showContrlbar)
					{
						TweenLite.to(this.skinManager.contrlBar, this.panelMovetime, {y:this.playerHeight - this.skinManager.contrlBar.bg_mc.height, alpha:1, onUpdate:this.onCtrlMoveUpate});
					}
					this.showctrlTimeout = setTimeout(this.hideCtlbar, this.showctrlTime);
				}
				else
				{
					this.skinManager.contrlBar.y = this.playerHeight - this.skinManager.contrlBar.bg_mc.height;
				}
				this.showContrlbar = true;
			}
			else
			{
				if (param2)
				{
					if (this.showContrlbar)
					{
						TweenLite.to(this.skinManager.contrlBar, this.panelMovetime, {y:_loc_3, alpha:0.5, onUpdate:this.onCtrlMoveUpate});
					}
				}
				else
				{
					this.skinManager.contrlBar.y = _loc_3;
				}
				this.showContrlbar = false;
			}
			this.showNormalSeekBar(param1);
			return;
		}// end function
		
		
		
		
		//隐藏CRLBAR,具体是哪个也还不知道
		private function hideCtlbar() : void
		{
			var _loc_1:Number = NaN;
			if (this.playerstatus == PlayerEnum.STATE_PLAYING)
			{
				if (this.mouseLeave || !this.skinManager.contrlBar.hitTestPoint(this.mouseX, this.mouseY, true))
				{
					Mouse.hide();
					_loc_1 = GlobalVars.showbarFullscreen ? (this.playerHeight - 2) : (this.playerHeight);
					TweenLite.to(this.skinManager.contrlBar, this.panelMovetime, {y:_loc_1, alpha:0.5, onUpdate:this.onCtrlMoveUpate});
					this.showContrlbar = false;
				}
			}
			return;
		}// end function

		
		//某个按键的特别显示
		private function onCtrlMoveUpate() : void
		{
			
			return;
		}// end function
		
		//内部分享按键.。这是一个超级麻烦的东西，其实没有必要这么麻烦，好些地方是用不到的。直接干掉好。。这块儿先不作等后面再改，有些麻烦了。
		//先来试着调整其它的东西看看
		private function addShareinside() : void
		{
			trace('开启内部分享');
			var _loc_2:Number = NaN;
			if (!this.skinManager.shareInside || !this.currentVideoData || !this.videoPlayer)
			{
				return;
			}
			if (this.isFullScreen)
			{
				this.btnNormal();
			}
			this.btnPause(null, false);
		
			
			var _loc_1:Number = 400;
			if (this.skinManager.btnShareplay)
			{
				this.skinManager.btnShareplay.btnplay.visible = true;
				this.skinManager.btnShareplay.btnpause.visible = false;
			}
			
			this.videoPlayer.visible = false;
			this.shareInsideShowing = true;
			
			this.videoPlayer.mouseEnabled = false;
			
			return;
		}// end function
		
		
		
		
		
		protected function naviToUrl(param1:URLRequest, param2:String = null):void
		{
			var request:* = param1;
			var window:* = param2;
			try
			{
				if (request)
				{
					navigateToURL(request, window);
				}
			}
			catch (e:Error)
			{
				showErrorPanel(true, 3);
			}
			if (this.isFullScreen)
			{
				this.btnNormal();
			}
			return;
		}// end function

		
		
		private function sharecopy(param1:Object) : void
		{
			try
			{
				switch(param1.value)
				{
					case "copyswf":
					{
						System.setClipboard(this.copySwf);
						break;
					}
					case "copyhtml":
					{
						System.setClipboard(this.copyHtml);
						break;
					}
					case "copypage":
					{
						System.setClipboard(this.copyPage);
						break;
					}
					default:
					{
						break;
					}
				}
			}
			catch (e:Error)
			{
			}
			return;
		}// end function
		
	
		
		//跳转到某个地方并停止,这里的作用还不一定有作用,跳转完成，后面会到哪里呢？
		protected function seekStopHandler(param1:Number) : void
		{
			
			//这个动作里面可能有问题。。
			this.videoPlayer.seekstop(param1);
			
			return;
		}// end function
		
		
		//分享面板的操作吧,好像是这样
		private function addSharelay(param1:Boolean) : void
		{
			if (this.skinManager.btnShareplay)
			{
				if (param1)
				{
					//this.skinManager.btnShareplay.x = this.skinManager.shareInside.x + this.sharepic.videox;
					//this.skinManager.btnShareplay.y = this.skinManager.shareInside.y + this.sharepic.videoy - 20;
					if (this.skinManager.btnShareplay.parent != this)
					{
						this.addChild(this.skinManager.btnShareplay as DisplayObject);
					}
					if (!this.skinManager.btnShareplay.btnplay.hasEventListener(MouseEvent.CLICK))
					{
						//this.skinManager.btnShareplay.btnplay.addEventListener(MouseEvent.CLICK, this.sharePlay);
						this.skinManager.btnShareplay.btnpause.addEventListener(MouseEvent.CLICK, this.sharePause);
					}
				}
				else
				{
					
					trace(this.skinManager.btnShareplay.parent);
					
					if (this.skinManager.btnShareplay.parent == this)
					{
						this.removeChild(this.skinManager.btnShareplay as DisplayObject);
					}
					
					if (this.skinManager.btnShareplay.btnplay.hasEventListener(MouseEvent.CLICK))
					{
						//this.skinManager.btnShareplay.btnplay.removeEventListener(MouseEvent.CLICK, this.sharePlay);
						this.skinManager.btnShareplay.btnpause.removeEventListener(MouseEvent.CLICK, this.sharePause);
					}
				}
			}
			return;
		}// end function*/
		
		
		//分析暂停,,具体懒得分析
		private function sharePause(event:Event) : void
		{
			this.skinManager.btnShareplay.btnplay.visible = true;
			this.skinManager.btnShareplay.btnpause.visible = false;
			//this.seekstartSharepic(null);
			return;
		}// end function
		
		
		
		
		
		
		//正常显示
		protected function btnNormal(event:Event = null) : void
		{
			this.screenfull = false;
			this.showCtrlBar(true, false);
			return;
		}// end function

		
		
		//暂停播放
		protected function btnPause(event:Event = null, param2:Boolean = true, param3:Boolean = true) : void
		{
			//这里加上暂停广告等的动作试下
			
			if (this.videoPlayer)
			{
				this.videoPlayer.pause();
				if (this.playerActivity)
				{
					this.playerActivity.pauseTimer();
				}
				this.showCtrlBar();
				this.playerstatus = PlayerEnum.STATE_PAUSE;
				this.playStatus = PlayerEnum.START_PAUSE;
				try
				{
					if (this.skinManager.playerSkin.skin.controlBar_mc.play_btn.state == "play")
					{
						this.skinManager.playerSkin.skin.controlBar_mc.play_btn.state = "pause";
					}
					this.adjustBigPlayBtn(param3);
				}
				catch (e:Error)
				{
				}
				if (param2)
				{
					dispatchEvent(new OmsPlayerEvent(OmsPlayerEvent.PLAY_PAUSE));
				}
				if (event)
				{
					//WebReportMananger.addReport({itype:WebReportPlayerClick.ITYPE_BTNPAUSE},true,true);
				}
			}
			return;
		}// end function
		
		
		
		//全屏东西
		protected function set screenfull(param1:Boolean) : void
		{
			
			//设置全屏动作
			var value:* = param1;
			//特定版本不支持
			
			
			this.isFullScreen = value;
			if (value)
			{
				trace('设置全屏');
				try
				{
					if (this.skinManager.contrlBar.full_btn)
					{
						this.skinManager.contrlBar.full_btn.state = "full";
					}
					
					
					stage.displayState = StageDisplayState.FULL_SCREEN;
					
					if (this.skinManager.searchBar && this.skinManager.searchBar.visible)
					{
						this.skinManager.searchBar.visible = false;
					}
				}
				catch (e:Error)
				{
					isFullScreen = false;
					showErrorPanel(true, 2);
					if (skinManager.contrlBar.full_btn)
					{
						skinManager.contrlBar.full_btn.state = "normal";
					}
				}
				this.mouseMoveCheck(null);
			}
			else
			{
				trace('设置非全屏');
				try
				{
					stage.displayState = StageDisplayState.NORMAL;
					if (this.skinManager.contrlBar.full_btn)
					{
						this.skinManager.contrlBar.full_btn.state = "normal";
					}
					if (this.videoPlayer.getPlayerState() == PlayerEnum.STATE_STOP)
					{
						if (this.skinManager.searchBar)
						{
							this.skinManager.searchBar.visible = true;
							this.skinManager.searchBar.y = 0;
							this.skinManager.searchBar.x = 0;
						}
					}
				}
				catch (e:Error)
				{
				}
			}
			this.adjustTopPanel();
			this.adjustRightCfg();
			
			if (GlobalVars.playerversion == PlayerEnum.TYPE_OUTSIDE || GlobalVars.playerversion == PlayerEnum.TYPE_NORMAL)
			{
				try
				{
					if (this.isFullScreen)
					{
						stage.frameRate = 42;
					}
					else
					{
						stage.frameRate = 36;
					}
				}
				catch (e:Error)
				{
				}
			}
			return;
		}// end function
		
		//跳转码特定播放页面,即不支持全屏的情况下..
		protected function jumpToPlayPage() : void
		{
			var _loc_1:String = null;
			if (!this.currentVideoData || !this.currentVideoData.arrayVid || this.currentVideoData.arrayVid.length == 0)
			{
				return;
			}
			if (this.currentVideoData.arrayVid && this.currentVideoData.arrayVid.length > 0)
			{
				if (this.playerstatus == PlayerEnum.STATE_PLAYING)
				{
					this.btnPause();
				}
				_loc_1 = this.currentVideoData.arrayVid[0];
				try
				{
					navigateToURL(new URLRequest(PlayerUtils.getPlayPage(_loc_1)), "_blank");
				}
				catch (e:Error)
				{
				}
			}
			return;
		}// end function
		
		
		
		//显示错误信息页面,主要是调用msg面板
		protected function showErrorPanel(param1:Boolean, param2:int = 3) : void
		{
			if (this.skinManager.msgPanel)
			{
				if (param1)
				{
					this.skinManager.msgPanel.update(param2);
					this.addPanel(this.skinManager.msgPanel);
				}
				else
				{
					this.removePanel(this.skinManager.msgPanel);
				}
			}
			return;
		}// end function
		
		
		//右侧的一些控制窗口,是否显示等
		protected function adjustRightCfg() : void
		{
			if (GlobalVars.showRightPanel && this.skinManager.rightCfgMsg)
			{
				if (!this.isFullScreen)
				{
					this.skinManager.rightCfgMsg.y = 26;
					this.skinManager.rightCfgMsg.x = this.videoWidth - this.skinManager.rightCfgMsg.width - 12;
					if (this.skinManager.rightCfgMsg.parent != this)
					{
						this.addChildAt(this.skinManager.rightCfgMsg  as DisplayObject, this.getChildIndex(this.skinManager.bigPlayBtn  as DisplayObject));
					}
				}
				else if (this.skinManager.rightCfgMsg.parent == this)
				{
					this.removeChild(this.skinManager.rightCfgMsg  as DisplayObject);
				}
			}
			return;
		}// end function
		
		//改变窗口大小的动作.
		protected function adjustVideoPlayer(param1:Number, param2:Number, param3:Boolean = false, param4:int = -1) : void
		{
			
			if (this.videoPlayer)
			{
				
				if (!this.isFullScreen)
				{
					this.currSizeFactor = 100;
				}else{
					
					if (this.videosizeFactor < 50)
					{
						this.currSizeFactor = 50;
					}
					else if (this.videosizeFactor > 100)
					{
						this.currSizeFactor = 100;
					}
					
				}
				
				param1 = param1 * this.currSizeFactor / 100;
				param2 = param2 * this.currSizeFactor / 100;
				
				
				this.sizefactor = (param4!=-1)?param4:this.currentScaleFactor;
				
				
				this.videoPlayer.resize(param1, param2, this.sizefactor, param3);
				
				if (!param3)
				{
					this.videoPlayer.x = (this.videoWidth - this.videoPlayer.getVideoWidth()) / 2;
					this.videoPlayer.y = (this.videoHeight - this.videoPlayer.getVideoHeight()) / 2;
					if (this.videoPlayer.getUsingStageVideo())
					{
						this.videoPlayer.resize(param1, param2, this.sizefactor, param3);
						
						//this.videoPlayer.resize(400, 300, this.sizefactor, param3);
					}
					try
					{
						TweenLite.killTweensOf(this.videoPlayer);
					}
					catch (e:Error)
					{
					}
				}
				else
				{
					//这里可能有问题，先不解决
					var xx:* = (this.videoWidth - this.videoPlayer.getVideoWidth()) / 2;
					var yy:* = (this.videoHeight - this.videoPlayer.getVideoHeight()) / 2;
					//相当于隔0.4稍videoplayer的显示尺寸变小
					TweenLite.to(this.videoPlayer, 0.4, {x:xx, y:yy});
				}
				
				
			}
			
			return;
		}// end function
		
		
		//这个是不是有用还不知道,测试一下先,好像是播放窗体的概念,这里先不去理论他,继续注释其它代码
		private function startPlayerActivity() : void
		{
			var _loc_1:String = null;//激活播放,有用.
			if (!PlayerUtils.indexHomePages(GlobalVars.usingHost))
			{
				return;
			}
			if (!this.currentVideoData.video_changeformat)
			{
				if (!this.playerActivity)
				{
					this.playerActivity = new PlayerActivity(GlobalVars.objIdAllowed);
					this.playerActivity.addEventListener("show_activity", this.playerActivityCreated);
					this.playerActivity.addEventListener("hide_activity", this.closePlayerActivity);
					this.playerActivity.addEventListener("click_activity", this.clickPlayerActivity);
					this.playerActivity.addEventListener("close_activity", this.closePlayerActivity);
				}
				_loc_1 = "";
				if (this.currentVideoData && this.currentVideoData.arrayVid && this.currentVideoData.arrayVid.length > 0)
				{
					_loc_1 = this.currentVideoData.arrayVid[0];
				}
				this.playerActivity.create(GlobalVars.coverid, _loc_1);
			}
			return;
		}// end function
		
		private function playerActivityCreated(event:PlayerActivityEvent) : void
		{
			if (this.playerActivity && this.playerActivity.parent != this)
			{
				this.addChild(this.playerActivity);
			}
			return;
		}// end function
		
		private function closePlayerActivity(event:PlayerActivityEvent) : void
		{
			if (this.playerActivity && this.playerActivity.parent == this)
			{
				this.removeChild(this.playerActivity);
			}
			return;
		}// end function
		
		private function clickPlayerActivity(event:PlayerActivityEvent) : void
		{
			if (event.value && event.value.link)
			{
				if (this.playerstatus == PlayerEnum.STATE_PLAYING)
				{
					this.btnPause();
				}
			}
			if (this.playerActivity && this.playerActivity.parent == this)
			{
				this.removeChild(this.playerActivity);
			}
			return;
		}// end function
		
		
		//设置顶部面板
		protected function adjustTopPanel() : void
		{
			if (this.skinManager.topPanel)
			{
				if (this.isFullScreen && this.videoPlayer.getPlayerState() != PlayerEnum.STATE_STOP)
				{
					if (this.playerWidth > 600)
					{
						
						this.skinManager.topPanel.title = GlobalVars.flvtitle;
						this.skinManager.topPanel.setWidth(this.playerWidth);
						this.skinManager.topPanel.startCountTime();
						this.skinManager.topPanel.x = 0;
						this.skinManager.topPanel.y = 0;
						if (this.skinManager.topPanel.parent != this)
						{
							this.addChildAt(this.skinManager.topPanel as DisplayObject, this.getChildIndex(this.skinManager.bigPlayBtn  as DisplayObject));
						}
						this.showTopPanel(true);
					}
				}
				else if (this.skinManager.topPanel.parent == this)
				{
					this.skinManager.topPanel.stopCountTime();
					this.removeChild(this.skinManager.topPanel as DisplayObject);
				}
			}
			return;
		}// end function
		
		//初始化时间面板。好像是时间进度条上的图片相关，具体的这里暂时好像不能调用。。后面再看下。先搞定暂停的东西及结束后的东西
		private function initTipTimePanel() : void
		{
			
			return;
		}// end function
		
		//检测播放时间对象
		private function checkPlayTimeObj() : void
		{
			if (GlobalVars.isPayedVideo)
			{
				return;
			}
			if (this.playtimeObj && this.playtimeObj.starttime >= 0 && this.videoPlayer.ranSeekAbled)
			{
				if (this.playtimeObj.starttype == PlayTime.TYPE_HISTORY)
				{
					if (this.moStart >= 0 && this.moEnd > this.moStart && this.moEnd - this.moStart < this.currentVideoData.video_duration - 2)
					{
						if (this.skinManager.contrlBar.seekBar && this.playtimeObj && this.playtimeObj.headstarttime >= 0 && this.playtimeObj.headstarttime < this.playtimeObj.endtime)
						{
							this.skinManager.contrlBar.seekBar.showAttractionPoint(this.playtimeObj.headstarttime / this.videoPlayer.getDuration(), this.playtimeObj.endtime / this.videoPlayer.getDuration());
						}
					}
					return;
				}
				else if (this.playtimeObj.starttype == PlayTime.TYPE_HEAD && this.useMovieHeadTail && GlobalVars.showCfg && this.skinManager.cfgPanel)
				{
					if (this.moStart >= 0 && this.moEnd > this.moStart && this.moEnd - this.moStart < this.currentVideoData.video_duration - 2 && !this.tipHisShowing)
					{
						this.showCheckPlay(ResourceManager.instance.getContent("tipinfo_head"), ResourceManager.instance.getContent("tiptxt_cfg"), {key:PlayerEnum.TIPLINK_HEADTAIL}, 0, 6000);
						if (this.skinManager.contrlBar.seekBar && this.playtimeObj && this.playtimeObj.headstarttime >= 0 && this.playtimeObj.headstarttime < this.playtimeObj.endtime)
						{
							this.skinManager.contrlBar.seekBar.showAttractionPoint(this.playtimeObj.headstarttime / this.videoPlayer.getDuration(), this.playtimeObj.endtime / this.videoPlayer.getDuration());
						}
					}
				}
				else if (this.playtimeObj.starttype == PlayTime.TYPE_ATTRACTION_START)
				{
					this.attractionStop = true;
					this.startPoint = this.playtimeObj.attstarttime / this.videoPlayer.getDuration();
					this.endPoint = this.playtimeObj.endtime / this.videoPlayer.getDuration();
				}
				else
				{
					this.showTipad();
				}
				if (this.playtimeObj.endtime > 0 && this.playtimeObj.endtime < this.videoPlayer.getDuration() && this.playtimeObj.endtype == PlayTime.TYPE_TAIL)
				{
					this.showTailMsg = true;
				}
			}
			else
			{
				this.showTipad();
			}
			try
			{
				if (this.skinManager.payTxt)
				{
					this.skinManager.payTxt.visible = false;
				}
				if (this.skinManager.vipTxt)
				{
					this.skinManager.vipTxt.visible = false;
				}
			}
			catch (e:Error)
			{
			}
			return;
		}// end function

		
		
		
		//好像是右下角的广告,这里测试显示看下效果,也好像不是..具体还未知,后面再看
		private function showTipad() : void
		{
			
			return;
		}// end function
		
		
		//播放器右上角LOGO.
		private function startLogoView() : void
		{
			if (!this.videoPlayer || !GlobalVars.useVideoLogo)
			{
				return;
			}
			
			return;
		}// end function
		
		//窗口单击事件
		private function videoClickHandler(event:Event) : void
		{
			if (this.endViewShowing)
			{
				return;
			}
			
			this.mouseMoveCheck(null);
			if (this.playerstatus == PlayerEnum.STATE_PLAYING)
			{
				this.btnPause(null);
			}
			else if (this.playerstatus == PlayerEnum.STATE_PAUSE)
			{
				this.btnPlay(null);
			}
			return;
		}// end function
		
		//播放动作
		protected function btnPlay(event:Event = null) : void
		{
			
			
			try
			{
				this.adjustBigPlayBtn(false);
				this.skinManager.playerSkin.skin.controlBar_mc.play_btn.visible = true;
			}
			catch (e:Error)
			{
			}
			this.playStatus = PlayerEnum.START_PLAY;
			if (this.videoPlayer)
			{
				if (this.playerstatus == PlayerEnum.STATE_PAUSE)
				{
					try
					{
						if (this.skinManager.playerSkin.skin.controlBar_mc.play_btn.state == "pause")
						{
							this.skinManager.playerSkin.skin.controlBar_mc.play_btn.state = "play";
						}
					}
					catch (e:Error)
					{
					}
					if (this.playerActivity)
					{
						this.playerActivity.resumeTimer();
					}
					if (this.timer && !this.timer.isRunning())
					{
						this.timer.restart();
					}
					this.videoPlayer.setVolume(GlobalVars.playerLocalInfo.volume);
					this.showCtrlBar(false, true);
					this.videoPlayer.resume();
					this.playerstatus = PlayerEnum.STATE_PLAYING;
					this.controlEnabled(true, true, true, true, true, true, true, true);
					this.skinManager.setDefinitionBtnEnable(GlobalVars.showformat);
					this.adjustPayPanel(false);
					dispatchEvent(new OmsPlayerEvent(OmsPlayerEvent.PLAY_STARTPLAY, {code:"resume"}));
				}
				else
				{
					if (this.skinManager.btnReplay)
					{
						this.skinManager.btnReplay.visible = false;
					}
					this.controlEnabled(false, false, true, false, true, false, false, false);
					this.showCtrlBar(true, false);
					this.skinManager.setDefinitionBtnEnable(false);
					dispatchEvent(new OmsPlayerEvent(OmsPlayerEvent.PLAY_CHANGE));
				}
			}
			return;
		}// end function
		
		//快进快退动作
		protected function keyStepHandler(param1:Boolean) : void
		{
			
			trace('快进');
			
			var _loc_2:Number = NaN;
			var _loc_3:Number = NaN;
			var _loc_4:Number = NaN;
			if (this.ignoreSeekboard)
			{
				return;
			}
			trace('--------快进检测的状态，根据状态反查定位------------');
			trace(this.playerstatus);
			
			trace(PlayerEnum.STATE_PLAYING);
			trace(PlayerEnum.STATE_PAUSE);
			
			trace('--------快进检测的状态，根据状态反查定位------------');
			
			
			//点击快进时有个状态位没有设置导致出了问题
			if (this.playerstatus == PlayerEnum.STATE_PLAYING || this.playerstatus == PlayerEnum.STATE_PAUSE)
			{
				
				
				if (this.videoPlayer.ranSeekAbled)
				{
					_loc_2 = this.videoPlayer.getPlayTime();
					_loc_3 = this.videoPlayer.getDuration();
					_loc_4 = -1;
					if (param1)
					{
						if (_loc_2 > _loc_3 - this.jumptime)
						{
							_loc_4 = _loc_3;
						}
						else
						{
							_loc_4 = _loc_2 + this.jumptime;
						}
					}
					else if (_loc_2 < this.jumptime)
					{
						_loc_4 = 0;
					}
					else
					{
						_loc_4 = _loc_2 - this.jumptime;
					}
					if (_loc_4 < 0)
					{
						_loc_4 = 0;
					}
					if (_loc_4 >= _loc_3)
					{
						this.stopByRanSeek();
						return;
					}
				
					this.seekStopHandler(_loc_4 / _loc_3);
					
					//WebReportMananger.addReport({itype:WebReportPlayerClick.ITYPE_SEEK});//快进的动作通知。。
				}
			}
			return;
		}// end function
		
		//支持窗口,这个可以根据实际情况调整
		protected function adjustPayPanel(param1:Boolean = true) : void
		{
			if (!this.skinManager.payPanel)
			{
				return;
			}
			if (param1)
			{
				this.skinManager.payPanel.x = (this.playerWidth - this.skinManager.payPanel.width) / 2;
				this.skinManager.payPanel.y = (this.playerHeight - this.skinManager.payPanel.height - this.skinManager.contrlBar.bg_mc.height) / 2;
			}
			else if (this.skinManager.payPanel.parent == this)
			{
				this.removeChild(this.skinManager.payPanel as DisplayObject);
			}
			return;
		}// end function
		
		
		//多码率设置初始化,这里后面可以考虑如何调用
		private function initFormatAndHeadTail() : void
		{
			var _loc_2:Boolean = false;
			var _loc_3:Array = null;
			var _loc_4:Object = null;
			var _loc_5:int = 0;
			var _loc_1:Boolean = true;
			try
			{
				_loc_2 = true;
				if (FormatUtil.hasMutiFormat(this.currentVideoData) && this.skinManager.definitionPanel)
				{
					if (!this.currentVideoData.video_changeformat)
					{
						_loc_3 = FormatUtil.getDefinitionPanelArray(this.currentVideoData.video_fmtlist);
						this.skinManager.definitionPanel.updateDisplay(_loc_3);
						_loc_5 = 0;
						while (_loc_5 < _loc_3.length)
						{
							
							_loc_4 = _loc_3[_loc_5];
							if (_loc_4 && _loc_4.name == GlobalVars.userSelFormat)
							{
								this.skinManager.definitionPanel.select = _loc_5;
								break;
							}
							_loc_5++;
						}
					}
					if (GlobalVars.playerLocalInfo.format != PlayerEnum.FORMAT_AUTO && GlobalVars.playerLocalInfo.format != this.currentVideoData.video_curfmt.name)
					{
						this.skinManager.definitionPanel.select = 0;
					}
					if (this.skinManager.definitionPanel.select == 0)
					{
						GlobalVars.isAutoFormat = true;
						var _loc_6:* = PlayerEnum.FORMAT_AUTO;
						this.currentVideoData.format = PlayerEnum.FORMAT_AUTO;
						GlobalVars.FormatSel = _loc_6;
						this.skinManager.definitionPanel.updateItemByIdx(FormatUtil.getAutoDefinitionInfo(this.currentVideoData.video_curfmt.name));
					}
					else
					{
						GlobalVars.isAutoFormat = false;
						this.skinManager.definitionPanel.updateItemByIdx(FormatUtil.getAutoDefinitionInfo());
					}
				}
				else
				{
					GlobalVars.isAutoFormat = true;
					_loc_1 = false;
					GlobalVars.FormatSel = "";
					GlobalVars.enabelGetClip = false;
				}
				if (this.playtimeObj.endtime > 0 && this.playtimeObj.endtype == PlayTime.TYPE_TAIL && this.moEnd - this.moStart > 2 && this.moEnd - this.moStart < this.currentVideoData.video_duration - 2)
				{
					_loc_2 = true;
				}
				else
				{
					_loc_2 = false;
				}
				if (this.skinManager.cfgPanel)
				{
					this.skinManager.cfgPanel.setShowMode(GlobalVars.showLightCfg, GlobalVars.showPopUpCfg, _loc_2, GlobalVars.showScaleCfg);
				}
				if (!this.currentVideoData.share_support)
				{
					GlobalVars.showShare = false;
				}
				if (this.skinManager.rightCfgMsg)
				{
					this.skinManager.rightCfgMsg.setShowMode(GlobalVars.showFavoriteCfg, GlobalVars.showShare);
				}
				this.adjustRightCfg();
				if (this.skinManager.topPanel)
				{
					this.skinManager.topPanel.showShare = GlobalVars.playerversion == PlayerEnum.TYPE_NORMAL ? (false) : (GlobalVars.showShare);
					this.skinManager.topPanel.showFavorite = GlobalVars.playerversion == PlayerEnum.TYPE_NORMAL ? (false) : (GlobalVars.showFavoriteCfg);
				}
				if (this.skinManager.searchBar)
				{
					this.skinManager.searchBar.setShowMode(GlobalVars.showSearch, GlobalVars.showFavoriteCfg, GlobalVars.showShare, GlobalVars.showBook);
				}
			}
			catch (e:Error)
			{
			}
			GlobalVars.showformat = _loc_1;
			this.skinManager.setDefinitionBtnEnable(GlobalVars.showformat);
			return;
		}// end function

		
		
		
		//控制按键是否显示
		public function controlEnabled(param1:Boolean, param2:Boolean, param3:Boolean, param4:Boolean, param5:Boolean, param6:*, param7:*, param8:*) : void
		{
			this.skinManager.controlEnabled(param1, param2, param3, param4, param5, param6, param7, param8);
			
			if (!this.skinManager.playerSkin)
			{
				return;
			}
			//添加或是删除一些动作，针对动作的监听
			
			if (param4)
			{
				if (!this.skinManager.contrlBar.seekBar.hasEventListener(MouseEvent.MOUSE_MOVE))
				{
					this.skinManager.contrlBar.seekBar.addEventListener(MouseEvent.MOUSE_MOVE, this.seekBarMMHandler);
					this.skinManager.contrlBar.seekBar.addEventListener(MouseEvent.MOUSE_OVER, this.seekBarMOVHandler);
					this.skinManager.contrlBar.seekBar.addEventListener(MouseEvent.MOUSE_OUT, this.seekBarMOTHandler);
				}
			}
			else if (this.skinManager.contrlBar.seekBar.hasEventListener(MouseEvent.MOUSE_MOVE))
			{
				this.skinManager.contrlBar.seekBar.removeEventListener(MouseEvent.MOUSE_MOVE, this.seekBarMMHandler);
				this.skinManager.contrlBar.seekBar.removeEventListener(MouseEvent.MOUSE_OVER, this.seekBarMOVHandler);
				this.skinManager.contrlBar.seekBar.removeEventListener(MouseEvent.MOUSE_OUT, this.seekBarMOTHandler);
			}
			
			
			if (param1)
			{
				this.videoClick.addEventListener(MyMouseEvent.CLICK, this.videoClickHandler);
				this.videoClick.addEventListener(MyMouseEvent.DOUBLE_CLICK, this.videoCbClickHandler);
				if (!this.skinManager.bigPlayBtn.hasEventListener(MouseEvent.MOUSE_UP))
				{
					this.skinManager.bigPlayBtn.addEventListener(MouseEvent.MOUSE_UP, this.bigBtnHandler);
				}
			}
			else
			{
				this.videoClick.removeEventListener(MyMouseEvent.CLICK, this.videoClickHandler);
				this.videoClick.removeEventListener(MyMouseEvent.DOUBLE_CLICK, this.videoCbClickHandler);
				
				
			}
			
			
			return;
		}// end function
		
		//双击事件
		private function videoCbClickHandler(event:Event) : void
		{
			if (this.isFullScreen)
			{
				this.screenfull = false;
			}
			else
			{
				this.screenfull = true;
			}
			return;
		}// end function
		
		//大按键监听事件
		protected function bigBtnHandler(event:Event = null) : void
		{
			this.btnPlay(event);
			try
			{
				this.skinManager.contrlBar.play_btn.state = "play";
			}
			catch (e:Error)
			{
			}
			return;
		}// end function


		
		//显示快进时间
		private function seekBarMMHandler(event:MouseEvent) : void
		{
			if (this.playerstatus == PlayerEnum.STATE_SEEKING)
			{
				return;
			}
			var _loc_2:* = this.videoPlayer.getDuration();
			if (_loc_2 > 0)
			{
				try
				{
					if (this.startPoint >= 0 && this.endPoint > this.startPoint)
					{
						_loc_2 = (this.endPoint - this.startPoint) * _loc_2;
					}
					this.showTimeTip(Tool.timeFormat(Math.round(this.skinManager.playerSkin.skin.seekBarMousePosition * _loc_2 * 1000), this.timeFormatType));
				}
				catch (e:Error)
				{
				}
			}
			return;
		}// end function
		//显示时间提示，这里没有这个项目，先不作考虑
		private function seekBarMOVHandler(event:MouseEvent) : void
		{
			trace('seekBarMOVHandler');//这个好像是跳出范围后的显示
			var event:* = event;
			var duration:* = this.videoPlayer.getDuration();
			if (duration > 0)
			{
				try
				{
					if (this.startPoint >= 0 && this.endPoint > this.startPoint && this.endPoint <= 1)
					{
						duration = (this.endPoint - this.startPoint) * duration;
					}
					this.showTimeTip(Tool.timeFormat(Math.round(this.skinManager.playerSkin.skin.seekBarMousePosition * duration * 1000), this.timeFormatType));
				}
				catch (e:Error)
				{
					skinManager.contrlBar.seekBar.removeEventListener(MouseEvent.MOUSE_MOVE, seekBarMMHandler);
					skinManager.contrlBar.seekBar.removeEventListener(MouseEvent.MOUSE_OVER, seekBarMOVHandler);
					skinManager.contrlBar.seekBar.removeEventListener(MouseEvent.MOUSE_OUT, seekBarMOTHandler);
				}
			}
			return;
		}// end function
		
		//移除显示时间提示
		private function seekBarMOTHandler(event:MouseEvent) : void
		{
			//不知道这个是干嘛的
			trace('seekBarMOTHandler');
			if (this.skinManager.timeTip && this.skinManager.timeTip.parent == this)
			{
				removeChild(this.skinManager.timeTip);
			}
			/*if (this.tipTimePanel && this.tipTimePanel.parent == this)
			{
				removeChild(this.tipTimePanel);
			}*/
			return;
		}// end function
		
		
		//设置当前时间.跳转的时候，设置下时间
		protected function showTimeTip(param1:String) : void
		{
			
			
			var _loc_2:* = mouseX;
			
			this.skinManager.timeTip.tiptext = param1;
			if (this.skinManager.timeTip.parent != this)
			{
				addChild(this.skinManager.timeTip);
			}
			this.skinManager.timeTip.x = _loc_2;
			this.skinManager.timeTip.y = this.skinManager.playerSkin.skin.controlBar_mc.y + this.skinManager.playerSkin.skin.controlBar_mc.seekBar.y - this.skinManager.timeTip.height - 5;
			
			return;
		}// end function
		
		
		//时间初始化,其实这里可以去掉的.
		private function metadataHandle() : void
		{
			var _loc_1:* = this.videoPlayer.getDuration();
			if (this.playtimeObj && this.playtimeObj.starttype == PlayTime.TYPE_ATTRACTION_START && this.playtimeObj.endtype == PlayTime.TYPE_ATTRACTION_END && this.playtimeObj.endtime > this.playtimeObj.starttime)
			{
				_loc_1 = this.playtimeObj.endtime - this.playtimeObj.starttime;
			}
			if (_loc_1 >= 3600)
			{
				this.timeFormatType = "00:00:00";
			}
			else
			{
				this.timeFormatType = "00:00";
			}
			this.adjustPlayer(this.videoWidth, this.videoHeight, false);
			return;
		}// end function
		
		//显示比例问题
		protected function adjustPlayer(param1:Number, param2:Number, param3:Boolean = true) : void
		{
			
			if (this.videoContainer)
			{
				this.videoContainer.x = 0;
				this.videoContainer.y = 0;
				
				this.videoContainer.setSize(param1, param2);
			}
			
			
			this.adjustVideoPlayer(param1, param2);
			if (param3)
			{
				this.adjustCtrlbar();
			}
			if (this.skinManager.bigPlayBtn != null)
			{
				this.adjustBigPlayBtn(this.skinManager.bigPlayBtn.x == 10000 ? (false) : (true));
			}
			this.adjustRightCfg(); //其它显示信息，界面上的
			//this.adjustPayPanel();
			this.adjustPanel(this.skinManager.infoPanel);
			//this.adjustSearchBar();
			this.adjustPanel(this.skinManager.sharePanel);
			//this.adjustSharePic();
			//this.adjustTipVote();投票
			this.adjustPanel(this.skinManager.msgPanel);
			if (this.skinManager.headtailTip)//Tip好像都是一些提示信息,里先都直接去掉好了.
			{
				this.skinManager.headtailTip.playerwidth = this.playerWidth;
			}
			if (this.skinManager.timeTip)
			{
				this.skinManager.timeTip.playerwidth = this.playerWidth;
			}
			/*if (this.tipTimePanel)
			{
				this.tipTimePanel.playerWidth = this.playerWidth;
			}*/
			if (this.skinManager.soundTip)
			{
				this.skinManager.soundTip.playerwidth = this.playerWidth;
			}
			try
			{
				if (this.skinManager.cfgPanel)
				{
					this.skinManager.cfgPanel.playerWidth = this.playerWidth;
				}
				if (this.skinManager.definitionPanel)
				{
					this.skinManager.definitionPanel.playerWidth = this.playerWidth;
				}
			}
			catch (e:Error)
			{
			}
			
			/*if (this.subtitleView)
			{
				this.subtitleView.resize(this.videoPlayer.getVideoWidth(), this.videoPlayer.getVideoHeight(), this.videoPlayer.x, this.videoPlayer.y);
			}*/
			return;
		}// end function
		
		
		
		protected function adjustCtrlbar() : void
		{
			this.skinManager.setSize(this.playerWidth, this.playerHeight, this.isFullScreen);
			if (this.videoPlayer && this.videoPlayer.getPlayerState() != PlayerEnum.STATE_STOP && this.videoPlayer.getLoadedPercent() > 0)
			{
				try
				{
					this.skinManager.contrlBar.seekBar.loadingWidth = this.videoPlayer.getLoadedPercent();
					if (this.skinManager.miniSeekbar)
					{
						this.skinManager.miniSeekbar.loadingWidth = this.videoPlayer.getLoadedPercent();
					}
				}
				catch (e:Error)
				{
				}
			}
			return;
		}// end function

		
		
		protected function adjustSearchBar() : void
		{
			if (this.skinManager.searchBar && this.skinManager.searchBar.parent == this)
			{
				if (this.videoPlayer.getPlayerState() != PlayerEnum.STATE_STOP)
				{
					this.skinManager.searchBar.y = -this.skinManager.searchBar.height;
					this.skinManager.searchBar.x = 0;
				}
				this.skinManager.searchBar.setSize(this.videoWidth);
			}
			return;
		}// end function
		
		
		
		
		
		//创建分享字符串
		private function createCopystr(param1:Array) : void
		{
			if (GlobalVars.showShare && (this.skinManager.sharePanel || this.skinManager.shareInside))
			{
				this.copySwf = "http://static.video.qq.com/TPout.swf?auto=1&vid=" + param1.join("|");
				if (this.playtimeObj && this.playtimeObj.starttype == PlayTime.TYPE_ATTRACTION_START && this.playtimeObj.endtype == PlayTime.TYPE_ATTRACTION_END)
				{
					this.copySwf = this.copySwf + ("&attstart=" + this.playtimeObj.attstarttime + "&attend=" + this.playtimeObj.endtime);
				}
				this.copyPage = PlayerUtils.getPlayPage(param1[0], GlobalVars.exid);
				this.copyHtml = "<embed src=\"" + this.copySwf + "\" quality=\"high\" width=\"460\" height=\"372\" align=\"middle\" allowScriptAccess=\"sameDomain\" allowFullscreen=\"true\" type=\"application/x-shockwave-flash\"></embed>";
				try
				{
					this.skinManager.sharePanel.setSwftxt(this.copySwf);
					this.skinManager.sharePanel.setHtmltxt(this.copyHtml);
					this.skinManager.sharePanel.setPagetxt(this.copyPage);
				}
				catch (e:Error)
				{
				}
			}
			return;
		}// end function
		
		
		//播放失败时调用的方法
		protected function playerError(event:VideoPlayerEvent) : void
		{
			trace('playerError');
			var event:* = event;
			switch(event.type)
			{
				case VideoPlayerEvent.SETUP_ERROR:
				case VideoPlayerEvent.PLAY_NOMAL_ERROR:
				{
					if (this.timer && this.timer.isRunning())
					{
						this.timer.stop();
					}
					this.showRightCfg(false);
					clearTimeout(this.seekstoptipTimeoutCount);
					this.closePopupBut(null);
					try
					{
						if (event.value.code && event.value.code == PlayerEnum.ST_ERROR_UNALLOW)
						{
							this.showErrorTip(false);
						}
						else
						{
							this.showErrorTip();
						}
					}
					catch (e:Error)
					{
						showErrorTip();
					}
					this.skinManager.contrlBar.play_btn.state = "pause";
					this.controlEnabled(false, false, true, false, true, false, false, false);
					this.skinManager.setDefinitionBtnEnable(false);
					AS3Debugger.Trace("BasePlayerV3::playerError");
					if (event.value && event.value.em == 80 && this.skinManager.msgPanel)
					{
						this.skinManager.msgPanel.update(1);
						this.addPanel(this.skinManager.msgPanel);
					}
					dispatchEvent(new OmsPlayerEvent(OmsPlayerEvent.PLAY_ERROR));//没有特别的错误事件
					break;
				}
				default:
				{
					break;
				}
			}
			return;
		}// end function
		
		//右侧的相关按键
		protected function showRightCfg(param1:Boolean):void
		{
			if (GlobalVars.showRightPanel && this.skinManager.rightCfgMsg)
			{
				if (!GlobalVars.showCfg)
				{
					return;
				}
				clearTimeout(this.rightCfgTimeoutCount);
				if (param1)
				{
					this.skinManager.rightCfgMsg.visible = true;
					TweenLite.to(this.skinManager.rightCfgMsg, this.panelMovetime, {alpha:1});
					this.rightCfgTimeoutCount = setTimeout(this.hideRightCfg, 5000);
				}
				else
				{
					this.skinManager.rightCfgMsg.visible = false;
					this.rightCfgShowing = false;
					this.skinManager.rightCfgMsg.alpha = 0;
				}
			}
			return;
		}// end function

		//隐藏右侧,关注什么之类的
		protected function hideRightCfg() : void
		{
			if (!this.skinManager.rightCfgMsg)
			{
				return;
			}
			clearTimeout(this.rightCfgTimeoutCount);
			if (this.skinManager.rightCfgMsg.hitTestPoint(this.mouseX, this.mouseY, true))
			{
				return;
			}
			TweenLite.to(this.skinManager.rightCfgMsg, this.panelMovetime, {alpha:0});
			return;
		}// end function

		//播放错误显示窗口
		protected function playerErrorHandler(param1:int) : void
		{
			switch(param1)
			{
				case PlayerEnum.ERROR_DEFAULT:
				{
					this.showErrorTip();
					break;
				}
				default:
				{
					break;
				}
			}
			return;
		}// end function
		
		
		//显示错误提示
		protected function showErrorTip(param1:Boolean = true) : void
		{
			this.playerstatus = PlayerEnum.STATE_STOP;
			if (param1)
			{
				
				GlobalVars._vodPlay.onStateChanged('CONNECTION_ERROR');
				
				this.showCheckPlay(ResourceManager.instance.getContent("tipinfo_videofail"), ResourceManager.instance.getContent("tiptxt_refreash"), {key:PlayerEnum.TIPLINK_REFRESH}, 0, 0);
				if (this.skinManager.msgPanel)
				{
					this.skinManager.msgPanel.update(0);
					this.addPanel(this.skinManager.msgPanel);
				}
			}
			else
			{
				this.skinManager.showMsgTip(ResourceManager.instance.getContent("tipinfo_forbid"));
			}
			return;
		}// end function
		
		//添加面板
		protected function addPanel(param1:*) : void
		{
			this.adjustPanel(param1);
			if (!param1 || contains(param1))
			{
				return;
			}
			addChild(param1);
			return;
		}// end function
		
		//面板位置
		protected function adjustPanel(param1:*, param2:Number = 375, param3:Number = 250) : void
		{
			if (!param1)
			{
				return;
			}
			if (this.videoWidth < param2 || this.videoHeight < param3)
			{
				if (contains(param1))
				{
					removeChild(param1);
				}
				return;
			}
			param1.x = (this.videoWidth - param1.width) / 2;
			param1.y = (this.videoHeight - param1.height) / 2;
			return;
		}// end function
		
		
		//显示检测播放
		protected function showCheckPlay(param1:String, param2:String, param3:Object, param4:Number = 0, param5:Number = 0, param6:Boolean = true) : void
		{
			var msg:* = param1;
			var link:* = param2;
			var key:* = param3;
			var starttime:* = param4;
			var endtime:* = param5;
			var mouseevent:* = param6;
			if (!this.skinManager.msgTip)
			{
				return;
			}
			if (this.skinManager.msgTip.btnlink && !this.skinManager.msgTip.btnlink.hasEventListener(MouseEvent.CLICK))
			{
				this.skinManager.msgTip.btnlink.addEventListener(MouseEvent.CLICK, this.tipLinkClickHandler);
			}
			if (mouseevent && !this.skinManager.msgTip.btnlink.hasEventListener(MouseEvent.MOUSE_OUT))
			{
				this.skinManager.msgTip.btnlink.addEventListener(MouseEvent.MOUSE_OUT, this.tipLinkOutHandler);
				this.skinManager.msgTip.btnlink.addEventListener(MouseEvent.MOUSE_OVER, this.tipLinkOverHandler);
			}
			clearTimeout(this.hideTipTimeout);
			this.showTipTimeout = setTimeout(function ():void
			{
				skinManager.showMsgTip(msg, link, key);
				return;
			}// end function
				, starttime);
			if (endtime != 0)
			{
				this.hideTipTimeout = setTimeout(function ():void
				{
					skinManager.showMsgTip();
					return;
				}// end function
					, endtime);
			}
			return;
		}// end function
		
		//清除隐藏面板事件
		private function tipLinkOverHandler(event:MouseEvent) : void
		{
			clearTimeout(this.hideTipTimeout);
			return;
		}// end function
		//面板点播事件
		private function tipLinkClickHandler(event:MouseEvent) : void
		{
			var _loc_2:Object = null;
			try
			{
				_loc_2 = this.skinManager.msgTip.btnlink.linkData;
				switch(_loc_2.key)
				{
					case PlayerEnum.TIPLINK_HISTORY:
					{
						this.seekStopHandler(0);
						break;
					}
					case PlayerEnum.TIPLINK_HEADTAIL:
					{
						this.btnOverHandler(null, this.skinManager.btnConfig);
						break;
					}
					case PlayerEnum.TIPLINK_REFRESH:
					{
						if (ExternalInterface.available && GlobalVars.objIdAllowed)
						{
							ExternalInterface.call("eval", "window.location.reload()");
						}
						break;
					}
					case PlayerEnum.TIPLINK_PAY:
					{
						this.paynowHandler(null);
						break;
					}
					case PlayerEnum.TIPLINK_TIPAD:
					{
						
						break;
					}
					case PlayerEnum.TIPLINK_FORMAT:
					{
						this.btnOverHandler(null, this.skinManager.btnDefinition);
						break;
					}
					case PlayerEnum.TIPLINK_PAYPANEL:
					{
						if (this.isFullScreen)
						{
							this.btnNormal();
						}
						try
						{
							navigateToURL(new URLRequest(GlobalVars.homepage), "_blank");
						}
						catch (e:Error)
						{
						}
						break;
					}
					case PlayerEnum.TIPLINK_HISTORY_PLAY:
					{
						if (ExternalInterface.available && GlobalVars.objIdAllowed)
						{
							ExternalInterface.call("_tenplay_historyplay", _loc_2.vid, _loc_2.tm);
						}
						break;
					}
					default:
					{
						break;
					}
				}
			}
			catch (e:Error)
			{
			}
			return;
		}// end function
		
		//支付面板动作
		private function paynowHandler(event:MouseEvent) : void
		{
			var event:* = event;
			if (GlobalVars.pay == 2)
			{
				try
				{
					if (ExternalInterface.available && GlobalVars.objIdAllowed)
					{
						ExternalInterface.call("__tenplay_buynow");
					}
				}
				catch (e:Error)
				{
				}
			}
			else
			{
				if (this.skinManager.payPanel)
				{
					try
					{
						this.skinManager.payPanel.checkLoginStatus();
						this.skinManager.payPanel.onVipClick();
					}
					catch (e:Error)
					{
						if (skinManager.payPanel.parent == this)
						{
							unpayCloseHandler(null);
						}
						else
						{
							if (playerstatus == PlayerEnum.STATE_PLAYING)
							{
								btnPause(null);
							}
							unpayHandler(false);
						}
					}
				}
				
			}
			return;
		}// end function
		
		
		//未支付关闭动作
		private function unpayCloseHandler(param1:Object) : void
		{
			this.adjustPayPanel(false);
			if (this.playerstatus == PlayerEnum.STATE_PAUSE)
			{
				this.btnPlay(null);
			}
			return;
		}// end function

		
		//移动到某个位置时显示的一些东西.类似最大化，最小化之类的东西
		private function btnOverHandler(event:MouseEvent = null, param2:Object = null) : void
		{
			//trace('11111111111111111111111111111');
			trace('定义mouseevent');
			var _loc_3:Object = null;
			if (event && event.currentTarget)
			{
				_loc_3 = event.currentTarget;
			}
			else
			{
				_loc_3 = param2;
			}
			switch(_loc_3)
			{
				case this.skinManager.btnDefinition:
				{
					//trace('2222222222222222222');
					clearTimeout(this.hideDefincount);
					if (this.currentVideoData && this.skinManager.definitionPanel)
					{
						if (this.skinManager.definitionPanel.select != 0)
						{
							this.skinManager.definitionPanel.updateItemByIdx(FormatUtil.getAutoDefinitionInfo());
						}
						else
						{
							this.skinManager.definitionPanel.updateItemByIdx(FormatUtil.getAutoDefinitionInfo(this.videoPlayer.getCurrFormatName()));
						}
						this.skinManager.definitionPanel.y = this.skinManager.playerSkin.skin.controlBar_mc.y + this.skinManager.btnDefinition.y - 3;
						this.skinManager.definitionPanel.x = this.skinManager.playerSkin.skin.controlBar_mc.x + this.skinManager.btnDefinition.x + 23;
						if (!contains(this.skinManager.definitionPanel as DisplayObject))
						{
							this.skinManager.definitionPanel.alpha = 0;
							addChild(this.skinManager.definitionPanel as DisplayObject);
							TweenLite.to(this.skinManager.definitionPanel, 0.35, {alpha:1});
						}
					}
					break;
				}
				case this.skinManager.btnConfig:
				{
					trace('333333333333333');
					clearTimeout(this.hideCfgcount);
					if (this.skinManager.cfgPanel)
					{
						this.skinManager.cfgPanel.y = this.skinManager.playerSkin.skin.controlBar_mc.y + this.skinManager.btnConfig.y - 3;
						this.skinManager.cfgPanel.x = this.skinManager.playerSkin.skin.controlBar_mc.x + this.skinManager.btnConfig.x + 12;
						if (!contains(this.skinManager.cfgPanel as DisplayObject))
						{
							this.skinManager.cfgPanel.alpha = 0;
							addChild(this.skinManager.cfgPanel as DisplayObject);
							TweenLite.to(this.skinManager.cfgPanel, 0.35, {alpha:1});
						}
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

		
		
		//移出后显示的.
		private function tipLinkOutHandler(event:MouseEvent) : void
		{
			var event:* = event;
			this.hideTipTimeout = setTimeout(function ():void
			{
				onMsgTipClose(null);
				return;
			}// end function
				, 3000);
			return;
		}// end function
		
		//关闭显示面板
		private function onMsgTipClose(event:MouseEvent) : void
		{
			if (this.skinManager.msgTip.btnlink && this.skinManager.msgTip.btnlink.hasEventListener(MouseEvent.MOUSE_OUT))
			{
				this.skinManager.msgTip.btnlink.removeEventListener(MouseEvent.MOUSE_OUT, this.tipLinkOutHandler);
				this.skinManager.msgTip.btnlink.removeEventListener(MouseEvent.MOUSE_OVER, this.tipLinkOverHandler);
			}
			this.skinManager.showMsgTip();
			return;
		}// end function
		
		
		//需要付费才可以播放的电影
		private function unpayHandler(param1:Boolean = true) : void
		{
			var _loc_2:ReportMode = null;
			if (!this.skinManager.payPanel)
			{
				this.showCheckPlay("此节目是付费影片，您可以到www.kankanews.com付费观看", "传送门", {key:PlayerEnum.TIPLINK_PAYPANEL}, 0, 0);
				return;
			}
			this.skinManager.payPanel.checkLoginStatus();
			if (param1 && this.skinManager.bigPlayBtn && this.skinManager.bigPlayBtn.parent == this)
			{
				addChildAt(this.skinManager.payPanel as DisplayObject, (getChildIndex(this.skinManager.bigPlayBtn as DisplayObject) + 1));
			}
			else
			{
				addChild(this.skinManager.payPanel as DisplayObject);
			}
			this.adjustPayPanel();
			this.adjustBigPlayBtn(false);
			//this.removeCoverPage();
			if (param1 && this.loadingswf && this.loadingswf.parent == this)
			{
				this.removeChild(this.loadingswf);
			}
			try
			{
				_loc_2 = ReportManager.createReportMode(ReportManager.STEP_PAY, Number(GlobalVars.payedVideoStatus), Number(this.skinManager.payPanel.getVideoStatus()), Number(this.skinManager.payPanel.getUserStatus()), this.videoPlayer.getPlayTime(), this.videoPlayer.getCurrVid(), this.videoPlayer.getCurrFormat(), "0", this.videoPlayer.getCurrVt(), 0, this.videoPlayer.getCurrLevel(), "", this.videoPlayer.getCurrFormatName(), {usingP2P:this.videoPlayer.getUsingP2P()});
				if (GlobalVars.isPayedVideo)
				{
					_loc_2.bi = 2;
					if (GlobalVars.isPreviewVideo)
					{
						_loc_2.bi = 1;
					}
				}
				ReportManager.addReport(_loc_2, true);
			}
			catch (e:Error)
			{
			}
			
			return;
		}// end function
		
		//创建EV..这个还不知道是什么东东,明天继续看了.
		private function createevEvent() : void
		{
			if (!this.evcreated)
			{
				this.evcreated = true;
				dispatchEvent(new OmsPlayerEvent(OmsPlayerEvent.CREATE_EV));
			}
			return;
		}// end function
		
		
		//播放完成
		private function playCompleteHandler() : void
		{
			trace('-------------');
			trace('playCompleteHandler');
			trace('-------------');
			var _loc_1:Number = NaN;
			this.playerstatus = PlayerEnum.STATE_STOP;
			AS3Debugger.Trace("BasePlayerV3::playCompleteHandler");
			clearTimeout(this.seekstoptipTimeoutCount);
			if (this.timer != null && this.timer.isRunning())
			{
				this.timer.stop();
			}
			if (this.videoPlayer)
			{
				ReportManager.heartReportEnd(this.videoPlayer.getCurrFormat(), this.videoPlayer.getModetype(), this.videoPlayer.getCurrVt());
				trace('终于播放完成了!~');
			}
			this.adjustBigPlayBtn(true);
			this.showCtrlBar(true);
			this.showRightCfg(false);
			this.closePopupBut(null);
			this.showTopPanel(false);
			this.mousecheck = false;
			this.enableMenu(false);
			this.showSearchBar(true, true);
			this.showNormalSeekBar(true, false);
			
			if (this.skinManager.definitionPanel && contains(this.skinManager.definitionPanel  as DisplayObject))
			{
				removeChild(this.skinManager.definitionPanel  as DisplayObject);
			}
			if (this.skinManager.cfgPanel && contains(this.skinManager.cfgPanel  as DisplayObject))
			{
				removeChild(this.skinManager.cfgPanel  as DisplayObject);
			}
			
			//播放结束调用两个报告体系,全部刷新
			
			ReportManager.flushReport(true);
			//WebReportMananger.web_flushReport(true);
			
			if (this.playerActivity)
			{
				this.playerActivity.destory();
				this.closePlayerActivity(null);
			}
			/*if (this.tipvote)
			{
				this.closeTipVote();
			}*/
			
			if (this.skinManager.btnShareplay && this.skinManager.btnShareplay.parent == this)
			{
				this.removeChild(this.skinManager.btnShareplay as DisplayObject);
			}
			this.showErrorPanel(false);
			if (this.videoPlayer.hasEventListener(VideoPlayerEvent.PLAY_STATUS_CHANGED))
			{
				this.videoPlayer.removeEventListener(VideoPlayerEvent.PLAY_STATUS_CHANGED, this.statusChangedHandler);
			}
			if (!GlobalVars.isPreviewVideo)
			{
				try
				{
					this.skinManager.contrlBar.seekBar.position = 0;
					this.skinManager.contrlBar.seekBar.loadingWidth = 0;
					if (this.skinManager.miniSeekbar)
					{
						this.skinManager.miniSeekbar.position = 0;
						this.skinManager.miniSeekbar.loadingWidth = 0;
					}
					this.skinManager.contrlBar.seekBar.hideAttrationPoint();
				}
				catch (e:Error)
				{
				}
				_loc_1 = this.videoPlayer.getDuration();
				if (this.startPoint >= 0 && this.startPoint < this.endPoint && this.endPoint <= 1)
				{
					_loc_1 = (this.endPoint - this.startPoint) * _loc_1;
				}
				this.skinManager.setShowTime(Tool.timeFormat(0, this.timeFormatType), Tool.timeFormat(_loc_1 * 1000, this.timeFormatType));
			}
			try
			{
				this.skinManager.contrlBar.play_btn.state = "pause";
			}
			catch (e:Error)
			{
			}
			if (this.skinManager.btnReplay)
			{
				if (this.skinManager.contrlBar.play_btn)
				{
					this.skinManager.contrlBar.play_btn.visible = false;
				}
				this.skinManager.btnReplay.visible = true;
			}
			this.seekBarMOTHandler(null);
			if (this.skinManager.shareInside)
			{
				this.controlEnabled(true, false, true, false, true, false, false, false);
			}
			else
			{
				this.controlEnabled(true, false, true, false, true, false, true, false);
			}
			this.skinManager.setDefinitionBtnEnable(false);
			this.skinManager.showMsgTip();
			this.attractionStop = false;
			return;
		}// end function
		
		
		//控制面板上的那个东西
		protected function infoPanelTimecout() : void
		{
			if (!this.videoPlayer || !this.skinManager.infoPanel || this.skinManager.infoPanel.parent != this)
			{
				return;
			}
			//信息面板内容参数
			this.skinManager.infoPanel.dlspeed = this.videoPlayer.getDlSpeed();
			this.skinManager.infoPanel.volume = this.videoPlayer.getVolume();
			this.skinManager.infoPanel.videoFps = this.videoPlayer.getFPS();
			
			try
			{
				this.skinManager.infoPanel.swfFps = stage.frameRate;
			}
			catch (e:Error)
			{
			}
			//视频的显示比例
			if (this.currentVideoData)
			{
				this.skinManager.infoPanel.videoSize = this.currentVideoData.video_orgWidth.toString() + "*" + this.currentVideoData.video_orgHeight.toString();
			}
			switch(this.currentScaleFactor)
			{
				case 1:
				{
					this.skinManager.infoPanel.videoScale = "铺满窗口";
					break;
				}
				case 3:
				{
					this.skinManager.infoPanel.videoScale = "16:9";
					break;
				}
				case 4:
				{
					this.skinManager.infoPanel.videoScale = "4:3";
					break;
				}
				default:
				{
					this.skinManager.infoPanel.videoScale = "原始尺寸";
					break;
					break;
				}
			}
			return;
		}// end function
		
		
		
		
		
		
		
		
		
	}
	
	
	
	
	
}