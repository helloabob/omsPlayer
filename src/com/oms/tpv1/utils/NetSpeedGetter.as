package com.oms.tpv1.utils
{
	import com.koma.utils.*;
	import com.sun.events.*;
	import com.sun.net.*;
	import com.oms.tpv1.model.*;
	import flash.events.*;
	import flash.net.*;
	
	//获取网络速度及IP的..这里应该是应用于网络速度之类的
	public class NetSpeedGetter extends EventDispatcher
	{
		//private var _cgiPath:String = "http://vv.video.qq.com/getspeed";
		//private var _cgiPath:String = "http://172.24.26.32/flash/getspeed.php";
		//private var _cgiPath:String = "http://172.24.26.32/flash/getspeed.php";
		//private var _cgiPath:String = "http://61.152.222.178:8033/index.php?app=api&mod=public&act=getspeed";
		
		
		
		private var _cgiPath:String = "http://v.kankanews.com/index.php?app=api&mod=public&act=getspeed";
		
		private var _fld:FileLoader;
		private var _currIp:String = "null";
		private var _currSpeed:Number = 0;
		private var _currPath:String = "";
		private var localSpeed:PlayerLocalSpeed;
		public var isSucc:Boolean = false;
		public var codenem:Number = 0;
		private static var _instance:NetSpeedGetter;
		
		public function NetSpeedGetter()
		{
			if (_instance)
			{
				throw new Error("单例类，不能用New创建");
			}
			return;
		}// end function
		
		public function getSpeedTest(param1:PlayerLocalSpeed, param2:Number = 0) : void
		{
			this.localSpeed = param1;
			var _loc_3:* = this.createStr();
			this.isSucc = false;
			this.codenem = 0;
			if (this._fld == null)
			{
				this._fld = new FileLoader();
				this._fld.requestTimeout = 5000;
				this._fld.loadTimeout = 5000;
			}
			else
			{
				this._fld.close();
			}
			if (!this._fld.hasEventListener(NLoaderEvent.LOAD_COMPLETE))
			{
				this._fld.addEventListener(NLoaderEvent.LOAD_COMPLETE, this.urlLoadCompleteHandler);
				this._fld.addEventListener(NLoaderEvent.LOAD_ERROR, this.urlLoadErrorHandler);
			}
			var _loc_4:Object = {history:_loc_3, adspeed:param2};
			this._currPath = PlayerUtils.getVurl(this._cgiPath, _loc_4);
			this._fld.load(this._cgiPath, "URLRequest", URLLoaderDataFormat.TEXT, _loc_4, "POST");
			return;
		}// end function
		
		public function close() : void
		{
			if (this._fld && this._fld.hasEventListener(NLoaderEvent.LOAD_COMPLETE))
			{
				this._fld.removeEventListener(NLoaderEvent.LOAD_COMPLETE, this.urlLoadCompleteHandler);
				this._fld.removeEventListener(NLoaderEvent.LOAD_ERROR, this.urlLoadErrorHandler);
			}
			if (this._fld)
			{
				try
				{
					this._fld.close();
				}
				catch (e:Error)
				{
				}
			}
			return;
		}// end function
		
		private function createStr() : String
		{
			var _loc_1:Array = null;
			var _loc_3:Object = null;
			var _loc_4:String = null;
			/*if (this.localSpeed)
			{
				_loc_1 = this.localSpeed.arraySpeed;
			}
			else
			{*/
				_loc_1 = new Array();
			//}
			var _loc_2:String = "";
			var _loc_5:String = "null";
			var _loc_6:* = new Date();
			var _loc_7:Number = 0;
			var _loc_8:int = 0;
			var _loc_9:* = _loc_1.length;
			while (_loc_8 < _loc_9)
			{
				
				_loc_3 = _loc_1[_loc_8];
				if (_loc_3.ip)
				{
					_loc_4 = _loc_3.ip;
				}
				else
				{
					_loc_4 = "null";
				}
				if (_loc_3.time)
				{
					_loc_5 = _loc_3.time;
				}
				else
				{
					_loc_5 = "" + Math.floor(_loc_6.getTime() / 1000);
				}
				if (_loc_3.vt && !isNaN(_loc_3.vt))
				{
					_loc_7 = _loc_3.vt;
				}
				else
				{
					_loc_7 = 0;
				}
				_loc_2 = _loc_2 + (_loc_4 + "," + Math.floor(Number(_loc_3.speed)) + "," + _loc_5);
				if (_loc_8 != (_loc_9 - 1))
				{
					_loc_2 = _loc_2 + "|";
				}
				_loc_8++;
			}
			return _loc_2;
		}// end function
		
		private function urlLoadCompleteHandler(event:NLoaderEvent) : void
		{
			this._fld.removeEventListener(NLoaderEvent.LOAD_COMPLETE, this.urlLoadCompleteHandler);
			this._fld.removeEventListener(NLoaderEvent.LOAD_ERROR, this.urlLoadErrorHandler);
			this._fld = null;
			var _loc_2:* = event.value.data;
			var _loc_3:* = this.getxmlinfo(_loc_2);
			if (_loc_3.ip)
			{
				this._currIp = _loc_3.ip;
			}
			if (_loc_3.speed && !isNaN(_loc_3.speed * 1))
			{
				this._currSpeed = _loc_3.speed * 1;
			}
			else
			{
				this._currSpeed = this.getLocalSpeed();
			}
			this.isSucc = true;
			this.codenem = 0;
			dispatchEvent(new Event("nsg_getok"));
			return;
		}// end function
		
		private function getxmlinfo(param1:String) : Object
		{
			var _loc_2:XML = null;
			try
			{
				_loc_2 = XML(param1);
			}
			catch (e:Error)
			{
			}
			if (_loc_2 == null)
			{
				return null;
			}
			_loc_2.ignoreWhitespace = true;
			var _loc_3:* = XMLUtils.toObject(_loc_2);
			return _loc_3.root;
		}// end function
		
		private function getLocalSpeed() : Number
		{
			var _loc_2:Array = null;
			var _loc_5:Object = null;
			var _loc_1:Number = 0;
			if (this.localSpeed)
			{
				_loc_2 = this.localSpeed.arraySpeed;
			}
			else
			{
				_loc_2 = new Array();
			}
			var _loc_3:* = _loc_2.length;
			if (_loc_3 == 0)
			{
				return 0;
			}
			var _loc_4:Number = 0;
			var _loc_6:int = 0;
			while (_loc_6 < _loc_3)
			{
				
				_loc_5 = _loc_2[_loc_6];
				if (_loc_5.speed && !isNaN(_loc_5.speed * 1))
				{
					_loc_4 = _loc_4 + _loc_5.speed * 1;
				}
				_loc_6++;
			}
			return Math.floor(_loc_4 / _loc_3);
		}// end function
		
		private function urlLoadErrorHandler(event:NLoaderEvent) : void
		{
			this._fld.removeEventListener(NLoaderEvent.LOAD_COMPLETE, this.urlLoadCompleteHandler);
			this._fld.removeEventListener(NLoaderEvent.LOAD_ERROR, this.urlLoadErrorHandler);
			this._fld = null;
			this.isSucc = false;
			if (event.value.code && !isNaN(event.value.code))
			{
				this.codenem = event.value.code;
			}
			this._currSpeed = this.getLocalSpeed();
			dispatchEvent(new Event("nsg_getok"));
			return;
		}// end function
		
		public function get currIp() : String
		{
			return this._currIp;
		}// end function
		
		public function get currSpeed() : Number
		{
			return this._currSpeed;
		}// end function
		
		public function get currPath() : String
		{
			return this._currPath;
		}// end function
		
		public static function get instance() : NetSpeedGetter
		{
			if (!_instance)
			{
				_instance = new NetSpeedGetter;
			}
			return _instance;
		}// end function
	}
}