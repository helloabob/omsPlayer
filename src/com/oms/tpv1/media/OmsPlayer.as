package com.oms.tpv1.media
{
	import com.greensock.*;
	import com.koma.utils.*;
	import com.oms.tpv1.events.*;
	import com.oms.tpv1.managers.*;
	import com.oms.tpv1.model.*;
	import com.oms.tpv1.resource.*;
	import com.oms.tpv1.utils.*;
	import com.oms.utils.timer.*;
	import com.sun.events.*;
	import com.sun.net.*;
	import com.sun.utils.*;
	import flash.display.*;
	import flash.events.*;
	import flash.external.*;
	import flash.net.*;
	import flash.system.*;
	import flash.text.*;
	import flash.ui.*;
	import flash.utils.*;
	import com.oms.report.*;
	
	public class OmsPlayer extends BasePlayer
	{
		private var autoPlay:Boolean;
		private var vid:String = "";
		private var outhost:String = "";
		private var arrayVid:Array;
		private var txtError:TextField;
		private var autoNormalScreen:Boolean = false;
		private var timerSave:TPTimer;
		private var tstart:Number = 0;
		private var historyStart:Number = 0;
		private var videostarted:Boolean = false;
		private var arrayDuration:Array;
		private var duration:String = "";
		private var attractionStart:Number = 0;
		private var attractionEnd:Number = 0;
		private var moviestart:Number = 0;
		private var movieend:Number = 0;
		private var settimeInfo:Object;
		private var volumeTimeoutCount:uint;
		private var _fld:FileLoader;
		private var xml_path:String = "";
		private var _tryTimes:int = 0;
		
		public function OmsPlayer()
		{
			
			
			
			this.addinit();
			
			return;
		}// end function
		
		
		
		public function set configurationParameters(param1:Object) : void
		{
			
			
			
			
			
			GlobalVars.omsid = param1.omsid;
			GlobalVars.xmlid = param1.xmlid;
			
			
			if (param1.autoPlay == "false")
			{
				this.autoPlay = false;
			}
			else
			{
				this.autoPlay = true;
			}
			this.addinit();
			
			
			return;
		}// end function
		
		
		
		
		
		private function addinit() : void
		{
			Security.allowDomain("*");
			GlobalVars.objIdAllowed = PlayerUtils.checkObjectID();
			try
			{
				if (ExternalInterface.available && GlobalVars.objIdAllowed)
				{
					GlobalVars.usingHost = String(ExternalInterface.call("eval", "location.href"));
				}
			}
			catch (e:Error)
			{
				AS3Debugger.Trace(e.toString());
				GlobalVars.usingHost = "";
			}
			
			
			//ReportManager.getReporttime('addinit');

			GlobalVars.omsid = 1250500;
			if (GlobalVars.xmlid != "")
			{
				
				
				
				this._fld = new FileLoader();
				this._fld.requestTimeout = 6000;
				this._fld.loadTimeout = 6000;
				if (!this._fld.hasEventListener(NLoaderEvent.LOAD_COMPLETE))
				{
					this._fld.addEventListener(NLoaderEvent.LOAD_COMPLETE, this.urlLoadCompleteHandler);
					this._fld.addEventListener(NLoaderEvent.LOAD_ERROR, this.urlLoadErrorHandler);
				}
				this.xml_path = "http://www.kankanews.com/statuses/vc/" + GlobalVars.xmlid.split("vxml/").join("") + ".xml";
				this._fld.load(this.xml_path, "URLRequest", URLLoaderDataFormat.TEXT, "", "POST");
				
			}else if(GlobalVars.omsid>0){
					this.outerParamsInit();
				
			}
			
			if(GlobalVars.xmlid != "" || GlobalVars.omsid>0){
				
				dispatchEvent(new Event("showMedia"));
				
				
				var numVersion:* = Math.floor(Math.random() * 10000).toString();
				AS3Debugger.identity = GlobalVars.version + " [instance " + numVersion + "]";
				AS3Debugger.OmitTrace = GlobalVars.playerDebug;
				AS3Debugger.OmitTrace = true;
				AS3Debugger.Trace("host=" + GlobalVars.usingHost + "!");
				addEventListener(Event.ADDED_TO_STAGE, this.addedToStage);
				
			}
			return;
		}// end function
		
		private function urlLoadCompleteHandler(event:NLoaderEvent) : void
		{
			
			
			
			
			
			var _loc_3:*;
			var event:* = event;
			var _loc_5:Boolean;
			var _loc_6:* = undefined;
			var _loc_7:String;
			this._fld.removeEventListener(NLoaderEvent.LOAD_COMPLETE, this.urlLoadCompleteHandler);
			this._fld.removeEventListener(NLoaderEvent.LOAD_ERROR, this.urlLoadErrorHandler);
			var _loc_2:* = event.value.data;
			try
			{
				_loc_3 = XML(_loc_2);
				if (int(_loc_3.omsid) < 0)
				{
					_loc_3.omsid = 1127701;
				}
				else
				{
					_loc_3.omsid = int(_loc_3.omsid);
				}
			}
			catch (e:Error)
			{
				_loc_3.omsid = 1127701;
			}
			
			GlobalVars.omsid = int(_loc_3.omsid);
			
			GlobalVars.videoWebChannel = this.getChannelNameFromString(_loc_3.column);
			GlobalVars.keyword = _loc_3.keywords.split(",").join("/");
			
			
			
			this.outerParamsInit();
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			stage.addEventListener(Event.RESIZE, this.resizeHandler);
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, this.screenHanler);
			this.playerInit();
			
			
			return;
		}// end function
		
		private function getChannelNameFromString(param1:String) : String
		{
			var _loc_2:* = param1;
			var _loc_3:* = _loc_2.indexOf("/");
			var _loc_4:* = _loc_2.lastIndexOf("/");
			_loc_2 = _loc_2.substring((_loc_3 + 1), _loc_4);
			return _loc_2;
		}// end function
		
		private function urlLoadErrorHandler(event:NLoaderEvent) : void
		{
			this.addinit();
			return;
		}// end function
		
		private function outerParamsInit() : void
		{
			
			
			//ReportManager.getReporttime('outerParamsInit');
			
			GlobalVars.playerversion = PlayerManager.checkPlayerVersion(this.loaderInfo.url);
			PlayerManager.checkPlayerCfg(GlobalVars.playerversion);
			this.vid = GlobalVars.omsid.toString();
			
			//this.vid = '1155822';
			
			GlobalVars.usingHost = "http://v.kankanews.com/";
			GlobalVars.showShare = true;
			GlobalVars.showPopUpCfg = false;
			GlobalVars.showLightCfg = false;
			GlobalVars.showEnd = true;
			PlayerUtils.checkVarsUrl(GlobalVars.playerSkinUrl);
			
			return;
		}// end function
		
		private function addedToStage(event:Event) : void
		{
			
			
			//ReportManager.getReporttime('addedToStage');
			dispatchEvent(new Event("showMedia"));
			
			this.removeEventListener(Event.ADDED_TO_STAGE, this.addedToStage);
			stage.align = StageAlign.TOP_LEFT;
			
			
			if(GlobalVars.xmlid==''){
				
			
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.stageFocusRect = false;
				stage.addEventListener(Event.RESIZE, this.resizeHandler);
				stage.addEventListener(FullScreenEvent.FULL_SCREEN, this.screenHanler);
				this.playerInit();
				
				
				
				
			}
			
			
			
			
			return;
		}// end function
		
		public function checkIsZVer() : void
		{
			return;
		}// end function
		
		
		private function playerInit() : void
		{
			
			//ReportManager.getReporttime('playerInit');
			
			videoWidth = stage.stageWidth;
			videoHeight = stage.stageHeight;
			playerWidth = stage.stageWidth;
			playerHeight = stage.stageHeight;
			GlobalVars.pid = Guid.create();
			this.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, this.onUncaughtError);
			this.stage.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, this.onUncaughtError);
			this.initMenu();
			this.addEventListener(OmsPlayerEvent.INIT_COMPLETE, this.playerInitComplete);
			this.addEventListener(OmsPlayerEvent.INIT_ERROR, this.playerInitError);
			this.addEventListener(OmsPlayerEvent.PLAY_STARTLOAD, this.playerLoad);
			this.addEventListener(OmsPlayerEvent.PLAY_STARTPLAY, this.playerStart);
			this.addEventListener(OmsPlayerEvent.PLAY_PAUSE, this.playerPause);
			this.addEventListener(OmsPlayerEvent.PLAY_SEEKSTOP, this.playerSeek);
			this.addEventListener(OmsPlayerEvent.PLAY_STOP, this.playerStop);
			this.addEventListener(OmsPlayerEvent.PLAY_CHANGE, this.playchanged);
			this.addEventListener(OmsPlayerEvent.CREATE_EV, this.createevHandler);
			var _loc_1:String = null;
			loadSkin();
			return;
		}// end function
		
		public function externalCallPlayVideo(param1:String) : void
		{
			return;
		}// end function
		
		private function initMenu() : void
		{
			var _loc_1:ContextMenu = null;
			try
			{
				_loc_1 = new ContextMenu();
				_loc_1.hideBuiltInItems();
				contextMenu = _loc_1;
			}
			catch (e:Error)
			{
			}
			return;
		}// end function
		
		private function createevHandler(event:OmsPlayerEvent) : void
		{
			var continuToPlay:Boolean;
			var platform:String;
			var info:Object;
			var event:* = event;
			event = event;
			try
			{
				if (ExternalInterface.available && GlobalVars.objIdAllowed)
				{
					continuToPlay = ExternalInterface.call("__flashplayer_continueToPlay");
					
				}
			}
			catch (e:Error)
			{
			}
			if (continuToPlay)
			{
				return;
			}
			if (!this.arrayVid || this.arrayVid.length == 0)
			{
				return;
			}
			if (GlobalVars.playerversion != PlayerEnum.TYPE_NORMAL)
			{
			}
			//var h:* = orgHeight - skinManager.contrlBar.bg_mc.height;
			
			
			return;
		}// end function
		
		private function playerStop(event:OmsPlayerEvent) : void
		{
			showMsgTip("");
			skinManager.contrlBar.mouseChildren = true;
			Mouse.show();
			this.playCompleteReport();
			if (loadingswf != null && loadingswf.parent == this)
			{
				removeChild(loadingswf);
			}
			this.playeEndHandler();
			return;
		}// end function
		
		private function playeEndHandler() : void
		{
			adjustBigPlayBtn(true);
			if (skinManager.shareInside)
			{
				controlEnabled(true, false, true, false, true, false, false, false);
			}
			else
			{
				controlEnabled(true, false, true, false, true, false, true, false);
			}
			skinManager.setDefinitionBtnEnable(false);
			if (this.autoNormalScreen && isFullScreen)
			{
				btnNormal();
			}
			PlayerUtils.onPlayerMsg(PlayerEnum.PLAYERMSG_STOP);
			return;
		}// end function
		
		private function playCompleteReport() : void
		{
			var _loc_1:int = 0;
			var _loc_2:int = 0;
			if (this.timerSave && this.timerSave.isRunning())
			{
				this.timerSave.stop();
			}
			try
			{
				if (!attractionStop)
				{
					if (ExternalInterface.available && GlobalVars.objIdAllowed)
					{
						_loc_1 = videoPlayer.getDuration();
						_loc_2 = videoPlayer.getPlayTime();
						ExternalInterface.call("_flash_view_history", -2, _loc_2, _loc_1);
					}
				}
			}
			catch (e:Error)
			{
			}
			return;
		}// end function
		
		private function playchanged(event:OmsPlayerEvent) : void
		{
			adjustBigPlayBtn(false);
			controlEnabled(false, false, true, false, true, false, false, false);
			skinManager.setDefinitionBtnEnable(false);
			GlobalVars.pid = Guid.create();
			var _loc_2:int = 0;
			this.tstart = 0;
			this.historyStart = _loc_2;
			this.checkAdBeforePlay();
			return;
		}// end function
		
		private function playerPause(event:OmsPlayerEvent) : void
		{
			PlayerUtils.onPlayerMsg(PlayerEnum.PLAYERMSG_PAUSE);
			return;
		}// end function
		
		private function playerSeek(event:OmsPlayerEvent) : void
		{
			if (event.value.msg == "seeked")
			{
				this.showPlayMsgtip();
			}
			return;
		}// end function
		
		public function showPlayMsgtip() : void
		{
			var _loc_1:Boolean = false;
			var _loc_2:String = null;
			var _loc_3:String = null;
			var _loc_4:String = null;
			if (this.settimeInfo && showPlayTip)
			{
				showPlayTip = false;
				tipHisShowing = true;
				_loc_1 = true;
				_loc_2 = ResourceManager.instance.getContent("tipinfo_history");
				_loc_3 = "";
				_loc_4 = "";
				if (this.settimeInfo.title != null && this.settimeInfo.title != "")
				{
					_loc_3 = this.settimeInfo.title + ResourceManager.instance.getContent("tipinfo_history4");
				}
				if (this.settimeInfo.tm != null && !isNaN(this.settimeInfo.tm) && this.settimeInfo.tm > 0)
				{
					_loc_4 = " " + Tool.timeFormat(this.settimeInfo.tm * 1000, "00:00") + " " + ResourceManager.instance.getContent("tipinfo_history2");
				}
				if (_loc_4 == "")
				{
					_loc_2 = "";
				}
				else if (_loc_3 == "")
				{
					_loc_1 = true;
					_loc_2 = _loc_2 + (_loc_4 + ResourceManager.instance.getContent("tipinfo_history3"));
				}
				else
				{
					_loc_1 = false;
					_loc_2 = _loc_2 + (_loc_3 + _loc_4);
				}
				if (!this.settimeInfo.vid || !this.settimeInfo.tm)
				{
					_loc_1 = true;
				}
				skinManager.showMsgTip();
				if (_loc_1)
				{
					showCheckPlay(_loc_2, "", null, 1000, 4000, false);
				}
				else
				{
					showCheckPlay(_loc_2, ResourceManager.instance.getContent("tiptxt_history"), {key:PlayerEnum.TIPLINK_HISTORY_PLAY, vid:this.settimeInfo.vid, tm:this.settimeInfo.tm}, 1000, 6000, false);
				}
			}
			return;
		}// end function
		
		private function playerStart(event:OmsPlayerEvent) : void
		{
			event = event;
			AS3Debugger.Trace("_____________________________________start");
			ignoreSeekboard = false;
			ignoreMousewheel = false;
			skinManager.contrlBar.mouseChildren = true;
			endViewShowing = false;
			dispatchEvent(new Event("showMedia"));
			if (event.value.code == "resume")
			{
			}
			else if (event.value.code == "replay")
			{
			}
			else if (event.value.code == "startToPlay")
			{
				if (loadingswf && loadingswf.parent == this)
				{
					removeChild(loadingswf);
				}
				if (event.value.first == true)
				{
					if (event.value.changeformat == true)
					{
						return;
					}
					PlayerUtils.onPlayerMsg(PlayerEnum.PLAYERMSG_PLAY);
				}
				trace("showPlayMsgtip");
			}
			return;
		}// end function
		
		private function startTimerSave(param1:Number = 0) : void
		{
			var _loc_2:int = 0;
			var _loc_3:int = 0;
			if (!this.timerSave)
			{
				this.timerSave = TPTimer.setInterval(this.timerHistorySaveHandler, 10000);
			}
			if (!this.timerSave.isRunning())
			{
				this.timerSave.restart();
			}
			try
			{
				if (ExternalInterface.available && GlobalVars.objIdAllowed)
				{
					_loc_2 = videoPlayer.getDuration();
					_loc_3 = videoPlayer.getPlayTime();
					if (param1 != 0)
					{
						_loc_3 = param1;
					}
					if (!attractionStop)
					{
						ExternalInterface.call("_flash_view_history", -1, _loc_3, _loc_2);
					}
					else
					{
						ExternalInterface.call("_flash_view_history", 0, _loc_3, _loc_2);
					}
				}
			}
			catch (e:Error)
			{
			}
			return;
		}// end function
		
		private function timerHistorySaveHandler() : void
		{
			var _loc_1:int = 0;
			var _loc_2:int = 0;
			if (!attractionStop && (playerstatus == PlayerEnum.STATE_PLAYING || playerstatus == PlayerEnum.START_PAUSE))
			{
				try
				{
					if (ExternalInterface.available && GlobalVars.objIdAllowed)
					{
						_loc_1 = Math.floor(videoPlayer.getPlayTime());
						_loc_2 = videoPlayer.getDuration();
						ExternalInterface.call("_flash_view_history", -3, _loc_1, _loc_2);
					}
				}
				catch (e:Error)
				{
				}
			}
			return;
		}// end function
		
		private function onUncaughtError(event:UncaughtErrorEvent) : void
		{
			if (event.type == AsyncErrorEvent.ASYNC_ERROR || event.type == SecurityErrorEvent.SECURITY_ERROR)
			{
				event.preventDefault();
			}
			return;
		}// end function
		
		private function playerInitComplete(event:OmsPlayerEvent) : void
		{
			trace("INIT COMPLETE");
			this.removeEventListener(OmsPlayerEvent.INIT_COMPLETE, this.playerInitComplete);
			this.removeEventListener(OmsPlayerEvent.INIT_ERROR, this.playerInitError);
			orgWidth = stage.stageWidth;
			orgHeight = stage.stageHeight;
			if (GlobalVars.playerversion != PlayerEnum.TYPE_NORMAL)
			{
				orgWidth = 460;
				orgHeight = 372;
			}
			this.addStagekeyListener(true);
			ignoreSeekboard = true;
			ignoreMousewheel = true;
			if (this.txtError && this.txtError.parent == this)
			{
				this.removeChild(this.txtError);
			}
			this.playerInitPlay();
			return;
		}// end function
		
		private function playerLoad(event:OmsPlayerEvent) : void
		{
			if (loadingswf && skinManager.bigPlayBtn && loadingswf.parent != this && !currentVideoData.video_changeformat && !currentVideoData.video_autoseek && !currentVideoData.video_forceHttp)
			{
				this.addChildAt(loadingswf as DisplayObject, getChildIndex(skinManager.bigPlayBtn as DisplayObject));
			}
			return;
		}// end function
		
		private function playerInitPlay() : void
		{
			var _loc_1:String = null;
			
			setTimeout(this.addCallBackForJS, 100);//提供外部JS调用功能
			
			//this.autoPlay = true;
			if (this.autoPlay)
			{
				
				
				
				controlEnabled(false, false, true, false, true, false, false, false);
				skinManager.setDefinitionBtnEnable(false);
				this.checkAdBeforePlay();
			}
			else
			{
				dispatchEvent(new Event("showMedia"));
				adjustBigPlayBtn(true);
				controlEnabled(true, false, true, false, true, false, false, false);
				skinManager.setDefinitionBtnEnable(false);
				_loc_1 = this.vid;
				if (_loc_1.indexOf("|") > 0)
				{
					_loc_1 = _loc_1.split("|")[0];
				}
			}
			return;
		}// end function
		
		
		private function addCallBackForJS() : void
		{
			try
			{
				if (ExternalInterface.available && GlobalVars.objIdAllowed)
				{
					/*ExternalInterface.addCallback("loadAndPlayVideoFromVID", this.loadAndPlayVideoFromVID);
					ExternalInterface.addCallback("loadAndPlayVideoV2", this.loadAndPlayVideoV2);
					
					ExternalInterface.addCallback("stopVideo", this.js_stopVideo);
					ExternalInterface.addCallback("mute", this.js_muteHandler);
					ExternalInterface.addCallback("unmute", this.js_unmuteHandler);
					ExternalInterface.addCallback("loginCallback", this.js_loginCallback);
					ExternalInterface.addCallback("attractionUpdate", this.js_attractionUpdate);*/
					ExternalInterface.addCallback("pauseVideo", this.js_pauseVideo);
					ExternalInterface.addCallback("getPlaytime", this.js_getPlaytime);
					
					ExternalInterface.addCallback("jsPlaytime", this.js_getPausePlaytime);
					
					/*ExternalInterface.addCallback("setPlaytime", this.js_setPlaytime);
					ExternalInterface.addCallback("setNextEnable", this.js_setNextEnable);
					ExternalInterface.addCallback("setTitle", this.js_setTitle);
					ExternalInterface.addCallback("setFullScreen", this.js_setFullScreen);
					ExternalInterface.addCallback("setLightStatus", this.js_setLightStatus);
					ExternalInterface.addCallback("setFavoriteStatus", this.js_setFavoriteStatus);
					ExternalInterface.call("playerInit", ExternalInterface.objectID);*/
				}
			}
			catch (e:Error)
			{
			}
			return;
		}// end function
		
		private function js_pauseVideo() : Boolean
		{
			
			if (playerstatus == PlayerEnum.STATE_PLAYING)
			{
				btnPause(null);
			}
			return true;
		}// end function

		
		private function js_getPausePlaytime() : Number
		{
			
			var _loc_1:Number = 0;
			if (videoPlayer)
			{
				if (playerstatus == PlayerEnum.STATE_PLAYING)
				{
					btnPause(null);
				}
				
				_loc_1 = videoPlayer.getPlayTime();
			}
			return _loc_1;
		}// end function
		
		
		
		private function js_getPlaytime() : Number
		{
			var _loc_1:Number = 0;
			if (videoPlayer)
			{
				_loc_1 = videoPlayer.getPlayTime();
			}
			return _loc_1;
		}// end function
		
		private function checkAdBeforePlay() : void
		{
			rpt_adLoaded = 1;
			this.startToLPlay();
			return;
		}// end function
		
		private function startToLPlay(param1:int = 0) : void
		{
			controlEnabled(false, false, true, false, true, false, false, false);
			skinManager.setDefinitionBtnEnable(false);
			if (loadingswf)
			{
				loadingswf.resize(videoWidth, videoHeight);
				if (loadingswf.parent != this)
				{
					this.addChildAt(loadingswf as DisplayObject, getChildIndex(skinManager.bigPlayBtn as DisplayObject));
				}
				else
				{
					this.setChildIndex(loadingswf as DisplayObject, getChildIndex(skinManager.bigPlayBtn as DisplayObject));
				}
			}
			
			if (!this.checkVid(this.vid, this.duration) && (GlobalVars.xmlid==''))
			{
				showMsgTip("您请求的视频不存在！");
				if (loadingswf && loadingswf.parent == this)
				{
					removeChild(loadingswf);
				}
				this.playerReset();
				return;
			}
			AS3Debugger.Trace("vid=" + this.vid + ",attractionStart=" + this.attractionStart + ",attractionEnd=" + this.attractionEnd + ",historyStart=" + this.historyStart + ",moviestart=" + this.moviestart + ",movieend=" + this.movieend);
			adjustBigPlayBtn(false);
			if ((this.historyStart == 0 || this.historyStart == -1) && this.tstart > 0)
			{
				this.historyStart = this.tstart;
			}
			
			playVideo(this.arrayVid, param1, this.attractionStart, this.attractionEnd, this.historyStart, this.moviestart, this.movieend);
			return;
		}// end function
		
		public function playerReset() : void
		{
			skinManager.contrlBar.play_btn.state = "pause";
			adjustBigPlayBtn(true);
			controlEnabled(true, false, false, false, true, false, false, false);
			skinManager.setDefinitionBtnEnable(false);
			return;
		}// end function
		
		private function checkVid(param1:String, param2:String) : Boolean
		{
			var _loc_3:String = null;
			var _loc_4:String = null;
			var _loc_5:int = 0;
			if (param1.indexOf("|") != -1)
			{
				this.arrayVid = param1.split("|");
				if (param2.indexOf("0") != -1)
				{
					this.arrayDuration = param2.split("|");
				}
				else
				{
					this.arrayDuration = new Array();
					_loc_5 = 0;
					while (_loc_5 < this.arrayVid.length)
					{
						
						this.arrayDuration.push("0");
						_loc_5++;
					}
				}
			}
			else
			{
				this.arrayVid = new Array();
				this.arrayVid.push(param1);
				this.arrayDuration = new Array();
				_loc_3 = "0";
				if (param2 != "" && !isNaN(Number(param2.split("|")[0])))
				{
					_loc_3 = param2.split("|")[0];
				}
				this.arrayDuration.push(_loc_3);
			}
			var _loc_6:Boolean = true;
			var _loc_7:* = /[0-9]/;
			_loc_5 = 0;
			while (_loc_5 < this.arrayVid.length)
			{
				
				_loc_4 = this.arrayVid[_loc_5];
				if (!_loc_7.test(_loc_4))
				{
					_loc_6 = false;
					break;
				}
				_loc_5++;
			}
			return _loc_6;
		}// end function
		
		private function playerInitError(event:OmsPlayerEvent) : void
		{
			var event:* = event;
			event = event;
			this.removeEventListener(OmsPlayerEvent.INIT_COMPLETE, this.playerInitComplete);
			this.removeEventListener(OmsPlayerEvent.INIT_ERROR, this.playerInitError);
			setTimeout(function () : void
			{
				if (!txtError)
				{
					txtError = new TextField();
				}
				txtError.width = 350;
				txtError.htmlText = "<font size=\'16\' color=\'#ffffff\' face=\'宋体\'>" + ResourceManager.instance.getContent("skin_error") + "</font>";
				txtError.x = (playerWidth - txtError.textWidth) / 2;
				txtError.y = (playerHeight - txtError.textHeight) / 2;
				if (!contains(txtError))
				{
					addChild(txtError);
				}
				return;
			}// end function
				, 1000);
			return;
		}// end function
		
		private function addStagekeyListener(param1:Boolean = true) : void
		{
			if (!stage)
			{
				return;
			}
			if (!stage.hasEventListener(KeyboardEvent.KEY_UP))
			{
				stage.addEventListener(KeyboardEvent.KEY_UP, this.stageKeyDownHandler);
			}
			return;
		}// end function
		
		private function stageKeyDownHandler(event:KeyboardEvent) : void
		{
			if (!videoPlayer)
			{
				return;
			}
			switch(event.keyCode)
			{
				case Keyboard.SPACE:
				{
					if (!ignoreSpace)
					{
						try
						{
							stage.focus = this;
						}
						catch (e:Error)
						{
						}
						if (playerstatus == PlayerEnum.STATE_PLAYING)
						{
							btnPause();
						}
						else if (playerstatus == PlayerEnum.STATE_PAUSE)
						{
							btnPlay();
						}
					}
					break;
				}
				case Keyboard.LEFT:
				{
					keyStepHandler(false);
					break;
				}
				case Keyboard.RIGHT:
				{
					keyStepHandler(true);
					break;
				}
				case Keyboard.UP:
				{
					if (!ignoreUpDown)
					{
						this.volumeUp();
					}
					break;
				}
				case Keyboard.DOWN:
				{
					if (!ignoreUpDown)
					{
						this.volumeDown();
					}
					break;
				}
				case Keyboard.ENTER:
				{
					break;
				}
				default:
				{
					break;
					break;
				}
			}
			return;
		}// end function
		
		private function volumeUp() : void
		{
			var _loc_1:int = 0;
			if (skinManager.contrlBar && skinManager.contrlBar.sound && videoPlayer)
			{
				_loc_1 = videoPlayer.getVolume();
				if (_loc_1 < 100)
				{
					_loc_1 = GlobalVars.playerLocalInfo.volume + 10;
				}
				else
				{
					_loc_1 = GlobalVars.playerLocalInfo.volume + 50 > 500 ? (500) : (GlobalVars.playerLocalInfo.volume + 50);
				}
				this.setVolume(_loc_1, {type:"up"});
			}
			return;
		}// end function
		
		private function volumeDown() : void
		{
			var _loc_1:int = 0;
			if (skinManager.contrlBar && skinManager.contrlBar.sound && videoPlayer)
			{
				_loc_1 = videoPlayer.getVolume();
				if (_loc_1 < 100)
				{
					_loc_1 = GlobalVars.playerLocalInfo.volume - 10 < 0 ? (0) : (GlobalVars.playerLocalInfo.volume - 10);
				}
				else
				{
					_loc_1 = GlobalVars.playerLocalInfo.volume - 50;
				}
				this.setVolume(_loc_1, {type:"down"});
			}
			return;
		}// end function
		
		private function setVolume(param1:Number, param2:Object = null) : void
		{
			var _loc_3:* = param1;
			GlobalVars.playerLocalInfo.volume = _loc_3;
			videoPlayer.setVolume(_loc_3);
			try
			{
				skinManager.contrlBar.sound.setVolume(_loc_3 / 100, true, param2);
			}
			catch (e:Error)
			{
			}
			return;
		}// end function
		
		private function resizeHandler(event:Event = null) : void
		{
			playerWidth = stage.stageWidth;
			playerHeight = stage.stageHeight;
			if (playerWidth == 0)
			{
				playerWidth = 1;
			}
			if (playerHeight == 0)
			{
				playerHeight = 1;
			}
			videoWidth = playerWidth;
			if (skinManager.contrlBar && !isFullScreen)
			{
				videoHeight = playerHeight - skinManager.contrlBar.bg_mc.height;
			}
			else
			{
				videoHeight = playerHeight;
			}
			adjustPlayer(videoWidth, videoHeight);
			if (loadingswf)
			{
				loadingswf.resize(videoWidth, videoHeight);
			}
			this.adjustAD();
			return;
		}// end function
		
		public function adjustAD() : void
		{
			return;
		}// end function
		
		private function screenHanler(event:FullScreenEvent) : void
		{
			AS3Debugger.Trace("screenHanler::call");
			if (!event.fullScreen)
			{
				isFullScreen = false;
				adjustTopPanel();
				TweenLite.killTweensOf(skinManager.contrlBar);
				showCtrlBar(true, false);
				skinManager.contrlBar.full_btn.state = "normal";
			}
			this.resizeHandler();
			return;
		}// end function
		
	}
}
