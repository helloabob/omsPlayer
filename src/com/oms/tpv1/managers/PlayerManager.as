package com.oms.tpv1.managers
{
	
	import com.oms.tpv1.media.*;
	import com.oms.tpv1.media.players.*;
	import com.oms.tpv1.model.*;
	import com.oms.tpv1.resource.*;
	import com.oms.tpv1.utils.*;
	
	
	public class PlayerManager extends Object
	{
		public function PlayerManager()
		{
			return;
		}// end function
		
		//调用不同播放器内核,这里其实,大有文章可作的.可以扩展增加一些比如HLS的内核播放器等.
		public static function getVideoPlayer(param1:int) : BaseVideoPlayer
		{
			//根据参数调用不同的video容器，这里可以增加基于HLS的插件播放器
			var _loc_2:BaseVideoPlayer = null;
			
			_loc_2 = new HttpVideoPlayer();
			return _loc_2;
		}// end function
		
		//检测外部分享时使用的播放器文件名
		public static function checkPlayerVersion(param1:String) : int
		{
			
			
			return PlayerEnum.TYPE_NORMAL;
		}// end function
		
		
		/*
		*根据播放器版本参数，定义类似广告，前后贴片等广告信息 
		*/
		public static function checkPlayerCfg(param1:int) : void
		{
			
			switch(param1)
			{
				case PlayerEnum.TYPE_NORMAL:
				{
					GlobalVars.playerSkinUrl = PlayerEnum.SKINURL_DEFAULT_V4; //设定皮肤,前后贴,广告语言等
					GlobalVars.showEnd = true;
					GlobalVars.showSearch = false;
					GlobalVars.showLightCfg = true;
					GlobalVars.showPopUpCfg = true;
					GlobalVars.showShare = true;
					//GlobalVars.adplay = false;
					ResourceManager.instance.setResource(ResourceManager.zh_cn);
					break;
				}
				case PlayerEnum.TYPE_OUTSIDE:
				{
					GlobalVars.playerSkinUrl = PlayerEnum.SKINURL_OUT_V4;
					GlobalVars.showEnd = true;
					GlobalVars.showSearch = true;
					GlobalVars.showPopUpCfg = false;
					GlobalVars.showLightCfg = false;
					GlobalVars.showShare = true;
					//GlobalVars.adplay = true;
					ResourceManager.instance.setResource(ResourceManager.zh_cn);
					break;
				}
				case PlayerEnum.TYPE_SWFOUTSIDE:
				{
					GlobalVars.playerSkinUrl = PlayerEnum.SKINURL_OUT_V4;
					GlobalVars.showEnd = false;
					GlobalVars.showSearch = true;
					GlobalVars.showPopUpCfg = false;
					GlobalVars.showLightCfg = false;
					GlobalVars.showShare = false;
					//GlobalVars.adplay = false;
					ResourceManager.instance.setResource(ResourceManager.zh_cn);
					break;
				}
				case PlayerEnum.TYPE_QZONE:
				{
					GlobalVars.playerSkinUrl = PlayerEnum.SKINURL_OUT_V4;
					GlobalVars.showEnd = true;
					GlobalVars.showSearch = true;
					GlobalVars.showPopUpCfg = false;
					GlobalVars.showLightCfg = false;
					GlobalVars.showShare = true;
					//GlobalVars.adplay = false;
					ResourceManager.instance.setResource(ResourceManager.zh_cn);
					break;
				}
				case PlayerEnum.TYPE_TVB:
				{
					GlobalVars.playerSkinUrl = PlayerEnum.SKINURL_TVB;
					GlobalVars.loadingUrl = PlayerEnum.LOADING_TVB;
					GlobalVars.showEnd = false;
					GlobalVars.showSearch = false;
					GlobalVars.showPopUpCfg = false;
					GlobalVars.showLightCfg = false;
					GlobalVars.showShare = false;
					//GlobalVars.adplay = false;
					ResourceManager.instance.setResource(ResourceManager.zh_hk);
					break;
				}
				case PlayerEnum.TYPE_MV:
				{
					GlobalVars.playerSkinUrl = PlayerEnum.SKINURL_DEFAULT_V4;
					GlobalVars.showEnd = false;
					GlobalVars.showSearch = false;
					GlobalVars.showLightCfg = false;
					GlobalVars.showPopUpCfg = false;
					GlobalVars.showLightCfg = false;
					GlobalVars.showShare = false;
					//GlobalVars.adplay = false;
					ResourceManager.instance.setResource(ResourceManager.zh_cn);
					break;
				}
				default:
				{
					break;
				}
			}
			return;
		}// end function
		
		//调用不进的载入动画,同时设置是否显示相关 层 包括一些全局参数
		public static function adjustPlayerCfg(param1:int) : void
		{
			var _loc_2:* = PlayerUtils.checkVarsSkinPath(GlobalVars.playerSkinUrl);
			var _loc_3:* = PlayerUtils.checkVarsLoadingPath(GlobalVars.loadingUrl);
			if (!_loc_3)
			{
				GlobalVars.loadingUrl = PlayerEnum.LOADING_DEFAULT;
			}
			switch(param1)
			{
				case PlayerEnum.TYPE_NORMAL:
				{
					GlobalVars.showSearch = false;
					GlobalVars.showScaleCfg = true;
					GlobalVars.showHeadTailCfg = true;
					//GlobalVars.adplay = true;
					if (!_loc_2 || GlobalVars.playerSkinUrl == PlayerEnum.SKINURL_DEFAULT)
					{
						GlobalVars.playerSkinUrl = PlayerEnum.SKINURL_DEFAULT_V4;
					}
					break;
				}
				case PlayerEnum.TYPE_OUTSIDE:
				{
					GlobalVars.showScaleCfg = true;
					GlobalVars.showHeadTailCfg = false;
					//GlobalVars.adplay = true;
					if (!_loc_2 || GlobalVars.playerSkinUrl == PlayerEnum.SKINURL_OUT)
					{
						GlobalVars.playerSkinUrl = PlayerEnum.SKINURL_OUT_V4;
					}
					break;
				}
				case PlayerEnum.TYPE_SWFOUTSIDE:
				{
					GlobalVars.showScaleCfg = true;
					GlobalVars.showHeadTailCfg = false;
					GlobalVars.showLightCfg = false;
					GlobalVars.showPopUpCfg = false;
					GlobalVars.showEnd = false;
					GlobalVars.showShare = false;
					//GlobalVars.adplay = false;
					if (!_loc_2 || GlobalVars.playerSkinUrl == PlayerEnum.SKINURL_OUT)
					{
						GlobalVars.playerSkinUrl = PlayerEnum.SKINURL_OUT_V4;
					}
					break;
				}
				case PlayerEnum.TYPE_QZONE:
				{
					GlobalVars.cgi_get_videoinfo = "http://uv.video.qq.com/qzgetinfo";
					GlobalVars.cgi_get_key = "http://uv.video.qq.com/qzgetkey";
					GlobalVars.showScaleCfg = true;
					GlobalVars.showHeadTailCfg = false;
					//GlobalVars.adplay = false;
					GlobalVars.showSearch = false;
					GlobalVars.showEnd = false;
					if (!_loc_2 || GlobalVars.playerSkinUrl == PlayerEnum.SKINURL_OUT)
					{
						GlobalVars.playerSkinUrl = PlayerEnum.SKINURL_OUT_V4;
					}
					break;
				}
				case PlayerEnum.TYPE_TVB:
				{
					GlobalVars.showScaleCfg = true;
					GlobalVars.showHeadTailCfg = false;
					GlobalVars.showEnd = false;
					GlobalVars.showShare = false;
					//GlobalVars.adplay = false;
					if (!_loc_2)
					{
						GlobalVars.playerSkinUrl = PlayerEnum.SKINURL_TVB;
					}
					if (!_loc_3)
					{
						GlobalVars.loadingUrl = PlayerEnum.LOADING_TVB;
					}
					break;
				}
				case PlayerEnum.TYPE_MV:
				{
					GlobalVars.showSearch = false;
					GlobalVars.showScaleCfg = true;
					GlobalVars.showRightPanel = false;
					GlobalVars.showHeadTailCfg = false;
					GlobalVars.showEnd = false;
					GlobalVars.showShare = false;
					//GlobalVars.adplay = true;
					if (!_loc_2 || GlobalVars.playerSkinUrl == PlayerEnum.SKINURL_DEFAULT)
					{
						GlobalVars.playerSkinUrl = PlayerEnum.SKINURL_DEFAULT_V4;
					}
					break;
				}
				default:
				{
					break;
				}
			}
			if (GlobalVars.playerSkinUrl.indexOf("TencentPlayerMiniSkin") != -1)
			{
				GlobalVars.loadingUrl = PlayerEnum.LOADING_MINI;
				GlobalVars.showbarFullscreen = false;
			}
			if (GlobalVars.playerSkinUrl.indexOf("QQPlayerSkin.swf") != -1)
			{
				GlobalVars.playerSkinUrl = PlayerEnum.SKINURL_OUT;
			}
			if (GlobalVars.playerSkinUrl == PlayerEnum.SKINURL_OUT)
			{
				GlobalVars.playerSkinUrl = PlayerEnum.SKINURL_OUT_V4;
			}
			else if (GlobalVars.playerSkinUrl == PlayerEnum.SKINURL_DEFAULT)
			{
				GlobalVars.playerSkinUrl = PlayerEnum.SKINURL_DEFAULT_V4;
			}
			else if (GlobalVars.playerSkinUrl == PlayerEnum.SKINURL_MINI)
			{
				GlobalVars.playerSkinUrl = PlayerEnum.SKINURL_MINI_V4;
			}
			else if (GlobalVars.playerSkinUrl == PlayerEnum.SKINURL_NBA)
			{
				GlobalVars.playerSkinUrl = PlayerEnum.SKINURL_NBA_V4;
			}
			return;
		}// end function
	}
}