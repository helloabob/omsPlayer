package com.oms.tpv1.managers
{
	import com.sun.events.*;
	import com.sun.media.video.*;
	import com.sun.net.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	
	//皮肤转入类,有些类似于文件下载类
	public class PlayerSkin extends Sprite
	{
		
		private var skinPath:String = "";
		private var fld:FileLoader;
		private var tryTimes:uint = 0;
		private var tempLoader:Loader;
		private var _skin:Object;
		public var loadingWidth:Number = 0;
		private static var _instance:PlayerSkin;
		
		public function PlayerSkin()
		{
			if (_instance)
			{
				throw new Error("只能用getInstance()来获取实例");
			}
			return;
		}// end function
		
		public function loadSkin(param1:*) : void
		{
			if (this._skin != null)
			{
				throw new Error("已经加载过皮肤");
			}
			if (param1 == undefined || param1 == null)
			{
				throw new Error("请提供正确的皮肤路径或者皮肤数据对象");
			}
			if (param1 is String)
			{
				this.skinPath = param1;
				this.tryTimes = 0;
				if (this.fld == null)
				{
					this.fld = new FileLoader();
				}
				if (!this.fld.hasEventListener(NLoaderEvent.LOAD_COMPLETE))
				{
					this.fld.addEventListener(NLoaderEvent.LOAD_COMPLETE, this.completeHandler);
					this.fld.addEventListener(NLoaderEvent.LOAD_ERROR, this.errorHandler);
				}
				this.fld.load(this.skinPath);
			}
			else if (param1 is ByteArray)
			{
				this.loadSkinFromByteArray(param1);
			}
			else
			{
				throw new Error("提供的皮肤数据不正确");
			}
			return;
		}// end function
		
		public function setSize(param1:uint, param2:uint, param3:Boolean = false) : void
		{
			//if (this._skin == undefined || this._skin == null)
			if (this._skin == null)
			{
				return;
			}
			this.adjustContrlBar(param1, param2, param3);
			return;
		}// end function
		//显示时间
		public function setShowTime(param1:String, param2:String) : void
		{
			this._skin.showTime(param1, param2);
			return;
		}// end function
		//皮肤的提示
		public function showMsgTip(param1:Boolean = true, param2:Boolean = true, param3:String = "", param4:String = "", param5:String = "") : void
		{
			this._skin.showMsgTip(param1, param2, param3, param4, param5);
			return;
		}// end function
		
		public function get skin():Object
		{
			//trace(this._skin);
			if (this._skin != null)
			{
				return this._skin;
			}
			return null;
		}// end function
		
		private function loadSkinFromByteArray(param1:ByteArray) : void
		{
			this.tempLoader = new Loader();
			this.tempLoader.loadBytes(param1);
			addEventListener(Event.ENTER_FRAME, this.checkLoaded);
			return;
		}// end function
		
		private function checkLoaded(event:Event) : void
		{
			if (this.tempLoader.contentLoaderInfo.bytesLoaded == this.tempLoader.contentLoaderInfo.bytesTotal)
			{
				removeEventListener(Event.ENTER_FRAME, this.checkLoaded);
				this._skin = this.tempLoader.content;
				addChild(this._skin.controlBar_mc as DisplayObject);
				this.skinInit();
				dispatchEvent(new SkinEvent(SkinEvent.SKIN_COMPLETE));
			}
			return;
		}// end function
		
		private function completeHandler(event:NLoaderEvent) : void
		{
			this.fld.removeEventListener(NLoaderEvent.LOAD_COMPLETE, this.completeHandler);
			this.fld.removeEventListener(NLoaderEvent.LOAD_ERROR, this.errorHandler);
			this._skin = event.value.loader.content;
			addChild(this._skin.controlBar_mc as DisplayObject);
			this.skinInit();
			dispatchEvent(new SkinEvent(SkinEvent.SKIN_COMPLETE));
			return;
		}// end function
		//强制10次下载
		private function errorHandler(event:NLoaderEvent) : void 
		{
			if (this.tryTimes < 10)
			{
				this.tryTimes = this.tryTimes + 1;
				this.fld.load(this.skinPath);
			}
			else
			{
				this.fld.removeEventListener(NLoaderEvent.LOAD_COMPLETE, this.completeHandler);
				this.fld.removeEventListener(NLoaderEvent.LOAD_ERROR, this.errorHandler);
				dispatchEvent(new SkinEvent(SkinEvent.SKIN_ERROR));
			}
			return;
		}// end function
		
		private function skinInit() : void
		{
			return;
		}// end function
		//设置加载的位置
		private function adjustContrlBar(param1:uint, param2:uint, param3:Boolean = false) : void
		{
			this._skin.controlBarAdjustSize(param1, param2);
			this._skin.controlBar_mc.y = param2 - this._skin.controlBar_mc.bg_mc.height;
			this._skin.controlBar_mc.x = 0;
			return;
		}// end function
		
		public static function getInstance() : PlayerSkin
		{
			if (_instance == null)
			{
				_instance = new PlayerSkin();
			}
			return _instance;
		}// end function
		
	}
}