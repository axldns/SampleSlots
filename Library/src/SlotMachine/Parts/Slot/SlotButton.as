package SlotMachine.Parts.Slot
{
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	/**
	 * Way simplified version of starlings Button class. This one got just two states (three in fact). Up, Down and disabled.
	 * SlotButton is more like toggle switch 
	 */
	public class SlotButton extends Image
	{
		
		private var up:Texture;
		private var down:Texture;
		private var _isEnabled:Boolean = true;
		private var isUp:Boolean = true;
		public function SlotButton(upstate:Texture, downstate:Texture)
		{
			up = upstate;
			down = downstate;
			super(up);
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			if (!isEnabled)
				return;
			var touch:Touch = event.getTouch(this);
			if(!touch)
				return;
			else if (touch.phase == TouchPhase.BEGAN)
			{
				isUP = !isUP
				dispatchEventWith(Event.TRIGGERED, true);
			}
		}
		
		public function get isEnabled():Boolean	{ return _isEnabled }
		public function set isEnabled(value:Boolean):void { _isEnabled = value }

		public function get isUP():Boolean { return isUp }
		public function set isUP(value:Boolean):void
		{
			isUp = value;
			this.texture = isUP ?  this.up : this.down
		}
		
		public function set isDOWN(v:Boolean):void { isUP = !v}
		public function get isDOWN():Boolean { return !isUP }
	}
}