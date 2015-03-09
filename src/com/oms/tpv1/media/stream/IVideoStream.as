package com.oms.tpv1.media.stream
{
	import flash.media.*;
	import flash.net.*;
	import flash.events.*;
	
	public interface IVideoStream extends IEventDispatcher
	{
		
		public function IVideoStream();
		
		function get readyToPlay() : Boolean;
		
		function load(param1:Object) : void;
		
		function onMetaData(param1:Object) : void;
		
		function onPlayStatus(param1:Object) : void;
		
		function get bytesLoaded() : Number;
		
		function get bytesTotal() : Number;
		
		function getLoadedPercent() : Number;
		
		function get playTime() : Number;
		
		function get bufferPercent() : Number;
		
		function get bufferPerToPlay() : Number;
		
		function get bufferLength() : Number;
		
		function closeStream() : void;
		
		function get volume() : Number;
		
		function set volume(param1:Number) : void;
		
		function set bufferTime(param1:int) : void;
		
		function get bufferTime() : int;
		
		function pause() : Boolean;
		
		function resume() : Boolean;
		
		function seek(param1:Number) : Boolean;
		
		function attachVideo(param1:Video) : void;
		
		function attachStageVideo(param1:Object) : void;
		
		function startToChange() : void;
		
		function usingP2P() : Boolean;
		
		function get P2PData() : Object;
		
		function get currentFPS() : Number;
		
		function get stream() : GSNetStream;
		
		
		
	}
}