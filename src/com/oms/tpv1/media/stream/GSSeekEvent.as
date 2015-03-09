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
	
	public class GSSeekEvent extends Event
	{
		protected var _offset:Number = 0;
		
		public function GSSeekEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public function get offset():Number
		{
			return _offset;
		}
		public function set offset(value:Number):void
		{
			_offset = value;
		}
	}
}