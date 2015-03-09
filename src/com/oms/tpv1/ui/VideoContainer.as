package com.oms.tpv1.ui
{
	import flash.display.*;
	import flash.geom.*;
	
	public class VideoContainer extends Sprite
	{
		private var videoRect:Rectangle;
		private var bg:Shape;
		
		public function VideoContainer()
		{
			this.init();
			return;
		}// end function
		
		private function init() : void
		{
			this.videoRect = new Rectangle(0, 0, 0, 0);
			this.bg = new Shape();
			this.drawRect(this.bg, 0);
			this.addChild(this.bg);
			return;
		}// end function
		
		private function drawRect(param1:Shape, param2:uint) : void
		{
			param1.graphics.beginFill(param2);
			param1.graphics.drawRect(0, 0, 100, 100);
			param1.graphics.endFill();
			return;
		}// end function
		
		public function setSize(param1:uint, param2:uint) : void
		{
			var _loc_3:int = 0;
			this.videoRect.y = 0;
			this.videoRect.x = 0;
			this.bg.width = param1;
			this.videoRect.width = param1;
			this.bg.height = param2;
			this.videoRect.height = param2;
			return;
		}// end function
		
		public function getVideoRect() : Rectangle
		{
			return this.videoRect;
		}// end function

	}
}