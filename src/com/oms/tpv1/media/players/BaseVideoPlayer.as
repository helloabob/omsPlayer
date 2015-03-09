package com.oms.tpv1.media.players
{
	
	import com.oms.tpv1.media.IVideoPlayer;
	import com.oms.tpv1.model.*;
	import com.oms.utils.timer.*;
	import com.sun.utils.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	
	
	
	public class BaseVideoPlayer extends Sprite implements IVideoPlayer
	{
		
		protected var progressTimer:TPTimer;
		protected var volume:Number = 100;
		protected var displayRect:Rectangle;
		protected var videodata:VideoPlayData;
		protected var player_state:int;
		protected var rangePlay:Boolean = false;
		protected var isSeeking:Boolean = false;
		protected var isBufferring:Boolean = false;
		protected var currScaleFactor:int = 0;
		protected var currResizeEffect:Boolean = false;
		protected var usingStageVideo:Boolean = false;
		private static var PROGRESS_INTERVAL:Number = 150;
		
		
		
		
		
		public function BaseVideoPlayer()
		{
			this.progressTimer = TPTimer.setInterval(this.onProgress, PROGRESS_INTERVAL);
			this.displayRect = new Rectangle();
			this.stop();
			this.mouseChildren = false;
			//this.inittracker();
			
			return;
		}
		
		
		
		
		public function setVideoData(param1:VideoPlayData) : void
		{
			this.videodata = param1;
			return;
		}// end function
		
		public function getVideoData() : VideoPlayData
		{
			return this.videodata;
		}// end function
		
		public function getBytesTotal() : Number
		{
			return 0;
		}// end function
		
		public function getBytesLoaded() : Number
		{
			return 0;
		}// end function
		
		public function getLoadedPercent() : Number
		{
			return 0;
		}// end function
		
		public function getBufferPercent() : Number
		{
			return 0;
		}// end function
		
		public function getBufferLengthPercent() : Number
		{
			return 0;
		}// end function
		
		public function getBufferLength() : Number
		{
			return 0;
		}// end function
		
		public function getDuration() : Number
		{
			return this.videodata.video_duration;
		}// end function
		
		public function getPlayTime() : Number
		{
			return 0;
		}// end function
		
		public function getPlayPercent() : Number
		{
			return 0;
		}// end function
		
		public function getVolume() : Number
		{
			return this.volume;
		}// end function
		
		public function setVolume(param1:Number) : void
		{
			this.volume = param1;
			return;
		}// end function
		
		public function getFPS() : Number
		{
			return 0;
		}// end function
		
		public function get ranSeekAbled() : Boolean
		{
			return false;
		}// end function
		
		public function stop() : void
		{
			this.progressTimer.stop();
			this.setPlayerState(PlayerEnum.STATE_STOP);
			return;
		}// end function
		
		public function play(param1:VideoPlayData = null) : void
		{
			/*
			vodMetaInfo.videoDuration=this.getDuration();
			
			if(vodMetaInfo.videoDuration==0||isNaN(vodMetaInfo.videoDuration)){
				
				setTimeout(play,1000);
				
			}else{
				
				vodPlay.endLoading(true,vodMetaInfo);
				
			}
			*/
			
			
			this.setPlayerState(PlayerEnum.STATE_PLAYING);
			return;
		}// end function
		
		public function pause() : void
		{
			this.setPlayerState(PlayerEnum.STATE_PAUSE);
			return;
		}// end function
		
		public function resume() : void
		{
			this.setPlayerState(PlayerEnum.STATE_PLAYING);
			return;
		}// end function
		
		public function seeking(param1:Number, param2:Boolean = true) : void
		{
			return;
		}// end function
		
		public function seekstop(param1:Number) : void
		{
			return;
		}// end function
		
		public function destroy() : void
		{
			return;
		}// end function
		
		public function setRange(param1:PlayTime) : void
		{
			return;
		}// end function
		
		public function resize(param1:Number, param2:Number, param3:int = 0, param4:Boolean = false) : void
		{
			if (!this.videodata)
			{
				return;
			}
			this.currScaleFactor = param3;
			this.currResizeEffect = param4;
			var _loc_5:* = param1;
			var _loc_6:* = param2;
			var _loc_7:* = new Object();
			_loc_7.width = 0;
			_loc_7.height = 0;
			var _loc_8:Number = 320;
			var _loc_9:Number = 240;
			if (this.videodata.video_width * this.videodata.video_height > 0){
				_loc_8 = this.videodata.video_orgWidth;
				_loc_9 = this.videodata.video_orgHeight;
			}
			_loc_7 = Tool.getViewSize(_loc_5, _loc_6, _loc_8, _loc_9, param3);
			this.videodata.video_width = _loc_7.width;
			this.videodata.video_height = _loc_7.height;
			return;
		}// end function
		
		//这里加上状态监听
		public function setPlayerState(param1:int) : void
		{
			
			//vodPlay.onStateChanged(GSVideoState.STOPPED);
			
			
			this.player_state = param1;
			return;
		}// end function
		
		public function getPlayerState() : int
		{
			return this.player_state;
		}// end function
		
		protected function onProgress(event:Event = null) : void
		{
			return;
		}// end function
		
		public function getVideoWidth() : Number
		{
			if (this.videodata)
			{
				return this.videodata.video_width;
			}
			return 0;
		}// end function
		
		public function getVideoHeight() : Number
		{
			if (this.videodata)
			{
				return this.videodata.video_height;
			}
			return 0;
		}// end function
		
		public function seekToStart() : void
		{
			return;
		}// end function
		
		public function getDlSpeed() : Number
		{
			return 0;
		}// end function
		
		public function getIsBufferring() : Boolean
		{
			return this.isBufferring;
		}// end function
		
		public function getCurrVid() : String
		{
			return "";
		}// end function
		
		public function getCurrFormat() : String
		{
			return "";
		}// end function
		
		public function getVideoCount() : int
		{
			return 1;
		}// end function
		
		public function getCurrVt() : Number
		{
			return 0;
		}// end function
		
		public function getModetype() : String
		{
			return "0";
		}// end function
		
		public function getModeRequestTimeCount() : Number
		{
			return 0;
		}// end function
		
		public function getModeRid() : String
		{
			return "";
		}// end function
		
		public function getCurrVurl() : String
		{
			return "";
		}// end function
		
		public function useDefaultUrl() : Boolean
		{
			return false;
		}// end function
		
		public function getRangePlay() : Boolean
		{
			return this.rangePlay;
		}// end function
		
		public function getCurrLevel() : String
		{
			return "0";
		}// end function
		
		public function getPlaytimeSeekPoint(param1:Number = -1) : Object
		{
			return null;
		}// end function
		
		public function getCurrFormatName() : String
		{
			return "";
		}// end function
		
		public function getModeLoadoverTime() : Number
		{
			return 0;
		}// end function
		
		public function getUsingP2P() : Boolean
		{
			return false;
		}// end function
		
		public function getUsingStageVideo() : Boolean
		{
			return this.usingStageVideo;
		}// end function
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}