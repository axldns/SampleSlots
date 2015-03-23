package SlotMachine
{
	/**
	 * [axldns free coding 2015]
	 */
	
	import SlotMachine.Parts.Control.Controler;
	import SlotMachine.Parts.Ledscreen.LedScreen;
	import SlotMachine.Parts.Slot.SlotFactory;
	import SlotMachine.Parts.Window.Window;
	
	import axl.utils.U;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.textures.TextureAtlas;
	
	public class Machine extends Sprite 
	{
		private var slotWindow:Window;
		private var slotFactory:SlotFactory;
		
		private var ledMessager:LedScreen;
		private var ledPoints:LedScreen;
		
		private var controler:Controler;
		
		private var material:TextureAtlas;
		private var def:XML;
		private var spinButton:Button;
		
		/**
		 * Main manufactural class. Assembles all machine parts together makes connections between them, distributes assets etc.
		 * There is a little issue in here, there is no concept of sound distribution, unlike with textures, and xml settings, 
		 * sounds are being played randomly in two controll classes, using utility classes. 
		 */
		
		public function Machine(machineMaterial:TextureAtlas,machineDefinition:XML)
		{
			super();
			
			material = machineMaterial;
			def = machineDefinition;
			build();
		}
		
		private function build():void
		{
			slotWindow = new Window(
				material.getTexture('window_glass.png'),
				material.getTexture('window_frame.png')
			);
			slotWindow.definition = XML(def.window);
			
			slotFactory = new SlotFactory();
			slotFactory.iconTextures 			= material.getTextures('slot_');
			slotFactory.iconNames 				= material.getNames('slot_');
			slotFactory.railTexture 			= material.getTexture('rail.png');
			slotFactory.slotButtonUpTexture 	= material.getTexture('button_slotUp.png');
			slotFactory.slotButtonDownTexture 	= material.getTexture('button_slotDown.png');
			slotFactory.definition = XML(def.slots);
			
			slotWindow.installSlots(slotFactory.makeSlots());
			slotFactory.shutDown();
			slotFactory = null;
			
		
			ledMessager = new LedScreen();
			ledMessager.definition= XML(def.ledMessageScreen);
			ledPoints = new LedScreen();
			ledPoints.definition = XML(def.ledPointsScreen);
			
			spinButton = new Button(
				material.getTexture('button_upstate.png'),"",
				material.getTexture('button_downstate.png')
			);
			
			controler = new Controler();
			controler.points = ledPoints;
			controler.messager = ledMessager;
			controler.slots =slotWindow.slots;
			controler.spinButton = spinButton;
			controler.definition = XML(def.controler);
			
			U.align(ledMessager, U.REC, 'center', 'top');
			U.align(slotWindow, U.REC, 'center', 'center');
			U.align(ledPoints, U.REC, 'left', 'bottom');
			
			slotWindow.y = ledMessager.bounds.bottom;
			
			this.addChild(slotWindow);
			this.addChild(ledMessager);
			this.addChild(ledPoints);
			this.addChild(spinButton);
		}
		
	}
}