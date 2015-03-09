package com.oms.tpv1.managers
{
	//import com.cloudacc.*;
	import com.oms.tpv1.media.stream.*;
	import com.sun.media.video.*;
	
	import flash.events.*;
	
	//创建流
	public class StreamFactory extends EventDispatcher
	{
		private var _coreInitedList:Array;
		public var streamVersion:String = "";
		public static const STREAMTYPE_NATIVE:int = 0;
		public static const STREAMTYPE_CLOUDACC:int = 1;
		private static var _instance:StreamFactory;
		
		public function StreamFactory()
		{
			this._coreInitedList = [false, false];
			if (_instance)
			{
				throw new Error("StreamFactory单例类，不能用New创建！");
			}
			return;
		}// end function
		
		public function init(param1:int = 0) : void
		{
			switch(param1)
			{
				case STREAMTYPE_NATIVE:
				{
					this.streamVersion = "";
					dispatchEvent(new Event(Event.COMPLETE));
					break;
				}
				case STREAMTYPE_CLOUDACC:
				{
					dispatchEvent(new Event(Event.COMPLETE));
					/*if (!XNetStream.P2PLibGetSucc)
					{
						this.streamVersion = "";
						XNetStream.xInit(this.cloudAccInited);
					}
					else
					{
						dispatchEvent(new Event(Event.COMPLETE));
					}*/
					break;
				}
				default:
				{
					break;
				}
			}
			return;
		}// end function
		
		public function getStream(param1:int = 0, param2:Object = null) : IVideoStream
		{
			var _loc_3:* = undefined;
			switch(param1)
			{
				case STREAMTYPE_NATIVE:
				{
					return new CommonStream();
				}
				case STREAMTYPE_CLOUDACC:
				{
					//_loc_3 = new CloudAccStream(param2);
					//return _loc_3;
					break;
				}
				default:
				{
					break;
				}
			}
			return null;
		}// end function
		
		private function cloudAccInited() : void
		{
			//this.streamVersion = XNetStream.getStreamVersion();
			//XNetStream.initReport();
			dispatchEvent(new Event(Event.COMPLETE));
			return;
		}// end function
		
		private function checkXNetHandler(event:StreamEvent) : void
		{
			
			return;
		}// end function
		
		public static function get instance() : StreamFactory
		{
			if (!_instance)
			{
				_instance = new StreamFactory;
			}
			return _instance;
		}// end function

	}
}