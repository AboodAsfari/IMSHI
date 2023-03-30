package Blocks{
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class PlayerSpawn extends BlockBase{		
		public var xOffset:Number = 0;
		
		public var trail:MovieClip;
		
		public function PlayerSpawn(inputtedColumn, inputtedRow, inputtedID):void{ //Sets up the player visuals
			super(inputtedColumn, inputtedRow, this, []); //See above
			Main.playerList.push(this); //See above
				
			TileDatabase.GetTile(column, row).occupiedBlock = this; //See above
			trail = new TrailEffect(); //See above
			trail.gotoAndStop(trail.totalFrames); //See above
			Main.blockContainer.addChild(trail); //See above
			
			var blockClass:Class = BlockDatabase.GetVisualClass(inputtedID); //See above
			visual = new blockClass(this); //See above
			Main.blockContainer.addChild(visual); //See above
		}
		
		public function MovePlayer(xChange, yChange):void{ //Attempts to move the player
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
					LevelHandler.moves++; //See above
					Trail(xChange, yChange);
				}else{ //See above
					TileDatabase.GetTile(column + xChange, row + yChange).occupiedBlock.Collision(this); //See above
				}
			}
		}
		
		override public function Move(xChange, yChange, resetPos):void{ //Changes the player coordinates
			for(var a:Number = 0; a < Main.blockList.length; a++){
				Main.blockList[a].BlockUpdate(this, "BlockExit");
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
			
			var globalCoords:Point = visual.parent.localToGlobal(new Point(visual.x, visual.y)); //See above
			if(globalCoords.x < 64 || globalCoords.x > Main.stageRef.stageWidth - 64 || globalCoords.y < 64 || globalCoords.y > Main.stageRef.stageHeight - 64){ //See above
				Main.mainGame.x -= xChange * 64; //See above
				Main.mainGame.y -= yChange * 64; //See above
			}
			
			for(var i:Number = 0; i < Main.blockList.length; i++){
				Main.blockList[i].BlockUpdate(this, "BlockEnter");
			}
		}
		
		override public function DeleteBlock():void{ //See above
			super.DeleteBlock(); //See above
			Main.playerList.removeAt(Main.playerList.indexOf(this)); //See above
		}
		
		public function Trail(xChange, yChange){ //Animates the player trail
			if(xChange > 0){ //See above
				trail.x = (column * TileDatabase.tileSize) + 0.5*(64-visual.width) - 4; //See above
				trail.y = (row * TileDatabase.tileSize) + 0.5*(64-visual.height) + 20; //See above
				trail.rotation = 0; //See above
				trail.scaleX = 1; //See above
			}else if(xChange < 0){ //See above
				trail.x = (column * TileDatabase.tileSize) + 0.5*(64-visual.width) + 44; //See above
				trail.y = (row * TileDatabase.tileSize) + 0.5*(64-visual.height) + 20; //See above
				trail.rotation = 0; //See above
				trail.scaleX = -1; //See above
			}else if(yChange > 0){ //See above
				trail.x = (column * TileDatabase.tileSize) + 0.5*(64-visual.width) + 20; //See above
				trail.y = (row * TileDatabase.tileSize) + 0.5*(64-visual.height) - 4; //See above
				trail.rotation = 90; //See above
				trail.scaleX = 1; //See above
			}else if(yChange < 0){ //See above
				trail.x = (column * TileDatabase.tileSize) + 0.5*(64-visual.width) + 20; //See above
				trail.y = (row * TileDatabase.tileSize) + 0.5*(64-visual.height) + 48; //See above
				trail.rotation = -90; //See above
				trail.scaleX = 1; //See above
			}
			trail.gotoAndPlay(1); //See above
		}

	}	
}