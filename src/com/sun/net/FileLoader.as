package com.sun.net
{
	import com.sun.events.NLoaderEvent;
	import com.sun.utils.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.utils.*;
	
	
	public class FileLoader extends EventDispatcher
	{
		
		private var _loader:Object;
		private var _isLoading:Boolean;
		private var _listener:IEventDispatcher;
		private var _instanceIndex:uint = 0;
		private var _requestTimeout:uint = 8.64e+007;
		private var _loadTimeout:uint = 8.64e+007;
		private var timeout:uint = 0;
		private var httpErrorState:int;
		private var isdispatched:Boolean = false;
		
		public function FileLoader()
		{
			this._isLoading = false;
			return;
		}// end function
		
		public function close() : void
		{
			if (this._loader != null)
			{
				try
				{
					this._loader.close();
				}
				catch (e:Error)
				{
				}
				this._isLoading = false;
				this.removeEvents(this._listener);
				clearTimeout(this.timeout);
				AS3Debugger.Trace("Try Close FileLoader");
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
		
		public function set loadTimeout(param1:uint) : void
		{
			this._loadTimeout = param1;
			return;
		}// end function
		
		public function load(param1:String, param2:String = "Loader", param3:String = "text", param4:Object = null, param5:String = "POST", param6:LoaderContext = null) : void
		{
			var variables:URLVariables;
			var i:String;
			var path:* = param1;
			var type:* = param2;
			var dataFormat:* = param3;
			var data:* = param4;
			var method:* = param5;
			var loaderContext:* = param6;
			AS3Debugger.Trace("FileLoader::load>>" + path);
			if (this._isLoading)
			{
				this._isLoading = false;
				try
				{
					this._loader.close();
				}
				catch (e:Error)
				{
				}
				this.removeEvents(this._listener);
			}
			clearTimeout(this.timeout);
			//this.httpErrorState = -2;
			if (type == "Loader")
			{
				this._loader = new Loader();
				this._listener = this._loader.contentLoaderInfo;
			}
			else
			{
				this._loader = new URLLoader();
				this._loader.dataFormat = dataFormat;
				this._listener = this._loader as IEventDispatcher;
			}
			var request:* = new URLRequest(path);
			
			if (data != null)
			{
				variables = new URLVariables();
				var _loc_9:*;
				
				for(var str:String in data)
				{
					
					
					variables[str]=data[str];
					
					
				}
				
				request.method = method;
				request.data = variables;
			}
			/*
			
			if (data != null)
			{
				variables = new URLVariables();
				var _loc_8:int = 0;
				var _loc_9:* = data;
				while (_loc_9 in _loc_8)
				{
					
					i = _loc_9[_loc_8];
					variables[i] = data[i];
				}
				request.method = method;
				request.data = variables;
			}*/
			try
			{
				this._isLoading = true;
				this.configureListeners(this._listener);
				if (this._loader is Loader)
				{
					this._loader.load(request, loaderContext);
				}
				else
				{
					this._loader.load(request);
				}
				this.timeout = setTimeout(this.requestTimeoutCheck, this._requestTimeout);
			}
			catch (error:Error)
			{
				_isLoading = false;
				clearTimeout(timeout);
				dispatchEvent(new NLoaderEvent(NLoaderEvent.LOAD_ERROR, {code:600}));
			}
			return;
		}// end function
		
		private function configureListeners(param1:IEventDispatcher) : void
		{
			param1.addEventListener(Event.COMPLETE, this.completeHandler);
			param1.addEventListener(ProgressEvent.PROGRESS, this.progressHandler);
			param1.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
			param1.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
			param1.addEventListener(Event.OPEN, this.openHandler);
			param1.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.httpStatusHandler);
			param1.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.undoErrorHandler);
			param1.removeEventListener(IOErrorEvent.IO_ERROR, this.undoErrorHandler);
			return;
		}// end function
		
		private function removeEvents(param1:IEventDispatcher, param2:Boolean = true) : void
		{
			param1.removeEventListener(Event.COMPLETE, this.completeHandler);
			param1.removeEventListener(ProgressEvent.PROGRESS, this.progressHandler);
			param1.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
			param1.removeEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
			param1.removeEventListener(Event.OPEN, this.openHandler);
			param1.removeEventListener(HTTPStatusEvent.HTTP_STATUS, this.httpStatusHandler);
			if (!param2)
			{
				param1.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.undoErrorHandler);
				param1.addEventListener(IOErrorEvent.IO_ERROR, this.undoErrorHandler);
			}
			return;
		}// end function
		
		private function httpStatusHandler(event:HTTPStatusEvent) : void
		{
			if (event.status * 1 >= 400)
			{
				this.httpErrorState = event.status;
				AS3Debugger.Trace("FileLoader::HTTP_ERROR>>status=" + event.status);
				dispatchEvent(new NLoaderEvent(NLoaderEvent.HTTP_ERROR, event.status));
			}
			return;
		}// end function
		
		private function requestTimeoutCheck() : void
		{
			if (this._isLoading)
			{
				this.removeEvents(this._listener, false);
				AS3Debugger.Trace("FileLoader::requestTimeoutCheck");
				try
				{
					this._loader.close();
				}
				catch (e:Error)
				{
				}
				dispatchEvent(new NLoaderEvent(NLoaderEvent.LOAD_ERROR, {"code":600}));
			}
			return;
		}// end function
		
		private function loadTimeoutCheck() : void
		{
			this.removeEvents(this._listener, false);
			AS3Debugger.Trace("FileLoader::loadTimeoutCheck");
			dispatchEvent(new NLoaderEvent(NLoaderEvent.LOAD_ERROR, {"code":600}));
			try
			{
				this._loader.close();
			}
			catch (e:Error)
			{
			}
			return;
		}// end function
		
		private function openHandler(event:Event) : void
		{
			clearTimeout(this.timeout);
			this.timeout = setTimeout(this.loadTimeoutCheck, this._loadTimeout);
			dispatchEvent(new NLoaderEvent(NLoaderEvent.LOAD_START, event.target));
			return;
		}// end function
		
		private function completeHandler(event:Event) : void
		{
			clearTimeout(this.timeout);
			this.removeEvents(this._listener);
			dispatchEvent(new NLoaderEvent(NLoaderEvent.LOAD_COMPLETE, event.target));
			this._isLoading = false;
			return;
		}// end function
		
		private function progressHandler(event:ProgressEvent) : void
		{
			dispatchEvent(new NLoaderEvent(NLoaderEvent.LOAD_PROGRESS, {bytesLoaded:event.bytesLoaded, bytesTotal:event.bytesTotal}));
			return;
		}// end function
		
		private function securityErrorHandler(event:SecurityErrorEvent) : void
		{
			clearTimeout(this.timeout);
			AS3Debugger.Trace("FileLoader::securityErrorHandler");
			this.removeEvents(this._listener);
			dispatchEvent(new NLoaderEvent(NLoaderEvent.LOAD_ERROR, {desc:"SecurityError", code:603}));
			this._isLoading = false;
			return;
		}// end function
		
		private function ioErrorHandler(event:IOErrorEvent) : void
		{
			clearTimeout(this.timeout);
			AS3Debugger.Trace("FileLoader::ioErrorHandler");
			this.removeEvents(this._listener);
			dispatchEvent(new NLoaderEvent(NLoaderEvent.LOAD_ERROR, {desc:"IOError", code:604}));
			this._isLoading = false;
			return;
		}// end function
		
		private function undoErrorHandler(event:Event) : void
		{
			AS3Debugger.Trace("FileLoader::undoErrorHandler");
			if (this._listener)
			{
				this._listener.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.undoErrorHandler);
				this._listener.removeEventListener(IOErrorEvent.IO_ERROR, this.undoErrorHandler);
			}
			return;
		}// end function
		

	}
}