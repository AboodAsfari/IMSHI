package BlockVisuals{
	import flash.display.MovieClip;
	
	public class DummyVisual extends MovieClip{
		public const specialTags = [];
		
		public function DummyVisual(script):void{ //Sets the block coordinates
			this.x = (script.column * TileDatabase.tileSize) + 0.5*(64-this.width); //See above
			this.y = (script.row * TileDatabase.tileSize) + 0.5*(64-this.height); //See above
		}
		
		public function VisualUpdate():void{ //A placeholder function to update the block visuals
			
		}
		
		public function RequestConnection(requester, column, row, connectionRole):Boolean{
			return false;
		}
		
		public function EditorDelete(){
			
		}

	}	
}