package com.oms.report
{
	import com.oms.tpv1.model.*;

	//import com.oms.tpv1.model.GlobalVars;
	
	//一些基本的REPORT的对象操作
	public class ReportMode extends Object
	{
		public var url:String;
		public var version:String;
		public var ispac:String;
		public var cmid:String;
		public var exid:String;
		public var autoformat:int;
		public var pid:String;
		public var platform:int = 1;
		public var loadwait:Number = 0;
		public var bufferwait:Number = 0;
		public var cpay:int;
		public var tpay:String;
		public var bt:Number = 0;
		public var vid:String = "";
		public var vt:Number = 0;
		public var format:String = "";
		public var idx:int = 0;
		public var type:String = "0";
		public var level:String = "0";
		public var vurl:String = "";
		public var buffersize:Number = 0;
		public var rid:String = "";
		public var bi:Number = 0;
		public var step:int = 0;
		public var val:Number = 0;
		public var val1:Number = 0;
		public var val2:Number = 0;
		public var clspeed:Number = 0;
		public var ctime:String = "";
		public var ptime:String = "";
		public var rnum:int = 1;
		public var emsg:String = "";
		public var pfversion:String;
		public var preformat:String = "";
		public var ptag:String;
		public var predefn:String = "";
		public var defn:String = "";
		public var index:uint = 0;
		public var pverion:String;
		public var dltype:int;
		
		public function ReportMode()
		{
			this.url = GlobalVars.usingHost;
			this.version = GlobalVars.version;
			//this.ispac = GlobalVars.ispAc;
			this.cmid = GlobalVars.playerLocalInfo.guid;
			this.exid = GlobalVars.exid;
			this.autoformat = GlobalVars.isAutoFormat ? (1) : (0);
			this.pid = GlobalVars.pid;
			this.cpay = GlobalVars.isPayedVideo ? (1) : (0);
			this.tpay = GlobalVars.payedVideoStatus;
			this.pfversion = GlobalVars.majorVersion + "." + GlobalVars.minorVersion;
			this.ptag = GlobalVars.ptag;
			//this.pverion = GlobalVars.p2pVersion;
			this.dltype = ReportManager.DLTYPE_HTTP;
			return;
		}// end function
		
		public function copy() : ReportMode
		{
			var _loc_1:* = new ReportMode();
			_loc_1.url = this.url;
			_loc_1.version = this.version;
			_loc_1.ispac = this.ispac;
			_loc_1.cmid = this.cmid;
			_loc_1.exid = this.exid;
			_loc_1.autoformat = this.autoformat;
			_loc_1.pid = this.pid;
			_loc_1.cpay = this.cpay;
			_loc_1.bt = this.bt;
			_loc_1.vid = this.vid;
			_loc_1.vt = this.vt;
			_loc_1.format = this.format;
			_loc_1.idx = this.idx;
			_loc_1.type = this.type;
			_loc_1.vurl = this.vurl;
			_loc_1.buffersize = this.buffersize;
			_loc_1.rid = this.rid;
			_loc_1.bi = this.bi;
			_loc_1.step = this.step;
			_loc_1.val = this.val;
			_loc_1.val1 = this.val1;
			_loc_1.val2 = this.val2;
			_loc_1.clspeed = this.clspeed;
			_loc_1.ctime = this.ctime;
			_loc_1.ptime = this.ptime;
			_loc_1.rnum = this.rnum;
			_loc_1.level = this.level;
			_loc_1.emsg = this.emsg;
			_loc_1.pfversion = this.pfversion;
			_loc_1.preformat = this.preformat;
			_loc_1.ptag = this.ptag;
			_loc_1.predefn = this.predefn;
			_loc_1.defn = this.defn;
			return _loc_1;
			
		}// end function
	}
}