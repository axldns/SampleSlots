package SlotMachine.Parts.Ledscreen
{
	/**
	 * [axldns free coding 2015]
	 */
	import axl.utils.U;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	public class LedScreen extends Sprite
	{
		protected var spots:Vector.<TextField>;
		private var _numChars:int;
		
		private var _fontName:String='font';
		private var _fontSize:int=20;
		private var _charGap:Number=5;
		private var _TEXT:String='test';
		private var _ledControler:LedControler;
		private var _textArray:Array;
		private var messages:XML;
		private var def:XML;
		private var ledCharSpeed:Number;
		
		/**
		 * Just a concept class, full of bugs and potential. 
		 * Intended to create imitation of a led screen with fancy controler to it.
		 *  
		 */
		public function LedScreen()
		{
			super();
			spots = new Vector.<TextField>();
			_textArray = new Array();
			numChars = 0;
		}
		/**
		 * Quick access to display random message from xml deffinition defined group of messages.
		 */
		public function randomMessage(group:String):void
		{
			var l:XMLList=  this.messages[group].msg;
			var i:int = Math.ceil(Math.random() * l.length())-1;
			this.text = String(l[i]);
		}
		/**
		 * specifies how many characters are being displayed at once
		 */
		public function set numChars(value:int):void
		{
			_numChars = value;
			while(spots.length > numChars)
				spots.pop().removeFromParent(true);
			while(spots.length < numChars)
				spots[spots.length] = this.addChild(createSlot());
			U.distribute(this, charGap);
		}
		/**
		 * creates one character place, used by set numChar function
		 */
		protected function createSlot():DisplayObject
		{
			return new TextField(fontSize,fontSize, '0', fontName, fontSize,0xffffff);
		}
		/**
		 * allows to set specific character at specific spot. Bear in mind that this method does not add characer
		 * to constant refference. So if there is ledControler connected, character will get replaced in next cycle;
		 */
		public function setSlotValue(which:int, what:String):void
		{
			if(which < spots.length && which > -1)
				spots[which].text = what;
		}
		
		/**
		 * connects led controler to instance (decorator conncept) by default 
		 * LedControll are being switched ON right after connecting
		 */
		public function set ledControler(value:LedControler):void
		{
			_ledControler = value;
			ledControler.connect(this);
		}
		/**
		 * sets room between all characters. seem to be buggy..
		 */
		public function set charGap(value:Number):void
		{
			_charGap = value;
			U.distribute(this, charGap);
		}
		
		/**
		 * sets the text to screen. If ledController is connected, old text is removed, new starts from alignment pos 00
		 */
		public function set text(v:String):void
		{
			_TEXT = v;
			_textArray = v.split("");
			for(var i:int = 0; i < numChars; i++)
				setSlotValue(i, _textArray[i]);
		}
		
		/**
		 * sets fontsize. realignes everything.  most buggy after all
		 */
		public function set fontSize(value:Number):void
		{
			_fontSize = value;
			applyNewFontSize();
			U.distribute(this, charGap);
		}
		
		/**
		 * applies font on all characters
		 */
		public function set fontName(value:String):void
		{
			_fontName = value;
			applyNewFont();
		}
		/**
		 * overridable, dot to dot font applying
		 */
		protected function applyNewFont():void
		{
			for(var j:int = 0; j < numChars; j++)
				spots[j].fontName = fontName;
			U.distribute(this, charGap);
		}
		/**
		 * overridable, dot to dot new font size pplying
		 */
		protected function applyNewFontSize():void
		{
			var tf:TextField;
			for(var i:int = 0; i < numChars; i++)
			{
				tf = TextField(spots[i]);
				tf.fontSize 	=  fontSize;
				tf.width 		= fontSize+5;
				tf.height 		= fontSize+5;
			}
		}
		
		public function get text():String {	return _TEXT}
		public function get fontSize():Number { return _fontSize }
		public function get fontName():String {	return _fontName }
		public function get textArray():Array { return _textArray }
		public function get ledControler():LedControler	{ return _ledControler	}
		public function get charGap():Number { return _charGap }
		public function get numChars():int	{ return _numChars 	}

		/**
		 * definition specified in further pass call, not the actual current settings
		 */
		public function get definition():XML
		{
			return def;
		}
		
		/**
		 * applies group of settings instantly
		 */
		public function set definition(value:XML):void
		{
			def = value;
			parseDefinition();
		}
		protected function parseDefinition():void
		{
			this.numChars = int(def.numChars);
			this.charGap = Number(def.charGap);
			this.fontName = String(def.fontName);
			this.fontSize = Number(def.fontSize);
			this.messages = XML(def.messages);
			this.ledCharSpeed = Number(def.ledCharSpeed);
			if(isNaN(this.ledCharSpeed))
				this.ledCharSpeed = -1;
			else
				this.ledControler = new LedControler(this.ledCharSpeed)
			this.randomMessage('welcomeText');
		}

	}
}