package test
{
	import com.koma.utils.Guid;

	public class UtilsTest implements BaseTest
	{
		public function UtilsTest()
		{
		}
		
		public function runTest():void
		{
			// TODO Auto Generated method stub
			trace(Guid.calculate("abcdef"));
		}
		
	}
}