package SlotMachine.Parts.Control
{
	/**
	 * [axldns free coding 2015]
	 */
	import SlotMachine.Parts.Ledscreen.LedScreen;
	import SlotMachine.Parts.Slot.Slot;
	
	import axl.utils.U;
	
	import starling.display.Button;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class Controler 
	{
		private var _points:LedScreen;
		private var _messager:LedScreen;
		private var _slots:Vector.<Slot>;
		private var _spinButton:Button;
		
		private var spinner:WheelTrigger;
		private var numSlots:uint;
		
		private var IS_GAME_STARTED:Boolean;
		private var IS_NOT_ENOUGH_MONEY:Boolean;
		private var startMoney:int = 1000;
		private var moneyPerSpin:Number = 50;
		private var currentMoney:int;
		private var def:XML;
		
		
		/**
		 * msg_ prefixed constant values are reffering to group of random messages definded in ledscreen definiton xml
		 */
		private const msg_zeroMatch:String='zeroMatches';
		private const msg_startSpin:String = 'startSpin';
		private const msg_hitWhileSpinning:String = 'hitWhileSpinning';
		private const msg_notEnoughMoney:String = 'notEnoughMoney';
		private const msg_startGame:String='startGame';
		
		/**
		 * Class which controlls entire machine behaviour. Not a display object
		 * States, logic, points etc.
		 */
		
		public function Controler()
		{
			spinner = new WheelTrigger();
			spinner.addEventListener(WheelTrigger.EVENT_SPIN_COMPLETE, spinComplete);
		}
		
		private function spinRequsted(e:Event=null):void
		{
			
			if(!IS_GAME_STARTED)
				startGameActions();
			if(spinner.isSpinning)
			{
				messager.randomMessage(this.msg_hitWhileSpinning);
				U.assets.getAsset('btnSpinWrong.mp3').play();
			}
			else
			{
				var bettingMoney:int = takBettingMoney();
				IS_NOT_ENOUGH_MONEY = ((money - moneyPerSpin - bettingMoney)  < 0)
				if(IS_NOT_ENOUGH_MONEY)
				{
					messager.randomMessage(this.msg_notEnoughMoney);
					U.assets.getAsset('btnSpinWrong.mp3').play();
				}
				else
				{
					U.assets.getAsset('btnSpinOk.mp3').play();
					money -= (moneyPerSpin + bettingMoney);
					lockSlotsForInput();
					spinner.spinAllWheels();
					messager.randomMessage(this.msg_startSpin);
				}
			}
		}
		
		
		private function lockSlotsForInput():void
		{
			var i:int = this.numSlots;
			while(i-->0)
				slots[i].isLockedForInput = true
		}
		
		private function unlockSlotsForInput():void
		{
			var i:int = this.numSlots;
			while(i-->0)
				slots[i].isLockedForInput = false;
		}
		
		
		private function checkOccurences2():Array
		{
			var s:String;
			var ocor:Array = [];
			for(var i:int = 0; i < this.numSlots; i++)
			{
				s = spinner.result[i].name;
				ocor[i] = 1;
				
				for(var j:int = i+1; j < this.numSlots; j++)
				{
					if(s == spinner.result[j].name)
					{
						ocor[i]++;
					}
				}
			}
			return ocor;
		}
		
		private function areThereOnlyBetPairs(index:Number):Boolean
		{
			var s:String = spinner.result[index].name;
			for(var i:int = 0; i < numSlots; i++)
				if(spinner.result[i].name ==s)
					if(!slots[i].isHOLD)
						return false;
			return true;
		}
	
		
		
		private function takBettingMoney():int
		{
			var amoney:int = 0;
			var i:int = this.numSlots;
			while(i-->0)
				if( slots[i].isHOLD && spinner.result[i])
					amoney += spinner.result[i].betPrice;
			return amoney;
		}
		
		
		private function ledTouch(e:TouchEvent):void
		{
			if(IS_NOT_ENOUGH_MONEY)
				if(e.getTouch(points, TouchPhase.BEGAN))
					money+=1;
		}
		
		private function spinComplete(e:Event):void
		{
			// time to define what is drawn, not an easy process. many variations of what could be shown
			// considering more than 4 slots. is it better to tell that you've got third to bet or three new?
			//here we assume basics
			var ocor:Array = this.checkOccurences2();
			var max:int;
			var index:Number;
			var i:int = numSlots;
			while(i-->0)
				if(ocor[i] > max)
					max = ocor[i], index = i;
			
			var allreadyPayed:Boolean = areThereOnlyBetPairs(index);
			if(allreadyPayed)
			{
				messager.text = 'these ' + spinner.result[index].name  + ' are already paid!  lol, good luck .. ';
				unlockSlotsForInput();
				return;
			}
			
			switch (max)
			{
				case 1:
					messager.randomMessage(this.msg_zeroMatch);
					break;
				case 2: 
					messager.text  = " OH, two " + spinner.result[index].name + '!  nicee!  wanna bet? only $$'+  String(spinner.result[index].betPrice) + ' each..  think about it .. probability .. money .. beaches .. really ?'
					break;
				case 3:
					messager.text = ' 3 ' +  spinner.result[index].name + '!!! NICE so actually ' +  String(spinner.result[index].prizes[3]) +'  for ya!  .sweet smell of money.. will we ever  dance again?'
					U.assets.getAsset('cash3.mp3').play();
					money +=  spinner.result[index].prizes[3];
					break;
				case 4:
					messager.text = 'JACKPOT! JACKPOT! JACKPOT! '  + "$$$$" + String(spinner.result[index].prizes[4]) + "$$$$ ";
					U.assets.getAsset('cash4.mp3').play();
					money +=  spinner.result[index].prizes[4];
					break;
			}
			
			unlockSlotsForInput();
		}
		
		
		private function startGameActions():void
		{
			IS_GAME_STARTED = true;
			messager.randomMessage(this.msg_startGame);
			money = startMoney;
			this.lockSlotsForInput();
			this.points.ledControler.isOFF = true;
		}
		
		
		private function get money():int { return currentMoney };
		private function set money(v:int):void
		{
			currentMoney = v;
			points.text = String(v);
		}
		
		public function get messager():LedScreen { return _messager }
		public function set messager(value:LedScreen):void { _messager = value }
		
		
		public function get points():LedScreen { return _points }
		public function set points(value:LedScreen):void
		{
			if(points)
				points.removeEventListener(TouchEvent.TOUCH, ledTouch);
			_points = value;
			points.addEventListener(TouchEvent.TOUCH, ledTouch);
		}
		
		
		public function get slots():Vector.<Slot> { return _slots}
		public function set slots(value:Vector.<Slot>):void
		{
			uninstallSlots();
			if(!value)
				return;
			_slots = value;
			this.numSlots = slots.length;
			spinner.slots = value;
			var i:int = numSlots;
			while(i-->0)
			{
				//first add so prevent from beting on values just drawn;
				slots[i].isLockedForInput = true;
				slots[i].addEventListener(Event.TRIGGERED, slotButtonDown);
			}
		}
		
		/**
		 * removes all slots from controll area. 
		 */
		public function uninstallSlots():void
		{
			if(!_slots)
				return;
			while(_slots.length)
				_slots.pop().removeEventListener(Event.TRIGGERED, slotButtonDown);
			_slots = null;
			numSlots = 0;
			spinner.slots = null;
			
		}
		/**
		 * event listener for slot bet buttons (group one)
		 */
		private function slotButtonDown(e:Event):void
		{
			var i:int = numSlots;
			var hcount:int = 0;
			while(i-->0)
				if(slots[i].isHOLD)
					hcount++;
			if(hcount == numSlots)
				slots[Math.floor(Math.random() * numSlots)].isHOLD = false;
	
			U.assets.getAsset('buttonHold.mp3').play(); // so handy and so inapriopriate
			
		}	
		
		/**
		 * sets the spin button to listen. executes all actions 
		 */
		public function get spinButton():Button { return _spinButton }
		public function set spinButton(value:Button):void
		{
			if(_spinButton)
				_spinButton.removeEventListener(Event.TRIGGERED, spinRequsted);
			
			_spinButton = value;
			
			if(_spinButton)
				_spinButton.addEventListener(starling.events.Event.TRIGGERED,spinRequsted);
		}
		
		public function get definition():XML { return def }
		public function set definition(value:XML):void 
		{
			def = value;
			parseDefinition();
		}
		
		private function parseDefinition():void
		{
			this.startMoney = int(def.startMoney);
			this.moneyPerSpin = int(def.moneyPerSpin);
			this.spinner.minSpinTime = Number(def.spinTime.@min);
			this.spinner.maxSpinTime = Number(def.spinTime.@max);
			this.spinner.minRotations= Number(def.spinDistance.@min);
			this.spinner.maxRotations= Number(def.spinDistance.@max);
		}
	}
}