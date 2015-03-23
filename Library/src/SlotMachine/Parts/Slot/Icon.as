package SlotMachine.Parts.Slot
{
	/**
	 * [axldns free coding 2015]
	 */
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class Icon extends Image
	{
		
		private var def:XML;
		private var _betPrice:int;
		private var _prizes:Object = {}
			
		/**
		 * Graphical representation of a single image placed on slot machine spin roll
		 * @param texture: - regular image texture, 
		 * @param textureName: - actual name will be substringed starting from first index of '_' to first index of '.' 
		 * usefull while factory created from getTextures vector 
		 * 
		 */
		public function Icon(texture:Texture,textureName:String)
		{
			super(texture);
			
			this.name = textureName.substr(textureName.indexOf('_')+1);
			this.name = name.substr(0,name.indexOf('.'));
			
		}

		
		/**
		 * pass all slot spot prices and prizes here
		 */
		public function get definition():XML { return def }
		public function set definition(value:XML):void
		{
			def = value;
			this._betPrice = int(def.@betPrice);
			var xl:XMLList = def.attributes();
			var i:int = xl.length();
			var xm:XML;
			while(i-->0)
			{
				xm = xl[i];
				prizes[String(xm.name())] = Number(xm.valueOf());
			}
		}
		public function get betPrice():int { return _betPrice }
		public function get prizes():Object	{ return _prizes }

		


	}
}