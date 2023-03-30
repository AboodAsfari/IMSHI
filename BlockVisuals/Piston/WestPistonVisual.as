package BlockVisuals.Piston{
	import flash.display.MovieClip;
	
	public class WestPistonVisual extends MovieClip{
		public var script:Object;
		public const specialTags = ["Receiver"];
		
		public function WestPistonVisual(inputtedScript):void{ //Sets the block coordinates
			script = inputtedScript;
			this.x = (script.column * TileDatabase.tileSize) + 0.5*(64-this.width); //See above
			this.y = (script.row * TileDatabase.tileSize) + 0.5*(64-this.height); //See above
			this.gotoAndStop(1);
			this.powerIndicator.gotoAndStop(1);
		}
		
		public function VisualUpdate():void{ //A placeholder function to update the block visuals
			
		}
		
		public function RequestConnection(requester, column, row, connectionRole):Boolean{
			if(connectionRole.indexOf("Receiver") != -1 && column != script.column - 1 && ((Math.abs(script.column - column) == 1 && Math.abs(script.row - row) == 0) || (Math.abs(script.column - column) == 0 && Math.abs(script.row - row) == 1))){
				return true;
			}else{
				return false;
			}
		}
		
		public function EditorDelete(){
			
		}

	}	
}