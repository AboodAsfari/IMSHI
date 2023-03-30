package{
	import flash.display.MovieClip;
	
	public class Tile{
		public var tile:MovieClip; //Stores the tile visual
		public var tileClass:Class; //Stores the tile class
		
		public var row:Number; //Stores the tile coordinates
		public var column:Number; //See above
		
		public var occupiedBlock:Object; //Stores the occupied block
		public var subOccupiedBlock:Object; //Stores the occupied block
		
		public function Tile(inputtedColumn, inputtedRow, inputtedTileClass):void{ //Sets up the tile visuals
			tileClass = inputtedTileClass;  //See above
			tile = new tileClass();  //See above
			
			row = inputtedRow; //See above
			column = inputtedColumn; //See above
			
			occupiedBlock = null; //See above
			subOccupiedBlock = null; //See above
			
			tile.x = column * TileDatabase.tileSize; //See above
			tile.y = row * TileDatabase.tileSize;  //See above
			tile.mainTile.gotoAndStop(1); //See above
			
			if(TileDatabase.tileDictX[column] != null && TileDatabase.tileDictX[column].length > 0){ //See above
				TileDatabase.tileDictX[column].push(this); //See above
			}else{
				TileDatabase.tileDictX[column] = [this]; //See above
			}
			
			if(TileDatabase.tileDictY[row] != null && TileDatabase.tileDictY[row].length > 0){ //See above
				TileDatabase.tileDictY[row].push(this); //See above
			}else{
				TileDatabase.tileDictY[row] = [this]; //See above
			}
			
			tile.tileBorder.topBorder.visible = false; //See above
			tile.tileBorder.bottomBorder.visible = false; //See above
			tile.tileBorder.leftBorder.visible = false; //See above
			tile.tileBorder.rightBorder.visible = false; //See above
			tile.tileBorder.bottomLeftBorder.visible = false; //See above
			tile.tileBorder.bottomRightBorder.visible = false; //See above
			tile.tileBorder.bottomBorder.gotoAndStop(TileDatabase.GetID(tileClass) + 1); //See above
			UpdateBorders(); //See above
			
			Main.mainGame.addChild(tile); //See above
		}
		
		public function UpdateBorders():void{ //Updates the tile borders
			if(TileDatabase.GetTile(column + 1, row) == null){ //See above
				tile.tileBorder.rightBorder.visible = true; //See above
			}else{ //See above
				tile.tileBorder.rightBorder.visible = false; //See above
			}
			
			if(TileDatabase.GetTile(column - 1, row) == null){ //See above
				tile.tileBorder.leftBorder.visible = true; //See above
			}else{ //See above
				tile.tileBorder.leftBorder.visible = false; //See above
			}
			
			if(TileDatabase.GetTile(column, row - 1) == null){ //See above
				tile.tileBorder.topBorder.visible = true; //See above
			}else{ //See above
				tile.tileBorder.topBorder.visible = false; //See above
			}
			
			if(TileDatabase.GetTile(column, row + 1) == null){ //See above
				tile.tileBorder.bottomBorder.visible = true; //See above
				if(TileDatabase.GetTile(column + 1, row) == null){ //See above
					tile.tileBorder.bottomRightBorder.visible = true; //See above
				}else{ //See above
					tile.tileBorder.bottomRightBorder.visible = false; //See above
				} //See above
				if(TileDatabase.GetTile(column - 1, row) == null){ //See above
					tile.tileBorder.bottomLeftBorder.visible = true; //See above
				}else{ //See above
					tile.tileBorder.bottomLeftBorder.visible = false; //See above
				}
			}else{ //See above
				tile.tileBorder.bottomBorder.visible = false; //See above
				tile.tileBorder.bottomRightBorder.visible = false; //See above
				tile.tileBorder.bottomLeftBorder.visible = false; //See above
			} //See above
			
		}
		
		public function DeleteTile():void{ //Deletes the tile			
			Main.tileList.removeAt(Main.tileList.indexOf(this)); //See above
			TileDatabase.tileDictX[column].removeAt(TileDatabase.tileDictX[column].indexOf(this)); //See above
			TileDatabase.tileDictY[row].removeAt(TileDatabase.tileDictY[row].indexOf(this)); //See above
			Main.mainGame.removeChild(tile); //See above
		}
		
	}
}