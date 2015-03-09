package com.sun.net
{
	import com.sun.events.*;
	import com.sun.utils.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	
	public class MyURLStream extends EventDispatcher
	{
		private var stream:URLStream;
		private var _instanceIndex:uint = 0;
		private var _requestTimeout:uint = 5000;
		private var timeout:uint;
		private var httpErrorState:int;
		
		public function MyURLStream()
		{
			return;
		}// end function
		
		public function close() : void
		{
			clearTimeout(this.timeout);
			AS3Debugger.Trace("MyURLStream::close");
			if (this.stream != null)
			{
				try
				{
					if (this.stream.connected)
					{
						this.stream.close();
					}
				}
				catch (e:Error)
				{
				}
				this.removeEvents(this.stream);
			}
			return;
		}// end function
		
		public function load(param1:String, param2:Object = null, param3:String = "POST") : void
		{
			var variables:URLVariables;
			var i:String;
			var url:* = param1;
			var data:* = param2;
			var method:* = param3;
			if (this.stream == null)
			{
				this.stream = new URLStream();
			}
			else
			{
				try
				{
					if (this.stream.connected)
					{
						this.stream.close();
					}
				}
				catch (e:Error)
				{
				}
			}
			clearTimeout(this.timeout);
			AS3Debugger.Trace("MyURLStream::load>>url=" + url + ",method=" + method);
			var request:* = new URLRequest(url);
			if (data != null)
			{
				variables = new URLVariables();
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
			try
			{
				this.configureListeners(this.stream);
				this.stream.load(request);
				this.timeout = setTimeout(this.requestTimeoutHandler, this._requestTimeout);
			}
			catch (error:Error)
			{
				dispatchEvent(new NLoaderEvent(NLoaderEvent.LOAD_ERROR, "Unable to load requested document." + error));
			}
			return;
		}// end function
		
		public function set instanceIndex(param1:uint) : void
		{
			this._instanceIndex = param1;
			return;
		}// end function
		
		public function get instanceIndex() : uint
		{
			return this._instanceIndex;
		}// end function
		
		public function set requestTimeout(param1:uint) : void
		{
			this._requestTimeout = param1;
			return;
		}// end function
		
		private function requestTimeoutHandler() : void
		{
			AS3Debugger.Trace("MyURLStream::requestTimeoutHandler");
			this.close();
			dispatchEvent(new NLoaderEvent(NLoaderEvent.LOAD_ERROR, "requestTimeout"));
			return;
		}// end function
		
		private function configureListeners(param1:EventDispatcher) : void
		{
			if (!param1.hasEventListener(Event.COMPLETE))
			{
				param1.addEventListener(Event.COMPLETE, this.completeHandler);
			}
			if (!param1.hasEventListener(HTTPStatusEvent.HTTP_STATUS))
			{
				param1.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.httpStatusHandler);
			}
			if (!param1.hasEventListener(IOErrorEvent.IO_ERROR))
			{
				param1.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
			}
			if (!param1.hasEventListener(Event.OPEN))
			{
				param1.addEventListener(Event.OPEN, this.openHandler);
			}
			if (!param1.hasEventListener(ProgressEvent.PROGRESS))
			{
				param1.addEventListener(ProgressEvent.PROGRESS, this.progressHandler);
			}
			if (!param1.hasEventListener(SecurityErrorEvent.SECURITY_ERROR))
			{
				param1.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
			}
			return;
		}// end function
		
		private function removeEvents(param1:EventDispatcher) : void
		{
			if (param1.hasEventListener(Event.COMPLETE))
			{
				param1.removeEventListener(Event.COMPLETE, this.completeHandler);
			}
			if (param1.hasEventListener(HTTPStatusEvent.HTTP_STATUS))
			{
				param1.removeEventListener(HTTPStatusEvent.HTTP_STATUS, this.httpStatusHandler);
			}
			if (param1.hasEventListener(IOErrorEvent.IO_ERROR))
			{
				param1.removeEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
			}
			if (param1.hasEventListener(Event.OPEN))
			{
				param1.removeEventListener(Event.OPEN, this.openHandler);
			}
			if (param1.hasEventListener(ProgressEvent.PROGRESS))
			{
				param1.removeEventListener(ProgressEvent.PROGRESS, this.progressHandler);
			}
			if (param1.hasEventListener(SecurityErrorEvent.SECURITY_ERROR))
			{
				param1.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
			}
			return;
		}// end function
		
		private function completeHandler(event:Event) : void
		{
			var event:* = event;
			this.removeEvents(this.stream);
			var bytes:* = new ByteArray();
			this.stream.readBytes(bytes);
			try
			{
				this.stream.close();
			}
			catch (e:Error)
			{
			}
			AS3Debugger.Trace("MyURLStream::completeHandler>>----------");
			dispatchEvent(new NLoaderEvent(NLoaderEvent.LOAD_COMPLETE, bytes));
			return;
		}// end function
		
		private function openHandler(event:Event) : void
		{
			AS3Debugger.Trace("MyURLStream::openHandler");
			clearTimeout(this.timeout);
			return;
		}// end function
		
		private function progressHandler(event:ProgressEvent) : void
		{
			dispatchEvent(new NLoaderEvent(NLoaderEvent.LOAD_PROGRESS, {bytesLoaded:event.bytesLoaded, bytesTotal:event.bytesTotal}));
			return;
		}// end function
		
		private function securityErrorHandler(event:SecurityErrorEvent) : void
		{
			AS3Debugger.Trace("MyURLStream::securityErrorHandler");
			clearTimeout(this.timeout);
			this.removeEvents(this.stream);
			dispatchEvent(new NLoaderEvent(NLoaderEvent.LOAD_ERROR, {desc:"SecurityError", code:-1}));
			return;
		}// end function
		
		private function httpStatusHandler(event:HTTPStatusEvent) : void
		{
			AS3Debugger.Trace("MyURLStream::httpStatusHandler>status=" + event.status);
			if (event.status * 1 >= 400)
			{
				this.httpErrorState = event.status;
				clearTimeout(this.timeout);
				dispatchEvent(new NLoaderEvent(NLoaderEvent.HTTP_ERROR, event.status));
			}
			return;
		}// end function
		
		private function ioErrorHandler(event:IOErrorEvent) : void
		{
			AS3Debugger.Trace("MyURLStream::ioErrorHandler");
			this.removeEvents(this.stream);
			clearTimeout(this.timeout);
			dispatchEvent(new NLoaderEvent(NLoaderEvent.LOAD_ERROR, {desc:"IOError", code:this.httpErrorState}));
			return;
		}// end function

	}
}