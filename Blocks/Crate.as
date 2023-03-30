package Blocks{
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	
	public class Crate extends BlockBase{
		
		public function Crate(inputtedColumn, inputtedRow, inputtedID):void{ //Sets up the crate's visuals 
			super(inputtedColumn, inputtedRow, this, []); //See above
				
			var blockClass:Class = BlockDatabase.GetVisualClass(inputtedID); //See above
				
			TileDatabase.GetTile(column, row).occupiedBlock = this; //See above
				
			visual = new blockClass(this); //See above
			visual.gotoAndStop(1);
			Main.blockContainer.addChild(visual); //See above
		}
		
		override public function Collision(collider):void{ //The code that allows the crate to be pushed
			var xChange:Number = column - collider.column; //See above
			var yChange:Number = row - collider.row; //See above
			if(Crate != getDefinitionByName(getQualifiedClassName(collider))){ //See above
				if(TileDatabase.GetTile(column + xChange, row + yChange) != null && TileDatabase.GetTile(column + xChange, row + yChange).occupiedBlock == null){ //See above
					collider.Move(xChange, yChange, true); //See above
					Move(xChange, yChange, false); //See above
					
	
					Main.blockContainer.addChild(collider.visual); //See above
						
					if(PlayerSpawn == getDefinitionByName(getQualifiedClassName(collider))){ //See above
						if(xChange > 0){ //See above
							collider.visual.scaleX = 1; //See above
							collider.xOffset = 0; //See above
							collider.visual.x = (collider.column * TileDatabase.tileSize) + 0.5*(64-collider.visual.width) + collider.xOffset; //See above
						}else if(xChange < 0){ //See above
							collider.visual.scaleX = -1; //See above
							collider.xOffset = 38; //See above
							collider.visual.x = (collider.column * TileDatabase.tileSize) + 0.5*(64-collider.visual.width) + collider.xOffset; //See above
						}
							
						collider.Trail(xChange, yChange); //See above
						Main.blockContainer.addChild(collider.trail); //See above
					}
				}else if(TileDatabase.GetTile(column + xChange, row + yChange) != null && TileDatabase.GetTile(column + xChange, row + yChange).occupiedBlock != null){ //See above
					TileDatabase.GetTile(column + xChange, row + yChange).occupiedBlock.Collision(this); //See above
				}
			}
		}
		
		override public function Move(xChange, yChange, resetPos):void{ //Moves the block
			for(var a:Number = 0; a < Main.blockList.length; a++){ //See above
				Main.blockList[a].BlockUpdate(this, "BlockExit"); //See above
			}
			
			Main.PlaySound(CrateMove);
			if(resetPos){
				TileDatabase.GetTile(column, row).occupiedBlock = null; //See above
			}
					
			column += xChange; //See above
			row += yChange; //See above
					
			TileDatabase.GetTile(column, row).occupiedBlock = this; //See above
					
			visual.x = (column * TileDatabase.tileSize) + 0.5*(64-visual.width); //See above
			visual.y = (row * TileDatabase.tileSize) + 0.5*(64-visual.height); //See above
			Main.blockContainer.setChildIndex(visual, Main.blockContainer.numChildren-1); //See above
			
			for(var i:Number = 0; i < Main.blockList.length; i++){
				Main.blockList[i].BlockUpdate(this, "BlockEnter");
			}
		}

	}	
}