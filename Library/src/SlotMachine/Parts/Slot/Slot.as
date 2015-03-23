package SlotMachine.Parts.Slot
{
	/**
	 *  [axldns free coding 2015]
	 */
	import axl.utils.Carusele;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class Slot extends Carusele
	{
		private var slotStations:Vector.<Icon>;
		private var holdButton:SlotButton;
		private var img_wheel:Image;
		private var isLocked:Boolean;
		private var isHold:Boolean;
		
		/**
		 * Class which contains all singular Icon instances and makes it aligned and movable in specific way
		 * contains much more than displays.Means much more than it contains. 
		 * <b> wheelImage and holdButton <b>are not </b> part of this instance display list 
		 * and should not be added in here. It makes it available for other machine parts but keeps most important refference.
		 */
		public function Slot(wheeltexture:Texture)
		{
			super();
			this.isVERTICAL = true;
			if(wheeltexture)
			{
				img_wheel = new Image(wheeltexture);
				this.addChildAt(img_wheel,0);
			}
		}
		/**
		 * takes wheel from its current space and resets dimensions to originals
		 */
		public function takeWheelBack():void
		{
			img_wheel.x = img_wheel.y = 0;
			img_wheel.scaleX = img_wheel.scaleY = 1;
			wheel.removeFromParent();
		}
		/**
		 * takes wheel from its current space and resets dimensions to originals
		 */
		public function takeHoldButtonBack():void
		{
			holdButton.x = holdButton.y = 0;
			holdButton.scaleX = holdButton.scaleY = 1;
			holdButton.removeFromParent();
		}
		/**
		 * takes assembly parts from its (wheel, holdButton) current space and resets dims to originals 
		 */
		public function takeBelongingsBack():void
		{
			takeWheelBack();
			takeHoldButtonBack();
		}
		/**
		 * if slot isHOLD, this method will not work
		 */
		override public function movementBit(delta:Number):void
		{
			if(!isHold)	super.movementBit(delta);
		}
		/**
		 * defines button that bellongs to slot and it's behaviour may variy 
		 */
		public function set holdbutton(value:SlotButton):void
		{
			holdButton = value;
			holdButton.addEventListener(Event.TRIGGERED, holdButtonDown)
		}
		
		private function holdButtonDown(e:Event):void
		{
			isHOLD = !isHOLD;
			this.dispatchEvent(e);
		}
		/**
		 * if its hold, <code> movementBit</code> function wont be executed. holdButton (if exists) is down true and up on false
		 */
		public function get isHOLD():Boolean { 	return isHold }
		public function set isHOLD(v:Boolean):void
		{
			isHold= v;
			if(this.holdButton)
				this.holdButton.isDOWN = v;
		}
		/**
		 * if its locked for input, hold button (if exists gets disabled, regardles of its state
		 */
		public function get isLockedForInput():Boolean { return isLocked }
		public function set isLockedForInput(v:Boolean):void 
		{ 
			isLocked = v;
			if(this.holdButton)
				this.holdButton.isEnabled = !v; 
		}
		
		public function get holdbutton():SlotButton { return holdButton }
		public function get wheel():Image { return img_wheel }
		
	}
}