package SlotMachine.Parts.Window
{
	/**
	 *  [axldns free coding 2015]
	 */
	import flash.geom.Rectangle;
	
	import SlotMachine.Parts.Slot.Slot;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.extensions.pixelmask.PixelMaskDisplayObject;
	import starling.textures.Texture;
	
	public class Window extends Sprite
	{
		private var pmContainer:PixelMaskDisplayObject;
		private var img_glass:Image;
		private var img_frame:Image;
		
		private var slotContainer:Sprite;
		private var wheelContainer:Sprite;
		private var buttonContainer:Sprite;
		
		private var allSlots:Vector.<Slot>;
		private var _slotGap:Number;
		private var _usableHeight:Number;
		private var _usableWidth:Number;
		private var innerFrame:Rectangle;
		private var def:XML;
		
		/**
		 * Main DisplayObject of slot machine. Does not contain any logic appart from design related
		 *  Here slots and it's componentss are being connected and installed
		 * (including reasembling).
		 * Class uses PixelMask starling extension to mask all slots. It also overrides super important 
		 * starling core function of all DisplayObjects: <code>getBounds</code>! It returnes fixed size Rectangle 
		 * for purposes of consistency of alingment
		 */
		public function Window(glass:Texture,frame:Texture)
		{
			super();
			innerFrame = new Rectangle(0,0, frame.width, frame.height);
			allSlots = new Vector.<Slot>();
			img_glass = new Image(glass);
			img_frame = new Image(frame);
			pmContainer = new PixelMaskDisplayObject();
			pmContainer.mask = this.img_glass;
			slotContainer = new Sprite();
			wheelContainer = new Sprite();
			buttonContainer = new Sprite();
			
			slotContainer.x = img_glass.width>>1;
			slotContainer.y = img_glass.height>>1;
			wheelContainer.x = img_glass.width>>1;
			wheelContainer.y = img_glass.height>>1;
			buttonContainer.x = img_glass.width>>1;
			buttonContainer.y = img_glass.height;
			
			
			this.pmContainer.addChild(wheelContainer);
			this.pmContainer.addChild(slotContainer);
			this.addChild(pmContainer);
			this.addChild(img_glass);
			this.addChild(img_frame);
			this.addChild(buttonContainer);
			
		}
		
		public override function getBounds(targetSpace:DisplayObject, resultRect:Rectangle=null):Rectangle
		{
			super.getBounds(targetSpace,innerFrame);
			innerFrame.width = img_frame.width;
			innerFrame.height= img_frame.height + buttonContainer.height;
			return innerFrame;
		}
		/**
		 * Installs slot to window by disassembling some parts of it and places bits into different scale spaces.
		 * This solution allows to put many slots into super alligned spaces while keeping it's destinated visual features.
		 * @params realign - indicates whole structure redistribution/rescalling. If you need to pass more than one slot,
		 * you should probably set it to fallse and call <code>realign</code> manualy afterwars or use <code>installSlots</code>
		 * method instead 
		 */
		public function installSlot(slot:Slot,realign:Boolean=true):void
		{
			if(allSlots.indexOf(slot) > -1)
				return;
			allSlots.push(slot);
			slotContainer.addChild(slot);
			wheelContainer.addChild(slot.wheel);
			buttonContainer.addChild(slot.holdbutton);
			if(realign)
				rearange();
		}
		/**
		 * uses installSlot function to add the slot to window, calls <code>realign</code> once whole set of Slot-s is added
		 */
		public function installSlots(setOf:Vector.<Slot>):void
		{
			while(setOf.length)
				installSlot(setOf.pop(),false);
			rearange();
			setOf = null;
		}
		/**
		 * uninstalls slot from window and removes its part from it.
		 */
		public function uninstallSlot(slot:Slot):void
		{
			var i:int = allSlots.indexOf(slot);
			if(i > -1)
				allSlots.splice(i,1);
			if(slotContainer.contains(slot))
			{
				slotContainer.removeChild(slot);
				slot.takeBelongingsBack();
			}
			rearange();
		}
		/**
		 * returns a slod specifided by v index (adding order)
		 */
		public function getSlot(v:int):Slot
		{
			if(v > -1 && v < numSlots)
				return allSlots[v];
			return null;
		}
		/**
		 * returns refference to vector of all installed slots
		 */
		public function get slots():Vector.<Slot> {	return this.allSlots }
		public function get numSlots():Number { return allSlots.length };
		
		/**
		 * realignes whole graphical window structure according to params and circumstances 
		 */
		public function rearange():void
		{
			var slotSpot:Number = this.img_glass.width * usableWidth / this.numSlots;
			var actualGap:Number = slotSpot * slotGap;
			var cs:Slot;
			var i:int = this.allSlots.length;
			while(i-->0)
			{
				cs= allSlots[i];
				cs.width = slotSpot-actualGap;
				cs.scaleY = cs.scaleX;
				cs.x = i * slotSpot;
				
				cs.wheel.height = this.img_glass.height * usableHeight;
				cs.wheel.width = cs.width;
				cs.wheel.x = cs.x;
				
				cs.holdbutton.width = cs.width;
				cs.holdbutton.scaleY = cs.holdbutton.scaleX;
				cs.holdbutton.x = cs.x;
			
			}
			
			slotContainer.pivotX = slotContainer.width>>1;
			wheelContainer.pivotX = wheelContainer.width>>1;
			wheelContainer.pivotY = wheelContainer.height>>1;
			buttonContainer.pivotX = buttonContainer.width>>1;
		}
		
		/**
		 * Value of distance between horizontally distributed slots
		 */
		public function get slotGap():Number { return _slotGap	}
		public function set slotGap(value:Number):void
		{
			_slotGap = value;
			rearange();
		}
		/**
		 * this allows you to use frame and glass images of different styles, as some may requrie different settings
		 * depending on their apperiance
		 */
		public function get usableHeight():Number { return _usableHeight }
		public function set usableHeight(value:Number):void
		{
			_usableHeight = value;
			rearange();
		}
		/**
		 * simmilar to <code>usableHeight</code> makes percentage of width which is to use by Slots
		 */
		public function get usableWidth():Number {return _usableWidth }
		public function set usableWidth(value:Number):void
		{
			_usableWidth = value;
			rearange();
		}

		public function get definition():XML { return def }
		public function set definition(value:XML):void 
		{
			def = value;
			parseDefinition();
		}
		
		public function parseDefinition():void
		{
			usableWidth = Number(def.usableWidth);
			usableHeight = Number(def.usableHeight);
			slotGap = Number(def.slotGap);
		}
		
	}
}