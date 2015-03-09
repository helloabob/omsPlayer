package  com.oms.tpv1.media.stream
{
	import com.gridsum.VideoTracker.IVodInfoProvider;
	//import flash.net.NetStream;
	import flash.external.ExternalInterface;
	import com.oms.tpv1.model.GlobalVars;
	
	public class NetStreamVodInfoProvider implements IVodInfoProvider{
		
		//private var _player:GSNetStream = null;
		
		public function NetStreamVodInfoProvider(player:GSNetStream){
			// constructor code
			GlobalVars._player = player;
			return;
		}
		
		public function getBitrate():Number
		{
			return 0;
		}
		
		public function getPosition():Number
		{
			//trace(GlobalVars._Nowtime);
			return GlobalVars._Nowtime;
		}
		
		public function getFramesPerSecond():Number
		{
			return 25;
		}
	}
}
