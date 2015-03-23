package
{
	/**
	 * [axldns free coding 2015]
	 */
	import flash.display.Sprite;
	
	import Game.Main;
	
	import axl.utils.U;
	
	import starling.core.Starling;
	
	[SWF(width="1024", height="768", frameRate="60", backgroundColor="0x222222")]
	
	public class Slots2 extends Sprite
	{
		[Embed(source = "assets/loading.jpg")]
		private static const Splash:Class;
		private static const designedForWidth:Number = 1024;
		private static const designedForHeight:Number = 768;
		
		private static var starilngInstance:Starling;
		
		public function Slots2()
		{
			super();
			setup();
			build();
		}
		
		public function setup():void
		{
			U.configSubpath = '/assets/cfg.xml';
		}
		
		public function build():void
		{
			U.init(stage, designedForWidth, designedForHeight,Game.Main, new Splash());
		}
		
	}
}