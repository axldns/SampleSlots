package axl.utils
{	
	/**
	 * [axldns free coding 2015]
	 */
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import axl.utils.Ldr;
	import axl.utils.Messages;
	/**
	 * Class loads and parses config file, strips assets array out of it
	 */
	public class Config extends EventDispatcher
	{
		
		private static var cfg:XML;
		
		/**
		 * holds list of assets path needed to load at app launch
		 */
		private var _assetsList:Array;
		private var configAddress:String;
		private var configName:String;
		
		
		public function Config(configSubppath:String) 
		{ 
			
			configAddress = U.assets.ADR + configSubppath;
			configName = configSubppath.replace(/(.*\/)(\w+[.]\w*\z)/i, "$2");
		}
		
		/**
		 * returns configuration xml loaded at app launch
		 */
		public function get CONFIG():XML { return cfg}
		public function get assetsList():Array { return _assetsList }
		
		
		/**
		 * loads and parses config. executes <code>onLoaded</code> function on complete if set.
		 * <b>displays message if config not found.
		 */
		public function load():void
		{
			U.bin.trrace('LOADING SETTINGS', configAddress);
			Ldr.loadQueueSynchro([configAddress], configLoaded);
		}
		
		private function configLoaded():void
		{
			U.bin.trrace('config loaded?');
			if(Ldr.getme(configName) != null)
			{
				U.bin.trrace('config accepted');
				cfg = XML(Ldr.getme(configName))
				parseConfig();
			}
			else
			{
				Messages.msg("Can't load config file. Tap to try again", load);
				return;
			}
			
			this.dispatchEvent(new Event(flash.events.Event.COMPLETE));
		}
		
		private function parseConfig():void
		{
			this._assetsList = configAssetList;
		}
		
		private function get configAssetList():Array
		{
			var alist:Array = [];
			var list:XMLList = cfg.files.file;
			var ll:int = list.length();
			var path:String;
			var x:XML;
			var adr:String = U.assets.ADR;
			while(ll-->0)
			{
				x = list[ll];
				path = String(adr + x.@dir + x.toString() +'.'+ x.@ext);
				alist[ll] = path;
			}
			return alist;
		}
		
		
	}
}