package com.sun.utils
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;

	
	public class StatDot extends EventDispatcher
	{
		public function StatDot()
		{
			return;
		}// end function
		//这里其实,不需要特别的返回
		public static function dataForServer(param1:Object, param2:String, param3:String = "POST") : void
		{
			var i:String;
			var data:* = param1;
			var path:* = param2;
			var method:* = param3;
			var request:* = new URLRequest(path);
			var loader:* = new URLLoader();
			var variables:* = new URLVariables();
			if (data != null)
			{
				var _loc_5:int = 0;
				var _loc_6:* = data;
				while (_loc_6 in _loc_5)
				{
					
					i = _loc_6[_loc_5];
					variables[i] = data[i];
				}
				request.method = method;
				request.data = variables;
			}
			request.method = method;
			request.data = variables;
			try
			{
				loader.load(request);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			}
			catch (e:Error)
			{
			}
			return;
		}// end function
		
		private static function ioErrorHandler(event:IOErrorEvent) : void
		{
			return;
		}// end function

	}
}