package com.oms.videov3.common
{
	import com.koma.utils.*;
	import com.oms.utils.timer.*;
	import com.oms.videov3.events.*;
	import com.sun.events.*;
	import com.sun.net.*;
	import com.sun.utils.*;
	//import com.sun.video.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.external.*;
	import flash.net.*;
	
	public class PlayerActivity extends Sprite
	{
		//private var cfgPath:String = "http://imgcache.qq.com/qqlive/conf/playerlottery/playerlottery.xml?max_age=43200&t=20130627";
		//private var cfgPath:String = "http://172.24.26.32/omsplayer/xml/playerlottery.xml?max_age=43200&t=20130627";
		private var cfgPath:String = "http://v.kankanews.com/data/player_xml/playerlottery.xml?max_age=43200&t=20130627";
		private var cfgLoaded:Boolean = false;
		private var cfgFld:FileLoader;
		private var cfgCheckLogin:Boolean = true;
		private var cfgCloseCount:uint = 1;
		private var cfgVids:String = "";
		private var currVid:String;
		private var currCid:String;
		private var checkObjId:Boolean = true;
		//private var activityCgi:String = "http://ncgi.video.qq.com/tvideo/fcgi-bin/avwblock?blockid=11&t=1";
		private var activityCgi:String = "";
		private var cgiloader:FileLoader;
		private var fld:FileLoader;
		private var linkLoder:FileLoader;
		public var starttime:Number = 240;
		public var endtime:Number = 255;
		private var orgheight:Number = 85;
		private var orgwidth:Number = 187;
		private var link:String = "";
		private var url:String = "";
		//private var reporturl:String = "http://ncgi.video.qq.com/tvideo/fcgi-bin/autolot?blockid=11&t=1";
		private var reporturl:String = "";
		private var reportClick:String;
		private var currPlayAd:Loader;
		//private var btnclose:BtnClose;
		private var showing:Boolean = false;
		public var dataOk:Boolean = false;
		private var myso:MySharedObject;
		private var soArray:Array;
		private var max_uin:int = 5;
		private var uin:String = "";
		private var timer:TPTimer;
		private var timeCount:uint = 0;
		private var timeStarted:Boolean = false;
		private var skey:String = "";
	
		
		public function PlayerActivity(param1:Boolean = true)
		{
			this.checkObjId = param1;
			return;
		}// end function
		
		public function create(param1:String = "", param2:String = "") : void
		{
			this.destory();
			this.buttonMode = false;
			this.currVid = param2;
			this.currCid = param1;
			this.checkCfg();
			return;
		}// end function
		
		private function checkCfg() : void
		{
			if (!this.cfgLoaded)
			{
				if (!this.cfgFld)
				{
					this.cfgFld = new FileLoader();
					var _loc_1:int = 5000;
					this.cfgFld.loadTimeout = 5000;
					this.cfgFld.requestTimeout = _loc_1;
				}
				if (!this.cfgFld.hasEventListener(NLoaderEvent.LOAD_COMPLETE))
				{
					this.cfgFld.addEventListener(NLoaderEvent.LOAD_COMPLETE, this.onCfgLoaded);
					this.cfgFld.addEventListener(NLoaderEvent.LOAD_ERROR, this.onCfgError);
				}
				this.cfgFld.load(this.cfgPath, "URLRequest", URLLoaderDataFormat.TEXT, null, "GET");
			}
			else
			{
				this.loadLottoryCgi();
			}
			return;
		}// end function
		
		private function onCfgLoaded(event:NLoaderEvent) : void
		{
			var xml:XML;
			var event:* = event;
			this.cfgFld.removeEventListener(NLoaderEvent.LOAD_COMPLETE, this.onCfgLoaded);
			this.cfgFld.removeEventListener(NLoaderEvent.LOAD_ERROR, this.onCfgError);
			var str:* = event.value.data;
			try
			{
				xml = XML(str);
			}
			catch (e:Error)
			{
				xml;
			}
			var info:* = XMLUtils.toObject(xml);
			if (!info || !info.root || !info.root.vids)
			{
				this.cfgLoaded = false;
				dispatchEvent(new PlayerActivityEvent("create_error"));
			}
			this.cfgLoaded = true;
			this.cfgVids = info.root.vids;
			if (info.root.login == "0")
			{
				this.cfgCheckLogin = false;
			}
			else
			{
				this.cfgCheckLogin = true;
			}
			if (info.root.closecount && !isNaN(Number(info.root.closecount)))
			{
				this.cfgCloseCount = Number(info.root.closecount);
			}
			else
			{
				this.cfgCloseCount = 3;
			}
			this.loadLottoryCgi();
			return;
		}// end function
		
		private function onCfgError(event:NLoaderEvent) : void
		{
			this.cfgFld.removeEventListener(NLoaderEvent.LOAD_COMPLETE, this.onCfgLoaded);
			this.cfgFld.removeEventListener(NLoaderEvent.LOAD_ERROR, this.onCfgError);
			this.cfgLoaded = false;
			dispatchEvent(new PlayerActivityEvent("create_error"));
			return;
		}// end function
		
		public function destory() : void
		{
			try
			{
				if (this.cgiloader)
				{
					this.cgiloader.close();
				}
			}
			catch (e:Error)
			{
				
				if (this.fld)
				{
					this.fld.close();
				}
			}
			catch (e:Error)
			{
				
				if (this.cfgFld)
				{
					if (this.cfgFld.hasEventListener(NLoaderEvent.LOAD_COMPLETE))
					{
						this.cfgFld.removeEventListener(NLoaderEvent.LOAD_COMPLETE, this.onCfgLoaded);
						this.cfgFld.removeEventListener(NLoaderEvent.LOAD_ERROR, this.onCfgError);
					}
					this.cfgFld.close();
				}
			}
			catch (e:Error)
			{
				
				if (this.linkLoder)
				{
					this.linkLoder.close();
				}
			}
			catch (e:Error)
			{
			}
			while (this.numChildren > 0)
			{
				
				this.removeChildAt(0);
			}
			if (this.currPlayAd && this.link)
			{
				this.buttonMode = false;
				if (this.currPlayAd.hasEventListener(MouseEvent.CLICK))
				{
					this.currPlayAd.removeEventListener(MouseEvent.CLICK, this.clickHandler);
				}
				this.currPlayAd = null;
			}
			this.showing = false;
			this.dataOk = false;
			this.timeStarted = false;
			this.uin = "";
			if (this.timer)
			{
				this.timer.stop();
			}
			return;
		}// end function
		//好像是用用户相关的.这个地方,后面再想法先干掉了.
		
		private function loadLottoryCgi() : void
		{
			var login:Boolean;
			var localinfo:Object;
			var uininfo:Object;
			var i:int;
			if (this.cfgVids == null || this.cfgVids == "" || this.currVid == "")
			{
				return;
			}
			if (this.currCid != "" && this.cfgVids.indexOf(this.currCid) != -1 || this.cfgVids.indexOf(this.currVid) != -1)
			{
				this.skey = "";
				if (this.cfgCheckLogin)
				{
					login;
					try
					{
						if (ExternalInterface.available)
						{
							login = ExternalInterface.call("txv.login.isLogin");
							this.uin = ExternalInterface.call("txv.login.getUin");
						}
					}
					catch (e:Error)
					{
						login;
						uin = "";
					}
					AS3Debugger.Trace("PlayerActivity:: is login?" + login + ",uin=" + this.uin);
					if (!login || this.uin == "0")
					{
						return;
					}
					try
					{
						if (ExternalInterface.available)
						{
							this.skey = ExternalInterface.call("Live.cookie.get", "skey");
						}
					}
					catch (e:Error)
					{
						skey = "";
					}
					if (this.skey != "")
					{
						this.skey = "&skey=" + this.skey;
					}
				}
				if (this.cfgCloseCount > 0)
				{
					if (!this.myso)
					{
						this.myso = new MySharedObject();
					}
					localinfo = this.myso.read("playactivity");
					if (localinfo && localinfo.activity != undefined && localinfo.activity != null && localinfo.activity is Array)
					{
						this.soArray = localinfo.activity;
						i;
						while (i < this.soArray.length)
						{
							
							uininfo = this.soArray[i];
							if (uininfo.time == this.getdatestr() && uininfo.uin == this.uin && uininfo.code == "10" && uininfo.count && uininfo.count >= (this.cfgCloseCount - 1))
							{
								return;
							}
							i = (i + 1);
						}
					}
					else
					{
						this.soArray = new Array();
					}
				}
				if (!this.timer)
				{
					this.timer = TPTimer.setInterval(this.onTimer, 1000);
				}
				this.timer.stop();
				this.timeCount = 0;
				if (!this.cgiloader)
				{
					this.cgiloader = new FileLoader();
					this.cgiloader.loadTimeout = 5000;
					this.cgiloader.requestTimeout = 5000;
				}
				if (!this.cgiloader.hasEventListener(NLoaderEvent.LOAD_COMPLETE))
				{
					this.cgiloader.addEventListener(NLoaderEvent.LOAD_COMPLETE, this.urlLoadCompleteHandler);
					this.cgiloader.addEventListener(NLoaderEvent.LOAD_ERROR, this.urlLoadErrorHandler);
				}
				this.activityCgi = this.activityCgi + this.skey;
				if (this.currCid != "")
				{
					this.activityCgi = this.activityCgi + ("&cid=" + this.currCid);
				}
				if (this.currVid != "")
				{
					this.activityCgi = this.activityCgi + ("&vid=" + this.currVid);
				}
				this.activityCgi = this.activityCgi + ("&r=" + Math.random());
				AS3Debugger.Trace("PlayerActivity::activityCgi=" + this.activityCgi);
				this.cgiloader.load(this.activityCgi, "URLRequest", URLLoaderDataFormat.TEXT, null, "GET");
			}
			return;
		}// end function
		
		private function urlLoadCompleteHandler(event:NLoaderEvent) : void
		{
			var _loc_4:RegExp = null;
			var _loc_5:String = null;
			this.cgiloader.removeEventListener(NLoaderEvent.LOAD_COMPLETE, this.urlLoadCompleteHandler);
			this.cgiloader.removeEventListener(NLoaderEvent.LOAD_ERROR, this.urlLoadErrorHandler);
			var _loc_2:* = event.value.data;
			AS3Debugger.Trace("PlayerActivity::urlLoadCompleteHandler " + _loc_2);
			var _loc_3:* = this.getXmlinfo(_loc_2);
			if (!_loc_3)
			{
				AS3Debugger.Trace("PlayerActivity::urlLoadCompleteHandler 状态异常，不参与活动");
				dispatchEvent(new PlayerActivityEvent("create_error"));
				return;
			}
			if (_loc_3.st && _loc_3.et && !isNaN(_loc_3.st * 1) && !isNaN(_loc_3.et * 1) && _loc_3.st * 1 < _loc_3.et * 1)
			{
				this.starttime = _loc_3.st * 1;
				this.endtime = _loc_3.et * 1;
			}
			if (_loc_3.width && _loc_3.height && !isNaN(_loc_3.width * 1) && !isNaN(_loc_3.height * 1))
			{
				this.orgwidth = _loc_3.width * 1;
				this.orgheight = _loc_3.height * 1;
			}
			if (_loc_3.link)
			{
				this.link = _loc_3.link;
			}
			else
			{
				this.link = "";
			}
			if (_loc_3.report)
			{
				_loc_4 = RegExp("http://[^/]+.qq.com/S*");
				_loc_5 = ("" + _loc_3.report);
				if (_loc_4.test(_loc_5.toLocaleLowerCase()))
				{
					this.reporturl = "" + _loc_3.report;
				}
			}
			this.reportClick = this.addUrlTail(this.reporturl, "v=20130617" + this.skey);
			if (_loc_3.url)
			{
				this.url = _loc_3.url;
			}
			if (this.link != "" && this.link != null || this.reportClick != "" && this.reportClick != null)
			{
				this.buttonMode = true;
			}
			else
			{
				this.buttonMode = false;
			}
			this.dataOk = true;
			this.showing = false;
			this.timeStarted = true;
			this.timer.restart();
			return;
		}// end function
		
		private function addUrlTail(param1:String, param2:String) : String
		{
			if (param1.indexOf("?") == -1)
			{
				return param1 + "?" + param2;
			}
			return param1 + "&" + param2;
		}// end function
		
		private function urlLoadErrorHandler(event:NLoaderEvent) : void
		{
			if (this.cgiloader && this.cgiloader && this.cgiloader.hasEventListener(NLoaderEvent.LOAD_COMPLETE))
			{
				this.cgiloader.removeEventListener(NLoaderEvent.LOAD_COMPLETE, this.urlLoadCompleteHandler);
				this.cgiloader.removeEventListener(NLoaderEvent.LOAD_ERROR, this.urlLoadErrorHandler);
			}
			if (this.fld && this.fld.hasEventListener(NLoaderEvent.LOAD_COMPLETE))
			{
				this.fld.removeEventListener(NLoaderEvent.LOAD_COMPLETE, this.loaderCompleteHandler);
				this.fld.removeEventListener(NLoaderEvent.LOAD_ERROR, this.urlLoadErrorHandler);
			}
			AS3Debugger.Trace("PlayerActivity::urlLoadErrorHandler 请求CGI或者下载素材失败");
			dispatchEvent(new PlayerActivityEvent("create_error"));
			return;
		}// end function
		
		private function loaderCompleteHandler(event:NLoaderEvent) : void
		{
			this.fld.removeEventListener(NLoaderEvent.LOAD_COMPLETE, this.loaderCompleteHandler);
			this.fld.removeEventListener(NLoaderEvent.LOAD_ERROR, this.urlLoadErrorHandler);
			this.currPlayAd = event.value.loader;
			if (this.currPlayAd && (this.link || this.reportClick))
			{
				this.currPlayAd.mouseChildren = false;
				if (!this.currPlayAd.hasEventListener(MouseEvent.CLICK))
				{
					this.currPlayAd.addEventListener(MouseEvent.CLICK, this.clickHandler);
				}
				if (this.currPlayAd.parent != this)
				{
					this.addChild(this.currPlayAd);
				}
			}
			/*if (!this.btnclose)
			{
				this.btnclose = new BtnClose();
				this.btnclose.addEventListener(MouseEvent.CLICK, this.closeHandler);
			}
			if (this.btnclose.parent != this)
			{
				AS3Debugger.Trace("PlayerActivity::orgwidth=" + this.orgwidth);
				this.btnclose.x = this.orgwidth - 20;
				this.btnclose.y = 5;
				this.addChild(this.btnclose);
			}*/
			AS3Debugger.Trace("PlayerActivity::loaderCompleteHandler 下载素材成功，显示");
			dispatchEvent(new PlayerActivityEvent("create_succ"));
			return;
		}// end function
		
		private function clickHandler(event:MouseEvent) : void
		{
			
			/*if (this.reportClick != "" && this.reportClick != null && this.skey != "")
			{
				StatDot.dataForServer(null, this.reportClick, "GET");
			}*/
			
			if (this.link != "" && this.link != null)
			{
				navigateToURL(new URLRequest(this.link), "_blank");
			}
			this.destory();
			dispatchEvent(new PlayerActivityEvent("click_activity", {link:this.link, report:this.reportClick}));
			return;
		}// end function
		
		private function closeHandler(event:MouseEvent) : void
		{
			var _loc_3:Object = null;
			if (this.uin == "")
			{
				return;
			}
			if (!this.myso)
			{
				this.myso = new MySharedObject();
			}
			if (!this.soArray)
			{
				this.soArray = new Array();
			}
			if (this.soArray.length > this.max_uin)
			{
				this.soArray.splice(this.max_uin, this.soArray.length - this.max_uin);
			}
			if (this.soArray.length == this.max_uin)
			{
				this.soArray.shift();
			}
			var _loc_2:* = this.getdatestr();
			var _loc_4:int = 0;
			var _loc_5:* = this.soArray.length - 1;
			while (_loc_5 >= 0)
			{
				
				_loc_3 = this.soArray[_loc_5];
				if (this.uin == _loc_3.uin)
				{
					if (_loc_3.count != null && _loc_3.count != undefined && !isNaN(Number(_loc_3.count)))
					{
						_loc_4 = Number(_loc_3.count);
						_loc_4 = _loc_4 + 1;
					}
					this.soArray.splice(_loc_5, 1);
					break;
				}
				_loc_5 = _loc_5 - 1;
			}
			this.soArray.push({uin:this.uin, code:"10", time:_loc_2, count:_loc_4});
			try
			{
				this.myso.save("playactivity", null, {activity:this.soArray});
			}
			catch (e:Error)
			{
			}
			this.destory();
			dispatchEvent(new PlayerActivityEvent("close_activity"));
			return;
		}// end function
		
		private function getXmlinfo(param1:String) : Object
		{
			var xml:XML;
			var str:* = param1;
			try
			{
				xml = XML(str);
			}
			catch (e:Error)
			{
				xml;
			}
			if (xml == null)
			{
				return null;
			}
			var info:* = XMLUtils.toObject(xml);
			if (!info || !info.root || !info.root.data || !info.root.data.material || !info.root.result || info.root.result.code == null)
			{
				return null;
			}
			var code:* = info.root.result.code;
			if (code != "0")
			{
				return null;
			}
			var material:* = info.root.data.material;
			if (material.url == null)
			{
				return null;
			}
			material.url = material.url.toLowerCase();
			if (material.url.indexOf(".swf") == -1 && material.url.indexOf(".png") == -1)
			{
				return null;
			}
			return material;
		}// end function
		
		private function getdatestr() : String
		{
			var _loc_1:* = new Date();
			var _loc_2:* = _loc_1.getFullYear().toString() + _loc_1.getMonth().toString() + _loc_1.getDate().toString();
			return _loc_2;
		}// end function
		
		private function onTimer() : void
		{
			
			this.timeCount = this.timeCount + 1;
			if (!this.dataOk)
			{
				return;
			}
			if (this.timeCount >= this.starttime && !this.showing)
			{
				this.showing = true;
				dispatchEvent(new PlayerActivityEvent("show_activity"));
				if (this.url == "" || this.url == null)
				{
					return;
				}
				if (this.fld == null)
				{
					this.fld = new FileLoader();
					this.fld.requestTimeout = 3000;
					this.fld.loadTimeout = 3000;
				}
				if (!this.fld.hasEventListener(NLoaderEvent.LOAD_COMPLETE))
				{
					this.fld.addEventListener(NLoaderEvent.LOAD_COMPLETE, this.loaderCompleteHandler);
					this.fld.addEventListener(NLoaderEvent.LOAD_ERROR, this.urlLoadErrorHandler);
				}
				this.fld.load(this.url);
			}
			if (this.timeCount > this.endtime && this.showing)
			{
				this.showing = false;
				this.destory();
				dispatchEvent(new PlayerActivityEvent("hide_activity"));
			}
			return;
		}// end function
		
		public function pauseTimer() : void
		{
			if (this.timeStarted && this.timer && this.timer.isRunning())
			{
				this.timer.stop();
			}
			return;
		}// end function
		
		public function resumeTimer() : void
		{
			if (this.timeStarted && this.timer && !this.timer.isRunning())
			{
				this.timer.restart();
			}
			return;
		}// end function
	}
}