package com.oms.tpv1.managers
{
	import com.greensock.*;
	import com.oms.tpv1.events.*;
	import com.oms.tpv1.model.*;
	import com.oms.tpv1.utils.*;
	import com.oms.videov3.ui.*;
	import com.sun.media.video.*;
	
	import flash.display.DisplayObject;
	import flash.events.*;
	
	//播放器皮肤管理
	public class SkinManagerV3 extends EventDispatcher
	{
		
		private var _playerSkin:PlayerSkin;
		private var _bigPlayBtn:Object;
		private var _cfgPanel:Object;
		private var _searchBar:Object;
		private var _toppanel:Object;
		private var _payPanel:Object;
		private var _timeTip:ToolTip;
		private var _msgTip:Object;
		private var _btnConfig:Object;
		private var _miniSeekbar:Object;
		public var headtailTip:ToolTip;
		private var _infoPanel:Object;
		private var _payTxt:Object;
		private var _vipTxt:Object;
		private var _logo:Object;
		private var _sharePanel:Object;
		private var _shareInsidePanel:Object;
		private var _btnNext:Object;
		private var _btnShareplay:Object;
		private var _msgPanel:Object;
		private var _btnDefinition:Object;
		private var _tipPanel:Object;
		private var _rightCfgMsg:Object;
		private var _definitionPanel:Object;
		private var _soundTip:ToolTip;
		private var _btnReplay:Object;
		public var currentSeekbarmode:Boolean = true;
		//public var playerSkin:* = new PlayerSkin();
		
		//播放器皮肤事件
		public function SkinManagerV3():void
		{
			this._playerSkin = PlayerSkin.getInstance();
			this._playerSkin.addEventListener(SkinEvent.SKIN_COMPLETE, this.completeHandler);
			this._playerSkin.addEventListener(SkinEvent.SKIN_ERROR, this.errorHandler);
			return;
		}// end function
		
		public function loadSkin() : void
		{
			//读取远程的皮肤地址
			
			var _loc_1:* = GlobalVars.playerSkinUrl;
			
			if (_loc_1.indexOf("http://") != -1)
			{
				_loc_1 = PlayerUtils.addUrlTail(_loc_1, "version=" + GlobalVars.verstionTail);
			}

			this._playerSkin.loadSkin(_loc_1);
			
			return;
		}// end function
		/*private function errorHandler(event:SkinEvent):void{
		
		return;	
		
		}//end function */
		//载入完成后，设置一些默认的按键信息
		private function completeHandler(event:SkinEvent) : void
		{
			

			
			this.playerSkin.removeEventListener(SkinEvent.SKIN_COMPLETE, this.completeHandler);
			this.playerSkin.removeEventListener(SkinEvent.SKIN_ERROR, this.errorHandler);
			
			
			var someobj:Object = {
								_bigPlayBtn:'bigPlay_btn',
								_definitionPanel:"definitionPanel",//清晰度
								_searchBar:"searchBar", 
								_rightCfgMsg:"rightcfg", 
								_cfgPanel:"cfgPanel", 
								_toppanel:"toppanel", 
								_infoPanel:"infoPanel",
								_sharePanel: "sharePanel", 
								_shareInsidePanel:"shareInside", 
								_btnShareplay:"btnshareplay", 
								_msgPanel:"msgPanel", 
								_tipPanel:"tippanel",
								_payPanel:"payPanel"
								};
			
			for (var i:String in someobj)
			{
				
				if (this.playerSkin.skin.hasOwnProperty(someobj[i] as String) && this.playerSkin.skin[someobj[i]] != undefined && this.playerSkin.skin[someobj[i]]!= null)
				{
					//var tmp_d:String = '_' + item;
					this[i] = this.playerSkin.skin[someobj[i]];
					
					
					
					
				}
				
			}
			
			
			//进度条上相关的变量初始化
			if (this.contrlBar)
			{

				var someobject2:Array = ["msgTip", "btnConfig", "payTxt", "vipTxt", "btnNext", "btnDefinition", "btnReplay", "miniSeekbar","logo"];
				for each(var item2:* in someobject2){
					//item = Math.random()
					if (this.contrlBar.hasOwnProperty(item2 as String) && this.contrlBar[item2])
					{
						var tmp_d2:String = '_' + item2;
						this[tmp_d2] = this.contrlBar[item2];
					}
					
				}
				
				
			
				

			}
			
			
			
			this._timeTip = new ToolTip(45, "Tahoma", 10, 1);
			this.headtailTip = new ToolTip(55, "宋体", 12, 0, 8882055);
			this._soundTip = new ToolTip(25, "Tahoma", 12, 0, 8882055);
			
			
			dispatchEvent(new SkinManagerV3Event(SkinManagerV3Event.SKIN_LOAD_COMPLETE)); //皮肤载入完成
			return;
		}// end function
		
		//搜索框
		private function searchhandler(event:Event) : void
		{
			return;
		}// end function
		
		//皮肤载入错误时
		private function errorHandler(event:SkinEvent):void
		{
			this.playerSkin.removeEventListener(SkinEvent.SKIN_COMPLETE, this.completeHandler);
			this.playerSkin.removeEventListener(SkinEvent.SKIN_ERROR, this.errorHandler);
			dispatchEvent(new SkinManagerV3Event(SkinManagerV3Event.SKIN_LOAD_ERROR));
			return;
		}// end function
		
		//提示信息
		/*
		 *1.显示的文字
		 *2.连接地址
		 *3.好像是对象
		*/
		public function showMsgTip(param1:String = "", param2:String = "", param3:Object = null) : void
		{
			var _loc_4:* = undefined;
			if (this.contrlBar && this.contrlBar.msgTip)
			{
				_loc_4 = this.contrlBar.msgTip;
				if (param1 != "")
				{
					_loc_4.msg_txt.text = param1;
					try
					{
						if (_loc_4.btnlink)
						{
							if (param2 == "")
							{
								_loc_4.btnlink.visible = false;
							}
							else
							{
								_loc_4.btnlink.reinit();
								_loc_4.btnlink.setLinkTxt(param2);
								_loc_4.btnlink.x = _loc_4.msg_txt.textWidth + 15;
								if (param3)
								{
									_loc_4.btnlink.linkData = param3;
								}
								_loc_4.btnlink.visible = true;
							}
						}
					}
					catch (e:Error)
					{
					}
					_loc_4.visible = true;
					
					TweenLite.to(_loc_4, 0.5, {alpha:1});
				
				}
				else
				{
					_loc_4.visible = false;
					_loc_4.alpha = 0;
				}
			}
			return;
		}// end function
		
		//中间大按键的位置,可以让他不显示,也可以让他显示在左下角,跟广告系统相关
		public function adjustBigPlayBtn(param1:Number, param2:Number, param3:Boolean = false, param4:Boolean = true) : void
		{
			if (this.bigPlayBtn == null)
			{
				return;
			}
			if (param3)
			{
				if (param4)
				{
					this.bigPlayBtn.x = (param1 - this.bigPlayBtn.width) / 2;
					this.bigPlayBtn.y = (param2 - this.bigPlayBtn.height) / 2;
				}
				else
				{
					this.bigPlayBtn.x = 19;
					this.bigPlayBtn.y = param2 - this.bigPlayBtn.height - 23;
				}
			}
			else
			{
				this.bigPlayBtn.x = 10000;
			}
			return;
		}// end function
		
		//控制按键的相关显示信息
		public function controlEnabled(param1:Boolean, param2:Boolean, param3:Boolean, param4:Boolean, param5:Boolean, param6:Boolean, param7:Boolean, param8:Boolean) : void
		{
			
			/*
			 * param1-8分别代表的可控按键包括
			
			播放，停止，全屏，跳，声音，
			6，7，8暂未知
			
			*/
			
			
			if (!this.playerSkin)
			{
				return;
			}
			
			try
			{
				PlayerUtils.setGray(this.playerSkin.skin.controlBar_mc.play_btn, param1);
				this.playerSkin.skin.controlBar_mc.play_btn.mouseChildren = param1;
				PlayerUtils.setGray(this.bigPlayBtn as DisplayObject, param1);
				this.bigPlayBtn.enabled = param1;
				
				
				
				
				PlayerUtils.setGray(this.playerSkin.skin.controlBar_mc.full_btn, param3);
				this.playerSkin.skin.controlBar_mc.full_btn.mouseChildren = param3;
				
				PlayerUtils.setGray(this.playerSkin.skin.controlBar_mc.stop_btn, param2);
				this.playerSkin.skin.controlBar_mc.stop_btn.mouseEnabled = param2;
				this.playerSkin.skin.controlBar_mc.stop_btn.mouseChildren = param2;
				
				PlayerUtils.setGray(this.playerSkin.skin.controlBar_mc.seekBar, param4);
				this.playerSkin.skin.controlBar_mc.seekBar.mouseEnabled = param4;
				this.playerSkin.skin.controlBar_mc.seekBar.mouseChildren = param4;
				
				PlayerUtils.setGray(this.playerSkin.skin.controlBar_mc.sound, param5);
				this.playerSkin.skin.controlBar_mc.sound.mouseEnabled = param5;
				this.playerSkin.skin.controlBar_mc.sound.mouseChildren = param5;
				
				PlayerUtils.setGray(this._btnConfig as DisplayObject, param6);
				this._btnConfig.mouseEnabled = param6;
				this._btnConfig.mouseChildren = param6;
				
				
				
			}catch (e:Error){
				
			}
			return;
		}// end function
		
		//清晰度设置
		public function setDefinitionBtnEnable(param1:Boolean) : void
		{
			try
			{
				if (this._btnDefinition)
				{
					//PlayerUtils.setGray(this._btnDefinition, param1);
					this._btnDefinition.mouseEnabled = param1;
				}
			}
			catch (e:Error)
			{
			}
			return;
		}// end function
		
		//下一个视频按键
		public function setNextbtnEnable(param1:Boolean) : void
		{
			try
			{
				if (this._btnNext)
				{
					//PlayerUtils.setGray(this._btnNext, param1);
					this._btnNext.mouseEnabled = param1;
					this._btnNext.mouseChildren = param1;
				}
			}
			catch (e:Error)
			{
			}
			return;
		}// end function
		
		//时间提示信息
		public function showTimeTip(param1:String) : void
		{
			this.playerSkin.skin.timeTip.tiptext = param1;
			return;
		}// end function
		
		//设置显示时间
		public function setShowTime(param1:String, param2:String, param3:String = "") : void
		{
			//trace('更新时间二');
			try
			{
				if (param3 == "00:00")
				{
					this.playerSkin.skin.shortTimeMode = true;
				}
				else if (param3 == "00:00:00")
				{
					this.playerSkin.skin.shortTimeMode = false;
				}
			}
			catch (e:Error)
			{
			}
			//这里是显示的时间相关跟进度条没有关系
			this.playerSkin.skin.setShowTime(param1, param2);
			return;
		}// end function
		
		//设置皮肤宽度等信息
		public function setSize(param1:Number, param2:Number, param3:Boolean):void
		{
			if (this.playerSkin)
			{
				this.playerSkin.setSize(param1, param2, param3);
			}
			if (this.timeTip)
			{
				this.timeTip.playerwidth = param1;
			}
			if (this.miniSeekbar)
			{
				this.miniSeekbar.setWidth(param1);
			}
			return;
		}// end function
		
		//最小化控制条
		public function gotoNormalSeekbarMode() : void
		{
			
			if (this._miniSeekbar)
			{
				this.currentSeekbarmode = true;
				this._miniSeekbar.visible = false;
				this.contrlBar.seekBar.visible = true;
				this.contrlBar.seekBar.alpha = 1;
			}
			return;
		}// end function
		
		//最小化按键的相关设置
		public function gotoMiniSeekbarMode() : void
		{
			
			if (this._miniSeekbar)
			{
				this.currentSeekbarmode = false;
				this._miniSeekbar.visible = true;
				this.contrlBar.seekBar.visible = false;
			}
			return;
		}// end function
		
		//获取控制条信息
		public function get contrlBar():Object
		{
			if (this._playerSkin == null || this._playerSkin.skin == null)
			{
				return null;
			}
			return this._playerSkin.skin.controlBar_mc;
		}// end function
		/*
		public function get playerSkin() : PlayerSkin
		{
		return this._playerSkin;
		}// end function
		*/
		//最大化按键
		public function get bigPlayBtn():Object
		{
			return this._bigPlayBtn;
		}// end function
		//顶部提示
		public function get topPanel():Object
		{
			return this._toppanel;
		}// end function
		//右侧
		
		public function get rightCfgMsg():Object
		{
			return this._rightCfgMsg;
			
		}// end function
		//配置信息
		public function get cfgPanel():Object
		{
			return this._cfgPanel;
		}// end function
		//搜索框
		public function get searchBar():Object
		{
			return this._searchBar;
		}// end function
		//支付窗口
		public function get payPanel():Object
		{
			return this._payPanel;
		}// end function
		//时间窗口
		public function get timeTip() : ToolTip
		{
			return this._timeTip;
		}// end function
		//声音提示
		public function get soundTip() : ToolTip
		{
			return this._soundTip;
		}// end function
		//消息提示
		public function get msgTip():Object
		{
			return this._msgTip;
		}// end function
		//按键配置
		public function get btnConfig():Object
		{
			return this._btnConfig;
		}// end function
		
		public function get miniSeekbar():Object
		{
			return this._miniSeekbar;
		}// end function
		
		public function get infoPanel():Object
		{
			return this._infoPanel;
		}// end function
		
		public function get payTxt():Object
		{
			return this._payTxt;
		}// end function
		
		public function get vipTxt():Object
		{
			return this._vipTxt;
		}// end function
		
		/*public function get logo():Object
		{
			return this._logo;
		}// end function*/
		
		public function get sharePanel():Object
		{
			return this._sharePanel;
		}// end function
		
		public function get shareInside():Object
		{
			return this._shareInsidePanel;
		}// end function
		
		public function get btnNext():Object
		{
			return this._btnNext;
		}// end function
		
		public function get btnShareplay():Object
		{
			return this._btnShareplay;
		}// end function
		
		public function get btnDefinition():Object
		{
			return this._btnDefinition;
		}// end function
		
		public function get tipPanel():Object
		{
			return this._tipPanel;
		}// end function
		
		public function get definitionPanel():Object
		{

			return this._definitionPanel;
			
			
		}// end function
		
		public function get msgPanel():Object
		{
			return this._msgPanel;
		}// end function
		
		public function get btnReplay():Object
		{
			return this._btnReplay;
		}// end function
		
		public function get playerSkin():PlayerSkin
		{
			return this._playerSkin;
		}
		
		
	}
}