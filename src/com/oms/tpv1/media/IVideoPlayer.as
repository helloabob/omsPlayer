package com.oms.tpv1.media
{
	import com.oms.tpv1.model.*;
	import flash.events.*;
	
	public interface IVideoPlayer extends IEventDispatcher
	{
		
		function setVideoData(param1:VideoPlayData) : void;
		
		function getVideoData() : VideoPlayData;
		
		function getBytesTotal() : Number;
		
		function getBytesLoaded() : Number;
		
		function getLoadedPercent() : Number;
		
		function getBufferPercent() : Number;
		
		function getBufferLengthPercent() : Number;
		
		function getDuration() : Number;
		
		function getPlayTime() : Number;
		
		function getPlayPercent() : Number;
		
		function getVolume() : Number;
		
		function setVolume(param1:Number) : void;
		
		function getFPS() : Number;
		
		function get ranSeekAbled() : Boolean;
		
		function getDlSpeed() : Number;
		
		function stop() : void;
		
		function play(param1:VideoPlayData = null) : void;
		
		function pause() : void;
		
		function resume() : void;
		
		function seeking(param1:Number, param2:Boolean = true) : void;
		
		function seekstop(param1:Number) : void;
		
		function seekToStart() : void;
		
		function destroy() : void;
		
		function resize(param1:Number, param2:Number, param3:int = 0, param4:Boolean = false) : void;
		
		function getPlayerState() : int;
		
		function getVideoWidth() : Number;
		
		function getVideoHeight() : Number;
		
		function getIsBufferring() : Boolean;
		
		function setRange(param1:PlayTime) : void;
		
		function getCurrVid() : String;
		
		function getCurrFormat() : String;
		
		function getVideoCount() : int;
		
		function useDefaultUrl() : Boolean;
		
		function getRangePlay() : Boolean;
		
		function getCurrLevel() : String;
		
		function getCurrVt() : Number;
		
		function getModetype() : String;
		
		function getPlaytimeSeekPoint(param1:Number = -1) : Object;
		
		function getUsingP2P() : Boolean;
		
	}
}