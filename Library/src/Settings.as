package
{	
	/**
	 * [axldns free coding 2015]
	 */
	import axl.utils.Ldr;
	import axl.utils.Messages;

	public class Settings
	{
		/**
		 * Defines subpath to config file. 
		 * <br> Config defines all other assets subpaths as well as variety of other settings.
		 */
		private static const config_subpath	:String = '/assets/';
		private static const config_name	:String = 'cfg.xml';
		
		/**
		 * address prefix. Resurce load addresses are being formed as <i>prefix</i> + <i>dir</i> + <i> name </i>
		 */
		private static var ADR:String;
		private static var cfg:XML;
		
		/**
		 * holds list of assets path needed to load at app launch
		 */
		private var _assetsList:Array;
		private var _onLoaded:Function;
	
		
		public function Settings(addressPath:String)
		{
			ADR = addressPath;
		}
		/**
		 * loads and parses config. executes <code>onLoaded</code> function on complete if set.
		 * <b>displays message if config not found.
		 */
		public function load():void
		{
			Ldr.loadQueueSynchro([ADR + config_subpath + config_name], configLoaded);
		}
		
		private function configLoaded():void
		{
			if(Ldr.getme(config_name) != null)
			{
				cfg = XML(Ldr.getme(config_name))
				parseConfig();
			}
			else
			{
				Messages.msg("Can't load config file. Tap to try again", load);
				return;
			}
			
			if(onLoaded is Function)
				onLoaded();
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
			while(ll-->0)
			{
				x = list[ll];
				path = String(ADR + x.@dir + x.toString() +'.'+ x.@ext);
				alist[ll] = path;
			}
			return alist;
		}
		
		public function get CONFIG():XML
		{
			return cfg;
		}
		
		public function get assetsList():Array
		{
			return _assetsList;
		}

		public function get onLoaded():Function
		{
			return _onLoaded;
		}

		public function set onLoaded(value:Function):void
		{
			_onLoaded = value;
		}


	}
}