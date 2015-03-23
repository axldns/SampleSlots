package SlotMachine.Parts.Control
{
	/**
	 * [axldns free coding 2015]
	 */
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	import SlotMachine.Parts.Slot.Icon;
	import SlotMachine.Parts.Slot.Slot;
	
	import axl.utils.Easing;
	import axl.utils.U;
	
	import starling.events.Event;
	import starling.events.EventDispatcher;

	
	public class WheelTrigger extends EventDispatcher
	{
		public static const EVENT_SPIN_COMPLETE:String = 'spinComplete';
		private static const SPIN_COMPLETE_EVENT:Event = new Event(EVENT_SPIN_COMPLETE);
		
		private var _slots:Vector.<Slot>;
		private var _result:Vector.<Icon>;
		private var animationData:Vector.<Point>;
		private var pooledPropertyObject:Object;
		
		private var spinToComplete:int;
		private var railLength:Number;
		private var numSlots:int;
		private var IS_SPINNING:Boolean;
		
		public var minSpinTime:Number;
		public var maxSpinTime:Number;
		public var minRotations:Number;
		public var maxRotations:Number;
		
		private var channelSpinning:SoundChannel; // this should not be here
		private var spinningSoundTransform:SoundTransform;  // this should not be here
		
		/**
		 * This class is the actual executor of spinning wheels. contains references to machine Slots and makes use of it. 
		 * Dispatches SPIN_COMPLETE_EVENT after each cycle
		 */
		public function WheelTrigger()
		{
			animationData = new Vector.<Point>();
			_result = new Vector.<Icon>();
			pooledPropertyObject = {};
			spinningSoundTransform = new SoundTransform();
		}
		
		public function spinAllWheels():void
		{
			spinToComplete = numSlots;
			var time:Number;
			var distance:Number;
			var i:int = numSlots;
			while(i-->0)
			{
				if(_slots[i].isHOLD)
				{
					spinToComplete--; // were not animating hold objects. even its helper data remains still
					continue;
				}
				
				// reseting previous spin data
				_result[i] = null;
				animationData[i].setTo(0,0);
				
				//applying new
				time = (Math.random() * (this.maxSpinTime - this.minSpinTime) + this.minSpinTime);
				distance = (Math.random() * (this.maxRotations - this.minRotations) + this.minRotations) * railLength;
				pooledPropertyObject.y = distance;
				
				//executing animation
				Easing.animate(animationData[i], time, pooledPropertyObject , mainSpinComplete,[i],null,false,false,false, manualUpdate,[i]);
			}
			
			// in case of somehow all slots were hold
			if(spinToComplete == 0)
				IS_SPINNING = false;
			else
			{
				IS_SPINNING = true;
				//spin sound loundes shouldbe adequate to number of slots spinning
				spinningSoundTransform.volume = spinToComplete/numSlots;
				channelSpinning = Sound(U.assets.getAsset('spinning.mp3')).play(0,10,spinningSoundTransform);
			}
		}
		/**
		 * this function is triggered every time one slot finishes its main animation.
		 *  separate slots execute this same function
		 */
		private function mainSpinComplete(ind:int):void
		{
			// now object needs to click on place if animation distanc left it not in line
			var info:Array = _slots[ind].getChildClosestToCenter();
			pooledPropertyObject.y = info.pop();
			animationData[ind].setTo(0,0);
			
			Easing.animate(animationData[ind], 1, pooledPropertyObject, clickOnPlaceComplete,[ind,info.pop()],Easing.easeOutQuart,false,false,false, manualUpdate,[ind]);
			info = null;
			
			//everyslot makes spinning sound quiter
			spinningSoundTransform.volume  *= .6;
			channelSpinning.soundTransform = spinningSoundTransform;
			Sound(U.assets.getAsset('spinEndCycle.mp3')).play();
		}
		
		/**
		 * same as mainSpinComplete, slots finding they're spot are executing this one
		 * spin to complete variable controlls when to dispatch notification to controler
		 * that all animations of all objects are compllete
		 */
		private function clickOnPlaceComplete(slotIndex:int, wonSpot:Icon):void
		{
			//by passing indexes to animation engine on complete, we know which object is on which place
			//acces table result with general slot indexes to get slot icon drawn
			result[slotIndex] = wonSpot;
			if(--spinToComplete == 0)
			{
				this.dispatchEvent(SPIN_COMPLETE_EVENT);
				IS_SPINNING = false;
				channelSpinning.stop();
			}
		}
		/**
		 * instead of passing large objects to animation, were passing points and they're indexes
		 * to perform optimal and use movementBit function of carusele class
		 */
		private function manualUpdate(ind:int):void
		{
			var o:Point = animationData[ind];
			o.x = o.y - o.x;
			_slots[ind].movementBit(o.x);
			o.x = o.y;
		}
		
		/**
		 * set slots to animate. and prepares internal helper objects.
		 * each asignment removes current slots. to uninstall all pass null.
		 */
		public function set slots(value:Vector.<Slot>):void
		{
			uninstallSlots();
			if(value == null)
				return
			_slots = value;
			numSlots = _slots.length;
			while(_result.length > numSlots)
				_result.pop();
			while(_result.length < numSlots)
				_result.push(null);
			if(numSlots > 0)
				railLength = _slots[0].railBounds.height;
			animationObjects = numSlots;
		}
		
		/**
		 * removes all slots and resets helper data
		 */
		private function uninstallSlots():void
		{
			if(_slots) _slots.length = 0;
			if(animationData) animationData.length = 0;
			if(result) result.length = 0;
			railLength = 0;
			numSlots = 0;
		}
		
		/**
		 * probably not the most smart way to deal with vectos, with whcich (unlike like with arrays) 
		 * you can not set index at unexsisting yet length
		 */
		private function set animationObjects(numSlots:uint):void
		{
			while(animationData.length < numSlots)
				animationData.push(new Point);
			while(animationData.length > numSlots)
				animationData.pop();
		}
		/**
		 * Tells whether animations are in progress
		 */
		public function get isSpinning():Boolean { return IS_SPINNING  }
		/**
		 * returns reference to drawn icons set (from each slot), keeping its order
		 * see Icon class to get idea.
		 */
		public function get result():Vector.<Icon> { return _result	}

	}
}