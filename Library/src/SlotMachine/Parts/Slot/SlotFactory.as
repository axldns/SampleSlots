package SlotMachine.Parts.Slot
{
	/**
	 * [axldns free coding 2015]
	 */
	import starling.textures.Texture;

	public class SlotFactory
	{
		public var iconNames:Vector.<String>;
		public var iconTextures:Vector.<Texture>;
		
		public var slotButtonUpTexture:Texture;
		public var slotButtonDownTexture:Texture;
		public var railTexture:Texture;
		
		
		private var numSlots:Number;
		private var def:XML;
		private var gapOfIcon:Number;
		private var updateEvery:Number;
	
		public function SlotFactory()
		{
		}
		/**
		 * closes factory and destoyes it's resources, including disposing textures, 
		 * which probably program wont be able to restore if 3d context is lost
		 */
		public function shutDown():void
		{
			if(iconTextures)
			{
				while(iconTextures.length)
					iconTextures.pop().dispose();
			}
			iconTextures = null;
			
			if(railTexture) railTexture.dispose();
			railTexture = null;
			
			if(slotButtonUpTexture) slotButtonUpTexture.dispose();
			slotButtonUpTexture = null;
			
			if(slotButtonDownTexture) slotButtonDownTexture.dispose();
			slotButtonDownTexture = null;
			
			
		}
		/**
		 * Instantiates and presets Slot class instance (and all Icon instances), according to settings passed in definition
		 */
		public function makeSlot():Slot
		{
			var slot:Slot = new Slot(railTexture);
				slot.GAP = gapOfIcon;
			var ic:Icon;
			var i:int = iconTextures.length;
			while(i-->0)
			{
				ic = new Icon(iconTextures[i],iconNames[i]);
				ic.definition = def.icons.icon.(@id == ic.name)[0];
				slot.addToRail(ic);
			}
			slot.sortEvery = slot.railBounds.height * updateEvery;
			slot.holdbutton = new SlotButton(slotButtonUpTexture, slotButtonDownTexture);
			slot.rearange();
			return slot;
		}
		/**
		 * uses function makeSlot in a loop. Returnns vector of preset Slot instances
		 */
		public function makeSlots():Vector.<Slot>
		{
			var i:int = numSlots;
			var v:Vector.<Slot> = new Vector.<Slot>();
			while(i-->0)
				v.push(makeSlot());
			return v;
		}
		
		public function get definition():XML { return def }

		public function set definition(value:XML):void
		{
			def = value;
			numSlots = Number(def.numSlots);
			gapOfIcon = Number(def.gapOfIcon);
			gapOfIcon = iconTextures[0].height * gapOfIcon;
			updateEvery = Number(def.updateEvery);
		}
	}
}