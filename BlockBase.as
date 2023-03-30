package{
	import flash.display.MovieClip;
	
	public class BlockBase{
		public var block:Object; //Stores the block object
		public var visual:MovieClip; //Stors the block visual
		
		public var column:Number; //Stores the column, row, as well as the initial column and row
		public var row:Number; //See above
		public var originalRow:Number; //See above
		public var originalColumn:Number; //See above
		
		public var specialTags:Array;
		
		public function BlockBase(inputtedColumn, inputtedRow, inputtedObject, inputtedTags):void{ //Sets the variables to the input from the subtype
			column = originalColumn = inputtedColumn; //See above
			row = originalRow = inputtedRow; //See above
			block = inputtedObject; //See above
			specialTags = inputtedTags; //See above
		}
		
		public function Collision(collider):void{ //A default function for when a player collides with an object (made to be overriden)
			
		}
		
		public function BlockUpdate(updater, updateType):void{ //A default function for when a block needs to update (made to be overriden)

		}
		
		public function Move(xChange, yChange, resetPos):void{ //Moves the block
			for(var a:Number = 0; a < Main.blockList.length; a++){
				Main.blockList[a].BlockUpdate(this, "BlockExit");
			}
			
			if(resetPos){
				TileDatabase.GetTile(column, row).occupiedBlock = null; //See above
			}
					
			column += xChange; //See above
			row += yChange; //See above
					
			TileDatabase.GetTile(column, row).occupiedBlock = this; //See above
					
			visual.x = (column * TileDatabase.tileSize) + 0.5*(64-visual.width); //See above
			visual.y = (row * TileDatabase.tileSize) + 0.5*(64-visual.height); //See above
			Main.blockContainer.setChildIndex(visual, Main.blockContainer.numChildren-1); //See above
			
			for(var b:Number = 0; b < Main.blockList.length; b++){
				Main.blockList[b].BlockUpdate(this, "BlockEnter");
			}
		}
		
		public function DeleteBlock():void{ //Deletes a block
			visual.EditorDelete();
			Main.blockList.removeAt(Main.blockList.indexOf(block)); //See above
			if(Main.blockContainer.contains(visual)){
				Main.blockContainer.removeChild(visual); //See above
			}else if(Main.subBlockContainer.contains(visual)){
				Main.subBlockContainer.removeChild(visual);
			}
		}

	}	
}