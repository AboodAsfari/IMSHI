package BlockVisuals.Lamp{
	import flash.display.MovieClip;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	
	public class PinkLampVisual extends MovieClip{
		public var script:Object;
		public const specialTags = ["Receiver", "Lamp"];
		
		public function PinkLampVisual(inputtedScript):void{ //Sets the block coordinates
			script = inputtedScript; //See above
			this.x = (script.column * TileDatabase.tileSize); //See above
			this.y = (script.row * TileDatabase.tileSize); //See above
			this.bulb.gotoAndStop(2);
			this.bulb.leftExtension.gotoAndStop(2);
			this.bulb.rightExtension.gotoAndStop(2);
			this.bulb.topExtension.gotoAndStop(2);
			this.bulb.bottomExtension.gotoAndStop(2);
			this.bulb.northEast.gotoAndStop(2);
			this.bulb.northWest.gotoAndStop(2);
			this.bulb.southEast.gotoAndStop(2);
			this.bulb.southWest.gotoAndStop(2);
			
			this.topBorder.visible = true;
			this.bottomBorder.visible = true;
			this.leftBorder.visible = true;
			this.rightBorder.visible = true;
			this.bulb.bottomExtension.visible = false;
			this.bulb.topExtension.visible = false;
			this.bulb.rightExtension.visible = false;
			this.bulb.leftExtension.visible = false;
			this.bulb.northEast.visible = false;
			this.bulb.northWest.visible = false;
			this.bulb.southEast.visible = false;
			this.bulb.southWest.visible = false;
			this.southEastCorner.visible = false;
			this.southWestCorner.visible = false;
			this.northEastCorner.visible = false;
			this.northWestCorner.visible = false;
			this.westNorthCorner.visible = false;
			this.westSouthCorner.visible = false;
			this.eastNorthCorner.visible = false;
			this.eastSouthCorner.visible = false;
			this.northWestSmoother.visible = false;
			this.southWestSmoother.visible = false;
			this.northEastSmoother.visible = false;
			this.southEastSmoother.visible = false;
			
			this.connector.wireRight.visible = false;
			this.connector.wireLeft.visible = false;
			this.connector.wireTop.visible = false;
			this.connector.wireBottom.visible = false;
			this.connector.rightBlocker.visible = false;
			this.connector.leftBlocker.visible = false;
			this.connector.topBlocker.visible = false;
			this.powerIndicator.gotoAndStop(1);
			
			this.connector.wireRight.gotoAndStop(1);
			this.connector.wireLeft.gotoAndStop(1);
			this.connector.wireTop.gotoAndStop(1);
			this.connector.wireBottom.gotoAndStop(1);
		}
		
		public function VisualUpdate():void{ //Updates the wire visuals
			this.connector.wireRight.visible = false;
			this.connector.wireLeft.visible = false;
			this.connector.wireTop.visible = false;
			this.connector.wireBottom.visible = false;
			
			
			this.topBorder.visible = true;
			this.bottomBorder.visible = true;
			this.rightBorder.visible = true;
			this.leftBorder.visible = true;
			this.bulb.northEast.visible = false;
			this.bulb.northWest.visible = false;
			this.bulb.southEast.visible = false;
			this.bulb.southWest.visible = false;
			this.bulb.bottomExtension.visible = false;
			this.bulb.topExtension.visible = false;
			this.bulb.rightExtension.visible = false;
			this.bulb.leftExtension.visible = false;
			this.southEastCorner.visible = false;
			this.southWestCorner.visible = false;
			this.northEastCorner.visible = false;
			this.northWestCorner.visible = false;
			this.westNorthCorner.visible = false;
			this.westSouthCorner.visible = false;
			this.eastNorthCorner.visible = false;
			this.eastSouthCorner.visible = false;
			this.northWestSmoother.visible = false;
			this.southWestSmoother.visible = false;
			this.northEastSmoother.visible = false;
			this.southEastSmoother.visible = false;
			
			var neighboringWires:Array = []; //See above
			var currentTile:Object; //See above
			var currentBlock:Object; //See above
			var currentSubBlock:Object; //See above
			const neighboringTiles:Array = [[1, 0], [-1, 0], [0, 1], [0, -1]]; //See above
			for(var a:Number = 0; a < neighboringTiles.length; a++){ //See above
				if(!Main.stageRef.contains(Main.mapEditorUI)){ //See above
					currentTile = TileDatabase.GetTile(script.column + neighboringTiles[a][0], script.row + neighboringTiles[a][1]); //See above
					if(currentTile != null){ //See above
						if((currentTile.subOccupiedBlock != null && (currentTile.subOccupiedBlock.specialTags.indexOf("Transmitter") != -1 || currentTile.subOccupiedBlock.specialTags.indexOf("Transmitter") != -1)) || (currentTile.occupiedBlock != null && (currentTile.occupiedBlock.specialTags.indexOf("Transmitter") != -1 || currentTile.occupiedBlock.specialTags.indexOf("Transmitter") != -1))){
							neighboringWires.push(neighboringTiles[a]); //See above
							if(neighboringTiles[a][0] == 1 && ((currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.visual.RequestConnection(this, script.column, script.row, ["Transmitter"])) || (currentTile.occupiedBlock != null && currentTile.occupiedBlock.visual.RequestConnection(this, script.column, script.row, ["Transmitter"])))){
								this.connector.wireRight.visible = true;
								if(currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.specialTags.indexOf("Wire") != -1){
									connector.wireRight.gotoAndStop(BlockDatabase.wireList.indexOf(getDefinitionByName(getQualifiedClassName(currentTile.subOccupiedBlock.visual))) + 1);
								}
							}else if(neighboringTiles[a][0] == -1 && ((currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.visual.RequestConnection(this, script.column, script.row, ["Transmitter"])) || (currentTile.occupiedBlock != null && currentTile.occupiedBlock.visual.RequestConnection(this, script.column, script.row, ["Transmitter"])))){
								this.connector.wireLeft.visible = true;
								if(currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.specialTags.indexOf("Wire") != -1){
									connector.wireLeft.gotoAndStop(BlockDatabase.wireList.indexOf(getDefinitionByName(getQualifiedClassName(currentTile.subOccupiedBlock.visual))) + 1);
								}
							}else if(neighboringTiles[a][1] == -1 && ((currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.visual.RequestConnection(this, script.column, script.row, ["Transmitter"])) || (currentTile.occupiedBlock != null && currentTile.occupiedBlock.visual.RequestConnection(this, script.column, script.row, ["Transmitter"])))){
								this.connector.wireTop.visible = true;
								if(currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.specialTags.indexOf("Wire") != -1){
									connector.wireTop.gotoAndStop(BlockDatabase.wireList.indexOf(getDefinitionByName(getQualifiedClassName(currentTile.subOccupiedBlock.visual))) + 1);
								}
							}else if(neighboringTiles[a][1] == 1 && ((currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.visual.RequestConnection(this, script.column, script.row, ["Transmitter"])) || (currentTile.occupiedBlock != null && currentTile.occupiedBlock.visual.RequestConnection(this, script.column, script.row, ["Transmitter"])))){
								this.connector.wireBottom.visible = true;
								if(currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.specialTags.indexOf("Wire") != -1){
									connector.wireBottom.gotoAndStop(BlockDatabase.wireList.indexOf(getDefinitionByName(getQualifiedClassName(currentTile.subOccupiedBlock.visual))) + 1);
								}
							}else{
								neighboringWires.removeAt(neighboringWires.indexOf(neighboringTiles[a])); //See above
							}
						}
						
						if(neighboringTiles[a][0] == 1 && currentTile.occupiedBlock != null && currentTile.occupiedBlock.specialTags.indexOf("Lamp") != -1){
							this.rightBorder.visible = false;
							this.bulb.rightExtension.visible = true;
						}else if(neighboringTiles[a][0] == -1 && currentTile.occupiedBlock != null && currentTile.occupiedBlock.specialTags.indexOf("Lamp") != -1){
							this.leftBorder.visible = false;
							this.bulb.leftExtension.visible = true;
						}else if(neighboringTiles[a][1] == -1 && currentTile.occupiedBlock != null && currentTile.occupiedBlock.specialTags.indexOf("Lamp") != -1){
							this.topBorder.visible = false;
							this.bulb.topExtension.visible = true;
						}else if(neighboringTiles[a][1] == 1 && currentTile.occupiedBlock != null && currentTile.occupiedBlock.specialTags.indexOf("Lamp") != -1){
							this.bottomBorder.visible = false;
							this.bulb.bottomExtension.visible = true;
						}
						
						if(!bottomBorder.visible && !rightBorder.visible){
							if(TileDatabase.GetTile(script.column + 1, script.row + 1) != null && TileDatabase.GetTile(script.column + 1, script.row + 1).occupiedBlock != null && TileDatabase.GetTile(script.column + 1, script.row + 1).occupiedBlock.specialTags.indexOf("Lamp") != -1){
								this.bulb.southEast.visible = true;
							}
						}if(!bottomBorder.visible && !leftBorder.visible){
							if(TileDatabase.GetTile(script.column - 1, script.row + 1) != null && TileDatabase.GetTile(script.column - 1, script.row + 1).occupiedBlock != null && TileDatabase.GetTile(script.column - 1, script.row + 1).occupiedBlock.specialTags.indexOf("Lamp") != -1){
								this.bulb.southWest.visible = true;
							}
						}if(!topBorder.visible && !rightBorder.visible){
							if(TileDatabase.GetTile(script.column + 1, script.row - 1) != null && TileDatabase.GetTile(script.column + 1, script.row - 1).occupiedBlock != null && TileDatabase.GetTile(script.column + 1, script.row - 1).occupiedBlock.specialTags.indexOf("Lamp") != -1){
								this.bulb.northEast.visible = true;
							}
						}if(!topBorder.visible && !leftBorder.visible){
							if(TileDatabase.GetTile(script.column - 1, script.row - 1) != null && TileDatabase.GetTile(script.column - 1, script.row - 1).occupiedBlock != null && TileDatabase.GetTile(script.column - 1, script.row - 1).occupiedBlock.specialTags.indexOf("Lamp") != -1){
								this.bulb.northWest.visible = true;
							}
						}
					}
				}else{
					currentBlock = BlockDatabase.GetBlock(script.column + neighboringTiles[a][0], script.row + neighboringTiles[a][1]); //See above
					currentSubBlock = BlockDatabase.GetSubBlock(script.column + neighboringTiles[a][0], script.row + neighboringTiles[a][1]); //See above
					if(currentBlock != null || currentSubBlock != null){ //See above
						if((currentSubBlock != null && (currentSubBlock.specialTags.indexOf("Transmitter") != -1 || currentSubBlock.specialTags.indexOf("Transmitter") != -1)) || (currentBlock != null && (currentBlock.specialTags.indexOf("Transmitter") != -1 || currentBlock.specialTags.indexOf("Transmitter") != -1))){
							neighboringWires.push(neighboringTiles[a]); //See above
							if(neighboringTiles[a][0] == 1 && ((currentSubBlock != null && currentSubBlock.RequestConnection(this, script.column, script.row, ["Transmitter"])) || (currentBlock != null && currentBlock.RequestConnection(this, script.column, script.row, ["Transmitter"])))){
								this.connector.wireRight.visible = true;
								if(currentSubBlock != null && currentSubBlock.specialTags.indexOf("Wire") != -1){
									connector.wireRight.gotoAndStop(BlockDatabase.wireList.indexOf(getDefinitionByName(getQualifiedClassName(currentSubBlock))) + 1);
								}
							}else if(neighboringTiles[a][0] == -1 && ((currentSubBlock != null && currentSubBlock.RequestConnection(this, script.column, script.row, ["Transmitter"])) || (currentBlock != null && currentBlock.RequestConnection(this, script.column, script.row, ["Transmitter"])))){
								this.connector.wireLeft.visible = true;
								if(currentSubBlock != null && currentSubBlock.specialTags.indexOf("Wire") != -1){
									connector.wireLeft.gotoAndStop(BlockDatabase.wireList.indexOf(getDefinitionByName(getQualifiedClassName(currentSubBlock))) + 1);
								}
							}else if(neighboringTiles[a][1] == -1 && ((currentSubBlock!= null && currentSubBlock.RequestConnection(this, script.column, script.row, ["Transmitter"])) || (currentBlock != null && currentBlock.RequestConnection(this, script.column, script.row, ["Transmitter"])))){
								this.connector.wireTop.visible = true;
								if(currentSubBlock != null && currentSubBlock.specialTags.indexOf("Wire") != -1){
									connector.wireTop.gotoAndStop(BlockDatabase.wireList.indexOf(getDefinitionByName(getQualifiedClassName(currentSubBlock))) + 1);
								}
							}else if(neighboringTiles[a][1] == 1 && ((currentSubBlock != null && currentSubBlock.RequestConnection(this, script.column, script.row, ["Transmitter"])) || (currentBlock != null && currentBlock.RequestConnection(this, script.column, script.row, ["Transmitter"])))){
								this.connector.wireBottom.visible = true;
								if(currentSubBlock != null && currentSubBlock.specialTags.indexOf("Wire") != -1){
									connector.wireBottom.gotoAndStop(BlockDatabase.wireList.indexOf(getDefinitionByName(getQualifiedClassName(currentSubBlock))) + 1);
								}
							}else{
								neighboringWires.removeAt(neighboringWires.indexOf(neighboringTiles[a])); //See above
							}
						}
						
						if(neighboringTiles[a][0] == 1 && currentBlock != null && currentBlock.specialTags.indexOf("Lamp") != -1){
							this.rightBorder.visible = false;
							this.bulb.rightExtension.visible = true;
						}else if(neighboringTiles[a][0] == -1 && currentBlock != null && currentBlock.specialTags.indexOf("Lamp") != -1){
							this.leftBorder.visible = false;
							this.bulb.leftExtension.visible = true;
						}else if(neighboringTiles[a][1] == -1 && currentBlock != null && currentBlock.specialTags.indexOf("Lamp") != -1){
							this.topBorder.visible = false;
							this.bulb.topExtension.visible = true;
						}else if(neighboringTiles[a][1] == 1 && currentBlock != null && currentBlock.specialTags.indexOf("Lamp") != -1){
							this.bottomBorder.visible = false;
							this.bulb.bottomExtension.visible = true;
						}
						
						if(!bottomBorder.visible && !rightBorder.visible){
							if(BlockDatabase.GetBlock(script.column + 1, script.row + 1) != null && BlockDatabase.GetBlock(script.column + 1, script.row + 1).specialTags.indexOf("Lamp") != -1){
								this.bulb.southEast.visible = true;
							}
						}if(!bottomBorder.visible && !leftBorder.visible){
							if(BlockDatabase.GetBlock(script.column - 1, script.row + 1) != null && BlockDatabase.GetBlock(script.column - 1, script.row + 1).specialTags.indexOf("Lamp") != -1){
								this.bulb.southWest.visible = true;
							}
						}if(!topBorder.visible && !rightBorder.visible){
							if(BlockDatabase.GetBlock(script.column + 1, script.row - 1) != null && BlockDatabase.GetBlock(script.column + 1, script.row - 1).specialTags.indexOf("Lamp") != -1){
								this.bulb.northEast.visible = true;
							}
						}if(!topBorder.visible && !leftBorder.visible){
							if(BlockDatabase.GetBlock(script.column - 1, script.row - 1) != null && BlockDatabase.GetBlock(script.column - 1, script.row - 1).specialTags.indexOf("Lamp") != -1){
								this.bulb.northWest.visible = true;
							}
						}
					}
				}
				
				if(!rightBorder.visible && topBorder.visible){
					this.eastNorthCorner.visible = true;
				}else{
					this.eastNorthCorner.visible = false;
				}if(!rightBorder.visible && bottomBorder.visible){
					this.eastSouthCorner.visible = true;
				}else{
					this.eastSouthCorner.visible = false;
				}if(!leftBorder.visible && topBorder.visible){
					this.westNorthCorner.visible = true;
				}else{
					this.westNorthCorner.visible = false;
				}if(!leftBorder.visible && bottomBorder.visible){
					this.westSouthCorner.visible = true;
				}else{
					this.westSouthCorner.visible = false;
				}if(!topBorder.visible && leftBorder.visible){
					this.northWestCorner.visible = true;
				}else{
					this.northWestCorner.visible = false;
				}if(!topBorder.visible && rightBorder.visible){
					this.northEastCorner.visible = true;
				}else{
					this.northEastCorner.visible = false;
				}if(!bottomBorder.visible && leftBorder.visible){
					this.southWestCorner.visible = true;
				}else{
					this.southWestCorner.visible = false;
				}if(!bottomBorder.visible && rightBorder.visible){
					this.southEastCorner.visible = true;
				}else{
					this.southEastCorner.visible = false;
				}
				
				if(leftBorder.visible && bottomBorder.visible){
					this.powerIndicator.visible = true;
				}else{
					this.powerIndicator.visible = false;
				}
			}
			
			if(!Main.stageRef.contains(Main.mapEditorUI)){
				if(!this.bulb.northWest.visible && TileDatabase.GetTile(script.column, script.row - 1) != null && TileDatabase.GetTile(script.column, script.row - 1).occupiedBlock != null && TileDatabase.GetTile(script.column, script.row - 1).occupiedBlock.specialTags.indexOf("Lamp") != -1 && TileDatabase.GetTile(script.column - 1, script.row) != null && TileDatabase.GetTile(script.column - 1, script.row).occupiedBlock != null && TileDatabase.GetTile(script.column - 1, script.row).occupiedBlock.specialTags.indexOf("Lamp") != -1){
					this.northWestSmoother.visible = true;
				}if(!this.bulb.northEast.visible && TileDatabase.GetTile(script.column, script.row - 1) != null && TileDatabase.GetTile(script.column, script.row - 1).occupiedBlock != null && TileDatabase.GetTile(script.column, script.row - 1).occupiedBlock.specialTags.indexOf("Lamp") != -1 && TileDatabase.GetTile(script.column + 1, script.row) != null && TileDatabase.GetTile(script.column + 1, script.row).occupiedBlock != null && TileDatabase.GetTile(script.column + 1, script.row).occupiedBlock.specialTags.indexOf("Lamp") != -1){
					this.northEastSmoother.visible = true;
				}if(!this.bulb.southWest.visible && TileDatabase.GetTile(script.column, script.row + 1) != null && TileDatabase.GetTile(script.column, script.row + 1).occupiedBlock != null && TileDatabase.GetTile(script.column, script.row + 1).occupiedBlock.specialTags.indexOf("Lamp") != -1 && TileDatabase.GetTile(script.column - 1, script.row) != null && TileDatabase.GetTile(script.column - 1, script.row).occupiedBlock != null && TileDatabase.GetTile(script.column - 1, script.row).occupiedBlock.specialTags.indexOf("Lamp") != -1){
					this.southWestSmoother.visible = true;
				}if(!this.bulb.southEast.visible && TileDatabase.GetTile(script.column, script.row + 1) != null && TileDatabase.GetTile(script.column, script.row + 1).occupiedBlock != null && TileDatabase.GetTile(script.column, script.row + 1).occupiedBlock.specialTags.indexOf("Lamp") != -1 && TileDatabase.GetTile(script.column + 1, script.row) != null && TileDatabase.GetTile(script.column + 1, script.row).occupiedBlock != null && TileDatabase.GetTile(script.column + 1, script.row).occupiedBlock.specialTags.indexOf("Lamp") != -1){
					this.southEastSmoother.visible = true;
				}
			}else{
				if(!this.bulb.northWest.visible && BlockDatabase.GetBlock(script.column, script.row - 1) != null && BlockDatabase.GetBlock(script.column, script.row - 1).specialTags.indexOf("Lamp") != -1 && BlockDatabase.GetBlock(script.column - 1, script.row) != null && BlockDatabase.GetBlock(script.column - 1, script.row).specialTags.indexOf("Lamp") != -1){
					this.northWestSmoother.visible = true;
				}if(!this.bulb.northEast.visible && BlockDatabase.GetBlock(script.column, script.row - 1) != null && BlockDatabase.GetBlock(script.column, script.row - 1).specialTags.indexOf("Lamp") != -1 && BlockDatabase.GetBlock(script.column + 1, script.row) != null && BlockDatabase.GetBlock(script.column + 1, script.row).specialTags.indexOf("Lamp") != -1){
					this.northEastSmoother.visible = true;
				}if(!this.bulb.southWest.visible && BlockDatabase.GetBlock(script.column, script.row + 1) != null && BlockDatabase.GetBlock(script.column, script.row + 1).specialTags.indexOf("Lamp") != -1 && BlockDatabase.GetBlock(script.column - 1, script.row) != null && BlockDatabase.GetBlock(script.column - 1, script.row).specialTags.indexOf("Lamp") != -1){
					this.southWestSmoother.visible = true;
				}if(!this.bulb.southEast.visible && BlockDatabase.GetBlock(script.column, script.row + 1) != null && BlockDatabase.GetBlock(script.column, script.row + 1).specialTags.indexOf("Lamp") != -1 && BlockDatabase.GetBlock(script.column + 1, script.row) != null && BlockDatabase.GetBlock(script.column + 1, script.row).specialTags.indexOf("Lamp") != -1){
					this.southEastSmoother.visible = true;
				}
			}
		}
		
		public function RequestConnection(requester, column, row, connectionRole):Boolean{
			if(connectionRole.indexOf("Receiver") != -1){
				return true;
			}else{
				return false;
			}
		}
		
		public function EditorDelete(){
			
		}

	}	
}