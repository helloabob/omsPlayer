package  com.oms.tpv1.media.stream
{
	import flash.events.Event;

	public class GSVideoStateEvent extends Event
	{
		public static const STATE_CHANGE:String = "stateChange";
		public static const MEDIA_OPENED:String = "mediaOpened";
		public static const MEDIA_FAILED:String = "mediaFailed";
		public static const METADATA_RECEIVED:String = "metadataReceived";
		public static const SEEK_UNDOWNLOAD_DATA:String = "videoSeekUndownloadData";
		
		public var videoState:String = null;
		
		public function GSVideoStateEvent(type:String)
		{
			super(type);
		}
		
		override public function clone():Event
		{
			var evt:GSVideoStateEvent = new GSVideoStateEvent(type);
			evt.videoState = videoState;
			return evt;
		}
	}
}