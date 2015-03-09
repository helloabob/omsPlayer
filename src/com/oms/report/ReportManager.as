package com.oms.report
{
	import __AS3__.vec.*;
	
	import com.oms.tpv1.media.players.*;
	import com.oms.tpv1.model.*;
	import com.oms.tpv1.utils.*;
	import com.oms.utils.*;
	import com.oms.utils.timer.*;
	import com.sun.events.*;
	import com.sun.net.*;
	import com.sun.utils.*;
	
	import flash.net.*;
	import flash.utils.*;
	
	//信息反馈功能
	//可以认为是全局的REPORT
	public class ReportManager extends Object
	{
		public static const PLAY_LOWSPEED:int = 71;
		public static const PLAY_ERROR:Number = 9000000;
		public static const STEP_GETINFO:int = 1011;
		public static const GETINFO_UNKNOWN:int = 0;
		public static const GETINFO_SUCC:int = 1;
		public static const GETINFO_HTTPERROR:int = 2;
		public static const GETINFO_CGIERROR:int = 3;
		public static const STEP_GETKEY:int = 1003;
		public static const GETKEY_UNKNOWN:int = 0;
		public static const GETKEY_SUCC:int = 1;
		public static const GETKEY_HTTPERROR:int = 2;
		public static const GETKEY_CGIERROR:int = 3;
		public static const STEP_GETSPEED:int = 1012;
		public static const GETSPEED_UNKNOWN:int = 0;
		public static const GETSPEED_SUCC:int = 1;
		public static const GETSPEED_HTTPERROR:int = 2;
		public static const GETSPEED_CGIERROR:int = 3;
		public static const STEP_GETCLIP:int = 1017;
		public static const GETCLIP_UNKNOWN:int = 0;
		public static const GETCLIP_SUCC:int = 1;
		public static const GETCLIP_HTTPERROR:int = 2;
		public static const GETCLIP_CGIERROR:int = 3;
		public static const GETKEY_NOKEY_PAYED:int = 100;
		public static const STEP_PLAYCOUNT:int = 4;
		public static const STEP_PLAYLOADING:int = 6;
		public static const STEP_REQUEST_FIRST:int = 30;
		public static const STEP_REQUEST_NOFIRST:int = 50;
		public static const STEP_REQUEST_SEEK:int = 60;
		public static const STEP_RESPONSE_SEEK:int = 63;
		public static const STEP_REQUEST_CHANGEFMT:int = 100;
		public static const REQUEST_FIRST_SUCC:int = 0;
		public static const REQUEST_FIRST_FAILED:int = 1;
		public static const REQUEST_CHANGEDURL_SUCC:int = 4;
		public static const REQUEST_CHANGEDURL_FAILED:int = 5;
		public static const REQUEST_NOKEY_SUCC:int = 6;
		public static const REQUEST_NOKEY_FAILED:int = 7;
		public static const STEP_BUFFERTIME_FIRST:int = 31;
		public static const STEP_BUFFERTIME_NOFIRST:int = 51;
		public static const STEP_BUFFERTIME_SEEK:int = 61;
		public static const STEP_BUFFERTIME_CHANGEFMT:int = 101;
		public static const BUFFERTIME_MORE10:int = 1;
		public static const BUFFERTIME_LESS10:int = 0;
		public static const STEP_BUFFERCOUNT_FIRST:int = 32;
		public static const STEP_BUFFERCOUNT_NOFIRST:int = 52;
		public static const STEP_BUFFERCOUNT_SEEK:int = 62;
		public static const STEP_BUFFERCOUNT_CHANGEFMT:int = 102;
		public static const STEP_ACTION_PAUSE:int = 301;
		public static const STEP_ACTION_PLAY:int = 302;
		public static const STEP_ACTION_SEEK:int = 303;
		public static const STEP_REQUESTERROR_FIRST:int = 34;
		public static const STEP_REQUESTERROR_NOFIRST:int = 54;
		public static const STEP_REQUESTERROR_SEEK:int = 64;
		public static const STEP_REQUESTERROR_CHANGEFMT:int = 104;
		public static const REQUESTERROR_DOWMLOAD_CODE:int = 606;
		public static const REQUESTERROR_PLAY_CODE:int = 607;
		public static const FORMAT_SEL:int = 0;
		public static const FORMAT_AUTO:int = 1;
		public static const STEP_USER_FIRST:int = 35;
		public static const STEP_USER_NOFIRST:int = 55;
		public static const STEP_LDER_FIRST:int = 36;
		public static const STEP_LDER_NOFIRST:int = 56;
		public static const STEP_LDER_SEEK:int = 66;
		public static const STEP_LDER_CHANGEFMT:int = 106;
		public static const STEP_LOAD_SKIN:int = 400;
		public static const STEP_LOAD_LOADING:int = 401;
		public static const STEP_LOAD_AD:int = 402;
		public static const STEP_LOAD_EV:int = 403;
		public static const STEP_LOAD_COVER:int = 404;
		public static const STEP_CDN_TEST:int = 500;
		public static const CDN_TEST_SUCC:int = 1;
		public static const CDN_TEST_FAIL:int = 2;
		public static const CDN_CODE_IO:int = 600;
		public static const CDN_CODE_SECURITY:int = 601;
		public static const STEP_PAY:int = 501;
		public static const STEP_CAPTURE_PICPARAM:int = 1013;
		public static const STEP_CAPTURE_PIC:int = 1014;
		public static const STEP_PREVIEW_PIC:int = 1015;
		public static const STEP_UPLOAD_PIC:int = 1016;
		public static const PIC_SUCC:int = 1;
		public static const PIC_HTTPERROR:int = 2;
		public static const PIC_CGIERROR:int = 3;
		public static const DLTYPE_HTTP:int = 1;
		public static const DLTYPE_P2P:int = 2;
		public static const STEP_TIP:int = 405;
		public static const STEP_AID:int = 1020;
		public static const STEP_P2PPLUGIN:int = 406;
		public static const STEP_BUFFERSTOP:int = 304;
		public static const STEP_ST_LOAD:int = 1037;
		public static const STEP_ST_SRT:int = 407;
		public static const STEP_CHANGEURL_ERROR_FIRST:int = 37;
		public static const STEP_CHANGEURL_ERROR_NOFIRST:int = 57;
		public static const STEP_CHANGEURL_ERROR_SEEK:int = 67;
		public static const STEP_CHANGEURL_ERROR_CNGFMT:int = 107;
		
		//private static var singleRptCgi:String = "http://172.24.26.32/flash/b.php";
		//private static var multiRptCgi:String = "http://rcgi.video.qq.com/report/bplay";
		//private static var multiRptCgi:String = "http://172.24.26.32/flash/bplay.php";
		//private static var multiRptCgi:String = "http://61.152.222.178:8033/index.php?app=api&mod=public&act=bplay";
		//private static var multiRptCgi:String = "http://172.24.26.32/flash/a.php";
		
		
		//private static var multiRptCgi:String = "http://61.152.223.175/index.php?app=api&mod=public&act=bplay";
		
		
		private static var arrayReportMode:Vector.<ReportMode> = new Vector.<ReportMode>;
		private static const MAXREPORT_COUNT:int = 3;
		public static var reportStaticPara:ReportMode;
		private static var tptimer:TPTimer;
		private static var info:Object;
		private static var index:uint = 0;
		private static var heartobj:Object;
		private static var hearttime:Number;
		
		public function ReportManager()
		{
			return;
		}// end function
		
		public static function getReporttime(b:String='1') : void
		{
			var _loc_1:* = new FileLoader();
			_loc_1.loadTimeout = 3000;
			_loc_1.requestTimeout = 3000;
			if (!_loc_1.hasEventListener(NLoaderEvent.LOAD_COMPLETE))
			{
				_loc_1.addEventListener(NLoaderEvent.LOAD_COMPLETE, getTimeCompleteHandler);
				_loc_1.addEventListener(NLoaderEvent.LOAD_ERROR, getTimeErrorHandler);
			}
			
			_loc_1.load(GlobalVars.multiRptCgi, "URLRequest", URLLoaderDataFormat.TEXT, {"gt":b});
			return;
		}// end function
		
		private static function getTimeCompleteHandler(event:NLoaderEvent) : void
		{
			var _loc_3:XML = null;
			event.currentTarget.removeEventListener(NLoaderEvent.LOAD_COMPLETE, getTimeCompleteHandler);
			event.currentTarget.removeEventListener(NLoaderEvent.LOAD_ERROR, getTimeErrorHandler);
			var _loc_2:* = event.value.data;
			try
			{
				_loc_3 = XML(_loc_2);
			}
			catch (e:Error)
			{
			}
			if (_loc_3 == null)
			{
				return;
			}
			var _loc_4:* = String(_loc_3.t);
			if (String(_loc_3.t) == "" || isNaN(Number(_loc_4)))
			{
				return;
			}
			var _loc_5:* = new Date();
			
			
			GlobalVars.report_infotime = Number(_loc_4) * 1000 + _loc_5.milliseconds;
			GlobalVars.report_timer = getTimer();
		
			return;
		}// end function
		
		private static function getTimeErrorHandler(event:NLoaderEvent) : void
		{
			event.currentTarget.removeEventListener(NLoaderEvent.LOAD_COMPLETE, getTimeCompleteHandler);
			event.currentTarget.removeEventListener(NLoaderEvent.LOAD_ERROR, getTimeErrorHandler);
			return;
		}// end function
		
		public static function createReportMode(param1:int, param2:int, param3:int, param4:int, param5:Number = 0, param6:String = "", param7:String = "", param8:String = "0", param9:Number = 0, param10:int = 0, param11:String = "0", param12:String = "", param13:String = "", param14:Object = null) : ReportMode
		{
			if (!reportStaticPara)
			{
				reportStaticPara = new ReportMode();
			}
			var _loc_15:* = reportStaticPara.copy();
			reportStaticPara.copy().autoformat = GlobalVars.isAutoFormat?1:0;
			_loc_15.url = GlobalVars.usingHost;
			_loc_15.step = param1;
			_loc_15.val = param2;
			_loc_15.val1 = param3;
			_loc_15.val2 = param4;
			if (GlobalVars.report_infotime == 0)
			{
				_loc_15.ctime = PlayerUtils.getCurrTime();
			}
			else
			{
				_loc_15.ctime = PlayerUtils.getCurrtimeByTime(GlobalVars.report_infotime + getTimer() - GlobalVars.report_timer);
			}
			_loc_15.ptime = Math.floor(param5 * 1000).toString();
			_loc_15.type = param8;
			_loc_15.vt = param9;
			_loc_15.idx = param10;
			_loc_15.level = param11;
			_loc_15.emsg = param12;
			if (param14 && param14.usingP2P)
			{
				_loc_15.dltype = DLTYPE_P2P;
			}
			else
			{
				_loc_15.dltype = DLTYPE_HTTP;
			}
			if (param6 != "")
			{
				_loc_15.vid = param6;
			}
			if (param7 != "")
			{
				_loc_15.format = param7;
			}
			if (param13 != "")
			{
				_loc_15.defn = param13;
			}
			_loc_15.clspeed = GlobalVars.clspeed;
			_loc_15.predefn = GlobalVars.preformatName;
			_loc_15.preformat = GlobalVars.preformat;
			_loc_15.index = index + 1;
			return _loc_15;
		}// end function
		
		public static function createReportModeByVideoMode(param1:int, param2:int, param3:int, param4:int, param5:Number = 0, param6:VideoPlayModeV3 = null) : ReportMode
		{
			var _loc_7:* = reportStaticPara.copy();
			_loc_7.autoformat = GlobalVars.isAutoFormat ? (1) : (0);
			_loc_7.url = GlobalVars.usingHost;
			_loc_7.step = param1;
			_loc_7.val = param2;
			_loc_7.val1 = param3;
			_loc_7.val2 = param4;
			if (GlobalVars.report_infotime == 0)
			{
				_loc_7.ctime = PlayerUtils.getCurrTime();
			}
			else
			{
				_loc_7.ctime = PlayerUtils.getCurrtimeByTime(GlobalVars.report_infotime + getTimer() - GlobalVars.report_timer);
			}
			_loc_7.clspeed = GlobalVars.clspeed;
			if (param6)
			{
				_loc_7.vid = param6.getVid();
				_loc_7.vt = param6.getVtype();
				_loc_7.format = param6.getVideoFormat();
				_loc_7.idx = param6.idx;
				_loc_7.type = param6.rtype;
				_loc_7.vurl = param6.requestPath;
				_loc_7.buffersize = param6.buffersize;
				_loc_7.rid = param6.rid;
				_loc_7.bi = param6.requestTimeCount;
				_loc_7.level = param6.level;
				_loc_7.defn = param6.formatName;
				//if (param6.usingP2P)
				//{
				//	_loc_7.dltype = DLTYPE_P2P;
				//}
				//else
				//{
					_loc_7.dltype = DLTYPE_HTTP;
				//}
			}
			_loc_7.ptime = Math.floor(param5 * 1000).toString();
			_loc_7.predefn = GlobalVars.preformatName;
			_loc_7.preformat = GlobalVars.preformat;
			_loc_7.index = index + 1;
			return _loc_7;
		}// end function
		
		public static function addReport(param1:ReportMode, param2:Boolean = false) : void
		{
			checkFlushBeforeAdd(param1);
			arrayReportMode.push(param1);
			if (param2 || arrayReportMode.length >= MAXREPORT_COUNT)
			{
				flushReport();
			}
			if (!tptimer)
			{
				tptimer = TPTimer.setInterval(flushReport, 60000);
			}
			if (!tptimer.isRunning())
			{
				tptimer.restart();
			}
			return;
		}// end function
		
		private static function checkFlushBeforeAdd(param1:ReportMode) : void
		{
			var _loc_2:ReportMode = null;
			var _loc_3:int = 0;
			//while (_loc_3 < arrayReportMode.length)
			
			while (_loc_3 < arrayReportMode.length)
			{
				
				_loc_2 = arrayReportMode[_loc_3];
				if (_loc_2.pid != param1.pid)
				{
					flushReport();
					return;
				}
				_loc_3++;
			}
			return;
		}// end function
		
		public static function flushReport(param1:Boolean = false) : void
		{
			trace('------------------');
			trace('----------flushReport--------');
			trace('------------------');
			
			var _loc_2:ReportMode = null;
			if (arrayReportMode.length == 0)
			{
				return;
			}
			info = new Object();
			var _loc_3:int = 0;
			
			while (_loc_3 < arrayReportMode.length)
			{
				
				_loc_2 = arrayReportMode[_loc_3];
				if (_loc_3 == 0)
				{
					info.bt = _loc_2.bt;
					info.version = _loc_2.version;
					info.cpay = _loc_2.cpay;
					info.platform = _loc_2.platform;
					info.cmid = _loc_2.cmid;
					info.pid = _loc_2.pid;
					info.url = _loc_2.url;
					info.pfversion = _loc_2.pfversion;
					info.ptag = _loc_2.ptag;
					info.pversion = _loc_2.pverion;
				}
				info.autoformat = addMutiNumValue(_loc_3, _loc_2.autoformat, info.autoformat);//终于找到这里了..不容易呀.
				info.step = addMutiNumValue(_loc_3, _loc_2.step, info.step);
				info.vid = addMutiStrValue(_loc_3, _loc_2.vid, info.vid);
				info.vt = addMutiNumValue(_loc_3, _loc_2.vt, info.vt);
				info.level = addMutiStrValue(_loc_3, _loc_2.level, info.level);
				info.emsg = addMutiStrValue(_loc_3, _loc_2.emsg, info.emsg);
				info.type = addMutiStrValue(_loc_3, _loc_2.type, info.type);
				info.val = addMutiNumValue(_loc_3, _loc_2.val, info.val);
				info.val1 = addMutiNumValue(_loc_3, _loc_2.val1, info.val1);
				info.val2 = addMutiNumValue(_loc_3, _loc_2.val2, info.val2);
				info.bi = addMutiNumValue(_loc_3, _loc_2.bi, info.bi);
				info.vurl = addMutiStrValue(_loc_3, _loc_2.vurl, info.vurl);
				info.rid = addMutiStrValue(_loc_3, _loc_2.rid, info.rid);
				info.clspeed = addMutiNumValue(_loc_3, _loc_2.clspeed, info.clspeed);
				info.buffersize = addMutiNumValue(_loc_3, _loc_2.buffersize, info.buffersize);
				info.loadwait = addMutiNumValue(_loc_3, _loc_2.loadwait, info.loadwait);
				info.bufferwait = addMutiNumValue(_loc_3, _loc_2.bufferwait, info.bufferwait);
				info.format = addMutiStrValue(_loc_3, _loc_2.format, info.format);
				info.idx = addMutiNumValue(_loc_3, _loc_2.idx, info.idx);
				info.ispac = addMutiStrValue(_loc_3, _loc_2.ispac, info.ispac);
				info.ctime = addMutiStrValue(_loc_3, _loc_2.ctime, info.ctime);
				info.ptime = addMutiStrValue(_loc_3, _loc_2.ptime, info.ptime);
				info.exid = addMutiStrValue(_loc_3, _loc_2.exid, info.exid);
				info.preformat = addMutiStrValue(_loc_3, _loc_2.preformat, info.preformat);
				info.predefn = addMutiStrValue(_loc_3, _loc_2.predefn, info.predefn);
				info.defn = addMutiStrValue(_loc_3, _loc_2.defn, info.defn);
				info.tpay = addMutiStrValue(_loc_3, _loc_2.tpay, info.tpay);
				info.index = addMutiNumValue(_loc_3, _loc_2.index, info.index);
				info.dltype = addMutiNumValue(_loc_3, _loc_2.dltype, info.dltype);
				_loc_3++;
			}
			info.rnum = arrayReportMode.length;
			info.ran = Math.random();
			StatDot.dataForServer(info, GlobalVars.multiRptCgi, "POST");
			arrayReportMode.splice(0, arrayReportMode.length);
			return;
		}// end function
		
		private static function addMutiStrValue(param1:int, param2:String, param3:* = null) : String
		{
			var _loc_4:* = param1 == 0 ? (param2) : ("$" + param2);
			if (param3 != null && param3 != undefined && param3 is String)
			{
				_loc_4 = param3 + _loc_4;
			}
			return _loc_4;
		}// end function
		
		private static function addMutiNumValue(param1:int, param2:Number, param3:* = null) : String
		{
			param2 = Math.floor(param2 * 100) / 100;
			var _loc_4:* = param1 == 0 ? (param2.toString()) : ("$" + param2.toString());
			if (param3 != null && param3 != undefined && param3 is String)
			{
				_loc_4 = param3 + _loc_4;
			}
			return _loc_4;
		}// end function
		
		public static function heartReportStart(param1:String, param2:String, param3:Number, param4:String) : void
		{
			heartobj = {format:param1, type:param2, vt:param3, pid:param4, platform:1};
			hearttime = -1;
			return;
		}// end function
		
		public static function heartReportOnTime(param1:String, param2:String, param3:Number) : void
		{
			if (!heartobj)
			{
				return;
			}
			if (hearttime == -1 || getTimer() - hearttime > 60000)
			{
				hearttime = getTimer();
				heartobj.step = 1;
				heartobj.format = param1;
				heartobj.type = param2;
				heartobj.vt = param3;
				StatDot.dataForServer(heartobj, GlobalVars.heart, "POST");
			}
			return;
		}// end function
		
		public static function heartReportEnd(param1:String, param2:String, param3:Number) : void
		{
			if (!heartobj)
			{
				return;
			}
			heartobj.step = 2;
			heartobj.format = param1;
			heartobj.type = param2;
			heartobj.vt = param3;
			StatDot.dataForServer(heartobj, GlobalVars.heart, "POST");
			heartobj = null;
			return;
		}// end function
	}
}