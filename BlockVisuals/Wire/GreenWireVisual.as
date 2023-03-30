package BlockVisuals.Wire{
	import flash.display.MovieClip;
	
	public class GreenWireVisual extends MovieClip{
		public var script:Object;
		public const specialTags = ["Receiver", "Transmitter", "Wire", "Green"];
		
		public function GreenWireVisual(inputtedScript):void{ //Sets the block coordinates
			script = inputtedScript; //See above
			this.x = (script.column * TileDatabase.tileSize) + 0.5*(64-this.width); //See above
			this.y = (script.row * TileDatabase.tileSize) + 0.5*(64-this.height); //See above
			this.gotoAndStop(1); //See above
			
			this.wireRight.gotoAndStop(3);
			this.wireLeft.gotoAndStop(3);
			this.wireTop.gotoAndStop(3);
			this.wireBottom.gotoAndStop(3);
			this.base.gotoAndStop(3);
			
			this.wireRight.visible = false;
			this.wireLeft.visible = false;
			this.wireTop.visible = false;
			this.wireBottom.visible = false;
			this.rightBlocker.visible = true;
			this.leftBlocker.visible = true;
			this.topBlocker.visible = true;
			this.bottomBlocker.visible = true;
		}
		
		public function VisualUpdate():void{ //Updates the wire visuals
			this.wireRight.visible = false;
			this.wireLeft.visible = false;
			this.wireTop.visible = false;
			this.wireBottom.visible = false;
			this.rightBlocker.visible = true;
			this.leftBlocker.visible = true;
			this.topBlocker.visible = true;
			this.bottomBlocker.visible = true;
			
			var neighboringWires:Array = []; //See above
			var currentTile:Object; //See above
			var currentBlock:Object; //See above
			var currentSubBlock:Object; //See above
			const neighboringTiles:Array = [[1, 0], [-1, 0], [0, 1], [0, -1]]; //See above
			for(var a:Number = 0; a < neighboringTiles.length; a++){ //See above
				if(!Main.stageRef.contains(Main.mapEditorUI)){ //See above
					currentTile = TileDatabase.GetTile(script.column + neighboringTiles[a][0], script.row + neighboringTiles[a][1]); //See above
					if(currentTile != null){ //See above
						if((currentTile.subOccupiedBlock != null && (currentTile.subOccupiedBlock.specialTags.indexOf("Wire") == -1 || currentTile.subOccupiedBlock.specialTags.indexOf("Green") != -1) && (currentTile.subOccupiedBlock.specialTags.indexOf("Receiver") != -1 || currentTile.subOccupiedBlock.specialTags.indexOf("Transmitter") != -1)) || (currentTile.occupiedBlock != null && (currentTile.occupiedBlock.specialTags.indexOf("Wire") == -1 || currentTile.occupiedBlock.specialTags.indexOf("Green") != -1) && (currentTile.occupiedBlock.specialTags.indexOf("Receiver") != -1 || currentTile.occupiedBlock.specialTags.indexOf("Transmitter") != -1))){
							neighboringWires.push(neighboringTiles[a]); //See above
							if(neighboringTiles[a][0] == 1 && ((currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.visual.RequestConnection(this, script.column, script.row, ["Transmitter", "Receiver"])) || (currentTile.occupiedBlock != null && currentTile.occupiedBlock.visual.RequestConnection(this, script.column, script.row, ["Transmitter", "Receiver"])))){
								this.wireRight.visible = true;
								this.rightBlocker.visible = false;
							}else if(neighboringTiles[a][0] == -1 && ((currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.visual.RequestConnection(this, script.column, script.row, ["Transmitter", "Receiver"])) || (currentTile.occupiedBlock != null && currentTile.occupiedBlock.visual.RequestConnection(this, script.column, script.row, ["Transmitter", "Receiver"])))){
								this.wireLeft.visible = true;
								this.leftBlocker.visible = false;
							}else if(neighboringTiles[a][1] == -1 && ((currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.visual.RequestConnection(this, script.column, script.row, ["Transmitter", "Receiver"])) || (currentTile.occupiedBlock != null && currentTile.occupiedBlock.visual.RequestConnection(this, script.column, script.row, ["Transmitter", "Receiver"])))){
								this.wireTop.visible = true;
								this.topBlocker.visible = false;
							}else if(neighboringTiles[a][1] == 1 && ((currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.visual.RequestConnection(this, script.column, script.row, ["Transmitter", "Receiver"])) || (currentTile.occupiedBlock != null && currentTile.occupiedBlock.visual.RequestConnection(this, script.column, script.row, ["Transmitter", "Receiver"])))){
								this.wireBottom.visible = true;
								this.bottomBlocker.visible = false;
							}else{
								neighboringWires.removeAt(neighboringWires.indexOf(neighboringTiles[a])); //See above
							}
						}
					}
				}else{
					currentBlock = BlockDatabase.GetBlock(script.column + neighboringTiles[a][0], script.row + neighboringTiles[a][1]); //See above
					currentSubBlock = BlockDatabase.GetSubBlock(script.column + neighboringTiles[a][0], script.row + neighboringTiles[a][1]); //See above
					if(currentBlock != null || currentSubBlock != null){ //See above
						if((currentSubBlock != null && (currentSubBlock.specialTags.indexOf("Wire") == -1 || currentSubBlock.specialTags.indexOf("Green") != -1) && (currentSubBlock.specialTags.indexOf("Receiver") != -1 || currentSubBlock.specialTags.indexOf("Transmitter") != -1)) || (currentBlock != null && (currentBlock.specialTags.indexOf("Wire") == -1 || currentBlock.specialTags.indexOf("Green") != -1) && (currentBlock.specialTags.indexOf("Receiver") != -1 || currentBlock.specialTags.indexOf("Transmitter") != -1))){
							neighboringWires.push(neighboringTiles[a]); //See above
							if(neighboringTiles[a][0] == 1 && ((currentSubBlock != null && currentSubBlock.RequestConnection(this, script.column, script.row, ["Transmitter", "Receiver"])) || (currentBlock != null && currentBlock.RequestConnection(this, script.column, script.row, ["Transmitter", "Receiver"])))){
								this.wireRight.visible = true;
								this.rightBlocker.visible = false;
							}else if(neighboringTiles[a][0] == -1 && ((currentSubBlock != null && currentSubBlock.RequestConnection(this, script.column, script.row, ["Transmitter", "Receiver"])) || (currentBlock != null && currentBlock.RequestConnection(this, script.column, script.row, ["Transmitter", "Receiver"])))){
								this.wireLeft.visible = true;
								this.leftBlocker.visible = false;
							}else if(neighboringTiles[a][1] == -1 && ((currentSubBlock!= null && currentSubBlock.RequestConnection(this, script.column, script.row, ["Transmitter", "Receiver"])) || (currentBlock != null && currentBlock.RequestConnection(this, script.column, script.row, ["Transmitter", "Receiver"])))){
								this.wireTop.visible = true;
								this.topBlocker.visible = false;
							}else if(neighboringTiles[a][1] == 1 && ((currentSubBlock != null && currentSubBlock.RequestConnection(this, script.column, script.row, ["Transmitter", "Receiver"])) || (currentBlock != null && currentBlock.RequestConnection(this, script.column, script.row, ["Transmitter", "Receiver"])))){
								this.wireBottom.visible = true;
								this.bottomBlocker.visible = false;
							}else{
								neighboringWires.removeAt(neighboringWires.indexOf(neighboringTiles[a])); //See above
							}
						}
					}
				}
			}
		}
		
		public function RequestConnection(requester, column, row, connectionRole):Boolean{
			if(requester.specialTags.indexOf("Wire") == -1 || requester.specialTags.indexOf("Green") != -1){
				return true;
			}else{
				return false;
			}
		}
		
		public function EditorDelete(){
			
		}

	}	
}