package BlockVisuals{
	import flash.display.MovieClip;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	
	public class PressurePlateVisual extends MovieClip{
		public var script:Object;
		public const specialTags = ["Transmitter"];
		
		public function PressurePlateVisual(inputtedScript):void{ //Sets the block coordinates
			script = inputtedScript
			this.x = (script.column * TileDatabase.tileSize) + 0.5*(64-this.width); //See above
			this.y = (script.row * TileDatabase.tileSize) + (64-this.height); //See above
			this.gotoAndStop(1); //See above
			this.connector.visible = false;
			
			this.connector.wireRight.gotoAndStop(1);
			this.connector.wireLeft.gotoAndStop(1);
			this.connector.wireTop.gotoAndStop(1);
			this.connector.wireBottom.gotoAndStop(1);
		}
		
		public function VisualUpdate():void{ //Updates the pressure plate's visuals
			this.connector.wireRight.visible = false;
			this.connector.rightBlocker.visible = true;
			this.connector.wireLeft.visible = false;
			this.connector.leftBlocker.visible = true;
			this.connector.wireTop.visible = false;
			this.connector.topBlocker.visible = true;
			
			var neighboringWires:Array = []; //See above
			var currentTile:Object; //See above
			var currentBlock:Object; //See above
			var currentSubBlock:Object; //See above
			const neighboringTiles:Array = [[1, 0], [-1, 0], [0, 1], [0, -1]]; //See above
			for(var a:Number = 0; a < neighboringTiles.length; a++){ //See above
				if(!Main.stageRef.contains(Main.mapEditorUI)){ //See above
					currentTile = TileDatabase.GetTile(script.column + neighboringTiles[a][0], script.row + neighboringTiles[a][1]); //See above
					if(currentTile != null){ //See above
						if((currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.specialTags.indexOf("Receiver") != -1) || (currentTile.occupiedBlock != null && currentTile.occupiedBlock.specialTags.indexOf("Receiver") != -1)){
							neighboringWires.push(neighboringTiles[a]); //See above
							if(neighboringTiles[a][0] == 1 && ((currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.visual.RequestConnection(this, script.column, script.row, ["Receiver"])) || (currentTile.occupiedBlock != null && currentTile.occupiedBlock.visual.RequestConnection(this, script.column, script.row, ["Receiver"])))){
								this.connector.wireRight.visible = true;
								this.connector.rightBlocker.visible = false;
								if(currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.specialTags.indexOf("Wire") != -1){
									this.connector.wireRight.gotoAndStop(BlockDatabase.wireList.indexOf(getDefinitionByName(getQualifiedClassName(currentTile.subOccupiedBlock.visual))) + 1);
								}
							}else if(neighboringTiles[a][0] == -1 && ((currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.visual.RequestConnection(this, script.column, script.row, ["Receiver"])) || (currentTile.occupiedBlock != null && currentTile.occupiedBlock.visual.RequestConnection(this, script.column, script.row, ["Receiver"])))){
								this.connector.wireLeft.visible = true;
								this.connector.leftBlocker.visible = false;
								if(currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.specialTags.indexOf("Wire") != -1){
									this.connector.wireLeft.gotoAndStop(BlockDatabase.wireList.indexOf(getDefinitionByName(getQualifiedClassName(currentTile.subOccupiedBlock.visual))) + 1);
								}
							}else if(neighboringTiles[a][1] == -1 && ((currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.visual.RequestConnection(this, script.column, script.row, ["Receiver"])) || (currentTile.occupiedBlock != null && currentTile.occupiedBlock.visual.RequestConnection(this, script.column, script.row, ["Receiver"])))){
								this.connector.wireTop.visible = true;
								this.connector.topBlocker.visible = false;
								if(currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.specialTags.indexOf("Wire") != -1){
									this.connector.wireTop.gotoAndStop(BlockDatabase.wireList.indexOf(getDefinitionByName(getQualifiedClassName(currentTile.subOccupiedBlock.visual))) + 1);
								}
							}else{
								neighboringWires.removeAt(neighboringWires.indexOf(neighboringTiles[a])); //See above
							}
						}
					}
				}else{
					currentBlock = BlockDatabase.GetBlock(script.column + neighboringTiles[a][0], script.row + neighboringTiles[a][1]); //See above
					currentSubBlock = BlockDatabase.GetSubBlock(script.column + neighboringTiles[a][0], script.row + neighboringTiles[a][1]); //See above
					if(currentBlock != null || currentSubBlock != null){ //See above
						if((currentSubBlock != null && (currentSubBlock.specialTags.indexOf("Receiver") != -1 || currentSubBlock.specialTags.indexOf("Transmitter") != -1)) || (currentBlock != null && (currentBlock.specialTags.indexOf("Receiver") != -1 || currentBlock.specialTags.indexOf("Transmitter") != -1))){
							neighboringWires.push(neighboringTiles[a]); //See above
							if(neighboringTiles[a][0] == 1 && ((currentSubBlock != null && currentSubBlock.RequestConnection(this, script.column, script.row, ["Receiver"])) || (currentBlock != null && currentBlock.RequestConnection(this, script.column, script.row, ["Receiver"])))){
								this.connector.wireRight.visible = true;
								this.connector.rightBlocker.visible = false;
								if(currentSubBlock != null && currentSubBlock.specialTags.indexOf("Wire") != -1){
									this.connector.wireRight.gotoAndStop(BlockDatabase.wireList.indexOf(getDefinitionByName(getQualifiedClassName(currentSubBlock))) + 1);
								}
							}else if(neighboringTiles[a][0] == -1 && ((currentSubBlock != null && currentSubBlock.RequestConnection(this, script.column, script.row, ["Receiver"])) || (currentBlock != null && currentBlock.RequestConnection(this, script.column, script.row, ["Receiver"])))){
								this.connector.wireLeft.visible = true;
								this.connector.leftBlocker.visible = false;
								if(currentSubBlock != null && currentSubBlock.specialTags.indexOf("Wire") != -1){
									this.connector.wireLeft.gotoAndStop(BlockDatabase.wireList.indexOf(getDefinitionByName(getQualifiedClassName(currentSubBlock))) + 1);
								}
							}else if(neighboringTiles[a][1] == -1 && ((currentSubBlock!= null && currentSubBlock.RequestConnection(this, script.column, script.row, ["Receiver"])) || (currentBlock != null && currentBlock.RequestConnection(this, script.column, script.row, ["Receiver"])))){
								this.connector.wireTop.visible = true;
								this.connector.topBlocker.visible = false;
								if(currentSubBlock != null && currentSubBlock.specialTags.indexOf("Wire") != -1){
									this.connector.wireTop.gotoAndStop(BlockDatabase.wireList.indexOf(getDefinitionByName(getQualifiedClassName(currentSubBlock))) + 1);
								}
							}else{
								neighboringWires.removeAt(neighboringWires.indexOf(neighboringTiles[a])); //See above
							}
						}
					}
				}
			}
			
			if(neighboringWires.length == 0 || (neighboringWires.length == 1 && neighboringWires[0][1] == 1)){
				this.connector.visible = false;
			}else{
				this.connector.visible = true;
			}
		}
		
		public function RequestConnection(requester, column, row, connectionRole):Boolean{
			if(connectionRole.indexOf("Transmitter") != -1){
				return true;
			}else{
				return false;
			}
		}
		
		public function EditorDelete(){
			
		}

	}	
}