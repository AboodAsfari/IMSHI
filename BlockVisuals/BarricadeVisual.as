package BlockVisuals{
	import flash.display.MovieClip;
	
	public class BarricadeVisual extends MovieClip{
		public const specialTags = ["Barricade"];
		private var script:Object;
		
		public function BarricadeVisual(inputtedScript):void{ //Sets the block coordinates
			script = inputtedScript;
			this.x = (script.column * TileDatabase.tileSize) + 0.5*(64-this.width); //See above
			this.y = (script.row * TileDatabase.tileSize) + 0.5*(64-this.height); //See above
		}
		
		public function VisualUpdate():void{ //A placeholder function to update the block visuals
			this.rightBorder.visible = true;
			this.leftBorder.visible = true;
			if(!Main.stageRef.contains(Main.mapEditorUI)){
				if(TileDatabase.GetTile(script.column + 1, script.row) != null && TileDatabase.GetTile(script.column + 1, script.row).occupiedBlock != null && TileDatabase.GetTile(script.column + 1, script.row).occupiedBlock.specialTags.indexOf("Barricade") != -1){
					this.rightBorder.visible = false;
				}if(TileDatabase.GetTile(script.column - 1, script.row) != null && TileDatabase.GetTile(script.column - 1, script.row).occupiedBlock != null && TileDatabase.GetTile(script.column - 1, script.row).occupiedBlock.specialTags.indexOf("Barricade") != -1){
					this.leftBorder.visible = false;
				}
			}else{
				if(BlockDatabase.GetBlock(script.column + 1, script.row) != null && BlockDatabase.GetBlock(script.column + 1, script.row).specialTags.indexOf("Barricade") != -1){
					this.rightBorder.visible = false;
				}if(BlockDatabase.GetBlock(script.column - 1, script.row) != null && BlockDatabase.GetBlock(script.column - 1, script.row).specialTags.indexOf("Barricade") != -1){
					this.leftBorder.visible = false;
				}
			}
		}
		
		public function RequestConnection(requester, column, row, connectionRole):Boolean{
			return false;
		}
		
		public function EditorDelete(){
			
		}

	}	
}