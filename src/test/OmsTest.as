package test
{
	import flash.display.Sprite;

	public class OmsTest extends Sprite
	{
		private var utilsTest:BaseTest = new UtilsTest();
		
		public function OmsTest()
		{
			/*case 1*/
			utilsTest.runTest();
		}
	}
}