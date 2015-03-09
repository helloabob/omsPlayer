package com.oms.tpv1.utils
{
	
	import com.oms.tpv1.model.*;
	
	
	public class PlayTimeUtil extends Object
	{
		public function PlayTimeUtil()
		{
			return;
		}// end function
		
		public static function getPlayTimeInfo(param1:Number = -1, param2:Number = -1, param3:Number = -1, param4:Number = -1, param5:Number = -1, param6:Boolean = false) : PlayTime
		{
			var _loc_7:* = new PlayTime();
			if (param1 < param2 && param1 >= 0)
			{
				_loc_7.starttime = param1;
				_loc_7.attstarttime = param1;
				_loc_7.endtime = param2;
				_loc_7.starttype = PlayTime.TYPE_ATTRACTION_START;
				_loc_7.endtype = PlayTime.TYPE_ATTRACTION_END;
				if (param3 > 0 && param3 > param1 && param3 < param2)
				{
					_loc_7.starttime = param3;
				}
			}
			else
			{
				if (param4 >= 0 && param4 < param5)
				{
					if (param6)
					{
						_loc_7.starttime = param4;
						_loc_7.starttype = PlayTime.TYPE_HEAD;
					}
					_loc_7.headstarttime = param4;
					_loc_7.endtime = param5;
					_loc_7.endtype = PlayTime.TYPE_TAIL;
				}
				if (param3 > 0)
				{
					_loc_7.starttime = param3;
					_loc_7.starttype = PlayTime.TYPE_HISTORY;
				}
			}
			return _loc_7;
		}// end function
		
		public static function changeFormatPlaytime(param1:PlayTime, param2:Number) : PlayTime
		{
			param1.starttime = param2;
			param1.starttype = PlayTime.TYPE_NONE;
			return param1;
		}// end function
	}
}