package com.oms.videov3.ui
{
	import flash.display.*;
	import flash.display.MovieClip;
	import flash.geom.*;
	import flash.text.*;
	
	public class ToolTip extends MovieClip
	{
		public var delta:MovieClip;
		public var bg:MovieClip = new MovieClip();
		private var text:TextField;
		private var format:TextFormat;
		private var point:Point;
		private var globalx:Number;
		private var stagewidth:Number = 500;
		public var playerwidth:Number = 500;
		public var bgWidth:Number;
		private var _autosize:Boolean = false;
		private var _orgwidth:Number = 50;
		
		public function ToolTip(param1:Number = 50, param2:String = "宋体", param3:int = 11, param4:Number = 1, param5:uint = 16777215)
		{
			this._orgwidth = param1;
			this.text = new TextField();
			this.text.width = param1;
			
			this.bg.width = param1;
			this.bgWidth = param1;
			
			this.text.height = 18;
			this.bg.x = (-param1) / 2;
			var _loc_6:* = new TextFormat(param2, param3, param5);
			new TextFormat(param2, param3, param5).align = TextFormatAlign.CENTER;
			this.text.defaultTextFormat = _loc_6;
			this.text.y = param4;
			this.text.x = (-param1) / 2;
			this.addChild(this.text);
			this.point = new Point();
			this.mouseChildren = false;
			return;
		}// end function
		
		public function set tiptext(param1:String) : void
		{
			this.text.text = param1;
			return;
		}// end function
		
		public function set autosize(param1:Boolean) : void
		{
			this._autosize = param1;
			var _loc_2:Number;
			if (param1)
			{
				_loc_2 = this.text.textWidth + 8;
			}
			else
			{
				_loc_2 = this._orgwidth;
				
			}
			this.text.width = _loc_2;
			this.bg.width = _loc_2;
			this.bgWidth = _loc_2;
			/*
			var _loc_3:* = (-this.bgWidth) / 2;
			this.bg.x = _loc_3;
			this.text.x = _loc_3;
			*/
			
			return;
		}// end function
		
		public function get autosize() : Boolean
		{
			return this._autosize;
		}// end function
		
		override public function set x(param1:Number) : void
		{
			super.x = param1;
			this.globalx = param1;
			this.stagewidth = this.playerwidth - this.bg.width;
			if (this.globalx > this.bg.width / 2 && this.globalx < this.stagewidth + this.bg.width / 2)
			{
				this.globalx = param1 - this.bg.width / 2;
			}
			else if (this.globalx <= this.bg.width - 5)
			{
				this.globalx = 0;
			}
			else
			{
				this.globalx = this.stagewidth;
			}
			var _loc_2:* = this.globalx - param1;
			this.bg.x = this.globalx - param1;
			this.text.x = _loc_2;
			return;
		}// end function
	}
}