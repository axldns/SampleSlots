package
{
	import axl.utils.U;
	
	[SWF(width="1024", height="768", frameRate="60", backgroundColor="0x222222")]
	public class SampleSlotsWeb extends Slots2
	{
		public function SampleSlotsWeb()
		{
			super();
		}
		
		//web specific code
		override public function setup():void
		{
			super.setup();
			axl.utils.U.ISWEB = true;
			
			// provide different config if you like to 
			// U.configSubpath = '/assets/cfg.xml';
		}
	}
}