//======================================================================
//
//     Copyright (C) 北京国双科技有限公司        
//                   http://www.gridsum.com
//
//     保密性声明：此文件属北京国双科技有限公司所有，仅限拥有由国双科技
//     授予了相应权限的人所查看和所修改。如果你没有被国双科技授予相应的
//     权限而得到此文件，请删除此文件。未得国双科技同意，不得查看、修改、
//     散播此文件。
//
//
//======================================================================
package  com.oms.tpv1.media.stream
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.NetStreamPlayOptions;
	import flash.utils.Timer;
	import com.gridsum.VideoTracker.GSVideoState;
	
	import flash.external.ExternalInterface;
	
	/**
	 * 带有播放状态的NetStream
	 */
	public class GSNetStream extends NetStream
	{
		protected var _state:String = GSVideoState.DISCONNECTED;
		protected var _isGoingToPlay:Boolean = true;
		protected var _eventDispatcher:EventDispatcher = null;
		protected var _seekTarget:Number = 0;
		//设置一个timer用来检测起始时刻
		protected var _startCheckTimer:Timer = null;
		protected var _startTime:Number = 0;
		
		public function GSNetStream(connection:NetConnection, peerID:String="connectToFMS")
		{
			super(connection, peerID);
			_startCheckTimer = new Timer(100);
			_startCheckTimer.addEventListener(TimerEvent.TIMER, onCheckStartTime);
			_eventDispatcher = new EventDispatcher();
			this.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			this.client = new Object();	//默认情况下忽略此类事件
		}
		
		private function onCheckStartTime(evt:TimerEvent):void
		{
			if(this.time > 0)
			{
				//直到这个时刻才能算是可播放了
				_startTime = this.time;
				_startCheckTimer.stop();
				//trace("set to playing at time = " + this.time);
				onStateChange(_isGoingToPlay ? GSVideoState.PLAYING : GSVideoState.PAUSED);
			}
		}
		
		private function onNetStatus(evt:NetStatusEvent):void
		{
			
			//ExternalInterface.call("nextplayb", evt.info.code);
			
			
			
			if (evt.info.code == "NetStream.Play.Start")
			{
				//已经准备好，准备载入第一帧
				onStateChange(GSVideoState.BUFFERING);
				super.seek(0);
				_startCheckTimer.start();
			}else if (evt.info.code == "NetStream.Play.StreamNotFound")
			{
				//未找到流
				onStateChange(GSVideoState.CONNECTION_ERROR);
				_isGoingToPlay = false;
			}else if (evt.info.code == "NetStream.Play.Stop")
			{
				//视频播放完毕
				//trace("该片段播放完毕");
				onStateChange(GSVideoState.STOPPED);
			}else if (evt.info.code == "NetStream.Buffer.Empty")
			{
				//缓冲区空了，如果原来处于播放状态，那么此时进入Buffering状态
				//但是要注意如果所有数据都下载完毕了，缓冲区依然空了，说明起始不是要缓冲，而是播放完了
				//trace("缓冲区空了，bytesLoaded = " + bytesLoaded + ", bytesTotal = " + bytesTotal);
				if(_state == GSVideoState.PLAYING && this.bytesLoaded < this.bytesTotal)
				{
					onStateChange(GSVideoState.BUFFERING);
				}
			}else if (evt.info.code == "NetStream.Buffer.Full")
			{
				if(_state == GSVideoState.BUFFERING || _state == GSVideoState.PAUSED)
				{
					//如果原本处于缓冲状态，那么这表示缓冲结束，恢复原本的播放或者暂停状态
					//如果原本就是播放或者暂停状态，那么不影响原状态
					//其他状态都不是能够正常播放的状态，不做任何变化
					onStateChange(_isGoingToPlay ? GSVideoState.PLAYING : GSVideoState.PAUSED);
				}
			}else if (evt.info.code == "NetStream.Seek.Notify")
			{
				//寻址完成
				if(_state != GSVideoState.LOADING)
				{
					onStateChange(_isGoingToPlay ? GSVideoState.PLAYING : GSVideoState.PAUSED);
				}
			}else if (evt.info.code == "NetStream.Seek.InvalidTime")
			{
				//寻址的位置尚未下载，或者超过完整的视频长度 evt.info.details中包含一个时间代码（暂时没有用到），该代码指示用户可以搜索的最后一个有效位置
				var event:GSSeekEvent = new GSSeekEvent(GSVideoStateEvent.SEEK_UNDOWNLOAD_DATA);
				event.offset = _seekTarget;
				
				ExternalInterface.call("nextplayb", "-----------"+event.offset+"-----------");
				
				this._eventDispatcher.dispatchEvent(event);
				onStateChange(GSVideoState.PAUSED);
			}
		}
		
		public function get state():String
		{
			return _state;
		}
		
		public function get startTime():Number
		{
			return _startTime;
		}
		
		public override function play(...parameters):void
		{
			
			super.play(parameters[0]);
			onStateChange(GSVideoState.LOADING);
			_isGoingToPlay = true;
			
		}
		
		public override function play2(param:NetStreamPlayOptions):void
		{
			super.play2(param);
			onStateChange(GSVideoState.LOADING);
			_isGoingToPlay = true;
		}
		
		public override function pause():void
		{
			super.pause();
			if(_state == GSVideoState.PLAYING || _state == GSVideoState.BUFFERING)
			{
				onStateChange(GSVideoState.PAUSED);
			}
			_isGoingToPlay = false;
		}
		
		public override function resume():void
		{
			super.resume();
			if(_state == GSVideoState.PAUSED)
			{
				onStateChange(GSVideoState.PLAYING);
			}
			_isGoingToPlay = true;
		}
		
		public override function close():void
		{
			super.close();
			onStateChange(GSVideoState.DISCONNECTED);
			_isGoingToPlay = false;
		}
		
		public override function togglePause():void
		{
			super.togglePause();
			_isGoingToPlay = !_isGoingToPlay;
			if(!_isGoingToPlay && (_state == GSVideoState.PLAYING || _state == GSVideoState.BUFFERING))
			{
				onStateChange(GSVideoState.PAUSED);
			}else if(_isGoingToPlay && _state == GSVideoState.PAUSED)
			{
				onStateChange(GSVideoState.PLAYING);
			}
		}
		
		public override function seek(offset:Number):void
		{
			_seekTarget = offset;
			super.seek(offset);
			onStateChange(GSVideoState.SEEKING);
		}
		
		public function addGSNetStreamEventListener(type:String, listener:Function):void
		{
			_eventDispatcher.addEventListener(type, listener);
		}
		
		public function removeGSNetStreamEventListener(type:String, listener:Function):void
		{
			_eventDispatcher.removeEventListener(type, listener);
		}
		
		private function onStateChange(state:String):void
		{
			if(this._state != state)
			{
				_state = state;
				var event:Event = new Event(GSVideoStateEvent.STATE_CHANGE);
				this._eventDispatcher.dispatchEvent(event);
			}
		}
	}
}