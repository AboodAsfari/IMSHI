package{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class EditorTile{
		public var tile:MovieClip; //Stores the tile movieclip
		public var tileClass:Class; //Stores the class of the tile
		
		public var row:Number; //Stores the row and column of the tile
		public var column:Number; //See above
		
		private var blockPreview:MovieClip; //A variable to store the block preview when building
		
		public function EditorTile(inputtedColumn, inputtedRow, inputtedTileClass):void{ //Initializes the location and borders of the tile
			tileClass = inputtedTileClass;  //See above
			tile = new tileClass();  //See above
			
			row = inputtedRow; //See above
			column = inputtedColumn; //See above
			
			tile.x = column * TileDatabase.tileSize; //See above
			tile.y = row * TileDatabase.tileSize; //See above

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
			
			Main.mainGame.addChild(tile); //See above
			
			tile.addEventListener(Event.ENTER_FRAME, HoverChecker); //See above
			AnimateIn(); //See above
		}
		
		private function AnimateIn():void{ //See above
			tile.scaleX = tile.scaleY = 1.1; //See above
			tile.addEventListener(Event.ENTER_FRAME, Animate); //See above
			function Animate(e:Event){ //See above
				tile.scaleX = tile.scaleY -= 0.05; //See above
				if(tile.scaleX <= 1){ //See above
					tile.removeEventListener(Event.ENTER_FRAME, Animate); //See above
				}
			}
		}
		
		public function UpdateBorders():void{ //Updates the borders of the tile
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
			}
		}
		
		
		private function HoverChecker(e:Event):void{//Checks if the button is being hovered over, used to place and delete blocks
			if(tile.mainTile.hitTestPoint(Main.stageRef.mouseX, Main.stageRef.mouseY, false) && !MapEditor.navMode && (!Main.mapEditorUI.hitTestPoint(Main.stageRef.mouseX, Main.stageRef.mouseY, true) || Main.mapEditorUI.namePanel.hitTestPoint(Main.stageRef.mouseX, Main.stageRef.mouseY, true)) && !MapEditor.paused && (MapEditor.hoveredTile == this || MapEditor.hoveredTile == null)){ //See above
				if(MapEditor.hoveredTile == null){ //See above
					MapEditor.hoveredTile = this; //See above
				}
				if(!MapEditor.buildMode){ //See above
					tile.mainTile.gotoAndStop(2); //See above
					if(!MapEditor.middleDown && MapEditor.leftDown && MapEditor.selectedBlockID != TileDatabase.GetID(tileClass)){ //See above
						DeleteTile(false, true); //See above
						MapEditor.NewTile(column - MapEditor.offsetX, row - MapEditor.offsetY, true); //See above	
					}
				}else{
					if(blockPreview == null && ((BlockDatabase.GetBlock(column, row) == null && !BlockDatabase.blockDatabase[MapEditor.selectedBlockID][5]) || (BlockDatabase.GetSubBlock(column, row) == null && BlockDatabase.blockDatabase[MapEditor.selectedBlockID][5]))){ //See above
						var blockClass:Class = BlockDatabase.GetVisualClass(MapEditor.selectedBlockID); //See above

						blockPreview = new blockClass(this); //See above
						//blockPreview.x -= column * TileDatabase.tileSize; //See above
						//blockPreview.y -= row * TileDatabase.tileSize; //See above
						blockPreview.alpha = 0.5; //See above
						Main.blockContainer.addChild(blockPreview); //See above
					}
					if(MapEditor.leftDown && !MapEditor.rightDown && !MapEditor.middleDown){ //See above
						if(BlockDatabase.GetBlock(column, row) == null || BlockDatabase.GetSubBlock(column, row) == null){
							if(BlockDatabase.blockDatabase[MapEditor.selectedBlockID][5] && BlockDatabase.GetSubBlock(column, row) == null){
								MapEditor.NewBlock(column, row, true, true); //See above
							}else if(BlockDatabase.GetBlock(column, row) == null && !BlockDatabase.blockDatabase[MapEditor.selectedBlockID][5]){
								MapEditor.NewBlock(column, row, true, false); //See above
							}
							if(blockPreview != null){
								Main.blockContainer.removeChild(blockPreview); //See above
							}
							blockPreview = null; //See above
						}
					}
				}
				
				if(MapEditor.rightDown && BlockDatabase.GetBlock(column, row) == null && BlockDatabase.GetSubBlock(column, row) == null && (MapEditor.deleteType == "None" || MapEditor.deleteType == "Tile")){ //See above
					DeleteTile(false, true); //See above
					MapEditor.deleteType = "Tile";
				}else if(!MapEditor.leftDown && MapEditor.rightDown && !MapEditor.middleDown && (BlockDatabase.GetBlock(column, row) != null || BlockDatabase.GetSubBlock(column, row) != null) && (MapEditor.deleteType == "None" || MapEditor.deleteType == "Block" || MapEditor.deleteType == "SubBlock")){ //See above
					if(BlockDatabase.GetBlock(column, row) != null && (MapEditor.deleteType == "Block" || MapEditor.deleteType == "None")){
						DeleteBlock(true);
						MapEditor.deleteType = "Block";
					}
					if(BlockDatabase.GetSubBlock(column, row) != null && (MapEditor.deleteType == "SubBlock" || MapEditor.deleteType == "None")){
						DeleteSubBlock(true); //See above
						MapEditor.deleteType = "SubBlock";
					}
				}
			}else{
				tile.mainTile.gotoAndStop(1); //See above
				if(blockPreview != null){ //See above
					Main.blockContainer..removeChild(blockPreview); //See above
					blockPreview = null; //See above
				} //See above
				if(MapEditor.hoveredTile == this){ //See above
					MapEditor.hoveredTile = null; //See above
				}
			}
		}
		
		public function DeleteTile(deleteBlock, removeHistory):void{ //Deletes the tile
			if(!MapEditor.paused){ //See above
				Main.PlaySound(Block); //See above
			}
			
			if(BlockDatabase.GetBlock(column, row) != null && deleteBlock){ //See above
				DeleteBlock(false); //See above
			}
			
			if(BlockDatabase.GetSubBlock(column, row) != null && deleteBlock){ //See above
				DeleteSubBlock(false); //See above
			}
			
			if(MapEditor.hoveredTile == this){ //See above
				MapEditor.hoveredTile = null; //See above
			}
			for(var a:Number = 0; a < MapEditor.tileData.length; a++){ //See above
				if(MapEditor.tileData[a][0] == TileDatabase.GetID(tileClass) && MapEditor.tileData[a][1] == column && MapEditor.tileData[a][2] == row){ //See above
					MapEditor.tileData.removeAt(a); //See above
					break; //See above
				}
			}
			
			if(removeHistory){ //See above
				for(var b:Number = 0; b < MapEditor.actionHistory.length; b++){ //See above
					for(var c:Number = 0; c < MapEditor.actionHistory[b].length; c++){ //See above
						if(MapEditor.actionHistory[b][c] == DeleteTile){ //See above
							MapEditor.actionHistory[b].removeAt(c); //See above
							break; //See above
						}
					}
				}
			}
			
			Main.tileList.removeAt(Main.tileList.indexOf(this)); //See above
			TileDatabase.tileDictX[column].removeAt(TileDatabase.tileDictX[column].indexOf(this)); //See above
			TileDatabase.tileDictY[row].removeAt(TileDatabase.tileDictY[row].indexOf(this)); //See above
			Main.mainGame.removeChild(tile); //See above
			if(blockPreview != null && Main.blockContainer.contains(blockPreview)){
				Main.blockContainer.removeChild(blockPreview);
			}
			
			TileDatabase.UpdateBorders(); //See above
			
			tile.removeEventListener(Event.ENTER_FRAME, HoverChecker); //See above
		}
		
		public function DeleteBlock(removeHistory):void{ //Deletes the block on this tile			
			var block:MovieClip = BlockDatabase.GetBlock(column, row); //See above
			BlockDatabase.blockDictX[column].removeAt(BlockDatabase.blockDictX[column].indexOf(block)); //See above	
			BlockDatabase.blockDictY[row].removeAt(BlockDatabase.blockDictY[row].indexOf(block)); //See above
			
			var blockID = BlockDatabase.GetID(getDefinitionByName(getQualifiedClassName(block))) //See above
			
			for(var a:Number = 0; a < MapEditor.blockData.length; a++){ //See above
				if(MapEditor.blockData[a][0] == blockID && MapEditor.blockData[a][1] == column && MapEditor.blockData[a][2] == row){ //See above 
					MapEditor.blockData.removeAt(a); //See above
					break; //See above
				}
			}
			
			if(removeHistory){ //See above
				for(var b:Number = 0; b < MapEditor.actionHistory.length; b++){ //See above
					for(var c:Number = 0; c < MapEditor.actionHistory[b].length; c++){ //See above
						if(MapEditor.actionHistory[b][c] == DeleteBlock){ //See above
							MapEditor.actionHistory[b].removeAt(c); //See above
							break; //See above
						}
					}
				}
			}
			block.EditorDelete();
			Main.blockContainer.removeChild(block); //See above
			Main.blockList.removeAt(Main.blockList.indexOf(block)); //See above
			
			if(!MapEditor.paused){ //See above
				Main.PlaySound(Block); //See above
				for(var d:Number = 0; d < Main.blockList.length; d++){
					Main.blockList[d].VisualUpdate();
				}
			}
		}
		
		public function DeleteSubBlock(removeHistory){ //Deletes the sub-block on this tile
			var block:MovieClip = BlockDatabase.GetSubBlock(column, row); //See above
			BlockDatabase.subBlockDictX[column].removeAt(BlockDatabase.subBlockDictX[column].indexOf(block)); //See above	
			BlockDatabase.subBlockDictY[row].removeAt(BlockDatabase.subBlockDictY[row].indexOf(block)); //See above
			
			var blockID = BlockDatabase.GetID(getDefinitionByName(getQualifiedClassName(block))) //See above

			for(var a:Number = 0; a < MapEditor.blockData.length; a++){ //See above
				if(MapEditor.blockData[a][0] == blockID && MapEditor.blockData[a][1] == column && MapEditor.blockData[a][2] == row){ //See above 
					MapEditor.blockData.removeAt(a); //See above
					break; //See above
				}
			}
			
			if(removeHistory){ //See above
				for(var b:Number = 0; b < MapEditor.actionHistory.length; b++){ //See above
					for(var c:Number = 0; c < MapEditor.actionHistory[b].length; c++){ //See above
						if(MapEditor.actionHistory[b][c] == DeleteSubBlock){ //See above
							MapEditor.actionHistory[b].removeAt(c); //See above
							break; //See above
						}
					}
				}
			}
			block.EditorDelete();
			Main.subBlockContainer.removeChild(block); //See above
			Main.blockList.removeAt(Main.blockList.indexOf(block)); //See above
			
			if(!MapEditor.paused){ //See above
				Main.PlaySound(Block); //See above
				for(var d:Number = 0; d < Main.blockList.length; d++){
					Main.blockList[d].VisualUpdate();
				}
			}
		}
		
		public function ResetPreview():void{
			if(blockPreview != null){ //See above
				Main.blockContainer.removeChild(blockPreview); //See above
				blockPreview = null; //See above
			}
		}
		
	}
}