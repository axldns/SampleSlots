package Game
{
	/**
	 * [axldns free coding 2015]
	 */
	import flash.display.Bitmap;
	
	import SlotMachine.Machine;
	
	import axl.utils.U;
	
	import starling.display.Sprite;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class Main extends Sprite
	{
		private var mainAtlas:TextureAtlas;
		private var font:BitmapFont;
		private var machine:Machine;
		private var definition:XML;
		
				
		public function Main()
		{
			super();
			init();
			build();
		}	
		/**
		 * Instantiates neccessary materials: main TextureAtlas, BtmapFont and application XML definition
		 */
		private function init():void
		{
			mainAtlas = new TextureAtlas(
				Texture.fromBitmap(Bitmap(U.assets.getAsset('slotmachine.png')),true,false,U.scalarReversed),
				XML(U.assets.getAsset('slotmachine.xml'))
			);
			
			font = new BitmapFont(
				mainAtlas.getTexture('font.png'),
				XML(U.assets.getAsset('font.fnt'))
			);
			
			TextField.registerBitmapFont(font,'font');
			
			definition = XML(U.config.CONFIG.slotmachine);
		}
		
		/**
		 * Instantiates tha actuall slot machine
		 */
		private function build():void
		{
			machine = new Machine(mainAtlas,definition);
			this.addChild(machine);
		}
		
	}
}