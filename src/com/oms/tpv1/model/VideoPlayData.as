package com.oms.tpv1.model
{
	import __AS3__.vec.*;
	//import com.oms.tpv1.ui.subtitle.*;
	//视频源数据信息.
	public class VideoPlayData extends Object
	{
		public var arrayVid:Array;
		public var buffertime:Number = 6;
		public var secBuffertime:Number = 5;
		public var waittime:Number = 0;
		public var historySpeed:Number = 0;
		public var format:String;
		public var playformat:String;
		public var playtimeInfo:PlayTime;
		public var video_duration:Number = 0;
		public var video_title:String = "";
		public var video_width:Number = 400;
		public var video_height:Number = 300;
		public var video_orgWidth:Number = 400;
		public var video_orgHeight:Number = 300;
		public var video_fmtlist:Vector.<VideoFormat>;
		//public var video_stlist:Vector.<SubtitleMode>;
		public var video_curfmt:VideoFormat;
		public var video_hardware:Boolean = false;
		public var video_br:Number = 128;
		public var video_vtype:int = 0;
		public var video_changeformat:Boolean = false;
		public var share_support:Boolean = true;
		public var video_autoseek:Boolean = false;
		public var video_forceHttp:Boolean = false;
		
		public function VideoPlayData()
		{
			this.format = PlayerEnum.FORMAT_AUTO;
			this.playformat = PlayerEnum.FORMAT_AUTO;
			return;
		}// end function
	}
}