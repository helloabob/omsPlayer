package com.oms.tpv1.ui
{
	import com.sun.events.*;
	import com.sun.net.*;
	import com.sun.utils.*;
	import com.oms.tpv1.events.*;
	import flash.display.*;
	
	public class LoadingSwf extends Sprite
	{
		private var fld:FileLoader;
		private var bg:Shape;
		private var lmask:Sprite;
		private var loadingSwfOrgW:Number;
		private var loadingSwfOrgH:Number;
		private var getloader:Boolean = true;
		private var loaderContent:MovieClip;
		
		public function LoadingSwf()
		{
			this.bg = new Shape();
			this.lmask = new Sprite();
			this.lmask.graphics.beginFill(16711680, 0.1);
			this.lmask.graphics.drawRect(0, 0, 100, 100);
			this.lmask.graphics.endFill();
			return;
		}// end function
		
		public function load(param1:String) : void
		{
			while (this.numChildren > 0)
			{
				
				this.removeChildAt(0);
			}
			this.getloader = false;
			this.loaderContent = null;
			if (!this.fld)
			{
				this.fld = new FileLoader();
				this.fld.requestTimeout = 5000;
				this.fld.loadTimeout = 5000;
			}
			if (!this.fld.hasEventListener(NLoaderEvent.LOAD_COMPLETE))
			{
				this.fld.addEventListener(NLoaderEvent.LOAD_COMPLETE, this.completeHandler);
				this.fld.addEventListener(NLoaderEvent.LOAD_ERROR, this.errorHandler);
			}
			this.fld.load(param1);
			return;
		}// end function
		
		private function completeHandler(event:NLoaderEvent) : void
		{
			var event:* = event;
			this.fld.removeEventListener(NLoaderEvent.LOAD_COMPLETE, this.completeHandler);
			this.fld.removeEventListener(NLoaderEvent.LOAD_ERROR, this.errorHandler);
			this.loadingSwfOrgW = event.value.width;
			this.loadingSwfOrgH = event.value.height;
			this.bg.graphics.beginFill(0, 1);
			this.bg.graphics.drawRect(0, 0, this.loadingSwfOrgW, this.loadingSwfOrgH);
			this.bg.graphics.endFill();
			if (this.bg.parent != this)
			{
				this.addChildAt(this.bg, 0);
			}
			this.addChild(event.value.loader);
			try
			{
				this.loaderContent = event.value.loader.content as MovieClip;
			}
			catch (e:Error)
			{
				loaderContent = null;
				AS3Debugger.Trace(e);
			}
			event.value.loader.mask = this.lmask;
			if (this.lmask.parent != this)
			{
				this.addChild(this.lmask);
			}
			this.getloader = true;
			dispatchEvent(new LoadingSwfEvent(LoadingSwfEvent.LOADING_COMPLETE));
			return;
		}// end function
		
		private function errorHandler(event:NLoaderEvent) : void
		{
			this.fld.removeEventListener(NLoaderEvent.LOAD_COMPLETE, this.completeHandler);
			this.fld.removeEventListener(NLoaderEvent.LOAD_ERROR, this.errorHandler);
			this.getloader = false;
			dispatchEvent(new LoadingSwfEvent(LoadingSwfEvent.LOADING_ERROR));
			return;
		}// end function
		
		public function resize(param1:Number, param2:Number) : void
		{
			if (this.getloader)
			{
				this.lmask.width = this.width;
				this.lmask.height = this.height;
				var _loc_3:* = (param1 - this.loadingSwfOrgW) / 2;
				this.getChildAt(2).x = (param1 - this.loadingSwfOrgW) / 2;
				this.getChildAt(1).x = _loc_3;
				this.bg.width = param1;
				this.bg.height = param2;
			}
			return;
		}// end function
		
		public function getLoader() : Boolean
		{
			return this.getloader;
		}// end function
		
		public function setLoadingText(param1:String) : void
		{
			try
			{
				if (this.loaderContent)
				{
					this.loaderContent.txtloading.text = param1;
				}
			}
			catch (e:Error)
			{
			}
			return;
		}// end function

	}
}