package com.oms.tpv1.resource
{
	import com.oms.tpv1.resource.*;
	import com.oms.tpv1.resource.zh_cn.*;
	//import com.oms.tpv1.resource.en_us.*;
	//import com.oms.tpv1.resource.zh_hk.*;
	
	
	import flash.utils.*;
	
	public class ResourceManager extends Object
	{
		private var currres:String = "zh_cn";
		private var msgClass:Class;
		private var msg:Object;
		public static const en_us:String = "en_us";
		public static const zh_cn:String = "zh_cn";
		public static const zh_hk:String = "zh_hk";
		private static var _instance:ResourceManager;
		
		public function ResourceManager()
		{
			var _loc_1:VideoMessages = null;
			//var _loc_2:com.oms.tpv1.resource.en_us::VideoMessages = null;
			//var _loc_3:com.oms.tpv1.resource.zh_hk::VideoMessages = null;
			return;
		}// end function
		
		public function setResource(param1:String) : void
		{
			this.currres = param1;
			return;
		}// end function
		
		public function getContent(param1:String) : String
		{
			if (!this.msg)
			{
				this.msgClass = getDefinitionByName("com.oms.tpv1.resource." + this.currres + ".VideoMessages") as Class;
				this.msg = new this.msgClass();
			}
			return this.msg[param1];
		}// end function
		
		public static function get instance() : ResourceManager
		{
			if (!_instance)
			{
				_instance = new ResourceManager;
			}
			return _instance;
		}// end function
	}
}