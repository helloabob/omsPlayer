package com.oms.tpv1.model
{
	//播放器相关信息
	public class PlayerEnum extends Object
	{
		public static const STATE_STOP:int = 0;
		public static const STATE_PLAYING:int = 1;
		public static const STATE_PAUSE:int = 2;
		public static const STATE_BUFFERRING:int = 3;
		public static const STATE_REQUESTING:int = 4;
		public static const STATE_SEEKING:int = 5;
		public static const STATE_SEEKED:int = 6;
		public static const TYPE_NORMAL:int = 0;
		public static const TYPE_OUTSIDE:int = 1;
		public static const TYPE_CNTV:int = 2;
		public static const TYPE_SWFOUTSIDE:int = 3;
		public static const TYPE_QZONE:int = 4;
		public static const TYPE_TVB:int = 5;
		public static const TYPE_MV:int = 6;
		public static const TYPE_NBAVIP:int = 7;
		public static const TYPE_TPCOMPONENT:int = 8;
		public static const ST_ERROR_GETURL:int = 0;
		public static const ST_ERROR_ARGS:int = 1;
		public static const ST_ERROR_UNALLOW:int = 2;
		public static const PLAYERROR_PLAYINIT:int = 2;
		public static const PLAYERROR_UNRECOVERY:int = 3;
		public static const FT_MP4:int = 0;
		public static const FT_FLV:int = 1;
		public static const FT_UNKNOW:int = 2;
		public static const ERROR_DEFAULT:int = 0;
		public static const ERROR_PLAY:int = 1;
		public static const START_PLAY:int = 0;
		public static const START_PAUSE:int = 1;
		public static const FORMAT_SHD:String = "shd";
		public static const FORMAT_HD:String = "hd";
		public static const FORMAT_SD:String = "sd";
		public static const FORMAT_FHD:String = "fhd";
		public static const FORMAT_AUTO:String = "auto";
		public static const TIPLINK_HISTORY:int = 0;
		public static const TIPLINK_HEADTAIL:int = 1;
		public static const TIPLINK_REFRESH:int = 2;
		public static const TIPLINK_PAY:int = 3;
		public static const TIPLINK_TIPAD:int = 4;
		public static const TIPLINK_FORMAT:int = 5;
		public static const TIPLINK_PAYPANEL:int = 6;
		public static const TIPLINK_HISTORY_PLAY:int = 7;
		public static const LOGIN_SHARE:String = "1";
		public static const BROWSER_UNKNOWN:int = 0;
		public static const BROWSER_MSIE:int = 1;
		public static const BROWSER_FF:int = 2;
		public static const BROWSER_CHROME:int = 3;
		public static const BROWSER_OPERA:int = 4;
		public static const BROWSER_SAFARI:int = 5;
		public static const BROWSER_OTHER:int = 6;
		
		//皮肤跟LOADING动画
		public static const SKINURL_DEFAULT:String = "http://172.24.26.32/omsplayer/skin/TencentPlayerSkinV3.swf";
		public static const SKINURL_OUT:String = "http://172.24.26.32/omsplayer/skin/TencentPlayerOutSkinV3.swf";
		public static const SKINURL_MINI:String = "http://172.24.26.32/omsplayer/skin/TencentPlayerMiniSkin.swf";
		public static const SKINURL_NBA:String = "http://172.24.26.32/omsplayer/skin/TPSkin_NBA.swf";
		public static const SKINURL_TVB:String = "http://172.24.26.32/omsplayer/skin/qqplayertvb_skinV3.swf";
		public static const SKINURL_OUT_V4:String = "http://172.24.26.32/omsplayer/skin/TencentPlayerOutSkinV4.swf";
		public static const SKINURL_MINI_V4:String = "http://172.24.26.32/omsplayer/skin/TencentPlayerMiniSkinV4.swf";
		public static const SKINURL_NBA_V4:String = "http://172.24.26.32/omsplayer/skin/nba_skinv4.swf";
		
		public static const LOADING_MINI:String = "http://172.24.26.32/omsplayer/skin/web_small_loading.swf";
		public static const LOADING_TVB:String = "http://172.24.26.32/omsplayer/skin/loadingtvb.swf";
		public static const LOADING_NOLOGO:String = "http://172.24.26.32/omsplayer/skin/nologo_loading.swf";
		
		//public static const SKINURL_DEFAULT_V4:String = "http://61.152.223.175/data/flash/PlayerSkinV4.swf";
		
		//public static const SKINURL_DEFAULT_V4:String = "http://172.24.26.32/flash/skin/nba_skinv4-1.swf";
		//public static const SKINURL_DEFAULT_V4:String = "http://172.24.26.32/flash/skin/TPSkin_NBA-1.swf";
		
		
		
		public static const SKINURL_DEFAULT_V4:String = "http://player.kksmg.com/data/player_swf/PlayerSkinV4c.swf";//当前应用的皮肤
		
//		public static const SKINURL_DEFAULT_V4:String = "http://172.24.26.32/flash/skin/sm.swf";//当前应用的皮肤
		
		//PlayerSkinV6.swf
		
		//public static const SKINURL_DEFAULT_V4:String = "http://player.kksmg.com/data/player_swf/TPSkin_NBA.swf"; //当前应用的皮肤
		
		//public static const SKINURL_DEFAULT_V4:String = "http://172.24.26.32/omsplayer/skin/TPSkin_NBA.swf"; //当前应用的皮肤
		
		
		
		//public static const SKINURL_DEFAULT_V4:String = "http://172.24.26.32/PlayerSkinV4.swf";
		
		public static const LOADING_DEFAULT:String = "http://player.kksmg.com/data/player_swf/Loading.swf";
		
		
		
		

		
		//public static const LOADING_DEFAULT:String = "http://172.24.26.32/omsplayer/skin/web_default_loading.swf";
		//public static const SKINURL_DEFAULT_V4:String = "http://61.152.222.178:8033/data/flash/PlayerSkinV4.swf";
		//public static const LOADING_DEFAULT:String = "http://61.152.222.178:8033/data/flash/Loading.swf";
		//public static const LOADING_DEFAULT:String = "http://172.24.26.32/omsplayer/skin/web_default_loading.swf";
		//public static const SKINURL_DEFAULT_V4:String = "http://172.24.26.32/flash/TencentPlayerOutSkinV4.swf";
		//public static const SKINURL_DEFAULT_V4:String = "http://172.24.26.32/omsplayer/skin/TencentPlayerSkinV4.swf";
		//public static const SKINURL_DEFAULT_V4:String = "http://172.24.26.32/omsplayer/skin/TencentPlayerSkinV4.swf";
		
		public static const LOADMETHOD_PAY:int = 100;
		public static const LOADMETHOD_NORMAL:int = 2;
		public static const FAVORITE_CLICK_PLAYER:String = "player";
		public static const FAVORITE_CLICK_END:String = "endview";
		public static const PLAYERMSG_PLAY:int = 0;
		public static const PLAYERMSG_PAUSE:int = 1;
		public static const PLAYERMSG_STOP:int = 2;
		
		public function PlayerEnum()
		{
			return;
		}// end function
	}
}