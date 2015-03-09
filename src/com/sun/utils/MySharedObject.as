package com.sun.utils
{
	import flash.events.*;
	import flash.net.*;

	
	public class MySharedObject extends EventDispatcher
	{
		public function MySharedObject()
		{
			return;
		}// end function
		
		public function save(param1:String, param2:String = null, param3:Object = null) : void
		{
			var k:String;
			var flushStatus:String;
			var soName:* = param1;
			var path:* = param2;
			var value:* = param3;
			var so:* = SharedObject.getLocal(soName, path);
			if (value == null)
			{
				throw new Error("请输入要保存的数据");
			}
			var _loc_5:int = 0;
			var _loc_6:* = value;
			while (_loc_6 in _loc_5)
			{
				
				k = _loc_6[_loc_5];
				so.data[k] = value[k];
			}
			flushStatus;
			try
			{
				flushStatus = so.flush(10000);
			}
			catch (error:Error)
			{
				dispatchEvent(new Event("SAVE_FAILED"));
			}
			if (flushStatus != null)
			{
				switch(flushStatus)
				{
					case SharedObjectFlushStatus.PENDING:
					{
						so.addEventListener(NetStatusEvent.NET_STATUS, this.onFlushStatus);
						break;
					}
					case SharedObjectFlushStatus.FLUSHED:
					{
						dispatchEvent(new Event("SAVE_SUCCESS"));
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
		
		public function read(param1:String, param2:String = null) : Object
		{
			var _loc_3:SharedObject = null;
			try
			{
				_loc_3 = SharedObject.getLocal(param1, param2);
				return _loc_3.data;
			}
			catch (e:Error)
			{
			}
			return null;
		}// end function
		
		private function onFlushStatus(event:NetStatusEvent) : void
		{
			switch(event.info.code)
			{
				case "SharedObject.Flush.Success":
				{
					dispatchEvent(new Event("SAVE_SUCCESS"));
					break;
				}
				case "SharedObject.Flush.Failed":
				{
					dispatchEvent(new Event("SAVE_FAILED"));
					break;
				}
				default:
				{
					break;
				}
			}
			event.target.removeEventListener(NetStatusEvent.NET_STATUS, this.onFlushStatus);
			return;
		}// end function
	}
}