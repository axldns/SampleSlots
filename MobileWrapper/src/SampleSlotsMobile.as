package
{
	import axl.utils.U;
	
	[SWF(width="1024", height="768", frameRate="60", backgroundColor="0x222222")]
	
	public class SampleSlotsMobile extends Slots2
	{
		public function SampleSlotsMobile()
		{
			super();
		}
		// mobile specific code
		override public function setup():void
		{
			super.setup();
			U.ISWEB = false;
			U.DEBUG = false
			// provide different config if you like to 
			// U.configSubpath = '/assets/cfg.xml';
		}
	}
}