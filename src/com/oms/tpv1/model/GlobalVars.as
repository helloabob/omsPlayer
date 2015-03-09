package com.oms.tpv1.model
{
	import __AS3__.vec.*;
	
	import com.gridsum.VideoTracker.VodPlay;
	import com.oms.report.ReportManager;
	import com.oms.tpv1.managers.*;
	import com.oms.tpv1.utils.*;
	
	import flash.net.NetStream;
	
	//标准全屏控制,全局变量
	public class GlobalVars extends Object
	{
		public static var flvtitle:String = "OMS视频系统";
		public static var covertitle:String = "";
		public static var usingHost:String = "";
		public static var objIdAllowed:Boolean = true;
		public static var playerversion:int = 0;
		public static var playertype:int = 0;
		public static var isPayedVideo:Boolean = false;
		public static var isPreviewVideo:Boolean = false;
		public static var payedVideoStatus:String = "";
		public static var pay:int = 0;
		public static var previewDuration:Number = 300; //未付费可以播放的时长
		public static var isAutoFormat:Boolean = true;
		public static var userSelFormat:String = "";
		public static var FormatSel:String = "";
		public static var autoFormatType:int = 1;
		public static var preformat:String = "0";
		public static var currformat:Object = "0";
		public static var preformatName:String = "0";
		//public static var ispAc:String = "0";
		public static var showShare:Boolean = true;
		public static var showEnd:Boolean = true;
		public static var showCfg:Boolean = true;
		public static var showRightPanel:Boolean = false;
		public static var showSearch:Boolean = true;
		public static var showSearchPanel:Boolean = true;
		public static var showBook:Boolean = false;
		public static var showLightCfg:Boolean = true;
		public static var showScaleCfg:Boolean = true;
		public static var showHeadTailCfg:Boolean = true;
		public static var showPopUpCfg:Boolean = true;
		public static var showFavoriteCfg:Boolean = true;
		public static var showNext:Boolean = false;
		public static var showformat:Boolean = true;
		public static var showTipAd:Boolean = true;
		public static var isPopUp:Boolean = false;
		public static var showlogo:Boolean = false;
		//public static var adplay:Boolean = true;
		public static var outvt:int = -1;
		public static var uid:String = "";
		
		//全局变量
		public static var omsid:Number = 0;
		public static var xmlid:String = '';
		public static var autoPlay:Boolean = true;
		public static var videoWebChannel:String = '看看新闻网/OMS';//统计用格式化路径
		public static var keyword:String = '看看新闻网/OMS'
		
		//统计用
		public static var _player:NetStream = null;
		public static var _playertime:Number = 0;
		public static var _Videotime:Number = 0;
		public static var _Nowtime:Number = 0;
		public static var _vodPlay:VodPlay = null;
		
		
		//public static var cgi_get_videoinfo:String = "http://v.kankanews.com/index.php?app=api&mod=public&act=flash_getinfo";
		public static var cgi_get_videoinfo:String = "http://v.kankanews.com/index.php?app=api&mod=public&act=flash_getinfo";
		//public static var cgi_get_videoinfo:String = "http://172.24.26.32/flash/getinfo/info.xml";
		
		//public static var cgi_get_key:String = "http://172.24.26.32/flash/getkey.php";
		
		//public static var loadingUrl:String = "http://172.24.26.32/oms/web_default_loading.swf";
		public static var loadingUrl:String = "http://player.kksmg.com/data/player_swf/md_loading.swf";
		//public static var loadingUrl:String = "http://61.152.223.175/data/flash/Loading.swf";
		
		
		
		//public static var cgi_get_videoinfo:String = "http://61.152.222.178:8033/index.php?app=api&mod=public&act=flash_getinfo";
		
		
		//public static var cgi_get_videoinfo:String = "http://172.24.26.32/flash/c.php";
		
		//public static var cgi_get_key:String = "http://vv.video.qq.com/getkey";
		
		public static var cgi_get_key:String = "http://v.kankanews.com/index.php?app=api&mod=public&act=getkey";
		
		public static var cgi_get_videoclip:String = "http://vv.video.qq.com/getclip";
		
		//public static var playerSkinUrl:String = "http://imgcache.qq.com/minivideo_v1/vd/res/skins/TencentPlayerSkinV3.swf";
		
		public static var playerSkinUrl:String = "http://172.24.26.32/oms/TencentPlayerSkinV3.swf";//本地测试
		
		public static var WebReport:String = "http://v.kankanews.com/index.php?app=api&mod=Report&act=web_report" //开始播放时的统计 WEBreport
		
		
		public static var endviewUrl:String = "http://172.24.26.32/flash/tpendviewv3.swf";
		
		//public static var multiRptCgi:String = "http://v.kankanews.com/index.php?app=api&mod=Report&act=bplay";
		
		public static var multiRptCgi:String = "http://v.kankanews.com/index.php?app=api&mod=Public&act=bplay";
		
		//public static var heart:String = "http://v.kankanews.com/index.php?app=api&mod=Report&act=heart";
		public static var heart:String = "http://v.kankanews.com/index.php?app=api&mod=Public&act=heart";
		
		
		
		//public static var loadingUrl:String = "http://imgcache.qq.com/minivideo_v1/vd/res/skins/web_default_loading.swf";
		
		
		//自己增加的
		
		
		public static var exid:String = "0";//反馈,统计用
		public static var timeDisplayFormat:String = "00:00";
		public static var stageVideoUsing:Boolean = false;
		public static var stageVideoRequired:Boolean = false;
		public static var playerLocalInfo:PlayerLocalInfo;
		public static var playerLocalSpeed:PlayerLocalSpeed;
		public static var pid:String;
		
		public static var rid:String;
		public static var coverid:String = "";
		public static var typeid:String = "";
		public static var cdntype:String = "";
		public static var speedObj:Object;
		public static var clsBufferCount:int = 0;
		public static var clspeed:Number = 0;
		public static var showbarFullscreen:Boolean = true;
		public static var homepage:String = "http://www.kankanews.com";
		public static var homepages:Array = ["http://www.kankanews.com"];
		public static var Capabilities:String = "";
		public static var majorVersion:String = "";
		public static var minorVersion:String = "";
		public static var jumptime:int = 15;
		public static var resumetime:int = 10;
		public static var currip:String = "";
		public static var report_infotime:Number = 0;
		public static var report_timer:Number = 0;
		public static var browserType:int = 0;
		public static var ptag:String = "";
		public static var refer:String = "";
		public static var playerDebug:Boolean = false;
		public static var enabelGetClip:Boolean = true;
		public static var arrayClspeed:Array = [];
		public static var arrayClspeedMaxLen:int = 10;
		public static var urlformat:String = "";
		public static var currLoadMethod:int = 2;
		public static var useTipPanel:Boolean = true;
		//public static var arrayTipLevelInfo:Vector.<TipBmLevelInfo>; 下边的那缩略图
		public static var useVideoLogo:Boolean = false;
		
		//public static var p2pStreamType:int = StreamFactory.STREAMTYPE_NATIVE;
		//public static var p2pVersion:String = "";
		
		public static var forceStreamType:int = -1;
		public static var forceHardware:Boolean = false;
		public static var arraySplitTime:Array;
		public static var dicStFormat:Object;
		
		
		
		public static var helpurl:String = "http://www.kankanews.com/kankannews/help/abouts/2012-02-20/4.html";
		public static var feedbackurl:String = "http://www.kankanews.com/kankannews/help/abouts/2012-02-20/4.html";
		
		
		public static var reportplay:String = "#";
		
		
		
		public function GlobalVars()
		{
			return;
		}// end function
		
		public static function get version() : String
		{
			//return PlayerUtils.getPlayerVersion(playerversion);
			var tmpstr:String = '123';
			return tmpstr;
		}// end function
		
		public static function get verstionTail() : String
		{
			//return PlayerUtils.getPlayerVersionTail(playerversion);
			var tmpstr:String = '123';
			return tmpstr;
		}// end function
		
	}
}