package Blocks{
	
	public class Dummy extends BlockBase{		
		private var xOffset:Number = 0; //The offset for the dummy when turning
		
		public function Dummy(inputtedColumn, inputtedRow, inputtedID):void{ //Sets up the dummy visuals
			super(inputtedColumn, inputtedRow, this, []); //See above
			Main.playerList.push(this); //See above
				
			TileDatabase.GetTile(column, row).occupiedBlock = this; //See above
			
			var blockClass:Class = BlockDatabase.GetVisualClass(inputtedID); //See above
			visual = new blockClass(this); //See above
			Main.blockContainer.addChild(visual); //See above
		}
		
		public function MovePlayer(xChange, yChange):void{ //Attempts to move the dummy
			var collider:Object = TileDatabase.GetTile(column + xChange, row + yChange); //See above
			
			if(xChange > 0){ //See above
				visual.scaleX = 1; //See above
				xOffset = 0; //See above
				visual.x = (column * TileDatabase.tileSize) + 0.5*(64-visual.width) + xOffset; //See above
			}else if(xChange < 0){ //See above
				visual.scaleX = -1; //See above
				xOffset = 38; //See above
				visual.x = (column * TileDatabase.tileSize) + 0.5*(64-visual.width) + xOffset; //See above
			}
			 
			if(collider != null){ //See above
				if(collider.occupiedBlock == null){ //See above
					Move(xChange, yChange, true); //See above
				}else{ //See above
					TileDatabase.GetTile(column + xChange, row + yChange).occupiedBlock.Collision(this); //See above
				}
			}
		}
		
		override public function Move(xChange, yChange, resetPos):void{ //Changes the coordinates of the dummy
			for(var a:Number = 0; a < Main.blockList.length; a++){ //See above
				Main.blockList[a].BlockUpdate(this, "BlockExit"); //See above
			}
			
			if(resetPos){
				TileDatabase.GetTile(column, row).occupiedBlock = null; //See above
			}
					
			column += xChange; //See above
			row += yChange; //See above
					
			TileDatabase.GetTile(column, row).occupiedBlock = this; //See above
					
			visual.x = (column * TileDatabase.tileSize) + 0.5*(64-visual.width) + xOffset; //See above
			visual.y = (row * TileDatabase.tileSize) + 0.5*(64-visual.height); //See above
			Main.blockContainer.setChildIndex(visual, Main.blockContainer.numChildren-1); //See above
			
			for(var i:Number = 0; i < Main.blockList.length; i++){
				Main.blockList[i].BlockUpdate(this, "BlockEnter");
			}
		}
		
		override public function DeleteBlock():void{ //Deletes the dummy
			super.DeleteBlock(); //See above
			Main.playerList.removeAt(Main.playerList.indexOf(this)) //See above
		}

	}	
}