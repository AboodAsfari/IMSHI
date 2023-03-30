package{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class GridTile extends MovieClip{
		private var column:Number; //Stores the column and row of the grid tile
		private var row:Number; //See above
		
		public function GridTile(inputtedColumn, inputtedRow):void{ //Updates the x and y of the tile
			column = inputtedColumn + 1; //See above
			row = inputtedRow + 1; //See above
			
			this.x = inputtedColumn * TileDatabase.tileSize; //See above
			this.y = (inputtedRow * TileDatabase.tileSize); //See above
			MapEditor.mapGrid.addChild(this); //See above
			
			this.addEventListener(Event.ENTER_FRAME, HoverChecker); //See above
		}
		
		private function HoverChecker(e:Event):void{ //Used to place down tiles
			if(this.mainContent.hitTestPoint(Main.stageRef.mouseX, Main.stageRef.mouseY, false) && TileDatabase.GetTile(column + MapEditor.offsetX, row + MapEditor.offsetY) == null && !MapEditor.navMode && (!Main.mapEditorUI.hitTestPoint(Main.stageRef.mouseX, Main.stageRef.mouseY, true) || Main.mapEditorUI.namePanel.hitTestPoint(Main.stageRef.mouseX, Main.stageRef.mouseY, true)) && !MapEditor.buildMode && !MapEditor.paused && (MapEditor.hoveredTile == this || MapEditor.hoveredTile == null)){ //See above
				if(MapEditor.hoveredTile == null){ //See above
					MapEditor.hoveredTile = this; //See above
				} //See above
				this.gotoAndStop(2); //See above
				if(MapEditor.leftDown && !MapEditor.rightDown && !MapEditor.middleDown && !MapEditor.ctrlDown){ //See above
					MapEditor.NewTile(column, row, true); //See above
				}
			}else{
				this.gotoAndStop(1); //See above
				if(MapEditor.hoveredTile == this){ //See above
					MapEditor.hoveredTile = null; //See above
				}
			}
		}

	}	
}