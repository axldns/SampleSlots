package SlotMachine.Parts.Ledscreen
{
	/**
	 * [axldns free coding 2015]
	 */
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import starling.events.EventDispatcher;

	public class LedControler extends EventDispatcher
	{
		private var leds:Vector.<LedScreen>;
		private var intervalID:uint;
		private var speed:Number;
		private var numConnected:int;
		private var _isON:Boolean;
		private var shuffleFunction:Function;
		
		/**
		 * Supplementary class to LedScreen. Actual executor of fun on character separated class. Very early stage
		 */
		public function LedControler(ledCharSpeed:Number)
		{
			speed = ledCharSpeed*1000;
			numConnected=0;
			leds = new Vector.<LedScreen>();
			shuffleFunction = forwardShuffle;
		}
		/**
		 * defines if texts goes from left to right or opposite.
		 */
		public function set directionForwad(forward:Boolean):void
		{
			shuffleFunction = forward ? forwardShuffle : backwardShuffle;
		}
		public function get directionForwad():Boolean
		{
			return shuffleFunction == forwardShuffle;
		}
		
		private function onTick():void
		{
			var i:int = numConnected;
			var led:LedScreen;
			var textArray:Array;
			while(i-->0)
			{
				led = leds[i];
				textArray =  led.textArray;
				shuffleFunction(textArray);
				for(var j:int = 0; j < led.numChars; j++)
					led.setSlotValue(j, textArray[j]);
			}
		}
		
		private function forwardShuffle(a:Array):void
		{
			a.push(a.shift());
		}
		private function backwardShuffle(a:Array):void
		{
			a.unshift(a.pop());
		}
		
		/**
		 * plug to ledScreen
		 */
		public function connect(led:LedScreen):void
		{
			leds.push(led);
			numConnected++;
			isON = true;
		}
		/**
		 * disconnects ledScreen from controler. If this is only ledScreen, it switches off itself
		 */
		public function disconnect(led:LedScreen):void
		{
			var i:int = leds.indexOf(led);
			if(i > -1)
			{
				leds.splice(i,1);
				numConnected--;
			}
			if(leds.length < 1)
				isOFF =true;
		}

		/**
		 * switches controler on and off
		 */
		public function set isON(value:Boolean):void
		{
			if(isON == value)
				return;
			_isON = value;
			
			if(isON)
				intervalID = setInterval(onTick,speed);
			else
				flash.utils.clearInterval(intervalID);
		}
		public function get isON():Boolean {return _isON}
		public function get isOFF():Boolean { return !_isON}
		public function set isOFF(v:Boolean):void{ isON = !v }

	}
}