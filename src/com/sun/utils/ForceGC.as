package com.sun.utils
{
	import flash.net.*;
	
	public class ForceGC extends Object
	{
		
		public function ForceGC()
		{
			return;
		}// end function
		
		public static function gc():void
		{
			try
			{
				new LocalConnection().connect("foo");
				new LocalConnection().connect("foo");
			}
			catch (e:Error)
			{
			}
			return;
		}// end function
		
	}
}