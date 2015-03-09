package com.oms.tpv1.media.players
{
	
	import com.gridsum.VideoTracker.IVodInfoProvider;
	
	import flash.external.*;
	import com.oms.tpv1.media.stream.CommonStream;
	
	public class FLVPlaybackVodInfoProvider implements IVodInfoProvider{
		
		private var _player:* = null;
		
		public function FLVPlaybackVodInfoProvider(player:*) {
			// constructor code
			_player = player;
		}
		
		/**描述：
		 *    Video Monitor Tracker SDK的使用者实现这个接口，以返回点播
		 *    视频的当前码率。如果当前视频不是可变码率的，返回0即可，如果
		 *	  是可变码率，请根据实际情况补全码率获取代码。
		 * 参数：无
		 * 返回值：
		 *    当前时刻视频所使用的码率
		 */
		public function getBitrate():Number
		{
			return 0;
		}
		
		/**描述：
		 *    Video Monitor Tracker SDK的使用者实现这个接口，以返回点播
		 *    视频的播放位置。
		 * 参数：无
		 * 返回值：
		 *    点播视频当前的播放到的位置，以秒为单位，精确到小数点后2位。如果当前还不知道
		 *    视频所播放到的位置（比如视频根本就没有打开），则返回-1。
		 */
		public function getPosition():Number
		{
			
			//ExternalInterface.call("nextplayb", 0);
			//return 0;
			return _player.playheadTime;
		}
		
		public function getFramesPerSecond():Number
		{
			return 20;
		}
	}
	
}
